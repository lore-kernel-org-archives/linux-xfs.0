Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794268286;
	b=pOG7q0JjpScVU74FKnNQQ39DxLyQ6uVThMpyxXx7ly649sEgfWNDYP0Tp4e+VIPeutKp
	 p5hr9DxrTaZDcX8UsSXD8qqJiuQosEXKqYEtDRdjIiWGSKJ6bwUnNemhMqu4QmexjPSMB
	 fJeaH1o948uSpu6+DE/FxABj+2SFpPSPmyNvxEScosLh1s9azB6FC7KDCLSzEXEZqYKsr
	 w3PmDgtc8/idlEp1RVZyuM6z9cRNrC8uqtS3RXqR6IdBv4VJZpjtcqaBJy5eA9Mxw9sdn
	 lVaARIU8MjlWyq7pWvli3wIWI1IN24h4CSbvIwTje0uKFYqOmQ6F+D6bUuiI0Mic/Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794268286;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=giTDOnVcOZriNwTDfhq4srUfjxgzdJlcjga2xuNUmbs=;
	b=b8EA/OoHn9MzfQ89L/DYJyL5IBA+Ie53jUNEmvPHsnPfauErMHZAK6bP+3ELoIIApWIa
	 ecbpeSKFyRfQsmgE0Upbw2ajQF2FZqSxDijUl4Yh+guBBsa2eHMqsLixnhsTgIKl6WWEZ
	 lI0wehr20kI1fXnqjBn/VT7/6O+RPBSpwgOMtPEOhhv/CQ7hOWqB6I8fqUbUMO2snnRkL
	 0ujcYJT3PaeD8I5nvqYYKJeTMzKjH5YgF4+UICLoTxdTyskqTvnuvmH3NhKvYA7KnVaQY
	 23WYrHA5Gu1SDuA7VWolFxCkj8SzJCezdIc6MNWjRuRzcOZT7e5NH9+pnyHLvKqHlKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g847cehg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AB8606A31C;
	Mon,  9 Nov 2026 23:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g847cehg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF411F00907;
	Mon,  9 Nov 2026 23:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794268285;
	bh=giTDOnVcOZriNwTDfhq4srUfjxgzdJlcjga2xuNUmbs=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=g847cehgi1FpLxhiqZo+CBI7CKdFDfAxdfvfs1RONFM3Aib72YIx987kMqANdSbQp
	 ePe/H62ugSCYFz6JMLbSCQpSIFDJGB9q8qsSwjtQKMLh+qx+o3AzQyZAak0dWsmGPI
	 34jIUgrM8vfsjZndprXURQuNAl1h9TRmuplBQvaTZTlURTGi769mWMsUAanvmtmvVl
	 Z8v0SCbE9mfc23Ie757k2puWWPS3Z2jayNP39T1BSluEsHOWg3c6ZicASfHmQYZFeS
	 ukm/ykjnOkTeAHMcIdh5OyGcnWPYc1zJc70X+m6GwpozJNKGRJPYDoQyM+YGQ52kSL
	 TB+kgwz7rCP8Q==
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
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v6 08/10] xfs: refuse writes to files racing with realtime inode flag changes
Date: Mon, 09 Nov 2026 18:51:19 -0500
Message-ID: <20261109235111.14129-9-mason@kernel.org>
In-Reply-To: <20261109235111.14129-1-mason@kernel.org>
References: <20261109235111.14129-1-mason@kernel.org>
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
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
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

