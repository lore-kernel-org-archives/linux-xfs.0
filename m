Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B40A0C76195
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Mar 2023 01:48:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbjC1BsA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Mar 2023 21:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbjC1Br7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2023 21:47:59 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E95101;
        Mon, 27 Mar 2023 18:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=hWmz1DT/D0alorn1x9sz798j2olMoW+klvejJUS31so=; b=SuVjU+6ofyW0/e9Hj4d6xtgY9F
        EBK/Nv+s2RuRGdWplvT5uPUxiB9QUmrOoQHgVWozWaedbl2/JFvtogr6P2PJmYSz7ga6B2LAshpEM
        o+EVshdlpqaNLiu181PNvwJSNYvKMkQliWr1JhaDgD8dG860Dg82St3wXPkM6okZWMYbmJUT/gm+w
        WIntnXFBF3RYAdbkqfLerbEzC6hN3cjajiAueduYg7k38mETdEDHphsEk3ZLP6ldaUSNlYPZDFpV6
        JP0JcQnfap8r+ddpFtxvLWuBkjCLCVVPTeDAEgJ8tHZ11XFd44iNMKci571W6Hjn8RqH46X3bNOBx
        7mv1pCpA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pgyRG-00CopA-0N;
        Tue, 28 Mar 2023 01:47:54 +0000
Date:   Mon, 27 Mar 2023 18:47:54 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     "yebin (H)" <yebin10@huawei.com>, Ye Bin <yebin@huaweicloud.com>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix BUG_ON in xfs_getbmap()
Message-ID: <ZCJHSsqk4SJEDOTC@infradead.org>
References: <20230327140218.4154709-1-yebin@huaweicloud.com>
 <20230327151524.GC16180@frogsfrogsfrogs>
 <64224406.5090106@huawei.com>
 <20230328014328.GG16180@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328014328.GG16180@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 27, 2023 at 06:43:28PM -0700, Darrick J. Wong wrote:
> <shrug> Seeing as the data fork mappings can change the instant the
> ILOCK drops, I'm not /that/ worried about users seeing a delalloc
> mapping even if the user requested a flush.  The results are already
> obsolete when they get to userspace, unless the application software has
> found another means to lock out access to the file.

That is true, but then again the users asked to not see delalloc
mappings, so we really shouldn't report one, right?
