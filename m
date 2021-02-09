Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F48C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 18:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A611E64EC2
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 18:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbhBISgv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 13:36:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:42474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233348AbhBISXC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Feb 2021 13:23:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 183E564E3F;
        Tue,  9 Feb 2021 18:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612894942;
        bh=3bKxg86PZL5c3EXAF83hazrz2vnN6ui4lvT7vDn9YD4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QNc+J63gzYL8nXHZ28asUphKb0RBfYZ82pEn3/OconByoGt4CG2NO6+nc6iSC6Usc
         ueSX/rjABG776cJ30J827h4uzrY024gF8AvvZZiP5bgRpV2FlVB5cJzCB2X5L6pmKv
         +l8Tn67LkMiZWr0qqJ51OdYY1vKP742xd+uL032ERAhDFrFQlyiTsgg+Coa8Xvz2+p
         P5Wh10n/3ZUMqYxAn2Q/9uQkM9PccPSkcCZsPDokWuTHRDBtUzxEHvZkL2f5ZKxvgR
         RSdx8VAL0W5+SSsmHhdkxukNyU5zD/HVKPdRbtnWWkN0B6xPcNoJzhRYfE4C66M8Zc
         6rjz0tTUBsAUQ==
Date:   Tue, 9 Feb 2021 10:22:21 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/10] xfs_admin: support adding features to V5
 filesystems
Message-ID: <20210209182221.GV7193@magnolia>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284386088.3057868.16559496991921219277.stgit@magnolia>
 <20210209172204.GH14273@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209172204.GH14273@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 09, 2021 at 12:22:04PM -0500, Brian Foster wrote:
> On Mon, Feb 08, 2021 at 08:11:00PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Teach the xfs_admin script how to add features to V5 filesystems.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  db/xfs_admin.sh      |    6 ++++--
> >  man/man8/xfs_admin.8 |   22 ++++++++++++++++++++++
> >  2 files changed, 26 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
> > index 430872ef..7a467dbe 100755
> > --- a/db/xfs_admin.sh
> > +++ b/db/xfs_admin.sh
> > @@ -8,9 +8,10 @@ status=0
> >  DB_OPTS=""
> >  REPAIR_OPTS=""
> >  REPAIR_DEV_OPTS=""
> > -USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-r rtdev] [-U uuid] device [logdev]"
> > +DB_LOG_OPTS=""
> > +USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-O v5_feature] [-r rtdev] [-U uuid] device [logdev]"
> 
> Technically this would pass through the lazy counter variant on a v4
> super, right? I wonder if we should just call it "[-O feature]" here.
> 
> >  
> > -while getopts "c:efjlL:pr:uU:V" c
> > +while getopts "c:efjlL:O:pr:uU:V" c
> >  do
> >  	case $c in
> >  	c)	REPAIR_OPTS=$REPAIR_OPTS" -c lazycount="$OPTARG;;
> ...
> > diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
> > index cccbb224..3f3aeea8 100644
> > --- a/man/man8/xfs_admin.8
> > +++ b/man/man8/xfs_admin.8
> ...
> > @@ -106,6 +108,26 @@ The filesystem label can be cleared using the special "\c
> >  " value for
> >  .IR label .
> >  .TP
> > +.BI \-O " feature1" = "status" , "feature2" = "status..."
> > +Add or remove features on an existing a V5 filesystem.
> 
> s/existing a/existing/

Fixed, thanks.

> Also, similar question around the lazycount variant. If it works, should
> it not be documented here?

It would work, but I'd rather stick to the existing narrative that
"xfs_admin -c 0|1" is how one changes the lazycount feature.  Mentioning
both avenues in the manpage introduces the potential for confusion as to
whether one is particularly better than the other.

--D

> Brian
> 
> > +The features should be specified as a comma-separated list.
> > +.I status
> > +should be either 0 to disable the feature or 1 to enable the feature.
> > +Note, however, that most features cannot be disabled.
> > +.IP
> > +.B NOTE:
> > +Administrators must ensure the filesystem is clean by running
> > +.B xfs_repair -n
> > +to inspect the filesystem before performing the upgrade.
> > +If corruption is found, recovery procedures (e.g. reformat followed by
> > +restoration from backup; or running
> > +.B xfs_repair
> > +without the
> > +.BR -n )
> > +must be followed to clean the filesystem.
> > +.IP
> > +There are currently no feature options.
> > +.TP
> >  .BI \-U " uuid"
> >  Set the UUID of the filesystem to
> >  .IR uuid .
> > 
> 
