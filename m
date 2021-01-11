Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38066C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 17:32:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9AD7229CA
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 17:32:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389366AbhAKRbq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 12:31:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389341AbhAKRbp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jan 2021 12:31:45 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97ACC061794
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jan 2021 09:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zLl3wy4WreUt0LS9W5RiBkI9J+x8Gmdp01cYSkbaBxA=; b=CkJQ2zmEbMmy8RR3wafJq3l+6Z
        JngG5CmWe3U1gOEkrmbzjf9jeFLf9nGrz5y5ATIYtEFehSdrGhYI4DR53mjRhxZ5bw4FaTHS6jPRc
        IHo8ea40z1+XKsPw1dng9lpSglXuZb02E/ZAO27DH8BJ7JssHvFGvNrkMOVcYoLYl3A9so1UTdEat
        Xp9/cI4RaJjk7eW0TTOLLk4sgLG4+khRcVsHdSEOmQyKZDRufmT8OGaPjBxx3zbztJlN8BEPAUhdL
        Gf2wGaTut5Aq9fX5UtYcHRMvh1B9nzF+3/RGOv2VfkbNY4NUbmSFUwWqUI/Tlm+DQlxCrJ1DdiFnM
        v063ZTzA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kz11q-003Yyf-90; Mon, 11 Jan 2021 17:30:54 +0000
Date:   Mon, 11 Jan 2021 17:30:54 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3 2/4] xfs: get rid of xfs_growfs_{data,log}_t
Message-ID: <20210111173054.GB848188@infradead.org>
References: <20210108190919.623672-1-hsiangkao@redhat.com>
 <20210108190919.623672-3-hsiangkao@redhat.com>
 <20210108212132.GS38809@magnolia>
 <f1b99677-aefa-a026-681a-e7d0ad515a8a@sandeen.net>
 <20210109004934.GB660098@xiangao.remote.csb>
 <20210110210436.GM331610@dread.disaster.area>
 <20210111001749.GC660098@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111001749.GC660098@xiangao.remote.csb>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 08:17:49AM +0800, Gao Xiang wrote:
> Okay, will leave the definitions in the next version.

Note that the important thing is to not break the kernel to userspace
ABI, the API is a little less important.  That being said breaking
programs piecemail for no good reason't isn't nice.  I think we
should probably move all the typedefs to the end of the file with
a comment and then at some point remove them as a single breaking
change.
