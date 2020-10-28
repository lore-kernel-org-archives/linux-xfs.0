Return-Path: <SRS0=iKFT=ED=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EA4AC5DF9D
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 21:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E810B24724
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 21:52:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tGZQvj/i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbgJ1VwM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:52:12 -0400
Received: from casper.infradead.org ([90.155.50.34]:44160 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728270AbgJ1VwH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 17:52:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yxtC3uhLjYN73Pnw7PTWpbD/T7EiczbHg1CnySo/qoo=; b=tGZQvj/i9md86a2ZCZxcyTUHgX
        9LAEIgUl5Xo1Xi85YqRXocz/Nu8OPeT0T4Ity5yUDVqrN1yKc+vdNllu8O1JBZuc7mx/TQHVbW/6s
        ihsMah+MIjNebho4tQfUGpGLQjAvnxpDzg1hPkmlDdriQ9RHDMANRyujq9+xC/ixB6go9tLXxO6Ua
        ug/h74YjqTW6ZYx9AfEowF51MFVSYKJgdsdPvy/CqMtTtstF2Vj1a4B+dmHWne+OFikPVrE4NnePE
        R+q9uiPTvg5ZF4VyGVifWqpRr8hjeFw4bKDevyreP2MdhcHQdgS9yoSwP/68oBo3Sci9Oa3AJYXNj
        Ne1yjB6w==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXg7D-0000rb-Pv; Wed, 28 Oct 2020 07:43:27 +0000
Date:   Wed, 28 Oct 2020 07:43:27 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs/030: hide the btree levels check errors
Message-ID: <20201028074327.GG2750@infradead.org>
References: <160382528936.1202316.2338876126552815991.stgit@magnolia>
 <160382533506.1202316.2655281450906651514.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160382533506.1202316.2655281450906651514.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 27, 2020 at 12:02:15PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Newer versions of xfsprogs now complain if the rmap and refcount btree
> levels are insane, so hide that error from the golden output.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
