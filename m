Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F25CF7CA1
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 18:30:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8C952AC003
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 16:30:05 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	iKLowmN0Y1VJ4Jja for <xfs@oss.sgi.com>;
	Tue, 21 Jun 2016 16:29:59 -0700 (PDT)
Date: Wed, 22 Jun 2016 09:29:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs_check: process sparse inode chunks correctly
Message-ID: <20160621232940.GQ12670@dastard>
References: <1466441562-12317-1-git-send-email-bfoster@redhat.com>
	<1466441562-12317-3-git-send-email-bfoster@redhat.com>
	<20160621090153.GB28212@redhat.com>
	<de32a39e-864d-bd4d-8d5d-7a019b8e445f@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <de32a39e-864d-bd4d-8d5d-7a019b8e445f@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Tue, Jun 21, 2016 at 08:54:04AM -0500, Eric Sandeen wrote:
> 
> 
> On 6/21/16 4:01 AM, Carlos Maiolino wrote:
> > On Mon, Jun 20, 2016 at 12:52:42PM -0400, Brian Foster wrote:
> >> Update the inode btree scanning functions to process sparse inode chunks
> >> correctly. For filesystems with sparse inode support enabled, process
> >> each chunk a cluster at a time. Each cluster is checked against the
> >> inobt record to determine if it is a hole and skipped if so.
> >>
> >> Note that since xfs_check is deprecated in favor of xfs_repair,  this
> >> adds the minimum support necessary to process sparse inode enabled
> >> filesystems. In other words, this adds no sparse inode specific checks
> >> or verifications. We only update the inobt scanning functions to extend
> >> the existing level of verification to sparse inode enabled filesystems
> >> (e.g., avoid incorrectly tracking sparse regions as inodes). Problems
> >> or corruptions associated with sparse inode records must be detected and
> >> recovered via xfs_repair.
> >>
> > 
> > Hi,
> > 
> > I'm not quite sure, but a while ago, I thought I've heard some rumors about
> > deprecating xfs_check, is this true or something that my mind made up for some
> > weird reason?
> 
> Yes, like Brian said above.  ;)
> 
> bfc541e xfsprogs: remove xfs_check
> 12a48f5 xfsprogs: remove xfs_check references from fsck.xfs script & manpage
> 
> However, we still run check inside xfs_db in xfstests as an independent
> verification step:
> 
> 187bccd xfstests: Remove dependence of xfs_check script
> 
> +# xfs_check script is planned to be deprecated. But, we want to
> +# be able to invoke "xfs_check" behavior in xfstests in order to
> +# maintain the current verification levels.
> +_xfs_check()

Right - it's a secondary set of code that effectively tells us
whether repair is detecting all the problems it should. i.e. if
check fails and repair doesn't, then we've got a bug in repair that
needs fixing.

Also, the check code is really just an "addon" to other
functionality in xfs_db (e.g. blockget) that we have to keep, so
removing check doesn't really gain us all that much in terms of
reduced maintenance overhead. So long as we can easily keep check up
to date with new features I think we shoul dbe keeping it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
