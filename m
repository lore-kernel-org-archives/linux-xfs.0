Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC352C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Sep 2022 21:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiI2VEZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Sep 2022 17:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiI2VEY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2022 17:04:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C6F14A7B7;
        Thu, 29 Sep 2022 14:04:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BDEBB82398;
        Thu, 29 Sep 2022 21:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450E2C433C1;
        Thu, 29 Sep 2022 21:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664485460;
        bh=koePECQ5LmBD1ua0YriGJ9PMsprdMz/Na4QCX2ycA7Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QZHQN9scPHXGJgRYLa8N37cAcN1eap8QnGkdeVyR/lEzEd/37a4PxY86Av75/twf/
         2rbpfF76vqVsBmOiQbtyjhvr3cIdBM5prbXhSBtG9bf1QZwn31l5VJ0HkyUGlPUN2h
         MBw4dVjTUsiFptIuqO/t1kQ1tOZPD7ADNqg66jOYXHZJP3oanGJwCxV2yuo75QEP4v
         IYD83ljpsrTpk3ucx2cbugH5GuM7WL9kRpOS+g7MoFNEkLaYfsa+fVh5cU+WlKXDj7
         tYDoMQj2Ene4MicWfuMe+QRkO7COn+4uA8ztYQWM7fKDmzsYp3yMNm0+BGC2i3dkq6
         fzPHRD/canU2Q==
Date:   Thu, 29 Sep 2022 14:04:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     Guo Xuenan <guoxuenan@huawei.com>, dchinner@redhat.com,
        fstests@vger.kernel.org, houtao1@huawei.com, jack.qiu@huawei.com,
        linux-xfs@vger.kernel.org, yi.zhang@huawei.com,
        zhengbin13@huawei.com
Subject: Re: [PATCH v2] xfs/554: xfs add illegal bestfree array size inject
 for leaf dir
Message-ID: <YzYIU9J0QH6WOHB2@magnolia>
References: <20220904005549.c3dzjutog724wykg@zlang-mailbox>
 <20220928095355.2074025-1-guoxuenan@huawei.com>
 <20220929113213.4r7be3dbr5r2nqqn@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929113213.4r7be3dbr5r2nqqn@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 29, 2022 at 07:32:13PM +0800, Zorro Lang wrote:
> On Wed, Sep 28, 2022 at 05:53:55PM +0800, Guo Xuenan wrote:
> > Test leaf dir allocting new block when bestfree array size
> > less than data blocks count, which may lead to UAF.
> > 
> > Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
> > ---
> >  tests/xfs/554     | 96 +++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/554.out |  7 ++++
> >  2 files changed, 103 insertions(+)
> >  create mode 100755 tests/xfs/554
> >  create mode 100644 tests/xfs/554.out
> > 
> > diff --git a/tests/xfs/554 b/tests/xfs/554
> > new file mode 100755
> > index 00000000..dba6aefa
> > --- /dev/null
> > +++ b/tests/xfs/554
> > @@ -0,0 +1,96 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Huawei Limited.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 554
> > +#
> > +# Check the running state of the XFS under illegal bestfree count
> > +# for leaf directory format.
> > +
> > +. ./common/preamble
> > +_begin_fstest auto quick
> > +
> > +# Import common functions.
> > +. ./common/populate
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_scratch
> > +
> > +# Get last dirblock entries
> > +__lastdb_entry_list()
> 
> I think you don't need to use "__" for a case internal function.
> 
> > +{
> > +	local dir_ino=$1
> > +	local entry_list=$2
> > +	local nblocks=`_scratch_xfs_db -c "inode $dir_ino" -c "p core.nblocks" |
> > +			sed -e 's/^.*core.nblocks = //g' -e 's/\([0-9]*\).*$/\1/g'`
> 
> _scratch_xfs_get_metadata_field ...
> 
> > +	local last_db=$((nblocks / 2))
> 
> I'm not a xfs expert, what's this mean? Why nblocks/2 is the last data block?
> For example, if we get a directory inode as this:
>   u3.bmx[0-3] = [startoff,startblock,blockcount,extentflag]
>   0:[0,14,2,0]
>   1:[2,10,2,0]
>   2:[4,72,6,0]
>   3:[8388608,12,2,0]
> 
> do you want to get the "2:[4,72,6,0]" ?

I think they want 9 (offset (4) + blockcount (6) - 1)?

I'm also not sure what this computation does...

> > +	_scratch_xfs_db -c "inode $dir_ino" -c "dblock ${last_db}" -c 'p du' |\
> > +		grep ".name =" | sed -e 's/^.*.name = //g' \
> > +		-e 's/\"//g' > ${entry_list} ||\
> > +		_fail "get last dir block entries failed"

...though from the 'print du' command, I'm fairly sure they want to
extract the dirents from the last directory data block.  So yes, 9.

This is sorta ugly, I think this means that you'd have to 'print u3.bmx'
and then walk the bmbt entries to return the fileoff of the last block
before $leaf_lblk.

> > +}
> > +
> > +echo "Format and mount"
> > +_scratch_mkfs > $seqres.full 2>&1
> > +_scratch_mount
> > +
> > +echo "Create and check leaf dir"
> > +blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> > +dirblksz=`$XFS_INFO_PROG "${SCRATCH_DEV}" | grep naming.*bsize |
> > +	sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g'`
> > +# Usually, following routine will create a directory with one leaf block
> > +# and three data block, meanwhile, the last data block is not full.



