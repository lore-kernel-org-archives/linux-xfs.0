Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D13366054;
	Mon, 21 Sep 2026 06:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789971394; cv=none; b=E+OS76CW/C2luu7+2BiCTDfWFkaDlG7UWNyiYMFD/tFBjLSL8Vvu4FMROrtG5o+jZyDesxGFNGs2PxONW6F+rY7mUJf3bAiWj9zGzmDezvTdxA/a8aGYtPvGkkq54cpdhgRRmI9HSgwuYmSimZ+fm1JFt+6y7W5UmrQU27WtAp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789971394; c=relaxed/simple;
	bh=zeK5Oo/zUMBFkg4eXNqE7zsNeiFXc+4SihYTh407y3A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PyAL5uM/42leWwZ79eZkmeKwDW/Bq6wC1UmW+7CTdwJ0T9AM2FEmt38OOJkFCOLglwjnXavZvCTMHxvvE1d3SDDSyH47FWjvoIjOuS2C3Xg/SCcUWkqN7hAE5wggtN9C4VzV86irm1wS4Tev+FgMZO/4eBBeM+dbJcveUllFe9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DHiq4grD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DHiq4grD"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 092F41F000FF;
	Mon, 21 Sep 2026 06:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789971393;
	bh=CtaTAm2gZRcqiYMQVcZRIQHCeYLs4E3QePbWRVnID8Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=DHiq4grD4BOEGcHXFdpqRv0gMHOWU/jdovZVX4CINnlCnpxh1rxvYoYfEkWsdAOru
	 buXt6qM/cSxeOXucUbrBl9bVHQSQjpsKVHqO1+I3P8NB4wgf4nVJ1jexZg5/NGFuMS
	 2jMtuTWDGyNA542HhB1sqkxGMWyDu543C8JivNicNcG6Sd3jz/cJugcyY4ofmve7ip
	 04NVQ5oZDc1oPrJM5DUO2kQFuCZddaicvoz9avu02XbA9wIqc/S9gOOnnPi72qoa/Y
	 /GVMQVpDxZw2dQPwNhBgX8m9u0Y++QnTIzXKiT2qbo++FCdowExmQ/X1hDmdhL33RE
	 5MY2v7w/KoREQ==
Date: Sun, 20 Sep 2026 23:16:32 -0700
Subject: [PATCH 06/14] xfs: fix xfs_rename_space_res for non-pptr filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178996120679.181988.11124162026436295653.stgit@frogsfrogsfrogs>
In-Reply-To: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

We don't need to reserve space for a parent pointer update for an
existing target if parent pointers are disabled.  Fix this regression
(which LOLLM noticed) so that rename reservations go back to what they
were before parent pointers.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 5a8338c88284df ("xfs: Add parent pointers to rename")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/libxfs/xfs_trans_space.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_trans_space.c b/fs/xfs/libxfs/xfs_trans_space.c
index c4cd547033e584..7edd0d86f0bdb2 100644
--- a/fs/xfs/libxfs/xfs_trans_space.c
+++ b/fs/xfs/libxfs/xfs_trans_space.c
@@ -127,10 +127,10 @@ xfs_rename_space_res(
 		if (has_whiteout)
 			ret += xfs_parent_calc_space_res(mp, src_namelen);
 		ret += 2 * xfs_parent_calc_space_res(mp, target_namelen);
+
+		if (target_exists)
+			ret += xfs_parent_calc_space_res(mp, target_namelen);
 	}
 
-	if (target_exists)
-		ret += xfs_parent_calc_space_res(mp, target_namelen);
-
 	return ret;
 }

