Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 437A7C48BE8
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 20:56:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E370610CA
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 20:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbhFPU7D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 16:59:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233698AbhFPU7D (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 Jun 2021 16:59:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96720600EF;
        Wed, 16 Jun 2021 20:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623877016;
        bh=ELe+m9WZz5esk65pujzJtz8KoJ3LY/7UIuOnpP2CJBY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dgNSj+oc0l8JFOGGYujCyOT/985VBhR2/VEJuCfeZMPjHyPO8pk2ht/FjFWD1WFHq
         mZ9oJvJKncHt0o8b50u5p3TLS4zRHw2l2zuEUp8j9K7j/SlTG0JVs57T1iFWD0ZDyF
         0gRlz/GNdo67aPizIMoOyzLyOJV6kqYkULtLNjRRP5HYHHYG0oBsqB2iMKL1HFM4we
         /UOjZgDU7yWJIQRgIqCW1TOOqkNhgGVr9Hh23IJp3wNlkS7D6E8x7NGwesa8hCmgYe
         r0F0FOtuLN5wZiFctlWi0wwTucC62ZjQEzGjF7Ct2t30y9kLlUtx/0u6qMaqrA9OA+
         s/bc/9CgkUabQ==
Date:   Wed, 16 Jun 2021 13:56:55 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com
Subject: Re: [PATCH 11/13] fstests: remove group files
Message-ID: <YMpllyP8/aRqx7WF@sol.localdomain>
References: <162370433910.3800603.9623820748404628250.stgit@locust>
 <162370439965.3800603.9202313200753311666.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162370439965.3800603.9202313200753311666.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 14, 2021 at 01:59:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we autogenerate group files, get rid of them in the source
> tree.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

Reviewed-by: Eric Biggers <ebiggers@google.com>
