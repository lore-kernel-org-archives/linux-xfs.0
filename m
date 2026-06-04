Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CF2351C34
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 06:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780553202; cv=none; b=KH1VsKI2oyf+NDSIdCpJeYo2IWUp+06V2rknKFB4RsPc9kgVnstCF/+WZFUfszU/b6TjZ8+zDLNxGe3kh94khd0057Omb0ZvybFp8Ynpfq6ixUHAkfeug7B41VRiHvFd3e12PsfmDQApxwU6/8u4Fvvb/Dzc9uOlYGU69j8x50s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780553202; c=relaxed/simple;
	bh=kVO/U0Lw1ijuDyOCN+SqP/GrVVEZ2c9R7IAwSj4lW9k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y3v5WfXWfU96NjPdC48v3RlOXMFPFDfRKwPJhecHb/f/77tU33vekiOph191g9mt7ieSZtguNkS0UojZ/xj8PuWWa6Q0yn73thpqqfewdIt2O5LhuzUzSCI0pPRHi7vvBNutgjjKxqU9LZ6+CNqHp1pi7F5/Q6qw+a54jAeGPNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HiEkSI9n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HiEkSI9n"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3CD5A1F00893;
	Thu,  4 Jun 2026 06:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780553201;
	bh=35gexlYb1v5dy6wWNWYKxIT81fBNjhvXHNWwIeggink=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=HiEkSI9nzf7/kXwsmKKOvIbQzwjpb0srbvh/TnFDCf4Bywc7ODGmsMBfO951h8Hrw
	 /gtW3rLydMoYy5JSK78LhiQK7lrwwEThgyfw4DdS1I1csdtBj3tWbneRzB4b30phpZ
	 z3kRXjmwp5c0+VndOd53g/Q6ZiZ8tko6vJoIhkZaOAr3TwNs5LjYJiMPYd7vhTRjZp
	 JHNOvC7jhP37TgCBCXbD7Tqta+Tgvo1l1WoHGRlmmixrOiEwVBMD162GA/PW45IWOU
	 ytNhvAe4amhpXfqu8VH2tD6glPkxS3s2roCSN+dDtABT9IrTx7+W6zrZZ4oNDaDpjP
	 My2JiWZE8LEBg==
Date: Wed, 03 Jun 2026 23:06:40 -0700
Subject: [PATCH 09/21] xfs_scrub: fix work estimation for rtgroups filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178055303275.2608728.8921400065325146466.stgit@frogsfrogsfrogs>
In-Reply-To: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex noticed that phase2_func queues up scrub work items for every
rtgroup in the system and tracks progress towards that number of work
items, but that it doesn't include the rtgroups in the estimate.  This
leads to the user-papercut of the progressbar quickly advancing to 100%
and then wedging there for most of the rt metadata scan.  Let's fix this
by amending the group estimator function.

Cc: <linux-xfs@vger.kernel.org> # v6.13.0
Fixes: 241d915d69d4ae ("xfs_scrub: scrub realtime allocation group metadata")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/xfs_scrub.h |    2 +-
 scrub/phase2.c    |    2 +-
 scrub/scrub.c     |   15 +++++++++++++--
 3 files changed, 15 insertions(+), 4 deletions(-)


diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 851b4f37db48e4..ce98693a674d9d 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -131,7 +131,7 @@ int phase7_func(struct scrub_ctx *ctx);
 int phase8_func(struct scrub_ctx *ctx);
 
 /* Progress estimator functions */
-unsigned int scrub_estimate_ag_work(struct scrub_ctx *ctx);
+unsigned int scrub_estimate_group_work(struct scrub_ctx *ctx);
 unsigned int scrub_estimate_iscan_work(struct scrub_ctx *ctx);
 int phase2_estimate(struct scrub_ctx *ctx, uint64_t *items,
 		    unsigned int *nr_threads, int *rshift);
diff --git a/scrub/phase2.c b/scrub/phase2.c
index c7828c332e7c3a..8de77429f05d60 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -416,7 +416,7 @@ phase2_estimate(
 	unsigned int		*nr_threads,
 	int			*rshift)
 {
-	*items = scrub_estimate_ag_work(ctx);
+	*items = scrub_estimate_group_work(ctx);
 	*nr_threads = scrub_nproc(ctx);
 	*rshift = 0;
 	return 0;
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 12ed87f07d9f6c..c9b75eb041e460 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -534,9 +534,9 @@ scrub_item_check_file(
 	return 0;
 }
 
-/* How many items do we have to check? */
+/* How many items do we have to check for per-AG and per-rtgroup work? */
 unsigned int
-scrub_estimate_ag_work(
+scrub_estimate_group_work(
 	struct scrub_ctx		*ctx)
 {
 	const struct xfrog_scrub_descr	*sc;
@@ -553,10 +553,21 @@ scrub_estimate_ag_work(
 		case XFROG_SCRUB_GROUP_FS:
 			estimate++;
 			break;
+		case XFROG_SCRUB_GROUP_RTGROUP:
+			/*
+			 * rtbitmap and rtsummary exist on non-rt/non-rtgroup
+			 * filesystems, but we schedule the other rtgroup
+			 * metadata for scanning (even if it won't do
+			 * anything), so we must include those in the
+			 * estimation as well.
+			 */
+			estimate += max(1, ctx->mnt.fsgeom.rgcount);
+			break;
 		default:
 			break;
 		}
 	}
+
 	return estimate;
 }
 

