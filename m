Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DC6AC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 14:20:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFCAB207FF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 14:20:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pHYBPCM/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHROUH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 10:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbgHROUF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 10:20:05 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0DAC061389
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:20:04 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id q14so14299287ilm.2
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hfi7NRLCIY+iLkxXCqPle19tIZ96fZm6zgFRx+y20Do=;
        b=pHYBPCM/HG5HhyBWjQGe/xp365UD1v6orNppwml2qDVlyOHpEB7SH15czeF6wFUKMl
         IzmRRjYc2DzkW0o75tL7adAxdD5gPLhDUwtPzulIsOuXhsBMqId36+SgGZv2Gbitnpbx
         e0aQn/zcR8fJNrAsRsYUbFQnsX4C65aQievsNJpumVjvCa/RcEn2/aN6Noy3ntTnZ3dh
         6vvt52gf9tq4re2jAeRCrWL7Eg3xzlyto9HJK1OH3LFF02oghEmNtVeXY6Jx+3VATat2
         g5PW+AjBX3IUYjioNrZgOiAC+ImN9XGYLacFuGygXpKWZCSFjNepuXADp3C+L95PjRrZ
         I95A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hfi7NRLCIY+iLkxXCqPle19tIZ96fZm6zgFRx+y20Do=;
        b=q7UOW2CqhWkSfx9KUya45iCmnlNuDwHa5OkfxQn+/+X9dgi6GhvBiD8SWss5yWllEG
         +pKKmcoGr+leVN6+6e1Mqdbg28r8iOSOQcA4or3Us/fAuo8qVPB296UOGBk9JEHNEbYi
         fG0yR/Pmq2SsXmT3gRuBa/vV2Evho16X4gujmh721oY9qx11QoySWcElcKM/fqQcdS60
         6UhFNUktDO6ekPpCi4ZX17xvAdNqIrL1Ol3jBclgS/6RhEVXNCFKT0A66LdUEN6KnVtc
         UgPsgHYBAXe9tjSXSZlRSwl4vxFjfL2zno779WDXCFmOPnUA8dpanaxSZq0b2WLA0MCf
         XY0Q==
X-Gm-Message-State: AOAM533pOh2V7vzwhep9ix6hFUz1D1xGCVzxiQxxsziz5L2dV5CYi9nM
        nJ3Lm3pyNBJKB3JEPNY2budEU2nWR2XzQd+WYU8=
X-Google-Smtp-Source: ABdhPJzjjM6FaEX/R8J+DeKrgQjuOKV7f3Zt68sCWtFO9FJYeUSrE/mBaf+vsM8RzJfxIu0exUOAFM7KNGFLBPu/QUQ=
X-Received: by 2002:a92:1fd9:: with SMTP id f86mr18562599ilf.250.1597760404274;
 Tue, 18 Aug 2020 07:20:04 -0700 (PDT)
MIME-Version: 1.0
References: <159770513155.3958786.16108819726679724438.stgit@magnolia> <159770513983.3958786.6208814640295936803.stgit@magnolia>
In-Reply-To: <159770513983.3958786.6208814640295936803.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 17:19:53 +0300
Message-ID: <CAOQ4uxiQ2x8SjoeFCJFoLkssZyQsu64ZvM-AfKSiLBig=B8bDA@mail.gmail.com>
Subject: Re: [PATCH 01/18] libxfs: create a real struct timespec64
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 2:23 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Create a real struct timespec64 that supports 64-bit seconds counts.
> The C library struct timespec doesn't support this on 32-bit
> architectures and we cannot lose the upper bits in the incore inode.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Ok.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
