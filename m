Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84FF84D35
	for <linux-xfs@vger.kernel.org>; Thu, 18 Apr 2024 08:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713428618; cv=none; b=AptiYtjN20NMD8BS05uaku3oJso9kOEWJSf+gAcH2T+QY54h0gZpEiD0IjEikVaMYAfk87QEj6EJ680vfG+XiVF+9ykW2MAG35BvTTasQw66pAlDODlJbp4X511YHTt7yVA2oWwWReXYRvxRqCTKuO0sj8CgQzD3V/s864WLRDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713428618; c=relaxed/simple;
	bh=NDTt8ZIvVNNL+vBWBetLQX+LvNEXCC4dqD/fFZ68NC8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=IRp2x5RTePnqbigQuUYMurzj5K2LGvYio8x8sWjBej5LPZkYNtZ4GLADIJF5D/4muSJBxi5J0/RxQzxybr4Avxy2yCMsMRsUmoPaFbbjHF7v1Fb+Rvjd8xz/ycABMQ4uNkxtYylK33rr20axWcAwQfHeQXD1V+sxiplC+Ioazmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h2hmXKyN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h2hmXKyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2A2C113CC
	for <linux-xfs@vger.kernel.org>; Thu, 18 Apr 2024 08:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713428618;
	bh=NDTt8ZIvVNNL+vBWBetLQX+LvNEXCC4dqD/fFZ68NC8=;
	h=Date:From:To:Subject:From;
	b=h2hmXKyNiG4fYaFo4bqgK0kWhzkzHoWLxI503QdeGxVJtecYJNwo87wbYanpvzP+P
	 nFQGU5Jvgg3uNcXTvuvCBGgECX2/PJBJpQfgVdSpbQRIgJUJTgKXodrUv0QNwUJ0VS
	 efZbjCoNfb65NlEaGfTCj4cR4W3NPEkMFUvfTUv/SE1tj0uYYmM/QGJzlx4lEeP0tN
	 S7/DYOIEI8P7FafpASfv+u5txM74tn0Sye0hDEpVwaQi7hRPf1DIznxZC2aqL6z+sM
	 Ub0tpJ2Q8EknQ5xd+9M0NeuVD8PjoXXAgnVbSQB3D8zY15lue2vVTqDnvMq/OUwPdR
	 RFeO2bfURhPUg==
Date: Thu, 18 Apr 2024 10:23:34 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] GPG key update
Message-ID: <akavzwaevicl2agsucc4salxjtxmmg74htvtiswzf2ortw2rud@fstpc2o5ywlo>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
I didn't mean to send such email, but more than one person already asked me about it, so, sharing it
for a broader audience.


TL;DR;

I started to use a new key to sign stuff two months ago, if you had any key mismatch problem, update
your keyring. My apologies for any trouble.


== Long Version ==

Because my smartcard does not accept ed25519 keys, I added a few new subkeys to the very same certify
GPG key, so I can make my keys safer.

Once my key got updated in kernel keyring I started using it for signing stuff.

I made the foolish assumption that automated packaging systems were querying the kernel keyring or
the public key repos (aka keys.openpgp.org) when trying to verify the signatures.

These new sub-keys belongs to the very same certify key as the another keys, which are still valid.
Nothing got revoked.

My certify (or master key) is still the same: 4020459E58C1A52511F5399113F703E6C11CF6F0
With a new extra subkey added under it: 0C1D891C50A732E0680F7B644675A111E50B5FA6

The kernel keyring has been updated in February with these new keys, so again, my apologies for any
unnecessary trouble, I assumed two months were enough for systems who relies on GPG signatures to
update their databases.

Below is the commit that updated the kernel's gpg database:

commit d3b3885a394fd3144c43bba98596665b42024e19
Author: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date:   Tue Feb 27 14:54:51 2024 -0500

    Periodic update from keyservers
    
    Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>


And directly from the kernel.org's database:

pgpkeys $ gpg --show-keys --with-subkey-fingerprint keys/13F703E6C11CF6F0.asc 
pub   ed25519 2022-05-27 [C]
      4020459E58C1A52511F5399113F703E6C11CF6F0
uid                      Carlos Eduardo Maiolino <carlos@maiolino.me>
uid                      Carlos Eduardo Maiolino <cmaiolino@redhat.com>
uid                      Carlos Eduardo Maiolino <cem@kernel.org>
sub   ed25519 2022-05-27 [A]
      36C5DFE1ECA79D1D444FDD904E5621A566959599
sub   ed25519 2022-05-27 [S]
      FA406E206AFF7873897C6864B45618C36A24FD23 <-- Old key still valid
sub   cv25519 2022-05-27 [E]
      5AE98D09B21AFBDE62EE571EE01E05EA81B10D5C
sub   nistp384 2024-02-15 [A]
      D3DF1E315DBCB4EDF392D6ED2BE8B50768C99F00
sub   nistp384 2024-02-15 [S]
      0C1D891C50A732E0680F7B644675A111E50B5FA6  <-- New key
sub   nistp384 2024-02-15 [E]
      C79922EE45DEA3F58B99B4701201F4FA234EEFD8
