Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB59CC001B0
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jul 2023 17:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbjGMREm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jul 2023 13:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbjGMREl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2023 13:04:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A58E2683;
        Thu, 13 Jul 2023 10:04:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C561861AEA;
        Thu, 13 Jul 2023 17:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2857CC433C7;
        Thu, 13 Jul 2023 17:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689267878;
        bh=8rhLoaJR3OyxDEDKuvCAwPKDXr/LOI/3a7/nmEAIaMc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QykXcTdZoduUgUyTMqJqtcWAIxbllAf0SXA2+WblTiQXUDZ3PpdebZsy9av5DuMQV
         RApKquuF6YYR5pDMzp+gZV7E9BJ5i7l2NAOGHrunsC9H230m+w1WQsscHdwUpikj8G
         Jw/dfWTKqTm3LbRrEp7CjqxVnKn0L7IpzyYDnIFlgFk4chxiLdWgWDQ4GmFQxMCFkv
         jfxsxl7GgnCB+raCRzQSg+zls0vLp6sPmGaNeuZ/xdzCa1/zPIjJt0jfIyYpxgGXm/
         k+nYVo9zJGLqm/Mf7s1YSU5ga7B1LWRE46R2tdHnZwxGO6WdhiyPJ3YRC14wrJ7/L0
         LERYbr/it4vuA==
Date:   Thu, 13 Jul 2023 10:04:37 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH] xfs: add a couple more tests for ascii-ci problems
Message-ID: <20230713170437.GR108251@frogsfrogsfrogs>
References: <20230711202528.GB11442@frogsfrogsfrogs>
 <20230713151645.7dztbrccuy2i4co7@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230713151645.7dztbrccuy2i4co7@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 13, 2023 at 11:16:45PM +0800, Zorro Lang wrote:
> On Tue, Jul 11, 2023 at 01:25:28PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add some tests to make sure that userspace and the kernel actually
> > agree on how to do ascii case-insensitive directory lookups, and that
> > metadump can actually obfuscate such filesystems.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/859     |   64 ++++++++++++++++++++++++++++++++++
> >  tests/xfs/859.out |   24 +++++++++++++
> >  tests/xfs/860     |  100 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/860.out |    9 +++++
> >  tests/xfs/861     |   90 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/861.out |    2 +
> >  6 files changed, 289 insertions(+)
> >  create mode 100755 tests/xfs/859
> >  create mode 100644 tests/xfs/859.out
> >  create mode 100755 tests/xfs/860
> >  create mode 100644 tests/xfs/860.out
> >  create mode 100755 tests/xfs/861
> >  create mode 100644 tests/xfs/861.out
> > 
> > diff --git a/tests/xfs/859 b/tests/xfs/859
> > new file mode 100755
> > index 0000000000..e99619c12f
> > --- /dev/null
> > +++ b/tests/xfs/859
> > @@ -0,0 +1,64 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2023 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test 859
> > +#
> > +# Make sure that the kernel and userspace agree on which byte sequences are
> > +# ASCII uppercase letters, and how to convert them.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto ci dir
> > +
> > +# Override the default cleanup function.
> > +# _cleanup()
> > +# {
> > +# 	cd /
> > +# 	rm -r -f $tmp.*
> > +# }
> 
> Need to remove.

Oops, will do.

> > +
> > +# Import common functions.
> > +. ./common/filter
> > +
> > +_fixed_by_kernel_commit a9248538facc "xfs: stabilize the dirent name transformation function used for ascii-ci dir hash computation"
> > +_fixed_by_kernel_commit 9dceccc5822f "xfs: use the directory name hash function for dir scrubbing"
> > +
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_xfs_mkfs_ciname
> > +
> > +_scratch_mkfs -n version=ci > $seqres.full
> 
> Ok, as you've check the version=ci in _require_xfs_mkfs_ciname, I think we don't
> need check the return status of this _scratch_mkfs.

<nod>  Also that "> $seqres.full" ought to be an append.

