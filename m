Return-Path: <SRS0=lEGq=6I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DEC9C55191
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 10:07:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C1B52084D
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Apr 2020 10:07:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JZ246RQw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgDXKHl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Apr 2020 06:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726896AbgDXKHk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Apr 2020 06:07:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92536C09B045;
        Fri, 24 Apr 2020 03:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=JZ246RQwd02JYzuM1b+RWAonKx
        DRZ7L+Vv8fdC9oP+Qbe+SeM4qP3NoV8X75zGRQ3J0NeMljNN0+vSO3MjrySZvCBqkMyyFL1YVqI5F
        IT/0+sN9MLMAANiNydE4bIQQjyEWhXag+GtBIygYO3HwAfI+2F/aSKFzoDPTtXWif5SpyS+23Eo4P
        J4JJI9q8pQYSbswH+r7P5uIvhlrkw4izX15do9nrtNODLbb4FZKxbCQpeTIz5iKNvtQzSCNnPCmOU
        DVZaff8p6c92yuYhXj2w4y0IYHlRDm4n2zHRCYa9Scc0DL3BfRP4fKgbyk9+27p/gGhbuR1Ww8/m5
        CKUJDv7g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jRvFE-0000TJ-AP; Fri, 24 Apr 2020 10:07:40 +0000
Date:   Fri, 24 Apr 2020 03:07:40 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ritesh Harjani <riteshh@linux.ibm.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jan Kara <jack@suse.com>, tytso@mit.edu,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH 2/2] iomap: bmap: Remove the WARN and return the proper
 block address
Message-ID: <20200424100740.GB456@infradead.org>
References: <cover.1587670914.git.riteshh@linux.ibm.com>
 <e2e09c5d840458b4ace6f9b31429ceefd9c1df01.1587670914.git.riteshh@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2e09c5d840458b4ace6f9b31429ceefd9c1df01.1587670914.git.riteshh@linux.ibm.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