> > +__populate_create_dir "${SCRATCH_MNT}/S_IFDIR.FMT_LEAF" "$((dirblksz / 12))"
> > +leaf_dir="$(__populate_find_inode "${SCRATCH_MNT}/S_IFDIR.FMT_LEAF")"
> > +_scratch_unmount
> > +
> > +# Delete directory entries in the last directory block,
> > +last_db_entries=$tmp.ldb_ents
> > +__lastdb_entry_list ${leaf_dir} ${last_db_entries}
> 
> Hmm... I don't like to give a tmp file to a function to get a name list,
> how about:
> 
>   lastdb_entry_list ${leaf_dir} > $tmp.ldb_ents
> 
> Or ...(below)
> 
> > +_scratch_mount
> > +cat ${last_db_entries} >> $seqres.full
> > +cat ${last_db_entries} | while read f
> > +do
> > +	rm -rf ${SCRATCH_MNT}/S_IFDIR.FMT_LEAF/$f
> > +done
> > +_scratch_unmount
> 
> ... you even can make all above code into a function named
> remove_lastdb_entries() or other name you like.
> 
> This new part (not in v1) makes this case more complicated than v1, is it
> necessary to reproduce the bug? Do we have a simple way?
> 
> > +
> > +# Check leaf directory
> > +leaf_lblk="$((32 * 1073741824 / blksz))"
> > +node_lblk="$((64 * 1073741824 / blksz))"
> > +__populate_check_xfs_dir "${leaf_dir}" "leaf"
> > +
> > +# Inject abnormal bestfree count
> > +echo "Inject bad bestfree count."
> > +_scratch_xfs_db -x -c "inode ${leaf_dir}" -c "dblock ${leaf_lblk}" \
> > +	-c "write ltail.bestcount 0"
> > +# Adding new entries to S_IFDIR.FMT_LEAF. Since we delete the files

It would be nice to have a blank line before the comments so that the
test doesn't look quite so much like a wall of text.

> > +# in last direcotry block, current dir block have no spare space for new

s/direcotry/directory/

> > +# entry. With ltail.bestcount setting illegally (eg. bestcount=0), then
> > +# creating new directories, which will trigger xfs to allocate new dir
> > +# block, meanwhile, exception will be triggered.
> > +# Root cause is that xfs don't examin the number bestfree slots, when the
> > +# slots number less than dir data blocks, if we need to allocate new dir
> > +# data block and update the bestfree array, we will use the dir block number
> > +# as index to assign bestfree array, while we did not check the leaf buf
> > +# boundary which may cause UAF or other memory access problem.

I suppose this implies that the test should be tagged dangerous for now?

> > +echo "Add directory entries to trigger exception."
> > +_scratch_mount
> > +seq 1 $((dirblksz / 24)) | while read d
> > +do
> > +mkdir "${SCRATCH_MNT}/S_IFDIR.FMT_LEAF/TEST$(printf "%.04d" "$d")" >> $seqres.full 2>&1
> 
> Indentation
> 
> > +done
> > +_scratch_unmount
> > +
> > +# Bad bestfree count should be found and fixed by xfs_repair
> > +_scratch_xfs_repair -n >> $seqres.full 2>&1
> > +egrep -q 'leaf block.*bad tail' $seqres.full && echo "Repair found problems."
> 
> If you don't care about the xfs_repair output, you can do it simply as:
>   _scratch_xfs_repair -n >> $seqres.full 2>&1 && \
>           echo "repair didn't find corruption?"
> 
> Or you can filter the output of `_scratch_xfs_repair -n` to be golden image.

I think they're trying to look specifically for xfs_repair complaining
about the bad leaf1 block tail, not just any error.

--D

> > +_repair_scratch_fs >> $seqres.full 2>&1 || _fail "Repair failed!"
> 
> How about:
> 
>   _repair_scratch_fs >> $seqres.full 2>&1
>   _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
> 
> (not sure, welcome more suggestions)
> 
> > +
> > +# Check demsg error
> > +_check_dmesg
> 
> You don't need to do that manually, except your dmesg error isn't in the
> default checking list of _check_dmesg.
> 
> > +
> > +# Success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/554.out b/tests/xfs/554.out
> > new file mode 100644
> > index 00000000..d966ab0a
> > --- /dev/null
> > +++ b/tests/xfs/554.out
> > @@ -0,0 +1,7 @@
> > +QA output created by 554
> > +Format and mount
> > +Create and check leaf dir
> > +Inject bad bestfree count.
> > +ltail.bestcount = 0
> > +Add a directory entry to trigger exception.
> > +Repair found problems.
> > -- 
> > 2.25.1
> > 
> 
