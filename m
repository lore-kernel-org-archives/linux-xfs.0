Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q215xn5V082096 for <xfs@oss.sgi.com>; Wed, 29 Feb 2012 23:59:50 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	PQoBMaOHhFN5Ga6G (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Feb 2012 21:59:48 -0800 (PST)
Date: Thu, 1 Mar 2012 00:59:43 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Poor performance using discard
Message-ID: <20120301055943.GA23051@infradead.org>
References: <1330469778.9688.7.camel@core24> <20120229012259.GW3592@dastard>
	<1330480826.9688.23.camel@core24> <20120229040819.GZ3592@dastard>
	<4F4E809A.40308@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F4E809A.40308@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Thomas Lynema <lyz27@yahoo.com>, xfs@oss.sgi.com

On Wed, Feb 29, 2012 at 01:46:34PM -0600, Eric Sandeen wrote:
> On 2/28/12 10:08 PM, Dave Chinner wrote:
> 
> > Also, I think you need to provide a block trace (output of
> > blktrace/blkparse for the rm -rf workloads) for both the XFS and
> > ext4 cases so we can see what discards are actually being issued and
> > how long they take to complete....
> > 
> 
> I ran a quick test on a loopback device on 3.3.0-rc4.  Loopback supports
> discards.  I made 1G filesystems on loopback on ext4 & xfs, mounted with
> -o discard, cloned a git tree to them, and ran rm -rf; sync under blktrace.
> 
> XFS took about 11 seconds, ext4 took about 1.7.
> 
> (without trim, times were roughly the same - but discard/trim is probably
> quite fast on the looback file)
> 
> Both files were reduced in disk usage about the same amount, so online
> discard was working for both:
> 
> # du -h ext4_fsfile xfs_fsfile
> 497M	ext4_fsfile
> 491M	xfs_fsfile
> 
> XFS issued many more discards than ext4:

XFS frees inode blocks, directory blocks and btree blocks.  ext4 only
ever frees data blocks and the occasional indirect block on files.

So a proper discard implementation on XFS without either a reall fast
non-blocking and/or vectored trim (like actually supported in hardware)
XFS will be fairly slow.

Unfortunately all the required bits are missing in the Linux block
layer, thus you really should use fstrim for now. 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
