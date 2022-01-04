Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2443C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Jan 2022 07:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbiADHVL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jan 2022 02:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbiADHVK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jan 2022 02:21:10 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9652C061761
        for <linux-xfs@vger.kernel.org>; Mon,  3 Jan 2022 23:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XL+yW9beFujKJoKyGvOSz1BjuS/186Zxc6HZFkXmtKg=; b=eiFv1qvwCnspM9IhQKfzDk0nid
        +GVZzsg2LF3qd5HmlSeYE3xDtS7ea3Qjt0UYP9MhS910Mx92cblmaSEpt5qsjv8wLJ4RCezEeKWwj
        4jw3w3htUl/L9ifJw9MYaCjjvMlq0MLWpAFTiuxoXP4UMQXlBxd24E2gf0mulhpUnbeHg5O0Y0G12
        hXl0xHkV608Ox8lLhZfT8Yk6WYr8Y6c3JNRRJ5QMUw40ewtlOGwdijyJfmufJpX395NClaEKBZE0I
        vNW68nyCH+9holB3/1doxToNM8EImmFLLp3lPFDwYG42zbJTABuBneVH6uDAQ1ieHlyPB9UOxY4Uh
        mctEjGRg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n4e83-00AVRP-Q1; Tue, 04 Jan 2022 07:21:07 +0000
Date:   Mon, 3 Jan 2022 23:21:07 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     "xuyang2018.jy@fujitsu.com" <xuyang2018.jy@fujitsu.com>,
        Christoph Hellwig <hch@infradead.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: The question of Q_XQUOTARM ioctl
Message-ID: <YdP1Y8FAeu871lr7@infradead.org>
References: <616F9367.3030801@fujitsu.com>
 <20220104023456.GE31606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104023456.GE31606@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 03, 2022 at 06:34:56PM -0800, Darrick J. Wong wrote:
> > 
> > I don't know the right intention for Q_XQUOTARM now. Can you give me
> > some advise? Or, we should remove Q_XQUOTARM ioctl and
> > xfs_qm_scall_trunc_qfile code.
> 
> I think xfs_qm_scall_trunc_qfiles probably should be doing:
> 
> 	if (xfs_has_quota(mp) || flags == 0 ||
> 	    (flags & ~XFS_QMOPT_QUOTALL)) {
> 		xfs_debug(...);
> 		return -EINVAL;
> 	}
> 
> Note the inversion in the has_quota test.  That would make it so that
> you can truncate the quota files if quota is not on.

Yes, that sounds reasonable.  Although I'd split the xfs_has_quota
file into a separate check with a separate debug message.
