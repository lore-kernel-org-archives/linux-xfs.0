Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3289FC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Mar 2022 19:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbiCYTng (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Mar 2022 15:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbiCYTnT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Mar 2022 15:43:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8B93EAD33;
        Fri, 25 Mar 2022 12:17:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6549E61C24;
        Fri, 25 Mar 2022 17:59:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3010C2BBE4;
        Fri, 25 Mar 2022 17:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648231159;
        bh=7CKLpxTY5kohEs2BHuw0ijcAlCv9pWfAo0sx2/HS0HM=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=lwJJssmr3ZckFvdkQLjsQoF+A3kEprneT09NdoaJ2/Ht003QUcTJ+68mUWzp18E+4
         S27V/zoK8kYMSlzq1F9BoG+lQgMI3CrjP/6xsnq9ZvmZGy3x2OyvGjo3xsHU+qkJaY
         MBdmkVryhgqQVG/NPbVTGS/0/ROF6s4zISlNsJP2xvxJPjhn4rg4QlgkhmGIh7IUVr
         s2R4nMIOJXU+Jpj4I4ySFT/8CLNiD3TxnxHEK77GptBCCffRZOA1WZgLATgnC/7Iv4
         bmzCQhShsEWQkE8Wcz8cYNUhCQl2WSK1ZDagipGNpObMczIRRIX8Xr2rBahOFb3ln6
         HNnVCwITQ+Dtg==
Date:   Fri, 25 Mar 2022 10:59:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>
Subject: Re: [PATCH v1] xfs/019: extend protofile test
Message-ID: <20220325175919.GU8224@magnolia>
References: <20220317232408.202636-1-catherine.hoang@oracle.com>
 <20220323013653.46d432ybh2zpdhhs@zlang-mailbox>
 <641873A3-0E40-4099-9804-35D1D6792CFA@oracle.com>
 <20220324192600.5dx3vkmrl6z3snu5@zlang-mailbox>
 <20220324201730.GS8224@magnolia>
 <20220325133356.ektmgzck7rpaghcz@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220325133356.ektmgzck7rpaghcz@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 25, 2022 at 09:33:56PM +0800, Zorro Lang wrote:
> On Thu, Mar 24, 2022 at 01:17:30PM -0700, Darrick J. Wong wrote:
> > On Fri, Mar 25, 2022 at 03:26:00AM +0800, Zorro Lang wrote:
> > > On Thu, Mar 24, 2022 at 03:44:00PM +0000, Catherine Hoang wrote:
> > > > > On Mar 22, 2022, at 6:36 PM, Zorro Lang <zlang@redhat.com> wrote:
> > > > > 
> > > > > On Thu, Mar 17, 2022 at 11:24:08PM +0000, Catherine Hoang wrote:
> > > > >> This test creates an xfs filesystem and verifies that the filesystem
> > > > >> matches what is specified by the protofile.
> > > > >> 
> > > > >> This patch extends the current test to check that a protofile can specify
> > > > >> setgid mode on directories. Also, check that the created symlink isn’t
> > > > >> broken.
> > > > >> 
> > > > >> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> > > > >> ---
> > > > > 
> > > > > Any specific reason to add this test? Likes uncovering some one known
> > > > > bug/fix?
> > > > > 
> > > > > Thanks,
> > > > > Zorro
> > > > 
> > > > Hi Zorro,
> > > > 
> > > > We’ve been exploring alternate uses for protofiles and noticed a few holes
> > > > in the testing.
> > > 
> > > That's great, but better to show some details in the patch/commit, likes
> > > a commit id of xfsprogs?/kernel? (if there's one) which fix the bug you
> > > metioned, to help others to know what's this change trying to cover.
> > 
> > I think this patch is adding a check that protofile lines are actually
> > being honored (in the case of the symlink file) and checking that setgid
> > on a directory is not carried over into new children unless the
> > protofile explicitly marks the children setgid.
> > 
> > IOWs, this isn't adding a regression test for a fix in xfsprogs, it's
> > increasing test coverage.
> 
> Oh, understand, I have no objection with this patch, just thought it covers
> a known bug :) If it's good to you too, let's ACK it.

Yes!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Thanks,
> Zorro
> 
> > 
> > --D
> > 
> > > Thanks,
> > > Zorro
> > > 
> > > > 
> > > > Thanks,
> > > > Catherine
> > > > > 
> > > > >> tests/xfs/019     |  6 ++++++
> > > > >> tests/xfs/019.out | 12 +++++++++++-
> > > > >> 2 files changed, 17 insertions(+), 1 deletion(-)
> > > > >> 
> > > > >> diff --git a/tests/xfs/019 b/tests/xfs/019
> > > > >> index 3dfd5408..535b7af1 100755
> > > > >> --- a/tests/xfs/019
> > > > >> +++ b/tests/xfs/019
> > > > >> @@ -73,6 +73,10 @@ $
> > > > >> setuid -u-666 0 0 $tempfile
> > > > >> setgid --g666 0 0 $tempfile
> > > > >> setugid -ug666 0 0 $tempfile
> > > > >> +directory_setgid d-g755 3 2
> > > > >> +file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_5 ---755 3 1 $tempfile
> > > > >> +$
> > > > >> +: back in the root
> > > > >> block_device b--012 3 1 161 162 
> > > > >> char_device c--345 3 1 177 178
> > > > >> pipe p--670 0 0
> > > > >> @@ -114,6 +118,8 @@ _verify_fs()
> > > > >> 		| xargs $here/src/lstat64 | _filter_stat)
> > > > >> 	diff -q $SCRATCH_MNT/bigfile $tempfile.2 \
> > > > >> 		|| _fail "bigfile corrupted"
> > > > >> +	diff -q $SCRATCH_MNT/symlink $tempfile.2 \
> > > > >> +		|| _fail "symlink broken"
> > > > >> 
> > > > >> 	echo "*** unmount FS"
> > > > >> 	_full "umount"
> > > > >> diff --git a/tests/xfs/019.out b/tests/xfs/019.out
> > > > >> index 19614d9d..8584f593 100644
> > > > >> --- a/tests/xfs/019.out
> > > > >> +++ b/tests/xfs/019.out
> > > > >> @@ -7,7 +7,7 @@ Wrote 2048.00Kb (value 0x2c)
> > > > >>  File: "."
> > > > >>  Size: <DSIZE> Filetype: Directory
> > > > >>  Mode: (0777/drwxrwxrwx) Uid: (3) Gid: (1)
> > > > >> -Device: <DEVICE> Inode: <INODE> Links: 3 
> > > > >> +Device: <DEVICE> Inode: <INODE> Links: 4 
> > > > >> 
> > > > >>  File: "./bigfile"
> > > > >>  Size: 2097152 Filetype: Regular File
> > > > >> @@ -54,6 +54,16 @@ Device: <DEVICE> Inode: <INODE> Links: 1
> > > > >>  Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
> > > > >> Device: <DEVICE> Inode: <INODE> Links: 1 
> > > > >> 
> > > > >> + File: "./directory_setgid"
> > > > >> + Size: <DSIZE> Filetype: Directory
> > > > >> + Mode: (2755/drwxr-sr-x) Uid: (3) Gid: (2)
> > > > >> +Device: <DEVICE> Inode: <INODE> Links: 2 
> > > > >> +
> > > > >> + File: "./directory_setgid/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_5"
> > > > >> + Size: 5 Filetype: Regular File
> > > > >> + Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (2)
> > > > >> +Device: <DEVICE> Inode: <INODE> Links: 1 
> > > > >> +
> > > > >>  File: "./pipe"
> > > > >>  Size: 0 Filetype: Fifo File
> > > > >>  Mode: (0670/frw-rwx---) Uid: (0) Gid: (0)
> > > > >> -- 
> > > > >> 2.25.1
> > > > >> 
> > > > > 
> > > > 
> > > 
> > 
> 
