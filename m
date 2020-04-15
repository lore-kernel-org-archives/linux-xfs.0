Return-Path: <SRS0=6B5E=57=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14699C352BE
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Apr 2020 01:17:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E782B20774
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Apr 2020 01:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586913429;
	bh=Z8t12Kri4dLkYoQfBj9LeTBHSVbJC29k8QLFe4WYAn0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=Qr+to8BB2KCHeEuVBaa67Cc6D53KuvS4m/lDvTF+uAbawWOPtATLzqKRcMyJVOmdm
	 +fzXedVG+xWd57wZD4LqNkSAKik7mggTXAgn+yBur3LpVeQ4rapb2NYkwoLtOMiVt7
	 58hrCodhUDUFatGywqtNIik9yxh8lN8C5kH1gYhc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389058AbgDOBRJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Apr 2020 21:17:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388394AbgDOBRH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Apr 2020 21:17:07 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CD58206D9;
        Wed, 15 Apr 2020 01:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586913426;
        bh=Z8t12Kri4dLkYoQfBj9LeTBHSVbJC29k8QLFe4WYAn0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=trHGKNCxzakSMiiFFW7h7ipr5l5ZPqXMRMACUtk4YKpwd8Pg1RJ2PiBsRP5nCE9+1
         fCvzyZDvGOZsZH+JWcOhF2bmZOk4UdQ9IgBloKo9E4jlYJXAc0OSn746DXLsWt7WBJ
         s1ct6x0rSpHRCfj/HRWtfY1TDdkeieGLLTsLzoWE=
Date:   Tue, 14 Apr 2020 18:17:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com, linux-xfs@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        William Kucharski <william.kucharski@oracle.com>
Subject: Re: [PATCH v11 05/25] mm: Add new readahead_control API
Message-Id: <20200414181705.bfc4c0087092051a9475141e@linux-foundation.org>
In-Reply-To: <20200414150233.24495-6-willy@infradead.org>
References: <20200414150233.24495-1-willy@infradead.org>
        <20200414150233.24495-6-willy@infradead.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 14 Apr 2020 08:02:13 -0700 Matthew Wilcox <willy@infradead.org> wrote:

> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Filesystems which implement the upcoming ->readahead method will get
> their pages by calling readahead_page() or readahead_page_batch().
> These functions support large pages, even though none of the filesystems
> to be converted do yet.
> 
> +static inline struct page *readahead_page(struct readahead_control *rac)
> +static inline unsigned int __readahead_batch(struct readahead_control *rac,
> +		struct page **array, unsigned int array_sz)

These are large functions.  Was it correct to inline them?

The batching API only appears to be used by fuse?  If so, do we really
need it?  Does it provide some functional need, or is it a performance
thing?  If the latter, how significant is it?

The code adds quite a few (inlined!) VM_BUG_ONs.  Can we plan to remove
them at some stage?  Such as, before Linus shouts at us :)