> > +_scratch_mount
> > +
> > +# Create a two-block directory to force leaf format
> > +mkdir "$SCRATCH_MNT/lol"
> > +touch "$SCRATCH_MNT/lol/autoexec.bat"
> > +i=0
> > +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
> > +nr_dirents=$((dblksz * 2 / 256))
> > +
> > +for ((i = 0; i < nr_dirents; i++)); do
> > +	name="$(printf "y%0254d" $i)"
> > +	ln "$SCRATCH_MNT/lol/autoexec.bat" "$SCRATCH_MNT/lol/$name"
> > +done
> > +
> > +dirsz=$(stat -c '%s' $SCRATCH_MNT/lol)
> > +test $dirsz -gt $dblksz || echo "dir size $dirsz, expected at least $dblksz?"
> > +stat $SCRATCH_MNT/lol >> $seqres.full
> > +
> > +# Create names with extended ascii characters in them to exploit the fact
> > +# that the Linux kernel will transform extended ASCII uppercase characters
> > +# but libc won't.  Need to force LANG=C here so that awk doesn't spit out utf8
> > +# sequences.
> > +old_lang="$LANG"
> > +LANG=C
> 
> Actually fstests test LANG=C by default in common/config:
>   export LANG=C
>   export LC_ALL=C
> 
> Anyway, I don't mind we make sure LANG=C in this case.

Oh yeah!  I forgot that fstests sets LANG=C when I <cough> copy-pasted
this from an internal reproducer script.  I'll either get rid of this
entirely or change it to

test "$LANG" = "C" || _notrun "LANG!=C, did the defaults change??"

> 
> > +awk 'END { for (i = 192; i < 247; i++) printf("%c\n", i); }' < /dev/null | while read name; do
> > +	ln "$SCRATCH_MNT/lol/autoexec.bat" "$SCRATCH_MNT/lol/$name" 2>&1 | _filter_scratch
> > +done
> > +
> > +LANG=$old_lang
> 
> How about package your code into a local function (e.g. do_test), then does:
> 
> LANG=C do_test
> 
> Will that help? If so, that can help to avoid the LANG set and restore. Or
> we'd better to restore the LANG in _cleanup of this case.

...and then I don't need to make any of these changes.

--D

