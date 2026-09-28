Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D1748E0C0
	for <linux-xfs@vger.kernel.org>; Mon, 28 Sep 2026 08:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790585317; cv=none; b=RsVxkanVgqRgiNUARraDOzYZEQc85etvogG0FSJjmpYp7zVOitHrNtOWGyUrXwM6qiHJxCxfmvmpGqXcpqwxepw3/wXC5LtR69hHHgU+nPGBEjmXdZ7q2J3WFr+xZFP1MQ5OG6oXddT+gEUBqxr0DF1ZRl5P78JReEE+2sxMwCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790585317; c=relaxed/simple;
	bh=RYRoyEZy3AZX96/W22uGNOvKvksOSwlIn7uO1WdQA74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ea1YvxdVJLG9mN7l2wkVfKZF8tSu9/MYS/Gol/ibboIi3vnRoH0NlbdO8F5naNd9J/yVFG+HRXIx7CxZWpXsye3jPm7rWEDLJl8gcpVz1KqA0T0yP8kdNfIMPOrMirNcr9UwoBALY7LJn+U5xJ40AaH9pKKJWvKhOXvWBhmJst4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bPoXHJLF; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bPoXHJLF"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-4a003bd18e5so3686195e9.0
        for <linux-xfs@vger.kernel.org>; Mon, 28 Sep 2026 01:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790585312; x=1791190112; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3/GiZQj0CaseyrQZxOd/ioPb55nZ1v2BOlX+DpEu3BI=;
        b=bPoXHJLF+XF7W3GG1m/hUTsZ23MtnLwud/DKjpYqb49jXKOdyE4iLwWWvMiZoXaS6K
         +jC8sz/94dqDUA9Kw9qCGY/xJ6ByGOaWA2hHR7cdybx3iJ14FvGJW0g9A6H2/dc0zsTe
         +MzF9NDzM+/RXhAqP+3x2LktjPAh80pNuoIUk2cQiHjia7gufCy+ygXl40O6asVwpiwF
         jOEHJ/UxnrygMYcQ+1rT/UCg3uJ4GGw0WdUfs7NITbZ0PXJSr/eDpvbN30SyfhfLi5ik
         dhL8AENaQCXI0ohPIEBWM1BtwPzeAl6+YcJEbmKI41YSjtrx1MWUDOctwhywYpGXuh1S
         BmGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790585312; x=1791190112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3/GiZQj0CaseyrQZxOd/ioPb55nZ1v2BOlX+DpEu3BI=;
        b=f78z+neG+NfU9yyuv+NZswxwCpzJbgtIZbGZQrI8rHIvmk5czlo8xF1gft77DUP9WR
         ECsdIIXBSQSDgvt9+b9nBYk9MKkA7/UK3HosIJQXdqTmGvq7rRfhBfL6Bq8byBI1NhcS
         tBa5FXGhdkV4atA7QXVQfq0TuG/9dxF/uh6+YXaU7SI7nNdwFuYfuIqe5bVilIpUy9wT
         NVw6yiR/WcwZVQPS4nTD0szRp/Az7rI/fhQFPtd3CqKFVeD4RtRknH8ULa+idfGRGcUB
         ZAIs7xA9ma3nj0OqKAWAP0rQjo761O21GpM2PwzsWrrZDnVw8OQMIpd6UxZnPQzjr55j
         JKSg==
X-Forwarded-Encrypted: i=1; AKwUvBzWQLq7z4PVa8I9be/OmxL25wZG1vADHzVv77+UIS9dnsS0IacAeQs1ezoE/SOA7xzFlVivffipd0A=@vger.kernel.org
X-Gm-Message-State: AFuF++mOZqfBpMEO+DnsbNRvQfET9dam/O4N7n0oXQoqtVbyRXWccVnX
	eDAPxVgf5qS7orF90j5k2FijPo7eFjutoZM95bn76Rur+LahxRgm/QIR
