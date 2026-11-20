Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795190031;
	b=XhC6hfNyu2OiRp/d4GOhwAVwXTVk0pEF+/lo0FAwJjWSIvyG8AB1+cEEWOCLu7AmNJgi
	 bRyh8GRqbtEvomIZ/gekfQYqPe8AgMs4MaF5eCEZSSj90mNhpC2fdX6ZcAIqUVIOzbpbh
	 1HigTKKa+E7jUyuAlCDxVLrUw7m/xpDG6WamrNuE7h889LKOWsEU8rWtFit6CKdm6LFHs
	 Ev+aVsKXLMntspILEd36h4XB0gMURpnCEgauoAvPdecZBaPUPFKz8d6QmCXKIIGERbgl+
	 1qnCwHZtqGtCbZzW/sVjmW5++jXkPJ6kqKYzf3WJzMbSPgpJoFT5ULZRsNqvixpu0Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795190031;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=E5gSXNwtA5kQIUw/uoqqaybdSZDyhnTy+gYKDJ9u12s=;
	b=BDfRlbDAp77e46FNdW6dh54AMzZ4KxYpLFw71qxSxBtA6RaOzLx/Lv2fK5c+6Md6obMM
	 nGDQoYWmuMncS+B+MjePD4qRqIwfIFkHNLQNd0GBVjamrVvW3AuBR8eYB6xs8j7cfNlps
	 QNshX0DwlLuUD8o1/hMshuDaCYqzIb2EcbFJLW1PTrWqpjKk5dWIPTwBJA5psYTKP+XAw
	 so+CNYLYxVFCscd1EYbfsCRAGTqFXqFrFMaRDTii6xYkTlVtRqx5gYgPvlROGo0K1TR8a
	 FTKvjGw2oqbR1ooh+uxvydPu7LGa6WElYDakeD298EcoVyYsxxJ8VjFgoJY7EuaETOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OZdZos0i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D26C606A334;
	Fri, 20 Nov 2026 15:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OZdZos0i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991DB1F000C0;
	Fri, 20 Nov 2026 15:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795190031;
	bh=E5gSXNwtA5kQIUw/uoqqaybdSZDyhnTy+gYKDJ9u12s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OZdZos0iO9L6qP1cpJU5weQvoMm3GHHjbXInIphUY28MGhkG3q2du8yD1xctmgmGH
	 gbt5/zngGoW28ArrsGoS5dH08PXLMsK9lDXGaagnSQ4md9kSA5Bb/AILT1ycq4YnED
	 LuCGIqLwqkUtQuvMURjrahA5GCFlOodAjsxyCa5A6qrAzx5WM20BmRCGS02h6RpWuA
	 qR0TgLvJ3tyiP1vP9Jc2EVhb7AMmvLJIHj1L7MupZbXQsL2OrPRmydy6SRJBoRHF4u
	 TIg/XFB1MetA6nLlgzGlBgJsFmuMtHquozmk6XV7WQU1seCdlRciBDnscGTQY6evN8
	 Bi2lWhQPS3Vcw==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "fsdevel" <linux-fsdevel@vger.kernel.org>,
	"fsverity" <fsverity@lists.linux.dev>,
	"linux-ext4" <linux-ext4@vger.kernel.org>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>,
	"linux-f2fs" <linux-f2fs-devel@lists.sourceforge.net>,
	"linux-xfs" <linux-xfs@vger.kernel.org>,
	dsterba@suse.com,
	"Eric Biggers" <ebiggers@kernel.org>,
	"Christian Brauner" <brauner@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	tytso@mit.edu,
	chao@kernel.org,
	jaegeuk@kernel.org,
	viro@zeniv.linux.org.uk,
	Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 1/7] fs: constify inode argument of inode_state_read_once()
Date: Fri, 20 Nov 2026 16:50:23 +0100
Message-ID: <20261120155032.187246-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120155032.187246-1-aalbersh@kernel.org>
References: <20261120155032.187246-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Constify inode parameter so that callers can pass const inode. Callers
do not need a change.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5b3a100aba77..5c62a968fbde 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -878,7 +878,7 @@ struct inode {
  *
  * We hide all of it behind helpers so that we can validate consumers.
  */
-static inline enum inode_state_flags_enum inode_state_read_once(struct inode *inode)
+static inline enum inode_state_flags_enum inode_state_read_once(const struct inode *inode)
 {
 	return READ_ONCE(inode->i_state.__state);
 }
-- 
2.54.0

