Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 35C0E7F3F
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 16:23:55 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BFF0FAC009
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 14:23:51 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	rV0GlaoNC76yzAAu for <xfs@oss.sgi.com>;
	Fri, 28 Feb 2014 14:23:49 -0800 (PST)
Date: Sat, 1 Mar 2014 09:20:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: avoid AGI/AGF deadlock scenario for inode chunk
	allocation
Message-ID: <20140228222048.GD13647@dastard>
References: <1392142066-16174-1-git-send-email-bfoster@redhat.com>
	<20140228192418.GB15562@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140228192418.GB15562@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Feb 28, 2014 at 02:24:18PM -0500, Brian Foster wrote:
> On Tue, Feb 11, 2014 at 01:07:46PM -0500, Brian Foster wrote:
> > The inode chunk allocation path can lead to deadlock conditions if
> > a transaction is dirtied with an AGF (to fix up the freelist) for
> > an AG that cannot satisfy the actual allocation request. This code
> > path is written to try and avoid this scenario, but it can be
> > reproduced by running xfstests generic/270 in a loop on a 512b fs.
> > 
> > An example situation is:
> > - process A attempts an inode allocation on AG 3, modifies
> >   the freelist, fails the allocation and ultimately moves on to
> >   AG 0 with the AG 3 AGF held
> > - process B is doing a free space operation (i.e., truncate) and
> >   acquires the AG 0 AGF, waits on the AG 3 AGF
> > - process A acquires the AG 0 AGI, waits on the AG 0 AGF (deadlock)
> > 
> > The problem here is that process A acquired the AG 3 AGF while
> > moving on to AG 0 (and releasing the AG 3 AGI with the AG 3 AGF
> > held). xfs_dialloc() makes one pass through each of the AGs when
> > attempting to allocate an inode chunk. The expectation is a clean
> > transaction if a particular AG cannot satisfy the allocation
> > request. xfs_ialloc_ag_alloc() is written to support this through
> > use of the minalignslop allocation args field.
> > 
> > When using the agi->agi_newino optimization, we attempt an exact
> > bno allocation request based on the location of the previously
> > allocated chunk. minalignslop is set to inform the allocator that
> > we will require alignment on this chunk, and thus to not allow the
> > request for this AG if the extra space is not available. Suppose
> > that the AG in question has just enough space for this request, but
> > not at the requested bno. xfs_alloc_fix_freelist() will proceed as
> > normal as it determines the request should succeed, and thus it is
> > allowed to modify the agf. xfs_alloc_ag_vextent() ultimately fails
> > because the requested bno is not available. In response, the caller
> > moves on to a NEAR_BNO allocation request for the same AG. The
> > alignment is set, but the minalignslop field is never reset. This
> > increases the overall requirement of the request from the first
> > attempt. If this delta is the difference between allocation success
> > and failure for the AG, xfs_alloc_fix_freelist() rejects this
> > request outright the second time around and causes the allocation
> > request to unnecessarily fail for this AG.
> > 
> > To address this situation, reset the minalignslop field immediately
> > after use and prevent it from leaking into subsequent requests.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > v2:
> > - Reset minalignslop immediately after use rather than prior to the
> >   subsequent request and add a comment. [dchinner]
> > 
> 
> ping? Any chance to get this committed?

I'm sorry, Brian, I thought I had committed it - I'll get it in the
next round.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
