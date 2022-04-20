Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38E7DC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Apr 2022 04:49:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238259AbiDTEwc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Apr 2022 00:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354965AbiDTEwb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Apr 2022 00:52:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE61275DC;
        Tue, 19 Apr 2022 21:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GOczIWAFowir8RwYCuJ+J5GuE0Dip4PeYPsVjWYY/9k=; b=Ou/rDodrUBXSf2UZ7FZvvpTtjt
        YgGhBzj5WEXWh1wgF+XO97fsJtzB9bEqxr8nl/T6ojZskInoMj7B7n1bC2UNYwUONCASotKRBgu2l
        49T3rh9dPEx95cKaizq9NjMWZRJl9UY59DO2RbVzwUBXCuWYKJsygB52kBSZDFPuQNHzs18JwnHKO
        Ez8OCCBeaxRrrdHzhtfVk4txw1WqqG3TJK0Sa7P/4hSPT36mSSyZZnXBvCsJfDLLEq0/vnYomg/XU
        wP2uJrBedgEbUq9ZsHEotJsuwpvZa/VEy/XClDW8kkkDWkslgKkyo1EuSNxHi4MDiv0PgWO3fjOAb
        EkHCLupQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nh2Hh-007Lu8-Vn; Wed, 20 Apr 2022 04:49:46 +0000
Date:   Tue, 19 Apr 2022 21:49:45 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Yang Xu <xuyang2018.jy@fujitsu.com>
Cc:     linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        viro@zeniv.linux.org.uk, david@fromorbit.com, djwong@kernel.org,
        brauner@kernel.org, jlayton@kernel.org, ntfs3@lists.linux.dev,
        chao@kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH v4 3/8] xfs: only call posix_acl_create under
 CONFIG_XFS_POSIX_ACL
Message-ID: <Yl+Q6a8ruNBkwLhr@infradead.org>
References: <1650368834-2420-1-git-send-email-xuyang2018.jy@fujitsu.com>
 <1650368834-2420-3-git-send-email-xuyang2018.jy@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1650368834-2420-3-git-send-email-xuyang2018.jy@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A nitpick in addition to the comments from Christian:  Please wrap
your commit messages after 73 characters.  The very long lines make them
rather unreadable.
