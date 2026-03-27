Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB7F86323;
	Fri, 27 Mar 2026 12:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774615076; cv=none; b=VgryqU3dcye0QeHW9JMT1mWLlrGCT0lvngaS5PoIDqbMBT7t4d/nDfXiBsDkKQCqcubunmRsglYyKzOQxplfIKmXifGAo1r6KCDAa059XavYw0FroSLuN+1YzNiFAwuF6ipyEjP4NQGvH0mDOs0U8HdeqWIePp6YiCpuxC4fnmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774615076; c=relaxed/simple;
	bh=/duEzlbLlWbaNFl7B2ctZCRDyG5Kb/EZTQqNb53lfyw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kk7+/yYDJupDIQnz0qrpQBesiCVg9IrOTeKsUSjOFLG6XRYND4jKU77IqoL+aJmqp7uK9ZolzaGkSbA+q34yshm8KVzCoBXFsocgpoWoSPhFs/eMKyNQs6OkBhRwP8aU6+WGtx/qwop6DrBkQl88AK563Ik+kT22Sng/w/Y9Krk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=H4kWK3Fj; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="H4kWK3Fj"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1774615075; x=1806151075;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/duEzlbLlWbaNFl7B2ctZCRDyG5Kb/EZTQqNb53lfyw=;
  b=H4kWK3FjGnyFOHHZHq+vg26YPUyMpslKdj2sO9Q4gQTpKvmvtutgAlIM
   8zZkpJ4w5YIpdWCRJZOHnaUWr5luIzyvjuouLUZO6RBhm4nOvchAOC5n0
   N5AdihtfeMYVq0+eZ7N+Zc+G2xMrBGlaQhp4Ed6lVAsghLLVmvdk8btI6
   g/3/QpB/citYWgLl1SgSrEcU7Ar2lX+lEgtZ1nekSWfUnDseMOI0NKB0S
   gN5cbEkLknG1/E5mtPBYshaAXBp9TpG8LzgsnJimQdRpgkghZfB5Cvpau
   EuQBVd8QKNFikR4w0YREbCfXpmcFVt7EJ0Esj/kRgjRSB1cAovZhGaWi9
   w==;
X-CSE-ConnectionGUID: kJJzRfp+QAqTuKeZanoKdA==
X-CSE-MsgGUID: YkJGiOiAQT2HRevXhflrDQ==
X-IronPort-AV: E=Sophos;i="6.23,144,1770566400"; 
   d="scan'208";a="139679417"
Received: from unknown (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Mar 2026 20:36:52 +0800
IronPort-SDR: 69c679d0_dVwVmHjk+vXE/MLOCzUaesIL1/456bDx/z90Nc0DSQC1x20
 cJfu7gZrReRuFjN2+fwcRNr/BrjCKeZ97wIaQMA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Mar 2026 05:36:32 -0700
WDCIronportException: Internal
Received: from unknown (HELO gcv.wdc.com) ([10.224.20.49])
  by uls-op-cesaip02.wdc.com with ESMTP; 27 Mar 2026 05:36:29 -0700
From: Hans Holmberg <hans.holmberg@wdc.com>
To: zlang@kernel.org
Cc: fstests@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH v2 0/2] add test for zone_gc_low_space attribute writes
Date: Fri, 27 Mar 2026 13:34:27 +0100
Message-ID: <20260327123429.39330-1-hans.holmberg@wdc.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Adds a test for zone_gc_low_space attribute writes and some helpers to
go along with that.

The new test will fail currently, but i've submitted a fix:
https://lore.kernel.org/linux-xfs/20260325124312.26349-1-hans.holmberg@wdc.com/

v2:
- factored out useful helpers to common/xfs
- style fixes suggested by Christoph
- added a check that the scratch rt device is zoned before reading zone
  capacity

v1:
https://lore.kernel.org/fstests/20260325125013.26631-1-hans.holmberg@wdc.com/

Hans Holmberg (2):
  xfs/647: turn rt dev block device lookup into a common helper
  xfs: test that zone_gc_low_space writes start gc for rw fses

 common/xfs        | 28 ++++++++++++++++++
 tests/xfs/647     | 10 +------
 tests/xfs/999     | 72 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/999.out |  2 ++
 4 files changed, 103 insertions(+), 9 deletions(-)
 create mode 100755 tests/xfs/999
 create mode 100644 tests/xfs/999.out

-- 
2.34.1

