Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 611B1C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Apr 2022 09:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240394AbiDYJw1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Apr 2022 05:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiDYJwH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Apr 2022 05:52:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC763ED2C
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 02:49:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE74260018
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 09:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276EFC385A7;
        Mon, 25 Apr 2022 09:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650880142;
        bh=1v4CWvOwE+xauipiKRG6or1/wkq6IhbkbSCG4TSRREU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SC4yUNwNep4HKOvf9k395X+xfVvf5daqXMBC2J3D/jzFF0Eaeun4QTYP3lppkZzHK
         AMrr1KT4LrgWbwCw0Aamos9BX8T4m/FlBPH8Rxd5EdB20CWavbfnaXtIt6Pws1c16X
         RfgmmTRiQTuOB2oPeoeMR5J2MeYqCtZ3+8YHoAFRni/ir9EKWa5kLQa9/VystJ2XHm
         kh9rZttmThQcBLBq+mKdlu513awWcG4SrVQU+bBObtemcSlMf5s38ODzWEH3WtTDof
         iRXzCyyPBN0uGKQO6W8IxeSRcKwNxTlCgeyo5t8ThrWlx+4ZYPnxL0CUPTzExu0wk5
         2sNQb51qyv+cg==
Date:   Mon, 25 Apr 2022 11:48:57 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Yang Xu <xuyang2018.jy@fujitsu.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH] xfs: improve __xfs_set_acl
Message-ID: <20220425094857.xgks2ugyxswunkuz@wittgenstein>
References: <1650531290-3262-1-git-send-email-xuyang2018.jy@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1650531290-3262-1-git-send-email-xuyang2018.jy@fujitsu.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 21, 2022 at 04:54:50PM +0800, Yang Xu wrote:
> Provide a proper stub for the !CONFIG_XFS_POSIX_ACL case.
> 
> Also use a easy way for xfs_get_acl stub.
> 
> Suggested-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
> ---

Fwiw,
Acked-by: Christian Brauner (Microsoft) <brauner@kernel.org>
