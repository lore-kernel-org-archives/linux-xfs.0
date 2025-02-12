Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6791F271839;
	Wed, 12 Feb 2025 03:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331510; cv=none; b=XDbgyMIEPizvbVdbu6JNBQZfrv8tlONEgJsHb6sWOUDaZqRixk7xXXCLvF5etpzyenS7Xp8HMCUVJ1WUvy8B5IddMYYROIAQWtjJM6B3INk/oGqRu4SZdqxI52b68EMihGbY0vWQ2499vqGUVrAVquFWpfyF1Sdbh+owt5j62Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331510; c=relaxed/simple;
	bh=x7T4IjtAXnVWChlNzEOwzWh6CK5dnmWupRYg51H074Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MZCxeAxNjumDrKu9XNWP6Fuzjq9hR+AqxXjTI6YA4aS9bdcQpPcJLbRUpp7SKfPwG7Dc1wQbUCVsJQ0/fa2D/A9wtVLUuEU1HIDdh4+prCVt+w/U+c/VUq/r6E3HRfS/L1d0xMCH/1N7gHxYEKJ/pbMOrLT84l1mP23JROWj4Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CMVFwhkD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CMVFwhkD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D17C4CEDF;
	Wed, 12 Feb 2025 03:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331510;
	bh=x7T4IjtAXnVWChlNzEOwzWh6CK5dnmWupRYg51H074Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CMVFwhkDEmPaggIYpDJnmHd9i4sCG++SEGOBrW+nG8el7taQCxILtRO9VQ2bILxTT
	 oBn9AP1zLcjbv4DXLs3pKEV9YppHc/2cJ4phLSE3jAwZi8Jbax4s+aRNR+ziRLqQVi
	 wbnynvNm8kHrM61ccpkWzYQqCx/qkEi0n8oUKh5dGwLq3RI29z7T1KxV5APTvMRA02
	 kcc4P0JOlomtxzRDvH6bnrmAqDEhgKUf4Y3AKFrvfy/Vugpj+7PJnQlIToahuu+yFi
	 vlkVvteoGJHQXyXW8m4YEYp6TF3fhkkWuz6Q/xzVJFQD8y/W6tQ63IvUP054DBHB4d
	 XFhwLnOktS5Sw==
Date: Tue, 11 Feb 2025 19:38:29 -0800
Subject: [PATCH 30/34] fsx: fix leaked log file pointer
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173933094813.1758477.793184109564270275.stgit@frogsfrogsfrogs>
In-Reply-To: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Fix a resource leaks in fsx, where we fail to close the fsx logfile,
because the C library could have some buffered contents that aren't
flushed when the program terminates.  glibc seems to do this for us, but
I wouldn't be so sure about the others.

Fixes: 3f742550dfed84 ("fsx: add support for recording operations to a file")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 ltp/fsx.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/ltp/fsx.c b/ltp/fsx.c
index d1b0f245582b31..163b9453b5418b 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -3489,6 +3489,7 @@ main(int argc, char **argv)
 	if (recordops)
 		logdump();
 
+	fclose(fsxlogf);
 	exit(0);
 	return 0;
 }

