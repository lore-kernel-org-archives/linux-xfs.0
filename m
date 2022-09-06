Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D68DC6FA89
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Sep 2022 22:08:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiIFWI4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Sep 2022 18:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiIFWIz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Sep 2022 18:08:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25D087690;
        Tue,  6 Sep 2022 15:08:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3580E616FE;
        Tue,  6 Sep 2022 22:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433FFC433C1;
        Tue,  6 Sep 2022 22:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662502133;
        bh=uyaghLFUj0ZUpYv1BfsnZYUsPz1vG7taUX0PRzOUbWM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V38ZoxcxLYyfWiUeHT6Fl+831Rgi6pJi6COWb6dgkYbZBhuGgqt1X+ndhxdRu8NcH
         PhQMZPmU2h0D39SdC2RSKkt1HyFT8NdUl89oV6Ixn9pI17mj7ER4d2Hc9huXWeCbNq
         i+3i8uYL5SnvLWF9WFqcnE99gSR2YmtDv75VhV5qGNsNOxhiapoN8pvJ9ncdsdAIX4
         bvVdcog5eFVzlkDnJf3hJMHUE9BSTikEfHZbG5nhBuv+yjnoIy7446EGgl9bQEN5w4
         6CQIL+JCmEpSFleBZP0kvFhoiQ63H/GuEzJnaKlanPcBDK9nzEN0FReaF0ufHZbnRW
         3HmhWtJtQr0HQ==
Date:   Tue, 6 Sep 2022 15:08:51 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-api@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH v5 0/8] make statx() return DIO alignment information
Message-ID: <YxfE8zjqkT6Zn+Vn@quark>
References: <20220827065851.135710-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220827065851.135710-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 26, 2022 at 11:58:43PM -0700, Eric Biggers wrote:
> This patchset makes the statx() system call return direct I/O (DIO)
> alignment information.  This allows userspace to easily determine
> whether a file supports DIO, and if so with what alignment restrictions.

Al, any thoughts on this patchset, and do you plan to apply it for 6.1?  Ideally
this would go through the VFS tree.  If not, I suppose I'll need to have it
added to linux-next and send the pull request myself.

- Eric
