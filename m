Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CF3D27F37
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 19:33:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BD1D98F8033
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 17:33:24 -0700 (PDT)
Received: from mail-yh0-f51.google.com (mail-yh0-f51.google.com
	[209.85.213.51]) by cuda.sgi.com with ESMTP id dLw4ee3JsfoZdBVw
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 23 Jun 2013 17:33:23 -0700 (PDT)
Received: by mail-yh0-f51.google.com with SMTP id l109so4648502yhq.24
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 17:33:23 -0700 (PDT)
Subject: Re: LVM + XFS + external log + snapshots
Mime-Version: 1.0 (Apple Message framework v1085)
From: aurfalien <aurfalien@gmail.com>
In-Reply-To: <51C783B7.2040502@sandeen.net>
Date: Sun, 23 Jun 2013 17:33:18 -0700
Message-Id: <146D25D8-F1F5-424C-9DCF-775AE770748F@gmail.com>
References: <022467CC-8EB2-41E9-8AF6-46F781882F6B@gmail.com>
	<20130623225546.GB29376@dastard> <51C783B7.2040502@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com


On Jun 23, 2013, at 4:24 PM, Eric Sandeen wrote:

> On 6/23/13 5:55 PM, Dave Chinner wrote:
>> On Fri, Jun 21, 2013 at 10:30:31PM -0700, aurfalien wrote:
>>> Hi all,
>>> 
>>> So I have an XFS file system within LVM  which has an external log.
>>> 
>>> My mount option in FSTAB is;
>>> 
>>> /dev/vg_spock_data/lv_data	/data	xfs	logdev=/dev/sdc1,nobarrier,logbufs=8,noatime,nodiratime	1 1
>>> 
>>> All is well no issues and very fast.
>>> 
>>> Now I'd like to snapshot this bad boy and then run rsnapshot to create a few days backup.
>> 
>> You need to snapshot the log device as well.
>> 
>> But that is problematic in that you need to snapshot it at the same
>> time you snapshot the data volume. Hence yo'd have to do:
>> 
>> # xfs_freeze -f <filesystem>
>> # <snapshot data volume>
>> # <snapshot log volume>
>> # xfs_freeze -u <filesystem>
>> 
>> And now you can mount the snapshot with:
>> 
>> # mount /dev/vg_spock_data/datasnapshot /snapshot -o nouuid,ro,logdev=/dev/vg_spock_log/logsnapshot
>> 
>> If you can't snapshot the log device, then you can't snapshot the
>> filesystem. Yet another reason for using internal logs...
> 
> Hm, given that freezing the fs makes the log (almost) completely clean, I wonder
> if he could mount with /dev/zero (or a loopback 0-filled file) to get at the snapshot,
> especially since it's being mounted RO.
> 
> Should be safe & consistent, no?
> 
> i.e.
> 
> truncate --size=2g logfile (or however big it needs to be)
> losetup /dev/loop0 logfile
> mount /dev/vg_anette_data/datasnapshot /snapshot -o logdev=/dev/loop0,nouuid,ro
> 
> -Eric

I'll try it and let you know.

Should be interesting.

- aurf
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
