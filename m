Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=96.67.55.147
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804480;
	b=AfZ0Jnbr0YYT8mGEYCLIVKpHHR1mED6s+WT68liolF6Vknt9/eDoIjz/USNdgk3ag522
	 lu9wALouTiZX1pY0TnO6A9NQRnxES34tnIcMXHFKd59a8z79BviJ4ZNq1dv1+Ji0GbIlb
	 h9h/NVJirkx0VpReg7PCF63phYAJf8qi672wXYSwqw4Oh/9CdNZuYCwE7L3Wc9rzmtNE3
	 6bJ0XNuzPm9y3X/aNqfIO3SAdZm9hlNv6YdQoHJ2trQcxC7KY9vp32R9XO5V6D0igydHN
	 kTUTqyuPAwXYdH0e0CDDzWcWhz3drSxKG37dOSQTe0Fm9ArwGZEwMPNI+xssu6o6DNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804480;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=RTCWGHjaF/Ld146pWyWxphZf6onDLp8uBS7oOvthXlU=;
	b=P2GL0kuo+L/T+ePLYytpMuNj+7mLZ9BZjJc7wDP/wjPXQO+9c6olv1cZhKddd7eMho49
	 AbuviySdHXsdmcQHO7wb0VmnJahYkJeW8o+WmRjHTWB4mbWEfYCUUy6FzRxUOQQuRrqnl
	 F16HDqJ6KKTPFkXjXthv07sJwGtOL6endxiZcsj/SAFer4feCfnk9USImOi1Ou1hofuzL
	 sMIy1O3+G2W04Ogb/Z49TQw9iHFEMbX2AsduqOv5KWBAXgwPGrrxOdjsfdZ/ZvM2OPoyX
	 DHeqcimvmXeJkqBD3GfXFo+FZEnRzOmEzooZgWEoOupbbZm3S18SbR2Biy0TE5oG82w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=surriel.com;
	spf=pass smtp.mailfrom=surriel.com;
	dkim=pass header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=ULGUO+Em;
	arc=none smtp.remote-ip=96.67.55.147
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5689606A31B;
	Wed,  4 Nov 2026 15:01:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5689606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=surriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=ULGUO+Em
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References; bh=RTCWGHjaF/Ld146pWyWxphZf6onDLp8uBS7oOvthXlU=; b=UL
	GUO+EmZTRYo4C619wE8rh7yBIQzPYZztFinuvmsOkxc8BAoJhTFOKpZfNbFxvYtDuLhiuO/4m1CjG
	bqGE/uRNxixbFfrzEbK+e5vLm0b44b12BzQrzFalUVWvXMFnZI8OfD1WTjDJG0/kpCHi6SviyOX9n
	LW8XiFlbLgxL+L5VJwr52KZ1BN0xJa5E6B/qSkrrFoHec0NNVdlo0OaIZvbS17b0TpxJy/dJ2XpFO
	7FXXpD7NdNGwE6y7Mvmwg5AdLoxUpOSNEaLHrB5o00SXcp3BVrCSOf/yl0xXBRndiHz84RuFyee78
	tIQdHNHmiz8JV7lh2/GPXZX2kNH8aiig==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219] (helo=fangorn)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xOcUG-00000001zrN-1aX5;
	Wed, 04 Nov 2026 15:01:16 +0000
Date: Wed, 4 Nov 2026 10:01:15 -0500
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>, "Darrick J.
 Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
 kernel-team@meta.com, Christian Andres Saide <csaide@meta.com>
Subject: [PATCH] xfs: keep successful near rt allocations
Message-ID: <20261104100115.36bf7d28@fangorn>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

XFS realtime allocations first attempt to allocate space near where
other parts of a file already are. If that allocation succeeds, it
does not have to do a global search for free space.

Unfortunately, a code cleanup a while ago causes xfs_rtallocate_rtg
to unconditionally do the global search, even when the search for a
nearby extent has succeeded.

Fix it by running the global search only when the near search did
not find available space.

Found by noticing higher kernel CPU use and examining the profile.

Fixes: fd048a1bb391d ("xfs: rework the rtalloc fallback handling")
Cc: stable@vger.kernel.org # v6.12
Reported-by: Christian Andres Saide <csaide@meta.com>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 fs/xfs/xfs_rtalloc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 84efe5a8fb11..31d90828b4e9 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1997,10 +1997,14 @@ xfs_rtallocate_rtg(
 		if (error == -ENOSPC) {
 			xfs_rtbuf_cache_relse(&args);
 			error = 0;
+			start = 0;
 		}
 	}
 
-	if (!error) {
+	/*
+	 * Global search, runs when the near search did not find space.
+	 */
+	if (!error && !start) {
 		error = xfs_rtallocate_extent_size(&args, minlen, maxlen, &len,
 				prod, &rtx);
 	}
-- 
2.56.0


