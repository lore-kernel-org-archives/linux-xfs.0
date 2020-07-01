Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40FABC433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:27:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12B9320775
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:27:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oPnKx/rB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbgGAI1p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728450AbgGAI1o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:27:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75CC3C061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HWRUIH7nQ5n9/cjG2TP+TwPxD3+3l5RtpwKILN2cTmI=; b=oPnKx/rBTP3KbXktuRKFL7qHKd
        36rkzowbmdCFj5tIcMxeP+rkn2nXcZ1nQ0tK20JD03OCZjoCf0Lrn9jvNil9JVe4P7Qa2gvJmP6OC
        UsqNDzl5c+SPeRMVR9YNfSYdvQAO260Ipa85nwZPzL9hSbYOdpoSc4BajtCJhT99uWVxHQvkchOj+
        8TUQmkEi0beEwk0H15Je2kq0UUEaTQrrLuyuNojmPz9Lrx9/5QtcVZqRPfzEG8I/Jamwc5HQWrZMM
        HxtrGq8/1Rc+PP4C0ye18/qZu8DJi1HQp98OAbB1oZtvim7nRxMLlguNVihmTfkftBbdVJ0vSe4f5
        Pz7Ml6dA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqY5l-0006ID-5v; Wed, 01 Jul 2020 08:27:41 +0000
Date:   Wed, 1 Jul 2020 09:27:41 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        edwin@etorok.net
Subject: Re: [PATCH 9/9] xfs: move helpers that lock and unlock two inodes
 against userspace IO
Message-ID: <20200701082741.GH20101@infradead.org>
References: <159304785928.874036.4735877085735285950.stgit@magnolia>
 <159304791766.874036.17659898139855742701.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159304791766.874036.17659898139855742701.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 24, 2020 at 06:18:37PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the double-inode locking helpers to xfs_inode.c since they're not
> specific to reflink.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
