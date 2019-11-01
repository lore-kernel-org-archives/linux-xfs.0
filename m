Return-Path: <SRS0=5kOL=YZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E1DFCA9ECF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 17:03:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB76B2085B
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Nov 2019 17:03:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O+W6Is9C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729245AbfKARDC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 13:03:02 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49910 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729197AbfKARDC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 13:03:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=3rJyGwKPut+lmwzHI4WUpzHIcd0CR8e6RzmPf+tr6aI=; b=O+W6Is9CriBPFRwyxEHkC5DSw
        v82Rj5linaa/+O8pobgTEekN87On9evYVYAoXWth1MMuL1TqB7LyWj3oz96Pcf5PIlzL//9BSaKVi
        /p/ujaAWR+/VQJvt2REbOHgVzhLI8dwYzlHcdU6440yMbalsSY/TyGsUlgTNW6xWi8kOXTZVPkI/1
        Eb1VKdNJVC55HbgJr7jhiaGTJ6kWElxjtxZfRwlMz34Q8A7tyRnGH0YW8zdE+CN+/hExUExPWUywt
        bS+ExmWVJBUfS7K4+92Y04HgjV8Olb33u+1OfRc3sG2q4xYujY7v59ZUZWTpSrUxxU/tWKxIY66o7
        8KGUI/gxw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQaKE-00087P-5b; Fri, 01 Nov 2019 17:03:02 +0000
Date:   Fri, 1 Nov 2019 10:03:02 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v8 11/16] xfs: move xfs_parseargs() validation to a helper
Message-ID: <20191101170302.GB28495@infradead.org>
References: <157259452909.28278.1001302742832626046.stgit@fedora-28>
 <157259466083.28278.9850069574379459064.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157259466083.28278.9850069574379459064.stgit@fedora-28>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:51:00PM +0800, Ian Kent wrote:
> Move the validation code of xfs_parseargs() into a helper for later
> use within the mount context methods.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
