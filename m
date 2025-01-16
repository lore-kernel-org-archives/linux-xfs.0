Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2F61F91F5;
	Thu, 16 Jan 2025 23:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070740; cv=none; b=ofNbOdWeMD9QWO8pkw7XISENOby6gGw118GYPo2nxZbuzvsJK7nbxfD88SYKRCjOkZIQrAcei5dgIS/IPOP2UAo+3oajOtDS1vDhkJ6vaL+Bi5RHtjrA4YlYeuNNB/IxQUXNF1SH1zyM1QO1j4/G/tnkRfL2ckVKdiKwDlp7GZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070740; c=relaxed/simple;
	bh=peSi/GHN0RPSpl1UkVQg33PRopVZpluEL6RXKRLjTq8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tbBQYomy4w6zfx+H6dL149JZl135+f9+JsUDNfnjPandlJiuZVtLOqff8wYrDT5Vavv1gz+r4oWo7fozP+JGSmtjEATPSNlsTXDl2fKlHceCvCC47dY0qlM9TAnSQEL9zaurNmw+339gDKsc8PWhi3Ob6YXJxwxSRPwwvFtoFpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ikHGW6Zi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ikHGW6Zi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D59BC4CED6;
	Thu, 16 Jan 2025 23:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070739;
	bh=peSi/GHN0RPSpl1UkVQg33PRopVZpluEL6RXKRLjTq8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ikHGW6ZiFm5SPkRMUFokXQhGo+IsRDlEE5zEC84EAqk0IDwlwcgzV3cQ6tR9ZCSL0
	 QJlLwKDGiZe4nKdcGXwqA3cJSNY43L6obzZB2GDvqm7Hq3MzSTb2Y3ftGLYinAw8px
	 l6cBS7pOl/1NGM5Rv0AHHb0Oku2uxi0exuVLa6KXYawmOwW5Iu73d4dU2Rl3hDDso5
	 PsUTWj+kQnODmJmHTHjCxzu4Aa3s7DXqcnPd81oslyFgHFs6Q8AQclLQOD2rejDdb8
	 Dvs4gbSukEDBDQ7HKrx8VERcIj86+s2c+Wmh6f4VixWSI6s+iiVogtSLIv4h+DMeS/
	 ceiaW/t17OBQA==
Date: Thu, 16 Jan 2025 15:38:59 -0800
Subject: [PATCH 1/4] xfs: update tests for quota files in the metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706976657.1929311.11925303799347881958.stgit@frogsfrogsfrogs>
In-Reply-To: <173706976640.1929311.7118885570179440699.stgit@frogsfrogsfrogs>
References: <173706976640.1929311.7118885570179440699.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Update fstests to handle quota files in the metadir.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/xfs |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)


diff --git a/common/xfs b/common/xfs
index aa635f8b4745fa..0f29d5c5a6b963 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1973,6 +1973,24 @@ _scratch_xfs_find_metafile()
 			return 0
 		fi
 		;;
+	"uquotino")
+		if _xfs_has_feature "$SCRATCH_DEV" metadir; then
+			echo "path -m /quota/user"
+			return 0
+		fi
+		;;
+	"gquotino")
+		if _xfs_has_feature "$SCRATCH_DEV" metadir; then
+			echo "path -m /quota/group"
+			return 0
+		fi
+		;;
+	"pquotino")
+		if _xfs_has_feature "$SCRATCH_DEV" metadir; then
+			echo "path -m /quota/project"
+			return 0
+		fi
+		;;
 	esac
 
 	sb_field="$(_scratch_xfs_get_sb_field "$metafile")"

