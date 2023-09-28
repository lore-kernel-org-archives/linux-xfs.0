Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F7C3E743C8
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Sep 2023 22:44:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjI1Wou (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Sep 2023 18:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjI1Wot (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Sep 2023 18:44:49 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8614C180
        for <linux-xfs@vger.kernel.org>; Thu, 28 Sep 2023 15:44:48 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-692d2e8c003so35640b3a.1
        for <linux-xfs@vger.kernel.org>; Thu, 28 Sep 2023 15:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1695941088; x=1696545888; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=woapVQlEUE+hfmrPjf/vANLkqwMvK9Wk7ysvsQvDHpQ=;
        b=ZL2ab0cXUEFK6TdwFv6KkKd9zEQ/8gTJIRX8dvNfpZtgjQwzEEewo4ulSh03XOoRoP
         vU01moJ5p1ZErkBsfiXkCtxBzRy6tWSKYCvM0CDslUB4qD+tDGq44v0Y0M1EVw7WHLd0
         xRzHcgtXqfPkBvbsRwUTeKcA+F2HORSYm6I0HwB7XAVK96fJxCJp6ixOwf9kZg+ba/aq
         dWpa40B/pftm8GHC/F/QdNJsCQxBhiAMdTSDHNcCu0qD/+KqeMoHap6TIfm5icuN70E9
         anyKQosgHHBmselE0vvc7ffGF6AMsD3VuApE2raT3IuBLodkY9X1Sew/vErk1IZ5DyiO
         Pruw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695941088; x=1696545888;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=woapVQlEUE+hfmrPjf/vANLkqwMvK9Wk7ysvsQvDHpQ=;
        b=hiv1ik8JghA+AvP83xwEzvUptSmQcz6R+ZlEZlRb8bREdWY7vw5UzKywo0CkClPDru
         oJg/0Y536e7noMiAU/wID1Yqa9xqC5pfdhuCyno1X4XyS24/P0Kezh264Ot52h89ontK
         RezxWw00a9VMR4hYvvgcYsHNI2OLQlGkOphOTU/DkQAkaFxIzniAXZO7CfK8TWPq7w35
         yjQSf5LR00FAecfytj+hs9+Os7WXYGpr6ASIuiwPfHS7I88/3XwZvV5/7/g1WCih9bd9
         sblt+A/r4yR+0EvxhhCzZMZJ2ZsD20cBQ/1Hdyyqk8KLVrqA6tJMnkJPxXCIA0IsubhF
         1aFg==
X-Gm-Message-State: AOJu0YxL16sdFA0Fut9o0pZYeiQ9QhtEFm9G0l3DQKsQnXEbEAay4q55
        smpD5A09GNDXIvB/EU15RCwUbRBTVQGyW2noNPQ=
X-Google-Smtp-Source: AGHT+IG1yKh++DLAvDLapt3uKt3onowhWrQjE3T4Nk94+ZBeCfPsUOpHxOcHO3uuMBC+kpr7JBYq/w==
X-Received: by 2002:a05:6a20:1604:b0:161:f7c3:29c2 with SMTP id l4-20020a056a20160400b00161f7c329c2mr3613640pzj.11.1695941087985;
        Thu, 28 Sep 2023 15:44:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id u25-20020a63a919000000b0057ab7d42a4dsm13110833pge.86.2023.09.28.15.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Sep 2023 15:44:47 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qlzkR-006tyF-1j;
        Fri, 29 Sep 2023 08:44:43 +1000
Date:   Fri, 29 Sep 2023 08:44:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 217572] Initial blocked tasks causing deterioration over
 hours until (nearly) complete system lockup and data loss with PostgreSQL 13
Message-ID: <ZRYB26fsNaau3/df@dread.disaster.area>
References: <bug-217572-201763@https.bugzilla.kernel.org/>
 <bug-217572-201763-z2qkmBIoaL@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-217572-201763-z2qkmBIoaL@https.bugzilla.kernel.org/>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 28, 2023 at 12:39:05PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=217572
> 
> --- Comment #10 from Christian Theune (ct@flyingcircus.io) ---
> @Dave I've seen this a second time now today. It also ended up being a copy
> statement with postgresql and I'm going to take a consistent snapshot of the
> full disk right now.

Have you tried seeing if commit cbc02854331e ("XArray: Do not return
sibling entries from xa_load()") fixes the problem? That has been
marked for stable, so I'd expect that it eventually makes it back to
6.1.y or whatever LTS kernel you are running now....

As for debug, this isn't an XFS problem - it's a page cache problem
when high-order folios are in use (which XFS uses) - so you need to
be looking at in-memory page cache state that is being tripped over
first....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
