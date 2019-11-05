Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6183CA9ED3
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 00:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB99E2080F
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 00:48:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YKIlDmmG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730021AbfKEAs3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 19:48:29 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42626 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729443AbfKEAs2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 19:48:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6YfqNlU8PMMlgBDCrriJIEGFGiaDjYfCO4HmaWhErRk=; b=YKIlDmmGk1hTgZTefVxUZ+WsO
        ftzMoJ1DJw8JlVswwTjHm2rXxvhERbPkN8uALX8T70BdQoNhhaZ6I9zAOi3oDsmQhDYENWicbtfJL
        3azHQz3fC8FP8mmuf6i/YyohBtY5nUCDhku5ekhqeOluHeQC62M7+6ouVpwvlqlh/ZYV/jtCwL+N+
        i+U6WOYQJG4kklYNM+MPMgpGIu+I9aRWi/4IUxcikkGMCI+MkVjyGD0XI56mYa/AVQa35KL3jUZ0k
        I7Bev0Zzj+qzDwGzmdpTcf2uV4XWd9uB6n0PYSLU5o72o2iH/Seb4z3oC2qbasmPe8BhO86RddeJv
        Cv9L+FDfg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iRn1I-0007kY-Nj; Tue, 05 Nov 2019 00:48:28 +0000
Date:   Mon, 4 Nov 2019 16:48:28 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: add a XFS_CORRUPT_ON macro
Message-ID: <20191105004828.GD22247@infradead.org>
References: <157281984457.4151907.11281776450827989936.stgit@magnolia>
 <157281987010.4151907.6435110079992395504.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157281987010.4151907.6435110079992395504.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 03, 2019 at 02:24:30PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a new macro, XFS_CORRUPT_ON, which we will use to integrate some
> corruption reporting when the corruption test expression is true.  This
> will be used in the next patch to remove the ugly XFS_WANT_CORRUPT*
> macros.

I don't particularly like the XFS_CORRUPT_ON name, and seeing how it
is used I like it even less.

Maybe XFS_IS_CORRUPT instead?
