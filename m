Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6693126B9;
	Sat, 25 Jul 2026 07:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784965182; cv=none; b=nk9/8bBa+sfWg7tSL7DzT8KJ4gS74Iq1IXi+G12jexjFUdAd0DcfRiJLdGa7VfWt4AbhyeNHj0tPA0Jqm7pwhVJSq/7i/STjToksXOefmZmJ2S/9fPlww+f6Xdv9OuVHmfEohleVzIVjhoVIG/ZD1iwIz4TEqczRc4KLrU/oiH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784965182; c=relaxed/simple;
	bh=wAHYRgzcOUADN2oUBWJSltTXcqcbhiFPn2UKh9mlBbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozGbbyApFyrZ9S2k67E4X8f5fAIQKozyWQkKONoVwy7ZKvYdPzSOHdRsprSGoWaAEZ6IR7sU3d7C52vTX62hzvh3Hn+9SYbiILtoFJrHx0T8o3Cp7JJeMs6ocgs0yRVTuVios+kbpfKaw698R1V6y83JFBOdXAajsqstiITBV+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TpbBYwjx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TpbBYwjx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7EB71F000E9;
	Sat, 25 Jul 2026 07:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784965181;
	bh=sLqlpYfUqqnUXzeM6LLwXu0zSUkOzx/Ofan0xuQplQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TpbBYwjxPGfADkXxk5469TxW8zfvfEKLdVGQDvUyxmKPL3ZU6nADeyl5k819QBZE7
	 ObVZN1la+VUDtK5QgSrCGk4/77LrZq71nsQBnmKF5l7QSakVUdY8X1P8JMWExL+rzP
	 vxpLM9GxygNfW85XZrCRc9baQTNJWbfIEgsh53g77UlHdvGkNZpwLfxxbOSERZ4lly
	 sUtSiDqYe9uyrC1X+mMhHP/t0hej7VEhD4j2bQopWR0QgC0+eUm/RwMGYnYb5aQkKs
	 P/C82IegjI9+qsw4vtZF0P16NkD7tABPil8QCWn7kWPTYfZN0furc69mvsR0AgiS+f
	 aJpxVJKQRRLsg==
From: Anand Jain <asj@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	zlang@kernel.org,
	djwong@kernel.org
Subject: [PATCH v8 04/13] fstests: add _require_fanotify_function
Date: Sat, 25 Jul 2026 15:39:01 +0800
Message-ID: <d8fb7f5c0d67cf01249e8fc4807e963cc1a353d0.1784949155.git.asj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1784949154.git.asj@kernel.org>
References: <cover.1784949154.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fanotify support may not be compiled into the kernel. Add
_require_fanotify_function to skip tests when fanotify is disabled.

Signed-off-by: Anand Jain <asj@kernel.org>
---
 common/rc | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/common/rc b/common/rc
index 53e5d9d43af6..21b516accdf7 100644
--- a/common/rc
+++ b/common/rc
@@ -6329,6 +6329,13 @@ _require_max_file_range_blocks()
 	esac
 }
 
+_require_fanotify_function()
+{
+        if $FSNOTIFYWAIT_PROG 2>&1 | grep -q "Function not implemented"; then
+                _notrun "Need CONFIG_FANOTIFY and CONFIG_FANOTIFY_ACCESS_PERMISSIONS to be enabled"
+        fi
+}
+
 _require_fanotify_ioerrors()
 {
 	local x
-- 
2.43.0

