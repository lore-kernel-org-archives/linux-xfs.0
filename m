Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAEC2DEA72
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 12:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752582690; cv=none; b=fGh2CxvgS6fH26ill3GYAUqEc3/k0k6kGqqZpQLoW/S1FniZhECgdNfBxSzCVcWrGd8TvXPe6j9OtuxBsnxNT3mYdc2nc9rca5uw0Z6U0s7SbC8nG3k+cAdon+unZTGqghBu0RwGeb5AXkQamm4AmFg1md43l2U7vxuJSBtjW/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752582690; c=relaxed/simple;
	bh=0PDhno7iun8cSlcicRqem7Cdwa8xfYumlyTht6GkXDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HxM0m8U+hm0jo1hj7xonizSM901tAUq8MscH+aYYMvCDtOAupRB6JkRsPCv4zJg1b18SHaZR6hbABjqb5S9faY0RaOxEs2EC3xUtnVX7OYtpG8H/c9FphwRy/bCjJWQpAZ3gQ/5A9SUHfc8ebaqZwosMrfK2/cTlGyWiqJ4kv8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ze8lGwUx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ze8lGwUx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=PX6jxPxd4z2/rdCEPewmKNBVlnt+d74AZGqJAE+exug=; b=ze8lGwUxBiy3UHCVeXVYtzsGOX
	/Q5L4VUsQQDOvSSlircGwmywyYgQYDxUnS9zwSrlgFk72eL/AstemCOEQJt5KiRNsGlol4hU8NJvQ
	FM2mdYttKPkXAmg8DHLjXzkJzpwb9hwUgIYYnInNWs73Nc+DNW06PRWUcQH6LmtOev9JRAu2wckm4
	cp3EWIhFzy+v6fazwFX0Gv1sThCyuPtS25alHgdKPNnNN4Sh5rDRAO3hWO6GIRZZm7hZ8mZBbcuT1
	E900+Twt+n9goq3AKjzqaPD7hEpgRuEDA404rms7hM1zaOCsVrW2pgfzfFfhMYo3mJn05I36QSDzn
	eNYN7gCg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ubeoh-000000054kA-2JOV;
	Tue, 15 Jul 2025 12:31:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: misc log cleanups allocation
Date: Tue, 15 Jul 2025 14:30:05 +0200
Message-ID: <20250715123125.1945534-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this is the harmless part of the "cleanup log item formatting" that
does not change the log space accounting.  I've reproduced the
issue Dave reported with that, which just got me further into the
rabit hole.  So I'd appreciate reviews for just these mostly
cosmetic changes for now, and I'll return to the harder parts
some time later.

A git tree is also available here:

    git://git.infradead.org/users/hch/xfs.git xfs-log-cleanups

Gitweb:

    https://git.infradead.org/?p=users/hch/xfs.git;a=shortlog;h=refs/heads/xfs-log-cleanups

Diffstat:
 libxfs/xfs_refcount.c |    4 -
 scrub/common.c        |    7 +
 scrub/common.h        |    2 
 scrub/dir_repair.c    |    8 --
 scrub/fscounters.c    |    3 
 scrub/metapath.c      |    4 -
 scrub/nlinks.c        |    8 --
 scrub/nlinks_repair.c |    4 -
 scrub/parent_repair.c |   12 ---
 scrub/quotacheck.c    |    4 -
 scrub/repair.c        |   16 ----
 scrub/repair.h        |    4 -
 scrub/rmap_repair.c   |    9 --
 scrub/rtrmap_repair.c |    9 --
 scrub/scrub.c         |    5 -
 xfs_attr_item.c       |    5 -
 xfs_discard.c         |   12 ---
 xfs_fsmap.c           |    4 -
 xfs_icache.c          |    5 -
 xfs_inode.c           |    5 -
 xfs_itable.c          |   18 ----
 xfs_iwalk.c           |   11 --
 xfs_log.c             |    6 -
 xfs_log_priv.h        |    4 -
 xfs_notify_failure.c  |    5 -
 xfs_qm.c              |   10 --
 xfs_rtalloc.c         |   13 ---
 xfs_trans.c           |  196 +++++++++++++++++++++++---------------------------
 xfs_trans.h           |    3 
 xfs_zone_gc.c         |    5 -
 30 files changed, 147 insertions(+), 254 deletions(-)
