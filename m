Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3D4DC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Sep 2022 11:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235235AbiI2Lc2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Sep 2022 07:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234255AbiI2LcZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2022 07:32:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A87F14357B
        for <linux-xfs@vger.kernel.org>; Thu, 29 Sep 2022 04:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664451142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Apr9Q5u36TNrNptCNL3d0HR1k1onh/SadicM5r1dx5s=;
        b=QM35bN4gT5uHvZzJnQW4hrzaJB+3aHH7C20XWNiPaJB66Jx5uXl2gNbngf5cCNSbyRq6v7
        9rl7sHWiEtb2ktI0SjSJmsz7ld5NFsch+cek6womizhw2S2Wd+ZCPTG9NTFmysPgV6h4Zl
        Fq6DE6pfSIi6mqFCL8maqCrdb/pKmrQ=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-493-uIGYJoj0NjKLhToRHw2Qpw-1; Thu, 29 Sep 2022 07:32:21 -0400
X-MC-Unique: uIGYJoj0NjKLhToRHw2Qpw-1
Received: by mail-pj1-f70.google.com with SMTP id mi9-20020a17090b4b4900b00202b50464b6so3417973pjb.9
        for <linux-xfs@vger.kernel.org>; Thu, 29 Sep 2022 04:32:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Apr9Q5u36TNrNptCNL3d0HR1k1onh/SadicM5r1dx5s=;
        b=YZjRgCnPvjlZms4aFP/6rBzHcm1vRVLjxF39h5yAtm/3SRjS44vxuM01WRLvBbT7HL
         1SWnaEZp1qX/Hd/xlO9MnPhLMAgZ6W7K8mrC5Qqld14ZZwxltUqbgROm7/bDwLyQ0qEn
         uhmLKss1KrpSeuo2M8271NaCrYuUlYVXCb7dTqW/kqop3OBGHZuJuEiJlUpJupU+9yHR
         XofzDiGKlD57Z5yE0A6Uc9N+bwRL4KFyqKGIvSRru540m2svgi6lHUJ0va46KbQE+79R
         4OLv0o0jVsVszoZz2cr3yN8bU8ooTKwudtjMi2BbFi25jr8R/MT0MKxT0QaqIIGX1rLy
         F7aA==
X-Gm-Message-State: ACrzQf2BF4L7guQKQ2Eds2pj2ffP0fO2WBevikhKNQCzBzbb8/zKfLwk
        h1xRVJgeIHr5a+ZWBJOMg0G1+fmoXzXxr0enZwO2/oZUWA2KXrqDtQhdfFXPuW//aIpE5soVyuY
        b1MP9YdFDIeN90NiW8D7z
X-Received: by 2002:a17:90b:4a8a:b0:202:8eec:b87a with SMTP id lp10-20020a17090b4a8a00b002028eecb87amr15986973pjb.48.1664451140166;
        Thu, 29 Sep 2022 04:32:20 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4HS72S4N//zP2+QEcJ2ROAvDP7wB9XVZndAp1WcNVPownhLornRMq/gWJ/VS74v0AfwZfstA==
X-Received: by 2002:a17:90b:4a8a:b0:202:8eec:b87a with SMTP id lp10-20020a17090b4a8a00b002028eecb87amr15986938pjb.48.1664451139794;
        Thu, 29 Sep 2022 04:32:19 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z17-20020a170903019100b00172d9f6e22bsm5800581plg.15.2022.09.29.04.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 04:32:19 -0700 (PDT)
Date:   Thu, 29 Sep 2022 19:32:13 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Guo Xuenan <guoxuenan@huawei.com>
Cc:     dchinner@redhat.com, djwong@kernel.org, fstests@vger.kernel.org,
        houtao1@huawei.com, jack.qiu@huawei.com, linux-xfs@vger.kernel.org,
        yi.zhang@huawei.com, zhengbin13@huawei.com
Subject: Re: [PATCH v2] xfs/554: xfs add illegal bestfree array size inject
 for leaf dir
Message-ID: <20220929113213.4r7be3dbr5r2nqqn@zlang-mailbox>
References: <20220904005549.c3dzjutog724wykg@zlang-mailbox>
 <20220928095355.2074025-1-guoxuenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928095355.2074025-1-guoxuenan@huawei.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 28, 2022 at 05:53:55PM +0800, Guo Xuenan wrote:
> Test leaf dir allocting new block when bestfree array size
> less than data blocks count, which may lead to UAF.
> 
> Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
> ---
>  tests/xfs/554     | 96 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/554.out |  7 ++++
>  2 files changed, 103 insertions(+)
>  create mode 100755 tests/xfs/554
>  create mode 100644 tests/xfs/554.out
> 
> diff --git a/tests/xfs/554 b/tests/xfs/554
> new file mode 100755
> index 00000000..dba6aefa
> --- /dev/null
> +++ b/tests/xfs/554
> @@ -0,0 +1,96 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Huawei Limited.  All Rights Reserved.
> +#
> +# FS QA Test No. 554
> +#
> +# Check the running state of the XFS under illegal bestfree count
> +# for leaf directory format.
> +
> +. ./common/preamble
> +_begin_fstest auto quick
> +
> +# Import common functions.
> +. ./common/populate
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +
> +# Get last dirblock entries
> +__lastdb_entry_list()

I think you don't need to use "__" for a case internal function.

