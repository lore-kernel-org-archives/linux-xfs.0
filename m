Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B99379CD
	for <linux-xfs@vger.kernel.org>; Tue, 18 Jun 2024 00:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718672224; cv=none; b=pkPWm0mPmQy9Dvhdy7wdpRVTE99K61ZrHPKozF+F9DPy3NwuPcddvuCfyS0O0gOqP4oMJFvU0AFQhaVuv1mOWWmTi75AvwtBsiKJpIby/QnGX+OqXArfefiscBHb1fo2I9Nqnx2kYwGQxyXRfHzQ8l1t5ORj/TBUhpZO9Jel5Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718672224; c=relaxed/simple;
	bh=3qzMeztneLXBB/LvFBbSIHVr0glaez7OxtCEVaBNL0o=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=P4nPleyrpU7Ialv//4QC/2KlRDSZ9mG7orziBcgTKlwrmKU/Vh1WROnx87LEgeRkLE+A86plW6VW3YjAvHXdY60qbyZLDVu3zssVgXuPeaTbAl19PJzVW5dLDG9FlebCuL+H2BAbkuUZ3eGSajwDNZyCeCFnc49CTG6apNYADGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mb5HCgyF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mb5HCgyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B4DC2BD10;
	Tue, 18 Jun 2024 00:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718672223;
	bh=3qzMeztneLXBB/LvFBbSIHVr0glaez7OxtCEVaBNL0o=;
	h=Date:From:To:Cc:Subject:From;
	b=mb5HCgyFLiIKySj1RtKNE3MTkMcwtcu+W/RozAqptTMlqXlHWxOEddstl9BtlkIBg
	 WJg76VoZCT035dAwIrbBvJYoLtt7h1plGnakVIty0imdY8Alpw9B6a33d0NpKCDevQ
	 7UK4PWg45Y9/mqW44feQWsKif8CW21baoPznQNTGONCJv7jExpmhLZkzYRo1KkpwkK
	 H3IymdvWnYFtSvyJwdfG5jOfe7wmJRlhNrv3Rmfzern38gqWLEl9qsGOnQkwCRyKpq
	 W4ATyNddPCPdvxf4Jb5DbJeBfOprrKYsXqdTLRQQgB3WNuh0Z3RspBViZ2tbpy6dxb
	 FFbg1NiG3TsFg==
Date: Mon, 17 Jun 2024 17:57:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfile: fix missing error unlock in xfile_fcb_find
Message-ID: <20240618005703.GD103034@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Fix a missing mutex pthread_mutex_unlock and uninitialized return value
in xfile_fcb_find.

Coverity-id: 1604113
Coverity-id: 1604099
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfile.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libxfs/xfile.c b/libxfs/xfile.c
index fdb76f406647..6e0fa809a296 100644
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
