Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44705244692
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2026 04:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780376379; cv=none; b=gHQdgr/pnCSwwTHZoYPr2mmA4OjDvwgUDBLk5I/L+UT28CwY/0cHgGqodWAVxSa+3EEzJOKMUj4JfMyct8o0ytS0iYnfXLqS6phJNyTTSkifbzbcS3MMT8KfBIpOYPBJR+QYml5pkVO08OoLpKaiiEa65F9dZJiuJrdPz4tLQlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780376379; c=relaxed/simple;
	bh=8gcnwUipJ1pafk7bLb4WPJWtAqJxv3z7hUrTqs2YOgc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HjyMlOz/z0/gWBe1jb5T0ii0xTJCSIZ9e73Xt6LP+CULbHsI38qCZmgyqBgLIb1zZIsKVxmVrKSepFkFLVrRzY/07ZYy7R/A0XXorjbNfoIIGaht+O+vjlRgprk4wBGj+VwivNRkP/zmxLrZRmluGxPyJsWMoyBiweoIXwriD8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZNoqUuU4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZNoqUuU4"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D731F1F00893;
	Tue,  2 Jun 2026 04:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780376377;
	bh=Y461o4n0WGlW3lAPIR4b0KOKxsW0WX9wpSKsP4MQnFU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=ZNoqUuU45VR9GLeL8JLh0fgRS9TqWH47ZUgIOnIzhWNmoRP2a4g+byK+MGKBHisjp
	 uRbFq0mItLjDPh5v8g9PZeYuK5uwoc8YJxXV+0dUaQ1ZcWTlJYtq5eBcvMpOyZ2fh7
	 MOazzOSi+IcL5Zb2qq8jGI3Zu/P2oKX07d9oi2zrXdUedApB1vd9BFxrr8pHfY/RZk
	 GrxLl4TL8GGjByB2RtsaIlt2I9z0qLnYYXz0WXgaMYpdTbP0I9T+TlaM2eOgmGKZTr
	 zUIjcqGc0L6VBMaoOJO78U32/XmrKlgEr/keDo8ABSSt8dxLnpedeDP/Vi6n+Vlb3W
	 oye6PQ7n6VN5w==
Date: Mon, 01 Jun 2026 21:59:37 -0700
Subject: [PATCH 6/7] xfs_healer: don't leak wh->mntpoint if fd_to_handle fails
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178037627154.588879.16839468479313253315.stgit@frogsfrogsfrogs>
In-Reply-To: <178037627011.588879.6129023788062831734.stgit@frogsfrogsfrogs>
References: <178037627011.588879.6129023788062831734.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex noticed that we leak wh->mntpoint if fd_to_handle fails, so fix
that leak.

Cc: <linux-xfs@vger.kernel.org> # v7.0.0
Fixes: 6f0f35a87c8797 ("xfs_healer: enable repairing filesystems")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/weakhandle.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/healer/weakhandle.c b/healer/weakhandle.c
index 506689aa77637e..6c0dbb301c4f7d 100644
--- a/healer/weakhandle.c
+++ b/healer/weakhandle.c
@@ -63,11 +63,13 @@ weakhandle_alloc(
 
 	ret = fd_to_handle(fd, &wh->hanp, &wh->hlen);
 	if (ret)
-		goto out_wh;
+		goto out_mntpt;
 
 	*whp = wh;
 	return 0;
 
+out_mntpt:
+	free(wh->mntpoint);
 out_wh:
 	free(wh);
 	return -1;

