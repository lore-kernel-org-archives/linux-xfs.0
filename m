Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 654727F37
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 17:55:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 42836304032
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 15:55:50 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	HL8fYRRbpG6uSTB3 for <xfs@oss.sgi.com>;
	Sun, 23 Jun 2013 15:55:48 -0700 (PDT)
Date: Mon, 24 Jun 2013 08:55:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: LVM + XFS + external log + snapshots
Message-ID: <20130623225546.GB29376@dastard>
References: <022467CC-8EB2-41E9-8AF6-46F781882F6B@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <022467CC-8EB2-41E9-8AF6-46F781882F6B@gmail.com>
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
To: aurfalien <aurfalien@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 21, 2013 at 10:30:31PM -0700, aurfalien wrote:
> Hi all,
> 
> So I have an XFS file system within LVM  which has an external log.
> 
> My mount option in FSTAB is;
> 
> /dev/vg_spock_data/lv_data	/data	xfs	logdev=/dev/sdc1,nobarrier,logbufs=8,noatime,nodiratime	1 1
> 
> All is well no issues and very fast.
> 
> Now I'd like to snapshot this bad boy and then run rsnapshot to create a few days backup.

You need to snapshot the log device as well.

But that is problematic in that you need to snapshot it at the same
time you snapshot the data volume. Hence yo'd have to do:

# xfs_freeze -f <filesystem>
# <snapshot data volume>
# <snapshot log volume>
# xfs_freeze -u <filesystem>

And now you can mount the snapshot with:

# mount /dev/vg_spock_data/datasnapshot /snapshot -o nouuid,ro,logdev=/dev/vg_spock_log/logsnapshot

If you can't snapshot the log device, then you can't snapshot the
filesystem. Yet another reason for using internal logs...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
