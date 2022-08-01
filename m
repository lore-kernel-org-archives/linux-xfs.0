Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E93E2C3F6B0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Aug 2022 08:42:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbiHAImg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Aug 2022 04:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbiHAImf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Aug 2022 04:42:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE24A2F67B;
        Mon,  1 Aug 2022 01:42:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72630B80EEF;
        Mon,  1 Aug 2022 08:42:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE456C433D6;
        Mon,  1 Aug 2022 08:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659343352;
        bh=xdcRAw//uV52ESsfJIhHPQ8DYgmPYP3HKsmJPsQ8XIw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HdbtrvUQKA7xMau5zSeWTJ8B/7jfd9oCn1nVjShgxzOX6rsY5QPgT0SG7s+XTewK8
         +N9FAoCHUDt3U+OU09A6u+c44p8NEifD+wL07nVqZJNCNObneN9MHADxJ0YuPDdk7w
         31DSGNl0VOW1CaMQB1YWdFO6/dA0T7KGO2CBOweo=
Date:   Mon, 1 Aug 2022 10:41:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 v2 0/9] xfs stable patches for 5.10.y (from v5.13+)
Message-ID: <YueR0E274KDHEO3T@kroah.com>
References: <20220729161609.4071252-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729161609.4071252-1-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 29, 2022 at 06:16:00PM +0200, Amir Goldstein wrote:
> Hi Greg,
> 
> This backport series contains mostly fixes from v5.14 release along
> with one fix deferred from the first joint 5.10/5.15 series [1].
> 
> The upstream commit f8d92a66e810 ("xfs: prevent UAF in
> xfs_log_item_in_current_chkpt") was already applied to 5.15.y, but its
> 5.10.y backport was more involved (required two non trivial dependency
> patches), so it needed more time for review and testing.
> 
> Per Darrick's recommendation, on top of the usual regression tests,
> I also ran the "recoveryloop" tests group for an extended period of
> time to test for rare regressions.
> 
> Some recoveryloop tests were failing at rates less frequent than 1/100,
> but no change in failure rate was observed between baseline (v5.10.131)
> and the backport branch.
> 
> There was one exceptional test, xfs/455, that was reporting data
> corruptions after crash at very low rate - less frequent than 1/1000
> on both baseline and backport branch.
> 
> It is hard to draw solid conclusions with such rare failures, but the
> test was run >10,000 times on baseline and >20,000 times on backport
> branch, so as far as our test coverage can attest, these backports are
> not introducing any obvious xfs regressions to 5.10.y.

Now queued up, thanks!

greg k-h
