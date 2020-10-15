Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3705DC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 08:36:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92A7F2075B
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 08:36:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Rv40hzKt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730376AbgJOIg1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 04:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730374AbgJOIg1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 04:36:27 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F625C061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 01:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=Rv40hzKtgT4T4vQ/X8gYZXhvzO
        y2ZLEgiYwsFqrR50FvzWjoAV1t2gsvzURlaBnoQK/lNcasf5H/KMcuzQDaqQBhepzKKQYjvIDxEEu
        yyfnv32/D4jtkdiIrUMRR3rc1LT3kWmN/Ga4nHR66kIY0QKFPMYaYt4tkCRaUvDXc26a4y4+9m/YY
        6us+qlM+Yj0npBsZLw6IscNKIjLsmDxhXaUDmEvakA7S2fi3G69FHffboww992ttTNo6frwg7sgcD
        VVLdLn1K6QrcYMgjnmAr/SPVgIKDwngowas5W1Rf4MxX7Btv24UVtjPOCLOyV44IZ2PEvvX+ORKAT
        9OTn4Q5w==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSykM-0001sE-5V; Thu, 15 Oct 2020 08:36:26 +0000
Date:   Thu, 15 Oct 2020 09:36:26 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: Re: [PATCH V6 05/11] xfs: Check for extent overflow when
 adding/removing dir entries
Message-ID: <20201015083626.GE5902@infradead.org>
References: <20201012092938.50946-1-chandanrlinux@gmail.com>
 <20201012092938.50946-6-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012092938.50946-6-chandanrlinux@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
