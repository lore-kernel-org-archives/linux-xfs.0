Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07096C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 20:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD03161075
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 20:35:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbhHSUgQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Aug 2021 16:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbhHSUgQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Aug 2021 16:36:16 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF03CC061756
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 13:35:39 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id w6so4615188plg.9
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 13:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2lq1/9dzMwse8hgj+nLsRtNNVHy5Ra8cI/pFGIqflik=;
        b=2RKmo3Q2iKNSxDasfmEsswnoQ8z3YAyLtAaZ/HjlU037dI8WGM89auY+HT0DGdfQG5
         U/MVHxJdBMIcF+Bd+xSvtL95UEX2dwFl/L/z3oPUnO/aigHxiu57hkL3swk7sYKK8eoK
         OPWWqbTNA4eO3pFQE3oPGvv1E3fjsnrOGOVy65plV9Zqf0TYsbeSGghf1ADPutP9iZR1
         5qcOPhlcQ0vwLOx7+tVxh274/kANbc4PzXIIj1zUrQt/iw6E5iILNWMZccVLZCykIsql
         szt7T9dgmeVXyvOI4dVbuIMMnv9/0iFbmrxmbHF8Fdu9z40bAQVIYwD2gzFvHS2c+7l1
         Qchg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2lq1/9dzMwse8hgj+nLsRtNNVHy5Ra8cI/pFGIqflik=;
        b=rCbIDtndZrpxDZAadimudBKqKniGJx/i96AAyNA4J2j43EhaeHpkkC8YrEyXYSGwVE
         PT1P05feXjJSVjMHvRd4PPF9+1XHv9PmPJPsSbXb6PFMQUW/HnUSsU90rqYfEIuoFWJk
         0Rx16GE5HpxPprchwvgcHcOWWP5vCzkMuCkKM+Ar/+i3+MwIOoB59Szu8/OEFxYz3rP/
         5D9ZaAhbIxERGESXHN58j/dvMYOGSKTvtIFCXsyIQg1MtkKBfWnDAR8anOyrqdt9meGD
         JlUtsWpmSGHDVWkdLB5NgabL6HaCuN/YJqA8BX2F1VKId7EcxbxzSQQRFNTQldB53630
         ZyAw==
X-Gm-Message-State: AOAM532fZTJyK2D86l6HfRR8D+H+2FtDfi2XOIcA+QKM6BJbuOZPnpCJ
        l70Fux91xTd5ctDGOeKw51siU0d+OyMM0mDHnmSlOA==
X-Google-Smtp-Source: ABdhPJxSp6xtccEDJJJY44GOHyKJniTxZ6vHD+7V+PQJrY3uECT6oRKOpiFktsbnpDGqKIO/PuciS0G+rhFl437R2uk=
X-Received: by 2002:a17:90a:708c:: with SMTP id g12mr628765pjk.13.1629405339323;
 Thu, 19 Aug 2021 13:35:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210809061244.1196573-1-hch@lst.de> <20210809061244.1196573-8-hch@lst.de>
In-Reply-To: <20210809061244.1196573-8-hch@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 19 Aug 2021 13:35:28 -0700
Message-ID: <CAPcyv4iRUYcZAMgiDLXDW-bRZxeRzAnWOgNJ4UL==CQX83_jxQ@mail.gmail.com>
Subject: Re: [PATCH 07/30] fsdax: mark the iomap argument to dax_iomap_sector
 as const
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>, cluster-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 8, 2021 at 11:19 PM Christoph Hellwig <hch@lst.de> wrote:

I'd prefer a non-empty changelog that said something like:

"In preparation for iomap_iter() update iomap helpers to treat the
iomap argument as read-only."

Just to leave a breadcrumb for the motivation for this change, but no
major worry if you don't respin for that.

>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Otherwise, LGTM

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
