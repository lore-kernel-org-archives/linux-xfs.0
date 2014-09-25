Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1834A7FAF
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 10:21:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9C41EAC003
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 08:21:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DItW6nT0vAJDjicl (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 08:21:50 -0700 (PDT)
Date: Thu, 25 Sep 2014 11:21:45 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: flush the range before zero range conversion
Message-ID: <20140925152145.GD47304@bfoster.bfoster>
References: <1411585591-55975-1-git-send-email-bfoster@redhat.com>
	<20140925120155.GF4945@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140925120155.GF4945@dastard>
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
Cc: xfs@oss.sgi.com

On Thu, Sep 25, 2014 at 10:01:55PM +1000, Dave Chinner wrote:
> On Wed, Sep 24, 2014 at 03:06:31PM -0400, Brian Foster wrote:
> > XFS currently discards delalloc blocks within the target range of a zero
> > range request. Unaligned start and end offsets are zeroed through the
> > page cache and the internal, aligned blocks are converted to unwritten
> > extents.
> > 
> > If EOF is page aligned and covered by a delayed allocation extent. The
> > inode size is not updated until I/O completion. If a zero range request
> > discards a delalloc range that covers page aligned EOF as such, the
> > inode size update never occurs. For example:
> > 
> > $ rm -f /mnt/file
> > $ xfs_io -fc "pwrite 0 64k" -c "zero 60k 4k" /mnt/file
> > $ stat -c "%s" /mnt/file
> > 65536
> > $ umount /mnt
> > $ mount <dev> /mnt
> > $ stat -c "%s" /mnt/file
> > 61440
> > 
> > Update xfs_zero_file_space() to flush the range rather than discard
> > delalloc blocks to ensure that inode size updates occur appropriately.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > I suppose we could be more clever here and only flush the range in this
> > particular scenario, but I'm not sure if there's a major benefit there.
> 
> Punching the delalloc range rather than flushing the file
> was done intentionally - this was added primarily for speeding up
> the zeroing of large VM image files. i.e. it's an extent
> manipulation operation rather than a data Io operation. Flushing the
> file defeats the primary reason for the operation existing.
> 
> We can easily detect this situation and just zero the last block in
> the file directly after punching out all the delalloc state. This
> should happen anyway when the region to be zeroed is not page
> aligned....
> 

Hmm, good point. xfs_iozero() goes through page cache. It seems like
that should work and it's something we already have to handle in this
path. I'll give it a shot.

Brian

> > FWIW, this implicitly addresses the indlen==0 assert failures described
> > in the xfs_bmap_del_extent() rfc, but doesn't necessarily mean we
> > shouldn't fix that code IMO.
> 
> We punch delalloc extents elsewhere, so that still needs fixing.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
