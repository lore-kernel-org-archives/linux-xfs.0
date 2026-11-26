Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795700806;
	b=VlSorVoQJGRs8quBfERhGY64iMnkMuuEs+uR/76PU6us7ToEssgUxFtU1qSfydguVp0z
	 Ae77d9qh9UQ6ZQm124rQYm19+pkDgFZg9KfV1oyd7/vkINKY6roGWW6djqP4NMdXfPmnv
	 CZBPc5Aw1DCXvt//kAC/lFYbRdbk+w7t3UdkqS0PnNShLL+i3rRIpO/chhXyrOt9phZOC
	 uLA5ULfHiisRLJCEi8R3F2AARzxRwKD8VeeOXd/RJLWYI4CsFGVpyoBHbb/8/0xcaconQ
	 Hg1/lceBgPr7d8nLaSSJwHWtA9y+SFkCmHCPZ3sgErWmNZzaSAGsb1vMcCCJgEwjbSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795700806;
	h=Received:DKIM-Signature:Date:From:To:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=d40l1EnkJU8uJ+yoiuRjtleUSnAu95dHab20Hg/pnuk=;
	b=OufSpxxgTgmkMeVts2WVQOzwkI7lHmU4QmckktpdIcj7ymNpxu3HAcFuBFAISLx+jWiC
	 COD/1Zd5pEqnqHjZPy7O0uD7au/HcigB5mooJi0l0TAW1dPGdmmd9f/RHmsS2CZRXj1vE
	 WMcDaArMs+LJQ1gUXjRnoESYmYsbdNtnbcr8Jyl7IWOyf19wOUjW7+EHSztBKQnQr+jGo
	 7aMp5T7CxHI0XPu7TYEq1VSK4Vr3zylbwyvySLh61y2gga4wxAlr5tUcu38ESuBoAZn3t
	 qp1WMCCUcRQEcGKkqWxYfGd9CNRXpSSiexBe2K+SODhokBepvjJ8OFBazIIA+SpMelw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BiE27Guv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536CA606A31C
	for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 13:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BiE27Guv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F6A1F000C4
	for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 13:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795700805;
	bh=d40l1EnkJU8uJ+yoiuRjtleUSnAu95dHab20Hg/pnuk=;
	h=Date:From:To:Subject;
	b=BiE27Guvcdb9H6y0VPDSZZVH05eDtTPWooTC/NZffd3WJdYaQ2utMB4SmsBUZnske
	 2nMwtEnA8NEjjfbs6ryx3t5TRUIJIdJIAGJgiD+lW5m/2vjuLa190JhV9kg0vxKnTr
	 Hs2GTb4c2vMPJX/07Rb7zXJ89QI5GCJdiu4TgYyKvG30F2w0PBl/YLgQSIXCo5Y78j
	 eIMh9Zygn68X+6tTQQlMtxBKDunDpHbxCiW46V4AUuZxq5c6+qMnUcYR7yCBatRL/q
	 3s6DINX34AwamS3702NeDnKE/lRZQv292XjJEKc7z425brOSdmbljY4u3DVfHgdj0x
	 cJtT3Uxpxqa2w==
Date: Thu, 26 Nov 2026 14:46:42 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next is now 1ebd141a13ae
Message-ID: <awg3NecL7NkWo_Ev@cronus.toxiclabs.cc>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi folks,

The xfs-linux/for-next branch has just been updated.

Patches often get missed, if your outstanding patches have been
reviewed, are not already merged in the mainline and are not
listed below, please give me a heads-up.

Follows the list of staged patches.

----- Fixes for v7.4 -----

Chris Mason (2):
      [bca5d7312f37] fs: validate atomic writes after O_APPEND and limits
      [3779fe1637ab] xfs: recheck direct write alignment after write checks

Eric Sandeen (1):
      [ba7d05f40780] xfs: pass proper leaf argument from xfs_rtrefcountbt_broot_realloc()

Ian Rogers (1):
      [c43e28d4f2d2] xfs: initialize error in xfs_getfsmap_rtdev_rtbitmap()

----- Next Merge-Window (v7.5) -----

Adrián García Casado (1):
      [e5a14f423f68] xfs: add __printf attribute to xfs_buf_alert_ratelimited()

Alejandro Colomar (1):
      [58de42855708] xfs: Remove incorrect use of '&'

Carlos Maiolino (1):
      [dac545553c1f] xfs: remove redundant extra assert from xfs_zone_gc_query

Eric Sandeen (8):
      [224d2105cd64] xfs: remove redundant stat checks after xfs_btree_insert()
      [a5689f638271] xfs: remove redundant stat checks after xfs_refcount_insert()
      [d69dbc0ff32e] xfs: remove redundant stat checks after xfs_inobt_insert_rec()
      [4d9405e89692] xfs: remove redundant stat check after rcbagbt_insert()
      [f2c584cf4723] xfs: remove status parameter from several btree insert functions
      [931a3463e3ea] xfs: add stat check to xfs_btree_delete and remove caller checks
      [41ddfeafe6f8] xfs: remove redundant stat checks after xfs_refcount_delete()
      [31a05b07e825] xfs: remove status parameter from two btree delete functions

Jianyun Gao (1):
      [a2a0791c4ef5] xfs: fix wrong lookup direction in xfs_refcount_lookup_eq tracepoint

Kyuwon Cho (1):
      [a1c699766280] xfs: reject a hole in a remote xattr value

Siddh Raman Pant (1):
      [25d68686fb0f] xfs: Fix duplicate assignment in xfs_alloc_read_agf.
