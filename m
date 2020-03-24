Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91186C41621
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 08:43:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73AC720870
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 08:43:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgCXInI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 04:43:08 -0400
Received: from verein.lst.de ([213.95.11.211]:34517 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbgCXInH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Mar 2020 04:43:07 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id BE9DC68B05; Tue, 24 Mar 2020 09:43:04 +0100 (CET)
Date:   Tue, 24 Mar 2020 09:43:04 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Christoph Hellwig <hch@lst.de>, guaneryu@gmail.com,
        jtulak@redhat.com, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: remove xfs/191-input-validation
Message-ID: <20200324084304.GA25318@lst.de>
References: <20200318172115.1120964-1-hch@lst.de> <20200319043306.GK14282@dhcp-12-102.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319043306.GK14282@dhcp-12-102.nay.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 19, 2020 at 12:33:06PM +0800, Zorro Lang wrote:
> On Wed, Mar 18, 2020 at 06:21:15PM +0100, Christoph Hellwig wrote:
> > This test has constantly failed since it was added, and the promised
> > input validation never materialized.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> 
> Hmm... that's truth this case always fails. But a mkfs.xfs sanity test is
> good.
> 
> We have a RHEL internal mkfs.xfs sanity test case, but it takes long time to
> run, can't port to xfstests directly.
> I don't know if Jan would like to improve this case, might make it simple,
> remove those unstable test lines, rewrite the case to avoid unstable test
> results? Or we remove this case, then write a new one?
> I can do that too, if the xfs-devel thinks it worth.

Fine with me, but we really need to get rid of tests failing for no
good reason.  And given that there hasn't been any action for years
just removing this test seems like the by far best option.
