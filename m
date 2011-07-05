Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p65B8r4x252684 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 06:08:54 -0500
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5FA691E58D93
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2011 04:08:53 -0700 (PDT)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id TNO7GZ7yXZCezgMu
	for <xfs@oss.sgi.com>; Tue, 05 Jul 2011 04:08:53 -0700 (PDT)
Received: from dermichi-2-pt.tunnel.tserv23.zrh1.ipv6.he.net
	([2001:470:25:4f4::2])
	by firestarter.dermichi.com with esmtpsa (TLSv1:CAMELLIA256-SHA:256)
	(Exim 4.76) (envelope-from <mw@dermichi.com>) id 1Qe3Uq-0006Ys-Id
	for xfs@oss.sgi.com; Tue, 05 Jul 2011 13:08:52 +0200
Message-ID: <4E12F0C3.7080405@dermichi.com>
Date: Tue, 05 Jul 2011 13:08:51 +0200
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: xfs_bmap Cannot allocate memory
References: <4E129B00.4020709@dermichi.com>
	<4E12E8F3.4080704@hardwarefreak.com>
In-Reply-To: <4E12E8F3.4080704@hardwarefreak.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Tue Jul 05 2011 12:35:31 GMT+0200 (CET), Stan Hoeppner
<stan@hardwarefreak.com> wrote:
> On 7/5/2011 12:02 AM, Michael Weissenbacher wrote:
> 
>> xfs_bmap: xfsctl(XFS_IOC_GETBMAPX) iflags=0x0
> 
> Googling the text above returns only 5 results, including your post
> today to this list.  Thus I doubt your problem is the result of a bug in
> XFS or xfsprogs.
> 
> Was the file being written to when you ran xfs_bmap?
No, the file has last been written 4 days ago

> If not, did you flush caches before running xfs_bmap?  Did you try
> unmounting and remounting the filesystem?  These steps are sometimes
> needed to get actual extent usage due to extents in cache that have not
> yet been written to disk.
Yes, i tried flushing the caches "echo 3 >/proc/sys/vm/drop_caches"
which didn't change anything.
I also did unmount, xfs_check (no errors reported), mount which didn't
change anything.

> What distro/kernel version?
Ubuntu Lucid 10.04.2 LTS with vanilla kernel 2.6.39.2

> What xfsprogs version?
Latest version 3.1.5, compiled from sources

> What filefrag version?
e2fsprogs 1.41.11-1ubuntu2.1

cheers,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
