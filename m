Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26F64C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 15:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAD61207DA
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 15:18:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JoMw/62E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgHRPSI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 11:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728009AbgHRPRp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 11:17:45 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C87C061343
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 08:17:44 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id b16so21560243ioj.4
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 08:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SVpIcfB5YKrZrdTZOPcFIcbqyOfXnw+fMbUhkHSGJN0=;
        b=JoMw/62EWXC30zQga0Kb4qHhQTyZw8XGLevzhtEE3TfzvbyP3PlgVNk5Gwe5Kpj3eV
         GHP218uqO7qJSRdVdrt9+sc0QrCmjZLLRdfu5vbpwenhVd2UaQgPulX+fl85WkvEHyrO
         MZT5m8fovOM+fcfxBj0Le4JjHkEaguPUrcTE94odzJnnhmkdy4T0VRicN6ozcGG0yhFM
         fK7T+ZsVKtJchhEyTh/6GpsjkNuhMFYjylD/AByoLvmOyyyy1YdV6x1hUMKon05WCm5W
         iGy0y1KymHSKaVfZKpdpD4MKrDBCtGu4AJlkD8d53p5y6iR2iikBTDKx7GBLlKFH3U5Z
         0IFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SVpIcfB5YKrZrdTZOPcFIcbqyOfXnw+fMbUhkHSGJN0=;
        b=hLAYQzn9Hyiwg4KvKMEIDNHHDTGmS9wBbKCfiWqt5VmSxyeOn2s7MxdIGkcbKDcQqO
         kmmDJe10w5dQp8FW5W/devav10RUyfzEY7GMy06vRKVoOv3d9PDMJRAj7QsIUPvHl4To
         PylM3cHH+1hYB3npKA+PLIEDvaXpM3x7FUJ0nNX0O2SUOFlzNBKS1f6MPX6sL6H1Fny0
         z4KRiqBO+5BgUPjzGqii01w2GyuKT95qOvga+GIiHS37+AinW50t2V3GnF+oGeRluV1K
         THq3D0nDRAb0B/hmECQEqNOrB4GEiO4kljC0bPVznRYjVDm06O0e2ZMY2OQVvnkJW2bo
         ufeA==
X-Gm-Message-State: AOAM532tdCCi8J8sgGb17B2jQoHqiSkrs12t+zeTH3Qqe2IfBQDvTz/z
        iSMwJ+1c+4cdFqcui8wkG/Ptt8Q5EX3/9Gj474s=
X-Google-Smtp-Source: ABdhPJzAtYJU3Y4h7OFKDaBnLCzJ267pnMqDgf4qN5j07coYrsb2ZkyOqQcQNaNGOojzyuBAeGF0jorT3H8fdjP55VM=
X-Received: by 2002:a6b:5d0a:: with SMTP id r10mr16697681iob.186.1597763864114;
 Tue, 18 Aug 2020 08:17:44 -0700 (PDT)
MIME-Version: 1.0
References: <159770513155.3958786.16108819726679724438.stgit@magnolia> <159770523573.3958786.6421311732799623643.stgit@magnolia>
In-Reply-To: <159770523573.3958786.6421311732799623643.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 18:17:33 +0300
Message-ID: <CAOQ4uxgc2ch7f5-Z2gZ_tXF7y0PubTViZNvY0TwnpZ57=Q9BCw@mail.gmail.com>
Subject: Re: [PATCH 16/18] xfs_db: add bigtime upgrade path
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
> Enable users to upgrade their filesystems to bigtime support.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Nice!
I am going to pass on the review of the other two xfs_db patches.
Too much new code to read...

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
