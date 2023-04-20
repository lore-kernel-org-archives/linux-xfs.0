Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB430C77B73
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Apr 2023 23:22:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbjDTXWO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Apr 2023 19:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbjDTXWM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Apr 2023 19:22:12 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7FF21AD
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2023 16:22:10 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1a6f0d8cdfeso14751235ad.2
        for <linux-xfs@vger.kernel.org>; Thu, 20 Apr 2023 16:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682032930; x=1684624930;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QnnYgkdhK2vMLa7woEz3lD/OwPc0INzutZXuoY8Bt3A=;
        b=oBqkBWi39jM8nE2ILKXLGi4+cd38OisBserd32/LlNZpIYHCNohou2PZ7XHQtu4gVA
         GLkUmPg38Hu/9fWtiRr2y3SFQOQfnla0rP6GofePgyPj1B8PwpiPzeSlQcK/dSpYlYyg
         RXBV0V+f2ImOtAmBeb7QBml5zdvV+pzGZ1FwMUVmkm2pm3r7YLlQ3muCBL7st62HIRvs
         ZwKUVVzgaT0fFiiZ8rB7rMRlROnFaO9VcGEGH9iPqkhNZzcNEE/dBn/pRmSRsdUJHR+V
         t2M2lmeGHLUArk3jjL3ruH5xz8shZQ1O19JXEVwJrbHZMxmIFMyZpNGVRnET00cP/PXp
         KPXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682032930; x=1684624930;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QnnYgkdhK2vMLa7woEz3lD/OwPc0INzutZXuoY8Bt3A=;
        b=Bn9TknYNTya6Xwzi30ynvm4h+TMeGM7ucVn1UDJ7POI7KJQdzor3RVeNY6lnCkSc2x
         pCNcCGyik1CNuWejfHK5mTZstRw1aNPBbA0dzqFU5uFAt4+W8M3Q4DE53I3P6ysQ1g3b
         NDahJBhNHg5bZh+fCTe2HX+SdRFDNCJtC9SbAbSlOQIuqcmhw1wEoG8FXAH2Wr7CijwB
         KWOwxgQ8e9P+/9d70CD9Mqy5Sv1ZitpmQgKikpZtbAXyk/EnPL4wmEhORUxaC84Gc9Cl
         XSbSImhxAmH59asWir2Fc3VIAGIOuJAd2tt0j0GeaOsy8TUB2k7TlV7oKO09U7kg9T5/
         QloA==
X-Gm-Message-State: AAQBX9c/raKUbxTVAewvoQapjlT4qtww8rwLweXy/VjGaajEwGwMN1iZ
        zprcwhtmCqJlK1IJb5wE2eUkKQ==
X-Google-Smtp-Source: AKy350ZU7m6BpcjsM9NnfDADj3HLqDx0/Tsx13QE8E8znz7G9NSthaqG5xM2MZhhbEUkTepd+2SIYw==
X-Received: by 2002:a17:903:230d:b0:1a9:3b64:3747 with SMTP id d13-20020a170903230d00b001a93b643747mr2302821plh.17.1682032930287;
        Thu, 20 Apr 2023 16:22:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id y11-20020a170902864b00b0019c2b1c4db1sm1589735plt.239.2023.04.20.16.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 16:22:09 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ppdbL-005q1V-4J; Fri, 21 Apr 2023 09:22:07 +1000
Date:   Fri, 21 Apr 2023 09:22:06 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfs: IO time one extent per EFI
Message-ID: <20230420232206.GZ3223426@dread.disaster.area>
References: <20230414225836.8952-1-wen.gang.wang@oracle.com>
 <20230414225836.8952-2-wen.gang.wang@oracle.com>
 <20230419235559.GW3223426@dread.disaster.area>
 <71E9310C-06A6-41B9-AFE6-C8EE37CF5058@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <71E9310C-06A6-41B9-AFE6-C8EE37CF5058@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 20, 2023 at 05:31:14PM +0000, Wengang Wang wrote:
