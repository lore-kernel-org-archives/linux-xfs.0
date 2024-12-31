Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C266113FD72
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688425; cv=none; b=kRudQKCmQxOH8a6BVtkEM5EbQ4khUj93vzHm6U0A57vgrmztRnrUIIOoisLMmrYvaLrNyn+bFy20Jl+1hk7fPfHuZ4D5IC1ottaMFFj3923qAldOiXuzdpWZw3uE3H7/LLLGL/0P3keBK/86kYT/RGl+Mr+ljI+zrv43jRucQfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688425; c=relaxed/simple;
	bh=IkaQy7fXHErKiCRb4fOUOGyO90dXzFqLcE1mpWKo/K4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tlMLhEzNi6XthtejUMmTMWZXFFLUVoRPx7cbjg/wTFuYxa1smwd1tsQUDTc3cKC8EzBkg5zm3N9jOWU1KgauJar+SxvA1rEXLOhsOncHL2rzaRjm8cHWGTKX21t4CQLSSeSgB5jTLHHVGoilmI+aQ3XqTyXuXVs0E4gVof7fzIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jKPX3af5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jKPX3af5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7C2C4CED2;
	Tue, 31 Dec 2024 23:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688425;
	bh=IkaQy7fXHErKiCRb4fOUOGyO90dXzFqLcE1mpWKo/K4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jKPX3af5C5ndUvN0YUCNRFC/jBHxlSccn2Jz/ExvzUy0FozNbqe7Kz7OKqHTrHQYY
	 Pe4AoPTqQ/vSGDiF03JbK436mw+0wT7aXtfRAJyit3T4xjV29u6B3C0kX52AVemMVc
	 z2y3xcAuixJIHwdQkturD+O68tE7vd7gyGKosf4OjmMBiOujdMhLRVNizoG8fGNcJq
	 BfDLoVu8fe+Wkz70tLUYlVV99lSTO1gvtWRnGl1fd+n/ll4Pbk2TIVWG2/0Pt6s71R
	 HBhYi/mkG5A578cY762EjmLuCBYrN5nOf879aPGkxglKuQKjUh6oetP0EIsEhfCai2
	 wMhZ6VS/nlh4A==
Date: Tue, 31 Dec 2024 15:40:25 -0800
Subject: [PATCH 06/16] iomap: report directio read and write errors to callers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568754846.2704911.5576678697570752742.stgit@frogsfrogsfrogs>
In-Reply-To: <173568754700.2704911.10879727466774074251.stgit@frogsfrogsfrogs>
References: <173568754700.2704911.10879727466774074251.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add more hooks to report directio IO errors to the filesystem.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/iomap/direct-io.c  |    4 ++++
 include/linux/iomap.h |    2 ++
 2 files changed, 6 insertions(+)


diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index dd521f4edf55ac..f572be18490b0a 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -100,6 +100,10 @@ ssize_t iomap_dio_complete(struct iomap_dio *dio)
 
 	if (dops && dops->end_io)
 		ret = dops->end_io(iocb, dio->size, ret, dio->flags);
+	if (dio->error && dops && dops->ioerror)
+		dops->ioerror(file_inode(iocb->ki_filp),
+				(dio->flags & IOMAP_DIO_WRITE) ? WRITE : READ,
+				offset, dio->size, dio->error);
 
 	if (likely(!ret)) {
 		ret = dio->size;
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index afa0917cf43705..69c8b45bd9b935 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -439,6 +439,8 @@ struct iomap_dio_ops {
 		      unsigned flags);
 	void (*submit_io)(const struct iomap_iter *iter, struct bio *bio,
 		          loff_t file_offset);
+	void (*ioerror)(struct inode *inode, int direction, loff_t pos,
+			u64 len, int error);
 
 	/*
 	 * Filesystems wishing to attach private information to a direct io bio

