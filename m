Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20D8EC48BE6
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 20:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEB0861076
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Jun 2021 20:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbhFPU6H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Jun 2021 16:58:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233777AbhFPU6H (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 Jun 2021 16:58:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C9686128C;
        Wed, 16 Jun 2021 20:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623876960;
        bh=RP0KrRZ6C8SnQUlDDFW7cUcD/avFA05+BN/S03g4LvA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XnC2CzuWxXbvY1PwoS1N/c64oSlnFqi4CZSBg1j2TZXW5azlcKZgsuEVghG23EgmI
         6511IMtHUPazWqOvMDHh/ggJOJZYLnOnOBXCGQEXvJr8AHEDHMkBtYz8PKY3zJSbml
         PtN2pdzvgJtjszqTkAzf/G11gs6V7AkN1+UA4YJT79P054WvHyOnbDuNvH6tXxNowK
         2AzBBAIp7R4jeD1xiucFYIw9pxc2CIpfFLZ+4DguaRen7MDz5WXM+rSqO5/yO+fOYJ
         VUeRu6+kqmgrfJe38WN/dkjOV4gK132e6cF7mcQvN4GGNQk7yE5C9oHN98xZJ3Zu07
         lNnH6FqzTnu0w==
Date:   Wed, 16 Jun 2021 13:55:59 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com
Subject: Re: [PATCH 10/13] check: use generated group files
Message-ID: <YMplX0TtO2htxssn@sol.localdomain>
References: <162370433910.3800603.9623820748404628250.stgit@locust>
 <162370439420.3800603.62743465175210643.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162370439420.3800603.62743465175210643.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 14, 2021 at 01:59:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Convert the ./check script to use the automatically generated group list
> membership files, as the transition is now complete.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

Reviewed-by: Eric Biggers <ebiggers@google.com>
