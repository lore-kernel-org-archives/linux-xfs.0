Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3CE28C2BF;
	Thu, 21 May 2026 13:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779368424; cv=none; b=MQatjiDXm4zlyA1YJ1KFKbPq2IXjaV7sjWteEV6IteUn50Gol7SyMgXDWU9G1dDz/5ySF1dkMq4UiL9alC3DJtrOXrk/MGgOrrAWa/RRbZrTisxzFUENpRCBMzUss+KAfRnc67wipC7zEQXJzwlIP3HV0FfJL+ms5Decdl2enyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779368424; c=relaxed/simple;
	bh=g9fTmXWgQx7/PuDf9S0UWI2714XxdBXWGdYNDI44wP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5NcZtDKiqUDjkZ8mxvYwJx9UDP08bXIgPqipL3Yva9AnwMYDxHmgx8N022E0hmJ5zpe7btw72pozsoF+YTO7/gfop985cqzQePf5GKvpD1KlpX/bphRGhlzuZOjcCYFPaX+Cz2wOIVqsUFjqsAEJk5gtaV7JMk3I5KuqUltvMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d88Cjvt8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d88Cjvt8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1987E1F000E9;
	Thu, 21 May 2026 13:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779368422;
	bh=vG/YK5moXGTayxb1rHKajaSrBu43PHIUn54D0m2olwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d88Cjvt8qxgvXtFfwcFRHpA5HeJOgJqQ4P5KqpQO6I4LCRIvxyxodJN96moevzOFV
	 MA9SRrQo6lEkCnKyNYV8xbKeDx0hXaaJ6fN6kNHoMH+NGD3/plxN9OLuuj+ye8jz0h
	 4UoKvm0SmNkAF8B+LFiJpjSuCo62ETvOZL2MrtOFhy2iqdOEhMPMdfu7vA1jB4G8SJ
	 iuUtIGUdun7NuNlhdnULFRyw/qVPwarjlqwrzlU+ajtxsD7OMN/0jKScVpGMLCPTXH
	 wrwIADoaRCgFcSGiZDIFsZ0wvaGoGoIRmBG5OUACiCcAyM7qNFQRHfyDOE1fyq098t
	 iC2/48LVPbgSg==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org,
	amir73il@gmail.com,
	zlang@redhat.com,
	hch@infradead.org
Subject: [PATCH v5 02/10] fstests: add _clone_mount_option() helper
Date: Thu, 21 May 2026 20:54:52 +0800
Message-ID: <028aae746adda2053ab618518b538b136048cc52.1779367627.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779367627.git.asj@kernel.org>
References: <cover.1779367627.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Adds _clone_mount_option() helper function to handle filesystem-specific
requirements for mounting cloned devices. Abstract the need for -o nouuid
on XFS.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 common/rc | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/common/rc b/common/rc
index a2ee23c45003..7ae9877918c8 100644
--- a/common/rc
+++ b/common/rc
@@ -397,6 +397,20 @@ _scratch_mount_options()
 					$SCRATCH_DEV $SCRATCH_MNT
 }
 
+_clone_mount_option()
+{
+	local mount_opts=""
+
+	case "$FSTYP" in
+	xfs)
+		mount_opts="-o nouuid"
+		;;
+	*)
+	esac
+
+	echo $mount_opts
+}
+
 _supports_filetype()
 {
 	local dir=$1
-- 
2.43.0

