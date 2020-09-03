Return-Path: <SRS0=br+O=CM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B23CC433E2
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 16:05:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19F0D208C7
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Sep 2020 16:05:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KPWwt3d4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbgICQFT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 12:05:19 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20402 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727065AbgICQFQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Sep 2020 12:05:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599149115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hl091aKDnKj+RiKb1YSG8zrHrA1PWM186Lp1JegPsb4=;
        b=KPWwt3d4R5NJubMeyOo5hw6FDrMoA20y2TsiUQ+kyZU26w0IXCs6gyEEpnlZGVBhuRlTND
        VEnuvfnc5MwisXV1zhR8sUNPpONX89Uv8O/P7BDI74ZHFrA4urOtJ0eNQ/6K66lNdKhb/e
        RNw550myvyh10wfm012yZH9JhEVo1Bc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-htUQ9s6gPlOA67btrD-IbA-1; Thu, 03 Sep 2020 12:05:13 -0400
X-MC-Unique: htUQ9s6gPlOA67btrD-IbA-1
Received: by mail-wm1-f70.google.com with SMTP id a5so1123026wmj.5
        for <linux-xfs@vger.kernel.org>; Thu, 03 Sep 2020 09:05:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=hl091aKDnKj+RiKb1YSG8zrHrA1PWM186Lp1JegPsb4=;
        b=pwJ45tddbJ4eWWsmwHXRSONMkaRdED6DJ4Vv4Xeb+xbetsjEVysfQtFgCFKbGOOz2z
         SBfZbNTVITUN17gAMzpjsAcNMERG9dKGvQswFkt5NcL2KYNYJe+C/eCJIq8xaSZ2yf9L
         jfB3K8yCWxQyHrIyp7EgXupi9thT+ql2utH79c/jgQb0hoYjHa8lzJgbVxajVTJoFw3h
         LcExuoEZsLRlob1alzemXtKJxvXELQdXVd872kxCuV7neXy/8CQRcvlF+d86p/1UK8Z1
         otS+aQoBbhejqa/qyj2Izx2kmEVi1Dn+AjFGyR6JaY+5Ga9Zk/dTs0BfCgMSPT/4fia3
         h6VQ==
X-Gm-Message-State: AOAM531k9vL/njThWrj83q2g7Zy25TadvP2Q8zC9EOcpaDDPqeIntHhO
        oyiKjkvOSWG4sKYFlb6TxmY2WHCfN2ydqWprghoBFtO3f3mY2j7AdciN4XAZUoJkDFdjby651fU
        XbMY2tXCsW7LJ1MIzv8HP
X-Received: by 2002:a5d:5642:: with SMTP id j2mr3185451wrw.417.1599149112597;
        Thu, 03 Sep 2020 09:05:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwcp8QEFsFZJ3RKvBR9fXjKQRUUFvD60FoViyWplAecDzoxAhPhjTnHLHsnjywC8znqa4BNHg==
X-Received: by 2002:a5d:5642:: with SMTP id j2mr3185426wrw.417.1599149112382;
        Thu, 03 Sep 2020 09:05:12 -0700 (PDT)
Received: from eorzea (ip-89-102-9-109.net.upcbroadband.cz. [89.102.9.109])
        by smtp.gmail.com with ESMTPSA id g8sm5201131wmd.12.2020.09.03.09.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 09:05:11 -0700 (PDT)
Date:   Thu, 3 Sep 2020 18:05:09 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 4/4] xfs: Convert xfs_attr_sf macros to inline
 functions
Message-ID: <20200903160509.dizravzqitvkbk2l@eorzea>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org
References: <20200903142839.72710-1-cmaiolino@redhat.com>
 <20200903142839.72710-5-cmaiolino@redhat.com>
 <20200903143309.GB19892@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903143309.GB19892@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 03, 2020 at 03:33:09PM +0100, Christoph Hellwig wrote:
> On Thu, Sep 03, 2020 at 04:28:39PM +0200, Carlos Maiolino wrote:
> > xfs_attr_sf_totsize() requires access to xfs_inode structure, so, once
> > xfs_attr_shortform_addname() is its only user, move it to xfs_attr.c
> > instead of playing with more #includes.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> > 
> > Changelog:
> > 	V2:
> > 	 - keep macro comments above inline functions
> > 	V3:
> > 	- Add extra spacing in xfs_attr_sf_totsize()
> > 	- Fix open curling braces on inline functions
> > 	- use void * casting on xfs_attr_sf_nextentry()
> > 
> >  fs/xfs/libxfs/xfs_attr.c      | 14 +++++++++++---
> >  fs/xfs/libxfs/xfs_attr_leaf.c | 18 +++++++++---------
> >  fs/xfs/libxfs/xfs_attr_sf.h   | 30 +++++++++++++++++++-----------
> >  fs/xfs/xfs_attr_list.c        |  4 ++--
> >  4 files changed, 41 insertions(+), 25 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index 2e055c079f397..982014499f1ff 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -428,7 +428,7 @@ xfs_attr_set(
> >  		 */
> >  		if (XFS_IFORK_Q(dp) == 0) {
> >  			int sf_size = sizeof(struct xfs_attr_sf_hdr) +
> > -				XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen,
> > +				xfs_attr_sf_entsize_byname(args->namelen,
> >  						args->valuelen);
> >  
> >  			error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
> > @@ -523,6 +523,14 @@ xfs_attr_set(
> >   * External routines when attribute list is inside the inode
> >   *========================================================================*/
> >  
> > +/* total space in use */
> > +static inline int xfs_attr_sf_totsize(struct xfs_inode *dp) {
> > +	struct xfs_attr_shortform *sf =
> > +		(struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
> > +
> > +	return be16_to_cpu(sf->hdr.totsize);
> 
> The { should go on a line by its own.

Sorry, I forgot to modify this one
> 
> > +static inline struct xfs_attr_sf_entry *
> > +xfs_attr_sf_nextentry(struct xfs_attr_sf_entry *sfep)
> > +{
> > +	return (void *)(sfep) + xfs_attr_sf_entsize(sfep);
> 
> No need for the braces around sfep.
> 

I'll resend, thanks

-- 
Carlos

