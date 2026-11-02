Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793607134;
	b=bFNG7YADkfhbRou9HO1/Ul8jx/Y+08sl5UBusIS4OwdB+2N3/1rnxszfT6MieY2pHfaI
	 KhSOreDtc7CScUi3l0wxZ1TfANBG6irg6CcyVwuf9KZqsmKISlKzN+faz/yaZBHlHdRy6
	 O+yWkVJW4AjLRV5c1bOeNoHXES4CxyV+hHPWl6PWMz9ZI3V3DM7xUjLXLLfsTPssF3G83
	 5ccRWjQ5p5lRP/kHUreBozq52FC52AXPcwTsBs6+D+LT0wnpevfTfn1UPWyNoZ8OfjWeQ
	 /HQqvoPH/4qty8P2357muCZvLYOdGLiOI5ByLT9j84IDAtLsauiM4c3lfiFD8d2IxYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793607134;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HusQp0AGtF0cjfU8TUfSRst/vJsaQjK/030p/TyZ4vg=;
	b=EYzCUUrwOzns53mNBahXRNNVfevNTYSeNa9yfdyziyNVXKNVhcmgh/21m5psNtUR9qA4
	 vKYTxGQuLihK4OXAm7gmLzCTEqdFoQzYPyEhJ5m9lxF+d/e4e8OVDpB10w4JpT4zOdFXp
	 /mfCqVNNhjw8CQP1pA7y5gflepA4Qq1GjTwqy7L3MWo7VW10S352rKUk9Os6RfWbAH5Md
	 39ajOIPdUBiAwHcx9hdfS5X8rrTnwlGmBV6HDQoYVRtaO2ttfa/mVcCPgzTGQrM6syPky
	 yfm/GTcVPRiL2t1W+u7OJGpmVK0wVZZQWSMBDgIEVB0t5yqsTiV6VnUGo6fcICEJyYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EvKiAiFg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07728606A324;
	Mon,  2 Nov 2026 08:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EvKiAiFg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6493F1F00919;
	Mon,  2 Nov 2026 08:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793607133;
	bh=HusQp0AGtF0cjfU8TUfSRst/vJsaQjK/030p/TyZ4vg=;
	h=From:To:Cc:Subject:Date;
	b=EvKiAiFgTVS1oF6oeVwv/nVCNBFcg9fLEDSOD/Y+jhggG2QNeaDBTs95831osn0TV
	 jpZR6oYPOjXECLGLsuKQrApRKIVQIWmbmXGg+Ii7qYvvzyMeLjEvHCv6MKUKXzo7c0
	 w8/6XbzDH4U+CaSNoa7qtYGKPb1h0z2Vh8aoiTV7Vawqi3oAkl/0oaqVW7ISn18UOu
	 hgYoi2UjglkiapLLFPNZPjtikfxP+7sUF801fkuPEeFg6HRZ9adm2M6lo0oIuBJq/x
	 0L5Wkend2v9IaLQ65eY3qOZKUMCO2qYA1T6z5/AkPa42ZymwyZW1186I8TqQH3o3z6
	 zEfYXgkqholMg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: fstests@vger.kernel.org,
	zlang@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH] xfs/619: fix mistyped seqres.full variable
Date: Mon,  2 Nov 2026 09:11:57 +0100
Message-ID: <20261102081156.640279-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
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

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 tests/xfs/619 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/619 b/tests/xfs/619
index 7e542f705e60..583be7160be2 100755
--- a/tests/xfs/619
+++ b/tests/xfs/619
@@ -36,7 +36,7 @@ file1 ---755 3 1 /dev/null
 $
 EOF
 
-_scratch_mkfs -f -n parent=1 -p $protofile >>$seqresres.full 2>&1 \
+_scratch_mkfs -f -n parent=1 -p $protofile >>$seqres.full 2>&1 \
 	|| _fail "mkfs failed"
 _check_scratch_fs
 
-- 
2.54.0

