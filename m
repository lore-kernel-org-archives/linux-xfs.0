Return-Path: <SRS0=s1/4=C4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32E2AC43463
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Sep 2020 05:14:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBFD421D43
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Sep 2020 05:14:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fwIYW8OP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbgISFOE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 19 Sep 2020 01:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgISFOE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Sep 2020 01:14:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29174C0613CE
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2020 22:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8d1lssh9RRXGrxC1HYSLgBxMLF+x17GN4Nzrl/OpZa4=; b=fwIYW8OPj8UFLuutdRnsOVQXRB
        uzca7H7D2vdKpSdfTGACqQGZVat1wlviI4OimFWl81NGPWWWEfEKFqw2Jat1SHXk6CUjJLycOY4NJ
        DA9w19SinsuId97x358ni0lTGA2PCPqWfIbE5XTGzORtlwvIfWiFKSPxKG4vpbgnT195367SsyeUl
        FgcXdAE5HmMYa/IQmRGoAMENdInd+IchpVD7ZKazSN18JtyKK2qtDt5L94xtAMfVgQXairlgPItGK
        xM+B3Rz/szcAZ5Vj+sEZd6vrtSDDI4p4I0Tedrx3D2kyqHsWf8tgNRVkHEqnXdPAd27LHHijr9Jx9
        OzAQts5w==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJVCE-00082v-C7; Sat, 19 Sep 2020 05:14:02 +0000
Date:   Sat, 19 Sep 2020 06:14:02 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 1/2] xfs: don't free rt blocks when we're doing a
 REMAP bunmapi call
Message-ID: <20200919051402.GC30063@infradead.org>
References: <160031330694.3624286.7407913899137083972.stgit@magnolia>
 <160031331319.3624286.3971628628820322437.stgit@magnolia>
 <20200918021450.GU7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918021450.GU7955@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 07:14:50PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When callers pass XFS_BMAPI_REMAP into xfs_bunmapi, they want the extent
> to be unmapped from the given file fork without the extent being freed.
> We do this for non-rt files, but we forgot to do this for realtime
> files.  So far this isn't a big deal since nobody makes a bunmapi call
> to a rt file with the REMAP flag set, but don't leave a logic bomb.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
