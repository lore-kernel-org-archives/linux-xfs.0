Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 138B1EE57E0
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Sep 2023 09:10:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240750AbjIHJKH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Sep 2023 05:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240567AbjIHJKG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Sep 2023 05:10:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6F41BFB;
        Fri,  8 Sep 2023 02:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SNFKFru0V8yFM5Jxy9HQDNqfkXEy96EgFoBM/yR0Dic=; b=vpKMwzJFIZmLAnoT8pEmaj+B9d
        QNeU6TLY1MwSVlwOJxnIWabYGk6FSzffxBZcaPywnEbC2fxeXkgoXrhbfJ/ubmJTdAsujLxMVZwzX
        MhfQuT/wTwBeABJ9wATpn/rIHXID+stqYJcu4/hSilmyFnveGqob1tMbj1S5AoKCIbfnonTghYEEE
        5dmzSby7AQPHenXASKZILG0aMSuM4l3Xz0GIpLs9TQadspYvE5GQiAVmlwYYHqamtl9/YhJHAvX9h
        vEeGGJGOJ0x7T3QRXs/FDuZdntYVW2AI4/TJTKA1L4dTEn+kTBgprG3xZbWFDV0Y0dDP/Ds96+yHv
        09W4wg1w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qeXUt-00DNXn-1d;
        Fri, 08 Sep 2023 09:09:51 +0000
Date:   Fri, 8 Sep 2023 02:09:51 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: Use rwsem_is_write_locked()
Message-ID: <ZPrk3yIrhA8usrgX@infradead.org>
References: <20230907174705.2976191-1-willy@infradead.org>
 <20230907174705.2976191-4-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230907174705.2976191-4-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 07, 2023 at 06:47:03PM +0100, Matthew Wilcox (Oracle) wrote:
> This avoids using the mr_writer field to check the XFS ILOCK is held
> for write.  It also improves the checking we do when lockdep is disabled.

Hmm, is there any reason to keep the lockdep-based version of
__xfs_rwsem_islocked around now at all?
