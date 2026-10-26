Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792979646;
	b=nP+C10g1ZdsPAazZ9Px+kfi12LVAQFxyVGQgEKAW+hxPg2Y2o2U3vZdyJz+aTCzep+4p
	 Lq9vKh3sLcS2UuyG/i3hCTg6zcyA/5pNnIqGOjfkPqBw9QpJcuQ8SUZoMD4RdyemHy3eA
	 GRNR6vGA0dGCURYQPUQrV+njuyBW6RTrk6kaGFKsl3T9DTW90KTOMPHD0WwrRpCFDS2jf
	 H8xFcvJIhSGK4Wzhubkq5tMRkwM0B4aU7CfwdsreJTsUn0Kb5zSjHEvJBN2FcwkVHXaMk
	 y6vlANzL4AJFDqxNpkvFFEe+uuOD2K3+W77tNDSFGd7KBN2q/2SwL6fGmX+RF0xfCPw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792979646;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=V88JQ3oyGEUdehJQsXeJlx+37xUAQ2Dh+/95FVC7EQs=;
	b=Y1ldH06hJ0Fu7jdxkcM/LtHmrlNZSfTgykUlSNXjCjlsADtGrjOZ5gaJ8Rfm2uajZowi
	 vKrIXvRTrWWKvU8fuS2+6anSuITiWiySMJzYkh1eHqJPhCKtrl7vvyH1EDhdl7yzEcG8a
	 TGHIm/c8+UJhPOXTT/hwsNBGJPEQvcVyO5F7ReuyyjU+Wmm17xwMmaeD8fLuf/XSn6Lux
	 DjzyzaqVwzuv6pvTLTwhwlWkVzvY1dDGTKpOTEJGoirZgKkKl5Ww4woC8ajt2aaYJGxD2
	 k7731GjhPSt8BWk1ub3OqnGgKII5wEfvPv6tQxJNc1Mom00dRHew3DAgWH0QxwH6fuw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hn4NEJVp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79906606A31B;
	Mon, 26 Oct 2026 01:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hn4NEJVp
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792979646;
	b=qJIBk4esroS+FjOvSAd1+MeuIMZMcrsuBPMNtagLDUOo0G+RIlvXgIguEi+5YdX1wlxc
	 afzIcmFqRLIpAg40sVVvosO7/Pdb5KVq6IPwlaynX//OrF6TxguV/P3XmqHI6DWMSpyxc
	 VofREwb7D1szUtfa4Vdf69AvVGaobV8TAV8RFy1BkXanctuShxCanh7G55WSRY2z/8rXi
	 qZ0X5RvzWj44d8mAmyOsU+uCZPUr/6MqIFQMotzc2leAP7sFRnhCUusb257FY8uQcM/mn
	 pMQjTpHs2kPbIGmLaoaHxo2mH48OcBzmY3kF/15sIDQAZWiVCgFDugbG28AdZJdGbkw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792979646;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=V88JQ3oyGEUdehJQsXeJlx+37xUAQ2Dh+/95FVC7EQs=;
	b=HT0J65agwuilrAvY1j9V2grfIynjX2JjD0eetn5cHvrGsKDVYh7vxEFP/JfDyJrmuKr9
	 Sv0ELL+aaYd9pcmWQj71hg3biE1bkaZSlGvwDRis0SX+bSyDR7vwvqrpe0pzw+eGKuPlg
	 9IlGoNnuhciJ8j2xOJwRrW4VtbOObEcJ9mbXIyYC1EH3ggJjsuafIzbkMuREpCmWFTBkx
	 rpRMwrTLh8kSFaHUxy6imA4EY9ZfsJaS2TIMLRIAlfKv4mZoQatvUbRgd8dDHBiDvOtxx
	 UttqOiklfR84ipkRHdXMw+GV/KiZyUVzrnNw2JL9Fsisv6gjdJ1/Eir0RqgYBP5b2Vw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 6987B1F01829;
	Mon, 26 Oct 2026 01:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792979646;
	bh=V88JQ3oyGEUdehJQsXeJlx+37xUAQ2Dh+/95FVC7EQs=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=Hn4NEJVp5Kc/BW7mVCRbHBD4T4ETuvg2uV/ora/TyCjw/44gGSz6zqhCz3xC33srZ
	 EwZfDHdig0lmTeEuXYm94cpGFpk8ZDRwwKMJC1J/qShBUeODmnaZaucNwL3uuV0L5I
	 OkziD2isHPbvIm3JFtz7nllMb+o5jaXhX/kpl6/1XPfkDVDI+n+Nr0q4XJI4AewP7W
	 ps4ByjkY3wJ/JHL5XQul9ih8nmw1LQfeEbwdXJ3xvAG4uX2i0fKT/aA9cAMqInfQ53
	 nDeEyc087kOAC2bUf89sxYkqD9CpVkeLjpayu0t5s/O8KhoFEvKkslX6ODzKNttZkf
	 4QMUg/UzHku7w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id BE72644B77;
	Mon, 26 Oct 2026 01:54:04 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Subject: [PATCH 0/2] xfs: discard every free extent in a whole-AG FITRIM
Date: Mon, 26 Oct 2026 10:54:04 +0900
Message-Id: <20261026-xfs-fitrim-skip-v1-0-cddd8414f99c@samsung.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALyy3moC/x3MSQqAMAxA0auUrA20dQKvIi6kJhrEgUZEKN7d4
 vIt/k+gFIUUOpMg0i0qx57hCgNhGfeZUKZs8NY3zvoSH1ZkuaJsqKuc2DK7wLZsqlBDrs5ILM9
 /7If3/QA0pdLzYQAAAA==
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <dgc@kernel.org>, 
 Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792979644; l=823;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=IkSnMGO4RLkaGK9K0XCl13Zs2nXzPjRFhg/jdMsWFtA=;
 b=vRZMtnQaD1kclpEj1aOKEIogO+2AExrRgNiakFIHTsTuDDp9Cx/Q9NjskiiJJ2CfSmcO6I/N5
 bl4C3E3lbWOBajcz/1hBhDdV9oU7iUgD4LImQC9Hrjtnsl/zH/0vcMh
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com

A whole-device fstrim walks each AG but the last by length. Two bugs
in that walk leave free extents undiscarded, while fstrim reports the
whole range as trimmed. Patch 2 depends on patch 1.

The new fstests case xfs/842, sent separately, fails without this
series and passes with it. ./check -g trim shows no regressions
(generic/038 and 500 were not run).

---
Daejun Park (2):
      xfs: don't skip free extents in later batches of a whole-AG FITRIM
      xfs: don't skip free extents of the longest length in a whole-AG FITRIM

 fs/xfs/xfs_discard.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)
---
base-commit: ec8f62cc109a3f596b3c65dc0f1011c209239051
change-id: 20261023-xfs-fitrim-skip-7ff1cf0364c5

Best regards,
-- 
Daejun Park <daejun7.park@samsung.com>


