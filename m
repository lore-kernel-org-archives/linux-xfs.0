Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AE52C43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 08:14:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 283112075B
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 08:14:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UKorZ0T2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgIQIAG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 04:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbgIQIAB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 04:00:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88E8C06174A;
        Thu, 17 Sep 2020 00:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JEuScgstovbBqMMQcW9Iw5Y1rcrAZ+mgL/ytV8fVhWI=; b=UKorZ0T29MxZ32zMfBhYircHO1
        JSI1SNjyR8RdIlbyBjN8zKnjCg3DnEvv3nku1SaQz7mgvl78ksznTjeY0iRGPv3osgRheuvPnbTXE
        4rB7Csm6uC9exMTh/I33+Q+hj9E+7+vTzqKfeR/vVVZw39uFmWr5qW2ILRR8YVq+HICkCrz+mb4Xu
        uevNxt8aDQBSR9LLLDoy8pFseko6qTYfPViq9C2EcOT1m3DBQAsR8DAwPBpB7pHOF1HgDlTcPQnJ9
        rd3PKHGjpQqJXZmXDL56bmjTpmBtHZHsddlnPE+UZ+DvdnVLz+tIDTt2TQ2lovGYifENpHnjWWpCW
        /EWQ8uIw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIopa-0007ap-R6; Thu, 17 Sep 2020 07:59:50 +0000
Date:   Thu, 17 Sep 2020 08:59:50 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 20/24] xfs/449: fix xfs info report output if realtime
 device specified
Message-ID: <20200917075950.GP26262@infradead.org>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013430267.2923511.8202421356162568130.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160013430267.2923511.8202421356162568130.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 06:45:02PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Modify the mkfs.xfs output so that "realtime =/dev/XXX" becomes
> "realtime =external" so that the output will match xfs_db, which doesn't
> take a rt device argument and thus does not know.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
