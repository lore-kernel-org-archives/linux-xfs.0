Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A06E6C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Sep 2022 02:41:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiI3ClN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Sep 2022 22:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiI3ClM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2022 22:41:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B23D1408A
        for <linux-xfs@vger.kernel.org>; Thu, 29 Sep 2022 19:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664505670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VOsyKjOGH+aQnVSOW59gRTSXbPWDi7ZZcSXHCseoJyY=;
        b=Z9Os4RLTIF63VlXE6CLV2v7p3EBHz2cR5gIAiLgrRagQnvvUouJHWRivDsg1+FVQ2LDEBH
        TxU0qhQDt25nIvYkibShzu3Oy2ZEmypJSwggYW23Mc/xyn93zNQb9kcnnqA2FcdqI3JxiB
        jQtDvvgXOuiHvWeeNvQdkhBhDeLH/jA=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-618--BBm15PoM0urgPs7HhfVMg-1; Thu, 29 Sep 2022 22:41:07 -0400
X-MC-Unique: -BBm15PoM0urgPs7HhfVMg-1
Received: by mail-pg1-f198.google.com with SMTP id p24-20020a63f458000000b0043cd718c49dso2034559pgk.15
        for <linux-xfs@vger.kernel.org>; Thu, 29 Sep 2022 19:41:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=VOsyKjOGH+aQnVSOW59gRTSXbPWDi7ZZcSXHCseoJyY=;
        b=qwgBdTpZ5dRkpxc7n/bIy9sZI3cJZgz5EKSLfghecYJdFNWHPQgPMnVnSYRHnuJXgR
         zjxIr++mFics8i8a8QiezwuI7YdFgLQuCov0quihehvK6RzjSUhY6ZjHRBlZf/SUWtU2
         qDnWKbffEPGjAkeulUz34JLBAjnR//X4nJd9KSj5AdoEDg7+kiiFknLjRNLyp3MALVqB
         qNAV+OfB5nsacBzBJqrUgtMscT2Yx7MYMtJOoBCkud7y82n4ePjVBKKSi0Et9EB8lQRB
         IXEVWS1m2+jXYATPdwa65aWVXdamenlNEvjPyK9Yzn5gjZDf2Hvu+5K8EncygdA4uR4D
         PH7w==
X-Gm-Message-State: ACrzQf25yD0AWp7yF/to7mm5JE5TbRkqfx8ulHEBoDX9JTbjIH8aZwA0
        03DuyYXiSpUQgUDNyTz58XMr4iMejkWHpWYQXLBd9i1mYmXqxVGMH/dhFV79nEE7tRQRo8kBjXR
        SWR6AVZbjmhUP5bmzYmfR
X-Received: by 2002:a17:903:2684:b0:17b:7568:ffea with SMTP id jf4-20020a170903268400b0017b7568ffeamr5018871plb.128.1664505666336;
        Thu, 29 Sep 2022 19:41:06 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5NTfrglDfyvkjuAoxkqZTdN5OZFSLXOKh7yKkydhrpHFevDGUJXm7aISsWcvVHKWwevqiGJA==
X-Received: by 2002:a17:903:2684:b0:17b:7568:ffea with SMTP id jf4-20020a170903268400b0017b7568ffeamr5018846plb.128.1664505665933;
        Thu, 29 Sep 2022 19:41:05 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id a27-20020aa78e9b000000b0053e599d7032sm420910pfr.54.2022.09.29.19.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 19:41:05 -0700 (PDT)
Date:   Fri, 30 Sep 2022 10:41:00 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Guo Xuenan <guoxuenan@huawei.com>, dchinner@redhat.com,
        fstests@vger.kernel.org, houtao1@huawei.com, jack.qiu@huawei.com,
        linux-xfs@vger.kernel.org, yi.zhang@huawei.com,
        zhengbin13@huawei.com
Subject: Re: [PATCH v2] xfs/554: xfs add illegal bestfree array size inject
 for leaf dir
Message-ID: <20220930024100.i4qg4iunfb3akz5w@zlang-mailbox>
References: <20220904005549.c3dzjutog724wykg@zlang-mailbox>
 <20220928095355.2074025-1-guoxuenan@huawei.com>
 <20220929113213.4r7be3dbr5r2nqqn@zlang-mailbox>
 <YzYIU9J0QH6WOHB2@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzYIU9J0QH6WOHB2@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 29, 2022 at 02:04:19PM -0700, Darrick J. Wong wrote:
