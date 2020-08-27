Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB81CC433E3
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 07:01:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B94322B4E
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 07:01:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LktwXBKQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgH0HBm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 03:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727793AbgH0HBN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 03:01:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5418C06121B
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DKhGSknbo9C+UJRNnXElMljoCYX1XojeRCApjECYJ6Q=; b=LktwXBKQT2PktukHJmXYfOZIAD
        X8VmFLwyF8zlTLOk0bvarijQu3RqjEimiUAKoQ4lRMrFUbPmjt5IdeyfZdUXm8mbLaNrgpWtgEvbi
        NZJnHkRx25ANBl1oCUopXfc8UxQnfDLtMBhe9OmlQ5vUQi9XX4lqu6CXPyV0uXyVsjZBrJBYt20oF
        xDsWHu0knE2TCh6baS906uwUq+vxzzcUILAQZF35bVng5RmC7RfJWp3oy8xhdohi/grWFL5dhlmkW
        gmnCsbEum62ZTTVw2JflHfgJBP+Rlx8zwvxYALagkp7kk1PEx0kFQU968uDoXQLec8+cbjfztj/ss
        BRUrM/Eg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kBBuI-0005l1-Si; Thu, 27 Aug 2020 07:01:10 +0000
Date:   Thu, 27 Aug 2020 08:01:10 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, hch@infradead.org, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, sandeen@sandeen.net
Subject: Re: [PATCH 10/11] xfs: trace timestamp limits
Message-ID: <20200827070110.GD17534@infradead.org>
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
 <159847956308.2601708.12409676822646276735.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159847956308.2601708.12409676822646276735.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 26, 2020 at 03:06:03PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a couple of tracepoints so that we can check the timestamp limits
> being set on inodes and quotas.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
