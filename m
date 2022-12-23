Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CFD9C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Dec 2022 15:03:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236235AbiLWPDf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Dec 2022 10:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236265AbiLWPDe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Dec 2022 10:03:34 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC2526AA8;
        Fri, 23 Dec 2022 07:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DFJPFR+SJnh6z4cysrFzIrS+oSNgljKDxLqTaCKq2js=; b=p+0vAwgi1qjrkHCEaMe/+QZAyl
        9SSYjD35B5d5s1GwoNJschsSgxaBNV0uSZSAw01WRa7AMWFCHRvQ8WqnIstPgmLeoIQ+juUBb8ltU
        geImrfKJUWV+uK4nChya8+3eE+MhktXsVhwLrwyvC1s1XPtUh/MusDr5t4ctBKW+ozFFlSMxlc9w2
        /+NeyDAr2inyZpswIO4xHmlTLF/75D3ZuTl/WLeJE60Xk5mm9ybbSoAEFG8sb/DxhLOBerJCHVWdG
        ZJRziFM8j/lDdA7lXldZK+IP6eQpSEHK233hRtKcFywXmPZYFvNPCvpoC+WJMpceHcJUSUjrKP7bQ
        +SBgn6Hw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p8ja5-009Agu-00; Fri, 23 Dec 2022 15:03:29 +0000
Date:   Fri, 23 Dec 2022 07:03:28 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Andreas Gruenbacher <agruenba@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, cluster-devel@redhat.com
Subject: Re: [RFC v3 3/7] iomap/gfs2: Unlock and put folio in page_done
 handler
Message-ID: <Y6XDQBaPu+r5ledz@infradead.org>
References: <20221216150626.670312-1-agruenba@redhat.com>
 <20221216150626.670312-4-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221216150626.670312-4-agruenba@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A yes, this is what I meant in the second half of the last patch.
The page_done name is a bit misleading now, though.
