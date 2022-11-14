Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 921B5C4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Nov 2022 11:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236969AbiKNL4i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Nov 2022 06:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236973AbiKNL4Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2022 06:56:24 -0500
Received: from mail.itouring.de (mail.itouring.de [IPv6:2a01:4f8:a0:4463::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446962793C
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 03:51:44 -0800 (PST)
Received: from tux.applied-asynchrony.com (p5ddd71d2.dip0.t-ipconnect.de [93.221.113.210])
        by mail.itouring.de (Postfix) with ESMTPSA id 485BA11DD6C;
        Mon, 14 Nov 2022 12:51:42 +0100 (CET)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id E168FF015A0;
        Mon, 14 Nov 2022 12:51:41 +0100 (CET)
Subject: Re: [ANNOUNCE] xfsprogs-6.0.0 released
To:     Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
References: <20221114113639.mxgewf2zjgokr6cb@andromeda>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <08c365c6-09f4-5af4-b242-7189d9f79921@applied-asynchrony.com>
Date:   Mon, 14 Nov 2022 12:51:41 +0100
MIME-Version: 1.0
In-Reply-To: <20221114113639.mxgewf2zjgokr6cb@andromeda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2022-11-14 12:36, Carlos Maiolino wrote:
> Hi folks,
> 
> The xfsprogs repository at:
> 
>          git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> 
> has just been updated and tagged for a v6.0.0 release. The condensed changelog
> since v6.0.0-rc0 is below.
> 
> Tarballs are available at:
> 
> https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-6.0.0.tar.gz
> https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-6.0.0.tar.xz
> https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-6.0.0.tar.sign
> 
> Patches often get missed, so please check if your outstanding
> patches were in this update. If they have not been in this update,
> please resubmit them to linux-xfs@vger.kernel.org so they can be
> picked up in the next update.

It looks like my compilation fix for clang-16 (and maybe gcc-13?) is missing:

https://lore.kernel.org/linux-xfs/865733c7-8314-cd13-f363-5ba2c6842372@applied-asynchrony.com/

thanks
Holger
