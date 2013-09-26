Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6BC9A7F5A
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 07:06:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F0280AC002
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 05:06:30 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id isklaCwlWWCg5qBJ
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 05:06:30 -0700 (PDT)
Message-ID: <5244234D.1010603@hardwarefreak.com>
Date: Thu, 26 Sep 2013 07:06:37 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Issues and new to the group
References: <0e4201cebaae$24873680$6d95a380$@host2max.com>
In-Reply-To: <0e4201cebaae$24873680$6d95a380$@host2max.com>
Reply-To: stan@hardwarefreak.com
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
To: Ronnie Tartar <rtartar@host2max.com>
Cc: xfs@oss.sgi.com

On 9/26/2013 6:47 AM, Ronnie Tartar wrote:

> I have a 600GB xfs file system mounted that suddenly started running slow on
> writes.  It takes about 2.5 to 3.5 seconds to write a single file.  Some

This typically occurs when the filesystem gets near full and free space
is heavily fragmented.  Writing to these free space fragments requires
lots of seeking.  Seeking causes latency.  I assume your storage device
is spinning rust, yes?

> folders (with less number of files) work well.  But it will copy fast, then
> slow for long periods of time.  

Some allocation groups may have less fragmented free space than others.
 Put another way, they may have more contiguous free space.  Thus less
seeking.

> This is a virtualized CentOS 5.9 64 bit box
> on Citrix Xenserver 5.6SP2.  Doesn't seem to be a load i/o issue as most of
> the load is system%.  My fragmentation is less than 1 %.    Any help would
> be greatly appreciated.  I was looking to see if there was a better way to
> mount this partition or allocate more memory, whatever it takes.  The
> folders are image folders that have anywhere between 5 to 10 million images
> in each folder.

> Fstab mount is: 
> /dev/xvdb1              /images xfs
> defaults,nodiratime,nosuid,nodev,allocsize=64m 1 1
                                   ^^^^^^^^^^^^^
This tells XFS to allocate 64MB of free space at the end of each file
being allocated.  If free space is heavily fragmented and the fragments
are all small, this will exacerbate the seek problem.  Given the 64MB
allocsize, I assume these image files are quite large.  If this is
correct, writing them over scattered small free space fragments also
requires seeking.  Thus, I'd guess you're seeking your disk, or array,
to death.

How full is the XFS volume, and what does your free space fragmentation
map look like?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
