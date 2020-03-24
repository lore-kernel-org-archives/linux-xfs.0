Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B784C4332B
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 08:44:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22D1820786
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 08:44:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NpjlwG8Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgCXIow (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 04:44:52 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33380 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgCXIow (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 04:44:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gpfmnWy+e3k8VX5dgofB1W8+ylPX5OgaIDLyeqvCpfk=; b=NpjlwG8YT4Nd1QBJ/Nl93wwZNB
        /fdCpRUot2CrWm0Xhi8ZK1FkKqzoejbyUBE8JIBpxLEbKfAhP65Ysqf3whCwk78mLq7oEAzkY1lH/
        WCA8p5awwAm7iY9IulkpBLYpMFLgE9RnIzh0lQUKInESaoIP/vCCEF2YCfJWTtYNIk71g9Nlf/6KD
        CpbFqtMo1i62H8lQCrTdBzP6Cwde8ehFAPBWNGE9CohCAnwOIqt9eJf0CenF+IRv95yxFZe52Ywlm
        KzsWTV06JqUzBNpHqOyalMQcFy0R7ohiBy3cRk13BnGBlspyjW48VHwPIo6MC766fBhGObp+3IWuM
        2P2kS78Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jGfB6-0003nA-Bc; Tue, 24 Mar 2020 08:44:52 +0000
Date:   Tue, 24 Mar 2020 01:44:52 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfsprogs: fix sliently borken option parsing
Message-ID: <20200324084452.GF32036@infradead.org>
References: <20200324001928.17894-1-david@fromorbit.com>
 <20200324001928.17894-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324001928.17894-5-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 24, 2020 at 11:19:27AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When getopt() is passed an option string like "-m -n" and the
> parameter m is defined as "m:", getopt returns a special error
> to indication that the optstring started with a "-". Any getopt()
> caller that is just catching the "?" error character will not
> not catch this special error, so it silently eats the parameter
> following -m.
> 
> Lots of getopt loops in xfsprogs have this issue. Convert them all
> to just use a "default:" to catch anything unexpected.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
