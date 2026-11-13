Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590665;
	b=h2AT9uB+tQnyfkhf0p2OP3Se9Q8M0/pFLg9+zB5S+8Wwo2B1bKYoM1+NsOcB4SZGu2DR
	 kfFwURRYEjnEwU+PwtJUS/WYQV6bCyBebDvnbxitY3MWvuVF31w5fPYRMAWRp6+C24AeY
	 Ktx7XelkHdywV48Inz2DeZQwFxK7a/kLtjlpHZuEuPvn7jYUe4EX4Mj7FJ0yBTdtcFXEu
	 pucL5Sbf13lzTlgRdQjmk+oVfma+KAtCnnMu35sxKiUdrEAYFwA2VOUglcrecROFsNGt4
	 BHhrbYwD3vi8HktARo132iqtlGRVddTggm9UOVJitzigqQZap9E3/apzmUiSSojirZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590665;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RcgyeO7FtkZzO/3JIgojB70QPZ/5DqUwjayqWLiiV60=;
	b=ytvMLlKkJ34KmqgRiTcUU86e4u0JQe618m2zuBN1nL52KNkrPu6p7J4aSqzRED/vsAeM
	 KwCoYqfn7pHqeOIYgzbTX+d7ojVDZabUg6wdhEKjARQnvK6VRS9KGW4wrh+cZ52bOdWKR
	 vntg5p7Y0XI8XGw1u8alY8FjmVYPGw/UjhLjFKEtYrUL3aZ0+MfUut1mKsoHN5WQ/xi5Q
	 0++u2zOE0v2TpVgl4yuF45++6+UKqt8lWpEuha/usBIZTrjQdg3TZhGjgSxjrnYXzxTSp
	 Lwx+WjJbnp3BFZcrwhB9PdMTc4uoUhSqMrbk+jMevus3bmAyC4w4il4GuEzWGDEKR7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=knvoC9PB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADC860776E3;
	Fri, 13 Nov 2026 17:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=knvoC9PB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA181F000C4;
	Fri, 13 Nov 2026 17:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590665;
	bh=RcgyeO7FtkZzO/3JIgojB70QPZ/5DqUwjayqWLiiV60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=knvoC9PBlodeGsZQs2oH51zGQnqshgC4cAOtp9BjcdjAWYBfbKlztuCgD/HiS3jFX
	 nSf1fYcD/v1CiKTBKwb/GU/7l1sV5we2uA5Su4Zi9THwbY97Jqw4Ts61610PLFUD/c
	 7og2z8bTXNgIuAtXDSAbMGgYwbzUMzMTqROjjKP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 582/686] xfs: Use folio_next_pos()
Date: Fri, 13 Nov 2026 10:51:55 -0500
Message-ID: <20261113153841.518529216@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit ac0a11113de3f0007283d20f5a38615ea4c6e9fd ]

This is one instruction more efficient than open-coding folio_pos() +
folio_size().  It's the equivalent of (x + y) << z rather than
x << z + y << z.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://patch.msgid.link/20251024170822.1427218-10-willy@infradead.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 329750292e9d ("xfarray: don't crash when sorting if array element crosses a folio")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/xfarray.c | 2 +-
 fs/xfs/xfs_aops.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index ccf7cfb63bbc8..78880b76b15d0 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -833,7 +833,7 @@ xfarray_sort_scan(
 		si->first_folio_idx = xfarray_idx(si->array,
 				folio_pos(si->folio) + si->array->obj_size - 1);
 
-		next_pos = folio_pos(si->folio) + folio_size(si->folio);
+		next_pos = folio_next_pos(si->folio);
 		si->last_folio_idx = xfarray_idx(si->array, next_pos - 1);
 		if (xfarray_pos(si->array, si->last_folio_idx + 1) > next_pos)
 			si->last_folio_idx--;
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 9845a5fcf8575..4c9afca35fefa 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -271,7 +271,7 @@ xfs_discard_folio(
 	 * folio itself and not the start offset that is passed in.
 	 */
 	xfs_bmap_punch_delalloc_range(ip, XFS_DATA_FORK, pos,
-				folio_pos(folio) + folio_size(folio), NULL);
+				folio_next_pos(folio), NULL);
 }
 
 /*
-- 
2.53.0



