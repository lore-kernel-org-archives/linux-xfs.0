Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4EB2E717B;
	Thu, 27 Aug 2026 05:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787808858; cv=none; b=oPjNdp6cIYOp95OQ+vgwMRA9QGIA8zuu09WSajLK3jy39+U1i91D7A/8dOu8ggr53fG6KyNsYwDS+EDFkt7E52XLpNSMgkDzyLDIYYl4fNMw5/agfV8LW6BM/WGBAKiKF43T80c2OTZXlMNoWI3ux8qV9+h4M8KSEU5Ao8ag/bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787808858; c=relaxed/simple;
	bh=1XfRKXOOY2RhkniR3LsZTg3ZYQMOxgAvGOCAx8WCqOQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y3Q46Wew/W1gL2Fp1IgfWK9habop+qRAi6AIP1sQcCJlxWLPtbeYiEzrk9SaPrHTMZOY8n8Z+Tfc/cJmWUudYrE494uHb+/Jr2wP6ug3h02Wd9Ikdq+RIXlX/PJ6UIVD8f9Xc9woWZMftin2ijuIkB30Sn9/ZZuPwG545w9HaVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oj07lz97; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oj07lz97"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 012831F000E9;
	Thu, 27 Aug 2026 05:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787808857;
	bh=YuiXctfKs30xQWzBOJ2EZsz8ZEnvUQPqUGJpp13XHgY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Oj07lz970YupvCJen2VumUWs8Ced6njUUNWM9az1CUKMv4z/pYr+En1LUdxeGOFg9
	 Oe8OCAHelbzlPUtnfz6iH6qDZ8ja2mOJE2aSkOAGh5AZz05ol9KqsXkmLJ4NpVe1Pz
	 R3tnk8aD94dEdLiZSs3K2SpG1049m3GUqGFrEt/3I8xI1TWjwXKP4+u9BDhjfTUcbn
	 mH54Y/EMYl7MKEbvXrzQWWJp+vdmKYAfxzDlLOw2gkEN1EcYhRN4sCp+rQ4ou0bgNU
	 9QT5ZKp1cpFo/enHURuOaeJfKHr+cTKYbSmCPzLOPOsHx9KONYfqu45KibEFrQtqNq
	 Ligp1gBc4OXtw==
Date: Wed, 26 Aug 2026 22:34:16 -0700
Subject: [PATCH 7/7] xfs: destroy seen inode bitmap when we fail to add a
 dirpath
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178780640732.3528467.1896782451034278071.stgit@frogsfrogsfrogs>
In-Reply-To: <178780640541.3528467.13867917797753503580.stgit@frogsfrogsfrogs>
References: <178780640541.3528467.13867917797753503580.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM observes a memory leak in xchk_dirtree_create_path if we create
the directory path object but appending the name to the path fails.
When this happens, we don't tear down the (empty) seen inode bitmap.
This is a pretty trivial error, but let's not leave logic bombs.

Do the same for a similar bug in xrep_dirtree_create_adoption_path.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 928b721a11789a ("xfs: teach online scrub to find directory tree structure problems")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/dirtree.c        |    1 +
 fs/xfs/scrub/dirtree_repair.c |    1 +
 2 files changed, 2 insertions(+)


diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
index 717cbac2956238..9b0ab23166124e 100644
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -259,6 +259,7 @@ xchk_dirtree_create_path(
 	dl->nr_paths++;
 	return 0;
 out_path:
+	xino_bitmap_destroy(&path->seen_inodes);
 	kfree(path);
 	return error;
 }
diff --git a/fs/xfs/scrub/dirtree_repair.c b/fs/xfs/scrub/dirtree_repair.c
index bbf6acf6fd400c..8acd55b8c7696d 100644
--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -618,6 +618,7 @@ xrep_dirtree_create_adoption_path(
 	return 0;
 
 out_path:
+	xino_bitmap_destroy(&path->seen_inodes);
 	kfree(path);
 	return error;
 }

