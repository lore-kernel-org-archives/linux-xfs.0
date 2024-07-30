Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91B44A21
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300122; cv=none; b=Oxd+HbPWZLX+w9KnjT8s+EspLHPg8xreqbG/36HNm4AFA3VCTjzR68xfLtIjBPeQJsHBONvd4MiVzDNTqElB0do9zy2lBhUeCtWovjjEBqonOZPL42V6ISJ72FcjbIlmmIKm3gMhjyAnzq8Z5wVk9gXdFHkZ820Ies62JPnVUCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300122; c=relaxed/simple;
	bh=K9LoPnJYlv3h/iqABQPIIGPkhSoSFKsNkLvErpp1DJg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t7Mv0PrFO1L58hH6HosW/o7XvbwnZS0rNPa96J4vhUH2w7PCbom4neSYcwQG5DqcxRU4WrT4cGgYmKq9OnHYCNFrNfBgCNSxOzrCfAUcxX4By4xJbdkxGSyXA9SdnkdLhPJogvfWsrCRojucLCwArezqfWmn2saxJjxKKQakol4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mc0Q+Cks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mc0Q+Cks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A153EC32786;
	Tue, 30 Jul 2024 00:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300122;
	bh=K9LoPnJYlv3h/iqABQPIIGPkhSoSFKsNkLvErpp1DJg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mc0Q+Cks3BjlQZHP2I/JAPsuawsAnxtSub4GwlgtX0foSiA//sz/LQH81FztC+VfO
	 dkma/dQBCF0lJQ8xO/OoFm2jPx1He1lMz+KNEhK7TW3B8TcZI4PP8aMUXGFh1HF2D+
	 aZhxwuc90F1TbRWyf6rUXj1h+lfGqX+4fOCDXrNT5UZno+bxZ0BktxG7AjqWAK+oGO
	 r3slRleQHIOhOdmddiIrLZpiO+bv4ZDbXKGUqQ82LYs19c77aTQbvGasPIsl0igrd4
	 n+AsQv0x1pi2J/B3SxODJEfEgfLgc0poe9BMLikGdbmydZResKFKtwvJ8tp/elQEyd
	 aSrI5v5/sC0vw==
Date: Mon, 29 Jul 2024 17:42:02 -0700
Subject: [PATCH 070/115] xfs: split out handle management helpers a bit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843428.1338752.14171945500604979431.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: b8c9d4253da43c02b287831f7e576568f24fbe58

Split out the functions that generate file/fs handles and map them back
into dentries in preparation for the GETPARENTS ioctl next.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 53526fca7..97384ab95 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -633,7 +633,9 @@ typedef struct xfs_fsop_attrmulti_handlereq {
 /*
  * per machine unique filesystem identifier types.
  */
-typedef struct { __u32 val[2]; } xfs_fsid_t; /* file system id type */
+typedef struct xfs_fsid {
+	__u32	val[2];			/* file system id type */
+} xfs_fsid_t;
 
 typedef struct xfs_fid {
 	__u16	fid_len;		/* length of remainder	*/

