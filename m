Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E23BC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 14:04:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48B1B2076D
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 14:04:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ojDtMYoB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHROEi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 10:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbgHROEh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 10:04:37 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DA0C061389
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:04:37 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id u126so21157581iod.12
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H7LHGkajbJ0NF9GwsVZghOXQThaZ2PjByHWBTjSJk3c=;
        b=ojDtMYoBM4lLRMEQ0zKB3YTGB27Ic9/y0gPcTNSpH4ef/4fa4bJGeCW1+MaXhx8KNg
         T/WP73NXNmlOmsyN8SouFSGJG9Z+N7Nhvx62DMknRzGAWeMR6I0pTKfJA1rR51ofNAdF
         are8/2uEsW6ZAjA5lf8G0p5XMjXVpMcvstxYkDrhtxJuJJ7bJZED5PXkGVEMpgSlcUQB
         bxC+bDj4w/qtA9JwoOWMtFSJMr7bbStEKm/8jogitPfXDJO1tMxhVjREMg8Zi1Q2TVDO
         oGj5HKdQlY6dRlMBf0bDmWVeomS+f9dLKkQ3NOjQ2ZG2zLPl9vxUJECwMvkIYRf/onKJ
         WeLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H7LHGkajbJ0NF9GwsVZghOXQThaZ2PjByHWBTjSJk3c=;
        b=cDeRUEBMu+u3WcM56jGULvA8d+9/2R9h3sHFxxupfGcITuE7UFmpLciBQVScbcb/UM
         +4BGkU9M+yhn0CXp6nY7CCSSp5eRlapye822PUrGdvwKRWuTRyawxkoG2+ykoFA0lR47
         iLKdEmuaBvXkATdNXZtNFT1ovF3e4uU4DnNkl+lUBjlqeDgF7PBvEXqr0xm/7y77Fceo
         HDlZ6UfoHzwSvEnBOTRbshSYhwHxb+Yb4eucRtWoCbqFMwXLyT34lhhYA+GqAj/m2LnJ
         Oe5fKqCtoRmoEh+5We5MPOfrkoGFmvOnfndYj2Gf/uOlvcS5X7Ki7IQmsX+keRLJVkms
         GqqA==
X-Gm-Message-State: AOAM530VU/e3hrdDiEA+W5fSj3DQr84cbUKkRtYHNLXrgoT+EPoyqaIP
        9s4dr6jR2aJqqg3gMhU768Va1DZ/pJMz9ot72BI=
X-Google-Smtp-Source: ABdhPJwSwDzGSwRUwXgMRHujdmzokUt6i2tBF5BrR2lbSG2Gi+Z6ywbBocXAFTAbqeCMDx5kO9mFeG8dBALeahLFeLQ=
X-Received: by 2002:a6b:5d0a:: with SMTP id r10mr16465427iob.186.1597759476878;
 Tue, 18 Aug 2020 07:04:36 -0700 (PDT)
MIME-Version: 1.0
References: <159770500809.3956827.8869892960975362931.stgit@magnolia> <159770507797.3956827.9540093948962475663.stgit@magnolia>
In-Reply-To: <159770507797.3956827.9540093948962475663.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 17:04:24 +0300
Message-ID: <CAOQ4uxi8Nd5t=L4mSsOWZKBLu6S2-_ytnivMaQLbbmQsQD3cFA@mail.gmail.com>
Subject: Re: [PATCH 11/11] xfs: enable big timestamps
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 1:58 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Enable the big timestamp feature.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

No complaints here :)

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
