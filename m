Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D93DCC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 11:23:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0D1960F21
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 11:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236845AbhG2LXQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jul 2021 07:23:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44018 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236043AbhG2LXI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jul 2021 07:23:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627557785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+wDRhqqGnmgKiI4zs2wWwmpuZ3JxHam+8d/b4lyeYwQ=;
        b=S5PzE8DhCh0cfJtOhuwcY5lv4twmE/6YU4GAvAjSfeog5r/SK4n9M3smX5aBO39vM99kSH
        spoJuVkxdt+H4N6iuJvCF1aRr+y0AQNhgHX6IHSamF80lL2uHWWSpUeBlQ4hOgLR+bvwfU
        OJqy9weWY6rvNn984lWGBmzh5ONCSWg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-BWXUaJkUNHee4jlrxFsEZA-1; Thu, 29 Jul 2021 07:23:03 -0400
X-MC-Unique: BWXUaJkUNHee4jlrxFsEZA-1
Received: by mail-ej1-f72.google.com with SMTP id ju25-20020a17090798b9b029058c24b55273so1885316ejc.8
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jul 2021 04:23:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=+wDRhqqGnmgKiI4zs2wWwmpuZ3JxHam+8d/b4lyeYwQ=;
        b=SsiZRcxglSB25tH3374GN+kP5RuFYy1Fofh8oWmfvXcWBId/OAXEV1AWj52Zip6UKw
         5pb4kofeyx2M8M4Iu3XF1+Ao9FXKyls/BxqKeLduUqXhczNp5DnaSxCdU9UZpA+JFoKF
         ZqALsBOgFPzBCFNrTcZbVikzXFqkrArU+h8dLj8yMefH/ZAXnucvpTSJMJN7hRam6l4V
         bCzXDmRO+mgEwFyu7EPA4PceTZSSgvE3HLNKZrs4pwqNpDx8lAn0rb8sldO9kPtbPq+Q
         1lr3OHN1PlVpMYGrUFYWibBjOyXUAuwfEyo/MqJF6qtgwg/OTy/ilVTB2FaPNYJfU7VS
         GI8Q==
X-Gm-Message-State: AOAM532VylZYLRPlh2z0k1GfSN91CgfqcWV1A/J0hW+6kyKhxaCeRdVg
        IfiK9I/Ou9m1jeEKFgY0ZA+1XMLLE0tzz/gU1vil3ZeXKNlhCF2cYd6LHw5N0TDtiirk2Eplh8M
        70aLE+FVEtiuEZ20hpKZu
X-Received: by 2002:a17:906:fc6:: with SMTP id c6mr4037761ejk.65.1627557782574;
        Thu, 29 Jul 2021 04:23:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyDyn7d2mtDVdO1OvYvQyQNiWb4Ep2DW2vQFzdQu0MBHIWryd8bey1l20VqISoneqXZF14ehg==
X-Received: by 2002:a17:906:fc6:: with SMTP id c6mr4037742ejk.65.1627557782348;
        Thu, 29 Jul 2021 04:23:02 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id e17sm868852ejz.83.2021.07.29.04.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 04:23:01 -0700 (PDT)
Date:   Thu, 29 Jul 2021 13:23:00 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] quota: allow users to truncate group and project quota
 files
Message-ID: <20210729112300.libgmkmog5d6knou@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
References: <20210728200208.GH3601443@magnolia>
 <20210728211535.GI3601443@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728211535.GI3601443@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 28, 2021 at 02:15:35PM -0700, Darrick J. Wong wrote:
> Eric asked me to resend all the pending patches for 5.13, so I might as
> well NAK this and tell everyone to watch for the imminent patchbomb.

oh, I'll read the whole thread before reviewing next time, but well, feel free
to carry my reviewed-by.

Cheers

> 
> --D
> 
> On Wed, Jul 28, 2021 at 01:02:08PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > In commit 79ac1ae4, I /think/ xfsprogs gained the ability to deal with
> > project or group quotas.  For some reason, the quota remove command was
> > structured so that if the user passes both -g and -p, it will only ask
> > the kernel truncate the group quota file.  This is a strange behavior
> > since -ug results in truncation requests for both user and group quota
> > files, and the kernel is smart enough to return 0 if asked to truncate a
> > quota file that doesn't exist.
> > 
> > In other words, this is a seemingly arbitrary limitation of the command.
> > It's an unexpected behavior since we don't do any sort of parameter
> > validation to warn users when -p is silently ignored.  Modern V5
> > filesystems support both group and project quotas, so it's all the more
> > surprising that you can't do group and project all at once.  Remove this
> > pointless restriction.
> > 
> > Found while triaging xfs/007 regressions.
> > 
> > Fixes: 79ac1ae4 ("Fix xfs_quota disable, enable, off and remove commands Merge of master-melb:xfs-cmds:29395a by kenmcd.")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  quota/state.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/quota/state.c b/quota/state.c
> > index 3ffb2c88..43fb700f 100644
> > --- a/quota/state.c
> > +++ b/quota/state.c
> > @@ -463,7 +463,8 @@ remove_extents(
> >  	if (type & XFS_GROUP_QUOTA) {
> >  		if (remove_qtype_extents(dir, XFS_GROUP_QUOTA) < 0)
> >  			return;
> > -	} else if (type & XFS_PROJ_QUOTA) {
> > +	}
> > +	if (type & XFS_PROJ_QUOTA) {
> >  		if (remove_qtype_extents(dir, XFS_PROJ_QUOTA) < 0)
> >  			return;
> >  	}
> 

-- 
Carlos

