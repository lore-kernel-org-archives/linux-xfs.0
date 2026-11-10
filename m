Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794272223;
	b=P/qeWzQ9ZpWJdg7F4HxH6NEgyS26jMTUzF9Gy94+sIESafb3vaazSEpxck6zC9AM7SS0
	 IcLftshrLEJm4nAb1PlZliEvO6bZ5lqZ64bLf2od+wBqbDyxKmErtkgtEN65GqmZcPkYf
	 nI2O0Px6Uwc58qTea6A1drKq9jOCm5+UJGruSlOLLTH/D7fLQmG03iKLmNLn6sfLsMbgy
	 jqD80y0dLIlrvdpao9upLKLX6jB1S1N1utmZ5q7HXD5VRtOn+xxvnxHVN9DxKyz5102Pd
	 aQNgbHi8S56s6JBEHuT8uYpnExt5eOq8ZnZcEgui35vto/s+l52YrFhRRlmHqChYynw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794272223;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=czzffEoyv+pyBw23/HoL/xXb8koPHhL+M0hkSdrd1N0=;
	b=yaYQ6c+SSBnGEpO9ohDrixG/nTAcad9f22wCQdQEedAZbLxitW6HnoXo0/ip7HIPRxvm
	 mNm/gj1D16rxPLRSCerPzuKZA+xj7QLkly2Dbv6EqHkW1+9tIkWv0lNH2VpqmmT6kLzlH
	 n3T4CESWNMkM7HXDcWTYynzefXc9EkbtZT4GhaU+IRNjZfHgk8dbpDYd34rbhP4rGIVBI
	 RsheM2l5rQdBAV6w8C7omaMmxcAivRZOjgdChtTp2ApEy9aAw95yUNeuhvuCGYLTo6ORZ
	 +8QZNM2j6FGm17GsDFWfLztz+zK6qMvtfj/QEhiEUUZcjsR2V5lPgqdYglt7JfUqawQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bhwFEsXt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E255E606A31C;
	Tue, 10 Nov 2026 00:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bhwFEsXt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E641F008A1;
	Tue, 10 Nov 2026 00:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794272222;
	bh=czzffEoyv+pyBw23/HoL/xXb8koPHhL+M0hkSdrd1N0=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=bhwFEsXtQJREwBad3TBRwOkuN/Lcm5yBnAJOXG9oiKcFIiRkc8mWlMORjbMsMNr6e
	 FsHUIqX1728HPcVcPEpTvyEnX0wjS8Xg+Bo4wndzi+xR/O4web5Lro/hz3epyR14QH
	 D8wlZLoxXYW68ljb1aJL/r03WA0CDMlvXBZ0HhvP+HY22jTIjWILRLmqRZAcmAUH2B
	 gT9rQQAiwxHhu/Z2MqNvX/aR5MBBbc068facYkPM7Xe/+jB2fV9qnooxhQnMuESorM
	 35DzR5YtEZs1YiWHiqQfBNzZAtYRV3VLErVSIXvji5iC28P7qD1NliBKdak/0/vG+8
	 o5I1VYE5T4gHg==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: clamp a pNFS LAYOUTCOMMIT extent before computing its end" has been added to the 5.10-stable tree
Date: Mon,  9 Nov 2026 19:57:00 -0500
Message-ID: <20261110005701.3549153-1-sashal@kernel.org>
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

to the 5.10-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-clamp-a-pnfs-layoutcommit-extent-before-computin.patch
and it can be found in the queue-5.10 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 860a13c85772ea79dff4b5d0cb5c0a0c1d37c983
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
index 053b99929f835..8b82249b48110 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -250,9 +250,7 @@ xfs_fs_commit_blocks(
 		if (start > size)
 			continue;
 
-		end = start + maps[i].length;
-		if (end > size)
-			end = size;
+		end = start + min_t(u64, maps[i].length, size - start);
 
 		length = end - start;
 		if (!length)
