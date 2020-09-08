Return-Path: <SRS0=Kgg+=CR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 530FAC43461
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 19:07:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E65C02076C
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Sep 2020 19:07:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Nmh11ZEh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731409AbgIHTGo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Sep 2020 15:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731257AbgIHQHN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Sep 2020 12:07:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926E5C09B055
        for <linux-xfs@vger.kernel.org>; Tue,  8 Sep 2020 07:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MUAeRX7GmBiVM860Jkmek+70sDnyw+AEtfTyEVYpPy8=; b=Nmh11ZEh6xjqKhV6fI1zgQoyor
        mwcKSVarvkAL5yJwHS2myS9TVrDNKPFzu6ZMBKXSWaIEr6KUd2UPfmKHy0rig0pjVKwrmyuMcpwRA
        WyBngCl/H20J9p+geqIZgffdIqidTfSr7Derl2zZZM+2q5FWwf+OUGJ768DLR9Lw8vqYCQuPlrBui
        +JGN0Ux9TJVgytHR89nVF9yW3eqQ9C9VNFGq3XvxgGK6Q/tumcOtKwAWUeASBKKiX3QWvV8LI4eVq
        31XTaM26F9qmD4gUUZGELq5h9Gh8H1TYUbAonr7WfWlaK3GfF9QWH67scXlBV+C2/qvAz1GT71f/V
        8kZjUniQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFeyF-0002pM-UY; Tue, 08 Sep 2020 14:51:44 +0000
Date:   Tue, 8 Sep 2020 15:51:43 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs_repair: complain about unwritten extents when
 they're not appropriate
Message-ID: <20200908145143.GI6039@infradead.org>
References: <159950111751.567790.16914248540507629904.stgit@magnolia>
 <159950114274.567790.13140838452739405641.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159950114274.567790.13140838452739405641.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 07, 2020 at 10:52:22AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We don't allow unwritten extents in the attr fork, and we don't allow
> them in the data fork except for regular files.  Check that this is the
> case.
> 
> Found by manually fuzzing the extentflag field of an attr fork to one.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
