Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D81DC54FD0
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 12:28:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69BA720575
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 12:28:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="h4uZN/H6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgD0M2l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 08:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbgD0M2l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 08:28:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91EAC0610D5;
        Mon, 27 Apr 2020 05:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Wzixkdd1MP05tKyiJudvvJUbNJ4oUXlhwu6lo0T90lk=; b=h4uZN/H6Mu3d0zPdDsclCVH32p
        44gY3nD6XgbLkqBBMl44AzSP/BJE3KBzRAPQwmBogEvavTEhIQUL3ocaF+cw7UkzuVAwITD4seBgk
        Pp8Hl1+tIQ8RODfstqU0/krSNx7E830cBVrxSyf5dfg0gpQoKrJKe2M5AynwMKOl0n3mi6Pl4oFKf
        efaEddM5vpsfG757hkc2v8IEonhVlf8jAZ4wp/U05w15FPDDSa7fkY0VDdkD1WHqV691GKsmZEkS8
        SOQI03I+FKN/fUWcflc8dcvjdXytbEbhLDXDLTXiJZruWD/RddNBs2RHT5uDy951iViKV1ctgL7yg
        iJXmOD4A==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jT2sG-0003WE-Dr; Mon, 27 Apr 2020 12:28:36 +0000
Date:   Mon, 27 Apr 2020 05:28:36 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Cc:     linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, darrick.wong@oracle.com,
        dan.j.williams@intel.com, david@fromorbit.com, hch@lst.de,
        rgoldwyn@suse.de, qi.fuli@fujitsu.com, y-goto@fujitsu.com
Subject: Re: [RFC PATCH 0/8] dax: Add a dax-rmap tree to support reflink
Message-ID: <20200427122836.GD29705@bombadil.infradead.org>
References: <20200427084750.136031-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427084750.136031-1-ruansy.fnst@cn.fujitsu.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 27, 2020 at 04:47:42PM +0800, Shiyang Ruan wrote:
> This patchset is a try to resolve the shared 'page cache' problem for
> fsdax.
> 
> In order to track multiple mappings and indexes on one page, I
> introduced a dax-rmap rb-tree to manage the relationship.  A dax entry
> will be associated more than once if is shared.  At the second time we
> associate this entry, we create this rb-tree and store its root in
> page->private(not used in fsdax).  Insert (->mapping, ->index) when
> dax_associate_entry() and delete it when dax_disassociate_entry().

Do we really want to track all of this on a per-page basis?  I would
have thought a per-extent basis was more useful.  Essentially, create
a new address_space for each shared extent.  Per page just seems like
a huge overhead.
