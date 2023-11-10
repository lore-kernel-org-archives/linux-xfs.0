Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0070C4167B
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Nov 2023 18:15:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344857AbjKJSPF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Nov 2023 13:15:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235393AbjKJSO3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Nov 2023 13:14:29 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863578682;
        Thu,  9 Nov 2023 23:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WcqbHTawts+uSnzuvifHEMIEpu10PW7yxePWCzc/iZo=; b=CiKifnrFplg/pmYpogdkbkCz9b
        KyI5DM9/HsfiuRAZcaLtJZFZUiwbP32u0DY+PXi0rgQRu1opftUcxeZRLuNkUNcMX7cZ9Thc/mkPr
        PCROHWLoP9mceVxpLyVxnWOAKRR+N5Dzz2Ef/bPnkYmEpdbrOd8hrVOb9HjVM7Mkibph1Caf/S7AM
        jlNirrkuCo1ydJmpMTfT/sDratNFktebkPo4bMm+x1lA7Xu58XwibV+LGlctEBTuSg/Gg/hE4Z84C
        nm9V576XoqlKNFY6F80r1ydwh+npiI5PtEpUqlcrEw73IIzJzV2kn0O5usurNHeJ72+4uQBVIAU/B
        sNfUjETw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1r1M2A-0081y5-38;
        Fri, 10 Nov 2023 07:34:31 +0000
Date:   Thu, 9 Nov 2023 23:34:30 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <carlos@maiolino.me>
Subject: Re: [Bug report][fstests generic/047] Internal error !(flags &
 XFS_DABUF_MAP_HOLE_OK) at line 2572 of file fs/xfs/libxfs/xfs_da_btree.c.
 Caller xfs_dabuf_map.constprop.0+0x26c/0x368 [xfs]
Message-ID: <ZU3dBpU67dG6rq3z@infradead.org>
References: <20231107080522.5lowalssbmi6lus3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUnxswEfoeZQhw5P@dread.disaster.area>
 <20231107151314.angahkixgxsjwbot@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUstA+1+IvHJ87eP@dread.disaster.area>
 <CAN=2_H+CdEK_rEUmYbmkCjSRqhX2cwi5yRHQcKAmKDPF16vqOw@mail.gmail.com>
 <ZUx429/S9H07xLrA@dread.disaster.area>
 <20231109140929.jq7bpnuustsup3xf@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZU1nltE2X6qLJ8EL@dread.disaster.area>
 <20231110013651.fw3j6khkdtjfe2bj@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZU2PhTKqwNEbjK13@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZU2PhTKqwNEbjK13@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +	if (!xfs_has_v3inodes(mp)) {
> +		if (ldip->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
> +			/*
> +			 * Deal with the wrap case, DI_MAX_FLUSH is less
> +			 * than smaller numbers
> +			 */
> +			if (be16_to_cpu(dip->di_flushiter) == DI_MAX_FLUSH &&
> +			    ldip->di_flushiter < (DI_MAX_FLUSH >> 1)) {
> +				/* do nothing */
> +			} else {
> +				trace_xfs_log_recover_inode_skip(log, in_f);
> +				error = 0;
> +				goto out_release;
> +			}

Tis just moves the existing code, but the conditional style is really
weird vs a simple:

			if (be16_to_cpu(dip->di_flushiter) != DI_MAX_FLUSH ||
			    ldip->di_flushiter >= (DI_MAX_FLUSH >> 1)) {
				trace_xfs_log_recover_inode_skip(log, in_f);
				error = 0;
				goto out_release;
			}

Nitpicking aside, this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
