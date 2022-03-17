Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B8EEC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 03:08:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240469AbiCQDKJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 23:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238537AbiCQDKH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 23:10:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA7C21242
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 20:08:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F294B81E01
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 03:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EEABC340EC;
        Thu, 17 Mar 2022 03:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647486528;
        bh=fRbtzPlLDjE6qZZoYYpeU4BZvDXT5HhB3R9Z7RHXqSw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WDcjOD8GOlj/LYDVXK6klzYQUSxBKx3Z1mpDgXzF4uLHpen6+u5OFB3JqudxjnNoK
         G9BFYbgkWP6ASc/GuhFCcyOAWKMeGitstBnSMUH4qMcqIryWL8H/rcIkBVH0KeoOOa
         UceNk/4IVOVbVNMrWmoq3ZrSm7NowLnk+PnXautV75uSgs0lBbxPHpZXK/UI9Fu60y
         BzuKQvOYxmGG0c5CP/186MgN/ebOtYsL9cFqIiJ5WV4Cr/XGnIXQpq0avgp0XPtOCW
         Z8BVunjFvpn26B1bjmy/QOkDLaKtOe6FkmzJfcLtoxyq8JFiuM7bcr3OrnuqF4G35w
         SmywXtxxzlpRQ==
Date:   Wed, 16 Mar 2022 20:08:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guodf <15147193722@163.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Metadata CRC error detected at xfs_bmbt block 0x1868f56bb0/0x1000
Message-ID: <20220317030847.GZ8224@magnolia>
References: <16d2444c.2cc8.17f95b788b9.Coremail.15147193722@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <16d2444c.2cc8.17f95b788b9.Coremail.15147193722@163.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 17, 2022 at 10:31:47AM +0800, guodf wrote:
> 
> 
> Hello:
>      A fatal error occurred in the XFS file system of my production environment when I run the following command
>      error：
>     [root@localhost 0316]# xfs_metadump  -g -o -w /dev/centos/home xfs.img
> Metadata CRC error detected at xfs_agf block 0x187ffffe79/0x200
> xfs_metadump: cannot init perag data (-74). Continuing anyway.
> Copying free space trees of AG 10                          
> Metadata CRC error detected at xfs_bmbt block 0x1868f56bb0/0x1000
> 
> 
> xfs_metadump: invalid numrecs (65079) in bmapbtd block 48/220114342
> Copying free space trees of AG 22  Metadata CRC error detected at xfs_bmbt block 0x18a6ffeb38/0x1000
> 
> 
> xfs_metadump: invalid numrecs (39031) in bmapbtd block 49/81788312
> Metadata CRC error detected at xfs_bmbt block 0x19a1ffeda8/0x1000
> xfs_metadump: invalid numrecs (49606) in bmapbtd block 51/71302632
> Metadata CRC error detected at xfs_bmbt block 0x1a9cfff018/0x1000
> xfs_metadump: invalid numrecs (4194) in bmapbtd block 53/60816952
> Copying free space trees of AG 48   bad magic number
> 
> 
> xfs_metadump: cannot read superblock for ag 49
> Metadata CRC error detected at xfs_agi block 0x187ffffe7a/0x200
> Metadata CRC error detected at xfs_agfl block 0x187ffffe7b/0x200
> /usr/sbin/xfs_metadump: line 33:  6369 Segmentation fault      (core dumped) xfs_db$DBOPTS -i -p xfs_metadump -c "metadump$OPTS $2" $1
> 
> 
> I have two questions and hope to get your reply
> 1：Metadata CRC error detected at xfs_agfl block 0x187ffffe7b/0x200
> 
> What does the red font mean？What does it mean？

There are checksum errors in the metadata, which implies that something
weird happened with the storage (bitflips in the cable, torn writes,
broken disk firmware)...

> 2：How can I fix it

Send us a coredump and the xfs_db binary so we can try to fix this
crash, and run xfs_repair?

--D

> 
> 
> Thank you very much
> 
