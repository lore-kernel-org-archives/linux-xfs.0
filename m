Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE588C13B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X0o9Yc/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D103C433C8;
	Sun, 31 Dec 2023 22:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062562;
	bh=2FkJ3HvnyNmiDp35GmWSvYVVayTVtwQ6IhctgNtAXac=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=X0o9Yc/evHjzIbCCSn867AE3H02HKl5YPozPZyJjRVh8A0Ds4ticqn1ugctvYD2VD
	 CHr1URXu8p5Qcz8B7a3tG3wTJiab0I5pPBcwUevTSvO/SuZKaRkXLGkIzBeA8kGgrc
	 eVxT8LSXKER8yY9fNvanc42xHLZQuFdYJBH5BgX4AsUz5idRxWoJlM+XZK7XmDFOhn
	 bFwB6ZvM2q926I21qqdr6KN6UQQToYZmKnr844rWc9lSn6SrbOWOrYzGk+8ovG5oX7
	 nF4kun90u/Q+HZuWPBp6guw1EkegOKlIWzsYv4VmpTrcMn6HrpBZbR5H2s08va04d5
	 SSc5LHljhqZmQ==
Date: Sun, 31 Dec 2023 14:42:42 -0800
Subject: [PATCH 9/9] xfs_scrub: remove unused action_list fields
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404999565.1797790.5249264048650632926.stgit@frogsfrogsfrogs>
In-Reply-To: <170404999439.1797790.8016278650267736019.stgit@frogsfrogsfrogs>
References: <170404999439.1797790.8016278650267736019.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Remove some fields since we don't need them anymore.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/repair.c |    5 -----
 scrub/repair.h |    2 --
 2 files changed, 7 deletions(-)


diff --git a/scrub/repair.c b/scrub/repair.c
index 2b863bb4195..a3a8fb311d0 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -432,7 +432,6 @@ action_list_discard(
 	struct action_item		*n;
 
 	list_for_each_entry_safe(aitem, n, &alist->list, list) {
-		alist->nr--;
 		list_del(&aitem->list);
 		free(aitem);
 	}
@@ -453,8 +452,6 @@ action_list_init(
 	struct action_list		*alist)
 {
 	INIT_LIST_HEAD(&alist->list);
-	alist->nr = 0;
-	alist->sorted = false;
 }
 
 /* Number of pending repairs in this list. */
@@ -478,8 +475,6 @@ action_list_add(
 	struct action_item		*aitem)
 {
 	list_add_tail(&aitem->list, &alist->list);
-	alist->nr++;
-	alist->sorted = false;
 }
 
 /* Repair everything on this list. */
diff --git a/scrub/repair.h b/scrub/repair.h
index 463a3f9bfef..a38cdd5e6df 100644
--- a/scrub/repair.h
+++ b/scrub/repair.h
@@ -8,8 +8,6 @@
 
 struct action_list {
 	struct list_head	list;
-	unsigned long long	nr;
-	bool			sorted;
 };
 
 struct action_item;

