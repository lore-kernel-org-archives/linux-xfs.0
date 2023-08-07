Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60073C001DB
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Aug 2023 08:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbjHGIl6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Aug 2023 04:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbjHGIlu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2023 04:41:50 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336C31721
        for <linux-xfs@vger.kernel.org>; Mon,  7 Aug 2023 01:41:43 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1b9c5e07c1bso38056985ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 07 Aug 2023 01:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1691397702; x=1692002502;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ieBVt0ZGNFZe3lAweOdigMZfLYOfS3A7DTWoDkDOzx0=;
        b=bAVAa3cJX8lXFLeae5P8mWkyLkkBOheJBUtOc3inlwQeF+/4EvIyWkEaQqD+onLRnj
         2rxecfO9kHs6U94+mG5GlWuGneF9OmzZAnm1hvPopqGoKG+8In1LNgxKc/7J/x23bOAs
         FM17oarWbTnBVLnOmM4Bu/dvNxcAZtiMfYy6J2KLrZ3jp8H1ZNBh9h4GA8yXgXvi7mVy
         ah1CQUxKLZ1KAwyguku2BJrIHHSnsYh5+7JQq53Glx2Ei3VIZnOmq/TpELnJhyeFKQJ9
         bMPo77rKsTLWeu3fBjIw+6h/0VHzWPUExSj9bEJMLPQrbdBvXfRvHO5NL689Lua4ZLux
         s50A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691397702; x=1692002502;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ieBVt0ZGNFZe3lAweOdigMZfLYOfS3A7DTWoDkDOzx0=;
        b=NJ2pGOZyiVKf6wq/gJlHhXPT4q0IZ1GRqCzNIf4n9oiXi3lUbscPtNx0UJzwQyDSDa
         Ja+qLaJO+IfkKhM5VN3Sr1KLTWVageRGvQCdHOdRD/FA6MK8J56/Lo7YHM82cVRNbZp/
         IAxIifDXMRn6t0uCoFOUAhNqPj/NUvy8L0azuXsKvFgon9+V+qq3KgXl5BsE02V8mo85
         T1qJjK+JX8bmrY51oLn7P4ouiEgIWfE+wKOTj0datIpMdm3pnHK0HZ+3DliyABGQeoF/
         +pWqAwAqd8anG3Z/pix8AyHfrBCuTIVI4lNSPnUA9UHQ6+yVFzZKtr+vtoJmrLGQ6Gjm
         pWtQ==
X-Gm-Message-State: AOJu0YzMNpweh8AqvfAGe0DtFCIjm9LstLWn7E+nE6QW/I3AUV9HeeuZ
        vDIGFyCHaD+DyMhhC21uBbcYQvpS90FrgVdHam4=
X-Google-Smtp-Source: AGHT+IFKBxqhFJOFmz5p+RmzN1Bj41xjsGSDz8smrqOZDBi01ouwTz/4gHUEZ310bx7Pl/rehfO14Q==
X-Received: by 2002:a17:902:a40b:b0:1bc:2d43:c741 with SMTP id p11-20020a170902a40b00b001bc2d43c741mr7670997plq.66.1691397702573;
        Mon, 07 Aug 2023 01:41:42 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-166-213.pa.nsw.optusnet.com.au. [49.180.166.213])
        by smtp.gmail.com with ESMTPSA id ji1-20020a170903324100b001b8a85489a3sm6288323plb.262.2023.08.07.01.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 01:41:42 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qSvo3-002Cn9-2H;
        Mon, 07 Aug 2023 18:41:39 +1000
Date:   Mon, 7 Aug 2023 18:41:39 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: log EFIs for all btree blocks being used to
 stage a btree
Message-ID: <ZNCuQ/mxsHQ67vjz@dread.disaster.area>
References: <169049623167.921279.16448199708156630380.stgit@frogsfrogsfrogs>
 <169049623218.921279.10028914723578681696.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169049623218.921279.10028914723578681696.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 27, 2023 at 03:24:32PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> We need to log EFIs for every extent that we allocate for the purpose of
> staging a new btree so that if we fail then the blocks will be freed
> during log recovery.  Add a function to relog the EFIs, so that repair
> can relog them all every time it creates a new btree block, which will
> help us to avoid pinning the log tail.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
.....
> +/*
> + * Set up automatic reaping of the blocks reserved for btree reconstruction in
> + * case we crash by logging a deferred free item for each extent we allocate so
> + * that we can get all of the space back if we crash before we can commit the
> + * new btree.  This function returns a token that can be used to cancel
> + * automatic reaping if repair is successful.
> + */
> +static int
> +xrep_newbt_schedule_autoreap(
> +	struct xrep_newbt		*xnr,
> +	struct xrep_newbt_resv		*resv)
> +{
> +	struct xfs_extent_free_item	efi_item = {
> +		.xefi_blockcount	= resv->len,
> +		.xefi_owner		= xnr->oinfo.oi_owner,
> +		.xefi_flags		= XFS_EFI_SKIP_DISCARD,
> +		.xefi_pag		= resv->pag,
> +	};
> +	struct xfs_scrub		*sc = xnr->sc;
> +	struct xfs_log_item		*lip;
> +	LIST_HEAD(items);
> +
> +	ASSERT(xnr->oinfo.oi_offset == 0);
> +
> +	efi_item.xefi_startblock = XFS_AGB_TO_FSB(sc->mp, resv->pag->pag_agno,
> +			resv->agbno);
> +	if (xnr->oinfo.oi_flags & XFS_OWNER_INFO_ATTR_FORK)
> +		efi_item.xefi_flags |= XFS_EFI_ATTR_FORK;
> +	if (xnr->oinfo.oi_flags & XFS_OWNER_INFO_BMBT_BLOCK)
> +		efi_item.xefi_flags |= XFS_EFI_BMBT_BLOCK;
> +
> +	INIT_LIST_HEAD(&efi_item.xefi_list);
> +	list_add(&efi_item.xefi_list, &items);
> +
> +	xfs_perag_intent_hold(resv->pag);
> +	lip = xfs_extent_free_defer_type.create_intent(sc->tp, &items, 1,
> +			false);

Hmmmm.

That triggered flashing lights and sirens - I'm not sure I really
like the usage of the defer type arrays like this, nor the
duplication of the defer mechanisms for relogging, etc.

Not that I have a better idea right now - is this the final form of
this code, or is more stuff built on top of it or around it?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
