Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795642131;
	b=T5PJkt4QXMrSF0zYoAedHu/F01C5iq2qu7Fdfq0/rqMcjEWfJAAPJ1Q2RDZeS3u9QvNv
	 /okI8y7ddeAgIbNiZQYcKVzhRy1OoKTiVfmgkIil4LUoLYlw/H1Mh6UJ0wT7dRebpZ8Wi
	 sf8AI4sqcuNMZC4KARCMv84nNhWFP67SpQT+zTzCRMWdjatQB42F4huijP6ryw7wqKzRP
	 JGVVI+p1fWKrwb+/3ObcvdWZe2lUGDCvcysnHoL8Qm79MPw0Chv0GUXrW4v3qW7czZpMj
	 w9sa9AHMSOoqCZZ2R4KsTae4z2+scZFpmhh0VLh19V42DbWIfdEUV2LW3wghqaWhR8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795642131;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=UjowZOwLGX6NVxvCT+6hu2OYX5/XrbTaCIGwhn/ppPw=;
	b=LqXOwQaSn0m4RNHChaKdu/dycbZa19C37UQGktRNLW2ht8XO5bUAhSuTuauqv3zVaHOx
	 5am1epYn+Dhd9Z40ZiZnoXZNS9l9a+5K8YCUrpClJWdWpzlYDUEJ8kOOaIXp3cC0BkapY
	 ZT5OnJmhZrmk4GXUmO+w/L/GbdTqSXK1t8qYn7X+VqdAaekvqieM9h11/tIYeQOAK44yM
	 OTF4oNeI7NGxcDXh0B8Y/0UdQpjWgwqnFxFC0b+FjnLFQleMkEXGGMa6g2ITCCkVLl2X3
	 HNO0aQdg5Ym5aD4e2CXsYrJuuGnDwNnT/swkSA8MdAmtOuOM0eRIF1E0+GM7bDu5bdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l13LiGxs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75232606A32D;
	Wed, 25 Nov 2026 21:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l13LiGxs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6413D1F000F0;
	Wed, 25 Nov 2026 21:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795642131;
	bh=UjowZOwLGX6NVxvCT+6hu2OYX5/XrbTaCIGwhn/ppPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l13LiGxsW6jmo+leYpb4GXvbuCSOXm06f0U30lz0Wofaa+7m/W3YFg66DtjqAxeW3
	 xV+p75y8IrOGcmzZrC6hBoYA+sR2bxYvfciKpVHLXtoGYMIugeOHN8estPftOJHut4
	 lBGqZ0kgzbJinpSO+sbOK4rSmurDlaX//7+mNMzMhVIfOOqgoGDMz8XMnHUAz8vBnu
	 fkkz7+GJ1kfFaekrEMUrE3axQ1Bv8iv0Qv2Ouo7mmfg9uhub+THy9xSUv5v0rTkBGE
	 9ggq8f7y/RtQ6DqXyh9HiGqietphCJPlcMifkW7ygQFoa3VVrlVrLak+ox5vNA4fDn
	 5CUyB/ncLn6EA==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	cem@kernel.org,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH 4/6] check: introduce post-test hook and CLI option
Date: Thu, 26 Nov 2026 05:28:21 +0800
Message-ID: <20261125212823.3389430-5-zlang@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261125212823.3389430-1-zlang@kernel.org>
References: <20261125212823.3389430-1-zlang@kernel.org>
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

Add the --hook-post-test option to run matching hooks right after
each test finishes (before golden output comparison), passing the
test's exit code.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 check | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/check b/check
index a90b2d6d..06c67cb2 100755
--- a/check
+++ b/check
@@ -79,6 +79,9 @@ General options:
     --hook-pre-test path=script[,mode=in|out][,match=glob]...
                             run a hook before each matching test; may be
                               given multiple times
+    --hook-post-test path=script[,mode=in|out][,match=glob]...
+                            run a hook after each matching test; may be
+                              given multiple times
     --exact-order           run tests in the exact order specified
     --extra-space <size>    require minimum free space on scratch device
     --fs <type>             test the given FSTYP; valid types include:
@@ -392,7 +395,7 @@ process_remain_tests()
 parse_check_args()
 {
 	local short_opts="g:x:X:e:E:s:S:lnri:I:TdbR:L:h"
-	local long_opts="fs:,exact-order,large-fs,extra-space:,udiff,help,hook-pre-test:"
+	local long_opts="fs:,exact-order,large-fs,extra-space:,udiff,help,hook-pre-test:,hook-post-test:"
 
 	compat_old_option "$@"
 
@@ -497,6 +500,10 @@ parse_check_args()
 			_hook_parse_args pre-test "$2"
 			shift
 			;;
+		--hook-post-test)
+			_hook_parse_args post-test "$2"
+			shift
+			;;
 		--large-fs)
 			export LARGE_SCRATCH_DEV=yes
 			;;
@@ -1109,6 +1116,7 @@ function run_section()
 			_run_seq >$tmp.out 2>&1
 			sts=$?
 		fi
+		_hook_run_event post-test "$seqnum" "$sts"
 
 		# If someone sets kernel.core_pattern or kernel.core_uses_pid,
 		# coredumps generated by fstests might have a longer name than
-- 
2.56.0

