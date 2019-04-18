Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49972 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388450AbfDRSva (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Apr 2019 14:51:30 -0400
Date: Thu, 18 Apr 2019 11:51:24 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 39/36] misc: fix strncpy length complaints
Message-ID: <20190418185124.GA4931@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <20190320193542.GC1183@magnolia>
 <a238d47e-3867-8f85-7534-985a6e79058a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a238d47e-3867-8f85-7534-985a6e79058a@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 04, 2019 at 04:30:38PM -0500, Eric Sandeen wrote:
> On 3/20/19 2:35 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Fix a number of complaints about feeding sizeof(dest) directly to
> > strncpy.  We do this by declaring the char arrays to be one larger
> > than necessary and subtracting one, to ensure that we never overfill
> > the buffer.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  mkfs/xfs_mkfs.c |   13 +++++++++++--
> >  quota/edit.c    |    9 ++++++---
> >  2 files changed, 17 insertions(+), 5 deletions(-)
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 9e1c6ec5..e87c692c 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -3251,8 +3251,17 @@ finish_superblock_setup(
> >  	struct xfs_mount	*mp,
> >  	struct xfs_sb		*sbp)
> >  {
> > -	if (cfg->label)
> > -		strncpy(sbp->sb_fname, cfg->label, sizeof(sbp->sb_fname));
> > +	if (cfg->label) {
> > +		size_t		label_len;
> > +
> > +		/*
> > +		 * Labels are null terminated unless the string fits exactly
> > +		 * in the label field, so assume sb_fname is zeroed and then
> > +		 * do a memcpy because the destination isn't a normal C string.
> > +		 */
> > +		label_len = min(sizeof(sbp->sb_fname), strlen(cfg->label));
> 
> Heh, comparing this to the patch I wrote in <checks notes> December and never
> sent *cough*, it seems like it might be wise to memset the whole thing to 0,
> to be sure we're not leaking bytes here and there in a short label?
> 
> +               memset(sbp->sb_fname, 0, sizeof(sbp->sb_fname));
> 
> Although, I suppose the prior strncpy had the same issue... *shrug*

I think the initialization is fine because...

finish_superblock_setup sets fields in *sbp.  It gets *sbp from the top
of main(), which does:

	struct xfs_mount	mbuf = {};
	struct xfs_mount	*mp = &mbuf;
	struct xfs_sb		*sbp = &mp->m_sb;

So assuming the empty mbuf initializer causes the whole stack variable
to be initialized to zero, we don't need to do a memset here.

> 
> > +		memcpy(sbp->sb_fname, cfg->label, label_len);
> > +	}
> >  
> >  	sbp->sb_dblocks = cfg->dblocks;
> >  	sbp->sb_rblocks = cfg->rtblocks;
> > diff --git a/quota/edit.c b/quota/edit.c
> > index b10a5b34..f9938b8a 100644
> > --- a/quota/edit.c
> > +++ b/quota/edit.c
> > @@ -368,8 +368,7 @@ restore_file(
> >  	uint		type)
> >  {
> >  	char		buffer[512];
> > -	char		devbuffer[512];
> > -	char		*dev = NULL;
> > +	char		dev[512];
> >  	uint		mask;
> >  	int		cnt;
> >  	uint32_t	id;
> > @@ -377,7 +376,11 @@ restore_file(
> >  
> >  	while (fgets(buffer, sizeof(buffer), fp) != NULL) {
> >  		if (strncmp("fs = ", buffer, 5) == 0) {
> > -			dev = strncpy(devbuffer, buffer+5, sizeof(devbuffer));
> > +			/*
> > +			 * Copy the device name to dev, strip off the trailing
> > +			 * newline, and move on to the next line.
> > +			 */
> > +			strncpy(dev, buffer + 5, sizeof(dev) - 1);
> >  			dev[strlen(dev) - 1] = '\0';
> >  			continue;
> >  		}
> 
> Ok.
> 
> I had something in io/label.c: label_f() as well.  Do you not get complaints
> about strncpy(label, optarg, sizeof(label)); ?

I do, that's why I changed it...?  io/label.c got changed to shut up the
warning about the sizeof(firstarg) as the third parameter.

> 
> I essentially did the same thing as for mkfs, though with my gratuitous
> memset:
> 
>                         break;
>                 case 's':
> -                       strncpy(label, optarg, sizeof(label));
> +                       len = min(strlen(optarg), sizeof(label));
> +                       /* Kernel doesn't care about null termination */
> +                       memset(label, 0, sizeof(label));
> +                       memcpy(label, optarg, len);
>                         break;
>                 default:
> 

(FWIW I'm not sure I remember what we were talking about here.)

Anyway, maybe I'll just resend the remaining patches as a rollup since
this series is already huge.

--D
