Return-Path: <SRS0=yXRu=2O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00769C3F68F
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 11:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9DAF20706
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Dec 2019 11:28:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="C4msNrpO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbfLXL2s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Dec 2019 06:28:48 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:48630 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfLXL2s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Dec 2019 06:28:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=eeGktmG27cS6ntegZtja6DJNcWGUSKxmq9N11h/xcOM=; b=C4msNrpOXv31pMiNNgpW4ZgB4
        Lm7yhvWsCHRM1MXDpX4A8DUYNdJtmO4DP3QTL0Zs+1eIUMBSHT9cc9No2+ehPiQoPtDT/nng5qQu0
        asrnoCi5MW4glQjszVRu1m/+Dwgqqj1TGWwlQGMIT2rSrhMMG24Ksl/PGlw8NLn8MjouPC3I3KOFn
        OZ9+u+YMAoNL7g3S7plq2Cq7hAPZjf7PLZRVay8H1l1nwS25YecZ/XcPXzq3wNrk1rDnZKvelTEuB
        Z3fRlzuFHDKf5Xq7Vmf0BpSqKXQzqF8wBctSUkWnKnvM2+X1RNtavXZszyCyKSrPpCbVhTksKq+l7
        0MEvjGh0Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ijiMn-0001pn-VG; Tue, 24 Dec 2019 11:28:45 +0000
Date:   Tue, 24 Dec 2019 03:28:45 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: rework insert range into an atomic operation
Message-ID: <20191224112845.GC24663@infradead.org>
References: <20191213171258.36934-1-bfoster@redhat.com>
 <20191213171258.36934-3-bfoster@redhat.com>
 <20191218023726.GH12765@magnolia>
 <20191218121033.GA63809@bfoster>
 <20191218211540.GB7489@magnolia>
 <20191219115550.GA6995@bfoster>
 <20191220201717.GQ7489@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220201717.GQ7489@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 20, 2019 at 12:17:17PM -0800, Darrick J. Wong wrote:
> I think directio completions might suffer from the same class of problem
> though, since we allow concurrent dio writes and dio doesn't do any of
> the ioend batching that we do with buffered write ioends.

OTOH direct I/O completions are per-I/O, and not per-extent like
buffered I/O completions.  Moreover for the case where we don't update
i_size and don't need a separate log force (overwrites without O_SYNC
or using fua) we could actually avoid the workqueue entirely with just
a little work.

> It might also be nice to find a way to unify the ioend paths since they
> both do "convert unwritten and do cow remapping" on the entire range,
> and diverge only once that's done.

They were common a while ago and it was a complete mess.  That is why
I split them.

