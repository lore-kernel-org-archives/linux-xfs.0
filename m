Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6836DC11D0C
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 15:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36CD824670
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 15:59:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t4XBm0GT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgBTP7q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 10:59:46 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:57750 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728684AbgBTP7q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 10:59:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4HSLoqTPrk9DoM6LQyotYg3QdLXV2nALBfwaYUbwPI4=; b=t4XBm0GTrQys+uGUSMwmgbrcc/
        dDn5MCRhiizJeeMUvJUm6oBBhcjlujUd9+vqCi3cSc8SiTwou53ls7dbEZTRNLqPngKRqGrGXyl5D
        fIBtl7+hNVIFMgwejKSU3Q55cBRhSuH6qW+iiECUW+cDbisj7o4lgMcb3wOz02BiHJyfXTILL+vY9
        PI4JOFLNAhIhTy0pxiof0b/H384RocLAtXKndhrhvR5/GE7qrp994XczunQciN7BpGeqyZr0RGikt
        eVmiyPRMn3r6Htg3LQHtjob0Bh6Y5JqsO0fFg7zzZDf55AmeYnSDrOCJCltfaRlWO+ZTEIDWS7MS0
        AwV0+jiw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4oEk-0000RZ-1o; Thu, 20 Feb 2020 15:59:38 +0000
Date:   Thu, 20 Feb 2020 07:59:38 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Richard Haines <richard_c_haines@btinternet.com>,
        sds@tycho.nsa.gov, paul@paul-moore.com, linux-xfs@vger.kernel.org,
        selinux@vger.kernel.org
Subject: Re: [PATCH 0/1] selinux: Add xfs quota command types
Message-ID: <20200220155938.GA1306@infradead.org>
References: <20200220153234.152426-1-richard_c_haines@btinternet.com>
 <20200220155731.GU9506@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220155731.GU9506@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 07:57:31AM -0800, Darrick J. Wong wrote:
> On Thu, Feb 20, 2020 at 03:32:33PM +0000, Richard Haines wrote:
> > Added these quota command types for SELinux checks on XFS quotas. I picked
> > those I thought useful. The selinux-testsuite will have tests for these
> > permission checks on XFS.
> > 
> > One point to note: XFS does not call dquot_quota_on() to trigger
> > security_quota_on(), therefore the 'file quotaon' permission is not tested
> > for SELinux
> 
> Is that a feature or a bug? :)
> 
> (It sounds like a bug to me, but let's see if anyone complains...)

The dquot_* routines are not generic quota code, but a specific
implementation used by most non-XFS file systems.  So if there is a bug
it is that the security call is not in the generic dispatch code.