> 
> 
> > On Apr 19, 2023, at 4:55 PM, Dave Chinner <david@fromorbit.com> wrote:
> > 
> > On Fri, Apr 14, 2023 at 03:58:35PM -0700, Wengang Wang wrote:
> >> At IO time, make sure an EFI contains only one extent. Transaction rolling in
> >> xfs_defer_finish() would commit the busy blocks for previous EFIs. By that we
> >> avoid holding busy extents (for previously extents in the same EFI) in current
> >> transaction when allocating blocks for AGFL where we could be otherwise stuck
> >> waiting the busy extents held by current transaction to be flushed (thus a
> >> deadlock).
> >> 
> >> The log changes
> >> 1) before change:
> >> 
> >>    358 rbbn 13 rec_lsn: 1,12 Oper 5: tid: ee327fd2  len: 48 flags: None
> >>    359 EFI  nextents:2 id:ffff9fef708ba940
> >>    360 EFI id=ffff9fef708ba940 (0x21, 7)
> >>    361 EFI id=ffff9fef708ba940 (0x18, 8)
> >>    362 -----------------------------------------------------------------
> >>    363 rbbn 13 rec_lsn: 1,12 Oper 6: tid: ee327fd2  len: 48 flags: None
> >>    364 EFD  nextents:2 id:ffff9fef708ba940
> >>    365 EFD id=ffff9fef708ba940 (0x21, 7)
> >>    366 EFD id=ffff9fef708ba940 (0x18, 8)
> >> 
> >> 2) after change:
> >> 
> >>    830 rbbn 31 rec_lsn: 1,30 Oper 5: tid: 319f015f  len: 32 flags: None
> >>    831 EFI  nextents:1 id:ffff9fef708b9b80
> >>    832 EFI id=ffff9fef708b9b80 (0x21, 7)
> >>    833 -----------------------------------------------------------------
> >>    834 rbbn 31 rec_lsn: 1,30 Oper 6: tid: 319f015f  len: 32 flags: None
> >>    835 EFI  nextents:1 id:ffff9fef708b9d38
> >>    836 EFI id=ffff9fef708b9d38 (0x18, 8)
> >>    837 -----------------------------------------------------------------
> >>    838 rbbn 31 rec_lsn: 1,30 Oper 7: tid: 319f015f  len: 32 flags: None
> >>    839 EFD  nextents:1 id:ffff9fef708b9b80
> >>    840 EFD id=ffff9fef708b9b80 (0x21, 7)
> >>    841 -----------------------------------------------------------------
> >>    842 rbbn 31 rec_lsn: 1,30 Oper 8: tid: 319f015f  len: 32 flags: None
> >>    843 EFD  nextents:1 id:ffff9fef708b9d38
> >>    844 EFD id=ffff9fef708b9d38 (0x18, 8)
> >> 
> >> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> >> ---
> >> fs/xfs/xfs_extfree_item.h | 9 ++++++++-
> >> 1 file changed, 8 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
> >> index da6a5afa607c..ae84d77eaf30 100644
> >> --- a/fs/xfs/xfs_extfree_item.h
> >> +++ b/fs/xfs/xfs_extfree_item.h
> >> @@ -13,8 +13,15 @@ struct kmem_cache;
> >> 
> >> /*
> >>  * Max number of extents in fast allocation path.
> >> + *
> >> + * At IO time, make sure an EFI contains only one extent. Transaction rolling
> >> + * in xfs_defer_finish() would commit the busy blocks for previous EFIs. By
> >> + * that we avoid holding busy extents (for previously extents in the same EFI)
> >> + * in current transaction when allocating blocks for AGFL where we could be
> >> + * otherwise stuck waiting the busy extents held by current transaction to be
> >> + * flushed (thus a deadlock).
> >>  */
> >> -#define XFS_EFI_MAX_FAST_EXTENTS 16
> >> +#define XFS_EFI_MAX_FAST_EXTENTS 1
> > 
> > IIRC, this doesn't have anything to do with the number of extents an
> > EFI can hold. All it does is control how the memory for the EFI
> > allocated.
> 
> Yes, it ensures that one EFI contains at most one extent. And because each
> deferred intent goes with one transaction roll, it would solve the AGFL allocation
> deadlock (because no busy extents held by the process when it is doing the
> AGFL allocation).
>
> > Oh, at some point it got overloaded code to define the max items in
> > a defer ops work item. Ok, I now see why you changed this, but I
> > don't think this is right way to solve the problem. We can handle
> > processing multiple extents per EFI just fine, we just need to
> > update the EFD and roll the transaction on each extent we process,
> > yes?
> > 
> 
> I am not quite sure what does “update the EFD” mean.

Historical terminology, see below.

> My original concern is that (without your updated EFD), the extents in original EFI can be partially done before a crush. And during the recovery, the already done extents would also be replayed and hit error (because the in-place metadata could be flushed since the transaction is rolled.).
> 
> Now consider your “update the EFD”, you meant the following?
> 
> EFI:  ID:  THISISID1   extent1 extent2
> free extent extent1
> EFD: ID: THISISID1  extent1
> free extent extent2
> another EFD: ID: THISISID1 (same ID as above)  extent2

Yes, that's pretty much how multi-extent EFIs used to work, except
the second and subsequent EFDs recorded all the extents that had
been freed.  That way recovery could simply find the EFD with the
highest LSN in the log to determine what part of the EFI had not
been replayed.

We don't do that anymore for partially processed multi-extent
intents anymore. Instead, we use deferred ops to chain updates. i.e.
we log a complete intent done items alongside a new intent
containing the remaining work to be done in the same transaction.
This cancels the original intent and atomically replaces it with a
new intent containing the remaining work to be done.

So when I say "update the EFD" I'm using historic terminology for
processing and recovering multi-extent intents. In modern terms,
what I mean is "update the deferred work intent chain to reflect the
work remaining to be done".

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
