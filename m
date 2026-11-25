Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795642117;
	b=Mh2TDs5qj+RSZgoGd9MnLLLOy7THLBif8Y0uuFsOpXLP1NAbU9aSzAh/VdpEZPXXWvWJ
	 xrTP5XGyvRIjyKHG5xuUg+cHua6c5EFCUQFD7vhpEDhKx3xfrCMJl7uJakWvm7SCV9qXA
	 F9qggOj3uGUGGOOOW+7yRnMfFSsT1Zzg+11Q4i3Oi2aOvmXcJfMTURpGj6BlBvb1e87hk
	 Ip/4JwfBgNTQycEqe/af3VizfBq8C5cwHOBp++Dadlh3eFnyhekdb5x0x6a+KVLAVz+k2
	 Dhu9lJ+CJk2D9Ovw0UWR3T2Uiljggoeu4iDNScdexbHuTfF8KOCFQVF34jRSANz38ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795642117;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0dlKON1hdC24e4Jmd9FYFD7HOwnwmEXI53/rRaAoBpg=;
	b=FDq3F0aguctNgyOa7w550PqdA9AVaRBwOAlTrL5+g2ZOce/TZ7Mc1mT0lSEfm4Ma3mD3
	 g9IgvshwYjmu5ksblJQGuTfz4aDusy4Ieyhjo7eVDwtRqwXBFPKJsITwR7j+cJrCr8yQR
	 G2dts8FiZBRL0F07J2ZPq6AZNYujv3ZPaYrqMZ77Gx1MavBQIk0iIznDvKsdzRIERogZs
	 WJJPZRCxPmEGtz/UFoAmJtJfBKj8eyYrKxUWF2JqMi1ZP9B3DAASaEPCxL+8hR3rf5x5b
	 j1J8dX09LBRttZhSDXjsK9gALIn2xQdPuGpZMeDj3hqJsnWsUvFPpBwG7bMbrsZAZQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S64eoNPw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA9D606A334;
	Wed, 25 Nov 2026 21:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S64eoNPw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DAC21F000C0;
	Wed, 25 Nov 2026 21:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795642116;
	bh=0dlKON1hdC24e4Jmd9FYFD7HOwnwmEXI53/rRaAoBpg=;
	h=From:To:Cc:Subject:Date;
	b=S64eoNPwd1hhfpQddx6y4wdjs2VqMUz+8MDV3ragn2i6/qWdeqWcMDaXHK8hv9mID
	 OOHwLZnyB1reHJpzxV6FNfwIAHsC89ztmqFe7SMmKpNl3OSQ5BNepDuSC+JvLv89jq
	 a1L8m7GRPBsNPNeIclQDH/WTtGCM4JaZFKY+tm++SqDRIy4QXJv4pXroxANZju/gJj
	 QsudDPbZkIvk0YIpxa4aOuAtxYonFuxzl8CGjW1qhCcUcMwVfosTNbgWTHmeLHI3JZ
	 nNwtxryzxLlgQMUnRIz2snAwUwdNdITgVzeFLxEn0rcBnljj9M9+kd298y9Mzano7/
	 q6SKJ7jLd0K5w==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	cem@kernel.org,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH 0/6] Add test hook infrastructure
Date: Thu, 26 Nov 2026 05:28:17 +0800
Message-ID: <20261125212823.3389430-1-zlang@kernel.org>
X-Mailer: git-send-email 2.56.0
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

Hi all,

This series adds test hook support to fstests, allowing users to
customize a test run (e.g., collecting traces, capturing extra debug
data, or reporting results to an external framework) without modifying
fstests itself.  It is inspired by Dave Chinner's earlier hook
infrastructure RFC [1] and also addresses the use cases from a recent
fstests mailing list discussion [2], supporting both in-process and
out-of-process hooks as well as a post-result event.

Hooks are registered on the command line via --hook-pre-test, --hook-post-test,
and --hook-post-result:

	--hook-<event> path=/path/to/hook[,mode=in|out][,match=<glob>]...

Options can be repeated and hooks run in the order given.  Optional
match=<glob> patterns restrict a hook to matching test names; without
them, the hook runs for every test.

Two execution modes are supported:

  - mode=in (default): a bash script defining hook_execute(), sourced
    in a subshell with full access to the test environment and fstests
    helpers.

  - mode=out: a standalone executable written in any language, invoked
    via env(1) with the test variables in HOOK_ENV_LIST and the hook
    context.

All hook output is appended to $seqres.hooks, and hook failures are
logged there without affecting the test result.

Series overview:

  - Patch 1 adds the core hook infrastructure (mode=in) in common/hooks.
  - Patch 2 adds out-of-process hook support (mode=out).
  - Patches 3-5 wire up the pre-test, post-test, and post-result events
    and CLI options in check.
  - Patch 6 adds README.hooks documenting usage and examples.

[1] https://lore.kernel.org/all/20210722064725.3077558-1-david@fromorbit.com/
[2] https://lore.kernel.org/fstests/20261119123910.294544-1-cem@kernel.org/

Feedback and reviews are welcome.

Thanks,
Zorro

Dave Chinner (1):
  common: add builtin test hook infrastructure

Zorro Lang (5):
  common: add out-of-process hook mode
  check: introduce pre-test hook and CLI option
  check: introduce post-test hook and CLI option
  check: introduce post-result hook and CLI option
  doc: document the test hooks

 README.hooks | 156 ++++++++++++++++++++++++++++++++++
 check        |  30 ++++++-
 common/hooks | 230 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 414 insertions(+), 2 deletions(-)
 create mode 100644 README.hooks
 create mode 100644 common/hooks

-- 
2.56.0

