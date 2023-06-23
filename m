Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B095EB64D7
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Jun 2023 21:14:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbjFWVOS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Jun 2023 17:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbjFWVOR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Jun 2023 17:14:17 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8F2E710F2
        for <linux-xfs@vger.kernel.org>; Fri, 23 Jun 2023 14:14:15 -0700 (PDT)
Received: from [10.1.184.212] (unknown [149.34.244.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 32C4D5196FD;
        Fri, 23 Jun 2023 16:14:13 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net 32C4D5196FD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
        s=default; t=1687554854;
        bh=X3V0gzE2EckvTXDHgaxv2WJ23PquQPij1IyxeDlTCwQ=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=kXB/2a4R3T6FCIgLr6bun1sIYt/4XZgnx4fjLHi56oGJvGXbrxtAl0vrQ4COioAkZ
         dUnVX6Vbqf86lbX3cTknPCC1NtCNAIAkOgZILdWh0sQe2f09IOKBcqI/sUBUGvfyp4
         8J4T1VPCTz96EgCdZEBZ+iCes/ioHbtY/PyQTTu/clSbggBl+K/EZySQTn5Vg+MiNb
         bQf6AaoS0nDXkDiC98pWgjsIPI8oJrxTjLvoibTfV8UJEvp+uFckk7l3SCuewefZw6
         /IA7MiMWxrA01HsskxdOV2jvG9rM1v8vrJI8MI1XkoPd9xmav264BadVQbhd6nGsSJ
         5mXGRFEfqHFvQ==
Message-ID: <3def220e-bc7b-ceb2-f875-cffe3af8471b@sandeen.net>
Date:   Fri, 23 Jun 2023 16:14:11 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: xfs_rapair fails with err 117. Can I fix the fs or recover
 individual files somehow?
Content-Language: en-US
To:     Fernando CMK <ferna.cmk@gmail.com>, linux-xfs@vger.kernel.org
References: <CAEBim7C575WhuWGO7_VJ62+6s2g4XFFgoF6=SrGX30nBYcD12Q@mail.gmail.com>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <CAEBim7C575WhuWGO7_VJ62+6s2g4XFFgoF6=SrGX30nBYcD12Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/23/23 3:25 PM, Fernando CMK wrote:
> Scenario
> 
> opensuse 15.5, the fs was originally created on an earlier opensuse
> release. The failed file system is on top of a mdadm raid 5, where
> other xfs file systems were also created, but only this one is having
> issues. The others are doing fine.
> 
> xfs_repair and xfs_repair -L both fail:

Full logs please, not the truncated version.

> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
>         - traversal finished ...
>         - moving disconnected inodes to lost+found ...
> Phase 7 - verify and correct link counts...
>         - 16:15:34: verify and correct link counts - 42 of 42
> allocation groups done
> stripe width (17591899783168) is too large
> Metadata corruption detected at 0x55f819658468, xfs_sb block 0x0/0x1000
> libxfs_bwrite: write verifier failed on xfs_sb bno 0x0/0x8
> stripe width (17591899783168) is too large

0xFFFEEF00000 - that's suspicious. No idea how the stripe unit could 
have been set to something so big.

> Metadata corruption detected at 0x55f819658468, xfs_sb block 0x0/0x1000
> libxfs_bwrite: write verifier failed on xfs_sb bno 0x0/0x8
> xfs_repair: Releasing dirty buffer to free list!
> xfs_repair: Refusing to write a corrupt buffer to the data device!
> xfs_repair: Lost a write to the data device!
> 
> fatal error -- File system metadata writeout failed, err=117.  Re-run
> xfs_repair.
> 
> I ran xfs_repair multiple times, but I always get the same error.

First, what version of xfs_repair are you using? xfs_Repair -V.
Latest is roughly the latest kernel, 6.x.

> Is there any way to fix the above?
> 
> I tried xfs_db on an image file I created from the file system, and I
> can  see individual paths  and file "good":

> xfs_db> path /certainpath
> xfs_db> ls
> 10         1550204032         directory      0x0000002e   1 . (good)
> 12         1024               directory      0x0000172e   2 .. (good)
> 25         1613125696         directory      0x99994f93  13 .AfterShotPro (good)
> 
> 
> Is there a way to extract files from the file system image without
> mounting the fs ? Or is there a way to mount the file system
> regardless of its state?

mount -o ro,norecovery should get you something ...

> Trying a regular mount, with or withour -o norecovery, I get:
> mount: /mnt: mount(2) system call failed: Structure needs cleaning.

... oh. And what did the kernel dmesg say when that happened?

What happened in between this filesystem being ok, and not being ok? 
What was the first sign of trouble?

If you want to provide an xfs_metadump (compressed, on gdrive or 
something, you can email me off-list) I can take a look.

-Eric

> 
> 
> 
> 
> Regards.
> 

