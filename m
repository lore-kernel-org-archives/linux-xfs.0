Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8E49C4361B
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 18:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7227C23BAC
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 18:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730097AbgLISN1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Dec 2020 13:13:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729882AbgLISN1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Dec 2020 13:13:27 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C49C0613CF
        for <linux-xfs@vger.kernel.org>; Wed,  9 Dec 2020 10:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iJMJZfz2IJdMm27clUcHtKjHDeE0zGX1sKN5LsITGjI=; b=bHnesj3n3fV6Bu878fX/MJ0qvj
        kXaqPzev9C2CdVC5Gsfjjiugtnonw91ZcCokxLKDMuHjybwJ1WfHWjgAvvJywxInoP8e8kbH7jiXv
        Pr+STj4EIOijmGHolbVcW9Xl6/qtIhP4DWb51DD/sJmJp9utm0/2n//7tlmpOj92Zoma+xI8DCps+
        Rk5O95Nw7SdxlonDWjMxsjdwE71WF/eUQ6ufH0iXnIdYj44qrMy1aTK8IpqA5wq+VNdkh0CiTiSgc
        x57PKzuEsixftQFRyXBBplYyPIJ5PYSifpLDMh2vIKPrWo4uYoLZqc8DK9mMmbl+dCpjzNaTOgkZg
        W+W9bdfA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kn3xC-0007xG-OJ; Wed, 09 Dec 2020 18:12:42 +0000
Date:   Wed, 9 Dec 2020 18:12:42 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, sandeen@sandeen.net,
        bfoster@redhat.com, david@fromorbit.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: define a new "needrepair" feature
Message-ID: <20201209181242.GA30491@infradead.org>
References: <160729616025.1606994.13590463307385382944.stgit@magnolia>
 <160729617344.1606994.3329458995178500981.stgit@magnolia>
 <20201209180400.GB28047@infradead.org>
 <20201209181056.GK1943235@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209181056.GK1943235@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 09, 2020 at 10:10:56AM -0800, Darrick J. Wong wrote:
> On Wed, Dec 09, 2020 at 06:04:00PM +0000, Christoph Hellwig wrote:
> > Who is going to set this flag?  If the kernel ever sets it that is
> > a good way to totally brick systems if it happens on the root file
> > system.
> 
> So far the only user is xfs_db, when xfs_admin tells it to upgrade a v5
> filesystem and we want/need to force the fs through xfs_repair:
> 
> https://lore.kernel.org/linux-xfs/160679383892.447856.12907477074923729733.stgit@magnolia/T/#mad4ee9c757051692f33a993a348f4e4e61ac098b
> https://lore.kernel.org/linux-xfs/160679383892.447856.12907477074923729733.stgit@magnolia/T/#mb6ef416f9626d87610625e069f516945783a5c13
> 
> I don't think there's ever going to be a use case for the kernel setting
> the feature flag on a mounted fs -- if some error is fixable we should
> just have online repair fix it; or if it's truly catastrophic we don't
> want to write the disk at all.

Maybe the definition wants a comment to explain this?
