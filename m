Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D706D155757;
	Wed,  2 Sep 2026 05:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327878; cv=none; b=kEbVR4iDoBbR91uwpp6jm0G0MVDLnB40rzpoYIsaTAo3UXE+ySBLW40MrZgRaCFyK7zlwnmq56Jw6FUT0OTM9++p1jw9sBtVpEJOtt1dUyG0w/X98Z1Flo4rWArwneMz3dt1SEiUp+eD+8FP8XOkTKksarL1m35E4ny4gvR4nFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327878; c=relaxed/simple;
	bh=EKDqrG4cMvfL4A7QxyjKtKZfvoP87yln10Rr1RBCaPE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BrFvWjZKBYrziXgX2aMA7uhojkM28kzS/7Z5hrxJzMEcKtpOMJaHgH6S61yqk4lYfvUaV2tySJ9cqXcT/aMbMyxSL0lbud0axd7Ky8mb86rw33OHINKt3KnZWGCJWANCR0AHEy5qoYYgQkh1EOZt0o1y6xgU20HOVo9tVefLd5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DBR6z6hG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DBR6z6hG"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 66F301F000E9;
	Wed,  2 Sep 2026 05:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788327877;
	bh=YRAhDbqgjFS729UnL5NQtqa0LG7eZEiJaHLuhcDK4s4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=DBR6z6hGqxT/7BzjYhNuNdQ1Etok889dYxpHActnH8GpRE1v7RlV9jBSeADCuc2b5
	 T/ylPWuaf2Nn60RArvaJtZCwSWB09KNkjsaYSopKm8iI9WsrhTJdhndt+Y1Kx+XiK/
	 KcK7cTKwRowSONBIir9C2bBUhauAZxSsZJZOkm6yvYT8UFBBmhBS1toY5aUZ1lrype
	 ltYZp3+szSlShPQ+AE/JvDP/xRwHrFMrJ3SyTpG5+W3wfFvMaAE9ccDd9bi8HIOhYh
	 p/fNA8k2//JLMLo1PtzSIdrvFDkhZDar29/M79Eqrn6Av7tPsrqZVEQzCV7ekHEbPr
	 gYukNZVuOeylA==
Date: Tue, 01 Sep 2026 22:44:37 -0700
Subject: [PATCH 5/6] xfs: don't modify file attributes or poke fsnotify for
 dry runs
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832749528.3507209.11787129781318331688.stgit@frogsfrogsfrogs>
In-Reply-To: <178832749387.3507209.8650516312948237987.stgit@frogsfrogsfrogs>
References: <178832749387.3507209.8650516312948237987.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

I noticed that we shouldn't be removing file privileges when doing a dry
run of an exchange-range operation.  LOLLM also points out that a dry
run shouldn't poke fsnotify because we don't actually change the files.
Fix both by gating them on !DRY_RUN.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 42672471f938cd ("xfs: bind together the front and back ends of the file range exchange code")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/xfs_exchrange.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
index 94965a6c2187ff..c69ecd6a19de4f 100644
--- a/fs/xfs/xfs_exchrange.c
+++ b/fs/xfs/xfs_exchrange.c
@@ -504,6 +504,9 @@ xfs_exchange_range_finish(
 {
 	int			error;
 
+	if (fxr->flags & XFS_EXCHANGE_RANGE_DRY_RUN)
+		return 0;
+
 	error = file_remove_privs(fxr->file1);
 	if (error)
 		return error;
@@ -783,9 +786,12 @@ xfs_exchange_range(
 	if (ret)
 		return ret;
 
-	fsnotify_modify(fxr->file1);
-	if (fxr->file2 != fxr->file1)
-		fsnotify_modify(fxr->file2);
+	if (!(fxr->flags & XFS_EXCHANGE_RANGE_DRY_RUN)) {
+		fsnotify_modify(fxr->file1);
+		if (fxr->file2 != fxr->file1)
+			fsnotify_modify(fxr->file2);
+	}
+
 	return 0;
 }
 

