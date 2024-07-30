Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C5E524C
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301406; cv=none; b=U5Z3vl7ZNVoO1kmA7cfeLEISfuMUOgkcNmT3N0R1LrJq2qOVy769sInSw3j8zvTBdOo/EQpuVeEu2491v5oeyH/EJD7PfC9zC1tnFbtcyDNcCC13QPbV2geMBvapIWDGRX9o41/nz0MEOdkqhuzk/8J16WesSJoYHGkhNb1fI5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301406; c=relaxed/simple;
	bh=+6hfvFZHT7WBFE7UewV9jilXtWwXH+0qde6NcpIVb9c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YKFFvU/+bAmm+glYPniFEKB+GrYsSmdIkNhm67BEsij4SIncWn2Wl8ogSFzdC+lv96xdHH1e6aklCPJrYxMOG0mxLq0+s9DqlfwdL5BUzplVxsNv228ubL4PKKTwrnDEgXLmdJ/wBuIIP1Ne+x9qKTBNgpwyv8iffXlAI1Gt9Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k4PDxnC0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k4PDxnC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460EBC32786;
	Tue, 30 Jul 2024 01:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301406;
	bh=+6hfvFZHT7WBFE7UewV9jilXtWwXH+0qde6NcpIVb9c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=k4PDxnC07TZwT+5KMG2SVmB98lAOPbNWjfyzMo0OlrhIz8VwKQ9wyWCSggRT3Aojh
	 PJYjqe06rJt5/kzEZizy9Xxf/qXULpLsQYp4cQnavMRbID/dKh8nmL6eA39OWnCtwm
	 3EiFLfP+DQz+Tq6Bt4dcDntDPO0DiPeQP3/7SxeNsG8fi4irm0cwmgOZ7rTGDf7jrP
	 qOXHc73S1m5J8PJfL3xzCOlLnZR/cumOJoJ0W9raiAac0VxfDY1QVrPLHPik3UbHob
	 i8c3Qlz1nIDW/gR/rKy9Ep3J8TJcDJO/nNeIDzQJU3j3dn0adiAPcty9pTzO0LDe+4
	 FfMC5XRYfO3aw==
Date: Mon, 29 Jul 2024 18:03:25 -0700
Subject: [PATCH 9/9] xfs_scrub: remove unused action_list fields
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229846477.1348067.7935419297237787757.stgit@frogsfrogsfrogs>
In-Reply-To: <172229846343.1348067.12285575950038094861.stgit@frogsfrogsfrogs>
References: <172229846343.1348067.12285575950038094861.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/repair.c |    5 -----
 scrub/repair.h |    2 --
 2 files changed, 7 deletions(-)


diff --git a/scrub/repair.c b/scrub/repair.c
index 2b863bb41..a3a8fb311 100644
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
index 463a3f9bf..a38cdd5e6 100644
--- a/scrub/repair.h
+++ b/scrub/repair.h
@@ -8,8 +8,6 @@
 
 struct action_list {
 	struct list_head	list;
-	unsigned long long	nr;
-	bool			sorted;
 };
 
 struct action_item;

