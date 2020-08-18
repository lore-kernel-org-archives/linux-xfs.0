Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34AFAC433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 14:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 144D6207FF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 14:26:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X9Ia7PRg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgHRO0v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 10:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbgHRO0v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 10:26:51 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F9BC061389
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:26:50 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id p18so13933079ilm.7
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7OMvF2gbRgxQ8tJVWnoAHMEPdQcByvJXKZWiBFBPt2o=;
        b=X9Ia7PRgFvKvmOrVcMopIYZ99LXK6Fcwkv3lc4ieDGEhE+7yMaBdrHi0xLXK9heUMR
         PzLba1piCbKy0wqt4Z/yk74KNKNMeKEMCZSiO6vi6ZaVrAi3nebs2HrUeDWi7Di3PqUG
         ap7udcEQN9pzqXlAZY5cm635QMeRD247cpvEmsnCUhlLHPettOmEH0K93C9oSUq4CnNa
         F+RNp8c5oPdMf/519Lgy5mt8QE+8p/SR2f6KXXjZLZNSNCpaFMPiRCPc9VH8Rn8Tggue
         h9wZljXP2PrEBkbLxd1jQ60/4h2kGb8Vs/+Fl/oZHpT+2efmjBBhLuok0W9o1fkck/Cv
         f/CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7OMvF2gbRgxQ8tJVWnoAHMEPdQcByvJXKZWiBFBPt2o=;
        b=NPFGF65iYnXh7Ysi4+FYmyW+Kai0giNG5+kwS2aspApo4uDjcDwgH6rPIi/nVlo0vN
         HjpLPH5hXTynzp2zG5YcuBxMwCUh8aJTlOzRMO8gdukLQ/oZXiqLFyN8JRODGpTs8fhP
         HmfU5bFir2ZKOuz9TESbndE6JYSf6EIoAILJASdR0hBID2L2xt4D5ZPuN1nqfsh306+/
         EINqS88kAUdh2JrY+S3T2JR/50di0/BbVKwd6WMpJZ/xxFHULA3Nt1I7qtdAw5QI1YdO
         C7JoCB0Ev1FxkX2rGkqIHIqZh7kCHAKBEeWOUbHmZts3MR8bF6wZjhO1qT0RoDZziJ9q
         GdHg==
X-Gm-Message-State: AOAM530mfTAzUS3DcF4DUYJ44Llc8je/xY/BwmFkdgzxCRNDWbiWb2CS
        H/hnALmKq/pI9gsTcXHlk8wuG9dClcoZIcMXn3U=
X-Google-Smtp-Source: ABdhPJwfTwmgwaZu6awBHEhEaLaDYa8Nn3ncvPznK2WWJyWhhf9RlNZkhrJGAlH+SrEM6+Qo9OBpHOis2CGuVtMmiaA=
X-Received: by 2002:a05:6e02:dc3:: with SMTP id l3mr18724378ilj.137.1597760810131;
 Tue, 18 Aug 2020 07:26:50 -0700 (PDT)
MIME-Version: 1.0
References: <159770513155.3958786.16108819726679724438.stgit@magnolia> <159770517167.3958786.5317029593308865611.stgit@magnolia>
In-Reply-To: <159770517167.3958786.5317029593308865611.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 17:26:39 +0300
Message-ID: <CAOQ4uxjFVhgfSYA=P9+w02PtTe=tsY_aMBBF14+AfeM9Ep5wJg@mail.gmail.com>
Subject: Re: [PATCH 06/18] xfs: move xfs_log_dinode_to_disk to the log code
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
> Move this function to xfs_inode_item.c to match the encoding function
> that's already there.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Again. strange commit message in this context, but fine.
I can understand the need for keeping the commit subject, but maybe
commit body could be adapted to what commit actually does?

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
