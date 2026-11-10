Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794337476;
	b=JAPWoRk7Lb/FYkQwBw/6s9VxT+DS5jrKQGCgTjPt4shvl0RFLYpTtQ1ru7s6Zlp8U3Wm
	 YtV+xS7K6bpusum8NYxEtnYXMdo/vf3m3LW/rFXD/DLtQPL58eU6IMgzWuAny8RGbO/MY
	 RJ+Ju5gyPc9zGCYQDVoK0hCkMCRgf8EohE5a3PphMXEBrhnkFuCEXYqQ3Gki3mu2edz2C
	 VInz624eErVDaHRVAOX3JYPubA9nfRpQMudlMaDGX4okneXDb4H+preuxj53lIpTRj9HA
	 dwSzVJB5W/e1QGi8AKG60Jpoqr+3FfTGV5QL2R3NeMhgIsqPl3JZKoGzb+zz5QQD6rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794337476;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=WWNLVcfquh27aUR6Wdno6hssFnOjNqjqldOyYJivYaM=;
	b=AJBlglNDTsicPOuk0SgYzShvgah/vjdcc02zD+rHP2CHZbQG3dtYFfdPEtBeBr8Rcy1V
	 2J7NBjfBD/n3WPkW+HTW1JP+Whk+HKdC05eTbHKHA+o8zVgniP51ehi8Jt/Xf8Ougyuql
	 0qsWs8sAql/RIE8rNyGvhRlpr2NBLhoJyHo6sRsUWu6GJ0JQufqqEXnRM3wvcz5LJsiet
	 E6lwg4/lDgA4aZi081zQiNmZaZxrX9fOgpmW3QapvgkvdNv7k95W5ovcneucSJanhnVo3
	 w6QDpoUiCrvuPB7yJNcJhidpa7rfZmDv21dSQ85PADkQkUXK8db0n4cbnv4S0t0mqUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LzsN9AaR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18584606A331;
	Tue, 10 Nov 2026 19:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LzsN9AaR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9691F008A2;
	Tue, 10 Nov 2026 19:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794337475;
	bh=WWNLVcfquh27aUR6Wdno6hssFnOjNqjqldOyYJivYaM=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=LzsN9AaRrrcetlLUqkiXbqZQ3iOo8FuUDoufDBQ5h3CZrp3IacJH2/a2nSe9TF02e
	 b38/2Nq+0Bj5fr+vD2tHM/u9MegKgBlcKGgbWrjvbRVPGKb/IkOKilannj25YDImCx
	 uhprmYeMtF6sXTjP2ZR04ry+Wz/UO8bZWtx/PHivuRe3nMwItFVL76yd3Xd6vjndWN
	 SRog+wWFMxDR3L0ZFvDL3Dx6bSFVnn8jqAQtv+lcvpeVsHmR0peJRh+Bihfgqtt8XU
	 8cysuANbEfplVPf0pw1vl3u+y8BcwRy+NJtwhPHl0rGE5SykBU1O17ok7QFDmr1/tU
	 G+8vQdbHXZ2dA==
From: Chris Mason <mason@kernel.org>
To: mason@kernel.org,
	tytso@mit.edu,
	cem@kernel.org,
	david@fromorbit.com,
	jack@suse.cz,
	djwong@kernel.org,
	josef@toxicpanda.com,
	hch@lst.de,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	tz2294@columbia.edu,
	brauner@kernel.org
Subject: [PATCH v7 08/11] xfs: refuse writes to files racing with realtime inode flag changes
Date: Tue, 10 Nov 2026 14:04:26 -0500
Message-ID: <20261110190417.32650-10-mason@kernel.org>
In-Reply-To: <20261110190417.32650-1-mason@kernel.org>
References: <20261110190417.32650-1-mason@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Zoned writes need to reserve space before taking the iolock to avoid
deadlocks with garbage collection.  But this means that the realtime inode
flag which indicates if the file will be placed on the zoned realtime
device or the main data device can be flipped after taking the reservation
and before taking the write, or after deciding to go down the regular
write path, both of which can't work.

Re-sample the realtime flag just before the actual write, and refuse the
write if the flag changed.  Do not retry the write using the now correct
path, as switching the flag under a write is not a normal use case, and
trying to flip between the zoned and regular path is an inherent life
lock as it could be switched around again the next time this check is
performed.

Fixes: 058dd70c65ab ("xfs: implement buffered writes to zoned RT devices")
Fixes: 2e2383405824 ("xfs: implement direct writes to zoned RT devices")
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chris Mason <mason@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---

Notes:
    v6->v7:
    - No change.

 fs/xfs/xfs_file.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index d888470d092a..515ddafc6673 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -441,6 +441,19 @@ xfs_file_write_checks(
 		goto restart;
 	}
 
+	/*
+	 * Now that we are in the same IOLOCK critical section as the actual
+	 * write, check that the inode still has the realtime flag in the state
+	 * that the caller expects.  If not, some deliberately cleared it while
+	 * I/O is ongoing, so bail out.
+	 */
+	if (xfs_is_zoned_inode(XFS_I(inode)) != !!ac) {
+		xfs_warn_ratelimited(XFS_I(inode)->i_mount,
+			"RT flag modifying during write for inode 0x%llx.",
+			inode->i_ino);
+		return -EINVAL;
+	}
+
 	/*
 	 * If the offset is beyond the size of the file, we need to zero all
 	 * blocks that fall between the existing EOF and the start of this
-- 
2.55.0

