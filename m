Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E01223DFA
	for <linux-xfs@vger.kernel.org>; Mon,  2 Jun 2025 17:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748885747; cv=none; b=KQnDwTr+Y4DkXYAxBM/VPvF8zEnTPPGGCO1d6bFPxGmN854FC4mCExVu64AP4JVJUfke6rVmIAByq/OuwarjIpzNbAy67S6f2uNsiDKoWKlNn0HY66H6WthnmiGzjcXeFz6NQwVqCuR8M97gJb6MymHkkgKaKYelIn6z0+Xz3aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748885747; c=relaxed/simple;
	bh=xuBs6ePmaJCXM2Ls53Vq0dsWeZqieGQ4WQWqse3Mtm8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Sy34DYaIoAH6sYHKJ5OWOVBXIAr9EZBlI2EAmVvjJ2H/F/6r7Vls6oMrlpJcCXf5dyNN8NTp6aP36GUT7RqT69gAPcFYGK26SDMa51H83UielXoMZZxEx/NTefZgQoDzn/rFj/ohvbiXcoIPPzlBurhjj+z4Mv3NO+wbZYsX6GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O5gWtdK8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O5gWtdK8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748885744;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=6qXYLmXokt8hHtu0ywrcR1knABCIz12pVqsAqy0jAlg=;
	b=O5gWtdK8JGrqRU2GCqEbDWPoHbdrILM75w2s0TDE73s69n9xhaQxCcJCdTITdWoQ51rg7x
	MwWc7zKWiLTJgV1m2/M44ai3ql4Ll+tzq6piA7IVIsdokbKGfhbtN6q4X1Ok8wLL8gA+Vv
	dBJhedfiAjQY664O/Su+ZrOuWJFdvco=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-yZ9nl-XHOsCmvlJtp7Ps7g-1; Mon, 02 Jun 2025 13:35:43 -0400
X-MC-Unique: yZ9nl-XHOsCmvlJtp7Ps7g-1
X-Mimecast-MFC-AGG-ID: yZ9nl-XHOsCmvlJtp7Ps7g_1748885742
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-450eaae2934so17544405e9.2
        for <linux-xfs@vger.kernel.org>; Mon, 02 Jun 2025 10:35:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748885742; x=1749490542;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6qXYLmXokt8hHtu0ywrcR1knABCIz12pVqsAqy0jAlg=;
        b=VThii5DWoIWLFdDsyvhNLOwVw7WxKfd64J8dOQppYTqf0XHndk0MZGcw8NrwCyVFAd
         5F/FOYOeqpqbTAZPhaSTtGEgSgQddVhqgrPNQEsn7pJEC2r/5+z5ZcWhKZfWUbIWkKjl
         xapN74SzZhTymSzxLLP6Jakm4eVJfOYlEiNckVAbWaiXBQNbtMA/fjuxLYhi4gQOCeKa
         E3ZcEZGf5ZJy/HKBdFd8xYFJ5M9nxmkaMZIdxZ+oBHE5OKIJy5AS4dsHUqXJ+cI5rf5y
         e6cnEvyf4iqWU3SEwYNQsKOpnt10yhpAfGva+nIKR0LmsSU27j6iAIKeskOY3VlXvsaJ
         rkrw==
X-Gm-Message-State: AOJu0Yx/7Khe5ATK/X7YPR4UQXhHJpgLocOwiUSVCd4N9/kHebcnXn10
	j55GzMR5LhRH5QvGwc3yUiVR5Xb3O6HWr1webugZ3jVghZpt6NSVXhD2EjCRCFk7Mr8GqHGLzJs
	2t5UA0VjzpSIFDNpv09PpDjH3kSBa1in+ZsVqC+GvBvf30Hs376+7W5wVq1grdFXJONXjTS3I+a
	Hs8Vg4RO6IB3zPOj0EFfF+nCfkQsSQCWEywY1I5YNIzdHm
X-Gm-Gg: ASbGnctsBbkrjqsC//IjTHL6+8QHWqXyP3oZuYYaroC2j7okg8Qt9vvbkopRtoDwGvZ
	SI/syf8v5Kx7tfC69dpK0mOVYpJfCbfhgadiHcKpFYibK423td6eyyJX2XFi36ntM2U6YihYC7f
	lz/1cm/Uxez3hPK4anlQHsQIQTdBoBhUmhJ+I5FIWe69Vx/g1VEYjHoZvhS2MgGdbu+/fctH/l2
	2wh57uTKCM1HUBve6orW9sAcrgCQwjlasGMIdy2S4QEalJJZkjIFIal+/7gBDNRTi/G7HMg00HF
	10Iv8FV5X/4pjCawdZTBB/2rLMMwLTc=
X-Received: by 2002:a05:600c:3147:b0:43d:b85:1831 with SMTP id 5b1f17b1804b1-450d8757eb5mr142091565e9.0.1748885741658;
        Mon, 02 Jun 2025 10:35:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGOJxRSwvE5pTlkBCjLE39tE/e7bKJBqKTbccCQcSdT20+8JRG5LwRhe3kQOQtxhL8Zf6bvvA==
X-Received: by 2002:a05:600c:3147:b0:43d:b85:1831 with SMTP id 5b1f17b1804b1-450d8757eb5mr142091175e9.0.1748885741138;
        Mon, 02 Jun 2025 10:35:41 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450d8000d8csm130541075e9.24.2025.06.02.10.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jun 2025 10:35:40 -0700 (PDT)
Date: Mon, 2 Jun 2025 19:35:40 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, dchinner@redhat.com, 
	djwong@kernel.org, hch@lst.de, john.g.garry@oracle.com, luca.dimaio1@gmail.com
Subject: [ANNOUNCE] xfsprogs: for-next updated to 1bee63ac33e4
Message-ID: <iemcmozjpgs2uaoygd3xtrah2wi7x2smhlmvsgl2mejymvxlao@pmo4xj3ns2wi>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs for-next branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the for-next branch is commit:

1bee63ac33e4ddfcc7f443d9b8f507d49cab4948

New commits:

Christoph Hellwig (3):
      [94ef61b5bba0] xfs: kill XBF_UNMAPPED
      [9a6b49d23aaf] xfs: remove the flags argument to xfs_buf_get_uncached
      [1bee63ac33e4] xfs_mdrestore: don't allow restoring onto zoned block devices

Darrick J. Wong (1):
      [ec9909785b86] man: adjust description of the statx manpage

Luca Di Maio (1):
      [6b66b1ab513f] xfs_protofile: fix permission octet when suid/guid is set

Code Diffstat:

 libxfs/libxfs_io.h        | 2 +-
 libxfs/libxfs_priv.h      | 1 -
 libxfs/rdwr.c             | 1 -
 libxfs/xfs_ag.c           | 2 +-
 libxfs/xfs_ialloc.c       | 2 +-
 libxfs/xfs_inode_buf.c    | 2 +-
 libxlog/xfs_log_recover.c | 2 +-
 man/man8/xfs_io.8         | 4 +++-
 mdrestore/xfs_mdrestore.c | 8 ++++++++
 mkfs/xfs_mkfs.c           | 4 ++--
 mkfs/xfs_protofile.py.in  | 4 +++-
 repair/rt.c               | 2 +-
 12 files changed, 22 insertions(+), 12 deletions(-)

-- 
- Andrey

