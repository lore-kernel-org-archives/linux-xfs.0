Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CF11F667B;
	Tue,  5 Nov 2024 22:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844249; cv=none; b=Z3tbtRxqYyndK3LlKQzUa/hxe89suDpTzU9JR8glchPnTpTnU0rXDnKASBKySq6Yj/Z3GY+XuK7uJmgcE7WqSt58/+9MCgAgEZ7nrDbQT1HRiugX3pt3S9j7d6FhHBXScxuKpwlTxyqJ5PrVprkIYkZPbD33hfKN9B+rZC5BK7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844249; c=relaxed/simple;
	bh=TfFlfPMcy9z+1qeKYUsFwqpLE/B879o42/Qv09i/U4w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CvM/JX4kkZWRvUbEl99exeDZW01b6wvT9thwGFxWYqNqiywWfhFjptaLX/Hztyku16j9hKBT4MfIW/Y/+8kl1Em1Exe38dCEtG605go8uJQMTKEBfOeugo061R0Am+jNalFZ/Wf5CC9iSMUT+7RVSYqq170qfeo+sm/XSkXQaJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G4FA0CfV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G4FA0CfV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11AFC4CECF;
	Tue,  5 Nov 2024 22:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844248;
	bh=TfFlfPMcy9z+1qeKYUsFwqpLE/B879o42/Qv09i/U4w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=G4FA0CfVBoma12pn0ThcLfBRSS6mGmM3L4xuKT0CKYmXJ3mL3f/vIuJxJVVsuukXj
	 sRSWWARoNLH0m6Efvn98kyo8XpXbPJqaxUoIID4xRsDhGc7kvdAPXByo4CZozufQb7
	 tCIjEf+2VqXeukFYojpJ2ktQK+x9IWdlMO/6IM28tOSEbDNbOj9HoNDmrCuE0bs1dt
	 HjooPjFywy2995jQ71nGcmqnws9Zns90N5TcelnJDBELv2/bK4gxg7Dev55HZ2m6Db
	 tSbkwUg+7smYuh5AjfCwn1f7lUSHqOzfhASXM5H19GBXuyeAYoMMSHwhh+e+0os48y
	 GWMN+wePKmCCA==
Date: Tue, 05 Nov 2024 14:04:08 -0800
Subject: [PATCHSET v5.5 01/10] xfs: convert perag to use xarrays
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173084394391.1868694.10289808022146677978.stgit@frogsfrogsfrogs>
In-Reply-To: <20241105215840.GK2386201@frogsfrogsfrogs>
References: <20241105215840.GK2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Convert the xfs_mount perag tree to use an xarray instead of a radix
tree.  There should be no functional changes here.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=perag-xarray-6.13
---
Commits in this patchset:
 * xfs: fix simplify extent lookup in xfs_can_free_eofblocks
 * xfs: fix superfluous clearing of info->low in __xfs_getfsmap_datadev
 * xfs: remove the unused pagb_count field in struct xfs_perag
 * xfs: remove the unused pag_active_wq field in struct xfs_perag
 * xfs: pass a pag to xfs_difree_inode_chunk
 * xfs: remove the agno argument to xfs_free_ag_extent
 * xfs: add xfs_agbno_to_fsb and xfs_agbno_to_daddr helpers
 * xfs: add a xfs_agino_to_ino helper
 * xfs: pass a pag to xfs_extent_busy_{search,reuse}
 * xfs: keep a reference to the pag for busy extents
 * xfs: remove the mount field from struct xfs_busy_extents
 * xfs: remove the unused trace_xfs_iwalk_ag trace point
 * xfs: remove the unused xrep_bmap_walk_rmap trace point
 * xfs: constify pag arguments to trace points
 * xfs: pass a perag structure to the xfs_ag_resv_init_error trace point
 * xfs: pass objects to the xfs_irec_merge_{pre,post} trace points
 * xfs: pass the iunlink item to the xfs_iunlink_update_dinode trace point
 * xfs: pass objects to the xrep_ibt_walk_rmap tracepoint
 * xfs: pass the pag to the trace_xrep_calc_ag_resblks{,_btsize} trace points
 * xfs: pass the pag to the xrep_newbt_extent_class tracepoints
 * xfs: convert remaining trace points to pass pag structures
 * xfs: split xfs_initialize_perag
 * xfs: insert the pag structures into the xarray later
---
 fs/xfs/libxfs/xfs_ag.c             |  135 ++++++++++++++-----------
 fs/xfs/libxfs/xfs_ag.h             |   30 +++++-
 fs/xfs/libxfs/xfs_ag_resv.c        |    3 -
 fs/xfs/libxfs/xfs_alloc.c          |   32 +++---
 fs/xfs/libxfs/xfs_alloc.h          |    5 -
 fs/xfs/libxfs/xfs_alloc_btree.c    |    2 
 fs/xfs/libxfs/xfs_btree.c          |    7 +
 fs/xfs/libxfs/xfs_ialloc.c         |   67 ++++++-------
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    2 
 fs/xfs/libxfs/xfs_inode_util.c     |    4 -
 fs/xfs/libxfs/xfs_refcount.c       |   11 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |    3 -
 fs/xfs/libxfs/xfs_rmap_btree.c     |    2 
 fs/xfs/scrub/agheader_repair.c     |   16 +--
 fs/xfs/scrub/alloc_repair.c        |   10 +-
 fs/xfs/scrub/bmap.c                |    5 -
 fs/xfs/scrub/bmap_repair.c         |    4 -
 fs/xfs/scrub/common.c              |    2 
 fs/xfs/scrub/cow_repair.c          |   18 +--
 fs/xfs/scrub/ialloc.c              |    8 +-
 fs/xfs/scrub/ialloc_repair.c       |   25 ++---
 fs/xfs/scrub/newbt.c               |   46 ++++-----
 fs/xfs/scrub/reap.c                |    8 +-
 fs/xfs/scrub/refcount_repair.c     |    5 -
 fs/xfs/scrub/repair.c              |   13 +-
 fs/xfs/scrub/rmap_repair.c         |    9 +-
 fs/xfs/scrub/trace.h               |  161 ++++++++++++++----------------
 fs/xfs/xfs_bmap_util.c             |    8 +-
 fs/xfs/xfs_buf_item_recover.c      |    5 -
 fs/xfs/xfs_discard.c               |   20 ++--
 fs/xfs/xfs_extent_busy.c           |   31 ++----
 fs/xfs/xfs_extent_busy.h           |   14 +--
 fs/xfs/xfs_extfree_item.c          |    4 -
 fs/xfs/xfs_filestream.c            |    5 -
 fs/xfs/xfs_fsmap.c                 |   25 ++---
 fs/xfs/xfs_health.c                |    8 +-
 fs/xfs/xfs_inode.c                 |    5 -
 fs/xfs/xfs_iunlink_item.c          |   13 +-
 fs/xfs/xfs_iwalk.c                 |   17 ++-
 fs/xfs/xfs_log_cil.c               |    3 -
 fs/xfs/xfs_log_recover.c           |    5 -
 fs/xfs/xfs_trace.c                 |    1 
 fs/xfs/xfs_trace.h                 |  191 +++++++++++++++---------------------
 fs/xfs/xfs_trans.c                 |    2 
 44 files changed, 459 insertions(+), 531 deletions(-)