> +{
> +	local dir_ino=$1
> +	local entry_list=$2
> +	local nblocks=`_scratch_xfs_db -c "inode $dir_ino" -c "p core.nblocks" |
> +			sed -e 's/^.*core.nblocks = //g' -e 's/\([0-9]*\).*$/\1/g'`

_scratch_xfs_get_metadata_field ...

> +	local last_db=$((nblocks / 2))

I'm not a xfs expert, what's this mean? Why nblocks/2 is the last data block?
For example, if we get a directory inode as this:
  u3.bmx[0-3] = [startoff,startblock,blockcount,extentflag]
  0:[0,14,2,0]
  1:[2,10,2,0]
  2:[4,72,6,0]
  3:[8388608,12,2,0]

do you want to get the "2:[4,72,6,0]" ?

> +	_scratch_xfs_db -c "inode $dir_ino" -c "dblock ${last_db}" -c 'p du' |\
> +		grep ".name =" | sed -e 's/^.*.name = //g' \
> +		-e 's/\"//g' > ${entry_list} ||\
> +		_fail "get last dir block entries failed"
> +}
> +
> +echo "Format and mount"
> +_scratch_mkfs > $seqres.full 2>&1
> +_scratch_mount
> +
> +echo "Create and check leaf dir"
> +blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> +dirblksz=`$XFS_INFO_PROG "${SCRATCH_DEV}" | grep naming.*bsize |
> +	sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g'`
> +# Usually, following routine will create a directory with one leaf block
> +# and three data block, meanwhile, the last data block is not full.
> +__populate_create_dir "${SCRATCH_MNT}/S_IFDIR.FMT_LEAF" "$((dirblksz / 12))"
> +leaf_dir="$(__populate_find_inode "${SCRATCH_MNT}/S_IFDIR.FMT_LEAF")"
> +_scratch_unmount
> +
> +# Delete directory entries in the last directory block,
> +last_db_entries=$tmp.ldb_ents
> +__lastdb_entry_list ${leaf_dir} ${last_db_entries}

Hmm... I don't like to give a tmp file to a function to get a name list,
how about:

  lastdb_entry_list ${leaf_dir} > $tmp.ldb_ents

Or ...(below)

> +_scratch_mount
> +cat ${last_db_entries} >> $seqres.full
> +cat ${last_db_entries} | while read f
> +do
> +	rm -rf ${SCRATCH_MNT}/S_IFDIR.FMT_LEAF/$f
> +done
> +_scratch_unmount

... you even can make all above code into a function named
remove_lastdb_entries() or other name you like.

This new part (not in v1) makes this case more complicated than v1, is it
necessary to reproduce the bug? Do we have a simple way?

> +
> +# Check leaf directory
> +leaf_lblk="$((32 * 1073741824 / blksz))"
> +node_lblk="$((64 * 1073741824 / blksz))"
> +__populate_check_xfs_dir "${leaf_dir}" "leaf"
> +
> +# Inject abnormal bestfree count
> +echo "Inject bad bestfree count."
> +_scratch_xfs_db -x -c "inode ${leaf_dir}" -c "dblock ${leaf_lblk}" \
> +	-c "write ltail.bestcount 0"
> +# Adding new entries to S_IFDIR.FMT_LEAF. Since we delete the files
> +# in last direcotry block, current dir block have no spare space for new
> +# entry. With ltail.bestcount setting illegally (eg. bestcount=0), then
> +# creating new directories, which will trigger xfs to allocate new dir
> +# block, meanwhile, exception will be triggered.
> +# Root cause is that xfs don't examin the number bestfree slots, when the
> +# slots number less than dir data blocks, if we need to allocate new dir
> +# data block and update the bestfree array, we will use the dir block number
> +# as index to assign bestfree array, while we did not check the leaf buf
> +# boundary which may cause UAF or other memory access problem.
> +echo "Add directory entries to trigger exception."
> +_scratch_mount
> +seq 1 $((dirblksz / 24)) | while read d
> +do
> +mkdir "${SCRATCH_MNT}/S_IFDIR.FMT_LEAF/TEST$(printf "%.04d" "$d")" >> $seqres.full 2>&1

Indentation

> +done
> +_scratch_unmount
> +
> +# Bad bestfree count should be found and fixed by xfs_repair
> +_scratch_xfs_repair -n >> $seqres.full 2>&1
> +egrep -q 'leaf block.*bad tail' $seqres.full && echo "Repair found problems."

If you don't care about the xfs_repair output, you can do it simply as:
  _scratch_xfs_repair -n >> $seqres.full 2>&1 && \
          echo "repair didn't find corruption?"

Or you can filter the output of `_scratch_xfs_repair -n` to be golden image.

> +_repair_scratch_fs >> $seqres.full 2>&1 || _fail "Repair failed!"

How about:

  _repair_scratch_fs >> $seqres.full 2>&1
  _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"

(not sure, welcome more suggestions)

> +
> +# Check demsg error
> +_check_dmesg

You don't need to do that manually, except your dmesg error isn't in the
default checking list of _check_dmesg.

> +
> +# Success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/554.out b/tests/xfs/554.out
> new file mode 100644
> index 00000000..d966ab0a
> --- /dev/null
> +++ b/tests/xfs/554.out
> @@ -0,0 +1,7 @@
> +QA output created by 554
> +Format and mount
> +Create and check leaf dir
> +Inject bad bestfree count.
> +ltail.bestcount = 0
> +Add a directory entry to trigger exception.
> +Repair found problems.
> -- 
> 2.25.1
> 

