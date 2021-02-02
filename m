Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB965C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 07:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7742A64EC5
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 07:06:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbhBBHGK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 02:06:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232482AbhBBHGI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Feb 2021 02:06:08 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB32C06174A
        for <linux-xfs@vger.kernel.org>; Mon,  1 Feb 2021 23:05:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=O62ZR5p5aGor76ncnw28v38r1ovA9kE1ugxZSSiqPaQ=; b=sMOIHvwRPYAGoesiKXBqOMPRrU
        ESAC8uE2a2OGiNm3VfzBe6NlY58u3vKAL17v9O0tZ6G4g1454lE/UcmiL1JNnEZ0IU0YZL3ruRkZe
        PdegzkEZGZKom1qxnXFtIZC6jZz7grf6dJSde0s/yfqU1MBdOqeguNNUQSeSO0NYtaIc8kxm4EEsb
        378+WwKo3xski0InCBREwq0Ai2l9GjN8Izf/UVe6Z7ehReYyz++UKGukteUjm99pQCXH21kTrz+dT
        b6dx4EfcZLfLJrRMjlvvq7y+4fvuyh2emH/LHpKT1PJ7zQp4wcotT7DIC8WA1eIK6yijLzqkGUT/W
        PJm1uGzg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l6pkb-00Eq4r-65; Tue, 02 Feb 2021 07:05:25 +0000
Date:   Tue, 2 Feb 2021 07:05:25 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Subject: Re: [PATCH 14/16] xfs: remove xfs_qm_vop_chown_reserve
Message-ID: <20210202070525.GC3535861@infradead.org>
References: <161223139756.491593.10895138838199018804.stgit@magnolia>
 <161223147738.491593.3959130426904738389.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161223147738.491593.3959130426904738389.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 01, 2021 at 06:04:37PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that the only caller of this function is xfs_trans_alloc_ichange,
> just open-code the meat of _chown_reserve in that caller.  Drop the
> (redundant) [ugp]id checks because xfs has a 1:1 relationship between
> quota ids and incore dquots.

Awesome, this is so much better than what we had before..

Reviewed-by: Christoph Hellwig <hch@lst.de>
