Return-Path: <SRS0=9PeN=CX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 544B2C43461
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 07:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CA6E206F4
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 07:26:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Bkg124Qo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbgINH0R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 03:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgINH0Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 03:26:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4438EC06174A;
        Mon, 14 Sep 2020 00:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5Y3f08R8O4gzFa/D7wQ+KFB3LbGnU10uhROXIbnFpy8=; b=Bkg124Qoyv5L1NH/oE0j7Tb6Se
        WW8Y6tHKBfj4hT9snshWtEgGyBXmReflDwHkeKB2EY0z/p/zQltrSSGdWozrSO35dh0N7VETTtkVD
        wzEfz1+deh4BDz/pGfgWgyXDbzBm+BfnLZXIIWP8EX5kczUR7JPavRm1NPxBkhjIAfgocpZv00kKR
        aDR4o+nAs60l+RMv/Rf961y16l/kQf+TXsBjUFE86VUwyS/aQcsL7Z90cRIVxh57FMrz5ou+0nQZm
        lBPt59ViHe45HMEKBCnYl+b5sScH/dmTrNyZSbsdR5WKxshrCK6HsCTOPz9m2LliBg8LY9Yk8msc3
        Oo7tnCiQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kHisN-0007lX-Ca; Mon, 14 Sep 2020 07:26:11 +0000
Date:   Mon, 14 Sep 2020 08:26:11 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc:     fstests@vger.kernel.org, darrick.wong@oracle.com,
        david@fromorbit.com, ira.weiny@intel.com,
        linux-xfs@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH v2 1/2] common/rc: Check 'tPnE' flags on a directory
 instead of a regilar file
Message-ID: <20200914072611.GB29046@infradead.org>
References: <20200914051400.32057-1-yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914051400.32057-1-yangx.jy@cn.fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 01:13:59PM +0800, Xiao Yang wrote:
> 'tPnE' flags are only valid for a directory so check them on a directory.
> 
> Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>

The change looks good, but I wonder if we should split the chattr
tests into

_require_chattr_file_flag

and

_require_chattr_dir_flag

to make the whole thing a little less convoluted..

