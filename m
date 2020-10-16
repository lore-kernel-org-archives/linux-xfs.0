Return-Path: <SRS0=Jdfz=DX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA49BC433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Oct 2020 07:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 604CF20720
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Oct 2020 07:04:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="s2leYagp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394389AbgJPHEv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Oct 2020 03:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394374AbgJPHEv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Oct 2020 03:04:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8D9C061755
        for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2020 00:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7+9YULm9/Iab2lxUg+Sa+9X1lReLmuT7CWynKONrF3g=; b=s2leYagpZgK/2Tuv64EINLwzIU
        JlU580+Ymte+VRN0WURRSLnfqrZeABePvvPyrx2vnwPk3Fp56rZi+LxDxjgQEHiXe7U2EgwaNABsY
        52zyAA/eRCmu0lTNebIeSQpaxyVUOP4wpe4IZprl3opndEUqfDkBHXHcCmSi203xsEDCthmQiD88K
        e7VoLDzyv8g/tcL3lIVDI/iP26FwrBk7o0LByJ6H3yd2qY/+3O2ZDSMbLqu1LElxFjKcMrfrhFXAs
        OIVrN5SzPSTXESkBLH3tNEi1MkMCuDyTLlettPYfYBoUiVWpgLWcpLjoEq0jKQBF3erb8uqqquzRe
        ak08gmsw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kTJnF-0003EW-0J; Fri, 16 Oct 2020 07:04:49 +0000
Date:   Fri, 16 Oct 2020 08:04:48 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com, david@fromorbit.com
Subject: Re: [PATCH V6 08/11] xfs: Check for extent overflow when remapping
 an extent
Message-ID: <20201016070448.GA12318@infradead.org>
References: <20201012092938.50946-1-chandanrlinux@gmail.com>
 <20201012092938.50946-9-chandanrlinux@gmail.com>
 <20201015083945.GH5902@infradead.org>
 <1680655.hsWa3aTUJI@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1680655.hsWa3aTUJI@garuda>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 03:31:26PM +0530, Chandan Babu R wrote:
> How about following the traits of XFS_IEXT_WRITE_UNWRITTEN_CNT (writing
> to unwritten extent) and XFS_IEXT_REFLINK_END_COW_CNT (moving an extent
> from cow fork to data fork) and setting XFS_IEXT_REFLINK_REMAP_CNT to a
> worst case value of 2? A write spanning the entirety of an unwritten extent
> does not change the extent count. Similarly, If there are no extents in the
> data fork spanning the file range mapped by an extent in the cow
> fork, moving the extent from cow fork to data fork increases the extent count
> by just 1 and not by the worst case count of 2.

No, I think the dynamic value is perfectly fine, as we have all the
information trivially available.  I just don't think having a separate
macro and the comment explaining it away from the actual functionality
is helpful.
