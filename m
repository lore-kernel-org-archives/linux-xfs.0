Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:46966 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752696AbeFKUXm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jun 2018 16:23:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5BKG9rp041804
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 20:23:42 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2jgecxeaef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 20:23:42 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w5BKNfgp011072
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 20:23:41 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w5BKNe5t017879
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jun 2018 20:23:41 GMT
Date: Mon, 11 Jun 2018 13:23:37 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 23/27] xfsprogs: Do not use namechecks on parent
 pointers
Message-ID: <20180611202337.GI22045@magnolia>
References: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
 <1528607272-11122-24-git-send-email-allison.henderson@oracle.com>
 <20180611180052.GE22045@magnolia>
 <056e2e3c-7bd0-b289-9a83-2fa496fed829@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <056e2e3c-7bd0-b289-9a83-2fa496fed829@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 11, 2018 at 01:00:45PM -0700, Allison Henderson wrote:
> On 06/11/2018 11:00 AM, Darrick J. Wong wrote:
> > On Sat, Jun 09, 2018 at 10:07:48PM -0700, Allison Henderson wrote:
> > > Attribute names of parent pointers are not strings.  So
> > > avoid doing namechecks for these attributes.
> > > 
> > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > ---
> > >   repair/attr_repair.c | 18 +++++++++++-------
> > >   1 file changed, 11 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> > > index 8b1b8a7..b8b0768 100644
> > > --- a/repair/attr_repair.c
> > > +++ b/repair/attr_repair.c
> > > @@ -308,8 +308,9 @@ process_shortform_attr(
> > >   		/* namecheck checks for / and null terminated for file names.
> > >   		 * attributes names currently follow the same rules.
> > >   		*/
> > > -		if (namecheck((char *)&currententry->nameval[0],
> > > -						currententry->namelen))  {
> > > +		if (!(currententry->flags & XFS_ATTR_PARENT) &&
> > > +			namecheck((char *)&currententry->nameval[0],
> > > +			currententry->namelen))  {
> > >   			do_warn(
> > 
> > Please don't indent the condition tests to the same column as the code.
> > Either line them up with the if parentheses or double-tab them.
> > 
> > if (!(currententry->flags & XFS_ATTR_PARENT) &&
> >      namecheck((char *)&currententry->nameval[0],
> > 		currententry->namelen)) {
> > 	do_warn(...);
> > }
> > 
> Alrighty, will fix
> 
> > >   	_("entry contains illegal character in shortform attribute name\n"));
> > >   			junkit = 1;
> > > @@ -470,8 +471,9 @@ process_leaf_attr_local(
> > >   	xfs_attr_leaf_name_local_t *local;
> > >   	local = xfs_attr3_leaf_name_local(leaf, i);
> > > -	if (local->namelen == 0 || namecheck((char *)&local->nameval[0],
> > > -							local->namelen)) {
> > > +	if (!(entry->flags & XFS_ATTR_PARENT) &&
> > > +		(local->namelen == 0 || namecheck((char *)&local->nameval[0],
> > > +		local->namelen))) {
> > 
> > Why skip the namelen checks when it's a parent pointer?  Isn't the pptr
> > corrupt if the (ino, gen, offset) data is length zero?
> > 
> Thats true, though I suppose in the case of parent pointers it should be the
> size of the name record.  Would it maybe be cleaner to make a subroutine
> that took local and entry and did the appropriate length checking there?  It
> may make things simpler here and also in the case below?

I probably wouldn't bother for the local entry because it's fairly
short.  The remote format case below is sort of gnarly, maybe it'd be
better refactored as a functi...

...hmm, thinking further, in the (flags & PARENT) case, namelen should
be exactly sizeof(struct xfs_parent_name_rec), right?

So perhaps we just move the namelen == 0 check into namecheck and pass
in the entry->flags so that we can do....

...thinking even further ahead, if there's some sort of verifier
function for struct xfs_parent_name_rec then we should call that here
too.  What do you think of this?

/* return true if attr name is garbage */
bool namecheck(entry, nameptr, namelen)
{
	if (namelen == 0)
		return true;
	if (entry->flags & _ATTR_PARENT) {
		xfs_failaddr_t	fa;

		if (namelen != sizeof(struct xfs_parent_name_rec))
			return true;

		fa = xfs_verify_pptr(mp, (struct xfs_parent_name_rec *)nameptr);
		return fa != NULL;
	}
	/* do the other name checks */
}

--D

> 
> 
> > >   		do_warn(
> > >   	_("attribute entry %d in attr block %u, inode %" PRIu64 " has bad name (namelen = %d)\n"),
> > >   			i, da_bno, ino, local->namelen);
> > > @@ -525,13 +527,15 @@ process_leaf_attr_remote(
> > >   	remotep = xfs_attr3_leaf_name_remote(leaf, i);
> > > -	if (remotep->namelen == 0 || namecheck((char *)&remotep->name[0],
> > > -						remotep->namelen) ||
> > > +	if (!(entry->flags & XFS_ATTR_PARENT) &&
> > > +			(remotep->namelen == 0 ||
> > > +			namecheck((char *)&remotep->name[0],
> > > +				remotep->namelen) ||
> > >   			be32_to_cpu(entry->hashval) !=
> > >   				libxfs_da_hashname((unsigned char *)&remotep->name[0],
> > >   						remotep->namelen) ||
> > >   			be32_to_cpu(entry->hashval) < last_hashval ||
> > > -			be32_to_cpu(remotep->valueblk) == 0) {
> > > +			be32_to_cpu(remotep->valueblk) == 0)) {
> > 
> > Do parent pointer attrs ever end up using a remote value block to store
> > the name?  If so, I think you only want to skip the namecheck, not the
> > namelen/hashval/valueblk checks, right?
> > 
> > --D
> > 
> > >   		do_warn(
> > >   	_("inconsistent remote attribute entry %d in attr block %u, ino %" PRIu64 "\n"), i, da_bno, ino);
> > >   		return -1;
> > > -- 
> > > 2.7.4
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
