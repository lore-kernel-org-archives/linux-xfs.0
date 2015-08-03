Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DC6CE7F5A
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 17:24:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 82792AC001
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 15:24:09 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	qtsHCeuygAd76IDB for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 15:24:06 -0700 (PDT)
Date: Tue, 4 Aug 2015 08:23:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: swalloc/allocsize question
Message-ID: <20150803222353.GU3902@dastard>
References: <55BFA467.8000707@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55BFA467.8000707@gmail.com>
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
To: Joe Landman <joe.landman@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 03, 2015 at 01:27:03PM -0400, Joe Landman wrote:
> Hi folks:
> 
>   I've noticed some "odd" behavior while experimenting with xfs
> mounts on relatively recent kernels (3.18 series).  Basically, the
> swalloc,allocsize=x options are being modified to something
> different.  That is:
> 
> root@usn-04:~/burn-in/fio# uname -r
> 3.18.12.scalable
> 
> root@usn-04:~/burn-in/fio# mount -o
> inode64,noatime,nodiratime,swalloc,allocsize=1280k /dev/sda /data/1
> 
> root@usn-04:~/burn-in/fio# mount | grep sda
> /dev/sda on /data/1 type xfs
> (rw,noatime,nodiratime,swalloc,attr2,inode64,allocsize=256k,noquota)
> 
> This is a hardware RAID6 with a 128k chunk size and 12 elements (so
> 10 data drives, thus the 1280k allocsize for stripe width
> allocation).  Is this something specific to xfs itself, or is this
> an issue in the mount tools ?

Please provide:

	- xfs_info output from the filesystem in question
	- dmesg output of all the mount messages

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
