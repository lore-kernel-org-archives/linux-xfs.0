Return-Path: <SRS0=0X6r=6J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E55C54FCB
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 19:01:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06F9020704
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Apr 2020 19:01:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qTLeW4Nm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgDYTBh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Apr 2020 15:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726216AbgDYTBh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Apr 2020 15:01:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F30C09B04D
        for <linux-xfs@vger.kernel.org>; Sat, 25 Apr 2020 12:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NDKdDPK6cXCOPcTDtK1ptrCjzNVrw1M6/UaksQxuGL8=; b=qTLeW4Nm+DOkKqvrmgb2RTvGjU
        nkW1+4KU4WxRaCggymKC2s0ZtVYbJtMCR7v4sJmKr9T0xWnbkZEHVoAUqT4abE1jOUX01ckXJqn8Z
        jEm8wZz70+MvcrDioYWtirO0YXheqRcsYtl9UVDg8nMl8aJVdwFkiBjDYhdfeo+qKFk/VbM5v/GvF
        7tiPgVXDSLgBltm2AoTvgsA2O0fmc5CPvDKBu+UtEI34Rz4TFIHUHnzT4NWts2KajlSO1AbK9pClw
        RcW4XRO8RizAM3uvXtDxSFI0YQR9ndXqWm0a4THhAADQC/FDQ83avQtBCEs1MKl4uv5S2qyKMXpkf
        tjki3M7g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSQ3V-00089d-6y; Sat, 25 Apr 2020 19:01:37 +0000
Date:   Sat, 25 Apr 2020 12:01:37 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: teach deferred op freezer to freeze and thaw
 inodes
Message-ID: <20200425190137.GA16009@infradead.org>
References: <158752128766.2142108.8793264653760565688.stgit@magnolia>
 <158752130655.2142108.9338576917893374360.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158752130655.2142108.9338576917893374360.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 21, 2020 at 07:08:26PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make it so that the deferred operations freezer can save inode numbers
> when we freeze the dfops chain, and turn them into pointers to incore
> inodes when we thaw the dfops chain to finish them.  Next, add dfops
> item freeze and thaw functions to the BUI/BUD items so that they can
> take advantage of this new feature.  This fixes a UAF bug in the
> deferred bunmapi code because xfs_bui_recover can schedule another BUI
> to continue unmapping but drops the inode pointer immediately
> afterwards.

I'm only looking over this the first time, but why can't we just keep
inode reference around during reocvery instead of this fairly
complicated scheme to save the ino and then look it up again?
