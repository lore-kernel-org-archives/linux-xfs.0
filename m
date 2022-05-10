Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C319C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 18:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233830AbiEJSyr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 14:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349090AbiEJSyk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 14:54:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0901C6C81
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 11:54:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B89B261046
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 18:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168DBC385A6;
        Tue, 10 May 2022 18:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652208878;
        bh=yKJb07WIXbbcpgq2UsreY9VN9Bf2TJTKOiZWzFvZ2Mc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m5mhvuFxd2znDTrA6OFkU0zUVrMJ93dCGhKAQ6Y6JGA/+lGPxpp+z01lYs5y5gKe0
         WLB8Vaerm91R2KlzLVGj509YKxKudl1c3yH8sjizyYzBlae2FBYR/U8gijhNxUZFcR
         sQ0LpKHrMMR7mp2pOjcrQyzjEGXZdLDPkZrsSto3bx+yklIlEE/epyc0pnqHW8Xo4E
         KAhhz3OC1APJi8DtzcdL1PosBevR9p0QZfpU+xw7KzJqS8i/n3jQnHyCXfUDpfOH1x
         DZCjzpVPdv2+hKaLo85v9+6ww2mCj1t4HjoRE7lG8jcwGV/8q6AxvlgNoxr16Fcc2X
         hPEEfdSPOP95g==
Date:   Tue, 10 May 2022 11:54:37 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [QUESTION] Upgrade xfs filesystem to reflink support?
Message-ID: <20220510185437.GB27195@magnolia>
References: <CAOQ4uxjBR_Z-j_g8teFBih7XPiUCtELgf=k8=_ye84J00ro+RA@mail.gmail.com>
 <20220509182043.GW27195@magnolia>
 <Ynowf/rmU2UVPlqw@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ynowf/rmU2UVPlqw@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 10, 2022 at 02:29:35AM -0700, Christoph Hellwig wrote:
> On Mon, May 09, 2022 at 11:20:43AM -0700, Darrick J. Wong wrote:
> > > Is there any a priori NACK or exceptional challenges w.r.t implementing
> > > upgrade of xfs to reflink support?
> > 
> > No, just lack of immediate user demand + time to develop and merge code
> > + time to QA the whole mess to make sure it doesn't introduce any
> > messes.
> 
> I also have vague memory I did an in-kernel online upgrade back in the
> day but we decided to not bother in the end.  Maybe some list archive
> search could find it.

https://lore.kernel.org/linux-xfs/1464877150-20457-1-git-send-email-hch@lst.de/

Note that your version did live upgrades of mounted filesystems
whereas the one I wrote does it as part of xfs_repair, which means we
have a somewhat better guarantee that the fs will be in decent shape
afterwards.

--D
