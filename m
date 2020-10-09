Return-Path: <SRS0=Vfs/=DQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECF42C433E7
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 01:01:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AAE422257
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 01:01:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IPHGBNKy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728605AbgJIBB6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 21:01:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45199 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728579AbgJIBB6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 21:01:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602205316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UWVGueE1ewfYhB1q7+ns2tEdz1obR+iAVyeQK6rww7g=;
        b=IPHGBNKyrxGDEwtFK/pxpUO5qsRQvdGusfcghxxHS9KfkCL3u/wqlMnZjUk4gZQH9rxG2e
        GgqTYheOC0RvkZKGndTjeqwCcXstbPvO11SDMY32haeFsun7tk3ha/moln5y1bWtV2loqQ
        jP9Zo1Ra3ohG5wd5GSw6O/PlJEvX35Q=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-r1sMNR0iOL6VwPGxGnRBDg-1; Thu, 08 Oct 2020 21:01:54 -0400
X-MC-Unique: r1sMNR0iOL6VwPGxGnRBDg-1
Received: by mail-pg1-f200.google.com with SMTP id j16so4280757pgi.3
        for <linux-xfs@vger.kernel.org>; Thu, 08 Oct 2020 18:01:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UWVGueE1ewfYhB1q7+ns2tEdz1obR+iAVyeQK6rww7g=;
        b=kwWGa3rZwltlbSblBtZg4RnrKuFkEVedPPYYuKK5FNlATPpQDy2OB7olMp194tPZ24
         S2VZKWzfhisODAtSXhFrINkhfqr+I8oyyhVJrYn4AypCgzVZbCBcrawHsqflXxXLYvSu
         fVFYOhh8xjXuETx1n5He1g/k0qlzxrjfZvD0UPq5xjBTRuiJNyu2tZtQw55nkuMS6mNQ
         lqwZ02i6aIdp8UyQ3R5pzWVY1bEzYjTI4FjMcv5+pvMQKZf38sKMB/m6z1coAXfUPvl4
         Tx6IiKsl+vefjGx270KgJ6UE1PRPrrfZ0VFiF29PQA0tCcuVY9OVVFMwKRN3QrW9l57u
         hUaQ==
X-Gm-Message-State: AOAM5327JIcOyZAx5amKsWW/1DmeNo8mIVcOP2gnPCa4oOAOWgsHm9Db
        wRTmwHAegphWHaRGZHr45RJygqCd6vqwSGccC0Ei2xZBeWlQo3v0r1dzDUrVCsVIMukh0gnhFeQ
        4/1r3MsR/9Ua24GPSHVZU
X-Received: by 2002:a62:1b02:0:b029:154:fdbe:4d2a with SMTP id b2-20020a621b020000b0290154fdbe4d2amr9911022pfb.27.1602205313734;
        Thu, 08 Oct 2020 18:01:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz2zfp/qCJeVaLJIGJXNoGRygv1HvWLFr8BTDLRVvCl+PCJdHFfUGMN3nZnVWtySqfdcTdOYQ==
X-Received: by 2002:a62:1b02:0:b029:154:fdbe:4d2a with SMTP id b2-20020a621b020000b0290154fdbe4d2amr9911006pfb.27.1602205313517;
        Thu, 08 Oct 2020 18:01:53 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 189sm8512971pfw.123.2020.10.08.18.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 18:01:53 -0700 (PDT)
Date:   Fri, 9 Oct 2020 09:01:42 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Gao Xiang <hsiangkao@aol.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v4 1/3] xfsprogs: allow i18n to xfs printk
Message-ID: <20201009010142.GC10631@xiangao.remote.csb>
References: <20201007140402.14295-1-hsiangkao@aol.com>
 <20201007140402.14295-2-hsiangkao@aol.com>
 <20201007152800.GB49547@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007152800.GB49547@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 07, 2020 at 08:28:00AM -0700, Darrick J. Wong wrote:
> On Wed, Oct 07, 2020 at 10:04:00PM +0800, Gao Xiang wrote:
> > From: Gao Xiang <hsiangkao@redhat.com>
> > 
> > In preparation to a common stripe validation helper,
> > allow i18n to xfs_{notice,warn,err,alert} so that
> > xfsprogs can share code with kernel.
> > 
> > Suggested-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> >  libxfs/libxfs_priv.h | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> > index 5688284deb4e..545a66dec9b8 100644
> > --- a/libxfs/libxfs_priv.h
> > +++ b/libxfs/libxfs_priv.h
> > @@ -121,10 +121,10 @@ extern char    *progname;
> >  extern void cmn_err(int, char *, ...);
> >  enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
> >  
> > -#define xfs_notice(mp,fmt,args...)		cmn_err(CE_NOTE,fmt, ## args)
> > -#define xfs_warn(mp,fmt,args...)		cmn_err(CE_WARN,fmt, ## args)
> > -#define xfs_err(mp,fmt,args...)			cmn_err(CE_ALERT,fmt, ## args)
> > -#define xfs_alert(mp,fmt,args...)		cmn_err(CE_ALERT,fmt, ## args)
> > +#define xfs_notice(mp,fmt,args...)	cmn_err(CE_NOTE, _(fmt), ## args)
> > +#define xfs_warn(mp,fmt,args...)	cmn_err(CE_WARN, _(fmt), ## args)
> > +#define xfs_err(mp,fmt,args...)		cmn_err(CE_ALERT, _(fmt), ## args)
> > +#define xfs_alert(mp,fmt,args...)	cmn_err(CE_ALERT, _(fmt), ## args)
> 
> AFAICT there isn't anything that passes a _() string to
> xfs_{alert,notice,warn,err} so this looks ok to me.  It'll be nice to
> add the libxfs strings to the message catalogue at last...
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Ok, assume that I don't have to update this patch
if my reading is correct. will resend this with
this RVB tag.

Thanks,
Gao Xiang

> 
> --D
>
 

