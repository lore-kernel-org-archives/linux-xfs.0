Return-Path: <SRS0=nhRG=CO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62FBDC43461
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Sep 2020 22:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29AE520797
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Sep 2020 22:02:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OBnzX/hN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgIEWCf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 5 Sep 2020 18:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728327AbgIEWCe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Sep 2020 18:02:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35ACCC061244;
        Sat,  5 Sep 2020 15:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Tlllsl+2PJQqHKeCcF6Zt/oIJ3kjkjvjZo5ekbYN/2w=; b=OBnzX/hN/ATaX+2T63VHasT+Xx
        iT2umIL+vj2hYX2fG4UOhbqedoVPHh8S23NOop5hWTR5UyjRvFQGrCz7a+j4ytCfknwrWRLhWxGHY
        OUi/x1LKcpYcyxmeQGKeKcHEEp968FrDIAVnJIJivwSs3pbiX58iOl4iKOOrEmLwtwp/tADdO0JvJ
        QX/VLWP6960IbZpp9TIObB3zX/IJk9bgXBUhuIL4e47cGsQfCfwk5XIUa01nZnOaD9Trip50nLiB1
        ewNrMH/lh1nNlcdyxbuz0Oza8x7h3bgVtTO5a4BxMPXFdrrWMRFqcMunbdMXNbcVQajDNzq4QELvu
        7Vgr29OA==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kEgGV-0007li-Fe; Sat, 05 Sep 2020 22:02:31 +0000
Date:   Sat, 5 Sep 2020 23:02:31 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Jan Kara <jack@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] quota: widen timestamps for the fs_disk_quota
 structure
Message-ID: <20200905220231.GB16750@casper.infradead.org>
References: <20200905164703.GC7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200905164703.GC7955@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Sep 05, 2020 at 09:47:03AM -0700, Darrick J. Wong wrote:
> +static inline void copy_to_xfs_dqblk_ts(const struct fs_disk_quota *d,
> +		__s32 *timer_lo, __s8 *timer_hi, s64 timer)
> +{
> +	*timer_lo = timer;
> +	if (d->d_fieldmask & FS_DQ_BIGTIME)
> +		*timer_hi = timer >> 32;
> +	else
> +		*timer_hi = 0;
> +}

Is that actually the right thing to do?  If FS_DQ_BIGTIME is not set,
I would expect us to avoid writing to timer_hi at all.  Alternatively, if
we do want to write to timer_hi, why not write to it unconditionally?

