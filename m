Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FEE5C48BE5
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 16:14:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6600461206
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 16:14:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhFUQQc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Jun 2021 12:16:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229789AbhFUQQb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Jun 2021 12:16:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36C466115B;
        Mon, 21 Jun 2021 16:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624292057;
        bh=wAuMctmcj7Rpl7yXbn+GsG7NAotqbttVPeDzRyw3rsw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SoEWTFX6J9nd4JCFiBYK7VqwrdFSoKWtzclhvJOsXQ2nf2Uj6bfhZ1X/HmZunehIs
         ueo6mg+95kVmKpkCpRQwoCavCpQR2jMGKiESl8joKLWRQPYvk7L1hoPilxlZpeAeQF
         iaZ5Z/rKhm0XZlbQLBQ2D/qk84hTQ51pX7f8O0thGLPrWR1KjyEvNi2WfJfhlY5Fw5
         T2lLLBtHtmbQaITmEICF1pqVpn1aY14PB6eVvlVOoizOgjuF8HiJsG6E+bU93aRCrp
         A6PsFavf6HtPf1kQgzWQ1IPUuTsCNKDLVg2JPGcD6PHQCPhsjOqR30npZ0zdJ9hn1i
         Uyt3iOMh99l5g==
Date:   Mon, 21 Jun 2021 09:14:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eryu Guan <eguan@linux.alibaba.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Eryu Guan <guaneryu@gmail.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>,
        ebiggers@kernel.org
Subject: Re: [PATCH 07/13] fstests: automatically generate group files
Message-ID: <20210621161416.GE158186@locust>
References: <162370437774.3800603.15907676407985880109.stgit@locust>
 <YMmpDGT9b4dBdSh2@infradead.org>
 <20210617001320.GK158209@locust>
 <YMsAEQsNhI1Y5JR8@infradead.org>
 <20210617171500.GC158186@locust>
 <YMyjgGEuLLcid9i+@infradead.org>
 <CAOQ4uxjvkJh2XcfDgj7g+JUkFXEc36_6YOKQHJ=pX2hpGfUDhQ@mail.gmail.com>
 <20210618155630.GE158209@locust>
 <YNAiutsL1f/KoBXM@infradead.org>
 <20210621063845.GG60846@e18g06458.et15sqa>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210621063845.GG60846@e18g06458.et15sqa>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 21, 2021 at 02:38:45PM +0800, Eryu Guan wrote:
> On Mon, Jun 21, 2021 at 06:25:14AM +0100, Christoph Hellwig wrote:
> > On Fri, Jun 18, 2021 at 08:56:30AM -0700, Darrick J. Wong wrote:
> > > On Fri, Jun 18, 2021 at 06:32:18PM +0300, Amir Goldstein wrote:
> > > > On Fri, Jun 18, 2021 at 4:47 PM Christoph Hellwig <hch@infradead.org> wrote:
> > > > >
> > > > > On Thu, Jun 17, 2021 at 10:15:00AM -0700, Darrick J. Wong wrote:
> > > > > > I suppose I could make the '-g' switch call 'make group.list', though
> > > > > > that's just going to increase the amount of noise for anyone like me who
> > > > > > runs fstests with a mostly readonly rootfs.
> > > > >
> > > > > Just stick to the original version and see if anyone screams loud
> > > > 
> > > > What is the original version?
> > > 
> > > Assuming the developer is smart enough to run 'make all install' before
> > > running fstests.
> > 
> > So install is also required now?  I have never before installed xfstests
> > I think.

Sorry, that should have read “...enough to run 'make all' or 'make
install' before running...”.

> No, install is not required, but running make after updating fstests is
> required, at least some tests may introduce new test binary in src and
> the binary is missing if you don't run make. So I think make is fine
> after updating fstests.

Ok, I'll leave this as it was and resubmit the series with the other
tweaks suggested by Christoph.

--D

> Thanks,
> Eryu
