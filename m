Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794519981;
	b=ZRPmYzu+np2iFXaMNdGGHLgxO7Qj/9lUFIJlS5eF+RxeOrf5fURcnVHLA+JswTu7T5UZ
	 WXJAlo6cIXTOCix7jrEP3KfUjpmlL0UAkvCC7bwarZ3ntJdAyAgHefo942E3+d6lNt0hR
	 DxwvUpSLfO2U3YdxrTGb7PUsufvjnISFRQx+8P6cNHd0W2rZZayp6k2mg3NJ16XJ+meY3
	 IwpjecXDaZxlXRj6Hb6DVBxvTZCkjFLZ8vdCs9Fzf+c9PLqqJjNQ6xrT+pUqvB6dmUTaM
	 9YNh2efZ8tBjrXkCK/3xKB1PtX1An6JKR2lnmNlibRNxCXNIk47rNox2+3KGS0k3XNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794519981;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=dhSFR2ubadcyXaAKett/4h+Z0PAEFKYZEE0yEgeDYgE=;
	b=BnQ5nocC7zgzF6daqARLepL88WTZNZ8XeXZ5T6cjB3zw/KHylkQV07EinyZeKeBhQ6sO
	 gKxnQq+TYmjCQsXaLbmUfZLNYNhZsqCFSCXuQWjMO81m4JV717m3TBvmDrpMq2SRMvrt9
	 x7k4MHMZjiEomzx2tj+AYmhtUtqeb2b070Ws+j09Mv4AGVb3tPKCIE/rtByTxpOVWb1iS
	 9dNcqRSp4RClCCUnakoLQ9gTe89TlQFIZTN7PEWJvFhVZXamwEp9bvTso/IchD2+mVfsl
	 o4HQgiW4kwh/yDwpTNuXz3g+cZdXNmgDu8AWs1idySU2JVC0pgeP+Glj6ZvCn2dN4Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lNcaDmma;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE209606A880;
	Thu, 12 Nov 2026 21:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lNcaDmma
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B97A1F000C5;
	Thu, 12 Nov 2026 21:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794519981;
	bh=dhSFR2ubadcyXaAKett/4h+Z0PAEFKYZEE0yEgeDYgE=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=lNcaDmmajZ+lz1UoySq0J+MPCUW5U2mZloPcWxVju1g27w7T/lJA9klBfgEUgBIe/
	 EV/D93SJ7Erw0v5orywlUlkCzmqMyD0XizsgoJFpm9gsnJfCgzu7GqhwkFyfAl7RvM
	 dNfbQvB5P1dbX8u+j2jBIjlu9M/mYQZH4NF+UQqITJLZkFQWErGGPXKCJ0t/lNoV4+
	 KUEAwjN1BKlSysBL8cmFJDq/NHSDzwKpNUnp1Bh8PwS3GH4U2aJFobmBZAR3kJ/OQU
	 1N8BkM2EEMaP6bZTNt4ou3GSMwYrIxKUAGH+agbv8v/cDuWPahQuXYxSRiht7+WJR0
	 L2TKyrJ4Ff18g==
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
Subject: [PATCH v9 08/14] xfs: refuse writes to files racing with realtime inode flag changes
Date: Thu, 12 Nov 2026 16:46:12 -0500
Message-ID: <20261112214604.67875-9-mason@kernel.org>
In-Reply-To: <20261112214604.67875-1-mason@kernel.org>
References: <20261112214604.67875-1-mason@kernel.org>
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
    v6->v9: no change

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

