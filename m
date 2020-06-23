Return-Path: <SRS0=nlsN=AE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 962EEC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 22:52:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68F7E20874
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Jun 2020 22:52:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lca.pw header.i=@lca.pw header.b="QWQq5RDG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387765AbgFWWwU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Jun 2020 18:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387717AbgFWWwT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jun 2020 18:52:19 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21617C0613ED
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jun 2020 15:30:03 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id f18so106268qkh.1
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jun 2020 15:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=eaPZgevT2CpnMUUM+GmJp3ep826/Vu8USLaTW1XXGMw=;
        b=QWQq5RDGTnwX3WnqevkbBWkazZh8odQfl932pZ3UbY0dCGQegngCVgx95WkZVr6BnO
         65ZIHrqmao0uN6GenF/4y4CW/OcmRkJXPzNKvRDmcXb7ZC7erhMA93XdDlwZ6l3vBF1f
         GxHnbtJycGks7s5BOlmqFZKUgWd+grPqJxni7VbGgMA8zUApStYLutkeT0rlrIBOHI08
         3Cql55Igvie4tl+36H8VyJCyQqgV0RR76/eI9IGW+so79IAWGhwE2UWaR81yETHij9Y+
         SmTPqigtUan78yqLcCU63BGCxEuDALLbhJ89gWLbCtwqVG4DBdoucn263Wyo8rE2fDql
         8TgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=eaPZgevT2CpnMUUM+GmJp3ep826/Vu8USLaTW1XXGMw=;
        b=OgouDVi9Jp923xdF1fPZ5lKF4ZQSfzmBn+Ai9fVeT1caPsCsLgqR5dQBs6O5cj4pPC
         liVvfg5DRU16h58uAZ0F0uWm1914AavCzJgdKwUVInxoKZ1w3rykJrigKl5w33KlMyrB
         Ozl/nsxZ+KbX2ti4BPNIUZEaTv+CqQhYQFF3he0U2LAQYje8G9dm4M+TlNQCo5bfv8EU
         ySMSHm3/8jqj2pc0iWwd7PqpypINwMxpxIMZHrCpwslnAY8GJ6FSvLyoyAarpFCfNmK4
         H5q1ic+Ij0ek0T/D9l60F66JWEpZk8TAWy9jswtVWR92rYRMeHmSFHMC4j2jOqROxFTM
         iJrg==
X-Gm-Message-State: AOAM530jtIwxzytK9gY9t1+4BO//hN5DmOPP0alF9NeElxQTZVBMBPyJ
        NPeBmPngDhB4v3Smpv+1PbUSNTkVvVnmJQ==
X-Google-Smtp-Source: ABdhPJwk15aS1BWBT2iEbMasfTOJdZ8L9kYNLCwIeSkqEjFH3YWtkSFhBbq1XdpbSIFrixrWCXSxpg==
X-Received: by 2002:a37:5ac1:: with SMTP id o184mr6623255qkb.498.1592951401983;
        Tue, 23 Jun 2020 15:30:01 -0700 (PDT)
Received: from ?IPv6:2600:1000:b118:1dc0:18a:ef24:8000:54d8? ([2600:1000:b118:1dc0:18a:ef24:8000:54d8])
        by smtp.gmail.com with ESMTPSA id 207sm1764428qki.134.2020.06.23.15.30.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 15:30:01 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Qian Cai <cai@lca.pw>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] mm: Track mmu notifiers in fs_reclaim_acquire/release
Date:   Tue, 23 Jun 2020 18:29:58 -0400
Message-Id: <CBC5DC63-241C-4291-8686-21CF758AC91B@lca.pw>
References: <CAKMK7uH90-k12KMHE0pWN6G_aCTr=YNhQsqoaAJC5FHygnf96g@mail.gmail.com>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        =?utf-8?Q?Thomas_Hellstr=C3=B6m?= <thomas_os@shipmail.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Linux MM <linux-mm@kvack.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        =?utf-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        linux-xfs@vger.kernel.org
In-Reply-To: <CAKMK7uH90-k12KMHE0pWN6G_aCTr=YNhQsqoaAJC5FHygnf96g@mail.gmail.com>
To:     Daniel Vetter <daniel@ffwll.ch>
X-Mailer: iPhone Mail (17F80)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



> On Jun 23, 2020, at 6:13 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
>=20
> Ok I tested this. I can't use your script to repro because
> - I don't have a setup with xfs, and the splat points at an issue in xfs
> - reproducing lockdep splats in shrinker callbacks is always a bit tricky

What=E2=80=99s xfs setup are you talking about? This is simple xfs rootfs an=
d then trigger swapping. Nothing tricky here as it hit on multiple machines w=
ithin a few seconds on linux-next.

> Summary: Everything is working as expected, there's no change in the
> lockdep annotations.
> I really think the problem is that either your testcase doesn't hit
> the issue reliably enough, or that you're not actually testing the
> same kernels and there's some other changes (xfs most likely, but
> really it could be anywhere) which is causing this regression. I'm
> rather convinced now after this test that it's not my stuff.

Well, the memory pressure workloads have been running for years on daily lin=
ux-next builds and never saw this one happened once. Also, the reverting is O=
NLY to revert your patch on the top of linux-next will stop the splat, so th=
ere is no not testing the same kernel at all.=
