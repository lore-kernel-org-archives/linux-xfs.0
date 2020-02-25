Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B43F8C35E04
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85F8C20CC7
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 17:56:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eA5LsAFx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730017AbgBYR4T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 12:56:19 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:60710 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728483AbgBYR4S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 12:56:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gGG2cTbC8cRRfSB7I1Voi9e3hRiBsj22wWL0rdTPmKg=; b=eA5LsAFx6uNIX4kJjF5DOVuPb8
        ltVdoiD/8m37s7Kekyz6654EOLuyzgSmbCbqdoVc6gHxbFHPwr67XNsu3KLvIRvkYHeotac0AANRO
        SyZuXgKs5mdLc1eo+4aWVoMSfQ2MFII866OqcEzOad4Iaoann85h5ladZf9Qbw1RQeAAno7IO8WRO
        Lf0p1aPJzM/E+MmCrIbAfYFJ3HaUjubfOBJYgs+4pvQ0Exka5rxhyiDxy3nKgkMQ5jx92wb/2DbbF
        8o7bu0dgCzoFEO+ikqyCLGw6wVODwF9SV9ecxcYIKVTBQ/EouG6T7EMFkf0PZ3ljJxONPBKgbQ4/R
        Mnf+YmUQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6eRN-0002mp-F9; Tue, 25 Feb 2020 17:56:17 +0000
Date:   Tue, 25 Feb 2020 09:56:17 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] xfs: mark ARM OABI as incompatible in Kconfig
Message-ID: <20200225175617.GB4129@infradead.org>
References: <ee78c5dd-5ee4-994c-47e2-209e38a9e986@redhat.com>
 <20200225005553.GD6740@magnolia>
 <79faa339-d6b8-d8eb-0857-7d755a780805@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79faa339-d6b8-d8eb-0857-7d755a780805@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 04:58:20PM -0800, Eric Sandeen wrote:
> Yeah probably.
> 
> But now looking at
> 
> aa2dd0ad4d6d xfs: remove __arch_pack
> 
> hch indicates that some non-arm architectures have similar problems,
> so is there any point to excluding this one config on this one arch?

Yes, I think we just need to be more careful with our newly added
structure layouts and whenever we do a major reorganization of an
existing one.
