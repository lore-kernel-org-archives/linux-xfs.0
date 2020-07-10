Return-Path: <SRS0=IY5l=AV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B44C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 09:00:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C4BC206E2
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 09:00:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qhVQBEud"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgGJJAo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jul 2020 05:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgGJJAn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jul 2020 05:00:43 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E5BC08C5CE
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jul 2020 02:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iRnF2UzEOLAQZBwswsINfbA2CNZ+sZDuzKAT65EpUjM=; b=qhVQBEudx0ZKhoQ5W6/Ou8E8UC
        513/cJKbMn2FoloS8NqUg4xrLdDfdC7B/LVY8hoHfxBEyzOVvPYw0RA3zrxFn9Nrd3YrM21dRsZjD
        NH/7AntCtcCwFEERUTzorMtb516+Y0jR6k+eDGQtoz7k9ZEwkLB4xEWVwJUhs5umV+/6U+lyCQDdq
        IIiGferarn9rZst3hgC4TPY1qvQNjVDE0lXC73ejNXOF70xhIRF2caGosQLKkAJ2M0ns1SU296Y+3
        fQnc/gWsPFqBk4oROpgvEkjyXQIU5nR1P4fSJU0f/ERrNEOXMAjZjbKVR4g5AKU3wJyqUU5siLdyX
        sFkgn4XA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtote-00088g-BJ; Fri, 10 Jul 2020 09:00:42 +0000
Date:   Fri, 10 Jul 2020 10:00:42 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Bill O'Donnell <billodo@redhat.com>
Cc:     linux-xfs@vger.kernel.org, sandeen@redhat.com,
        darrick.wong@oracle.com
Subject: Re: [PATCH] xfsprogs: xfs_quota state command should report ugp
 grace times
Message-ID: <20200710090042.GB30797@infradead.org>
References: <20200709212657.216923-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709212657.216923-1-billodo@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 09, 2020 at 04:26:57PM -0500, Bill O'Donnell wrote:
> Since grace periods are now supported for three quota types (ugp),
> modify xfs_quota state command to report times for all three.

This looks like it'll clash with the patch that Darrick just sent..

> +	if (type & XFS_USER_QUOTA) {
> +		if (xfsquotactl(XFS_GETQSTATV, dev, XFS_USER_QUOTA,
> +				0, (void *)&sv) < 0) {
> +			if (xfsquotactl(XFS_GETQSTAT, dev, XFS_USER_QUOTA,
> +					0, (void *)&s) < 0) {
> +				if (flags & VERBOSE_FLAG)
> +					fprintf(fp,
> +						_("%s quota are not enabled on %s\n"),
> +						type_to_string(XFS_USER_QUOTA),
> +						dev);
> +				return;
> +			}
> +			state_stat_to_statv(&s, &sv);
>  		}
>  
>  		state_qfilestat(fp, mount, XFS_USER_QUOTA, &sv.qs_uquota,
>  				sv.qs_flags & XFS_QUOTA_UDQ_ACCT,
>  				sv.qs_flags & XFS_QUOTA_UDQ_ENFD);
> +		state_timelimit(fp, XFS_BLOCK_QUOTA, sv.qs_btimelimit);
> +		state_timelimit(fp, XFS_INODE_QUOTA, sv.qs_itimelimit);
> +		state_timelimit(fp, XFS_RTBLOCK_QUOTA, sv.qs_rtbtimelimit);
> +	}

Any chance we could factor this repititive code into a helper?
