Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53092 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751479AbeEDTYF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 May 2018 15:24:05 -0400
Date: Fri, 4 May 2018 12:23:37 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/11] xfs_repair: examine all remote attribute blocks
Message-ID: <20180504192337.GJ26569@magnolia>
References: <152401958920.13319.10756339531174871801.stgit@magnolia>
 <152401959780.13319.9582448473529615015.stgit@magnolia>
 <be57719e-81ed-9574-02b1-1d85efde624c@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be57719e-81ed-9574-02b1-1d85efde624c@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Fri, May 04, 2018 at 01:20:42PM -0500, Eric Sandeen wrote:
> On 4/17/18 9:46 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Examine all remote xattr values of a file, not just the XFS_ATTR_ROOT
> > values.  This enables us to detect and zap corrupt user xattrs, as
> > tested by xfs/404.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Whoa.  ;)  Where'd this come from?  At first glance it seems crazy to only
> check XFS_ATTR_ROOT but then I stated digging a little...
> 
> This is essentially akin to other code we still have in the local
> case,
> 
>         /* Only check values for root security attributes */
>         if (entry->flags & XFS_ATTR_ROOT) {
>                 if (valuecheck(mp, (char *)&local->nameval[0], NULL,
>                                 local->namelen, be16_to_cpu(local->valuelen))) {
>                         do_warn(
>         _("bad security value for attribute entry %d in attr block %u, inode %" PRIu64 "\n"),
>                                 i, da_bno, ino);
>                         return -1;
>                 }
>         }
> 
> soooo this patch essentially allows valuecheck on !XFS_ATTR_ROOT attributes,
> but valuecheck says:
> 
>  * Calls will be made to xfs_mac_valid or xfs_acl_valid routines if the
>  * security attributes exist. They will be cleared if invalid.
>  * No other values will be checked. 
> 
> So, um, what's actually getting fixed?  Ah, ok:
> 
> this also allows us to simply try to /get/ the remote attribute:
> 
> rmtval_get()
> 
> and if that fails:
> 
>                 do_warn(
>         _("remote attribute get failed for entry %d, inode %" PRIu64 "\n"),
>                         i, ino);
>                 goto bad_free_out;
> 
> we zap it.
> 
> So ... uh...
> 
> I think you want to /move/ the XFS_ATTR_ROOT check before the call to valuecheck(),
> rather than removing it entirely.

Yes.  I could just make it part of the valuecheck test...

if (rmtval_get(...)) {
	do_warn(...);
	goto bad_free_out;
}

if ((entry->flags & XFS_ATTR_ROOT) &&
    valuecheck(...)) {
	do_warn(...);
	goto bad_free_out;
}

free(value);

--D

> 
> Ok, at this rate I'll have all 11 patches done by June.
> 
> -Eric
> 
> > ---
> >  repair/attr_repair.c |    3 ---
> >  1 file changed, 3 deletions(-)
> > 
> > 
> > diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> > index 8b1b8a7..bb5ab3d 100644
> > --- a/repair/attr_repair.c
> > +++ b/repair/attr_repair.c
> > @@ -537,9 +537,6 @@ process_leaf_attr_remote(
> >  		return -1;
> >  	}
> >  
> > -	if (!(entry->flags & XFS_ATTR_ROOT))
> > -		goto out;
> > -
> >  	value = malloc(be32_to_cpu(remotep->valuelen));
> >  	if (value == NULL) {
> >  		do_warn(
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
