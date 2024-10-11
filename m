Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E30101E6;
	Fri, 11 Oct 2024 01:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728611047; cv=none; b=hPfQRofKlonZFqWvdt47ywLRTyl+0PNqBEvKxkK58tqWfSQJ3C3bg2ZbENw6Sh0HckxF4WmWjflQGWen74IV5e3ugYS00zz+MnwTcF0k2FYAeSAsDLrTFmbRyUPl7uUD2DVAfGggOVnNlY/ubLgVtAwfqfPAamQi4JuNkdL0lsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728611047; c=relaxed/simple;
	bh=qYOvriPxveYS8BygKNW1NCBQL36uoNPYxVsnUN70fhk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=erb9Q1tgr5pwkpfoA9OxgjfcA58M3XtfU8Dq3dszecmBAvM9AsdemZSAJkWnUScBZAMxrhYNEQDjCw1pWyWpoYJdHYYHi9XH9dWj60kZZOk4osFN0rCPV5l1QlAtTqoDApzOtbsEFRDEhudtLZTVI0zLUzLbFmYadFRckFuPjXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oOUD4GW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oOUD4GW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B35C4CEC5;
	Fri, 11 Oct 2024 01:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728611046;
	bh=qYOvriPxveYS8BygKNW1NCBQL36uoNPYxVsnUN70fhk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oOUD4GW6OEV3FbqE50dlx7Wu/BNACawaAU2F4erVlXOB1TPfGhJXd6HuIHxIjePno
	 /pbV8cY3adRl/YsgQgHtp1xIDY4oU8+CkdkcXwR7NLBQyZ4Zx4RzZjxiUTdHsCgrFJ
	 zlQifNKAZJ3INTuZhP0uEB/ehxRrbHD6/GUO4E4YStlqEYVf+nzc9yHODCygoLRAWs
	 Kl03tqvnDQrNJ9o5IrTJvMrgblKrhenwQdnHL1nIJ1aeHj6YJjRq8sdXy3+4uLqgB8
	 MOAi7hn8XbmtFUrh2h3RrfNDZ8LIrNfh9Wq44lYK2hteQYfzkkciPEV7L8hDGYpkMJ
	 XwWXV7B1hOu3Q==
Date: Thu, 10 Oct 2024 18:44:06 -0700
Subject: [PATCH 12/16] xfs/122: update for rtbitmap headers
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860658703.4188964.12482205486731778269.stgit@frogsfrogsfrogs>
In-Reply-To: <172860658506.4188964.2073353321745959286.stgit@frogsfrogsfrogs>
References: <172860658506.4188964.2073353321745959286.stgit@frogsfrogsfrogs>
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index ff501d027612ee..18aff98f96ac46 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -124,6 +124,7 @@ sizeof(struct xfs_refcount_key) = 4
 sizeof(struct xfs_refcount_rec) = 12
 sizeof(struct xfs_rmap_key) = 20
 sizeof(struct xfs_rmap_rec) = 24
+sizeof(struct xfs_rtbuf_blkinfo) = 48
 sizeof(struct xfs_rtgroup_geometry) = 128
 sizeof(struct xfs_rtrmap_key) = 24
 sizeof(struct xfs_rtrmap_rec) = 32

