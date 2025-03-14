Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7562F1FF1CF
	for <linux-xfs@vger.kernel.org>; Fri, 14 Mar 2025 13:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741959456; cv=none; b=nMm2KXNcKsXsHvcp7A4mauJqlHdlxH8bojufjAO+zGPVUnZ3r0ehsw5MOcvBOZhwbDSv5DW/zGqqSTxmSKwcOcCadd4SCC4Zz/xiixJBnaHB+kpY8NOQfKeyJ+aoGfMXmWFy04M0Amx+C6g0G4IcZ1uJyy/8wokBE4MkyyIKhAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741959456; c=relaxed/simple;
	bh=5CtmVj8cfO0OEJuzX4JAHOqwbWNDwfsHfWDLkgpD5To=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=d+kK/J7sgHhl7qMYo9gfHYg4tAX8MabTxTd2qy9y6qz14/wUDZ+9TvcJed+mL7sIcP/JOyHyTO36CjR8w1TrFYe3hwFaMFH1SeQyJUN1PkwCFDjMR5s5N1+kRzrjTu+tLBdNGqI75jQ+w5XFep/sjSMzUiDiwdpgrujDDeIeSAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iBDTypMM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iBDTypMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC7DC4CEE3
	for <linux-xfs@vger.kernel.org>; Fri, 14 Mar 2025 13:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741959455;
	bh=5CtmVj8cfO0OEJuzX4JAHOqwbWNDwfsHfWDLkgpD5To=;
	h=Date:From:To:Subject:From;
	b=iBDTypMM2E4HN29WJT99ZohfzYCqHVSCIU/9bSFIFk64sf80md/REaBL9JEWTiO0s
	 jqZiy2u3/zX+xFeLw+QXfuJKwL8Klv22JU+Uq1cLBzM2vriQBVG8modWMHPlWlXSey
	 5R+ltCY1yQgDNR+eWB1RF2Gx2/rTMHKZrPK7ys7988Qb+ePKmKLmfrz5qbXAupsgws
	 NDHiyLUlRZ2lnmmZIeK49quKf+37rs0lbbz+RmZTDhapB4DeCUs/RfvgOLxOrqqxmT
	 5GiCffi0dJ1KNPWa9mS+Hgi/LSnz4/3j8EOlQ3a0g++s5gu48BjeMBJm5yx8P80peV
	 ue9a3bjlm7B9A==
Date: Fri, 14 Mar 2025 14:37:32 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to a40830266566
Message-ID: <g2e6s3dhlevki76eoizein62wsociuj3gx5hrmn2stjrp7rzvf@xhggzokpa76o>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

a40830266566 Merge branch 'xfs-6.15-merge' into for-next

16 new commits:

Carlos Maiolino (2):
      [8e53370903d6] Merge branch 'xfs-6.15-folios_vmalloc' into xfs-6.15-merge
      [a40830266566] Merge branch 'xfs-6.15-merge' into for-next

Chen Ni (1):
      [ef0f5bd5dd62] xfs: remove unnecessary NULL check before kvfree()

Christoph Hellwig (10):
      [f2a3717a74c2] xfs: add a fast path to xfs_buf_zero when b_addr is set
      [51e10993153a] xfs: remove xfs_buf.b_offset
      [48a325a4eec3] xfs: remove xfs_buf_is_vmapped
      [50a524e0ef9b] xfs: refactor backing memory allocations for buffers
      [4ef398283182] xfs: remove the kmalloc to page allocator fallback
      [94c78cfa3bd1] xfs: convert buffer cache to use high order folios
      [a2f790b28512] xfs: kill XBF_UNMAPPED
      [e2874632a621] xfs: use vmalloc instead of vm_map_area for buffer backing memory
      [e614a00117bc] xfs: cleanup mapping tmpfs folios into the buffer cache
      [89ce287c83c9] xfs: trace what memory backs a buffer

Dave Chinner (2):
      [69659e46b758] xfs: unmapped buffer item size straddling mismatch
      [fd87851680ed] xfs: buffer items don't straddle pages anymore

Jiapeng Chong (1):
      [fcb255537bee] xfs: Remove duplicate xfs_rtbitmap.h header

Code Diffstat:

 fs/xfs/libxfs/xfs_ialloc.c    |   2 +-
 fs/xfs/libxfs/xfs_inode_buf.c |   2 +-
 fs/xfs/libxfs/xfs_sb.c        |   1 -
 fs/xfs/scrub/inode_repair.c   |   3 +-
 fs/xfs/xfs_buf.c              | 377 +++++++++++++++---------------------------
 fs/xfs/xfs_buf.h              |  25 ++-
 fs/xfs/xfs_buf_item.c         | 114 -------------
 fs/xfs/xfs_buf_item_recover.c |   8 +-
 fs/xfs/xfs_buf_mem.c          |  43 ++---
 fs/xfs/xfs_buf_mem.h          |   6 +-
 fs/xfs/xfs_inode.c            |   3 +-
 fs/xfs/xfs_rtalloc.c          |   3 +-
 fs/xfs/xfs_trace.h            |   4 +
 13 files changed, 169 insertions(+), 422 deletions(-)
