Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89B85C432BE
	for <linux-xfs@archiver.kernel.org>; Sun, 25 Jul 2021 10:00:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C96160F35
	for <linux-xfs@archiver.kernel.org>; Sun, 25 Jul 2021 10:00:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhGYJTz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 25 Jul 2021 05:19:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:58190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230370AbhGYJTz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 25 Jul 2021 05:19:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39F4560C51;
        Sun, 25 Jul 2021 10:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627207225;
        bh=x7k4bz7Y7uiJ9HuwIGC00aa9QqIdMDVb+kj05Oe8caQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=K9xh3UjE9h8p4mNba4tJb72qMolVr5FH3ck2XHfJC3Nq04ce2eNk/tWZvYXz09Xa4
         +iI6mJ90H2NO+S//WQjEpIA7XrQYfP831fQ0DmDfswAZvUdfBVU3UVjkxpgYhxTvi5
         lZhDdEBVy61QSDHoJGEAc1B2kXpVIzulRFjasgiCNcKoGPiYDkI1fgZsMQjI8YgeDl
         TtQPELL26wKbWqPPLasBDRNXpx4fiZPjnA2J3xmL4mlkQpsuerCiCsRR6l4Y9MmGya
         rogIhPCQ1fgY+drq8dJVV4V/uBQH8/2i/YE78Ibc15+7mq+hGPP8xBm5m+vyyIGoa0
         ZW9XoygA98WSw==
Subject: Re: [PATCH 1/9] f2fs: make f2fs_write_failed() take struct inode
To:     Eric Biggers <ebiggers@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Satya Tangirala <satyaprateek2357@gmail.com>,
        Changheun Lee <nanich.lee@samsung.com>,
        Matthew Bobrowski <mbobrowski@mbobrowski.org>
References: <20210716143919.44373-1-ebiggers@kernel.org>
 <20210716143919.44373-2-ebiggers@kernel.org>
From:   Chao Yu <chao@kernel.org>
Message-ID: <7bc676f9-dbaf-5c8d-2b6e-67c75383d02d@kernel.org>
Date:   Sun, 25 Jul 2021 18:00:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210716143919.44373-2-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2021/7/16 22:39, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Make f2fs_write_failed() take a 'struct inode' directly rather than a
> 'struct address_space', as this simplifies it slightly.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,
