Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BFF4C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 01:39:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF7BC20829
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 01:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730175AbhARBjK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 17 Jan 2021 20:39:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27644 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726592AbhARBjI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Jan 2021 20:39:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610933862;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=2Vu7Si28HREx62wxZBv5kaAMEvcAaz5qr3zQLzPGYHE=;
        b=RTpM5l7Z37bsm11X7bNTQkp5xlQVd/PlCgqxRITYH+8WMWYmtem9u9G3SXmRdtUFAalyGI
        Uf9rzQWx4doZg9Hl/zvVkfDIsXTgEubLyr9DpciVasGwwPM0Tayiatnt5JxF1bYozWhY5/
        mdWvy3kpJZ/SdbXJtg+Gc/k7/F1lIMQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-806c1T9YNKSn7bDQ1kYifg-1; Sun, 17 Jan 2021 20:37:38 -0500
X-MC-Unique: 806c1T9YNKSn7bDQ1kYifg-1
Received: by mail-ed1-f71.google.com with SMTP id a24so1834706eda.14
        for <linux-xfs@vger.kernel.org>; Sun, 17 Jan 2021 17:37:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=2Vu7Si28HREx62wxZBv5kaAMEvcAaz5qr3zQLzPGYHE=;
        b=ijS9Mv7LuFsMSDv4xlqch4n9i4jw1NIqeHCNRJmRfttqbQY2tiIYPd2idl77X4BI9U
         OcWIv5hendlLmSO8SxMgZ3xKYhRCRoAC+12fOiCutyd9afm8ccKHB85+nkfJ5cxDfDQw
         QecUWYIkU0ZmVvhj7wx5Ey7UcTW/lkjN58QXEBnwr4B6UzAxdsk0+v03BPh/hMgfGFX7
         aiOSwZGySxZENyZUN8elr8/vT8bAR9cFo1D4A2meabzOuS+pceXTLfrsd/pnZ3+4f30I
         ozRTPW2O/g3WbY/aY7VikNxsww2sv2VHEeX69iDqODkjJvB54b5CwTuV4ZzwK79SI4ML
         Gzhg==
X-Gm-Message-State: AOAM533USbnyR/splPt4s1//XraP7MMuysdi7e1+FGrgW+53KHbUab8E
        2h9dQjUq5zq82MJeD1ZniDIdoLc6Htt82M2gnz7L9+6IQ9cFyukz9D0ZKXGmOJSIMBZSqw2IU4+
        dzPCPdyOr2pMLQ/W71hOMkwbjEAZ/qTh0uXAH
X-Received: by 2002:a17:906:28d6:: with SMTP id p22mr11217956ejd.365.1610933857491;
        Sun, 17 Jan 2021 17:37:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwXKJJHcTwPmsRS5TkCq95iEGRfGU52tu/fIuDzfNVp/YeCBJoUrZcHizufaIiynnyQcnL5jaHkNBgCu+mAbJw=
X-Received: by 2002:a17:906:28d6:: with SMTP id p22mr11217949ejd.365.1610933857339;
 Sun, 17 Jan 2021 17:37:37 -0800 (PST)
MIME-Version: 1.0
References: <20210114183747.2507-1-bastiangermann@fishpost.de>
 <CAFMei7Pg2b1vs7WkV=JEUA_sZQ_8bedCaDcc+=eur-EaEwF7=w@mail.gmail.com> <24a4b41b-4af0-66ad-48c9-64e616c2ce4e@fishpost.de>
In-Reply-To: <24a4b41b-4af0-66ad-48c9-64e616c2ce4e@fishpost.de>
Reply-To: nathans@redhat.com
From:   Nathan Scott <nathans@redhat.com>
Date:   Mon, 18 Jan 2021 12:37:26 +1100
Message-ID: <CAFMei7M1OMCJ_8pcuGZRLtpy9aXHZQ+iRKDkDrz5zP+kqUZ3qg@mail.gmail.com>
Subject: Re: [PATCH 0/6] debian: xfsprogs package clean-up
To:     Bastian Germann <bastiangermann@fishpost.de>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Bastian,

On Sat, Jan 16, 2021 at 8:34 PM Bastian Germann
<bastiangermann@fishpost.de> wrote:
> [...]
> There is no point in adding me unless you allow uploads for my key
> 2861 2573 17C7 AEE4 F880  497E C386 0AC5 9F57 4E3A via
>

Will do, thanks for the pointer.

cheers.

--
Nathan

