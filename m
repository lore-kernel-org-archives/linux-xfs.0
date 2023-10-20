Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D81BCDB47E
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Oct 2023 10:02:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376930AbjJTKCK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Oct 2023 06:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376959AbjJTKBk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Oct 2023 06:01:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DFE1700
        for <linux-xfs@vger.kernel.org>; Fri, 20 Oct 2023 03:01:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B358C433C7;
        Fri, 20 Oct 2023 10:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697796096;
        bh=lzHAk3dExR6FwsdPVTRy5vF1LS3VUKmX2W/bDr/QLoI=;
        h=References:From:To:Cc:Subject:Date:In-reply-to:From;
        b=Ukw+27nf/Tijp3Zq0ul5lRnbqUtAFqAtg7gINa2ZueIF8VfPgtXoJRXPOMGlA+FoF
         b1zPl60AUrzHMljNOukoj6fjRA1Q1hKWRwEJR/6N4LSDkZOD5KRmHFVWxsHvPYilr0
         VZQPeycZUgdsk7rPYT+uVXKbhUfj4/UzgtpIF5h9xTVSno4/SBUPgd7q11H8gyw+ju
         Zs8tUWS92TYsG1zWu/YCb8fmPn1SHheBlow6SR0TjmqazyLKZqiFzvGiNUFqwrq9Cb
         w9cPlWTpuBYioFlAzXz47nDOilJi/Ilz1a9wMmjnpBOQj9k1idf4TGMdlw6uDGPUZf
         WN0YDjjnQp7YQ==
References: <20230828065744.1446462-1-ruansy.fnst@fujitsu.com>
 <20230928103227.250550-1-ruansy.fnst@fujitsu.com>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandanbabu@kernel.org>
To:     akpm@linux-foundation.org
Cc:     Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        dan.j.williams@intel.com, willy@infradead.org, jack@suse.cz,
        djwong@kernel.org, mcgrof@kernel.org
Subject: Re: [PATCH v15] mm, pmem, xfs: Introduce MF_MEM_PRE_REMOVE for unbind
Date:   Fri, 20 Oct 2023 15:26:32 +0530
In-reply-to: <20230928103227.250550-1-ruansy.fnst@fujitsu.com>
Message-ID: <875y31wr2d.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 28, 2023 at 06:32:27 PM +0800, Shiyang Ruan wrote:
> ====
> Changes since v14:
>  1. added/fixed code comments per Dan's comments
> ====
>
> Now, if we suddenly remove a PMEM device(by calling unbind) which
> contains FSDAX while programs are still accessing data in this device,
> e.g.:
> ```
>  $FSSTRESS_PROG -d $SCRATCH_MNT -n 99999 -p 4 &
>  # $FSX_PROG -N 1000000 -o 8192 -l 500000 $SCRATCH_MNT/t001 &
>  echo "pfn1.1" > /sys/bus/nd/drivers/nd_pmem/unbind
> ```
> it could come into an unacceptable state:
>   1. device has gone but mount point still exists, and umount will fail
>        with "target is busy"
>   2. programs will hang and cannot be killed
>   3. may crash with NULL pointer dereference
>
> To fix this, we introduce a MF_MEM_PRE_REMOVE flag to let it know that we
> are going to remove the whole device, and make sure all related processes
> could be notified so that they could end up gracefully.
>
> This patch is inspired by Dan's "mm, dax, pmem: Introduce
> dev_pagemap_failure()"[1].  With the help of dax_holder and
> ->notify_failure() mechanism, the pmem driver is able to ask filesystem
> on it to unmap all files in use, and notify processes who are using
> those files.
>
> Call trace:
> trigger unbind
>  -> unbind_store()
>   -> ... (skip)
>    -> devres_release_all()
>     -> kill_dax()
>      -> dax_holder_notify_failure(dax_dev, 0, U64_MAX, MF_MEM_PRE_REMOVE)
>       -> xfs_dax_notify_failure()
>       `-> freeze_super()             // freeze (kernel call)
>       `-> do xfs rmap
>       ` -> mf_dax_kill_procs()
>       `  -> collect_procs_fsdax()    // all associated processes
>       `  -> unmap_and_kill()
>       ` -> invalidate_inode_pages2_range() // drop file's cache
>       `-> thaw_super()               // thaw (both kernel & user call)
>
> Introduce MF_MEM_PRE_REMOVE to let filesystem know this is a remove
> event.  Use the exclusive freeze/thaw[2] to lock the filesystem to prevent
> new dax mapping from being created.  Do not shutdown filesystem directly
> if configuration is not supported, or if failure range includes metadata
> area.  Make sure all files and processes(not only the current progress)
> are handled correctly.  Also drop the cache of associated files before
> pmem is removed.
>
> [1]: https://lore.kernel.org/linux-mm/161604050314.1463742.14151665140035795571.stgit@dwillia2-desk3.amr.corp.intel.com/
> [2]: https://lore.kernel.org/linux-xfs/169116275623.3187159.16862410128731457358.stg-ugh@frogsfrogsfrogs/
>
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Acked-by: Dan Williams <dan.j.williams@intel.com>

Hi Andrew,

Shiyang had indicated that this patch has been added to
akpm/mm-hotfixes-unstable branch. However, I don't see the patch listed in
that branch.

I am about to start collecting XFS patches for v6.7 cycle. Please let me know
if you have any objections with me taking this patch via the XFS tree.

-- 
Chandan
