Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795642134;
	b=MBcEmDmzNatJ+7CXvRB2otKnpOzn3l3uwdZFEHOWAW8iIzjSbN+sWcAgKuxT5d9a7eFj
	 DGBV0ieKNpi2IedIfp6vNww4/GZQEZt9Yq1ylxF83G+POSViOGjDnp3B8ExUn2SjyIEmD
	 czwkHEbVngCCTfRs4XjMSrE6Xno1bNtm9Q1s9v99cjYvShDOl85KirY9nWa5amyJIoZUm
	 m93S7aQGtWX01J2BLM+3HdGmCGlqyebpuahk/DKAc/RDVUSZm/peB+DJLK8Z9+eYfeHgS
	 GdvHasJ5cz+unhpwsGER3zgzdpBlAg51mz7DYBBZ7Ulc5DJwfmrqM1xiEou7jE2t0kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795642134;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=MWPxLPBjzgYO3dWxSzZ6tXIuaM5SPxZ096WFPx/GKtk=;
	b=FddmbRkR3pUEbpVFk5n2XCUUZxwrzxW1b4nDKy+pqcN4877Cw5UpYYUzMszdAkWt1kDn
	 Ab/1IerrRRhsJoiKpHhtRiAjgV0NKFJXLazfluRdqyQpxarRzpR1SWghjC4yYllgx//j4
	 4Kw9apzZCuWFZy3/OJdfAP0c0ZPJA4sABEpbYzY2y7dPQVViOL46zyQdco1G1CmayQ5Yu
	 4KjPh/YCd4sJ1ust5aG/5xor6jQgmY7OF5S2rd8kz79g31xuNWCqdKm15D40MFhG6e4tT
	 UQ94zsultQ7dD2O664c348CkQpnZWYSpzNbMSi//7Hwn3i4sqK+UJcTLemd+5gNybtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="ghjEB/8A";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CAB606A695;
	Wed, 25 Nov 2026 21:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ghjEB/8A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A7C1F00A3C;
	Wed, 25 Nov 2026 21:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795642134;
	bh=MWPxLPBjzgYO3dWxSzZ6tXIuaM5SPxZ096WFPx/GKtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ghjEB/8AMGQRFYVROIKs/FM5x9UGxt4f0TFoDU0PDtnwSFMHJwwGihl9cKCpraFjd
	 MX0M2jiHz5Wzs+ovDbSMH+G8JHhCouI6Ag7SgTjUh29TMUDI1E/0Yf1x4W4ANN98Ix
	 mdxPOlFYkpDVppsrxc4lTsIWSwq9H5EN/GOF6CWeZ3poUYv1JMCEeAtPheQ2TKc1eQ
	 bfHu4ScdnBApXNXf+u3FXqFdqdhpIqv4U4LItAHsL84YQdkcstDv2tmo0hPpNFCj0f
	 9ssd4U1GuIlQ+M//DCeT2fjtQ2xm10sa9trA2T4GaXU0BvzJFAfSNpoBHuTLFJeLNQ
	 r5wxmiiaOo46Q==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	cem@kernel.org,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH 5/6] check: introduce post-result hook and CLI option
Date: Thu, 26 Nov 2026 05:28:22 +0800
Message-ID: <20261125212823.3389430-6-zlang@kernel.org>
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

Add the --hook-post-result option to run matching hooks once each
test's final result (pass/fail/notrun/expunge) is determined, passing
the result and runtime. Hooks run even when no report format (-R) is
requested.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 check | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/check b/check
index 06c67cb2..5c4f16a8 100755
--- a/check
+++ b/check
@@ -82,6 +82,9 @@ General options:
     --hook-post-test path=script[,mode=in|out][,match=glob]...
                             run a hook after each matching test; may be
                               given multiple times
+    --hook-post-result path=script[,mode=in|out][,match=glob]...
+                            run a hook with the result of each matching test;
+                              may be given multiple times
     --exact-order           run tests in the exact order specified
     --extra-space <size>    require minimum free space on scratch device
     --fs <type>             test the given FSTYP; valid types include:
@@ -395,7 +398,7 @@ process_remain_tests()
 parse_check_args()
 {
 	local short_opts="g:x:X:e:E:s:S:lnri:I:TdbR:L:h"
-	local long_opts="fs:,exact-order,large-fs,extra-space:,udiff,help,hook-pre-test:,hook-post-test:"
+	local long_opts="fs:,exact-order,large-fs,extra-space:,udiff,help,hook-pre-test:,hook-post-test:,hook-post-result:"
 
 	compat_old_option "$@"
 
@@ -504,6 +507,10 @@ parse_check_args()
 			_hook_parse_args post-test "$2"
 			shift
 			;;
+		--hook-post-result)
+			_hook_parse_args post-result "$2"
+			shift
+			;;
 		--large-fs)
 			export LARGE_SCRATCH_DEV=yes
 			;;
@@ -783,6 +790,8 @@ _stash_test_status() {
 		_make_testcase_report "$section" "$test_seq" \
 				      "$test_status" "$((stop - start))"
 	fi
+	_hook_run_event post-result "$test_seq" "$test_status" \
+				      "$((stop - start))"
 
 	if ((${#loop_status[*]} > 0)); then
 		# continuing or completing rerun-on-failure loop
-- 
2.56.0

