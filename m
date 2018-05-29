Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38464 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934836AbeE2OxC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 May 2018 10:53:02 -0400
Date: Tue, 29 May 2018 07:52:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/7] xfs_repair: fix integer handling issues
Message-ID: <20180529145252.GA30110@magnolia>
References: <152728629694.22515.17699396814561914788.stgit@magnolia>
 <152728630312.22515.18006873991572258759.stgit@magnolia>
 <20180528135608.lkysdibdrzhewlom@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180528135608.lkysdibdrzhewlom@odin.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Mon, May 28, 2018 at 03:56:08PM +0200, Carlos Maiolino wrote:
> On Fri, May 25, 2018 at 03:11:43PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When we shift sb_logblocks to the right we need to ensure that we have
> Unless I'm missing something, it should be "to the left"?

Oops, yes, s/right/left/.

--D

> Otherwise:
> 
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> > enough storage space to shift correctly.  Cast logblocks to a 64-bit
> > type so that we don't screw up the check.
> 
> > 
> > Coverity-id: 1435810
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  repair/sb.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/repair/sb.c b/repair/sb.c
> > index ef44e39c..543200f7 100644
> > --- a/repair/sb.c
> > +++ b/repair/sb.c
> > @@ -313,7 +313,8 @@ verify_sb_loginfo(
> >  	if (xfs_sb_version_hascrc(sb) &&
> >  	    (sb->sb_logblocks == 0 ||
> >  	     sb->sb_logblocks > XFS_MAX_LOG_BLOCKS ||
> > -	     (sb->sb_logblocks << sb->sb_blocklog) > XFS_MAX_LOG_BYTES))
> > +	     ((unsigned long long)sb->sb_logblocks << sb->sb_blocklog) >
> > +	     XFS_MAX_LOG_BYTES))
> >  		return false;
> >  
> >  	if (sb->sb_logsunit > 1 && sb->sb_logsunit % sb->sb_blocksize)
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> Carlos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
