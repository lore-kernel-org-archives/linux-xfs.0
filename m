Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60108C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 16:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A8336198E
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 16:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhCVQve (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 12:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbhCVQvG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Mar 2021 12:51:06 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD698C061574
        for <linux-xfs@vger.kernel.org>; Mon, 22 Mar 2021 09:51:05 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id z9so15457824ilb.4
        for <linux-xfs@vger.kernel.org>; Mon, 22 Mar 2021 09:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=IOsQb5jlH8Eo6j++D8ki5e+RXoyG2ym37A0foUIu+Pg=;
        b=bNwo04fmqUSy2wfsN6Uz1t1pcuR4ZjA0X6W+a2DGAxHykb+5KCbp2M485tWBMB+Erb
         +C3Ej3j/8LyZgFpXIrwBTDQCx+KHiNuBI3iEhZXYUVBj2Lhtqk22UylUOnQNsoZn9Nzv
         nCDh/X1cDZOeMAE72jw+yIKM15BbgbJwG0rnMQRxxjFgJhsbhq9RkfLbyBq/HSh3rTfD
         dvLijZKRoo0OyhVvsqLIdbVbTe2X31EZbVvAYHJfkhxq9oKAi4s+osWFeYbwiqvVB0Np
         hGkWbsxBRv+4FH6ousxFJkG0epGI/T7PN7BtZNCl+RHL7AAsc/fIoWunDp1RzU5d94T0
         RLNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=IOsQb5jlH8Eo6j++D8ki5e+RXoyG2ym37A0foUIu+Pg=;
        b=mKlFAM+m2oiIrSFJOOP/rJSWIl0es//aiMoJ73Yz0k/Mbg9bF9oZJl+5jFMvtOP4+c
         7OQaFGr8EL2pibkA/P30GJEuJr7+e0drunduIn/0dYQMN8YgDwSl/fDJ/saBFNBSKkUP
         7rKOIQIbsyQ1uJflk6W4fKdr8FjPF233jbSNbag1N8Ht5Mx3GOrjRDnAJsgK2T3sgi5a
         hGXaFyJf1SjTdt4niVu/vyujndY/yBpkL4dwM/VY1eEPR4Vv/eSfQWD1zjtdAUI3TZ/8
         0t+qL/VKXXAFcWJ5Ap137P0L+UOX75JUVmgo1T6gpoA2GkG8cK63bTvFAFbYz2brRZLr
         +uLw==
X-Gm-Message-State: AOAM533U6STuoWbkt8bHyNw+OYHsGEML7Cq+NaoXMvoSglA0wt3Kfzt2
        zPPy58UrEtq7HfAwltGGMQQRt2AjcJvStYjFiwIVKoQ1lRs=
X-Google-Smtp-Source: ABdhPJxkLWPenbbnyIxq6dTwdosP4sYYLi6+CQtAnzPKinfk3n6p2xmS39Z0RPFnCJTMc5zkTv1DbTYzZjLiPgeH2RU=
X-Received: by 2002:a92:cd0c:: with SMTP id z12mr774245iln.109.1616431865320;
 Mon, 22 Mar 2021 09:51:05 -0700 (PDT)
MIME-Version: 1.0
References: <CANSSxym1ob76jW9i-1ZLfEe4KSHA5auOnZhtXykRQg0efAL+WA@mail.gmail.com>
In-Reply-To: <CANSSxym1ob76jW9i-1ZLfEe4KSHA5auOnZhtXykRQg0efAL+WA@mail.gmail.com>
From:   =?UTF-8?Q?Ralf_Gro=C3=9F?= <ralf.gross+xfs@gmail.com>
Date:   Mon, 22 Mar 2021 17:50:55 +0100
Message-ID: <CANSSxy=d2Tihu8dXUFQmRwYWHNdcGQoSQAkZpePD-8NOV+d5dw@mail.gmail.com>
Subject: Re: memory requirements for a 400TB fs with reflinks
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

No advice or rule of thumb regarding needed memory for xfs_repair?

Ralf


Am Sa., 20. M=C3=A4rz 2021 um 19:01 Uhr schrieb Ralf Gro=C3=9F <ralf.gross+=
xfs@gmail.com>:
>
> Hi,
>
> I plan to deploy a couple of Linux (RHEL 8.x) server as Veeam backup
> repositories. Base for this might be high density server with 58 x
> 16TB disks, 2x  RAID 60, each with its own raid controller and 28
> disks. So each RAID 6 has 14 disks, + 2 globale spare.
>
> I wonder what memory requirement such a server would have, is there
> any special requirement regarding reflinks? I remember that xfs_repair
> has been a problem in the past, but my experience with this is from 10
> years ago. Currently I plan to use 192GB RAM, this would be perfect as
> it utilizes 6 memory channels and 16GB DIMMs are not so expensive.
>
> Thanks - Ralf
