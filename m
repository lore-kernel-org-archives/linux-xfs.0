Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 198ECCDB474
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Oct 2023 12:22:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbjJWMWU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Oct 2023 08:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjJWMWT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Oct 2023 08:22:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63D9FF
        for <linux-xfs@vger.kernel.org>; Mon, 23 Oct 2023 05:22:17 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE325C433C8;
        Mon, 23 Oct 2023 12:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698063737;
        bh=yWAB5IfWcKrAlITT4bJyO6/NuZWlOzBmHsnfhba5iJk=;
        h=References:From:To:Cc:Subject:Date:In-reply-to:From;
        b=fUTH+SSp6jspikGzmehSSTvtU+ailRWHiTav2WWd5d/KCGJvzLg5O3ZLuHPTEjOH/
         1DERIBOo1JAhCgasljWl67Hd2R62YfCkTRPDNxAt4JkBKGqa2SWealTnKBF/x2+0BT
         DHzztgSJhoWo5DhBILafGR8mfcL2nFbkPoWKT3SMNbMWxq6B16vFF7jOQGsk9STebI
         pY3wyZh+CpJP5IUZuk5csmNWEKu6SSLmHkwiyWcYHkB4/C2rlQxJhWQbQ+JmLd0VBo
         mkoOKgiujS64fBy31V7xkM1XK1GsPFdAYQA4JMn0ABpMVYx3/7/rfFsXEJDzfnq63+
         0ANLXF7nrA+VQ==
References: <20230828065744.1446462-1-ruansy.fnst@fujitsu.com>
 <20230928103227.250550-1-ruansy.fnst@fujitsu.com>
 <875y31wr2d.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20231020154009.GS3195650@frogsfrogsfrogs>
 <87msw9zvpk.fsf@debian-BULLSEYE-live-builder-AMD64>
 <834497bc-0876-43bb-bd67-154ad7f26af3@fujitsu.com>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandanbabu@kernel.org>
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     akpm@linux-foundation.org, "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        dan.j.williams@intel.com, willy@infradead.org, jack@suse.cz,
        mcgrof@kernel.org
Subject: Re: [PATCH v15] mm, pmem, xfs: Introduce MF_MEM_PRE_REMOVE for unbind
Date:   Mon, 23 Oct 2023 17:51:49 +0530
In-reply-to: <834497bc-0876-43bb-bd67-154ad7f26af3@fujitsu.com>
Message-ID: <87edhlzfyi.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 23, 2023 at 03:26:52 PM +0800, Shiyang Ruan wrote:
> =E5=9C=A8 2023/10/23 14:40, Chandan Babu R =E5=86=99=E9=81=93:
>> On Fri, Oct 20, 2023 at 08:40:09 AM -0700, Darrick J. Wong wrote:
>>> On Fri, Oct 20, 2023 at 03:26:32PM +0530, Chandan Babu R wrote:
>>>> On Thu, Sep 28, 2023 at 06:32:27 PM +0800, Shiyang Ruan wrote:
>>>>> =3D=3D=3D=3D
>>>>> Changes since v14:
>>>>>   1. added/fixed code comments per Dan's comments
>>>>> =3D=3D=3D=3D
>>>>>
>>>>> Now, if we suddenly remove a PMEM device(by calling unbind) which
>>>>> contains FSDAX while programs are still accessing data in this device,
>>>>> e.g.:
>>>>> ```
>>>>>   $FSSTRESS_PROG -d $SCRATCH_MNT -n 99999 -p 4 &
>>>>>   # $FSX_PROG -N 1000000 -o 8192 -l 500000 $SCRATCH_MNT/t001 &
>>>>>   echo "pfn1.1" > /sys/bus/nd/drivers/nd_pmem/unbind
>>>>> ```
>>>>> it could come into an unacceptable state:
>>>>>    1. device has gone but mount point still exists, and umount will f=
ail
>>>>>         with "target is busy"
>>>>>    2. programs will hang and cannot be killed
>>>>>    3. may crash with NULL pointer dereference
>>>>>
>>>>> To fix this, we introduce a MF_MEM_PRE_REMOVE flag to let it know tha=
t we
>>>>> are going to remove the whole device, and make sure all related proce=
sses
>>>>> could be notified so that they could end up gracefully.
>>>>>
>>>>> This patch is inspired by Dan's "mm, dax, pmem: Introduce
>>>>> dev_pagemap_failure()"[1].  With the help of dax_holder and
>>>>> ->notify_failure() mechanism, the pmem driver is able to ask filesyst=
em
>>>>> on it to unmap all files in use, and notify processes who are using
>>>>> those files.
>>>>>
>>>>> Call trace:
>>>>> trigger unbind
>>>>>   -> unbind_store()
>>>>>    -> ... (skip)
>>>>>     -> devres_release_all()
>>>>>      -> kill_dax()
>>>>>       -> dax_holder_notify_failure(dax_dev, 0, U64_MAX, MF_MEM_PRE_RE=
MOVE)
>>>>>        -> xfs_dax_notify_failure()
>>>>>        `-> freeze_super()             // freeze (kernel call)
>>>>>        `-> do xfs rmap
>>>>>        ` -> mf_dax_kill_procs()
>>>>>        `  -> collect_procs_fsdax()    // all associated processes
>>>>>        `  -> unmap_and_kill()
>>>>>        ` -> invalidate_inode_pages2_range() // drop file's cache
>>>>>        `-> thaw_super()               // thaw (both kernel & user cal=
l)
>>>>>
>>>>> Introduce MF_MEM_PRE_REMOVE to let filesystem know this is a remove
>>>>> event.  Use the exclusive freeze/thaw[2] to lock the filesystem to pr=
event
>>>>> new dax mapping from being created.  Do not shutdown filesystem direc=
tly
>>>>> if configuration is not supported, or if failure range includes metad=
ata
>>>>> area.  Make sure all files and processes(not only the current progres=
s)
>>>>> are handled correctly.  Also drop the cache of associated files before
>>>>> pmem is removed.
>>>>>
>>>>> [1]: https://lore.kernel.org/linux-mm/161604050314.1463742.1415166514=
0035795571.stgit@dwillia2-desk3.amr.corp.intel.com/
>>>>> [2]: https://lore.kernel.org/linux-xfs/169116275623.3187159.168624101=
28731457358.stg-ugh@frogsfrogsfrogs/
>>>>>
>>>>> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
>>>>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>>>>> Acked-by: Dan Williams <dan.j.williams@intel.com>
>>>>
>>>> Hi Andrew,
>>>>
>>>> Shiyang had indicated that this patch has been added to
>>>> akpm/mm-hotfixes-unstable branch. However, I don't see the patch liste=
d in
>>>> that branch.
>>>>
>>>> I am about to start collecting XFS patches for v6.7 cycle. Please let =
me know
>>>> if you have any objections with me taking this patch via the XFS tree.
>>>
>>> V15 was dropped from his tree on 28 Sept., you might as well pull it
>>> into your own tree for 6.7.  It's been testing fine on my trees for the
>>> past 3 weeks.
>>>
>>> https://lore.kernel.org/mm-commits/20230928172815.EE6AFC433C8@smtp.kern=
el.org/
>> Shiyang, this patch does not apply cleanly on v6.6-rc7. Can you
>> please rebase
>> the patch on v6.6-rc7 and send it to the mailing list?
>
> Sure.  I have rebased it and sent a v15.1.  Please check it:
>
> https://lore.kernel.org/linux-xfs/20231023072046.1626474-1-ruansy.fnst@fu=
jitsu.com/

Thank you. I have applied the patch to my local Git tree.

--=20
Chandan
