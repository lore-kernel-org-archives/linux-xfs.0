Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31507ECAAD3
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Sep 2022 09:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiISJmQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Sep 2022 05:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiISJmP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Sep 2022 05:42:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C76021264
        for <linux-xfs@vger.kernel.org>; Mon, 19 Sep 2022 02:42:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCD3B60C0F
        for <linux-xfs@vger.kernel.org>; Mon, 19 Sep 2022 09:42:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA88C433D6;
        Mon, 19 Sep 2022 09:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663580534;
        bh=NRV2RFy8RKyi6TvpduPaJZKQxmPPdcZ1kwd5+dfdcJA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qQn7p/Hn/Pd6BXNFMnpCM9QEQLgVRovq9fIhSIVW2j6KYuWTnKme85r9Y9Vhs0nu3
         kPud5Zf4Rlqp6Z5ULLaY9ogVbfZxVzKh6/IfrYPz2bkI2EmXfmn6KZL7qmonVxJwBb
         qJciKxT/kVEpj2ifUYM3dGmp/3ZXWqfiHkTq3PGEU8HcNyV26BRXjC1VraM/f6Irf4
         y2GjWrOJet4CK40uZ+s+PilzETT4PLmb6H2RFHR/nGsmVyIpM7uzXQBNro53/ifjVc
         JQZBbE231MYo1wBD8+9ryhuR1oWHmH0qy6kvMAxlureQNy9wZk8cAPsoZ4F+mrSbam
         V0h4YS1Ex6zTw==
Date:   Mon, 19 Sep 2022 11:42:09 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     zhanchengbin <zhanchengbin1@huawei.com>
Cc:     linfeilong <linfeilong@huawei.com>, liuzhiqiang26@huawei.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfsdump: Judge the return value of malloc function
Message-ID: <20220919094209.j5e42ehjgxpr4fmy@andromeda>
References: <yheUla9csTdQLfCMUYXUn7lO9OEuieknMbKuPyGsUnT6AfIlgd9CViWYzi7pvgpE8BxLcqMEVvbiJaodODRO1A==@protonmail.internalid>
 <d63e28c3-b265-07f0-3483-ca93a47322d9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d63e28c3-b265-07f0-3483-ca93a47322d9@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Sep 17, 2022 at 05:16:09PM +0800, zhanchengbin wrote:
> Add judgment on the return value of malloc function.
> 
> Signed-off-by: zhanchengbin <zhanchengbin1@huawei.com>

If you are sending a new version, please, keep a short changelog, so, people can
understand why you're sending a new version.

Thanks.

-- 
Carlos Maiolino
