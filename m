Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 124ECC49361
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 17:15:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9539613CA
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 17:15:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbhFQRRJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 13:17:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231373AbhFQRRI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Jun 2021 13:17:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBC8D613C1;
        Thu, 17 Jun 2021 17:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623950100;
        bh=UeVMaa01LBtlt9/QzIExys60zzWBHB+4rQxWvP+W8kI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QG0Knet9pgK9J96yKrjiKfWHljPG5iva0+nENYZeh+PzP+gtRMaDn3fdTXtt1w/OF
         HKMqnwS9gpQbDxXCnjzsxa5/qBEyXWNCYYHk26EUvnXqpKMni3r99nRxa/j3iGq19v
         gibOs3F9unXJzVlKU+IMwJb1Yhi4YiowMNKkJ/Zzf0pok4NPf9kU+I65NoYtOho8Pe
         Uz87U1LTlPsyUDPJUwq9d66VgXdHTtnQt6tsmBXtbFe2CT48NVygDg5pKzPPyFpqdu
         UCEhCS0Ghqb5UcaAChfe9VvTYYiVjKvyRJ4OvZkaZmOrsz6KaI8C95zsayTz3bxMXP
         J0EYwr7JgZ90w==
Date:   Thu, 17 Jun 2021 10:15:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     guaneryu@gmail.com, Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
Subject: Re: [PATCH 07/13] fstests: automatically generate group files
Message-ID: <20210617171500.GC158186@locust>
References: <162370433910.3800603.9623820748404628250.stgit@locust>
 <162370437774.3800603.15907676407985880109.stgit@locust>
 <YMmpDGT9b4dBdSh2@infradead.org>
 <20210617001320.GK158209@locust>
 <YMsAEQsNhI1Y5JR8@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMsAEQsNhI1Y5JR8@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 17, 2021 at 08:56:01AM +0100, Christoph Hellwig wrote:
> On Wed, Jun 16, 2021 at 05:13:20PM -0700, Darrick J. Wong wrote:
> > <shrug> What's wrong with requiring everyone to run 'make' when they
> > change something in fstests?  I suspect most people already do that as
> > muscle memory for most every other code project on the planet, or as
> > part of `make install' prior to starting it fstests.
> 
> I know I keep forgetting it and I know a few other people that do as
> well.

I suppose I could make the '-g' switch call 'make group.list', though
that's just going to increase the amount of noise for anyone like me who
runs fstests with a mostly readonly rootfs.

--D
