Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAE16C04FDF
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Aug 2023 22:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233054AbjHIWF5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Aug 2023 18:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbjHIWFz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Aug 2023 18:05:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842371729;
        Wed,  9 Aug 2023 15:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=QErTeQkz1cVsGQxjUoASrFujfY4NBEiICWhnXG0gBV0=; b=aCZKusqHBKNCz29OEKtMrCA0hp
        H3ASUAefgwC2AqVwlmJVgJBQRdFlvWLqBrWITEhcCE5VoHY+OS70nmuUs7TplQ99030xLEX11gB0L
        amI17KAIn6duu/Mr17rJcXumsmN4y5HiSx0FpSADV+z7iFLgPLuGeGyEH6r3ihoG3SuEPpQi/vIIS
        riRg1P7lpsCZ/8zWjDKUEAt14j3I2xoHKu8QPPOkWNvcK4ZiC92iho70hhnAF9YDADQzWoRgN2KbM
        1iludwYtrQxeVoPiIv3k3h8/i1M//8pkg5xw0TyR7sgZC4BMy3yLUydPZJpX0bW8w3nr4Hj2wEktI
        FwyoIhAg==;
Received: from [4.28.11.157] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qTrJK-005xnv-0d;
        Wed, 09 Aug 2023 22:05:46 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org
Subject: s_fs_info and ->kill_sb revisited v2
Date:   Wed,  9 Aug 2023 15:05:32 -0700
Message-Id: <20230809220545.1308228-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

this series is against the VFS vfs.super branch does two slightly
related things:

 - move closing of the external devices in ext4 and xfs from ->put_super
   into ->kill_sb so that this isn't done under s_umount which creates
   lock ordere reversal
 - move freeing the private dta in s_fs_info into ->kill_sb for file systems
   that pass it in through the fs_context, as otherwise we could leak it
   before fill_super is called (this is something new on the vfs.super
   branch because of the changed place where blkdev_get is called)

Changes since v1:
 - keep the invalidate_bdev call in XFS and actually document it
 - minor whitespace fixes