X-Gm-Gg: AYBFou26hhBWjF2AxuzSFwj2TXu/oO7sy4nx3G4380hzJDdrlpRFXh2tJynDxRmKYLq
	Lc8fBpZpMBwOyJUfDIo7RWiuxj3EPSxxyD/mfAZz42boWL5Cw9AAfMrV1bG7lxLyvLWMh8mEol7
	asXa+Q6xMKgE11kcLHf+r0O6yypc/gWF4OZ+RLbjciMVzwhQnO/XMrxSjDuv+3fAsrLQisbEzuu
	M3nLrfudi0iC0dXg40SeAjzbgYipvIW3yu5l+JCoWu4fFXFWv2fsFe1nSNMF8mWBE5WK4xQvJX4
	7fV6UWDpDwLigv+lnEvztRkqwqffeStf62TxTWX2UuYvUxHxT5lkJ7+RKQlBCHNCnjxO+Nuyd5C
	a2csV0eYp2SwjyuziVtTLwBZVDcpGoVSoRKMXkalazWoGiqtM3f0B6mznpbUbIUrTJyZ9J2Zy8O
	AkDyPSegMoxcfp3VbLxLj9PUqnx3koyHDjMNpx6pO3Bws5IWaiKR7seydy5P9xnKriuTgp/JhDp
	MMTwreWW5R7/k7iIw1Pu0cgl73iYLD8bupTEXs5DK3q/XhEe30ejBrNyrD9NMtbIVQsdxwG5chl
	eibP
X-Received: by 2002:a05:600c:4f47:b0:49f:c199:e1e2 with SMTP id 5b1f17b1804b1-49ff06ed9c1mr189367295e9.28.1790585312467;
        Mon, 28 Sep 2026 01:48:32 -0700 (PDT)
Received: from andreayoga.localdomain (93-42-14-189.ip84.fastwebnet.it. [93.42.14.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a0017652d1sm182584705e9.5.2026.09.28.01.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 01:48:32 -0700 (PDT)
From: Andrea Parri <parri.andrea@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>
Cc: Andrea Parri <parri.andrea@gmail.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 3/4] iomap: don't lose a fiemap iteration error when emitting the last extent
Date: Mon, 28 Sep 2026 10:48:08 +0200
Message-ID: <250226e33b3b23c6b1714a45dc3c465c2a45cdc0.1790342457.git.parri.andrea@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1790342457.git.parri.andrea@gmail.com>
References: <cover.1790342457.git.parri.andrea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iomap_fiemap() emits extents one behind: iomap_fiemap_iter() flushes the
previous extent and remembers the current one, and the remembered extent
is written with FIEMAP_EXTENT_LAST after the iteration loop.

That final flush overwrites ret, so when ->iomap_begin() fails partway
through the iteration the error is replaced by the result of
iomap_to_fiemap() (zero on success) and iomap_fiemap() returns success
with a truncated extent list whose last entry is wrongly marked as the
last extent in the file.  The pre-iomap_iter code returned the error
from inside the loop, before flushing the pending extent.

Check for the iteration error before flushing the pending extent, so
that real errors are propagated and only a successful iteration emits
the final FIEMAP_EXTENT_LAST extent.  -ENOENT (no mapping) is still not
an error, and the pending extent is still emitted in that case.

Fixes: 7892386d3571 ("iomap: switch iomap_fiemap to use iomap_iter")
Cc: <stable@vger.kernel.org> # v5.15
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Assisted-by: LLM
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
---
 fs/iomap/fiemap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/fiemap.c b/fs/iomap/fiemap.c
index d11dadff82865..54b824b7edb5c 100644
--- a/fs/iomap/fiemap.c
+++ b/fs/iomap/fiemap.c
@@ -76,15 +76,15 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
 	while ((ret = iomap_iter(&iter, ops)) > 0)
 		iter.status = iomap_fiemap_iter(&iter, fi, &prev);
 
+	/* inode with no (attribute) mapping will give ENOENT */
+	if (ret < 0 && ret != -ENOENT)
+		return ret;
+
 	if (prev.type != IOMAP_HOLE) {
 		ret = iomap_to_fiemap(fi, &prev, FIEMAP_EXTENT_LAST);
 		if (ret < 0)
 			return ret;
 	}
-
-	/* inode with no (attribute) mapping will give ENOENT */
-	if (ret < 0 && ret != -ENOENT)
-		return ret;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iomap_fiemap);
-- 
2.53.0

