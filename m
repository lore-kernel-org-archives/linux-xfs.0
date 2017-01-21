Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37492 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752203AbdAUAIq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Jan 2017 19:08:46 -0500
Date: Fri, 20 Jan 2017 16:08:05 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 4/5] xfs_repair: zero shared_vn
Message-ID: <20170121000804.GI12985@birch.djwong.org>
References: <148494391629.5256.3328772079712970611.stgit@birch.djwong.org>
 <148494394162.5256.166843220095123974.stgit@birch.djwong.org>
 <20170120225251.GH12985@birch.djwong.org>
 <9307d194-d679-20c6-e83c-ac7fb38e467e@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9307d194-d679-20c6-e83c-ac7fb38e467e@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Fri, Jan 20, 2017 at 05:08:37PM -0600, Eric Sandeen wrote:
> On 1/20/17 4:52 PM, Darrick J. Wong wrote:
> > Since shared_vn always has to be zero, zero it at the end of repair.
>                                                  ^^^^^^^^^^^^^^^^^^^^
> 
> Or at the beginning ;)

"...at the start of repair."

> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v2: reset shared_vn in phase 1 and tell the user about it, per sandeen
> > ---
> >  repair/phase1.c |   11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/repair/phase1.c b/repair/phase1.c
> > index 126d0b3..ee5d3d7 100644
> > --- a/repair/phase1.c
> > +++ b/repair/phase1.c
> > @@ -138,6 +138,17 @@ _("Cannot disable lazy-counters on V5 fs\n"));
> >  		}
> >  	}
> >  
> > +	/* shared_vn should be zero */
> > +	if (sb->sb_shared_vn) {
> > +		if (!no_modify)  {
> > +			do_warn(_("resetting shared_vn to zero\n"));
> > +			sb->sb_shared_vn = 0;
> > +			primary_sb_modified = 1;
> > +		} else  {
> > +			do_warn(_("would reset shared_vn to zero\n"));
> > +		}
> > +	}
> > +
> 
> No other test has the if/else on no modify, they simply say what the problem
> is, "correcting" etc, but at the /end/ it says whether or not it's written out:
> 
>         if (primary_sb_modified)  {
>                 if (!no_modify)  {
>                         do_warn(_("writing modified primary superblock\n"));
>                         write_primary_sb(sb, sb->sb_sectsize);
>                 } else  {
>                         do_warn(_("would write modified primary superblock\n"));
>                 }
>         }
> 

Many of the repairs in later phases /do/ use this paradigm, though none
in this function do that.  I don't really care one way or the other, so
I'll change it to:

> So I think just something like:
> 
> +	if (sb->sb_shared_vn) {
> +		do_warn(_("superblock has invalid shared_vn, resetting\n"));
> +		sb->sb_shared_vn = 0;
> +		primary_sb_modified = 1;
> +	}
> 
> would suffice.

--D

> 
> -Eric
> 
> >  	if (primary_sb_modified)  {
> >  		if (!no_modify)  {
> >  			do_warn(_("writing modified primary superblock\n"));
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
