Return-Path: <SRS0=IJtx=XO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42B06C3A5A6
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 21:03:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0569721920
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 21:03:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cPTd4V0K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732070AbfISVDe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Sep 2019 17:03:34 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49126 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730064AbfISVDe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Sep 2019 17:03:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vr+IkYd0U4HZmwFAcpIRMbJ8jy/FCkzgcVYdBFXXhcA=; b=cPTd4V0KHEXTJHZIfFEwYMO+6
        8kCqHaF3ohVIeKOoqySoYiVvEGk2P5difLXB8utE222C1Au9hWTeFxcjdKZI35c8Q78/TIIIleeiq
        PgSZqGcbqViFyu1cv1UGwycM+BAVu4r5tjJDn9GRyTUSQ9m1VWJiIVZA/BDI4ox3KT8RxYZrT3qFx
        aUoWxrwn4CfG18yi4dbLXxqzRMPUsXX72DZue6iRV29k+QJQy5Gf0wX5bxrD3gGJsMv0Nc0Nono26
        KVM0HlE8nyuefPbBWIsOI8HLqehRkGBhqASSvVF3Ac1DWSvQk1cSC+Nc65ZS1S/my5N6OGtjexlp5
        9L3C9156w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iB3aJ-00009b-RT; Thu, 19 Sep 2019 21:03:27 +0000
Date:   Thu, 19 Sep 2019 14:03:27 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [ANNOUNCE] xfs-linux: iomap-5.4-merge rebased to 1b4fdf4f30db
Message-ID: <20190919210327.GA500@infradead.org>
References: <20190919153704.GK2229799@magnolia>
 <BYAPR04MB581608DF1FDE1FDC24BD94C6E7890@BYAPR04MB5816.namprd04.prod.outlook.com>
 <20190919170804.GB1646@infradead.org>
 <20190919194011.GN2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919194011.GN2229799@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 19, 2019 at 12:40:11PM -0700, Darrick J. Wong wrote:
> iomap: Fix trivial typo
> iomap: split size and error for iomap_dio_rw ->end_io
> iomap: move the iomap_dio_rw ->end_io callback into a structure
> 
> But frankly, do we even need the two directio patches?  IIRC Matthew
> Bobrowski wanted them for the ext4 directio port, but seeing as Ted
> isn't submitting that for 5.4 and gfs2 doesn't supply a directio endio
> handler, maybe I should just send the trivial typo fix and that's it?

You can decide as the maintainer.  I'm always happy to get simple
patchws with API changes like the end_io off to Linus as quick as
possible, though.
