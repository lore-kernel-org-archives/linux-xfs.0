Return-Path: <SRS0=CSRb=5Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 459CAC2BB54
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 07:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C7A520769
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 07:41:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PYIz0OYR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgDIHlA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Apr 2020 03:41:00 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51584 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgDIHlA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Apr 2020 03:41:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8EYTxCZM4fYVaCIaZqPSTP+6v/NL7nVFlepypkokg3s=; b=PYIz0OYRPF5tRGO571woedCq/9
        G2xHxBqVdV+sMrrJJDpcqxdIuz/OIE/mbIMR7WFv2CVOQaCbIcgjhiC3NAQTqa62O+TiNzQcyj9LB
        bLyMkOuX7ZvAbWGwMwAjreIKRSoMVB2oNCmBzK+seIkugYNK15Y7WCRRNOp8X+2+GsN0hcV6fHGqg
        x3KkW37+hwNBu22T2+qBx55V5VqdwVR5VqxpxcdtonqIUiGkDfK+D2m/Aff9jyQqnMVvOyK6No1Kr
        Sq9Xwpx84/49fYx194VR20/rKt/NRJoAPIqs+qJXWwSca3gyEUqdWlz5LcWiMVid3g32U8Hi9+zWE
        M9Wmbgug==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jMRnY-0008A3-QO; Thu, 09 Apr 2020 07:40:28 +0000
Date:   Thu, 9 Apr 2020 00:40:28 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        fstests@vger.kernel.org, hch@infradead.org
Subject: Re: xfs_check vs. xfs_repair vs. the world^W^Wfstests
Message-ID: <20200409074028.GB21033@infradead.org>
References: <20200408030031.GB6740@magnolia>
 <2574725.68tNun6CyS@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2574725.68tNun6CyS@localhost.localdomain>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 08, 2020 at 10:23:21AM +0530, Chandan Rajendra wrote:
> > Not sure what to do about quota in repair -- we could build in the
> > ability to do quota counts since we scan the whole inode table and
> > directory tree anyway.  From there it's not so hard to rebuild the quota
> > inodes too.
> >
> 
> I will take up this work and get it completed.
> 
> Since I have other higher priority tasks at work place, I will have this as my
> secondary focus. Meanwhile, until it gets done, can we disable running these
> tests on block size > 4k i.e. https://patchwork.kernel.org/patch/11454399/.

I still think even with the above outstanding issues we should not
run check by default.  We can still opt into it, but check extends
the run time of xfstests for not very good reasons.
