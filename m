Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9109AC19F2B
	for <linux-xfs@archiver.kernel.org>; Sun, 31 Jul 2022 16:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbiGaQ6p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Jul 2022 12:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236777AbiGaQ6n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 31 Jul 2022 12:58:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5016EAE4E;
        Sun, 31 Jul 2022 09:58:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0172BB80D83;
        Sun, 31 Jul 2022 16:58:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B328DC433D6;
        Sun, 31 Jul 2022 16:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659286719;
        bh=5FvwGtCJCdP7GwVOSFurUQTAGWzW77xMOdq4LdSoK8w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gMALhZxHcJXybOR5DT1xakdz41d7bnZClPD+oeJdWzJawsedIz1kCB+OTNRS7pViV
         1sq2qTYPPcGuFvmiqlvCKYQz+Lc74nECWcXSvLmtsVomsFhcqdHVSdJe7AF5mI8JlU
         yg4a2zLl9X3c6ARLMb97GYzcyNoZ4Qni0HNuzZB/YAz/QApjTxTjvwzftQVgUPYrEB
         jdvQ8nANCSHlj+GBZFpdIu6OJVuA5+uLiZldtFr0D2vkxZhBnudiAAccEMNXSGvSlQ
         1OXSM9wRu22ZqDK0Se0iiOKW9m3p0hHND5Oduj+55PHte1E6LkFta4AmUouYG5NlA3
         QbwU6XkIoy9iA==
Date:   Sun, 31 Jul 2022 09:58:39 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs/432: fix this test when external devices are in
 use
Message-ID: <Yua0vwCQFsayKH1x@magnolia>
References: <165903222941.2338516.818684834175743726.stgit@magnolia>
 <165903223512.2338516.9583051314883581667.stgit@magnolia>
 <YuLunHKTHbw1wcvZ@infradead.org>
 <20220731052912.u3mcvvhl2dintaqq@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220731052912.u3mcvvhl2dintaqq@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 31, 2022 at 01:29:12PM +0800, Zorro Lang wrote:
> On Thu, Jul 28, 2022 at 01:16:28PM -0700, Christoph Hellwig wrote:
> > On Thu, Jul 28, 2022 at 11:17:15AM -0700, Darrick J. Wong wrote:
> > > +SCRATCH_DEV=$metadump_img _scratch_xfs_repair -n &>> $seqres.full || \
> > > +	echo "xfs_repair on restored fs returned $?"
> > 
> > Wouldn;t it make more sense to have a version of _scratch_xfs_repair
> > rather than doing a somewhat unexpected override of this global
> > variable?
> 
> Any detailed ideas about how to have a new version of _scratch_xfs_repair? I'll
> keep this patch unmerged this week, before Darrick reply your discussion.
> 
> Currently a few cases do some overriding [1] before calling _scratch_* helpers.
> And good news is this kind of "override" affect only the environment seen by
> its follow command/function. So I generally don't have objection if it works
> well. But it's welcome if we have a better idea to deal with this kind of
> requirement :)

I don't know of a better way to do "xfs_repair the scratch filesystem,
but with a different scratch device".

One could create a new helper wherein any parameter that happens to be a
path to a regular file or bdev would cause SCRATCH_DEV not to be
included, but now we're walking arguments instead of being agnostic
about them and merely passing them through to $XFS_REPAIR_PROG
untouched.  Worse yet, if there just happens to be (say) a file named
'-d' or 'rmapbt=1' in the current directory, the test will think it
should omit SCRATCH_DEV.  The C getopt parser in xfs_repair won't see
things this way, and these two tests become brittle over that.

This can be worked around by parsing the arguments so that any getopt
arguments will not be subjected to the "Should we override SCRATCH_DEV?"
test.  Because xfs_repair options change over time, we'd have to scan
the binary to extract the getopt string (or construct it from --help).
This is nontrivial, so the xfs_repair getopt extraction routines
themselves will need a new fstest to test the test code, lest the two
tests become brittle over that.

All that fugly parsing crap can be worked around by teaching xfs_repair
to ignore any respecified data device paths, but this is likely to cause
resistance from the xfsprogs maintainers because that sounds like an
avenue to introduce confusing behavior to end users.

*OR* we could just override the variable definition for the one line
since (for once) bash makes this easy and the syntax communicates very
loudly "HI USE THIS ALT SCRATCH_DEV PLZ".  And test authors already do
this.

--D

> Thanks,
> Zorro
> 
> 
> [1]
> $ grep -rsn SCRATCH_DEV= tests/
> tests/btrfs/160:36:old_SCRATCH_DEV=$SCRATCH_DEV
> tests/btrfs/160:38:SCRATCH_DEV=$DMERROR_DEV
> tests/btrfs/146:39:old_SCRATCH_DEV=$SCRATCH_DEV
> tests/btrfs/146:41:SCRATCH_DEV=$DMERROR_DEV
> tests/btrfs/146:62:SCRATCH_DEV=$old_SCRATCH_DEV
> tests/xfs/507:198:LARGE_SCRATCH_DEV=yes _check_xfs_filesystem $loop_dev none none
> tests/xfs/185:75:SCRATCH_DEV="$ddloop"
> tests/xfs/234:56:SCRATCH_DEV=$TEST_DIR/image _scratch_mount
> tests/xfs/234:57:SCRATCH_DEV=$TEST_DIR/image _scratch_unmount
> tests/xfs/336:68:SCRATCH_DEV=$TEST_DIR/image _scratch_mount
> tests/xfs/336:69:SCRATCH_DEV=$TEST_DIR/image _scratch_unmount
> tests/xfs/157:61:       SCRATCH_DEV=$orig_ddev
> tests/xfs/157:76:SCRATCH_DEV=$fake_datafile
> tests/xfs/129:56:SCRATCH_DEV=$TEST_DIR/image _scratch_mount
> tests/xfs/129:57:SCRATCH_DEV=$TEST_DIR/image _scratch_unmount
> tests/ceph/005:27:SCRATCH_DEV="$SCRATCH_DEV/quota-dir" _scratch_mount
> tests/ceph/005:29:SCRATCH_DEV="$SCRATCH_DEV_ORIG/quota-dir" _scratch_unmount
> tests/ceph/005:31:SCRATCH_DEV="$SCRATCH_DEV_ORIG/quota-dir/subdir" _scratch_mount
> tests/ceph/005:33:SCRATCH_DEV="$SCRATCH_DEV_ORIG/quota-dir/subdir" _scratch_unmount
> 
> > 
> 
