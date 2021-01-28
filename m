Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AF1BC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 18:27:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DA8C64E1D
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 18:27:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbhA1S13 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 13:27:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbhA1SYN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 13:24:13 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2174C061786
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jan 2021 10:23:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JMPqnatYN+lowVl6hO6CaR9Pk8I15diI48+yKI+tovI=; b=O1VzDFAoOqX1ipUaHQBPINDMoR
        IpSm5605yFrv0y7THELn0CY4TI8v9zcgEiTBexIOSFFA40fXRZ8OsyJlQwkFU5MUlt4mwxIX2AebH
        Zx070ZzRn70QKEz9E9BW/18ZfKlazZDpBw4+44tJHwfr7xoZcI7XP0JIVDnCfMF3mDRa4z2wcEQZt
        8e8yqpwLelMcBIniw/EaagIljSVrlCDRf2fN2jwQ6yDP5JamCToDbEA0gaoSlLwH46ksxgyq3ErDF
        XwCr/7sArPwN66pUAPxK00Bq6b2jLH9GGy2K2TSputeex+LSPeiWlONpzoRXuFGdmthn50MS5pWyr
        08mn3Trw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l5BxP-008oYJ-Ta; Thu, 28 Jan 2021 18:23:52 +0000
Date:   Thu, 28 Jan 2021 18:23:51 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 05/13] xfs: fix up build warnings when quotas are disabled
Message-ID: <20210128182351.GA2100786@infradead.org>
References: <161181366379.1523592.9213241916555622577.stgit@magnolia>
 <161181369266.1523592.14023535880347018628.stgit@magnolia>
 <20210128180922.GD2619139@bfoster>
 <20210128182249.GW7698@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128182249.GW7698@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 28, 2021 at 10:22:49AM -0800, Darrick J. Wong wrote:
> > > -#define xfs_qm_dqrele(d)
> > > -#define xfs_qm_statvfs(ip, s)
> > > +#define xfs_qm_dqrele(d)			do { (d) = (d); } while(0)
> > 
> > What's the need for the assignment, out of curiosity?
> 
> It shuts up a gcc warning about how the dquot pointer is set but never
> used.  One hopes the same gcc is smart enough not to generate any code
> for this.

The alternative would be to turn these stubs into inline functions,
which would also kill the warning.
