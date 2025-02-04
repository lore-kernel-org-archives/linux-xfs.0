Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCFF25A62C;
	Tue,  4 Feb 2025 21:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704263; cv=none; b=LfH0uldciYTu+VdRDNj1XawVkU07O86JgcXx0EG2er9LbtWUojWi2FX4zgsZZOXS6lp+rlovpghPFBDs6LcrKe4myrdwSsdSv8aOEbi8g03ePF550K2u8s3eVVkAcTR5SMAIYvk/g5fdQOuPCqL6ffH/zqPYNddvkcIFGocak6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704263; c=relaxed/simple;
	bh=TU+b8xnNHHQDCl8mXZVwDmk7NrFQje3B92kBrjzEyBA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ox7s0Ix6xhRIfBj6VwCG1spOxJp5zY2REeFM9hG6AeUltwgn5+1LXeVobworHGhoRS7t2fI0ghVq4shM+EUO5ZuCsjHgEzBN25W1Vf0Ii8hP+D1jhakzji0tRyo4R3xlF8RaKtzZFO+B020MUGgFO9I6KmtEleVxpz9on6IT7bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kJ369szr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kJ369szr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B0AC4CEDF;
	Tue,  4 Feb 2025 21:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704263;
	bh=TU+b8xnNHHQDCl8mXZVwDmk7NrFQje3B92kBrjzEyBA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kJ369szrhveygTc+bIQV1Ss2Noy9LSpEWzz+UBuPdOKiyU5T3XryVlkqYqPLvhpXt
	 wYWKkfU16RuRYygYYH/YeDW51QvNehfbB5o3vhYe6+KBXC0/xH0bEIYoG5UE/87tHu
	 uKtim1p2nYBWewpib4xGSK+W5mk6CHfN79qrWbdXM45weyS2vEbBZuxNCDRVPUWQKm
	 +QjmHUT7SaemLKlGXzOy/Ml/5XMJ0J6CYIQH0Q8cmQVNtjvHdVPRmpUoFPhow2J1sB
	 hAaqqZvAGdITzyvLOLZmHCTEs3Z3VfvGywMMpx69hD9LrL4GQw1oVWjqLwR/6iFUkz
	 +CkMaH8FFO9+g==
Date: Tue, 04 Feb 2025 13:24:22 -0800
Subject: [PATCH 08/34] common/populate: correct the parent pointer name
 creation formulae
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173870406230.546134.368446131039029732.stgit@frogsfrogsfrogs>
In-Reply-To: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The formulae used to compute the number of parent pointers that we have
to create in a child file in order to generate a particular xattr
structure are not even close to correct -- the first one needs a bit of
adjustment, but the second one is way off and creates far too many
files.

Fix the computation, and document where the magic numbers come from.

Cc: <fstests@vger.kernel.org> # v2024.06.27
Fixes: 0c02207d61af9a ("populate: create hardlinks for parent pointers")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/populate |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)


diff --git a/common/populate b/common/populate
index 4cf9c0691956a3..c907e04efd0ea9 100644
--- a/common/populate
+++ b/common/populate
@@ -473,13 +473,18 @@ _scratch_xfs_populate() {
 		__populate_create_dir "${SCRATCH_MNT}/PPTRS" 1 '' \
 			--hardlink --format "two_%d"
 
-		# Create one xattr leaf block of parent pointers
-		nr="$((blksz * 2 / 16))"
+		# Create one xattr leaf block of parent pointers.  The name is
+		# 8 bytes and, the handle is 12 bytes, which rounds up to 24
+		# bytes per record, plus xattr structure overhead.
+		nr="$((blksz / 24))"
 		__populate_create_dir "${SCRATCH_MNT}/PPTRS" ${nr} '' \
 			--hardlink --format "many%04d"
 
-		# Create multiple xattr leaf blocks of large parent pointers
-		nr="$((blksz * 16 / 16))"
+		# Create multiple xattr leaf blocks of large parent pointers.
+		# The name is 256 bytes and the handle is 12 bytes, which
+		# rounds up to 272 bytes per record, plus xattr structure
+		# overhead.
+		nr="$((blksz * 2 / 272))"
 		__populate_create_dir "${SCRATCH_MNT}/PPTRS" ${nr} '' \
 			--hardlink --format "y%0254d"
 

