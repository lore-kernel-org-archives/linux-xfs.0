Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAM96hYk209949 for <xfs@oss.sgi.com>; Mon, 22 Nov 2010 03:06:44 -0600
Received: from mail.ims.co.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8D2D1989DF
	for <xfs@oss.sgi.com>; Mon, 22 Nov 2010 01:05:33 -0800 (PST)
Received: from mail.ims.co.at (mail.ims.co.at [81.223.138.19]) by cuda.sgi.com
	with ESMTP id JIseD0Bnc31VT6Az for <xfs@oss.sgi.com>;
	Mon, 22 Nov 2010 01:05:33 -0800 (PST)
Date: Mon, 22 Nov 2010 10:05:27 +0100
From: Samuel Kvasnica <samuel.kvasnica@ims.co.at>
Message-ID: <4CEA3257.6090309@ims.co.at>
In-Reply-To: <20101122003754.GE13830@dastard>
References: <20101119133848.GA5471@infradead.org>
References: <20101122003754.GE13830@dastard>
Subject: Re: [PATCH] xfs: fix exporting with left over 64-bit inodes
MIME-Version: 1.0
Content-Disposition: inline
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com


On 11/22/2010 01:37 AM, Dave Chinner wrote:
> On Fri, Nov 19, 2010 at 08:38:49AM -0500, Christoph Hellwig wrote:
>> From: Samuel Kvasnica <samuel.kvasnica@ims.co.at>
>>
>> We now support mounting and using filesystems with 64-bit inodes even
>> when not mounted with the inode64 option (which now only controls if
>> we allocate new inodes in that space or not).  Make sure we always
>> use large NFS file handles when exporting a filesystem that may contain
>> 64-bit inodes.  Note that this only affects newly generated file handles,
>> any outstanding 32-bit file handle is still accepted.
>>
>> [hch: the comment and commit log are mine, the rest is from a patch
>>  snipplet from Samuel]
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Won't this mean that people exporting non-root directories suddenly
> have those exports stop working on a kernel upgrade due to changing
> the handle format?
>
> Cheers,
>
> Dave.
Hello Dave,

nothing is really changing, it is a bugfix. NFS was trying to use 32bit
inodes which was incorrect (i.e. broken at client) for xfs filesystem
containing 64bit inodes in one special case. This is fixed now.

regards,

Sam


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
