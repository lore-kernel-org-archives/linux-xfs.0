Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65901C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 17:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B03A2065F
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 17:47:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ubQDuP4e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgGORrZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 13:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgGORrZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 13:47:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4894AC061755
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 10:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9Oftynegg9gxG1X2w8riRPjQpbOdWLi88X/cVVesQLQ=; b=ubQDuP4e5BWJKIBpyDroer7kai
        P8H8S9UsGWQxR6XoVBFVnfOX/MOJljUlmXibR6TeQjYmU1cynpKHg4iC+osTr1F66wC0SNNF6xsLm
        0J01LYrdFlHBvhbgRbH6IxRvLfZMMSi2BoJ4aH5FYwwbRuo5ISzsibR2A5+9s2IowhyC6lhE8pdpi
        PA/l+pN48LxAOzwQAG7LRh9oD+wO5TICloNgMRd9CKNoNoFvO6fUlaiGTcB4Rwv15OBFzvifufJpZ
        ySVZhFFSmyNaYrJmY2tpZplScxZUEp2LmmRV5OLsynkpteJ96RjC4K/3JuWPimJe48YXF5FdVeVBy
        hxs52ABw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvlV4-0003bB-I0; Wed, 15 Jul 2020 17:47:22 +0000
Date:   Wed, 15 Jul 2020 18:47:22 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs_repair: alphabetize HFILES and CFILES
Message-ID: <20200715174722.GD11239@infradead.org>
References: <159476316511.3156699.17998319555266568403.stgit@magnolia>
 <159476317341.3156699.9021466334498861961.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159476317341.3156699.9021466334498861961.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 14, 2020 at 02:46:13PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert the definitions of HFILES and CFILES to lists that can be sorted
> easily (in vim, anyway), then fix the alphabetization of the makefile
> targets.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
