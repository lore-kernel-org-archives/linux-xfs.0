Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 376C37F37
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 18:24:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F32F38F8035
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 16:24:41 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id WtUMc46vmuuwlR2X for <xfs@oss.sgi.com>;
	Sun, 23 Jun 2013 16:24:40 -0700 (PDT)
Message-ID: <51C783B7.2040502@sandeen.net>
Date: Sun, 23 Jun 2013 18:24:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: LVM + XFS + external log + snapshots
References: <022467CC-8EB2-41E9-8AF6-46F781882F6B@gmail.com>
	<20130623225546.GB29376@dastard>
In-Reply-To: <20130623225546.GB29376@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, aurfalien <aurfalien@gmail.com>

On 6/23/13 5:55 PM, Dave Chinner wrote:
> On Fri, Jun 21, 2013 at 10:30:31PM -0700, aurfalien wrote:
>> Hi all,
>>
>> So I have an XFS file system within LVM  which has an external log.
>>
>> My mount option in FSTAB is;
>>
>> /dev/vg_spock_data/lv_data	/data	xfs	logdev=/dev/sdc1,nobarrier,logbufs=8,noatime,nodiratime	1 1
>>
>> All is well no issues and very fast.
>>
>> Now I'd like to snapshot this bad boy and then run rsnapshot to create a few days backup.
> 
> You need to snapshot the log device as well.
> 
> But that is problematic in that you need to snapshot it at the same
> time you snapshot the data volume. Hence yo'd have to do:
> 
> # xfs_freeze -f <filesystem>
> # <snapshot data volume>
> # <snapshot log volume>
> # xfs_freeze -u <filesystem>
> 
> And now you can mount the snapshot with:
> 
> # mount /dev/vg_spock_data/datasnapshot /snapshot -o nouuid,ro,logdev=/dev/vg_spock_log/logsnapshot
> 
> If you can't snapshot the log device, then you can't snapshot the
> filesystem. Yet another reason for using internal logs...

Hm, given that freezing the fs makes the log (almost) completely clean, I wonder
if he could mount with /dev/zero (or a loopback 0-filled file) to get at the snapshot,
especially since it's being mounted RO.

Should be safe & consistent, no?

i.e.

truncate --size=2g logfile (or however big it needs to be)
losetup /dev/loop0 logfile
mount /dev/vg_anette_data/datasnapshot /snapshot -o logdev=/dev/loop0,nouuid,ro

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
