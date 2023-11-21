Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F1A2C61D85
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Nov 2023 04:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjKUEes (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Nov 2023 23:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjKUEer (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Nov 2023 23:34:47 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7781983
        for <linux-xfs@vger.kernel.org>; Mon, 20 Nov 2023 20:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=YPA35SjscLRps4ecFHEgmB5g5C
        2MwUmA5qrQXbKzpa3N6FpmZEpzRSdv9FTiwp6VPNDBVAhmVo0JTlENPOJDFBn14fUKAyYkKQ/RJkj
        WC3yWQadSVn5n73EupnNUSXaXBMkdFvfqb2VKpKXsJDvSEEmlIZsn/xDJ3hPnZnslV897hkFhQ5g4
        CAuwAOibqfTogJgUoxF01UbUirKbQWhqpudRVFYpkatgBVIYY6xQzFjOKCQ9Zej4Gy88YPPOY416G
        EyAi/t6XopiIdH/cl49GMPV1oWGi9Nj7td6reVpBTukHKgcnaiJAtvg+3VyeDknZ/URcQrsGyJxM6
        f7TuIskg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r5ITC-00Fb8r-1l;
        Tue, 21 Nov 2023 04:34:42 +0000
Date:   Mon, 20 Nov 2023 20:34:42 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, chandanbabu@kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: clean up dqblk extraction
Message-ID: <ZVwzYh64YGjIxiI/@infradead.org>
References: <170050509316.475996.582959032103929936.stgit@frogsfrogsfrogs>
 <170050509891.475996.3583155500177528277.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170050509891.475996.3583155500177528277.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
