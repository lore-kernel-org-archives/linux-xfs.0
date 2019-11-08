Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E017FA372C
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:14:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FEA02087E
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:14:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WM0ghAzh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbfKHHOl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 02:14:41 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52200 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfKHHOl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 02:14:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4IFDjpl8dpUyTP/q3OWHzF2ave7OrdzwPN3zxcsEi2I=; b=WM0ghAzhtGRp3RSF5xOsI0lvm
        GkAIXtiR78L2BFJtd4/0DG10a06JagE9q2wQLYOxIJ6OfvWdJVkngCTtJMmhWjld5lZZm/OErJUYR
        edPiS5PtACDks517KJ1hjbLkliniY1dy4Cs0d8aerIle/h+ob5oCUSA8/leI5nsYbFBF1/V+yaWUG
        iLrLvfJl78snyYXKU3hEsdWLgftBaTvpv7PYLq8FbOIgDPbiFqd/jZuWpFDFWAOHAvEraMn7lGkiF
        JwE2K4NZ8CKD4b92gDLvMH6b6/c+5A4ugUInmi8kf2A5CnNs9+2w0KHYfcZlExZDEMdJnM8TUIrnh
        bixUdZMaQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSyTh-0001wH-Ah; Fri, 08 Nov 2019 07:14:41 +0000
Date:   Thu, 7 Nov 2019 23:14:41 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: actually check xfs_btree_check_block return in
 xfs_btree_islastblock
Message-ID: <20191108071441.GB31526@infradead.org>
References: <157319668531.834585.6920821852974178.stgit@magnolia>
 <157319670439.834585.6578359830660435523.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157319670439.834585.6578359830660435523.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 11:05:04PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Coverity points out that xfs_btree_islastblock calls
> xfs_btree_check_block, but doesn't act on an error return.  This
> predicate has no answer if the btree is corrupt, so tweak the helper to
> be able to return errors, and then modify the one call site.

Could we just kill xfs_btree_islastblock?  It has pretty trivial, and
only has a single caller which only uses on of the two branches in the
function anyway.
