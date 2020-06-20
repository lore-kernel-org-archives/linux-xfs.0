Return-Path: <SRS0=7N5F=AB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 404C0C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Jun 2020 12:54:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F0D623B84
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Jun 2020 12:54:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cGlLtJQE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgFTMyU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 20 Jun 2020 08:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgFTMyU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Jun 2020 08:54:20 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174B4C06174E
        for <linux-xfs@vger.kernel.org>; Sat, 20 Jun 2020 05:54:20 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id s14so1129405plq.6
        for <linux-xfs@vger.kernel.org>; Sat, 20 Jun 2020 05:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=41DmdMBZf7hvhS20Pjpe+vKRUiRlr/hXNL2i6xCmWUk=;
        b=cGlLtJQE5iN/gCZ9w9aUFLtTXnTh+UZeXF+Re30ftxUFRr4UNVSodx80bIcrGPXKpW
         ZAAZlq1ciyOAXAofvrqFXdNDPQOcV0eK2ILJNSGH/X6C4hiXzs8Xb7nmMzjB7pz1vDHM
         vyw1Y01Ptik0zN0D2D+rx+xwxtOYiZi7kXYcP8CnN9lVq3ZUe/pXH7vnZkYeyuUZo+2x
         Ow7f5IQooSRZV7jiKvY4xNmB76QYPTbXG1yPqClG2WYsT488JOec8W6jNB0HbYhWsb1e
         VJqEVJNto/lnZ1jt93DvpQ0C+eYXj+wp5PzxL+uJKY6mK7FFusMKIM05wcntV2Q4vUnB
         wHIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=41DmdMBZf7hvhS20Pjpe+vKRUiRlr/hXNL2i6xCmWUk=;
        b=mDoib92ixobq0IiQrFiRWciqGn1iEOeIbiWstISAdeGCsxkcPHzfv/I/Vd1wYPE/Qx
         4YjigISgSEQbMPg1XejCVURb318VG3cXx042ZDVFLsfepu0omYb0J8ojkbdiewh9r6ff
         6rWhRs36p9zqY8dVHoAsYtigeNkxzcVSeJYRoebtQEmvRW2vZA6ScOvm6uQkHJYUiQuc
         SW3HbqPvI21C6ZEnESGTV2geXNDutGoXr0NntdphfHlCsvMoqw9yVsgUXOuCQ6qgKHue
         oO36E88SZzGaIauvGh526FhdOYtAmOFuHomE4B9JZ5b/JDBL2wWgir5gk9TD0NO+2YNa
         DVkQ==
X-Gm-Message-State: AOAM532ogNCQHl4OacSE7nVO7IssKcn8jC0c8QaQDZQrWQpDwVZge8hm
        RYGaBDANZqLcw4xM1hNapFbzeJqe
X-Google-Smtp-Source: ABdhPJyDPy7htWbsJo4o/HTJLsJun3HblvnIv6T0cSd98QEOKTUIgUsJsTlFRRdXfM6HL6iihg6WSw==
X-Received: by 2002:a17:90a:6047:: with SMTP id h7mr8261606pjm.145.1592657659692;
        Sat, 20 Jun 2020 05:54:19 -0700 (PDT)
Received: from garuda.localnet ([171.61.66.69])
        by smtp.gmail.com with ESMTPSA id fv7sm8035962pjb.41.2020.06.20.05.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 05:54:19 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        darrick.wong@oracle.com, bfoster@redhat.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 1/7] xfs: Fix log reservation calculation for xattr insert operation
Date:   Sat, 20 Jun 2020 18:23:22 +0530
Message-ID: <9772855.enW1IiravT@garuda>
In-Reply-To: <20200619143354.GA29528@infradead.org>
References: <20200606082745.15174-1-chandanrlinux@gmail.com> <20200606082745.15174-2-chandanrlinux@gmail.com> <20200619143354.GA29528@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Friday 19 June 2020 8:03:54 PM IST Christoph Hellwig wrote:
> On Sat, Jun 06, 2020 at 01:57:39PM +0530, Chandan Babu R wrote:
> > -		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
> > -				 M_RES(mp)->tr_attrsetrt.tr_logres *
> > -					args->total;
> > -		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
> > -		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
> > +		tres = M_RES(mp)->tr_attrset;
> >  		total = args->total;
> 
> tres can become a pointer now, and we can avoid the struct copy.
> 

Yes, you are right. I will fix this up. Thanks for the review.

-- 
chandan



