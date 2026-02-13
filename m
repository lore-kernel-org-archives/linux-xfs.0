Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5843A2727F3;
	Fri, 13 Feb 2026 07:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770966123; cv=none; b=XUel0W+r7y5ZziD3WhYAIvpQ8MFKDgAmBCkYmrQUT9jZWkafQ1C7gzQdtgEuTbIRnWCO8zGTy1KNYOdfqtyxlU+PfP5ANY2e5xQsN24asf7LfL6PADZshN7SNq0XRsh4K1yDUH9UMl6l4LkTYQ+sE+QMWLwHWJ3+450EkswK5FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770966123; c=relaxed/simple;
	bh=iSIy7NAJPrjEdPcd4UeTXpoTl9zgTJT/95A9CezpxzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0w6lzjPpmpG2ZRHQsCs018l69wNee4+3647YbpRGsP+M/rOqqddENfscbA1LrL21NhnkPnoCxiHywL7gHrJ5A5e/GkyfYe9fFG70bJY4BsNHiKKdnGpLClKW+Y3VMh0CAaX2nbf85U4tYBVhoTGoNj0i4GGHrdvb5LM2o9S4PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=TaHzIaUe; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="TaHzIaUe"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1770966122; x=1802502122;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iSIy7NAJPrjEdPcd4UeTXpoTl9zgTJT/95A9CezpxzI=;
  b=TaHzIaUeUwBgMd2fghYkWLMUkn3JcPIavoWHS5KYh5jZCPB+8KqA7Qqm
   U+4A2Mll36jIHojBeF971rir28JrJKZvOzzf2/5fdfCAJiOVkNd1yb5Qd
   b88kd+i6/OlUkkR1dJ2q2ntN8P4Jk9sBFp8Duz4YAuq4KEM8IWoKa3TCq
   dJVbzgkVvX6H+8jhCBJ3yYA1wV87k595jmbUwkpVKu9Mf/HQaHSV8OX+h
   XXNibB4J022Ia2c43SACOiHPY6zfdP4fyzgksHvejC/VC6FBEiQGeQaJs
   iuQLWa8Abj2jPPECGl1On2hKRTFD97wjQ0GsCsrvVptXX31xSImMTNaEf
   w==;
X-CSE-ConnectionGUID: OeL2+lq9ReqKfwiKzoV6Iw==
X-CSE-MsgGUID: y4Nec5deRqyR6Eq+HUb93g==
X-IronPort-AV: E=Sophos;i="6.21,288,1763395200"; 
   d="scan'208";a="137154152"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 Feb 2026 15:01:56 +0800
IronPort-SDR: 698ecc64_+RgUFSjR3mJ3TgRdCF5/pk9zZ6MNitzjRdx4gfYCDYrUaaO
 cOvpCOWQgRAL20IjfVkVyk0xwqYogSYoIePbQiw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Feb 2026 23:01:57 -0800
WDCIronportException: Internal
Received: from wdap-yooxex5p9f.ad.shared (HELO neo.wdc.com) ([10.224.28.126])
  by uls-op-cesaip01.wdc.com with ESMTP; 12 Feb 2026 23:01:54 -0800
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Zorro Lang <zlang@redhat.com>
Cc: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 1/2] fstests: add _fixed_by_fs_commit helper
Date: Fri, 13 Feb 2026 08:01:47 +0100
Message-ID: <20260213070148.37518-2-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213070148.37518-1-johannes.thumshirn@wdc.com>
References: <20260213070148.37518-1-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new helper `_fixed_by_fs_commit` eliminating the
 if [ $FSTYP = fs ] && _fixed_by_kernel_commit XXXX YYYY
pattern.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 common/rc | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/common/rc b/common/rc
index c3cdc220a29b..7adc53045be0 100644
--- a/common/rc
+++ b/common/rc
@@ -1898,6 +1898,15 @@ _fixed_by_kernel_commit()
 	_fixed_by_git_commit kernel $*
 }
 
+_fixed_by_fs_commit()
+{
+	local fstyp=$1
+	shift
+
+	[ "$fstyp" = "$FSTYP" ] && \
+		_fixed_by_kernel_commit $*
+}
+
 # Compare with _fixed_by_* helpers, this helper is used for test cases
 # are not regression tests, e.g. functional tests or maintainer tests,
 # this helper suggests git commits that should be applied to source trees
-- 
2.53.0

