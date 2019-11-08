Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5716FC5DF60
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:21:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B69C2085B
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:21:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Xh/8O5bc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbfKHHVj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 02:21:39 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52912 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfKHHVj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 02:21:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+yMYA1/l8V2Q5BK0lKDpi8pvaZVQY4hzJ8zIzzyl7vk=; b=Xh/8O5bcwkfIoEtd+X3ZCSCPF
        2vg/EkxwbuclsXZCntgEauymr3p+QuvwCFk71V/WRJDqGURALF6vTiVo4oOJVk55X80vJch2zBxDQ
        Y4gNdl3tO+UgerAHt9ddR3HlNLy0WbgEbfr6cMntbUIIMmbtP9lvzd11E71QF+4LuqpYgdvI/bdWZ
        40fQ0gPRbdkvPYZGSUMaFfH9JPySGhGG6vGXo+uz7wdCP+sX8KiimWmsUzpfcYqygmNAubtpMygiE
        hDk7QHfnl6FQNWQvWMqkBO22ihNamGI87uq6MsaR0IE6LP03+FBu7pVVSMJxvT2f2nqtTGOhc2PXu
        1aJhS4NAA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSyaR-00058G-3U; Fri, 08 Nov 2019 07:21:39 +0000
Date:   Thu, 7 Nov 2019 23:21:39 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/2] xfs: convert open coded corruption check to use
 XFS_IS_CORRUPT
Message-ID: <20191108072139.GA14546@infradead.org>
References: <157319670850.834699.10430897268214054248.stgit@magnolia>
 <157319672136.834699.13051359836285578031.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157319672136.834699.13051359836285578031.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 11:05:21PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert the last of the open coded corruption check and report idioms to
> use the XFS_IS_CORRUPT macro.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
