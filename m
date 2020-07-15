Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20EA9C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 18:09:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E71102065D
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 18:09:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D47NWG3S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbgGOSJ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 14:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgGOSJ6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 14:09:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0325BC061755
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 11:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XCJP0C034M29DSzMHsIpUKGiUSKdvOFMDw4L/Oee9m0=; b=D47NWG3Spv5woB4iluyawyo4CT
        jlvbRvpJYJXz0muh4BN3LHcC9yUNDp8GIw9cOWga+x02k9nDjbsVmXkcxh9TxwHecG/aTMv9bI1XV
        K2LO8qSWmks3HtNJKDXNFfvm19blZtCRMbRQerkfwZQAymXb+goPrQicG7KbIllxniN/HE2TTNuRk
        LIMj4PAmPf+6JsretftrnfKtiQg6nsZGXmV6kb6JlvSkhrlLrO3Yk81+pS2dVDvG6kf+FtIFq/kIT
        24pH0aoUrefBZ2EUOziHcu8ks6ECbqUUmRv0l1dsc9nrTFT0RDZ1mBSLgxkvoNGa2yTkFsfLaPJzV
        Y+ooEo8Q==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvlqu-0004cB-H2; Wed, 15 Jul 2020 18:09:56 +0000
Date:   Wed, 15 Jul 2020 19:09:56 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: preserve inode versioning across remounts
Message-ID: <20200715180956.GB14300@infradead.org>
References: <e8bfbbec-4cb9-0267-08eb-03580e2aedc6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8bfbbec-4cb9-0267-08eb-03580e2aedc6@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 14, 2020 at 03:11:34PM -0700, Eric Sandeen wrote:
> The MS_I_VERSION mount flag is exposed via the VFS, as documented
> in the mount manpages etc; see the iversion and noiversion mount
> options in mount(8).
> 
> As a result, mount -o remount looks for this option in /proc/mounts
> and will only send the I_VERSION flag back in during remount it it
> is present.  Since it's not there, a remount will /remove/ the
> I_VERSION flag at the vfs level, and iversion functionality is lost.
> 
> xfs v5 superblocks intend to always have i_version enabled; it is
> set as a default at mount time, but is lost during remount for the
> reasons above.

Looks good, this fixes the new mount API conversion, as the old code
automatically added it.  Maybe this wants a Fixes tag.

Reviewed-by: Christoph Hellwig <hch@lst.de>
