Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C947C35E01
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:21:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9A1D20838
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:21:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Rk8kMIoe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbgBYRVU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 12:21:20 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:56324 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727983AbgBYRVU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 12:21:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eSchbCSasqZkDe1s1y9/Mh6bUm2yN8S6W1wPSMld3zU=; b=Rk8kMIoeErzRlh8zc5ojRznQg5
        Kon6tlf0TQcPerijWn6lOI8o0+RB49ExEX5ecAmqvoGXFjrou5Plh0TPPTMPIvKPuDSM/LcA1HGAU
        Wfsed00cLmR7HsyYy6jH58P+a1OQvR3hMAUCfEdbrjd/16v7IXy0TKFt8wMHciBDMGhxsd8M/maOB
        +/+UAvcNQ2Hd/9wJ3j7MNMJrdnI5C1LcXxtWonsDmS+e3Mog9klEUFUpERftqvs3zaq+inh5yj3yz
        zutWj/QaW6vz0QdlMyqi/bv4L9X8QJYvqm37yWOrzJM4Fqvqixyz6efjn8k7LNqgWH7r89U27QmXY
        nS1gRLPA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6dtV-0002u0-46; Tue, 25 Feb 2020 17:21:17 +0000
Date:   Tue, 25 Feb 2020 09:21:17 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Allison Collins <allison.henderson@oracle.com>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 02/19] xfs: Embed struct xfs_name in xfs_da_args
Message-ID: <20200225172117.GA2937@infradead.org>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-3-allison.henderson@oracle.com>
 <20200225005718.GC10776@dread.disaster.area>
 <5de019d4-d19f-315d-0299-3926c49cf150@oracle.com>
 <20200225040652.GD10776@dread.disaster.area>
 <d3fdea13-ff1d-ed69-8005-60193c2d2e53@oracle.com>
 <20200225042707.GF6740@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225042707.GF6740@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 08:27:07PM -0800, Darrick J. Wong wrote:
> At this point you might as well wait for me to actually put hch's attr
> interface refactoring series into for-next (unless this series is
> already based off of that??) though Christoph might be a bit time
> constrained this week...

I can resend it.  The only change from the last version is to drop
the da_args move, I've just been waiting for more comments to not
spam the list too much..
