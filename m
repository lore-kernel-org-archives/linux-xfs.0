Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C22AB7F56
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 10:02:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A3376304039
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 08:02:49 -0700 (PDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24]) by
	cuda.sgi.com with ESMTP id GU1pOlLQVjNfpR9o (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Jun 2014 08:02:47 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Date: Mon, 02 Jun 2014 17:01:20 +0200
Message-ID: <5896675.3VErDJM7s2@wuerfel>
In-Reply-To: <20140602130700.GC14276@thunk.org>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<15496653.1vSv1RUCC0@wuerfel> <20140602130700.GC14276@thunk.org>
MIME-Version: 1.0
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, lftan@altera.com, hch@infradead.org, john.stultz@linaro.org, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, geert@linux-m68k.org, tglx@linutronix.de, xfs@oss.sgi.com, joseph@codesourcery.com

On Monday 02 June 2014 09:07:00 Theodore Ts'o wrote:
> Yes, there are some ongoing dicussions about changing the post-2038
> encoding of the timestamp in ext4, which is why this hasn't been fixed
> yet.  The main thing that's been missing is time for me to review the
> patches, and a good way of writing regression tests that will work (or
> at least not fail) on build environments with a 32-bit time_t and
> 32-bit-only capable versions of functions such as gmtime(3).
> 
> And given current discussions, I may want to think about some kind of
> superblock flag to allow the use of a 32-bit unsigned encoding for
> file systems using a 128-byte inode, with a way of setting that flag
> after scanning the file system to make sure there are no times that
> are previous to January 1, 1970.  (Or more generally, allow any epoch
> to be defined using a 64-bit time_t offset stored in the superblock...)

FWIW, I've gone through the other file system implementations once
more. The most common pattern I've encountered is to have a read_inode
function with

	inode->i_mtime = le32_to_cpu(raw_inode->mtime);

which results in interpreting the time as 'signed' on 32-bit
kernels, but as 'unsigned' on 64-bit kernels. This could have been
done intentionally to extend the valid time range to 2106 on 64-bit
kernels, but it seems more likely that the code was written with
no thought given to 64-bit time_t at all. I see this pattern on
p9fs (old protocol only), afs, bfs, ceph, efs, freevxfs, hpfs, jffs2,
jfs, minix, nfsv2/v3 (this was clearly intentional and is
spelled out in the RFC), qnx4, qnx6, reiserfs, squashfs, sysv,
and ufs (protocol version 1 only).

The other behavior I see is to treat the on-disk 32-bit value
as signed on both 32-bit and 64-bit kernels:

	inode->i_mtime = (signed)le32_to_cpu(raw_inode->mtime);

this seems to be done intentionally in all cases, to maintain
compatibility between 32-bit and 64-bit kernels, but it's
relatively rare: exofs, ext2/3/4 (good old inodes) and xfs
are the only ones doing this.

In case of ext2/3/4, the sign handlign was introduced here:
http://www.spinics.net/lists/linux-ext4/msg01758.html

exofs and xfs seem to have done it like this for all of git
history.

	Arnd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
