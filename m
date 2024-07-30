Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B802C4A21
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722298995; cv=none; b=PoZcHKyyMttUIsLavToUD5b1VFj4LEn3EK8XqF/3pVbp5B0NqpoR4ZOBK1AsTYMVbzWiMfLv8uFpVUhnh8syEMMtLEPQl2y+ula8UoJQUkRVMYDRBTHNbco1CI073qx96C1PyUOOSTp7wFyHrlTehXTqU+ArncJ9Tnty7Qas4nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722298995; c=relaxed/simple;
	bh=etdlSgkJtmUGXGaJZiGlyWnMTP/HPJ5Tgk0HZzfia4Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iUocH4Z6bVY8wqQGW6ClOdVkR28BHl5lvVDLBjYCks072Vr/11SqGm1/DTTsB+QL28L+BHYFX/uvuJVaFc2Go8bJj9a1CevKCmHlZmsadtWWQE6sbRzyC2k5a4lpvIJJvpCcSkTGrwPlx4YEfjbjsgFpAnWwHQRExEAhXikWu80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XB+L7NtF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XB+L7NtF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF2DC32786;
	Tue, 30 Jul 2024 00:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722298995;
	bh=etdlSgkJtmUGXGaJZiGlyWnMTP/HPJ5Tgk0HZzfia4Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XB+L7NtFRKTab8goYcPlyp3p2HRQW3ZrGgdxUrr3S1rJUy6sgVmwfuk02SRH1UlxW
	 tZUb1Fd+MLklOZaflIjIMo4hY0lgazKqqIR7SLP/iOG5xBkJlipc4a7lwCZ0NkIsHc
	 gcXNwgGi/ds/ZrJunt5o+aq4tGIUauP7dn2608YQf88iSuTXMh0FLtCmpD6eGHgvT6
	 i3+ymKc4DBLJytY2CY4c+0nTQ2vxeedgdTxBl/eLhZPyBNuj80fppEJYfbW16sDwz6
	 dr6Ar9a2Kcm/AKZjSxr8qKcMBwWUAVet1VI925GcvML7A5zQQtoF6EAWUm4I0FRByc
	 bsaHpxBml9LUw==
Date: Mon, 29 Jul 2024 17:23:15 -0700
Subject: [PATCH 3/5] xfile: fix missing error unlock in xfile_fcb_find
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Carlos Maiolino <cmaiolino@redhat.com>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <172229841920.1338302.2007415922737734118.stgit@frogsfrogsfrogs>
In-Reply-To: <172229841874.1338302.4791739002907908995.stgit@frogsfrogsfrogs>
References: <172229841874.1338302.4791739002907908995.stgit@frogsfrogsfrogs>
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

Fix a missing mutex pthread_mutex_unlock and uninitialized return value
in xfile_fcb_find.

Coverity-id: 1604113
Coverity-id: 1604099
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfile.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfile.c b/libxfs/xfile.c
index fdb76f406..6e0fa809a 100644
--- a/libxfs/xfile.c
+++ b/libxfs/xfile.c
@@ -179,7 +179,7 @@ xfile_fcb_find(
 {
 	struct xfile_fcb	*fcb;
 	int			ret;
-	int			error;
+	int			error = 0;
 
 	/* No maximum range means that the caller gets a private memfd. */
 	if (maxbytes == 0) {
@@ -222,13 +222,13 @@ xfile_fcb_find(
 	/* Otherwise, open a new memfd and add it to our list. */
 	error = xfile_fcb_create(description, &fcb);
 	if (error)
-		return error;
+		goto out_unlock;
 
 	ret = ftruncate(fcb->fd, maxbytes);
 	if (ret) {
 		error = -errno;
 		xfile_fcb_irele(fcb, 0, maxbytes);
-		return error;
+		goto out_unlock;
 	}
 
 	list_add_tail(&fcb->fcb_list, &fcb_list);