> On Thu, Sep 29, 2022 at 07:32:13PM +0800, Zorro Lang wrote:
> > On Wed, Sep 28, 2022 at 05:53:55PM +0800, Guo Xuenan wrote:
> > > Test leaf dir allocting new block when bestfree array size
> > > less than data blocks count, which may lead to UAF.
> > > 
> > > Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
> > > ---
> > >  tests/xfs/554     | 96 +++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/xfs/554.out |  7 ++++
> > >  2 files changed, 103 insertions(+)
> > >  create mode 100755 tests/xfs/554
> > >  create mode 100644 tests/xfs/554.out
> > > 
> > > diff --git a/tests/xfs/554 b/tests/xfs/554
> > > new file mode 100755
> > > index 00000000..dba6aefa
> > > --- /dev/null
> > > +++ b/tests/xfs/554
> > > @@ -0,0 +1,96 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2022 Huawei Limited.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 554
> > > +#
> > > +# Check the running state of the XFS under illegal bestfree count
> > > +# for leaf directory format.
> > > +
> > > +. ./common/preamble
> > > +_begin_fstest auto quick
> > > +
> > > +# Import common functions.
> > > +. ./common/populate
> > > +
> > > +# real QA test starts here
> > > +_supported_fs xfs
> > > +_require_scratch
> > > +
> > > +# Get last dirblock entries
> > > +__lastdb_entry_list()
> > 
> > I think you don't need to use "__" for a case internal function.
> > 
> > > +{
> > > +	local dir_ino=$1
> > > +	local entry_list=$2
> > > +	local nblocks=`_scratch_xfs_db -c "inode $dir_ino" -c "p core.nblocks" |
> > > +			sed -e 's/^.*core.nblocks = //g' -e 's/\([0-9]*\).*$/\1/g'`
> > 
> > _scratch_xfs_get_metadata_field ...
> > 
> > > +	local last_db=$((nblocks / 2))
> > 
> > I'm not a xfs expert, what's this mean? Why nblocks/2 is the last data block?
> > For example, if we get a directory inode as this:
> >   u3.bmx[0-3] = [startoff,startblock,blockcount,extentflag]
> >   0:[0,14,2,0]
> >   1:[2,10,2,0]
> >   2:[4,72,6,0]
> >   3:[8388608,12,2,0]
> > 
> > do you want to get the "2:[4,72,6,0]" ?
> 
> I think they want 9 (offset (4) + blockcount (6) - 1)?
> 
> I'm also not sure what this computation does...
> 
> > > +	_scratch_xfs_db -c "inode $dir_ino" -c "dblock ${last_db}" -c 'p du' |\
> > > +		grep ".name =" | sed -e 's/^.*.name = //g' \
> > > +		-e 's/\"//g' > ${entry_list} ||\
> > > +		_fail "get last dir block entries failed"
> 
> ...though from the 'print du' command, I'm fairly sure they want to
> extract the dirents from the last directory data block.  So yes, 9.

OK, so he wants the last logic block of the last extent which store dir entries.

> 
> This is sorta ugly, I think this means that you'd have to 'print u3.bmx'
> and then walk the bmbt entries to return the fileoff of the last block
> before $leaf_lblk.

Yeah, it will be ugly, might be something like this:

remove_lastdb_entries()
{
	local dino=$1

	local leaf_bmx=$(_scratch_xfs_db -c "inode $dino" -c "p u3.bmx" | \
				sed -ne "/\[$leaf_lblk,/s/\(.*\)\:\[.*\]/\1/p")
	local lastdb_bmx=$((leaf_bmx - 1))
	local startoff=$(_scratch_xfs_db -c "inode $dino" -c "p u3.bmx" | \
				sed -ne "s/$lastdb_bmx:\[\(.*\),.*,.*,.*\]/\1/p")
	local blockcount=$(_scratch_xfs_db -c "inode $dino" -c "p u3.bmx" | \
				sed -ne "s/$lastdb_bmx:\[.*,.*,\(.*\),.*\]/\1/p")
	local lastdb=$((startoff + blockcount - 1))

	# remove all entries in the last logic data block
	_scratch_xfs_db -c "inode $dino" -c "dblock $lastdb" -c "p du" | \
		sed -ne "s/du.*\.name = \"\(.*\)\"/\1/p" | xargs rm -f
}

Or some better implements. Anyway these code looks like easy to broken :)

So I tried to ask if this step is necessary to reproduce the bug? The v1 patch
didn't have this step, is it can reproduce this bug ?
I think we don't need to make sure it's reproducible 100%, if we can simplify
a test case very much and keep high probability to reproduce the bug, that's
fine for me.

Thanks,
Zorro

