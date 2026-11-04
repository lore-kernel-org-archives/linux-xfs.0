Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793818085;
	b=4ZMTkMUe2IXDIMGYBl7nX+4FRMT/XaCrWl0qs6TzpIaeK4tGc/4xzp7299SJ1aLnX2Wd
	 rWkhkfZrwyaCYOrtR7mqpLjy/pUqSlovYy0IEl/gMuzm9Log4WCHurvSRX1kvplI5hYKe
	 6eRGp2vMgXxqz2PMzhNvFGefJQeGWZn7litsqg4LJoWDQovoEE0GnYqUCzTnFnbDlPj1R
	 Eh5lqPXb3wwg6aKRLohxgBukFMWOY1hFeChTHQiMdRvAOWkdqy3uUUQpZ9M2aOoWWbK3K
	 N5NDmJ/ami4keRYd+LYlDsZIdUHLhCNiQcvuFNG0NqMR+oApaW88oEPHNjzdKqxECLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793818085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=piTRSwW498KP64b3vfsBfh6T+tdP3ME+PlOqF83q4q8=;
	b=JjOoU2DT+Gns2uOnhjZ0VRkut/spedxWKRx8D6ehIRa6mPWOEGDO3w6SFh2tI00CW347
	 l9/ti+H8hlaolEqjSYXJSB2kaElRnvkByUNd4xPOk3KP9AkhZfynkab4/qJQFs8m16A0Y
	 98sor5GB4hjJKvm0KGr5Z5nIlBbXNCs/zxwL2fIS0CpoansmozI2sS9NsCl/j64plncTm
	 m0mMLP/x5fmcFT4bzBcqdQvVmLEvF88JkrG3lRvlkimQSbchyFyDn3cbtHOJk/UFff8k5
	 nljls5jAujT/Xue/xwCfvjQ5nQhE3a6+ak2+jUWDlhRLL0ziuDAJjbAfMEZAlspWfYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TtQkTKqs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BE6606A326;
	Wed,  4 Nov 2026 18:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TtQkTKqs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739071F000C1;
	Wed,  4 Nov 2026 18:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793818084;
	bh=piTRSwW498KP64b3vfsBfh6T+tdP3ME+PlOqF83q4q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TtQkTKqs7ykU3CFtSQf5LC4RF9mfAfoStQ6xShkuBXQLu3AqX8QBHt07Naq9qoZtI
	 EO0lAf76K/diM5Q2YG7SqtWJ4Y2Lok/k2E4TlHR9G+2QXScT561ciG3M6/YU/75Rcr
	 2GGEaMYvn7Ydn2cjZVwqV81IY2P6TRJSWikuhdfB3kw+ps6QCCNYxWFUHbDX3lTyv0
	 LB5cDrjxx2/C3xhcJ9cAoLyptL0UN2YoMcxAoqBqfZyqPw7peXyg4CWS/F8lMb3Pi/
	 jQTD2DN3JdTl0tVv8M8S3YV9vI8ad0pjOqzZatBH2x5B8NgtK7svQU69PN6dNAmlQ2
	 A1l0BCyZygG5Q==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Anand Suveer Jain <asj@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v3 5/6] common/rc: use common helper in _require_fanotify_ioerrors for f2fs
Date: Thu,  5 Nov 2026 02:47:35 +0800
Message-ID: <20261104184736.1564283-6-zlang@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104184736.1564283-1-zlang@kernel.org>
References: <20261104184736.1564283-1-zlang@kernel.org>
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

The f2fs branch of _require_fanotify_ioerrors() reads the raw
/sys/fs/f2fs/features/fserror path.  Use the new
_get_fs_sysfs_feature_attr helper instead.

Signed-off-by: Zorro Lang <zlang@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 common/rc | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/common/rc b/common/rc
index 35f5d21e..a8d3c3d8 100644
--- a/common/rc
+++ b/common/rc
@@ -6360,8 +6360,8 @@ _require_fanotify_ioerrors()
 		test -n "$x" && return 0
 		;;
 	f2fs)
-		local feat_file="/sys/fs/f2fs/features/fserror"
-		if [ -f "$feat_file" ] && [ "$(cat "$feat_file")" = "supported" ]; then
+		x="$(_get_fs_sysfs_feature_attr fserror 2>/dev/null)"
+		if [ "$x" = "supported" ];then
 			return 0
 		fi
 		;;
-- 
2.56.0

