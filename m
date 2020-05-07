Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFF42C38A2A
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 16:28:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8B9020838
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 16:28:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T2h5Wx+b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgEGQ2x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 12:28:53 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23587 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726222AbgEGQ2x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 12:28:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588868931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C/ZPQdFAMXbaXgtLhwEcoNo90HqDBrY/9fZpVckIA9w=;
        b=T2h5Wx+bKmd4pnGnT+S5B7rNnstR27rj/dz1ITwJwGNh9HuWNqux45tuV5/PLJyg3owGP4
        /V1L5PEwAlaXFWRmX67ioWAi9P3TRzQrPcbvUn4ZnfPQ8vpaGx8RMa6qrf4es1RVG1bw8r
        NsE458v+SjBhMM+ZyCOj3Pj4lM0pgw4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-fwIXa0Y2N5ib7SBMbeMuIQ-1; Thu, 07 May 2020 12:28:49 -0400
X-MC-Unique: fwIXa0Y2N5ib7SBMbeMuIQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69FFB872FE1;
        Thu,  7 May 2020 16:28:48 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EE63E62A42;
        Thu,  7 May 2020 16:28:47 +0000 (UTC)
Date:   Thu, 7 May 2020 12:28:46 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/12] xfs: remove xfs_ifork_ops
Message-ID: <20200507162846.GG9003@bfoster>
References: <20200501081424.2598914-1-hch@lst.de>
 <20200501081424.2598914-9-hch@lst.de>
 <20200501155649.GO40250@bfoster>
 <20200501160809.GT6742@magnolia>
 <20200501163809.GA18426@lst.de>
 <20200501165017.GA20127@lst.de>
 <20200501182316.GT40250@bfoster>
 <20200507123411.GB17936@lst.de>
 <20200507134355.GF9003@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507134355.GF9003@bfoster>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 07, 2020 at 09:43:55AM -0400, Brian Foster wrote:
> On Thu, May 07, 2020 at 02:34:11PM +0200, Christoph Hellwig wrote:
> > On Fri, May 01, 2020 at 02:23:16PM -0400, Brian Foster wrote:
> > > Can we use another dummy parent inode value in xfs_repair? It looks to
> > > me that we set it to zero in phase 4 if it fails verification and set
> > > the parent to NULLFSINO (i.e. unknown) in repair's in-core tracking.
> > > Phase 6 walks the directory entries and explicitly sets the parent inode
> > > number of entries with an unknown parent (according to the in-core
> > > tracking). IOW, I don't see where we actually rely on the directory
> > > header having a parent inode of zero outside of detecting it in the
> > > custom verifier. If that's the only functional purpose, I wonder if we
> > > could do something like set the bogus parent field of a sf dir to the
> > > root inode or to itself, that way the default verifier wouldn't trip
> > > over it..
> > 
> > I don't think we need a dummy parent at all - we can just skip the
> > parent validation entirely, which is what my incremental patch does.
> > 
> 
> xfs_repair already skips the parent validation, this patch just
> refactors it. What I was considering above is whether repair uses the
> current dummy value of zero for any functional reason. If not, it kind
> of looks like the earlier phase of repair checks the parent, sees that
> it would fail a verifier, replaces it with zero (which would also fail
> the verifier) and then eventually replaces zero with a valid parent or
> ditches the entry in phase 6. If we placed a temporary parent value in
> the early phase that wouldn't explicitly fail a verifier by being an
> invalid inode number (instead of using 0 to notify the verifier to skip
> the validation), then we wouldn't need to skip the parent validation in
> phase 6 when we look up the inode again.
> 
...

To demonstrate, I hacked on repair a bit using an fs with an
intentionally corrupted shortform parent inode and had to make the
following tweaks to work around the custom fork verifier. The
ino_discovery checks were added because phases 3 and 4 toggle that flag
such that the former clears the parent value in the inode, but the
latter actually updates the external parent tracking. IOW, setting a
"valid" inode in phase 3 would otherwise trick phase 4 into using it.
I'd probably try to think of something cleaner for that issue if we were
to take such an approach.

Brian

diff --git a/repair/dir2.c b/repair/dir2.c
index cbbce601..c30ccb37 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -165,7 +165,7 @@ process_sf_dir2(
 	int			tmp_elen;
 	int			tmp_len;
 	xfs_dir2_sf_entry_t	*tmp_sfep;
-	xfs_ino_t		zero = 0;
+	xfs_ino_t		zero = mp->m_sb.sb_rootino;
 
 	sfp = (struct xfs_dir2_sf_hdr *)XFS_DFORK_DPTR(dip);
 	max_size = XFS_DFORK_DSIZE(dip, mp);
@@ -494,7 +494,8 @@ _("bogus .. inode number (%" PRIu64 ") in directory inode %" PRIu64 ", "),
 		if (!no_modify)  {
 			do_warn(_("clearing inode number\n"));
 
-			libxfs_dir2_sf_put_parent_ino(sfp, zero);
+			if (!ino_discovery)
+				libxfs_dir2_sf_put_parent_ino(sfp, zero);
 			*dino_dirty = 1;
 			*repair = 1;
 		} else  {
@@ -528,8 +529,8 @@ _("bad .. entry in directory inode %" PRIu64 ", points to self, "),
 			ino);
 		if (!no_modify)  {
 			do_warn(_("clearing inode number\n"));
-
-			libxfs_dir2_sf_put_parent_ino(sfp, zero);
+			if (!ino_discovery)
+				libxfs_dir2_sf_put_parent_ino(sfp, zero);
 			*dino_dirty = 1;
 			*repair = 1;
 		} else  {
diff --git a/repair/phase6.c b/repair/phase6.c
index beceea9a..613ca578 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1104,7 +1104,7 @@ mv_orphanage(
 					(unsigned long long)ino, ++incr);
 
 	/* Orphans may not have a proper parent, so use custom ops here */
-	err = -libxfs_iget(mp, NULL, ino, 0, &ino_p, &phase6_ifork_ops);
+	err = -libxfs_iget(mp, NULL, ino, 0, &ino_p, &xfs_default_ifork_ops);
 	if (err)
 		do_error(_("%d - couldn't iget disconnected inode\n"), err);
 
@@ -2875,7 +2875,7 @@ process_dir_inode(
 
 	ASSERT(!is_inode_refchecked(irec, ino_offset) || dotdot_update);
 
-	error = -libxfs_iget(mp, NULL, ino, 0, &ip, &phase6_ifork_ops);
+	error = -libxfs_iget(mp, NULL, ino, 0, &ip, &xfs_default_ifork_ops);
 	if (error) {
 		if (!no_modify)
 			do_error(

