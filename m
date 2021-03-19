Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D65C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 16:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BF3961955
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Mar 2021 16:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhCSQ71 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Mar 2021 12:59:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230108AbhCSQ7Z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Mar 2021 12:59:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F0A761957;
        Fri, 19 Mar 2021 16:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616173165;
        bh=+nXv67gwylzxL4kB8nxPJAwMjswwdYiw1/5aDdP4XFE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WihulB6MXit6ufTuzqexcOpMSji8sECWxl/iDKbeulRP9eAQIrU/EW7XvoRUtL7kW
         6/tls5wpbXF2EFiod+VGfs/eue6TrVogor/1F80FpiAaGmB7pjXWZd/GauH6QERTp3
         TgbExdgbeRlPxJ66jPO3WSpcMSr7xh/Y0srjCYoZ1Nd7rBY1mwvFXDvFMMWK+aGQfC
         TgbxiRLiw1XJtPH0NI8sRvpF5G6M0dDH2AbJGDe1B4OvrhpuBqMhbRYAJpTwCOsZfo
         fmaLeVMDv0HDhRulv1iX9C9wLOhlDJd2hDhtM38ugg8VjOmTfgxtN8+tTHIrs8CUxX
         V31kDnyZDmZJw==
Date:   Fri, 19 Mar 2021 09:59:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: move the check for post-EOF mappings into
 xfs_can_free_eofblocks
Message-ID: <20210319165924.GR22100@magnolia>
References: <161610680641.1887542.10509468263256161712.stgit@magnolia>
 <161610681767.1887542.5197301352012661570.stgit@magnolia>
 <20210319055907.GB955126@infradead.org>
 <20210319060534.GF1670408@magnolia>
 <20210319063537.GB965589@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319063537.GB965589@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 19, 2021 at 06:35:37AM +0000, Christoph Hellwig wrote:
> On Thu, Mar 18, 2021 at 11:05:34PM -0700, Darrick J. Wong wrote:
> > xfs_inactive doesn't take the iolock because (evidently) at some point
> > there were lockdep complaints about taking it in reclaim context.  By
> > the time the inode reaches inactivation context, there can't be any
> > other users of it anyway -- the last caller dropped its reference, we
> > tore down the VFS inode, and anyone who wants to resuscitate the inode
> > will wait in xfs_iget for us to finish.
> 
> Yes.  What I meant is that if we can deduce that we are in inactive
> somehow (probably using the VFS inode state) we can ASSERT that we
> are either in inactive or hold the iolock.

Yeah, I think we can do:

	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL) ||
	       (VFS_I(ip)->i_state & I_FREEING));

--D
