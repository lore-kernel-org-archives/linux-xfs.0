Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26C4BC34021
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4E8F2070B
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 13:51:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HXXaLBmE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728617AbgBQNvb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 08:51:31 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57488 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbgBQNvb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:51:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SFkeDWICFJgxkTEpr3P0fDGJYTT/FY+vTY+q20E6Ajs=; b=HXXaLBmE+f/BpKWDuA+BAEzIj/
        WEwirnhqDg3t6glw4nXbsffpKme03hw1pux4tTUMRIiUsYUGP8zyVdwmp3ZQYhIi6667gbItpIHQY
        1ftKH6+7H6MXQKzdLzyBudY3IAsH9vdrIZk1I1jNyxpu48KRvAHQYEDC92hRztScVik55gJ55+QLZ
        psc3yDbK8QMwy0i/fcrtru5gET5DPzu/XM/PzJ62vMVloKMh6IzZt5CqwRRgjza43W8mC8YITOWsg
        Me/LyOJ69KxfGv/03NtCadSLBIhCLmEeCN4UIySoeViWz4O1CTh9c1ZMTQOqLJd31y1dyb0xUjVCi
        A1xRsuWg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3go6-0001J3-7o; Mon, 17 Feb 2020 13:51:30 +0000
Date:   Mon, 17 Feb 2020 05:51:30 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>, alex@zadara.com
Subject: Re: [PATCH 4/7] xfs_repair: refactor fixed inode location checks
Message-ID: <20200217135130.GH18371@infradead.org>
References: <158086359783.2079685.9581209719946834913.stgit@magnolia>
 <158086362282.2079685.17208024677816310215.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158086362282.2079685.17208024677816310215.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 04, 2020 at 04:47:02PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the checking and resetting of fixed-location inodes (root,
> rbmino, rsumino) into a helper function.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
