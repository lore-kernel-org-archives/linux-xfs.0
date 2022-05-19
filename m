Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F33DCC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 19 May 2022 08:36:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232795AbiESIgE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 May 2022 04:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235497AbiESIgA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 May 2022 04:36:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33531E1E
        for <linux-xfs@vger.kernel.org>; Thu, 19 May 2022 01:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nBNJWlmsOCX/tsnQGnpttf5mI0HDhmufojTx49LIo1g=; b=v/u7UrseS620PPkg4C6UbMoxXZ
        EusVsjJfR+GPJvSP7k4di51k6aQTbdrSNaGJCuVfpbEvssIYL89RwaTq+spdEXf+uisAtr00uiYxE
        BLUFBNgbfZmgun96PsXuSAL0/pqMGlxc2frAeIHp+hOJiqlBjW2gnHx9qMkq381ykh6S9CUHlmcbw
        cb/jXQVjH8YHOmrwl/Lj5RbemrVb4phEY9P1vG3lwfzf9bPqE9ga5gBiY6jXS5cFaBYa5orRyRXqz
        hL4lIw4mCA4sfYheeaeQqpNICXFhpiEJSkrK1dp/Vg9pjbLXsPb/kFvcb4eZD91qqWjfQh5sKOVEZ
        9jdQPccA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nrbdW-005tVA-Qx; Thu, 19 May 2022 08:35:58 +0000
Date:   Thu, 19 May 2022 01:35:58 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/3] xfs: refactor buffer cancellation table allocation
Message-ID: <YoYBbg59ktNdM2qJ@infradead.org>
References: <165290012335.1646290.10769144718908005637.stgit@magnolia>
 <165290012900.1646290.13406779783177992762.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165290012900.1646290.13406779783177992762.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 18, 2022 at 11:55:29AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Move the code that allocates and frees the buffer cancellation tables
> used by log recovery into the file that actually uses the tables.  This
> is a precursor to some cleanups and a memory leak fix.

While you're at it, I'd also move XLOG_BC_TABLE_SIZE and
XLOG_BUF_CANCEL_BUCKET to xfs_buf_item_recover.c.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