> 
> > > +}
> > > +
> > > +echo "Format and mount"
> > > +_scratch_mkfs > $seqres.full 2>&1
> > > +_scratch_mount
> > > +
> > > +echo "Create and check leaf dir"
> > > +blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> > > +dirblksz=`$XFS_INFO_PROG "${SCRATCH_DEV}" | grep naming.*bsize |
> > > +	sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g'`
> > > +# Usually, following routine will create a directory with one leaf block
> > > +# and three data block, meanwhile, the last data block is not full.
> 
> 
> 
> > > +__populate_create_dir "${SCRATCH_MNT}/S_IFDIR.FMT_LEAF" "$((dirblksz / 12))"
> > > +leaf_dir="$(__populate_find_inode "${SCRATCH_MNT}/S_IFDIR.FMT_LEAF")"
> > > +_scratch_unmount
> > > +
> > > +# Delete directory entries in the last directory block,
> > > +last_db_entries=$tmp.ldb_ents
> > > +__lastdb_entry_list ${leaf_dir} ${last_db_entries}
> > 
> > Hmm... I don't like to give a tmp file to a function to get a name list,
> > how about:
> > 
> >   lastdb_entry_list ${leaf_dir} > $tmp.ldb_ents
> > 
> > Or ...(below)
> > 
> > > +_scratch_mount
> > > +cat ${last_db_entries} >> $seqres.full
> > > +cat ${last_db_entries} | while read f
> > > +do
> > > +	rm -rf ${SCRATCH_MNT}/S_IFDIR.FMT_LEAF/$f
> > > +done
> > > +_scratch_unmount
> > 
> > ... you even can make all above code into a function named
> > remove_lastdb_entries() or other name you like.
> > 
> > This new part (not in v1) makes this case more complicated than v1, is it
> > necessary to reproduce the bug? Do we have a simple way?
> > 
> > > +
> > > +# Check leaf directory
> > > +leaf_lblk="$((32 * 1073741824 / blksz))"
> > > +node_lblk="$((64 * 1073741824 / blksz))"
> > > +__populate_check_xfs_dir "${leaf_dir}" "leaf"
> > > +
> > > +# Inject abnormal bestfree count
> > > +echo "Inject bad bestfree count."
> > > +_scratch_xfs_db -x -c "inode ${leaf_dir}" -c "dblock ${leaf_lblk}" \
> > > +	-c "write ltail.bestcount 0"
> > > +# Adding new entries to S_IFDIR.FMT_LEAF. Since we delete the files
> 
> It would be nice to have a blank line before the comments so that the
> test doesn't look quite so much like a wall of text.
> 
> > > +# in last direcotry block, current dir block have no spare space for new
> 
> s/direcotry/directory/
> 
> > > +# entry. With ltail.bestcount setting illegally (eg. bestcount=0), then
> > > +# creating new directories, which will trigger xfs to allocate new dir
> > > +# block, meanwhile, exception will be triggered.
> > > +# Root cause is that xfs don't examin the number bestfree slots, when the
> > > +# slots number less than dir data blocks, if we need to allocate new dir
> > > +# data block and update the bestfree array, we will use the dir block number
> > > +# as index to assign bestfree array, while we did not check the leaf buf
> > > +# boundary which may cause UAF or other memory access problem.
> 
> I suppose this implies that the test should be tagged dangerous for now?
> 
> > > +echo "Add directory entries to trigger exception."
> > > +_scratch_mount
> > > +seq 1 $((dirblksz / 24)) | while read d
> > > +do
> > > +mkdir "${SCRATCH_MNT}/S_IFDIR.FMT_LEAF/TEST$(printf "%.04d" "$d")" >> $seqres.full 2>&1
> > 
> > Indentation
> > 
> > > +done
> > > +_scratch_unmount
> > > +
> > > +# Bad bestfree count should be found and fixed by xfs_repair
> > > +_scratch_xfs_repair -n >> $seqres.full 2>&1
> > > +egrep -q 'leaf block.*bad tail' $seqres.full && echo "Repair found problems."
> > 
> > If you don't care about the xfs_repair output, you can do it simply as:
> >   _scratch_xfs_repair -n >> $seqres.full 2>&1 && \
> >           echo "repair didn't find corruption?"
> > 
> > Or you can filter the output of `_scratch_xfs_repair -n` to be golden image.
> 
> I think they're trying to look specifically for xfs_repair complaining
> about the bad leaf1 block tail, not just any error.
> 
> --D
> 
> > > +_repair_scratch_fs >> $seqres.full 2>&1 || _fail "Repair failed!"
> > 
> > How about:
> > 
> >   _repair_scratch_fs >> $seqres.full 2>&1
> >   _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
> > 
> > (not sure, welcome more suggestions)
> > 
> > > +
> > > +# Check demsg error
> > > +_check_dmesg
> > 
> > You don't need to do that manually, except your dmesg error isn't in the
> > default checking list of _check_dmesg.
> > 
> > > +
> > > +# Success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/554.out b/tests/xfs/554.out
> > > new file mode 100644
> > > index 00000000..d966ab0a
> > > --- /dev/null
> > > +++ b/tests/xfs/554.out
> > > @@ -0,0 +1,7 @@
> > > +QA output created by 554
> > > +Format and mount
> > > +Create and check leaf dir
> > > +Inject bad bestfree count.
> > > +ltail.bestcount = 0
> > > +Add a directory entry to trigger exception.
> > > +Repair found problems.
> > > -- 
> > > 2.25.1
> > > 
> > 
> 

