Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8516DC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 01:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiATB24 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 20:28:56 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43170 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiATB2z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 20:28:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 799BA614F1
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 01:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42E9C340E4;
        Thu, 20 Jan 2022 01:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642642134;
        bh=EJPpIFBP7/JqsaP5H7gedJunUFB7c9EVnWYy67yEt1g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rx/BcXViX8U+Gl4C7+LhMWAawR55wdFgHBMgMo+vk6rrYx2yLS3J1yk08K7Ecxm/4
         c5CPfaSB1AT8/orG33MTJRnwUfYVSNkltiagWxSfCt6219aDczsKZG0dIByfNGNE2g
         FmmXibd9iDBhfZyRU6QG585H+mdSqhWaaVRcqLQFgBGzT45x6Rns873CoKBJ1kzHzc
         +A3IaBG6cYsVDQM1zBHjTBADPTTxKebo8o+amFAUDmWq9/i4iITPJqwSstYnri6KGd
         717O3z6fwd008xT3+UFK8Lrbvqe7i5KTDj5RdHaVst9C4rbgiyV4JPDE5J69LNdIoU
         XOCoQ/4T4sD+A==
Date:   Wed, 19 Jan 2022 17:28:54 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Subject: Re: [PATCH 12/17] xfs_scrub: report optional features in version
 string
Message-ID: <20220120012854.GI13540@magnolia>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
 <164263816090.863810.16834243121150635355.stgit@magnolia>
 <Yei4CAWLzMmG33cf@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yei4CAWLzMmG33cf@mit.edu>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 19, 2022 at 08:16:56PM -0500, Theodore Ts'o wrote:
> On Wed, Jan 19, 2022 at 04:22:40PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Ted T'so reported brittleness in the fstests logic in generic/45[34] to
> 
> Not a super big deal, but my last name is "Ts'o".

D'oh.  Sorry about that, will fix.

--D

> Thanks,
> 
> 						- Ted
