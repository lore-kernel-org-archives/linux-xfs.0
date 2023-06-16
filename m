Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF77EB64D7
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jun 2023 05:52:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbjFPFwJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Jun 2023 01:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjFPFwJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Jun 2023 01:52:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B38C170E;
        Thu, 15 Jun 2023 22:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=DsV9N7jL1wmhaAjN5sea4APDqD
        gwl1GJxwjAvjxRhz/AcKt06Hg+iF95R+mkaokn5Vb6uKZgem1A0MvjK6zQC6o0HQvjGS/Qt6pCLlY
        7SIEGUAJO7upnkfa68kEexTsjaPq0y7P1T/FMdMUGM/kr5i7lLSNxJScgEfT4gSHofFBKGtC8D3Kp
        wBxoi5TReWFkfqAn406b+SDiIPmkbnBFKU6s5XwtIDxFsS441YB35aPbcxN4BOhS/JenxlPG7DgYf
        knx+XVk9rIFsQu1BQ0PClCgFnh3N7dgcAVt7mSm+wrNy5S1xZZhU1EyVlLSbpDB7hz3XWGm9J9Cwd
        TuzT+XIA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qA2NS-00GwTm-1K;
        Fri, 16 Jun 2023 05:52:06 +0000
Date:   Thu, 15 Jun 2023 22:52:06 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        mcgrof@kernel.org, jack@suse.cz, hch@infradead.org,
        ruansy.fnst@fujitsu.com
Subject: Re: [PATCH 2/3] fs: wait for partially frozen filesystems
Message-ID: <ZIv4hglCFNpqktcT@infradead.org>
References: <168688010689.860947.1788875898367401950.stgit@frogsfrogsfrogs>
 <168688011838.860947.2073512011056060112.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168688011838.860947.2073512011056060112.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
