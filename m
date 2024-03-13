Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD49A79C5
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295533; cv=none; b=aT3RWuFF9oAqcdUYid3idmuVnjwv2XlBPVwddCuqyFIFA8Muviu72TF1rgXuIjnsjcfjDiEjbTlhS5mT9sEMk5cIwtREyBWreHnrfIHPBPrnAkxeX00ggVcU9rMj7GnoOuBTBNL6y0Wd/sqg897sXp2f+lbnlLMKId4Pu93LIMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295533; c=relaxed/simple;
	bh=YU7nz1stGlg5S8IZ8DrTLoVx1RAyf+WBmNkbFhPzwNo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=erXTIJKrgrMNvbLMl9irQ+PHuydCL24CgM07UWBH6OBCjMB4QqIS7pvOgqBv4zRklfe83PG5HunZSdpLbvQv/mYlOuQx2QNKxdDBxkUTetuAJFe+b07TffrcgixOzraKQD6VtV/ecM5/EPRgtFJsw6W1CST1au3u0+5vkprK55M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hOyqQnBT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hOyqQnBT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70506C433F1;
	Wed, 13 Mar 2024 02:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295533;
	bh=YU7nz1stGlg5S8IZ8DrTLoVx1RAyf+WBmNkbFhPzwNo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hOyqQnBTH9pc+GYopMiDWpKijrEWsUt6x7hIbHzItiL2c+ppu76boxaxSXMG9yk7B
	 9XnnsIrkJPpxdgZvjW++WuDp5/6kD129MPG/2ga0JDnzC5DoyPKImR+s/fUwdmw0wX
	 uGJshWGXt/pmoEfQTq8+ACTmuu+harlCXr130A8lvPYwD+1KGoU1bal+UdQnq07M0d
	 atjmkN1MJr4lXy9uwVkU2PuDo37tji07ROOHRmyxoOflQVTnVcfsFBNWT1nELz22ll
	 PVEM2HVCU7pDzhiBLOCA3tPC3tx4eRG77VZRXSdaBipyVQzfN2oul5rDnOEIMSV7om
	 Pt28eAEVtDaAw==
Date: Tue, 12 Mar 2024 19:05:33 -0700
Subject: [PATCH 48/67] xfs: return -ENOSPC from xfs_rtallocate_*
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <171029431886.2061787.10702090808474301367.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: ce42b5d37527b282d38413c1b5f7283253f6562d

Just return -ENOSPC instead of returning 0 and setting the return rt
extent number to NULLRTEXTNO.  This is turn removes all users of
NULLRTEXTNO, so remove that as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_types.h |    1 -
 1 file changed, 1 deletion(-)


diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 035bf703d719..20b5375f2d9c 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -51,7 +51,6 @@ typedef void *		xfs_failaddr_t;
 #define	NULLRFSBLOCK	((xfs_rfsblock_t)-1)
 #define	NULLRTBLOCK	((xfs_rtblock_t)-1)
 #define	NULLFILEOFF	((xfs_fileoff_t)-1)
-#define	NULLRTEXTNO	((xfs_rtxnum_t)-1)
 
 #define	NULLAGBLOCK	((xfs_agblock_t)-1)
 #define	NULLAGNUMBER	((xfs_agnumber_t)-1)

