Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794270128;
	b=dGO6+toioRsv31pJVm0JiTAPPoMmCjbZIdP5MELSO8I8R6RMQkbNTC8OvA5XZ6hbw8n/
	 ywJOD+7A3EniFltvZ/RVWVoapUzEmjYHhny9cPE6GUnUBtxt7ucM34L5WK1hkqgOtHiG7
	 5QCj478uMfyIJmRk5nX+kCqkpjAtQdgTONBafKnvPaw3d6v0Sd9a4JT2bpvqEMpG/b/Zn
	 Mq6uQPzJBTorGhd55lOJrxmcjsCx2B44PAMpSYUZcBmi6YOx6gWYdYyo21FjrZW4ueWpK
	 dr27IDXJfUBC4IsRcteYn5h9/3FwYbEl/4eowgbRY8xMuNx+YqsqauftRXKG1zE0LOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794270128;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=R++eU5trcGHkbcJ+zCghw+7se2HB+UGz03tOvpA9BQc=;
	b=e4AFg2rqS1U5OzreOU1jYhiaG7WAzU0Z9IcTGLh10V7Ny+fP12Xpi2vudokXlHOg0FUs
	 iFt7BbrFz/7joKIcF0VbXhLk9lYA6VfW8qPvDbGNgLa3Kz49RuZUlnCe8i3d4fRnU8WqX
	 YYA9JVb8vg/9kr+xMJB4RCxg1sv2NeG6vb9Et/PACKcsUM6LC84eoYTsJeeZ6ZvUI/vxM
	 pKWa7hW09FtKWMCRJqjAhy5gK19eMXk0TPbOj9o4MmDMDrixgru+3rs0kyCfdObcg1Kf3
	 NtQgbwZGPTXu+opLvGzoaIRFHP8/Bmu9VsAMYNomRERT+uqkQEZncI9JLYbZR5oubmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lbyo2hAX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B58606A31C;
	Tue, 10 Nov 2026 00:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lbyo2hAX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C8F1F008A1;
	Tue, 10 Nov 2026 00:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794270128;
	bh=R++eU5trcGHkbcJ+zCghw+7se2HB+UGz03tOvpA9BQc=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=lbyo2hAXJePLj+tbQemuO95aCeCWnyv4km0LtgYiwUnga7455PZz/UNLtSg7yEEA4
	 J0dT/4fd4heKYFlEsJEpWjmS9vAuxzWxBLABViLOjHOfjI3o/lDcv8yhotcY53aSN1
	 fTtbP4lcI7W/N7DzQe71A9ikyD/iC+VCuu2FLxCwG6Ej3AqNEtVvXRvLz550v/irNs
	 u2r6+i5sT9RwGHqfXMq3D6sJBQE8Vm+aJVFNHeshqkTOTSO69L5+12cPNTWiNBrDCn
	 fdSp4Equqx4EWuC6rCS2V8iFY5SsxzZNJLkkI1mKRlnVKjA32HemvwbTUkKJSXuFdl
	 b/SZILLS7PRqg==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: clamp a pNFS LAYOUTCOMMIT extent before computing its end" has been added to the 6.18-stable tree
Date: Mon,  9 Nov 2026 19:22:05 -0500
Message-ID: <20261110002205.3505655-1-sashal@kernel.org>
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

to the 6.18-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-clamp-a-pnfs-layoutcommit-extent-before-computin.patch
and it can be found in the queue-6.18 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit bfc4e32e1fd6e887ff31ba385d39aa686a1820d9
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
index ef08f0f619f70..b880d061ee90c 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -311,9 +311,7 @@ xfs_fs_commit_blocks(
 		if (start > size)
 			continue;
 
-		end = start + maps[i].length;
-		if (end > size)
-			end = size;
+		end = start + min_t(u64, maps[i].length, size - start);
 
 		length = end - start;
 		if (!length)
