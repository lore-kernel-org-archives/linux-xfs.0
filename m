Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E9F9ECAAD5
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Aug 2022 08:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiH2IYx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Aug 2022 04:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiH2IYv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Aug 2022 04:24:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7B6E01
        for <linux-xfs@vger.kernel.org>; Mon, 29 Aug 2022 01:24:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D6D0B80D86
        for <linux-xfs@vger.kernel.org>; Mon, 29 Aug 2022 08:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAC7C43470;
        Mon, 29 Aug 2022 08:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661761484;
        bh=AgSDZIyszT+qDvXGIcrlF0e+LCXVbuunXBTvYPKnFqY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q6jBijYf/S92wHVXmqtZxZLPHPWVdf6RYhK+sn+RziMkFVlg4Dy9iO6ebPnAvsTN4
         ZnMVXJUpK1XVdmjBgnJyloocj4BK7EyCwz8Q4DCRf1nduekEXLUGbbejtFoWWTj3gB
         olMMPri8sa+CWPyi4/ZjDrqDTBregDKJZgsuS1js6D0w2ZM2oASs+D2GYKbl8k/Bh9
         zbfE4i9vFToNkceYLr+N8eLWI3LAseN0gGuqObWYAH/GjZcNpirWOIEJE/RInozJZ4
         3ZlIE8ExygndbjNfAyINhkZQsuq84+r4Bt60rGeYULbmgu7xIDmhNlt0HoONi9uoJK
         9Bs/NWeJNJS+A==
Date:   Mon, 29 Aug 2022 10:24:40 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     Wang Yugui <wangyugui@e16-tech.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: questions about hybird xfs wih ssd/hdd  by realtime subvol
Message-ID: <20220829082440.o3qzqdn44pw7z2ou@andromeda>
References: <cra8LsdEma_cTwegy_oY4sLK9oYZOVv-VzyNw2y5Azvj_cPt5Fx3AyINvXKkQFhNXwB6-xMP4wVI67KS0eru1w==@protonmail.internalid>
 <20220829102619.AE3B.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220829102619.AE3B.409509F4@e16-tech.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 29, 2022 at 10:26:20AM +0800, Wang Yugui wrote:
> Hi,
> 
> I saw some info about hybird xfs wih ssd/hdd  by realtime subvol.
> 
> Hybrid XFS—Using SSDs to Supercharge HDDs at Facebook
> https://www.usenix.org/conference/srecon19asia/presentation/shamasunder
> 
> There are some questions about how to control the data to save into
> normal vol or realtime subvol firstly.
> 
> 1, man xfsctl
> here is XFS_XFLAG_REALTIME in man xfsctl of xfsprogs 5.0 ,
> but there is no XFS_XFLAG_REALTIME in xfsprogs 5.14/5.19.
> xfsctl(XFS_XFLAG_REALTIME) will be removed in the further?

It's been a while since XFS uses FS_XFLAG features directly, so, what you're
specifically looking for is FS_XFLAG_REALTIME. xfsprogs today only has a
preprocessor define:

#define XFS_XFLAG_REALTIME	FS_XFLAG_REALTIME

FS_XFLAG_REALTIME is part of the xfs realtime, unlikely it's going away without
the realtime filesystems going first, so, unlikely it's gonna happen.

> 
> 2, Is there some tool to do xfsctl(XFS_XFLAG_REALTIME)?

You can use xfs_io's chattr command to add/remote the REALTIME attribute of a
file.


> 
> 3, we build a xfs filesystem with 1G device and 1G rtdev device. and
> then we can save 2G data into this xfs filesystem.
> 
> Is there any tool/kernel option/kernel patch to control the data to save
> into normal vol or realtime subvol firstly?

I didn't watch the talk you mentioned above, but when use an rt device, you
don't use the 'normal' one then the rt later, or vice-versa, the rt-device is
used to store data blocks for those files marked with the xattr above. For those
files you want to store in the realtime device, you should add the above xattr
to them.

Cheers.

-- 
Carlos Maiolino
