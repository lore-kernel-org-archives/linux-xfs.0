Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9144AC83003
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 11:48:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F55620B80
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 11:48:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hiip1iBR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgD2LsV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 07:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726974AbgD2LsV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 07:48:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C3DFC03C1AD
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 04:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Qd2gPGXCQ+2QBGCn+8Bcjg1CkxceaamJZUcdqmBMiqU=; b=hiip1iBRuKBX2UqG05FMmk/Qnu
        na5lO7Ih7kpLDMspj7ZRJCo/r9CEqRliFNhKuVJKzObCyzJQNAVbyiGj9nadTf3ucSaSDQ2HBUjF8
        mY/SH42zXhQo7Rdc/kIV70e2mpJIgy85XlMRD/39uIMk5suhhfB5qQYO0TA9IbAGyDUhYZcAp3fn2
        /RvsyS9NCSDEJs8l3CAZr8ergZD7dPh3wwbOBjIconGovfe8XA4SdLvxvhwai2t8vR1hVahNrHrG4
        xGPqH74xlf3h3inpWxUqUkuYjvlTNfuJtjgByUWEcnU3MhVTQz5pXg4Pv9kozxAaFDkJDgd4S5bTF
        ykz4F2ag==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jTlCN-00072U-6g; Wed, 29 Apr 2020 11:48:19 +0000
Date:   Wed, 29 Apr 2020 04:48:19 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: teach deferred op freezer to freeze and thaw
 inodes
Message-ID: <20200429114819.GA24120@infradead.org>
References: <158752128766.2142108.8793264653760565688.stgit@magnolia>
 <158752130655.2142108.9338576917893374360.stgit@magnolia>
 <20200425190137.GA16009@infradead.org>
 <20200427113752.GE4577@bfoster>
 <20200428221747.GH6742@magnolia>
 <20200429113803.GA33986@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429113803.GA33986@bfoster>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 07:38:03AM -0400, Brian Foster wrote:
> That aside, based on your description above it seems we currently rely
> on this icache retention behavior for recovery anyways, otherwise we'd
> hit this use after free and probably have user reports. That suggests to
> me that holding a reference is a logical next step, at least as a bug
> fix patch to provide a more practical solution for stable/distro
> kernels. For example, if we just associated an iget()/iput() with the
> assignment of the xfs_bmap_intent->bi_owner field (and the eventual free
> of the intent structure), would that technically solve the inode use
> after free problem?

Yes, that's what I thought.

> 
> BTW, I also wonder about the viability of changing ->bi_owner to an
> xfs_ino_t instead of a direct pointer, but that might be more
> involved than just adding a reference to the existing scheme...

It is actually pretty easy, but I'm not sure if hitting the icache for
every finished bmap item is all that desirable.
