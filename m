Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 90C357F54
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 18:33:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 706E48F804C
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 16:33:47 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	youkpKdqAMVhen29 for <xfs@oss.sgi.com>;
	Mon, 21 Oct 2013 16:33:45 -0700 (PDT)
Date: Tue, 22 Oct 2013 10:33:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/19] xfs: unify directory/attribute format definitions
Message-ID: <20131021233341.GF4446@dastard>
References: <1381789085-21923-1-git-send-email-david@fromorbit.com>
	<1381789085-21923-6-git-send-email-david@fromorbit.com>
	<20131021231129.GM1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131021231129.GM1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, Oct 21, 2013 at 06:11:29PM -0500, Ben Myers wrote:
> On Tue, Oct 15, 2013 at 09:17:51AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The on-disk format definitions for the directory and attribute
> > structures are spread across 3 header files right now, only one of
> > which is dedicated to defining on-disk structures and their
> > manipulation (xfs_dir2_format.h). Pull all the format definitions
> > into a single header file - xfs_da_format.h - and switch all the
> > code over to point at that.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> IIRC Christoph had some concerns with this one, but it wasn't very clear
> exactly what they were.  This looks ok to me.  Christoph did you have anything
> more to add?

I pulled some of the btree specific definitions back into
xfs_btree.h (key, ptr unions), but I left the bmbt_rec-host
definitions in the header as I haven't worked out exactly how to
relocate them without introducing new dependencies everywhere. Hence
I've cleaned up most of what Christoph asked for, but I'm leaving
the hard part for a separate patch(set) where it will be (hopefully)
much clearer what is being moved and what dependencies it
reintroduces.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
