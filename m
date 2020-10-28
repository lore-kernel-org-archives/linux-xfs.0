Return-Path: <SRS0=iKFT=ED=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7153C56202
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 21:51:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 871D52245A
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 21:51:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vhBW71DF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgJ1Vvy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:51:54 -0400
Received: from casper.infradead.org ([90.155.50.34]:44160 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728183AbgJ1Vvx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 17:51:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Le0I1dBERuiC3K+KVa6VwoeMrpWRddpd5K+WfHHhKpY=; b=vhBW71DFY60N7h3ZiDrorT+syx
        6MrX70yU5/3+AEyP09RXQ5NFq8XEIgYoeJiJBzwWHbo/Zg+uPPZahiwoeEGRjgJTdT5v5TdpQaee6
        sIiHtzY6kEwebqVEFSi98rC79RditDMiCpqLf2PsQ3jNugJo0idU+qokNtfc+pqyZN2e3QPzEJnI3
        ARugCN6+CmS7Om//YCoMuPfc4G4YmRiRYfiTET5T2NUmPFcV4lp8j0dttajeknT4J5OZtQy1UcgRf
        gydX5P2SgiPJ35KYo1z2xBcuOK5vKd/y+kU134pm6E3XW+p3kjQrYdSfj2Ko1/ZgRKHdXtI+M7SX3
        +qLwbwQA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXg6T-0000pZ-NB; Wed, 28 Oct 2020 07:42:42 +0000
Date:   Wed, 28 Oct 2020 07:42:41 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs/327: fix inode reflink flag checking
Message-ID: <20201028074241.GE2750@infradead.org>
References: <160382528936.1202316.2338876126552815991.stgit@magnolia>
 <160382532250.1202316.4733915561999380155.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160382532250.1202316.4733915561999380155.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 27, 2020 at 12:02:02PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This is a regression test that tried to make sure that repair correctly
> clears the XFS inode reflink flag when it detects files that do not
> share any blocks.  However, it does this checking by looking at the
> (online) lsattr output.  This worked fine during development when we
> exposed the reflink state via the stat ioctls, but that has long since
> been removed.  Now the only way to check is via xfs_db, so switch it to
> use that.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
