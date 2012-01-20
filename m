Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0KC6hQv102374 for <xfs@oss.sgi.com>; Fri, 20 Jan 2012 06:06:43 -0600
Received: from honeysuckle.london.02.net (honeysuckle.london.02.net
	[87.194.255.144]) by cuda.sgi.com with ESMTP id
	YmsZTS5TqPbhiV2F for <xfs@oss.sgi.com>;
	Fri, 20 Jan 2012 04:06:39 -0800 (PST)
Received: from ty.sabi.co.UK (87.194.99.40) by honeysuckle.london.02.net
	(8.5.140)
	id 4EEF52D2008B2074 for xfs@oss.sgi.com; Fri, 20 Jan 2012 12:06:37 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1RoDEl-0004HT-Fy
	for <xfs@oss.sgi.com>; Fri, 20 Jan 2012 12:06:31 +0000
MIME-Version: 1.0
Message-ID: <20249.22727.359884.733592@tree.ty.sabi.co.UK>
Date: Fri, 20 Jan 2012 12:06:31 +0000
Subject: Re: Optimal XFS formatting options?
In-Reply-To: <4F192DEC.4030400@tlinx.org>
References: <33140169.post@talk.nabble.com>
	<20242.10382.19330.275280@tree.ty.sabi.co.UK>
	<4F192DEC.4030400@tlinx.org>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux fs XFS <xfs@oss.sgi.com>

[ ... ]
>> * XFS has several limitations on 32b kernels. Just make sure
>>   you have a 64b kernel.
[ ... ]
> I was unaware that the block size was larger on 64b kernels.
> Is that what you are referring to ? (would be nice)...

Not as such, the maximum block size is limited by the Linux page
cache, that is hw page size, which is for IA32 and AMD64
architectures the same at 4KiB. However other architectures
which are natively 64b allow bigger page sizes (notably IA64
[aka Itanium]), so the page cache and thus XFS can do larger
blocks sizes.

The limitations of XFS on 32b kernels come from limitations of
XFS itself in 32b mode, limitations of Linux in 32b mode, and
combined limitations. For example:

  * There be 32b inode numbers, which limit inodes to the first
    1TB of a filetree if sector size is 512B.

  * The 32b block IO subsystems limits partition sizes to 16TiB.

  * XFS tools scanning a large filesystem, usually for repair,
    can run out of the available 32b address space (by default
    around 2GiB).

Page 5 and 6 here list some limits:

  http://oss.sgi.com/projects/xfs/training/xfs_slides_02_overview.pdf

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
