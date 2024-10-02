Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B005227
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831176; cv=none; b=gkKDZgWQrvZAuGaU1SHCfJJwjsZmw5aIlOmr/2pESpsxnwPstcfl3uf6ewnDwPM2Ls6sKmlTUgOR2cf+ibMFS7ZYnoPgy9QJzuC/W/UEnX4BG6PH7qcPOO9apg5BOdMx2AiRoSUdpO8JFBaodlSaRoL8FjMXyRWwSSvoTtoXkIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831176; c=relaxed/simple;
	bh=yt5+627Nj5hWplCer56KPLeeIjt7HgENuqtfH5jW1Jk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SxirRmzsfnTkHcLU5W/hxh/IfDHIuEFahQNbgv0Mc1eE6Dchl46xZqAe4YJs+IOWyOFlnE9EdrGI9UHooRnktuE0a0ZwurrNS4wvsiaCjgTS80q4pZjEFF9Zmiq8UZAWv3oNMBOYg3PVrX6ewUTT27eQ5a/YroN82d4Zgn+syaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V4skMiNg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V4skMiNg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E80C4CEC6;
	Wed,  2 Oct 2024 01:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831176;
	bh=yt5+627Nj5hWplCer56KPLeeIjt7HgENuqtfH5jW1Jk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=V4skMiNgmAvrM8caS0a4Ol+rmdPWmcWzwP1rdsTMRkozLrXRLM4vY7IWtucRe4dL/
	 2k2QCMjLnklQdqYVeBEZGKuKsl436lYYscqjx8kiAe4pFBgjLAyFiVTusblUj5HUjX
	 O2fHuHJSxhzP3fsu5jBHIrkHbNKv7S8Qp2WvYKI9phAvAf3YlKEFJvubb+HfyWbF9i
	 pnxONaUIhXdmg0j1GPi4ncCQdo/2Dp53AHrJOdOxKNEXPOE9u02gcdW1397rNfCrzq
	 DLPwrQf+E3BIUAV/u9wzCy/k5/4kCG03ug9bTQjafGVyd286oT4Hk2fIVSeMNuuHtY
	 S3esxRX9h8eiA==
Date: Tue, 01 Oct 2024 18:06:15 -0700
Subject: [PATCH 2/6] debian: Update public release key
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Bastian Germann <bage@debian.org>, linux-xfs@vger.kernel.org
Message-ID: <172783101000.4034333.14658715241598019162.stgit@frogsfrogsfrogs>
In-Reply-To: <172783100964.4034333.14645939288722831394.stgit@frogsfrogsfrogs>
References: <172783100964.4034333.14645939288722831394.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Bastian Germann <bage@debian.org>

New key material, used for some releases in the Debian archive:

pub   ed25519 2022-05-27 [C]
      4020459E58C1A52511F5399113F703E6C11CF6F0
uid           Carlos Eduardo Maiolino <carlos@maiolino.me>
uid           Carlos Eduardo Maiolino <cem@kernel.org>
uid           Carlos Eduardo Maiolino <cmaiolino@redhat.com>
sub   ed25519 2022-05-27 [A]
sub   ed25519 2022-05-27 [S]
sub   nistp384 2024-02-15 [A]
sub   nistp384 2024-02-15 [S]
sub   nistp384 2024-02-15 [E]
sub   cv25519 2022-05-27 [E]

Signed-off-by: Bastian Germann <bage@debian.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 debian/upstream/signing-key.asc |  106 +++++++++++++++++----------------------
 1 file changed, 46 insertions(+), 60 deletions(-)


diff --git a/debian/upstream/signing-key.asc b/debian/upstream/signing-key.asc
index 5a9ec9b80..21b193a55 100644
--- a/debian/upstream/signing-key.asc
+++ b/debian/upstream/signing-key.asc
@@ -1,63 +1,49 @@
 -----BEGIN PGP PUBLIC KEY BLOCK-----
 
