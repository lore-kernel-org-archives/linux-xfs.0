Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EB2777F37
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2014 10:16:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CFD6BAC003
	for <xfs@oss.sgi.com>; Tue, 29 Jul 2014 08:16:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id v9jIYdyOvtU0GMmb (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 29 Jul 2014 08:16:27 -0700 (PDT)
Date: Tue, 29 Jul 2014 11:25:40 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC 00/18] xfs: sparse inode chunks
Message-ID: <20140729152540.GC17085@bfoster.bfoster>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
	<20140724223211.GQ20518@dastard>
	<20140725163056.GA3350@laptop.bfoster>
	<20140726000335.GE20518@dastard>
	<20140728121400.GB53501@bfoster.bfoster>
	<20140729002650.GH26465@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140729002650.GH26465@dastard>
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

On Tue, Jul 29, 2014 at 10:26:50AM +1000, Dave Chinner wrote:
> On Mon, Jul 28, 2014 at 08:14:01AM -0400, Brian Foster wrote:
> > On Sat, Jul 26, 2014 at 10:03:35AM +1000, Dave Chinner wrote:
> > > On Fri, Jul 25, 2014 at 12:30:57PM -0400, Brian Foster wrote:
> > > > Hmm, I suppose that does create a new and interesting dynamic with
> > > > regard to the feature bit (non-deterministic backwards compatibility).
> > > > One could certainly value backwards compatibility over this particular
> > > > feature, and there is currently no way to control it. I'll look into
> > > > doing something with xfs_admin. In fact, I was thinking of adding
> > > > something to tune the cluster size bit to get around the v5 scaling
> > > > issue anyways.
> > > 
> > > What v5 scalability issue is that? I don't recall any outstanding
> > > issues with inode cluster IO....
> > > 
> > 
> > There's no scalability issue... I'm just referring to the fact that we
> > scale the cluster size by the inode size increase factor on v5
> > superblocks.
> > 
> > E.g., my free space fragmentation xfstests test started out with a fixed
> > file size based on something close to the worst case with an
> > implementation that used the allocation granularity of max(<holemask bit
> > granularity>, <inodes per block>). Once I tied the implementation to the
> > cluster size due to the aforementioned complexities, it became apparent
> > the test was less effective with my chosen file size on v5 supers,
> > particularly as the inode size increased. So from there I was
> > considering a similar xfs_admin command a user could run to reduce the
> > cluster size as a backstop should this limitation arise in the real
> > world. We can start with doing something just to enable the feature as
> > outlined above and revisit this then...
> 
> Right, but I'd suggest that the better long term solution to avoid
> the limitations of inode cluster buffer alignment issues is to get
> rid of inode clusters and inode buffers altogether. We only need
> inode buffers for logging unlinked list modifications, so once we
> log those as part of the inode core for for v5 filesystems then we
> can do much more dynamic inode IO. That then frees us up to do fine
> grained sparse inode allocation because we aren't limited by
> in-memory buffering limitations.
> 
> http://xfs.org/index.php/Improving_inode_Caching#Food_For_Thought_.28Crazy_Ideas.29
> 

Interesting, thanks. I guess removing the need for the code that's
incompatible with the sub-cluster size granularity is a nice option. :)
I'll have to read into this some more once the basic sparse inode
feature is more hashed out.

Brian

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
