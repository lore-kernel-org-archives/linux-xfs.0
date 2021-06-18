Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8513AC49361
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 15:56:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D6CF6113E
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Jun 2021 15:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235648AbhFRP6m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 11:58:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235647AbhFRP6l (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 Jun 2021 11:58:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C08ED61351;
        Fri, 18 Jun 2021 15:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624031790;
        bh=TgVcoY/zKpZktbl0xXe4ndDmpXVSRtlnB5jz2/7tvbU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QBf1Lhtwf8LSVV5Ib/2pI9PBczUu+H5rPf72R4OCQSQtjLBhlyzmV/+Fog4UaRYHS
         7f39X4N/F1F8idssHjNRiUD3Jm1HL4OMGXCU30Bm2YVjFiru1FjuD7m/6o1uVt8JD2
         jIIsb+k4KJddYpag7X7ktXaw1Tcq9q9T1/O96VA77ii71/H+siVnl/WhImO8hsAUEq
         PybPIWQEirFRSLh+6orFCbgAAag1HuFE/oKQ4jiYlAxXFvmeGs/BlR8Tjr5jwhp6n4
         YtE+exImfyCqlQmdtWthHtCU4Inc8EBF0/k3yZ+tF0nBgmZJNsVHdlPVe/vHW0wQg2
         nlMBuOK2pKASA==
Date:   Fri, 18 Jun 2021 08:56:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Eryu Guan <guaneryu@gmail.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>,
        ebiggers@kernel.org
Subject: Re: [PATCH 07/13] fstests: automatically generate group files
Message-ID: <20210618155630.GE158209@locust>
References: <162370433910.3800603.9623820748404628250.stgit@locust>
 <162370437774.3800603.15907676407985880109.stgit@locust>
 <YMmpDGT9b4dBdSh2@infradead.org>
 <20210617001320.GK158209@locust>
 <YMsAEQsNhI1Y5JR8@infradead.org>
 <20210617171500.GC158186@locust>
 <YMyjgGEuLLcid9i+@infradead.org>
 <CAOQ4uxjvkJh2XcfDgj7g+JUkFXEc36_6YOKQHJ=pX2hpGfUDhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjvkJh2XcfDgj7g+JUkFXEc36_6YOKQHJ=pX2hpGfUDhQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 18, 2021 at 06:32:18PM +0300, Amir Goldstein wrote:
> On Fri, Jun 18, 2021 at 4:47 PM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > On Thu, Jun 17, 2021 at 10:15:00AM -0700, Darrick J. Wong wrote:
> > > I suppose I could make the '-g' switch call 'make group.list', though
> > > that's just going to increase the amount of noise for anyone like me who
> > > runs fstests with a mostly readonly rootfs.
> >
> > Just stick to the original version and see if anyone screams loud
> 
> What is the original version?

Assuming the developer is smart enough to run 'make all install' before
running fstests.

--D

> > enough.  Of course the best long-term plan would be to not even generate
> > group files by just calculate the list in-memory.
> 
> Why in-memory?
> check already creates $tmp.list with the list of test files right?
> Any reason not to the group.list files under /tmp while preparing
> the test list instead of creating them in the src directory?
> 
> Thanks,
> Amir.
