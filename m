Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF500C4320A
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 05:44:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D381761038
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 05:44:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbhHLFpK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 01:45:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35931 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234365AbhHLFpJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Aug 2021 01:45:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628747084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sfFjUmBD0vah0vR4NJfABF+FTNvaIRzaEBZIfMKiF0w=;
        b=TgssHCrNQDT6DUQx3C6XE97QypwIZ5vZVQ9Lg82Hhh4aqrrtAFKdQF9p8yN1G2IgSYr6W3
        EyQ6KB/9mN7avTnI2VvgHjbA5AuCGlVufsfpoiBMj0VikzGdTSPNZW88CLakWdUV7z4fga
        2Y1oaPnMC/v+uyOyNNUSPPMhbvH1zoE=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-h1bwM2fMMSSHiZ4IBB22BA-1; Thu, 12 Aug 2021 01:44:42 -0400
X-MC-Unique: h1bwM2fMMSSHiZ4IBB22BA-1
Received: by mail-pl1-f198.google.com with SMTP id f17-20020a170902ab91b029012c3bac8d81so2984488plr.23
        for <linux-xfs@vger.kernel.org>; Wed, 11 Aug 2021 22:44:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=sfFjUmBD0vah0vR4NJfABF+FTNvaIRzaEBZIfMKiF0w=;
        b=a/Xq11RofvGe3iD5CJy8QZtklywZa14ud8Zx9KbaucrX8yyvMwGU4hP0XX6VCP+bue
         58/pB4azYpFJlTjy2BHdoO9ls0csNyCqsHnqtD6SeMj19Gf5slz1H8YyELLelD1PZJdO
         3rjQdTxPBHJiYMA2Fr7GFGQBFXeIHOSkdMMVhPwe8NkoKkzdlVPZ1+x2S4GVda9CNCur
         bWCQFQSZ/AdwkOilzcw/D2M2Yw9r0M47bw/e9uunlKADM2jbTTxjDB6IbE5qQ+yucLZr
         eqEzXLlhtRh/5majT3c4vLgWD5C44Y4lGnYmLcXFKi35ty14/idiJUYS9H3VSm5V45Ml
         hT/Q==
X-Gm-Message-State: AOAM5339krE54kwWIT1mnS4R8tHy8g9Lt/bWQAVlbxyFK0ECil3vaKSa
        2cSVenq2AHZGnbOibuWRe/+j6lvDhXqgVk+V/eBgpLYSu1XlkjYR8dTuqUFUOWb4ZSVj1+kDOWd
        r4OiDDPhEKRxBNRuiRZME
X-Received: by 2002:a05:6a00:1626:b029:3e0:99b6:b320 with SMTP id e6-20020a056a001626b02903e099b6b320mr453313pfc.25.1628747081777;
        Wed, 11 Aug 2021 22:44:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxGU8c20OElgi+4k5Lz1sO/oPEBOt4S1cEEaeoGKHGVi2sxHyJnFh7FiuRoFcwmmgrAUebsQ==
X-Received: by 2002:a05:6a00:1626:b029:3e0:99b6:b320 with SMTP id e6-20020a056a001626b02903e099b6b320mr453297pfc.25.1628747081487;
        Wed, 11 Aug 2021 22:44:41 -0700 (PDT)
Received: from fedora ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b128sm1675609pfb.144.2021.08.11.22.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 22:44:41 -0700 (PDT)
Date:   Thu, 12 Aug 2021 14:01:31 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 3/3] xfs: test regression in shrink when the new EOFS
 splits a sparse inode cluster
Message-ID: <20210812060131.dtb2efzohowbmnsd@fedora>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
References: <162743101932.3428896.8510279402246446036.stgit@magnolia>
 <162743103574.3428896.5902517991928414065.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162743103574.3428896.5902517991928414065.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 27, 2021 at 05:10:35PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This is a targeted regression test for the patch "xfs: check for sparse
