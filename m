Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6346AC43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 04:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1956F2074B
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 04:10:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pUpx2+3r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgIQEKO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 00:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgIQEKO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 00:10:14 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5DA1C06178A;
        Wed, 16 Sep 2020 21:10:13 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id c3so423443plz.5;
        Wed, 16 Sep 2020 21:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C0/mwsFxka30LQmyOb9S4ddGG+Qgynpnk45mvu0dvsE=;
        b=pUpx2+3rDdhhECu7HVCVWtZ8af1jhQCdOklQATzHshwL7um6POqFdwdMlYXrp3hqj0
         gOrbv41y3YOYTijCCjlLlENIeMYkEb3OCfRlZsfdaBSb5j6L5KiKXacPrbE0+JC3kyry
         LQDpXMk2pvvW38oQZMMMZSyrqiygJsDjGiS+HNguXA1gCzDpdG32/mVbhfEzfYmLK9DP
         b+Jz/5ufKNTLDh45MUMreK+mYhFx+YA6cwbC8QITd9srOtm7ZLBH85SBMns8j1+dnMoI
         3N5o2feFvBuEUrV9sn17TEtJ7MDi2lRhAE9Qwa2tfrFifG8gyzFMODuHwj0zxGeUwvE3
         6RyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C0/mwsFxka30LQmyOb9S4ddGG+Qgynpnk45mvu0dvsE=;
        b=O22wvxyMbOIbCICOVTDmfHnOMRFMMaYQBzFmdtcpI/PSFShCHOQe34E/6LO1pF6mlR
         u/dyZPPiqWZ0qLbQRRrhjjGjWCJy/AjZBBrDirJZbtlO3r7/sywHfIGOnqRPRuW2Y8JG
         jaIHXc4MLcYxNddv8PLRxdXMYhnrxzLznYAJT30UBqP1hsxOO4Sqaw9tybGOE0PllCnt
         ohQKcCIs3WcnHlzpFhCUm6xS7SIAIViAkwQMEXJ9yfBgPABN4OFdFpz3/Qs7a1jr3ULn
         AiPbeXvWRetw94OibEkc79Bb1qIHU1U15nXtiR6c4aGP4of/lt5+M01RZCB0PGaXenqC
         uClA==
X-Gm-Message-State: AOAM533gmpbVkVPBimlJsCDNPzgGee8dRvygwS7g49DR4ZLuh7tH0STb
        8OPcf4tAe/r3Cz12TVzzoUZqng58zbY=
X-Google-Smtp-Source: ABdhPJwlx+JaRWMvCJB1Ye/KYzS9Y/2YrjzwcC24CUyYrZifuLok1Rp166pqnHjJFrauz+vImQszRw==
X-Received: by 2002:a17:90b:1741:: with SMTP id jf1mr6600275pjb.164.1600315811165;
        Wed, 16 Sep 2020 21:10:11 -0700 (PDT)
Received: from garuda.localnet ([122.179.62.198])
        by smtp.gmail.com with ESMTPSA id 194sm17525412pfy.44.2020.09.16.21.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 21:10:10 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        guaneryu@gmail.com, zlang@redhat.com
Subject: Re: [PATCH 1/2] xfs: Add realtime group
Date:   Thu, 17 Sep 2020 09:40:02 +0530
Message-ID: <1900695.duUiiUEepb@garuda>
In-Reply-To: <20200916165142.GD7954@magnolia>
References: <20200916053407.2036-1-chandanrlinux@gmail.com> <20200916165142.GD7954@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday 16 September 2020 10:21:42 PM IST Darrick J. Wong wrote:
> On Wed, Sep 16, 2020 at 11:04:06AM +0530, Chandan Babu R wrote:
> > This commit adds a new group to classify tests that can work with
> > realtime devices.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  tests/xfs/group | 52 ++++++++++++++++++++++++-------------------------
> >  1 file changed, 26 insertions(+), 26 deletions(-)
> > 
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index ed0d389e..3bb0f674 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -67,7 +67,7 @@
> >  067 acl attr auto quick
> >  068 auto stress dump
> >  069 ioctl auto quick
> > -070 auto quick repair
> > +070 auto quick repair realtime
> 
> This test has an open-coded call to repair + rt volume, but is not
> itself a test of rt functionality.

That is true. I had decided to include this since it executed xfs_repair if
the scratch fs had a realtime device associated with it. I will remove it.

> 
> >  071 rw auto
> >  072 rw auto prealloc quick
> >  073 copy auto
> > @@ -87,11 +87,11 @@
> >  087 fuzzers
> >  088 fuzzers
> >  089 fuzzers
> > -090 rw auto
> > +090 rw auto realtime
> >  091 fuzzers
> >  092 other auto quick
> >  093 fuzzers
> > -094 metadata dir ioctl auto
> > +094 metadata dir ioctl auto realtime
> >  095 log v2log auto
> >  096 mkfs v2log auto quick
> >  097 fuzzers
> > @@ -119,7 +119,7 @@
> >  119 log v2log auto freeze
> >  120 fuzzers
> >  121 shutdown log auto quick
> > -122 other auto quick clone
> > +122 other auto quick clone realtime
> 
> This is an ondisk structure size check.  It doesn't test rt
> functionality, but I guess it doesn't really harm things to throw it on
> the 'realtime' pile.  I'm not objecting to this; it's just a funny
> thought I had while reading this patch.

I had decided to add this test to "realtime" group since it was checking sizes
of structures associated with realtime functionality. For
e.g. tests/xfs/122.out has,

sizeof(struct xfs_rtrmap_key) = 24                                                                       
sizeof(struct xfs_rtrmap_rec) = 32                                                                       
sizeof(struct xfs_rtrmap_root) = 4 

However, I think these structures are associated with a Btree that hasn't been
merged into the mainline kernel yet since I couldn't find them in the source
code. I was of the opinion that adding this test will be useful when the
corresponding patches get merged into mainline and test suite is invoked for
"realtime" group only.

> 
> (Not sure why it's in 'clone' either...)
> 
> >  123 fuzzers
> >  124 fuzzers
> >  125 fuzzers
> > @@ -128,7 +128,7 @@
> >  128 auto quick clone fsr
> >  129 auto quick clone
> >  130 fuzzers clone
> > -131 auto quick clone
> > +131 auto quick clone realtime
> >  132 auto quick
> >  133 dangerous_fuzzers
> >  134 dangerous_fuzzers
> > @@ -188,7 +188,7 @@
> >  188 ci dir auto
> >  189 mount auto quick
> >  190 rw auto quick
> > -191-input-validation auto quick mkfs
> > +191-input-validation auto quick mkfs realtime
> >  192 auto quick clone
> >  193 auto quick clone
> >  194 rw auto
> > @@ -272,7 +272,7 @@
> >  273 auto rmap fsmap
> >  274 auto quick rmap fsmap
> >  275 auto quick rmap fsmap
> > -276 auto quick rmap fsmap
> > +276 auto quick rmap fsmap realtime
> >  277 auto quick rmap fsmap
> >  278 repair auto
> >  279 auto mkfs
> > @@ -287,7 +287,7 @@
> >  288 auto quick repair fuzzers
> >  289 growfs auto quick
> >  290 auto rw prealloc quick ioctl zero
> > -291 auto repair
> > +291 auto repair realtime
> 
> This is a directory repair test, which doesn't exercise any rt volume
> functionality.
> 
> ...
> 
> FWIW I checked all the other tests that you added to the realtime group,
> and the changes I don't have any comments about all look ok to me.

Thanks for going through the list of tests.

-- 
chandan



