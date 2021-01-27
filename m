Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC179C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 17:14:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B27C64DA3
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 17:14:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbhA0RNs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jan 2021 12:13:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:38764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234372AbhA0RLr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 27 Jan 2021 12:11:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A0FE64DA1;
        Wed, 27 Jan 2021 17:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611767466;
        bh=CaMnXsXHwmbOD2PDrY4xEYW3WGDKh2vWkT8cF+tFmDE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mIF04xsEATzxYH/C+3sBzIdu4jgGX4gcRrWOT/lD8oL2jlODfGWsJ1oxOULWyrP7Z
         xOXeC2FvBNAjmq7erEx69djn1ePGBHo8v3dF5X0LWM/Rklq7CvWvC0qVuiBi0bZkd1
         ub2typ1gLYwJc38V3lQFO15gfSLMdTuReGqb8U2j6fZs0a4yJr570hS5FHWfzaFpw/
         DlwWvgBULQCzxkA/sAci2O23RzDPhuSzwHyooqjE2tgcOTGwTM8+VOKGL+FShks1br
         I6jHtWpANrrs+Krw/hq49SUp8q4wbY7g6U8mKVRAU/p18bBbTz1o+UgusayyA9WwZD
         NybWhZ2bQd6og==
Date:   Wed, 27 Jan 2021 09:11:05 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v4.1 05/11] xfs: pass flags and return gc errors from
 xfs_blockgc_free_quota
Message-ID: <20210127171105.GI7698@magnolia>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142794741.2171939.10175775024910240954.stgit@magnolia>
 <20210126045237.GM7698@magnolia>
 <20210127165959.GB1730140@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210127165959.GB1730140@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 27, 2021 at 04:59:59PM +0000, Christoph Hellwig wrote:
> I'm a little lost what these v4.1 patches right in the middle of a
> deep thread area..

I've lost my ability to track where these discussions have gone since
everything's landing out of order and I'm just now discovering replies
from other people that predate my last email to them.

It might simply be time for me to repost the whole thing, with explicit
cc for everyone who's participated in these threads in case vger slows
again.

--D
