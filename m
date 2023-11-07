Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE75FC4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 08:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbjKGIil (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 03:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbjKGIik (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 03:38:40 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFAC0183
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 00:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Fa+MDjXPP+vkhhe07SPm6zhLyf
        5rrR6M+S7CwL3EzcioDlRNBePmpPk9eVPIkjmXxuNI5PbGUkkrVEh9C2dDVO/r5++DdCu7iwsl2BJ
        TTyWZ9PhdNt0bKm9RhtzhNnPV1HLalWLdZgY5XB91mu5Hf6cRa7mbaUc9aDIDQDlUUeoHEjNI998E
        6o7CvnF+eKP3ZFrEhGkwib2xuWUqSRodvRVhaXz5l+Qo5rS+fLVdbOMBUHqFqsgxoBDnFFjr+ltOj
        JGfxRqTyKaPWPs9YBwwFPeTEw+vYSLf+yUjOr/wILTokGiExgCvd2utVrxs83Qq7WPH2HjITzMB95
        niWsykRw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r0HbZ-000ps8-1x;
        Tue, 07 Nov 2023 08:38:37 +0000
Date:   Tue, 7 Nov 2023 00:38:37 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs_scrub: fix pathname escaping across all service
 definitions
Message-ID: <ZUn3jY/qb27aLSGj@infradead.org>
References: <168506073832.3745766.10929690168821459226.stgit@frogsfrogsfrogs>
 <168506073873.3745766.7019908892401637437.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168506073873.3745766.7019908892401637437.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
