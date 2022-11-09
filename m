Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A097C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 11:22:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbiKILW4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Nov 2022 06:22:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbiKILWy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Nov 2022 06:22:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69F1286C1
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 03:22:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A8C461A04
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 11:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D116C433C1;
        Wed,  9 Nov 2022 11:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667992968;
        bh=6vJD60yemrQNI1vhzCK7WmztzyWgxuenVvIgRYwqWTo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=go5ND0ens2yHBEmaQK7lIn3w1goRUn3PFkDKi6dsKOa4eb9+ObLugcr2e/i+UdWt1
         pdK4b+JVkZDa0mxb2zFLVU3xic8xc5R79FJMEjng46r+ZAq6yjt6eHx/i/2b7h1M+5
         uAun4PWcjDRAmryNVNdr/w5wH2doJ9tb1/dUv86IE5e8Cz2i/fA7o42aTsbdnV6Ofq
         8FVftbCklYa9JMlq9A7e1VwKapZ1TDcRzst2OO/93LRc1ZaidOo7P2NUcNsTlO3twz
         XOCMobbbFkd0uo8cbO8u7t2XcuSVYlqAlqryooquS/JROyGvNjtO4twXaBTMi5DETV
         ydkd6VOrSMvNQ==
Date:   Wed, 9 Nov 2022 12:22:44 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     Alexander Hartner <thahartner@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Detecting disk failures on XFS
Message-ID: <20221109112244.quouifqv5dz2fobp@andromeda>
References: <CAG5wfU0E+y_gnfQLP4x2Ctan0Ts4d3frjVgZ9dt-xegVrucdXQ@mail.gmail.com>
 <QtbZGXwmKZ_mbTKDco-Y_ypZtspaugF_sgelHYzl6AZxT9cU4GLqBDu1ip7hsZ9I10mZHi4SN_tGI_GeJw19uQ==@protonmail.internalid>
 <CAG5wfU2p08ju-SbaRYMjuPXzzEXGneQzTTP56xYrWatO=NUS0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG5wfU2p08ju-SbaRYMjuPXzzEXGneQzTTP56xYrWatO=NUS0g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 09, 2022 at 12:58:55PM +0800, Alexander Hartner wrote:
> We have dealing with a problem where a NVME drive fails every so
> often. More than it really should. While we are trying to make sense
> of the hardware issue, we are also looking at the recovery options.
> 
> Currently we are using Ubuntu 20.04 LTS on XFS with a single NVME
> disk. If the disk fails the following error is reported.
> 
> Nov 6, 2022 @ 20:27:12.000    [1095930.104279] nvme nvme0: controller
> is down; will reset: CSTS=0x3, PCI_STATUS=0x10
> Nov 6, 2022 @ 20:27:12.000    [1095930.451711] nvme nvme0: 64/0/0
> default/read/poll queues
> Nov 6, 2022 @ 20:27:12.000    [1095930.453846] blk_update_request: I/O
> error, dev nvme0n1, sector 34503744 op 0x1:(WRITE) flags 0x800
> phys_seg 1 prio class 0
> 
> And the system becomes completely unresponsive.
> 
> I am looking for a solution to stop the system when this happens, so
> the other nodes in our cluster can carry the work. However since the
> system is unresponsive and the disk presumably in read-only mode we
> stuck in a sort of zombie state, where the processes are still running
> but don't have access to the disk. On EXT3/4 there is an option to
> take the system down.
> 

XFS doesn't work like that, it will either shutdown the filesystem or keep
trying the IO waiting the storage to come back in case of transient IO errors.
We don't keep a filesystem alive if it might me inconsistent.

> Is there an equivalent for XFS ? I didn't find anything similar on the
> XFS man page.
> 
> Also any other suggestions to better handle this ?

Look at "Error handling" section at kernel's Documentation:

https://docs.kernel.org/admin-guide/xfs.html

This might help. But I don't know how it translates to the distro kernel you
are using though.

Cheers.

-- 
Carlos Maiolino
