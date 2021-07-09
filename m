Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41106C07E99
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 06:25:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1626861442
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jul 2021 06:25:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbhGIG2F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Jul 2021 02:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhGIG2F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Jul 2021 02:28:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24427C0613DD
        for <linux-xfs@vger.kernel.org>; Thu,  8 Jul 2021 23:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WN4/8gjEsH/Tencp6NsddQiAR6ggtpDxVTPCplpwGBQ=; b=oxEMwI2b1CikbtEwqXs8K6Ies5
        RaTCv4BaVcFTB4e7wTZJkP6RLUm069Mt6rWxeIB5HHzI/q2zaG5Kvk2q1C1cqNfq9PUEJEjevV3Us
        61zpROsmOVJF1Aw/ft/8K6kg9iWZ8vpXJ4LH+7lJvjGMYeeKvHjIdhDDhd8FaXe29Sd0Rr6cY0Kn/
        PA/NU6+97q+FNELfR7vG/LdIDLbx/x/VMZsnngc9oOVB54feg9sXYtOsQd/EbfuNt7nIpCpKOQj6N
        tetwnLvu+7n1GmkwdEWfQsl1n31sofkJE/WLjlTLXI5nxfkjk56mrKtF0Ywa3RsHLE9wowWDKyxaj
        BgiuCWLQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m1jwj-00EDec-VB; Fri, 09 Jul 2021 06:25:17 +0000
Date:   Fri, 9 Jul 2021 07:25:09 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: don't expose misaligned extszinherit hints to
 userspace
Message-ID: <YOfrxV9p1Bhrs1jD@infradead.org>
References: <20210709041209.GO11588@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709041209.GO11588@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 08, 2021 at 09:12:09PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Commit 603f000b15f2 changed xfs_ioctl_setattr_check_extsize to reject an
> attempt to set an EXTSZINHERIT extent size hint on a directory with
> RTINHERIT set if the hint isn't a multiple of the realtime extent size.
> However, I have recently discovered that it is possible to change the
> realtime extent size when adding a rt device to a filesystem, which
> means that the existence of directories with misaligned inherited hints
> is not an accident.
> 
> As a result, it's possible that someone could have set a valid hint and
> added an rt volume with a different rt extent size, which invalidates
> the ondisk hints.  After such a sequence, FSGETXATTR will report a
> misaligned hint, which FSSETXATTR will trip over, causing confusion if
> the user was doing the usual GET/SET sequence to change some other
> attribute.  Change xfs_fill_fsxattr to omit the hint if it isn't aligned
> properly.

Looks sensible, but maybe we need a pr_info_ratelimited to inform
the user of this case?
