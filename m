Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794271116;
	b=kJjCP4VJRGXuUjJ14vLFanVVIjVbxPXh6NP8fZFkrtGJj9dX2Cm5JNYI1Nd3TvBmkNJZ
	 8lkr3gDyl+8guNsdB9fXlYn3qTs2BVVBxuLVZpj1ED4K7t8l2/J67g+MJO4itnrPtvMQ7
	 EPCxo8vvWEBn42uI9P+kuIODjyvmXZUg1kgZnNt541b8/iUmCsKwqHBoCEQOlJOtmPxyC
	 /5x/+ZHfVOFXprfFZMqDgQkWFhx9/9GZN4oLdsO9rBOTaIj/Idi2WQLHS6tSp3lR9rte+
	 kGQi6Q/jk1+1FNFqvAPTyb+Cdb84bMlicX1Z0cx82orhLNXVPl5mH8FqkWbztMiDjHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794271116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=9yWjq37FKqPtusch3+XDK1PEacwXlAR11aX4lXvCrIY=;
	b=3xX5Ck1fc+BsxA9lQ41kKkmxsPaaFFM4DX4wPaHAsPDR7j7WsACHbFpB7GN4tNpZ+E5C
	 aWLSNBmPgQzC176fKJGVh4/ATAk21K8D13ELqEUYvUaOGXDYaNuqljrILJPCmEl6U/SOa
	 hyW7ZtawaiGLbZamVdoCFKUpn00mR3gT+Egpqw98Ng6S89fY4HRojsi91yTiheXSAFJQ+
	 Sluwji2wxg7T8zZCZGc0LjTcKgFiNveZMxCEUh75ozCQjg10BObsRRJkC2MektnPIx+qC
	 ZSoQSLBfotuQNIMCVe7hPRKT/xoERSRfTmtiBoxmMSTBV9iICR1ez6sazkbBF6ugkWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QvFNR0bu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70B9606A325;
	Tue, 10 Nov 2026 00:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QvFNR0bu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6C41F008A3;
	Tue, 10 Nov 2026 00:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794271115;
	bh=9yWjq37FKqPtusch3+XDK1PEacwXlAR11aX4lXvCrIY=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=QvFNR0bu5lWGEwbPQYch+YJKTSFMYZgMH+6xQqoNXZD/GTKuHHP/7w7MkHDgIFDqZ
	 +wtBv7MI92e39ySc4hW9dxIwZ5oLSij/wDAfB3Af/JeUE8dtTPm6u03U23lCm4HzyZ
	 AGKLWg7Wdipso9xCELORDJ+MR/lWQsFCIbnQ7fh7EaPJL6VGJcWAWDz1FpCdeU9EOn
	 bLBLvqDHWhkOX/j6y3q9qwyf9OTNmkje96aahDVr0spcRLv6NtnD8R5sgiCXik6/jc
	 ZECToG66AKfUsl6Jnw/o0EOyLwpPc6cbVQi53OBk8mMMJaVXx0m/m7rLc1Ti+et6KN
	 dfGqqFvgdkd3Q==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: clamp a pNFS LAYOUTCOMMIT extent before computing its end" has been added to the 6.6-stable tree
Date: Mon,  9 Nov 2026 19:38:33 -0500
Message-ID: <20261110003833.3527820-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
Reply-To: stable@vger.kernel.org
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

This is a note to let you know that I've just added the patch titled

    xfs: clamp a pNFS LAYOUTCOMMIT extent before computing its end

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-clamp-a-pnfs-layoutcommit-extent-before-computin.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit dbc2e3992384561baac320258a6bc7ee10b690bf
Author: Daejun Park <daejun7.park@samsung.com>
Date:   Thu Oct 29 11:23:01 2026 +0900

    xfs: clamp a pNFS LAYOUTCOMMIT extent before computing its end
    
    [ Upstream commit d8c2bc88460f89e543ab3af622fc8f34c7011d71 ]
    
    xfs_fs_commit_blocks() adds the client's length to the offset before it
    clamps the end to the file size. A large length wraps the sum and
    reaches xfs_iomap_write_unwritten() unclamped. With the previous two
    patches the LAYOUTCOMMIT then fails with -EIO and converts nothing.
    
    Clamp the length first.
    
    Fixes: 527851124d10 ("xfs: implement pNFS export operations")
    Cc: stable@vger.kernel.org
    Signed-off-by: Daejun Park <daejun7.park@samsung.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
    Signed-off-by: Carlos Maiolino <cem@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index ca3d085a3e781..a222410812ac4 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -302,9 +302,7 @@ xfs_fs_commit_blocks(
 		if (start > size)
 			continue;
 
-		end = start + maps[i].length;
-		if (end > size)
-			end = size;
+		end = start + min_t(u64, maps[i].length, size - start);
 
 		length = end - start;
 		if (!length)