> inode clusters that cross new EOAG when shrinking", which was found by
> running the random-loopy shrink stresser xfs/168.
> 
> The original shrink implementation assumed that if we could allocate the
> last free extent in the filesystem, it was ok to proceed with the fs
> shrink.  Unfortunately, this isn't quite the case -- if there's a sparse
> inode cluster such that the blocks at the end of the cluster are free,
> it is not ok to shrink the fs to the point that part of the cluster
> hangs off the end of the filesystem.  Doing so results in repair and
> scrub marking the filesystem corrupt, so we must not.
> 
> (EOFS == "end of filesystem"; EOAG == "end of allocation group")
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Good to me, and test passed on my system.

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/778     |  190 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/778.out |    2 +
>  2 files changed, 192 insertions(+)
>  create mode 100755 tests/xfs/778
>  create mode 100644 tests/xfs/778.out
> 
> 
> diff --git a/tests/xfs/778 b/tests/xfs/778
> new file mode 100755
> index 00000000..73cebaf1
> --- /dev/null
> +++ b/tests/xfs/778
> @@ -0,0 +1,190 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 778
> +#
> +# Ensure that online shrink does not let us shrink the fs such that the end
> +# of the filesystem is now in the middle of a sparse inode cluster.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick shrink
> +
> +# Import common functions.
> +. ./common/filter
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_require_scratch
> +_require_xfs_sparse_inodes
> +_require_scratch_xfs_shrink
> +_require_xfs_io_command "falloc"
> +_require_xfs_io_command "fpunch"
> +
> +_scratch_mkfs "-d size=50m -m crc=1 -i sparse" |
> +	_filter_mkfs > /dev/null 2> $tmp.mkfs
> +. $tmp.mkfs	# for isize
> +cat $tmp.mkfs >> $seqres.full
> +
> +daddr_to_fsblocks=$((dbsize / 512))
> +
> +convert_units() {
> +	_scratch_xfs_db -f -c "$@" | sed -e 's/^.*(\([0-9]*\)).*$/\1/g'
> +}
> +
> +# Figure out the next possible inode number after the log, since we can't
> +# shrink or relocate the log
> +logstart=$(_scratch_xfs_get_metadata_field 'logstart' 'sb')
> +if [ $logstart -gt 0 ]; then
> +	logblocks=$(_scratch_xfs_get_metadata_field 'logblocks' 'sb')
> +	logend=$((logstart + logblocks))
> +	logend_agno=$(convert_units "convert fsb $logend agno")
> +	logend_agino=$(convert_units "convert fsb $logend agino")
> +else
> +	logend_agno=0
> +	logend_agino=0
> +fi
> +
> +_scratch_mount
> +_xfs_force_bdev data $SCRATCH_MNT
> +old_dblocks=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | grep geom.datablocks)
> +
> +mkdir $SCRATCH_MNT/save/
> +sino=$(stat -c '%i' $SCRATCH_MNT/save)
> +
> +_consume_freesp()
> +{
> +	file=$1
> +
> +	# consume nearly all available space (leave ~1MB)
> +	avail=`_get_available_space $SCRATCH_MNT`
> +	filesizemb=$((avail / 1024 / 1024 - 1))
> +	$XFS_IO_PROG -fc "falloc 0 ${filesizemb}m" $file
> +}
> +
> +# Allocate inodes in a directory until failure.
> +_alloc_inodes()
> +{
> +	dir=$1
> +
> +	i=0
> +	while [ true ]; do
> +		touch $dir/$i 2>> $seqres.full || break
> +		i=$((i + 1))
> +	done
> +}
> +
> +# Find a sparse inode cluster after logend_agno/logend_agino.
> +find_sparse_clusters()
> +{
> +	for ((agno = agcount - 1; agno >= logend_agno; agno--)); do
> +		_scratch_xfs_db -c "agi $agno" -c "addr root" -c "btdump" | \
> +			tr ':[,]' '    ' | \
> +			awk -v "agno=$agno" \
> +			    -v "agino=$logend_agino" \
> +'{if ($2 >= agino && and(strtonum($3), 0x8000)) {printf("%s %s %s\n", agno, $2, $3);}}' | \
> +			tac
> +	done
> +}
> +
> +# Calculate the fs inode chunk size based on the inode size and fixed 64-inode
> +# record. This value is used as the target level of free space fragmentation
> +# induced by the test (i.e., max size of free extents). We don't need to go
> +# smaller than a full chunk because the XFS block allocator tacks on alignment
> +# requirements to the size of the requested allocation. In other words, a chunk
> +# sized free chunk is not enough to guarantee a successful chunk sized
> +# allocation.
> +XFS_INODES_PER_CHUNK=64
> +CHUNK_SIZE=$((isize * XFS_INODES_PER_CHUNK))
> +
> +_consume_freesp $SCRATCH_MNT/spc
> +
> +# Now that the fs is nearly full, punch holes in every other $CHUNK_SIZE range
> +# of the space consumer file.  The goal here is to end up with a sparse cluster
> +# at the end of the fs (and past any internal log), where the chunks at the end
> +# of the cluster are sparse.
> +
> +offset=`_get_filesize $SCRATCH_MNT/spc`
> +offset=$((offset - $CHUNK_SIZE * 2))
> +nr=0
> +while [ $offset -ge 0 ]; do
> +	$XFS_IO_PROG -c "fpunch $offset $CHUNK_SIZE" $SCRATCH_MNT/spc \
> +		2>> $seqres.full || _fail "fpunch failed"
> +
> +	# allocate as many inodes as possible
> +	mkdir -p $SCRATCH_MNT/urk/offset.$offset > /dev/null 2>&1
> +	_alloc_inodes $SCRATCH_MNT/urk/offset.$offset
> +
> +	offset=$((offset - $CHUNK_SIZE * 2))
> +
> +	# Every five times through the loop, see if we got a sparse cluster
> +	nr=$((nr + 1))
> +	if [ $((nr % 5)) -eq 4 ]; then
> +		_scratch_unmount
> +		find_sparse_clusters > $tmp.clusters
> +		if [ -s $tmp.clusters ]; then
> +			break;
> +		fi
> +		_scratch_mount
> +	fi
> +done
> +
> +test -s $tmp.clusters || _notrun "Could not create a sparse inode cluster"
> +
> +echo clusters >> $seqres.full
> +cat $tmp.clusters >> $seqres.full
> +
> +# Figure out which inode numbers are in that last cluster.  We need to preserve
> +# that cluster but delete everything else ahead of shrinking.
> +icluster_agno=$(head -n 1 $tmp.clusters | cut -d ' ' -f 1)
> +icluster_agino=$(head -n 1 $tmp.clusters | cut -d ' ' -f 2)
> +icluster_ino=$(convert_units "convert agno $icluster_agno agino $icluster_agino ino")
> +
> +# Check that the save directory isn't going to prevent us from shrinking
> +test $sino -lt $icluster_ino || \
> +	echo "/save inode comes after target cluster, test may fail"
> +
> +# Save the inodes in the last cluster and delete everything else
> +_scratch_mount
> +rm -r $SCRATCH_MNT/spc
> +for ((ino = icluster_ino; ino < icluster_ino + XFS_INODES_PER_CHUNK; ino++)); do
> +	find $SCRATCH_MNT/urk/ -inum "$ino" -print0 | xargs -r -0 mv -t $SCRATCH_MNT/save/
> +done
> +rm -rf $SCRATCH_MNT/urk/ $SCRATCH_MNT/save/*/*
> +sync
> +$XFS_IO_PROG -c 'fsmap -vvvvv' $SCRATCH_MNT &>> $seqres.full
> +
> +# Propose shrinking the filesystem such that the end of the fs ends up in the
> +# sparse part of our sparse cluster.  Remember, the last block of that cluster
> +# ought to be free.
> +target_ino=$((icluster_ino + XFS_INODES_PER_CHUNK - 1))
> +for ((ino = target_ino; ino >= icluster_ino; ino--)); do
> +	found=$(find $SCRATCH_MNT/save/ -inum "$ino" | wc -l)
> +	test $found -gt 0 && break
> +
> +	ino_daddr=$(convert_units "convert ino $ino daddr")
> +	new_size=$((ino_daddr / daddr_to_fsblocks))
> +
> +	echo "Hope to fail at shrinking to $new_size" >> $seqres.full
> +	$XFS_GROWFS_PROG -D $new_size $SCRATCH_MNT &>> $seqres.full
> +	res=$?
> +
> +	# Make sure shrink did not work
> +	new_dblocks=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | grep geom.datablocks)
> +	if [ "$new_dblocks" != "$old_dblocks" ]; then
> +		echo "should not have shrank $old_dblocks -> $new_dblocks"
> +		break
> +	fi
> +
> +	if [ $res -eq 0 ]; then
> +		echo "shrink to $new_size (ino $ino) should have failed"
> +		break
> +	fi
> +done
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/778.out b/tests/xfs/778.out
> new file mode 100644
> index 00000000..e80f72a3
> --- /dev/null
> +++ b/tests/xfs/778.out
> @@ -0,0 +1,2 @@
> +QA output created by 778
> +Silence is golden
> 

