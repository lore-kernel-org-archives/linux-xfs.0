Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 344E6C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 046A86146D
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352677AbhCDARp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:17:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:54588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235097AbhCCRBJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Mar 2021 12:01:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3501A64ED4;
        Wed,  3 Mar 2021 17:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614790820;
        bh=G10lVrqBtiBf6UvVOWsAYfYwe5TvkNYUcAuTcRUXdFg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JC31UThmyshovp2WBLe+Sdb/yRcEIexmHJzshmikGP7m4TaLa4q8Yc6krAsbHNRmQ
         DWS7RFqMlNd3bPdaOU6aPl3xkZ7QiTJPvZUHf/Q9n4m9mFlFDVNi3gWDKKzSuZEnGs
         pGcbm2rsXrC4N2NJoBs2Pyi9u1TmZC1ouO6XBCdV/1g3aCuIx3NOex18BQHX5564iP
         oWvyfDzjA+Baepe2ku/mBakTfU+Uv0coJUI1yn7yhaL9B+eO7CR0G3FUeUciu8p/Sw
         cNlu6JpIXkvv9ELyqokVk5+BMBGhYsuF1dyoJHYWxVFOmnUFLVZEI5iNkQhQdxAzNT
         bHKHzjJ0iZn/A==
Date:   Wed, 3 Mar 2021 09:00:19 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Geert Hendrickx <geert@hendrickx.be>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: xfs_admin -O feature upgrade feedback
Message-ID: <20210303170019.GH7269@magnolia>
References: <YDy+OmsVCkTfiMPp@vera.ghen.be>
 <20210301191803.GE7269@magnolia>
 <YD4tWbfzmuXv1mKQ@bfoster>
 <YD7C0v5rKopCJvk2@vera.ghen.be>
 <YD937HTr5Lq/YErv@bfoster>
 <YD+NF63sGji+OBtc@vera.ghen.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YD+NF63sGji+OBtc@vera.ghen.be>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 03, 2021 at 02:20:23PM +0100, Geert Hendrickx wrote:
> On Wed, Mar 03, 2021 at 06:50:04 -0500, Brian Foster wrote:
> > Maybe a simple compromise is a verbose option for xfs_admin itself..?
> > I.e., the normal use case operates as it does now, but the failure case
> > would print something like:
> > 
> >   "Feature conversion failed. Retry with -v for detailed error output."

Ugh, no, by the time the sysadmin /reruns/ repair, the original output
is lost.  Frankly I'd rather xfs_admin stop interfering with
stdout/stderr and teach repair to suppress errors due to upgrades.

--D

> > ... and then 'xfs_admin -v ...' would just pass through xfs_repair
> > output. Eh?
> 
> 
> Good suggestion, that should cover it.
> 
> 
> 	Geert
> 
> 
