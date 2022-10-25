Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 798BEFA373E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 18:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbiJYSu2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 14:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbiJYSuZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 14:50:25 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442CF45042
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 11:50:23 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id v4-20020a17090a088400b00212cb0ed97eso12698940pjc.5
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 11:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eMjT6X6JQcuWH5Lr8XaGHzrYawWF4Gr9sF6hPbgc2f8=;
        b=dE4wP7AWHcqQiiC0Ssrrru8sDrUjsEfgeiSTXzPOJu/BaJPaOUVgluc03eHS3poMDF
         Fa+cYQf5Gz9awcqgdmaWzEsFFIWN8qkvFrYPEhoSZS2zsxcMx1fsCs5zZnfBttXzGYTQ
         XOyPwMuEVSUJ1PmALOJnr2d9gzUE5br91EfWQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eMjT6X6JQcuWH5Lr8XaGHzrYawWF4Gr9sF6hPbgc2f8=;
        b=KYznkpC7WADxn6nYoi9ClJrJ+2AkZM6vFF9Zv+EPJBuiz/XqrFnychcmBlpi8rKgML
         2/CSA/jYiJE7wUVjuMjimczwG9lvRBgJrDUmyx30z185egohpwdtKkZOb+puBl5IiWUn
         0oAyfj1k/jajiPgTrd/dwD4UQ41BAo7bWMFrKwUsfAE2T31wI9TXASFfefplVAFysXxQ
         z3c3KBHt4rqmpFmC340KMns2m9h1BNMydLsnv8uvW4TSGp8RgphdfuCgRPxbBqGn6g0x
         hHgyoSu29gb2vz0/MwJhK7TGstMamBv/UXAdlEBdCvuaoqe9Wwf3CdzCNfklm9tb1Lbk
         U6Ww==
X-Gm-Message-State: ACrzQf05arm+ij8TkjjrTWf4E1nhlpdFkzxZKKr65+jJMJJNNAMKC9fF
        7fEh2X/n2lW9N3c5P0JMlgDQGGxLy07ccQ==
X-Google-Smtp-Source: AMsMyM5nbyrQU45w1ECz+c6B1TeNOmSwN66DumEhvx8iy5mGKoeOsvYZvPh1Aps2Njm9ThZ7JlfZlg==
X-Received: by 2002:a17:90a:ae16:b0:212:d2bd:82f0 with SMTP id t22-20020a17090aae1600b00212d2bd82f0mr27408257pjq.12.1666723822745;
        Tue, 25 Oct 2022 11:50:22 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902e80400b00178a9b193cfsm1511552plg.140.2022.10.25.11.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 11:50:22 -0700 (PDT)
Date:   Tue, 25 Oct 2022 11:50:21 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/6] xfs: fix validation in attr log item recovery
Message-ID: <202210251148.65450A2DBC@keescook>
References: <166664715160.2688790.16712973829093762327.stgit@magnolia>
 <166664715731.2688790.9836328662603103847.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166664715731.2688790.9836328662603103847.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 24, 2022 at 02:32:37PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Before we start fixing all the complaints about memcpy'ing log items
> around, let's fix some inadequate validation in the xattr log item
> recovery code and get rid of the (now trivial) copy_format function.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

I can't speak to the new checks, but yeah, the decomposition to a direct
check and memcpy looks correct.

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
