Return-Path: <SRS0=qEB5=44=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39A54C0044D
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 17:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACDD32074B
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 17:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730193AbgCKRWi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Mar 2020 13:22:38 -0400
Received: from verein.lst.de ([213.95.11.211]:60536 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730351AbgCKRWi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Mar 2020 13:22:38 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id CC68568B05; Wed, 11 Mar 2020 18:22:34 +0100 (CET)
Date:   Wed, 11 Mar 2020 18:22:34 +0100
From:   "hch@lst.de" <hch@lst.de>
To:     "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
Cc:     "hch@lst.de" <hch@lst.de>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 5.5 XFS getdents regression?
Message-ID: <20200311172234.GA26340@lst.de>
References: <72c5fd8e9a23dde619f70f21b8100752ec63e1d2.camel@nokia.com> <20200310221406.GO10776@dread.disaster.area> <862b6c718957aff7156bf04964b7242f5075e8a7.camel@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <862b6c718957aff7156bf04964b7242f5075e8a7.camel@nokia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 11, 2020 at 05:06:16PM +0000, Rantala, Tommi T. (Nokia - FI/Espoo) wrote:
> On Wed, 2020-03-11 at 09:14 +1100, Dave Chinner wrote:
> > On Tue, Mar 10, 2020 at 08:45:58AM +0000, Rantala, Tommi T. (Nokia -
> > FI/Espoo) wrote:
> > > Hello,
> > > 
> > > One of my GitLab CI jobs stopped working after upgrading server
> > > 5.4.18-
> > > 100.fc30.x86_64 -> 5.5.7-100.fc30.x86_64.
> > > (tested 5.5.8-100.fc30.x86_64 too, no change)
> > > The server is fedora30 with XFS rootfs.
> > > The problem reproduces always, and takes only couple minutes to run.
> > > 
> > > The CI job fails in the beginning when doing "git clean" in docker
> > > container, and failing to rmdir some directory:
> > > "warning: failed to remove 
> > > .vendor/pkg/mod/golang.org/x/net@v0.0.0-20200114155413-6afb5195e5aa/in
> > > tern
> > > al/socket: Directory not empty"
> > > 
> > > Quick google search finds some other people reporting similar problems
> > > with 5.5.0:
> > > https://gitlab.com/gitlab-org/gitlab-runner/issues/3185
> > 
> > Which appears to be caused by multiple gitlab processes modifying
> > the directory at the same time. i.e. something is adding an entry to
> > the directory at the same time something is trying to rm -rf it.
> > That's a race condition, and would lead to the exact symptoms you
> > see here, depending on where in the directory the new entry is
> > added.
> 
> OK traced "execve" with strace too, and it shows that it's "git clean
> -ffdx" command (single process) that is being executed in the container,
> which is doing the cleanup.
> 
> Tested with 5.6-rc5, it's failing the same way.
> 
> Spent some time to bisect this, and the problem is introduced by this:
> 
> commit 263dde869bd09b1a709fd92118c7fff832773689
> Author: Christoph Hellwig <hch@lst.de>
> Date:   Fri Nov 8 15:05:32 2019 -0800
> 
>     xfs: cleanup xfs_dir2_block_getdents
>     
>     Use an offset as the main means for iteration, and only do pointer
>     arithmetics to find the data/unused entries.
>     
>     Signed-off-by: Christoph Hellwig <hch@lst.de>
>     Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>     Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> 
> 
> Hmmmmm, looking at that commit, I think it slighty changed how the
> "offset" is used compared to how the pointers were used.
> 
> This cures the issue for me, tested (briefly) on top of 5.6-rc5.
> Does it make sense...?
> (Email client probably damages white-space, sorry, I'll send this properly
> signed-off with git-send-email if it's OK)

Thanks, this looks good.  Although I wonder if the slightly different
version below might be a little more elegant?

diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 0d3b640cf1cc..871ec22c9aee 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -147,7 +147,7 @@ xfs_dir2_block_getdents(
 	xfs_off_t		cook;
 	struct xfs_da_geometry	*geo = args->geo;
 	int			lock_mode;
-	unsigned int		offset;
+	unsigned int		offset, next_offset;
 	unsigned int		end;
 
 	/*
@@ -173,9 +173,10 @@ xfs_dir2_block_getdents(
 	 * Loop over the data portion of the block.
 	 * Each object is a real entry (dep) or an unused one (dup).
 	 */
-	offset = geo->data_entry_offset;
 	end = xfs_dir3_data_end_offset(geo, bp->b_addr);
-	while (offset < end) {
+	for (offset = geo->data_entry_offset;
+	     offset < end;
+	     offset = next_offset) {
 		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
 		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
 		uint8_t filetype;
@@ -184,14 +185,15 @@ xfs_dir2_block_getdents(
 		 * Unused, skip it.
 		 */
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
-			offset += be16_to_cpu(dup->length);
+			next_offset = offset + be16_to_cpu(dup->length);
 			continue;
 		}
 
 		/*
 		 * Bump pointer for the next iteration.
 		 */
-		offset += xfs_dir2_data_entsize(dp->i_mount, dep->namelen);
+		next_offset = offset +
+			xfs_dir2_data_entsize(dp->i_mount, dep->namelen);
 
 		/*
 		 * The entry is before the desired starting point, skip it.