> 
> (similar review points to below cases)
> 
> Thanks,
> Zorro
> 
> > +
> > +# Now just let repair run
> > +
> > +status=0
> > +exit
> > diff --git a/tests/xfs/859.out b/tests/xfs/859.out
> > new file mode 100644
> > index 0000000000..a4939ba670
> > --- /dev/null
> > +++ b/tests/xfs/859.out
> > @@ -0,0 +1,24 @@
> > +QA output created by 859
> > +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\340': File exists
> > +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\341': File exists
> > +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\342': File exists
> > +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\343': File exists
> > +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\344': File exists
> > +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\345': File exists
> > +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\346': File exists
> > +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\347': File exists
> > +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\350': File exists
> > +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\351': File exists
> > +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\352': File exists
> > +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\353': File exists
> > +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\354': File exists
> > +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\355': File exists
> > +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\356': File exists
> > +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\357': File exists
> > +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\360': File exists
> > +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\361': File exists
> > +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\362': File exists
> > +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\363': File exists
> > +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\364': File exists
> > +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\365': File exists
> > +ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\366': File exists
> > diff --git a/tests/xfs/860 b/tests/xfs/860
> > new file mode 100755
> > index 0000000000..42f16efe6c
> > --- /dev/null
> > +++ b/tests/xfs/860
> > @@ -0,0 +1,100 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2023 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test 860
> > +#
> > +# Make sure that metadump obfuscation works for filesystems with ascii-ci
> > +# enabled.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto dir ci
> > +
> > +_cleanup()
> > +{
> > +      cd /
> > +      rm -r -f $tmp.* $testdir
> > +}
> > +
> > +_fixed_by_git_commit xfsprogs 10a01bcd "xfs_db: fix metadump name obfuscation for ascii-ci filesystems"
> > +
> > +_supported_fs xfs
> > +_require_test
> > +_require_scratch
> > +_require_xfs_mkfs_ciname
> > +
> > +_scratch_mkfs -n version=ci > $seqres.full
> > +_scratch_mount
> > +
> > +# Create a two-block directory to force leaf format
> > +mkdir "$SCRATCH_MNT/lol"
> > +touch "$SCRATCH_MNT/lol/autoexec.bat"
> > +i=0
> > +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
> > +nr_dirents=$((dblksz * 2 / 256))
> > +
> > +for ((i = 0; i < nr_dirents; i++)); do
> > +	name="$(printf "y%0254d" $i)"
> > +	ln "$SCRATCH_MNT/lol/autoexec.bat" "$SCRATCH_MNT/lol/$name"
> > +done
> > +
> > +dirsz=$(stat -c '%s' $SCRATCH_MNT/lol)
> > +test $dirsz -gt $dblksz || echo "dir size $dirsz, expected at least $dblksz?"
> > +stat $SCRATCH_MNT/lol >> $seqres.full
> > +
> > +# Create a two-block attr to force leaf format
> > +i=0
> > +for ((i = 0; i < nr_dirents; i++)); do
> > +	name="$(printf "user.%0250d" $i)"
> > +	$SETFATTR_PROG -n "$name" -v 1 "$SCRATCH_MNT/lol/autoexec.bat"
> > +done
> > +stat $SCRATCH_MNT/lol/autoexec.bat >> $seqres.full
> > +
> > +_scratch_unmount
> > +
> > +testdir=$TEST_DIR/$seq.metadumps
> > +mkdir -p $testdir
> > +metadump_file=$testdir/scratch.md
> > +metadump_file_a=${metadump_file}.a
> > +metadump_file_o=${metadump_file}.o
> > +metadump_file_ao=${metadump_file}.ao
> > +
> > +echo metadump
> > +_scratch_xfs_metadump $metadump_file >> $seqres.full
> > +
> > +echo metadump a
> > +_scratch_xfs_metadump $metadump_file_a -a >> $seqres.full
> > +
> > +echo metadump o
> > +_scratch_xfs_metadump $metadump_file_o -o >> $seqres.full
> > +
> > +echo metadump ao
> > +_scratch_xfs_metadump $metadump_file_ao -a -o >> $seqres.full
> > +
> > +echo mdrestore
> > +_scratch_xfs_mdrestore $metadump_file
> > +_scratch_mount
> > +_check_scratch_fs
> > +_scratch_unmount
> > +
> > +echo mdrestore a
> > +_scratch_xfs_mdrestore $metadump_file_a
> > +_scratch_mount
> > +_check_scratch_fs
> > +_scratch_unmount
> > +
> > +echo mdrestore o
> > +_scratch_xfs_mdrestore $metadump_file_o
> > +_scratch_mount
> > +_check_scratch_fs
> > +_scratch_unmount
> > +
> > +echo mdrestore ao
> > +_scratch_xfs_mdrestore $metadump_file_ao
> > +_scratch_mount
> > +_check_scratch_fs
> > +_scratch_unmount
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/860.out b/tests/xfs/860.out
> > new file mode 100644
> > index 0000000000..136fc5f7d6
> > --- /dev/null
> > +++ b/tests/xfs/860.out
> > @@ -0,0 +1,9 @@
> > +QA output created by 860
> > +metadump
> > +metadump a
> > +metadump o
> > +metadump ao
> > +mdrestore
> > +mdrestore a
> > +mdrestore o
> > +mdrestore ao
> > diff --git a/tests/xfs/861 b/tests/xfs/861
> > new file mode 100755
> > index 0000000000..7b0a37a3f1
> > --- /dev/null
> > +++ b/tests/xfs/861
> > @@ -0,0 +1,90 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2023 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test 861
> > +#
> > +# Make sure that the kernel and utilities can handle large numbers of dirhash
> > +# collisions in both the directory and extended attribute structures.
> > +#
> > +# This started as a regression test for the new 'hashcoll' function in xfs_db,
> > +# but became a regression test for an xfs_repair bug affecting hashval checks
> > +# applied to the second and higher node levels of a dabtree.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto dir
> > +
> > +_fixed_by_git_commit xfsprogs b7b81f336ac "xfs_repair: fix incorrect dabtree hashval comparison"
> > +
> > +_supported_fs xfs
> > +_require_xfs_db_command "hashcoll"
> > +_require_xfs_db_command "path"
> > +_require_scratch
> > +
> > +_scratch_mkfs > $seqres.full
> > +_scratch_mount
> > +
> > +crash_dir=$SCRATCH_MNT/lol/
> > +crash_attrs=$SCRATCH_MNT/hah
> > +
> > +mkdir -p "$crash_dir"
> > +touch "$crash_attrs"
> > +
> > +# Create enough dirents to fill two dabtree node blocks with names that all
> > +# hash to the same value.  Each dirent gets its own record in the dabtree,
> > +# so we must create enough dirents to get a dabtree of at least height 2.
> > +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
> > +
> > +da_records_per_block=$((dblksz / 8))	# 32-bit hash and 32-bit before
> > +nr_dirents=$((da_records_per_block * 2))
> > +
> > +longname="$(mktemp --dry-run "$(perl -e 'print "X" x 255;')" | tr ' ' 'X')"
> > +echo "creating $nr_dirents dirents from '$longname'" >> $seqres.full
> > +_scratch_xfs_db -r -c "hashcoll -n $nr_dirents -p $crash_dir $longname"
> > +
> > +# Create enough xattrs to fill two dabtree nodes.  Each attribute leaf block
> > +# gets its own record in the dabtree, so we have to create enough attr blocks
> > +# (each full of attrs) to get a dabtree of at least height 2.
> > +blksz=$(_get_block_size "$SCRATCH_MNT")
> > +
> > +attr_records_per_block=$((blksz / 255))
> > +da_records_per_block=$((blksz / 8))	# 32-bit hash and 32-bit before
> > +nr_attrs=$((da_records_per_block * attr_records_per_block * 2))
> > +
> > +longname="$(mktemp --dry-run "$(perl -e 'print "X" x 249;')" | tr ' ' 'X')"
> > +echo "creating $nr_attrs attrs from '$longname'" >> $seqres.full
> > +_scratch_xfs_db -r -c "hashcoll -a -n $nr_attrs -p $crash_attrs $longname"
> > +
> > +_scratch_unmount
> > +
> > +# Make sure that there's one hash value dominating the dabtree block.
> > +# We don't require 100% because directories create dabtree records for dot
> > +# and dotdot.
> > +filter_hashvals() {
> > +	uniq -c | awk -v seqres_full="$seqres.full" \
> > +		'{print $0 >> seqres_full; tot += $1; if ($1 > biggest) biggest = $1;} END {if (biggest >= (tot - 2)) exit(0); exit(1);}'
> > +	test "${PIPESTATUS[1]}" -eq 0 || \
> > +		echo "Scattered dabtree hashes?  See seqres.full"
> > +}
> > +
> > +# Did we actually get a two-level dabtree for the directory?  Does it contain a
> > +# long run of hashes?
> > +echo "dir check" >> $seqres.full
> > +da_node_block_offset=$(( (2 ** 35) / blksz ))
> > +dir_db_args=(-c 'path /lol/' -c "dblock $da_node_block_offset" -c 'addr nbtree[0].before')
> > +dir_count="$(_scratch_xfs_db "${dir_db_args[@]}" -c 'print lhdr.count' | awk '{print $3}')"
> > +_scratch_xfs_db "${dir_db_args[@]}" -c "print lents[0-$((dir_count - 1))].hashval" | sed -e 's/lents\[[0-9]*\]/lents[NN]/g' | filter_hashvals
> > +
> > +# Did we actually get a two-level dabtree for the attrs?  Does it contain a
> > +# long run of hashes?
> > +echo "attr check" >> $seqres.full
> > +attr_db_args=(-c 'path /hah' -c "ablock 0" -c 'addr btree[0].before')
> > +attr_count="$(_scratch_xfs_db "${attr_db_args[@]}" -c 'print hdr.count' | awk '{print $3}')"
> > +_scratch_xfs_db "${attr_db_args[@]}" -c "print btree[0-$((attr_count - 1))].hashval" | sed -e 's/btree\[[0-9]*\]/btree[NN]/g' | filter_hashvals
> > +
> > +# Remount to get some coverage of xfs_scrub before seeing if xfs_repair
> > +# will trip over the large dabtrees.
> > +echo Silence is golden
> > +_scratch_mount
> > +status=0
> > +exit
> > diff --git a/tests/xfs/861.out b/tests/xfs/861.out
> > new file mode 100644
> > index 0000000000..d11b76c82e
> > --- /dev/null
> > +++ b/tests/xfs/861.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 861
> > +Silence is golden
> > 
> 
