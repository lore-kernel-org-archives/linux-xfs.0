Return-Path: <SRS0=tkkj=YB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12308C4360C
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 06:59:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF0FB206C2
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Oct 2019 06:59:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CBSyjcU3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730103AbfJHG7o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Oct 2019 02:59:44 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50130 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730069AbfJHG7o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Oct 2019 02:59:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=WF7f/O1W8H4sipC3Y+3lRksmbocbmc9XU8GUfWl+k7c=; b=CBSyjcU3VwZdIahNHMkHm9Pge
        FHl0f3LzKzdWYiNXFbIjE1E0PFeWdrBKdCQwdJLPheMNcScZFwFx5xlKkPfwokCtBC1KqNSnAPdNT
        e3+vKBeu74OIky1AwTHMH06nk5ZtgTGcH0T3vwr1sF8NX5gxyR1jyA7rBZh6/PNwclCeBU4p1kYMq
        kDPIYNZxvH2pqEBjsR+IpX5k8+TkPNxlIPeqqEseLckpvlx0IDzmKwQWwkMwfw/xxKHJl0XlBAyhr
        +LuWbQdgz025QygJkVpGtHheIQ2g55J/yf8npId7UI584byl+ww6ad5cu7IlODvwq7/dAPGbhO/QN
        1Tt/OMnAA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iHjTD-0005jN-WF; Tue, 08 Oct 2019 06:59:44 +0000
Date:   Mon, 7 Oct 2019 23:59:43 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/3] xfs: log the inode on directory sf to block
 format change
Message-ID: <20191008065943.GA21805@infradead.org>
References: <20191007131938.23839-1-bfoster@redhat.com>
 <20191007131938.23839-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007131938.23839-2-bfoster@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 07, 2019 at 09:19:36AM -0400, Brian Foster wrote:
> When a directory changes from shortform (sf) to block format, the sf
> format is copied to a temporary buffer, the inode format is modified
> and the updated format filled with the dentries from the temporary
> buffer. If the inode format is modified and attempt to grow the
> inode fails (due to I/O error, for example), it is possible to
> return an error while leaving the directory in an inconsistent state
> and with an otherwise clean transaction. This results in corruption
> of the associated directory and leads to xfs_dabuf_map() errors as
> subsequent lookups cannot accurately determine the format of the
> directory. This problem is reproduced occasionally by generic/475.
> 
> The fundamental problem is that xfs_dir2_sf_to_block() changes the
> on-disk inode format without logging the inode. The inode is
> eventually logged by the bmapi layer in the common case, but error
> checking introduces the possibility of failing the high level
> request before this happens.
> 
> Update both of the dir2 and attr callers of
> xfs_bmap_local_to_extents_empty() to log the inode core as
> consistent with the bmap local to extent format change codepath.
> This ensures that any subsequent errors after the format has changed
> cause the transaction to abort.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
