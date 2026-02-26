Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1350273D8D;
	Thu, 26 Feb 2026 18:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772128858; cv=none; b=sR9iHWrUohayp990Q63lJ6FWXjD4r2MeO2MAaSrvFyzgFjesK4cqq0hlsbvBzuYiABLDEbq+HPO01ZPB/cTRCSF5BT6TyWqxwpf0Wa+E03O3PD9Jlimb5XQh+LGb74TsdfUvYLVAtRC1vtewGNe8lzd4mOg4Hnz24kKAetlx+5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772128858; c=relaxed/simple;
	bh=tSa5hiZicrhBi+QNoJvAJrtUetEQAG+5OISR6HExzek=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=hN5OHfJ/EwWvWh4ZHTP/5ax9Aw1JFmWVJqP8UOIMzg5FkYuBicQro+txFHvukC4S5c0KIU/fkb2HoKXD88tVIP5zE/7JQc20/zgD8nRywC0NQAEr4nMPjRaV6s423pdzKTjjm8Yhyg3ttMk2uKOIMSHjqu5BbHYW5FtHI6jnBtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c748izqF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c748izqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90356C116C6;
	Thu, 26 Feb 2026 18:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772128858;
	bh=tSa5hiZicrhBi+QNoJvAJrtUetEQAG+5OISR6HExzek=;
	h=Date:From:To:Cc:Subject:From;
	b=c748izqFEo4LcM8ySrqe6h0bV0E+M1eaxAFHGkvsSPzV48C3p9fR73VONdMbVrAfp
	 KEho9eKTTTwA2FWZ77ombT8gTOUUWP9b/9QhCLvrbH2Dg4wRH6gxD5cIubUm5U6YTM
	 VuDfvgO4aOganUR/YdUskSdLCfIJAOMFkup1sW10w96EA4fX7o+oVCF6zIRy9j/K42
	 2/kWvui0eXjjXaDkW9JidBGV6GhKdT1pKWCrdX/w3CSdN6KWnrAVTYnuiawKVabvsf
	 BV6CJbLx42c9hMWU2+vQLEuLJ0vRj4PZ8ItlYm5VIm+5dXTmxYjVdugUz0CZ/3g0rp
	 CINLNcp9aAICw==
Date: Thu, 26 Feb 2026 10:00:58 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>,
	Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] iomap: reject delalloc mappings during writeback
Message-ID: <20260226180058.GF13853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Filesystems should never provide a delayed allocation mapping to
writeback; they're supposed to allocate the space before replying.
This can lead to weird IO errors and crashes in the block layer if the
filesystem is being malicious, or if it hadn't set iomap->dev because
it's a delalloc mapping.

Fix this by failing writeback on delalloc mappings.  Currently no
filesystems actually misbehave in this manner, but we ought to be
stricter about things like that.

Cc: <stable@vger.kernel.org> # v5.5
Fixes: 598ecfbaa742ac ("iomap: lift the xfs writeback code to iomap")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/iomap/ioend.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
index 4d1ef8a2cee90b..62dd539e087c7d 100644
--- a/fs/iomap/ioend.c
+++ b/fs/iomap/ioend.c
@@ -216,6 +216,7 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
 
 	switch (wpc->iomap.type) {
 	case IOMAP_INLINE:
+	case IOMAP_DELALLOC:
 		WARN_ON_ONCE(1);
 		return -EIO;
 	case IOMAP_HOLE:
