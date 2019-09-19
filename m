Return-Path: <SRS0=IJtx=XO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA132C49ED7
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 17:08:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B2F9214AF
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 17:08:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d4KGLbyd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391848AbfISRIH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Sep 2019 13:08:07 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45474 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390733AbfISRIH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Sep 2019 13:08:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=E6NrFJZUPePgvjh+IWLP3k9agkGqKaeAu5kGIgjh9NE=; b=d4KGLbydtimHaXwG62spHjwLL
        vJuCc26DDicMCYedleKKfcQsaHTVIXuQhsYlkadkZJZRqCpaoPreoJv8yD0Zy6hVE0XHLa721Msp7
        5D5KerI9I4LW+lLjtpKdQBb7MK87uYkxGQ8cWt4e3ranweERHWIZD6tigf5QJiMJctepqY24Qw5fh
        4PSP8GCYUw0mkA+rRDdizNFljYegef9IpEkE+aYggf3vOi2nNdQU0tvhU4l8tlrP4FvDBOXI3/Q62
        jWhQIXROKDFDXK962ifpw7NsdXjQ/f8yWVJKz9DIFEcGcSOdEO2uEUeplvlrZUClVwbPR1VtR2yI5
        Quhh9STeA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iAzuW-0002Je-QD; Thu, 19 Sep 2019 17:08:04 +0000
Date:   Thu, 19 Sep 2019 10:08:04 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [ANNOUNCE] xfs-linux: iomap-5.4-merge rebased to 1b4fdf4f30db
Message-ID: <20190919170804.GB1646@infradead.org>
References: <20190919153704.GK2229799@magnolia>
 <BYAPR04MB581608DF1FDE1FDC24BD94C6E7890@BYAPR04MB5816.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR04MB581608DF1FDE1FDC24BD94C6E7890@BYAPR04MB5816.namprd04.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 19, 2019 at 04:19:37PM +0000, Damien Le Moal wrote:
> OK. Will do, but traveling this week so I will not be able to test until next week.

Which suggests zonefs won't make it for 5.4, right?  At that point
I wonder if we should defer the whole generic iomap writeback thing
to 5.5 entirely.  The whole idea of having two copies of the code always
scared me, even more so given that 5.4 is slated to be a long term
stable release.

So maybe just do the trivial typo + end_io cleanups for Linus this
merge window?
