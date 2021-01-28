Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA7B5C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 09:58:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79E3D64DA1
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 09:58:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbhA1J6Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 04:58:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231745AbhA1J6X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 04:58:23 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2257C061573
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jan 2021 01:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tYuuRJZzwiNj4LdOI1P/dG8iy/nmpvow9H2KRz6Taf4=; b=hEIgmQBxAjxqUVPVhdTfd93zfL
        q9dEQXUWPGc1LtF42JRqGOixt7rt6Dvf7uPBSOZwziIfKrvl1r50QZEF+3rkLJghWGCRCxiKCrFzB
        NAdGc1wYax20nZTAdpEMQNWpupJ+4h024JHekhRpKV6cp3RrG/gPiPFsl67BvwbZJG0c/4Qd6bBKQ
        weO0nwdeDMZ7n7cIBBxwUrIjD7/PS8VGcUn4fy+RpA7Ie03crPZako3RtaIuFOqlBtd4t4zn+VxKI
        BHa/MD87dJYyKCzuK+jdD/CdIcrhTynnPHI4KeotNSep9EQhtzEpZMWVWhqCwNwEapFdxvHn5+kaX
        CfxoTiMA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l543V-008IDQ-GM; Thu, 28 Jan 2021 09:57:37 +0000
Date:   Thu, 28 Jan 2021 09:57:37 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Subject: Re: [PATCH 11/13] xfs: refactor inode creation
 transaction/inode/quota allocation idiom
Message-ID: <20210128095737.GG1973802@infradead.org>
References: <161181366379.1523592.9213241916555622577.stgit@magnolia>
 <161181372686.1523592.6379270446924577363.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161181372686.1523592.6379270446924577363.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 27, 2021 at 10:02:06PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> For file creation, create a new helper xfs_trans_alloc_icreate that
> allocates a transaction and reserves the appropriate amount of quota
> against that transction.  Replace all the open-coded idioms with a
> single call to this helper so that we can contain the retry loops in the
> next patchset.

For most callers this moves the call to xfs_trans_reserve_quota_icreate
out of the ilock criticial section.  Which seems fine and actually
mildly desirable.  But please document it.
