Return-Path: <SRS0=yY6+=BX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1587C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Aug 2020 15:28:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF66A207DA
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Aug 2020 15:28:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VdcY0oti"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgHMP2c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Aug 2020 11:28:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25237 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726167AbgHMP2b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Aug 2020 11:28:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597332510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4jV4ZrGTqcxDuUWpsha+5XjzVSadx1ZxdGzQKnYbVVc=;
        b=VdcY0oti33hqL8Zeo1Ub+Gfo7pDg5bBW8qE+9myDVzZoSpz6GcTeyViltDn5L9wFd+xjKh
        xquPaoSXDh5DBQnj06Yv8tdECutaFFbW6iZ6Hof6LQrqFdS8OZZ7TEf3YwGxlePy+oFs2p
        uvScj9dJ8PGgJPODztRUNMbJEY2KeLI=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-_2wtT4c1OlC6EcOq-Wih6w-1; Thu, 13 Aug 2020 11:28:28 -0400
X-MC-Unique: _2wtT4c1OlC6EcOq-Wih6w-1
Received: by mail-pl1-f198.google.com with SMTP id b11so4120703plx.21
        for <linux-xfs@vger.kernel.org>; Thu, 13 Aug 2020 08:28:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4jV4ZrGTqcxDuUWpsha+5XjzVSadx1ZxdGzQKnYbVVc=;
        b=DAVJm8CDlYnF8fCMJdS7nT2NDCaf7TIsgfwopnCaC2WBt+fxeHzXVR/ASoCpU2e8O/
         l6Qjj2Ophac6iBFhUlOgjtH94mdusPXhtXB4LkNIcnB6/cncKLswKMWK143lZ7lFPTC4
         9rCOBl2vqRgoX/IgZLPLzI70koqFEogKdGVQs74dwD7PD2ZFETVG4HjlctC65qqZM+Hy
         ucxAZLRu0EX5sQ1MKs755Uv22WL0AlUq85XHwoyPgO5hupF/J6Wsgzaopn6dsA9VVi5k
         IdxqveSHJeYrOScjC9+K9TDLI1pZEurOm9fk0BND67BXLBGDbSLmF6oxZFogm2fy/UPl
         wXwQ==
X-Gm-Message-State: AOAM532GuNSs27ZCGLK3tq4Zd81do8Zp3+JZbSSr6IC7AETEJcmqeGzA
        fs/0tUQq3B8RAtyTMdmp9o+8Zlf0ohSWxOjRgNsN7otTET5DwwAmMU5WKJMTIZIvHrkb+DtFYKI
        06vt5XuwXM0om131kLEnN
X-Received: by 2002:a17:902:10e:: with SMTP id 14mr4165768plb.297.1597332506973;
        Thu, 13 Aug 2020 08:28:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxi5VKBcJd3Oht+2cTnu4U3XP/hGN69JKm3mqZ7ejza1jJqi7JJDO+z49Z/IAvytXq7UB1USw==
X-Received: by 2002:a17:902:10e:: with SMTP id 14mr4165749plb.297.1597332506746;
        Thu, 13 Aug 2020 08:28:26 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k12sm5497546pjp.38.2020.08.13.08.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2020 08:28:26 -0700 (PDT)
Date:   Thu, 13 Aug 2020 23:28:17 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_db: use correct inode to set inode type
Message-ID: <20200813152817.GA32687@xiangao.remote.csb>
References: <20200813060324.8159-1-zlang@redhat.com>
 <20200813135345.GA3176@xiangao.remote.csb>
 <20200813152905.GP2937@dhcp-12-102.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813152905.GP2937@dhcp-12-102.nay.redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 13, 2020 at 11:29:05PM +0800, Zorro Lang wrote:

...

> > >  		ino = XFS_AGINO_TO_INO(mp, xfs_daddr_to_agno(mp, b),
> > > -			((b << BBSHIFT) >> mp->m_sb.sb_inodelog) %
> > > +			(((b << BBSHIFT) + bo) >> mp->m_sb.sb_inodelog) %
> > >  			XFS_AGB_TO_AGINO(mp, mp->m_sb.sb_agblocks));
> > >  		set_cur_inode(ino);
> > >  		return;
> > 
> > Not familar with such code, but after looking into a bit, (my premature
> > thought is that) I'm wondering if we need to reverify original buffer in
> > 
> > if (type->fields) {
> > 	...
> > 	set_cur()
> > }
> > 
> > iocur_top->typ = type;
> > 
> > /* verify the buffer if the type has one. */
> > ...
> > 
> > since set_cur() already verified the buffer in
> > set_cur->libxfs_buf_read->...->libxfs_readbuf_verify?
> > 
> > Not related to this patchset but I'm a bit curious about it now...
> 
> I'm not the one who learn about xfsprogs best:) But by looking into
> set_cur_inode() -> set_cur(), I think the set_cur() does the xfs_buf
> verification, so I don't think we need to do that again at the end
> of set_iocur_type().

Nope, I wasn't saying we need to add anything after set_cur_inode().
but commit 55f224baf83d ("xfs_db: update buffer size when new type is set")

In detail, I think it might be

if (type->fields) {
	...
	set_cur()
	return;		<- here
}

iocur_top->typ = type;

/* verify the buffer if the type has one. */
...

Thanks,
Gao Xiang

> 
> Thanks,
> Zorro
> 
> > 
> > Thanks,
> > Gao Xiang
> > 
> > > -- 
> > > 2.20.1
> > > 
> > 
> 

