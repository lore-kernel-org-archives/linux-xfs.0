Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792787499;
	b=zAqhV9c5Pk89UwG/QRkMpTWJ5kqhfHN22tPhqK6NJw2jmJZ+bQkNaDG0nyzadcHwVUC6
	 JFVAkTQlvTdvNfHJTwC5VxsnGogQVoAhQMbRrCaNC8JW28drxKvFCgJsbcMeF6tZz5CFn
	 8QI8KRviqGFve0BcBvJG02jeFUSfpsEN4Hh/Yddp/JKr4RR/PrSeD71sEaCXgjVLDM3p1
	 ZiqUssMB6j5OWhTF+FGNhIPwNZ890ckvhzfLU2GAYW3xR0675VYnm2RAEat2FdmXNMlwn
	 cu3HI1vCaRc3DsPGsQefq+MXI+KObE5F8BPoC5yPNCgNrdrEY8AVZYN5MXSGrn7NB4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792787499;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=rmRPKAg5VFswYwp+gGOlEkGRKJI4lVhzJ3Tv6W4jknI=;
	b=1E9Cotou5O5nMf/EHcm0EGcs6tlm4lGaxg+wKLLUxEglMD82Ni11f3i/zkm0A8p6BSyo
	 zNaSOIk4Ve1zeOxQ40+RD+rI0Le+ya484UGeiSJi5a4uhr+TnGBPMlANw3zX6uyohnTlM
	 LrVlEsZ+p0dLex6K8FxGN/OGsSYjfXDb19tdiP/7okLym13niN4bMkC9xB0jseB5mc7hP
	 9AbaOEDkQxNIhoW7oLxslqgEd8a22Rc+fNLnPNSMl6ghSmZY+4cC0MO12HaP2O7gzAKIv
	 sN3b/WbPksG0z5VhXb4YsUED+B156SELyksMsKoWHZ1zStb6wHeM9p7LUtE+vG1tUsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nxXrP0kz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E277606A323;
	Fri, 23 Oct 2026 20:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nxXrP0kz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D201F01828;
	Fri, 23 Oct 2026 20:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792787499;
	bh=rmRPKAg5VFswYwp+gGOlEkGRKJI4lVhzJ3Tv6W4jknI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nxXrP0kzmcr6GRJax6PCD4qqj3i3fyMKyXprW/zpEFIvUYH08SSqZnaC4t4MpPUHt
	 hmx6U4FNgnFCN0+9J9Mva3Zf9aAbl0uHyTYvMXddWRT63mw8yit74dCA+6JRlqNsjW
	 OO+Qncf+JXhGdgOlov2/ko5QjvT1USD3emMXExpTI8ibigVSFsjjRHAB54sHjR0xUR
	 352nRnSs/QqOxG/hYp6f2FTNtseJPpfIxvJcamDKXOhLVAqwLEGaRug/OTOsda5TIl
	 TMT+A10a1y/X1A5cdqPgmyuxLTq3ZeUs7XFcjaIr5fxxjCqNuzpc+fLyl04oNWq9vZ
	 yyD0RuYC3Ewgw==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Anand Suveer Jain <asj@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2 5/6] common/rc: use common helper in _require_fanotify_ioerrors for f2fs
Date: Sat, 24 Oct 2026 04:31:13 +0800
Message-ID: <20261023203114.1655019-6-zlang@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261023203114.1655019-1-zlang@kernel.org>
References: <20261023203114.1655019-1-zlang@kernel.org>
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
---
 common/rc | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/common/rc b/common/rc
index 67a64a09..66a4209d 100644
--- a/common/rc
+++ b/common/rc
@@ -6344,8 +6344,8 @@ _require_fanotify_ioerrors()
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
2.55.0

