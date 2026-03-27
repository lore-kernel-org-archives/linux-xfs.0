Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FDC226CFE;
	Fri, 27 Mar 2026 12:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774615078; cv=none; b=Ma5xx+WNPtcIdr+Mrfr2LkcBGqKGQJU6xeyIgr29lmm30kw3wQGN0ERcTF6vgkYyANBX5mZm6LKwRAQLV6A45AEf7kWiFX9yVdINaaAJAv2g9RxDXFlQA/+l+f6hUl0c8LzQHjM9QEn0ezqSgxWE2R8Qj4wkUYvt6TFKZogFeUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774615078; c=relaxed/simple;
	bh=TysAxCSUeDQZ2qB7gZliYIvx9LPnNICOSsnrEr9/UYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7htWCqzfSYZEquFKKIZRjbHRl89je+NHra+FiORQ5QJueqMF1CTk6pvSVRywwGaIMe39f/RmzOfYEWwn/HWKgjWjXzcC4PjMicwfP8XjkqskFG5YK9Zl1RlRO4hzOkZxxmiwT3H4C144XSXpRsDkdZyWM0ch5djrNj5af1YkOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=F48tIZ0k; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="F48tIZ0k"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1774615076; x=1806151076;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TysAxCSUeDQZ2qB7gZliYIvx9LPnNICOSsnrEr9/UYw=;
  b=F48tIZ0kUBVWpeQE/DlJFzKUmPi2R1fXXHTAReVGr7MUt1X3bCz+pwdk
   7jo0paEI3sg+qgtvR/oe+0BaER3sV+P3zuGjGeQ8y2hjCkH6JI72RH08C
   fId9VcbDBmyMmAm0/r06Wpyam9SebhtdnbVo8x3Q2fIPcTK7LPrw6O9Uv
   /tZPaB33VgNhu+cJ/RS4TRvoc6RVpe+2N/RebYnGozP1X4EzZ6kpobVFi
   B/Ui2d85xsBc/dqfyQn3UB4dhDEPmBhNkxUxU/Ch0vocjiDU33T7u73tD
   PsnGPWrUwvBXehWWB1pr808ubHrX72Vy7fDakFTZcpMmgXRRA0N7iezrl
   g==;
X-CSE-ConnectionGUID: JzYG7nyKQkae27H+K9b+kw==
X-CSE-MsgGUID: jfDcldtfSvGdUbRv5y2FIA==
X-IronPort-AV: E=Sophos;i="6.23,144,1770566400"; 
   d="scan'208";a="139679418"
Received: from unknown (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Mar 2026 20:36:52 +0800
IronPort-SDR: 69c679d3_OUN+1ylVIbxDDFHBc23iBOG8uyLuwdudq+fAYKktVFNMk2N
 eYMY78wwbtEmcNCmGqJZX88i4VbEJPyvvhu6SBA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Mar 2026 05:36:35 -0700
WDCIronportException: Internal
Received: from unknown (HELO gcv.wdc.com) ([10.224.20.49])
  by uls-op-cesaip02.wdc.com with ESMTP; 27 Mar 2026 05:36:33 -0700
From: Hans Holmberg <hans.holmberg@wdc.com>
To: zlang@kernel.org
Cc: fstests@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH v2 1/2] xfs/647: turn rt dev block device lookup into a common helper
Date: Fri, 27 Mar 2026 13:34:28 +0100
Message-ID: <20260327123429.39330-2-hans.holmberg@wdc.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260327123429.39330-1-hans.holmberg@wdc.com>
References: <20260327123429.39330-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Turn the logic figuring out on which block device the rt data is stored on
into a common helper.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
---
 common/xfs    | 11 +++++++++++
 tests/xfs/647 | 10 +---------
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/common/xfs b/common/xfs
index 7fa0db2e26b4..c81f939e68d2 100644
--- a/common/xfs
+++ b/common/xfs
@@ -737,6 +737,17 @@ _xfs_metadump_supports_rt()
 	$XFS_METADUMP_PROG --help 2>&1 | grep -q -- '-r rtdev'
 }
 
+# What block device is rt data located on for scratch?
+_xfs_get_scratch_rtdev_bdev()
+{
+	# Is the rt dev internal or not?
+	if [ -z "$SCRATCH_RTDEV" ]; then
+		echo "$SCRATCH_DEV"
+	else
+		echo "$SCRATCH_RTDEV"
+	fi
+}
+
 # Snapshot the metadata on the scratch device
 _scratch_xfs_metadump()
 {
diff --git a/tests/xfs/647 b/tests/xfs/647
index 76959b28c779..0ef340a14b07 100755
--- a/tests/xfs/647
+++ b/tests/xfs/647
@@ -17,15 +17,7 @@ _begin_fstest auto quick zone
 _require_scratch
 _require_realtime
 
-#
-# Figure out if the rt section is internal or not
-#
-if [ -z "$SCRATCH_RTDEV" ]; then
-	zdev=$SCRATCH_DEV
-else
-	zdev=$SCRATCH_RTDEV
-fi
-
+zdev="$(_xfs_get_scratch_rtdev_bdev)"
 _require_zoned_device $zdev
 _require_command "$BLKZONE_PROG" blkzone
 
-- 
2.34.1