-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
-=El1H
+mDMEYpDWzRYJKwYBBAHaRw8BAQdALRUYJSJQyHn8o9318h7Pj4KYIOPF6a+6Z13A
+bBReh6C0LENhcmxvcyBFZHVhcmRvIE1haW9saW5vIDxjYXJsb3NAbWFpb2xpbm8u
+bWU+iJYEExYKAD4FCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4ACGQEWIQRAIEWe
+WMGlJRH1OZET9wPmwRz28AUCYpERyAIbAQAKCRAT9wPmwRz28PBCAQDsBVWWrXVJ
+CUVfRDPkjN3zIGqDI4lZO9gXztG88NODvAD/bicVG0GsxDsq1VOzSXz0NbwnrVmO
+Z92IQcuqQcB3rAG0KENhcmxvcyBFZHVhcmRvIE1haW9saW5vIDxjZW1Aa2VybmVs
+Lm9yZz6IkwQTFgoAOxYhBEAgRZ5YwaUlEfU5kRP3A+bBHPbwBQJiqHtFAhsBBQsJ
+CAcCAiICBhUKCQgLAgQWAgMBAh4HAheAAAoJEBP3A+bBHPbwgUcA/1UvHEU2farI
+RuWL2V+86kAJE+3mXwaj4RKNxj3k1LH7AQDtZJ4iZvfPF1u5jv9HAe2m9sj2KtGR
+G5qCTM1kdGvWCbQuQ2FybG9zIEVkdWFyZG8gTWFpb2xpbm8gPGNtYWlvbGlub0By
+ZWRoYXQuY29tPoiTBBMWCgA7AhsDBQsJCAcCAiICBhUKCQgLAgQWAgMBAh4HAheA
+FiEEQCBFnljBpSUR9TmRE/cD5sEc9vAFAmKREHMACgkQE/cD5sEc9vDMcwD+PAZz
+J5LR8RXDuCjHupo48DbhldDX89sOarOSlM3NIswA/3Nc1tcDiHrPOpmWVPKD7Qnk
+UY7XDyqjkNnetbgDOeQAuDMEYpDlmxYJKwYBBAHaRw8BAQdAUo8FDT3qwJVb00K1
+sgqYszeazP13DnY2yUPd6BjDq/KIeAQYFgoAIBYhBEAgRZ5YwaUlEfU5kRP3A+bB
+HPbwBQJikOWbAhsgAAoJEBP3A+bBHPbwGmQBAJJo3csKUuPjbpiIHpVsNve6QSLN
+3dgPc89bzEAF+pTbAP42oeQezPHlac3uMHk7qA6eW2oDPjwk4hmdURD0JWfqCbgz
+BGKQ5aMWCSsGAQQB2kcPAQEHQM4qGA9zcl9U6XXd971xCPhvCkFq8Van5AICigf2
+gCjyiO8EGBYKACAWIQRAIEWeWMGlJRH1OZET9wPmwRz28AUCYpDlowIbAgCBCRAT
+9wPmwRz28HYgBBkWCgAdFiEE+kBuIGr/eHOJfGhktFYYw2ok/SMFAmKQ5aMACgkQ
+tFYYw2ok/SPQpAEA2lHK9gQ5u8IXll/GyffBK/dsya9N/4t8ZiVv/O7YdfIBAL7D
+tDoStw9qfiqtINr1dpoMkcSvJaGLPKP9NDWEm7EJWuoBAOK55BkUEd7+DAcooxoa
+tZY2jzE0GyC4kz21KgN5NbbLAQCA81Au6Q1iWloidsg01YQQbzPsvjJ6CVeQ6k7f
+y/ijB7hvBGXOGm8TBSuBBAAiAwMEIioVSfoxda04vWBNR8rTTgtTN5J6ij0aelSv
+kvLGN7AX8dtTxsm9TyEzdvtmwyM4H9DHwPde2GyTTRBIJbvAeTtq2JbAok6xLdfm
+OcinFnO8hFrFQ2o46n6WqFqth/wyiHgEGBYKACAWIQRAIEWeWMGlJRH1OZET9wPm
+wRz28AUCZc4abwIbIAAKCRAT9wPmwRz28GItAQC0xQluEL7p4THLhTgWXcrf4wQ/
+bWdXxU4JwUuPoic1+AEA3Swlkhn8LbNnXiIwAsIg1uus2WzyL3yJEhE54pd8bQm4
+bwRlzhMWEwUrgQQAIgMDBKZ4OlpocCPFvYoqDAhwAJqJsNC7PAFcVY3VnrAJXLet
+hFrZfh5LBzR1ukZAQhYPn1A3gGZ6PizRI91imJ6nkvywxIeVpf75qQf10RnZ6Z4k
+NzP1z0WFXu/vrbKoL9CWAYkBDwQYFgoAIBYhBEAgRZ5YwaUlEfU5kRP3A+bBHPbw
+BQJlzhMWAhsCAKEJEBP3A+bBHPbwliAEGRMJAB0WIQQMHYkcUKcy4GgPe2RGdaER
+5QtfpgUCZc4TFgAKCRBGdaER5QtfpokjAXwIsSWrL3eax+z/3cVL0Q1AZ4/ZMKmM
+wnvrz50DRePaICWT2xVVQXMY/e8kAGhZxWoBf1/BBUdPioXmC+B8Go35oSMEVOBI
+HOYPmgzA5f1eszBSki06pDXcS3aJIiawfK1EcQRPAQCTybdoRNsPltL8cD4J3hou
+8RuBeErKy8BKFqp6O5sCBAEA1apBNKyFIapH+ZwDBNq5CSiFe/G55EIh5hFdQJMU
+OAe4cwRlzhRcEgUrgQQAIgMDBNj1uGqGJ8a0sqN8kBicGNkFAtoyvfEFTH+KUSNn
+GP34wya2HnMUB7t0LU8d+lt5M3pH1bv6Tg3GSfGQ530R9FjU2Qz5QFcajA5inBTV
+qYY+Dk/ZCYE3/qtPspuryGRiIQMBCQmIeAQYFgoAIBYhBEAgRZ5YwaUlEfU5kRP3
+A+bBHPbwBQJlzhRcAhsMAAoJEBP3A+bBHPbwExUBAMuOSJrrxg2Y3S23/sXr6uB8
+GHgFdcBGp6G4jx+0QeOsAP0ZfWgHg40YqRFhwmTAE9j3FE1j9u7kiuHn6iAJS4Qf
+Brg4BGKQ5mASCisGAQQBl1UBBQEBB0DaAZhs0bB5OqligT7Z6+r5TuwAaPx75HqC
+1FGVNq/0PQMBCAeIeAQYFgoAIBYhBEAgRZ5YwaUlEfU5kRP3A+bBHPbwBQJikOZg
+AhsMAAoJEBP3A+bBHPbwvsQA/34JP7FUK5H4Lq+2b47KL364x2xwuLVnoN1fGFRy
+DnXKAP9ULaEyzGc8LewpHfrxRn6kkrOQ9RTJsGhOGf1laKj5Aw==
+=apYB
 -----END PGP PUBLIC KEY BLOCK-----

