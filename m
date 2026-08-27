Received: from proxima.stupidest.org (proxima.stupidest.org [35.163.12.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930AD3AEF46
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 17:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.163.12.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788112174; cv=none; b=ArHg6FuDf8EZYx7AXbwSirHvbIfLPyBMfZAyxVeAV9VQExteXwoxow5tj3oBtlUAIF/GLo1rdIobzzHkx9th44KyC/uYR3EnQ9SMp+z7QcfRM9gGY8gCU743K7GCTWHR6ztM/1jO6POf70RXJi6M5iaokJk2YhtorkfX6I+hN0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788112174; c=relaxed/simple;
	bh=tgPMfzIX/q41pXxLbtfWb6YoTTFr/UCzEnWwz9AD5ws=;
	h=To:Message-ID:In-Reply-To:References:From:Date:Subject; b=JGzLeXyV3KDGLjeVLwI0pmRvDhk53X3qRCTk/a0vVNI/aAbLGBhbvHdYZ79VkDTy2J4bi5dKo2B+iSQhq3t1eP+fcvmyegnC/LojKB79PZ/uGGZpvZA+2bb9CpwAZQUhTiYe1wMoEJAH1RBQ8FifQvWWmC0efMakOFRonnW0BL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=f00f.org; spf=pass smtp.mailfrom=f00f.org; dkim=pass (2048-bit key) header.d=f00f.org header.i=@f00f.org header.b=Lp5lkpxf; arc=none smtp.client-ip=35.163.12.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=f00f.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=f00f.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=f00f.org header.i=@f00f.org header.b="Lp5lkpxf"
Received: from aether.stupidest.org (unknown [10.0.1.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by proxima.stupidest.org (Postfix) with ESMTPS id 4hY04W5gNzz6m9
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 17:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=f00f.org; s=m2016a;
	t=1788112171; bh=JTbJCwtzo4u6cQVVS+uyOSV++n8LvwQKR4omHUxzMB0=;
	h=To:Message-ID:In-Reply-To:References:From:Date:Subject;
	b=Lp5lkpxf4X2lU2ZRXhZyrOc7Rat6w7PZka9a0yehVJ6R7XXnz0EKiYKsSoCujkCRn
	 YdA3n3pcppdsKiE+GlM5lDvJVLuihKR2YJ259PtpAwRq9z2KzDzSdl0L0HlHZRBTox
	 sxGAeCxTq6bKTk4gdA66El9OBY6Dpgr9oc2Ki7OHSFdoKe3/8CtlqC+TtXcDehxMt8
	 A0Hf22ElLqxSGRsdRGLhcCzhkTUS3UZapQiDecojX8cCnJTTb0YAE9+4m/HR+ileOx
	 +IqMlvxrBWBEJacfjiRSna7W7bm+mV2Uz7PvERRrbj+ZBmbreL5h4CmHgNKQsFAQJs
	 b4D/7vY0fjqBg==
Received: from stupidest.org (unknown [172.31.255.110])
	by aether.stupidest.org (Postfix) with SMTP id 4hY04V1nXmz9KQbD
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 10:49:30 -0700 (PDT)
Received: by stupidest.org (sSMTP sendmail emulation); Sun, 30 Aug 2026 10:49:30 -0700
To: linux-xfs@vger.kernel.org
Message-ID: <7e3d4d82541b0a7520a19d062fc0043e345066ca.1788110147.git.cw@f00f.org>
In-Reply-To: <cover.1788110147.git.cw@f00f.org>
References: <cover.1788110147.git.cw@f00f.org>
From: Chris Wedgwood <cw@f00f.org>
Date: Wed, 26 Aug 2026 22:08:13 -0700
Subject: [PATCH 6/9] libxfs-diff: also compare libxlog against the kernel
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

libxfs/ mirrors the kernel's fs/xfs/libxfs/, and the tool checks that.
libxlog/ carries files taken from the top level of fs/xfs, and nothing
checked those, so a divergence there was invisible.

State the second mapping explicitly rather than searching for a matching
name, so each directory has one declared kernel counterpart.
---
 tools/libxfs-diff | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/libxfs-diff b/tools/libxfs-diff
index fa57c004..345188bf 100755
--- a/tools/libxfs-diff
+++ b/tools/libxfs-diff
@@ -20,7 +20,18 @@ fi
 
 dir="$(readlink -m "${dir}/..")"
 
+# libxfs/ mirrors fs/xfs/libxfs/; libxlog/ mirrors the top level of fs/xfs.
 for i in libxfs/xfs*.[ch]; do
 	kfile="${dir}/$i"
 	diff -Naurpw --label "$i" <(sed -e '/#include/d' "$i") --label "${kfile}" <(sed -e '/#include/d' "${kfile}")
 done
+
+for i in libxlog/xfs*.[ch]; do
+	test -e "$i" || continue
+	kfile="${dir}/$(basename "$i")"
+	if ! test -e "${kfile}"; then
+		echo "warning: no kernel source for $i" >&2
+		continue
+	fi
+	diff -Naurpw --label "$i" <(sed -e '/#include/d' "$i") --label "${kfile}" <(sed -e '/#include/d' "${kfile}")
+done
-- 
2.47.3

