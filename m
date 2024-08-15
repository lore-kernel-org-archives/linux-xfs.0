Received: from shrimp.cherry.relay.mailchannels.net (shrimp.cherry.relay.mailchannels.net [23.83.223.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD09A5A7AA
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 19:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.164
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723751373; cv=pass; b=RGtzlh8Qx9izCTC5R50NBsPMrfXIsvQjaUd5eeHXyTzRQSSlHCU2HyUCSoLBzUKBn8p6Tpq43m9tJyJuEtjca1TIxg6J5bWCBaG8Fq92Y6xfJuvhFBreVX3g3Pg/CcjE7X3PdySsRQ6iDlCAsUDL5NJWuITpq6FtbhgzPfiowFU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723751373; c=relaxed/simple;
	bh=m6zxJ9SLJGX4U6MFrwsV7T5jh515p+NkZxO+ZKtlh1w=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=PA3297YakSb4CiRuwtHh26CkTEyDuT0qRm3FLZ28XzQL2TKJv026Oznj0v8YTWmdu2W8wQw5Ti3hIrmne5t+lpD51f83xaMwTPWAn17RntpE+ZplxHB0QD1a2lM55c+cbiJmRqwBs/bhjdcesyKWEHmfWqYsQNYorJKJ/zcArnE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com; spf=pass smtp.mailfrom=templeofstupid.com; dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b=H6nOodEa; arc=pass smtp.client-ip=23.83.223.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b="H6nOodEa"
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 8FC1DC4130
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 19:29:59 +0000 (UTC)
Received: from pdx1-sub0-mail-a210.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 3D9AEC4488
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 19:29:59 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1723750199; a=rsa-sha256;
	cv=none;
	b=0Uim9T+ZOJStLj3E7WNrIPRc+K96fzbZu96SjHrc5/dGpEoOadIMK4ipU3q2qxVh8/n6ld
	wFoHKiEW5wFGQFVpP4jx2hpIWbGQpgKJrQtphwVq9+Mbfy7iU8IYjufVSpfVqHShk41Y0U
	rqGsIj7VioZlDNnhyvwAQfhFXRHqtMfhjOJB1Uw8c2X8myWgafbueRMfp2qfmOY/wdl8qX
	M6ZgBRGVhc33FhyaxBH/8qWyA+02DBmzK32P7OPQcuJAB2FiV94nhutL65hNYG/5R4vhGH
	9W4tix8Fqku7GMd1AYAwAFl/2WpcJhPBm391CWtLN8pp4YLCu4Zv308XATmhHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1723750199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 dkim-signature; bh=2AbtyVmd3LsaV2zE1A0WvvXs3AQU/DKRvNe+kpgzUPg=;
	b=qZxIly4COg+Ih5A29hMibyyuZuoL8eLNlMn4q2ygwFdEULayB+ZKoab4mDAetIo1Uf8F9F
	wYzM9zEOsdmigGrxu3J2ahuzmsakzXYOhuIMmcHGW8g5g+JUDt5tsGtrWX1l4eXJKUz5TV
	XQv6D8UWdxwpw6GNLQYToMLCk8llYCh9hfj/PwJkGJq7jnuQPurtDodnt0oJNnNuOxGyfJ
	RLp609gxiSpOu4NtXEsBDm/NkZ8GZX5emhXPVyhn8TpktSoFA13CHZp4dfL/0jGPo3+tjA
	vn3CAEXPCuWTpAKueIv285+4lNXLlrWDbvcrjoBhwd7Y4nFdgochpZ2beKM/cg==
ARC-Authentication-Results: i=1;
	rspamd-c4b59d8dc-ft5vf;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=kjlx@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Interest-Illegal: 2837f9c42bc568dd_1723750199465_2395959390
X-MC-Loop-Signature: 1723750199464:1710305397
X-MC-Ingress-Time: 1723750199464
Received: from pdx1-sub0-mail-a210.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.126.110.137 (trex/7.0.2);
	Thu, 15 Aug 2024 19:29:59 +0000
Received: from kmjvbox.templeofstupid.com (c-73-70-109-47.hsd1.ca.comcast.net [73.70.109.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a210.dreamhost.com (Postfix) with ESMTPSA id 4WlFZH053rz9v
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 12:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1723750199;
	bh=2AbtyVmd3LsaV2zE1A0WvvXs3AQU/DKRvNe+kpgzUPg=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=H6nOodEao8271sTvBGN75dTYKEE800EOsiy2nbjwcEEudGlj4IZRT13Bnowd9yNtH
	 7RFmDQcVa9T9FnYEp8IH6codpPSCbWmM0w6acqYZ8g/aooRZjliKpposwKOMSzIiMs
	 FnvFrYvZq9hc0OxKA+6ZppkDd3uWuG8cEBGcjf/YrKJkmyMRse83WIJKfWkZ667q/Y
	 NQlUT6vGH5eYjEAZfvQEroVa98m7B1lrJ7Q7ftxl11un1+Fkk95vjUwdZNDx4vOAGu
	 +VjirijysR/PCMruwLz7n0EO1urWU7gzbLDhqlqcV5YbqlU3A6ExUmls/+oXrtzpxi
	 F8PfRbLuHzXyw==
Received: from johansen (uid 1000)
	(envelope-from kjlx@templeofstupid.com)
	id e0064
	by kmjvbox.templeofstupid.com (DragonFly Mail Agent v0.12);
	Thu, 15 Aug 2024 12:29:58 -0700
Date: Thu, 15 Aug 2024 12:29:58 -0700
From: Krister Johansen <kjlx@templeofstupid.com>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>
Cc: Dave Chinner <dchinner@redhat.com>, Zorro Lang <zlang@kernel.org>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCHSET] AGFL reservation changes
Message-ID: <cover.1723687224.git.kjlx@templeofstupid.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
This patchset contains changes to linux and to xfstests to address a
reoccuring panic in xfs_bmap_extents_to_btree.

The RFC was discussed here:

https://lore.kernel.org/linux-xfs/cover.1718232004.git.kjlx@templeofstupid.com/T/#t

The kernel changes modify how the AGFL reservation is calculated when a
filesystem is mounted.  This is also pushed into the in-core per-AG
structures to ensure that they do not consume the additional space
reserved by this change.

Additionally, this includes a pair of xfstest patches.  The first
introduces a test that triggers the problem we're trying to fix, as
xfs/608.  The second is a modification to xfs/306, which started failing
because the increased space that is reserved by these changes is above
the global reserve limit that this test intentionally lowers.  The
second patch increases this limit by one block.  If this seems wrong,
I'm happy to debug further.  The change was based upon the assumption
that artifically lowered global reservation limits had to be cognizant
of the per-AG limits.

-K
