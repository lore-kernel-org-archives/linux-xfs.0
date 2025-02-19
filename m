Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C050618E25;
	Wed, 19 Feb 2025 00:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739925998; cv=none; b=XoNOKgAruX6pmBsYjWQwluzrcV79QAWEOXaMzGFqaBlC5Sw52RaRp7pgFEUb0WYyusuGt/xzDgaLXPXuFhYmIr443f87g/WCIBMJvLiy+0NayF4hrK79KxPXsf42w1vnY/34QkIaZLHEtBItPhjPQa64otL0OfSafuAL7/nt9LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739925998; c=relaxed/simple;
	bh=RgQ1+4GYHdKMhYiLmjdUJWX4EwXpdPu+gBjBdXc3ug4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iPLNlsiVu/MVIln8xbKDzWal7tBlG+m4HPEHsBR/XnFvv8k4utLi6LXaPBGKfovdHYU7rwW1K7pCFb2dR6nq9SoGFdWfm3BcNNXViC2dDDcKv/TurwjH0jhAPfYlDEDTq4pkTNSeYVQjfBay1YQbTj8leQNMvdWeX50O191iHUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IKy6F3ap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IKy6F3ap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93955C4CEE2;
	Wed, 19 Feb 2025 00:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739925998;
	bh=RgQ1+4GYHdKMhYiLmjdUJWX4EwXpdPu+gBjBdXc3ug4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IKy6F3apb3xTxZuWR+eIB0Cmsl5vtSsZo7sdcbmDcbFw0D2jeMmxm0jTzupFPxb2y
	 FrWmrwEihTbZAjKmlWNHPJ68xuBYgil5lTyMH/VKwEUaettpzoXFUWtoitplbyXHBO
	 z0nD7Pg9Cr3x+ZnQXYZSJYZfCJvJSnSl9orf77qpzKl+qht0dh862iP8o7G8hI4s85
	 yEO5TMn9LwJdN6D037Y0xXHJ4x4h4VQCzsnnAo64gIOq6ImhR1Knj0eANHpofINOJr
	 tFX2Ul4PeG3zO/B5hMAZCewf1Y2/we65VdpRXg/6b13D+V3nBtUHGkFDMgfdeCqpy8
	 ZQ+xZWE9ktOmg==
Date: Tue, 18 Feb 2025 16:46:38 -0800
Subject: [PATCHSET v32.1 03/12] fstests: fix online and offline fsck test
 groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992587345.4078254.10329522794097667782.stgit@frogsfrogsfrogs>
In-Reply-To: <20250219004353.GM21799@frogsfrogsfrogs>
References: <20250219004353.GM21799@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

I've been working on online fsck for years, and hardening offline fsck
whenever I notice easy to fix discrepancies between the two tools.  Now
that it's been a couple of years since I've seen any problems, I think
it's time to open this to wider testing by dropping /some/ of the
"dangerous" tags.

While working on this I also noticed that some of the fuzz tests were
misclassified, so this patchset fixes those problems too.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fix-fsck-test-classifications
---
Commits in this patchset:
 * misc: drop the dangerous label from xfs_scrub fsstress tests
 * misc: rename the dangerous_repair group to fuzzers_repair
 * misc: rename the dangerous_online_repair group to fuzzers_online_repair
 * misc: rename the dangerous_bothrepair group to fuzzers_bothrepair
 * misc: rename the dangerous_norepair group to fuzzers_norepair
 * misc: fix misclassification of xfs_repair fuzz tests
 * misc: fix misclassification of xfs_scrub + xfs_repair fuzz tests
 * misc: fix misclassification of verifier fuzz tests
 * misc: add xfs_scrub + xfs_repair fuzz tests to the scrub and repair groups
 * misc: remove the dangerous_scrub group
 * xfs/28[56],xfs/56[56]: add to the auto group
 * xfs/349: reclassify this test as not dangerous
---
 doc/group-names.txt |   13 ++++++-------
 tests/xfs/285       |    2 +-
 tests/xfs/286       |    2 +-
 tests/xfs/349       |    3 +--
 tests/xfs/350       |    2 +-
 tests/xfs/351       |    2 +-
 tests/xfs/352       |    2 +-
 tests/xfs/353       |    2 +-
 tests/xfs/354       |    2 +-
 tests/xfs/355       |    2 +-
 tests/xfs/356       |    2 +-
 tests/xfs/357       |    2 +-
 tests/xfs/358       |    2 +-
 tests/xfs/359       |    2 +-
 tests/xfs/360       |    2 +-
 tests/xfs/361       |    2 +-
 tests/xfs/362       |    2 +-
 tests/xfs/363       |    2 +-
 tests/xfs/364       |    2 +-
 tests/xfs/365       |    2 +-
 tests/xfs/366       |    2 +-
 tests/xfs/367       |    2 +-
 tests/xfs/368       |    2 +-
 tests/xfs/369       |    2 +-
 tests/xfs/370       |    2 +-
 tests/xfs/371       |    2 +-
 tests/xfs/372       |    2 +-
 tests/xfs/373       |    2 +-
 tests/xfs/374       |    2 +-
 tests/xfs/375       |    2 +-
 tests/xfs/376       |    2 +-
 tests/xfs/377       |    2 +-
 tests/xfs/378       |    2 +-
 tests/xfs/379       |    2 +-
 tests/xfs/380       |    2 +-
 tests/xfs/381       |    2 +-
 tests/xfs/382       |    2 +-
 tests/xfs/383       |    2 +-
 tests/xfs/384       |    2 +-
 tests/xfs/385       |    2 +-
 tests/xfs/386       |    2 +-
 tests/xfs/387       |    2 +-
 tests/xfs/388       |    2 +-
 tests/xfs/389       |    2 +-
 tests/xfs/390       |    2 +-
 tests/xfs/391       |    2 +-
 tests/xfs/392       |    2 +-
 tests/xfs/393       |    2 +-
 tests/xfs/394       |    2 +-
 tests/xfs/395       |    2 +-
 tests/xfs/396       |    2 +-
 tests/xfs/397       |    2 +-
 tests/xfs/398       |    2 +-
 tests/xfs/399       |    2 +-
 tests/xfs/400       |    2 +-
 tests/xfs/401       |    2 +-
 tests/xfs/402       |    2 +-
 tests/xfs/403       |    2 +-
 tests/xfs/404       |    2 +-
 tests/xfs/405       |    2 +-
 tests/xfs/406       |    2 +-
 tests/xfs/407       |    2 +-
 tests/xfs/408       |    2 +-
 tests/xfs/409       |    2 +-
 tests/xfs/410       |    2 +-
 tests/xfs/411       |    2 +-
 tests/xfs/412       |    2 +-
 tests/xfs/413       |    2 +-
 tests/xfs/414       |    2 +-
 tests/xfs/415       |    2 +-
 tests/xfs/416       |    2 +-
 tests/xfs/417       |    2 +-
 tests/xfs/418       |    2 +-
 tests/xfs/422       |    2 +-
 tests/xfs/423       |    2 +-
 tests/xfs/425       |    2 +-
 tests/xfs/426       |    2 +-
 tests/xfs/427       |    2 +-
 tests/xfs/428       |    2 +-
 tests/xfs/429       |    2 +-
 tests/xfs/430       |    2 +-
 tests/xfs/453       |    2 +-
 tests/xfs/454       |    2 +-
 tests/xfs/455       |    2 +-
 tests/xfs/456       |    2 +-
 tests/xfs/457       |    2 +-
 tests/xfs/458       |    2 +-
 tests/xfs/459       |    2 +-
 tests/xfs/460       |    2 +-
 tests/xfs/461       |    2 +-
 tests/xfs/462       |    2 +-
 tests/xfs/463       |    2 +-
 tests/xfs/464       |    2 +-
 tests/xfs/465       |    2 +-
 tests/xfs/466       |    2 +-
 tests/xfs/467       |    2 +-
 tests/xfs/468       |    2 +-
 tests/xfs/469       |    2 +-
 tests/xfs/470       |    2 +-
 tests/xfs/471       |    2 +-
 tests/xfs/472       |    2 +-
 tests/xfs/473       |    2 +-
 tests/xfs/474       |    2 +-
 tests/xfs/475       |    2 +-
 tests/xfs/476       |    2 +-
 tests/xfs/477       |    2 +-
 tests/xfs/478       |    2 +-
 tests/xfs/479       |    2 +-
 tests/xfs/480       |    2 +-
 tests/xfs/481       |    2 +-
 tests/xfs/482       |    2 +-
 tests/xfs/483       |    2 +-
 tests/xfs/484       |    2 +-
 tests/xfs/485       |    2 +-
 tests/xfs/486       |    2 +-
 tests/xfs/487       |    2 +-
 tests/xfs/488       |    2 +-
 tests/xfs/489       |    2 +-
 tests/xfs/496       |    2 +-
 tests/xfs/497       |    2 +-
 tests/xfs/498       |    2 +-
 tests/xfs/561       |    2 +-
 tests/xfs/562       |    2 +-
 tests/xfs/563       |    2 +-
 tests/xfs/564       |    2 +-
 tests/xfs/565       |    2 +-
 tests/xfs/566       |    2 +-
 tests/xfs/570       |    2 +-
 tests/xfs/571       |    2 +-
 tests/xfs/572       |    2 +-
 tests/xfs/573       |    2 +-
 tests/xfs/574       |    2 +-
 tests/xfs/575       |    2 +-
 tests/xfs/576       |    2 +-
 tests/xfs/577       |    2 +-
 tests/xfs/578       |    2 +-
 tests/xfs/579       |    2 +-
 tests/xfs/580       |    2 +-
 tests/xfs/581       |    2 +-
 tests/xfs/582       |    2 +-
 tests/xfs/583       |    2 +-
 tests/xfs/584       |    2 +-
 tests/xfs/585       |    2 +-
 tests/xfs/586       |    2 +-
 tests/xfs/587       |    2 +-
 tests/xfs/588       |    2 +-
 tests/xfs/589       |    2 +-
 tests/xfs/590       |    2 +-
 tests/xfs/591       |    2 +-
 tests/xfs/592       |    2 +-
 tests/xfs/593       |    2 +-
 tests/xfs/594       |    2 +-
 tests/xfs/595       |    2 +-
 tests/xfs/621       |    2 +-
 tests/xfs/622       |    2 +-
 tests/xfs/628       |    2 +-
 tests/xfs/708       |    2 +-
 tests/xfs/709       |    2 +-
 tests/xfs/710       |    2 +-
 tests/xfs/711       |    2 +-
 tests/xfs/712       |    2 +-
 tests/xfs/713       |    2 +-
 tests/xfs/714       |    2 +-
 tests/xfs/715       |    2 +-
 tests/xfs/717       |    2 +-
 tests/xfs/718       |    2 +-
 tests/xfs/719       |    2 +-
 tests/xfs/721       |    2 +-
 tests/xfs/722       |    2 +-
 tests/xfs/723       |    2 +-
 tests/xfs/724       |    2 +-
 tests/xfs/725       |    2 +-
 tests/xfs/726       |    2 +-
 tests/xfs/727       |    2 +-
 tests/xfs/728       |    2 +-
 tests/xfs/729       |    2 +-
 tests/xfs/730       |    2 +-
 tests/xfs/731       |    2 +-
 tests/xfs/733       |    2 +-
 tests/xfs/734       |    2 +-
 tests/xfs/735       |    2 +-
 tests/xfs/736       |    2 +-
 tests/xfs/737       |    2 +-
 tests/xfs/738       |    2 +-
 tests/xfs/739       |    2 +-
 tests/xfs/740       |    2 +-
 tests/xfs/741       |    2 +-
 tests/xfs/742       |    2 +-
 tests/xfs/743       |    2 +-
 tests/xfs/744       |    2 +-
 tests/xfs/745       |    2 +-
 tests/xfs/746       |    2 +-
 tests/xfs/747       |    2 +-
 tests/xfs/748       |    2 +-
 tests/xfs/749       |    2 +-
 tests/xfs/750       |    2 +-
 tests/xfs/751       |    2 +-
 tests/xfs/752       |    2 +-
 tests/xfs/753       |    2 +-
 tests/xfs/754       |    2 +-
 tests/xfs/755       |    2 +-
 tests/xfs/756       |    2 +-
 tests/xfs/757       |    2 +-
 tests/xfs/758       |    2 +-
 tests/xfs/759       |    2 +-
 tests/xfs/760       |    2 +-
 tests/xfs/761       |    2 +-
 tests/xfs/762       |    2 +-
 tests/xfs/763       |    2 +-
 tests/xfs/764       |    2 +-
 tests/xfs/765       |    2 +-
 tests/xfs/766       |    2 +-
 tests/xfs/767       |    2 +-
 tests/xfs/768       |    2 +-
 tests/xfs/769       |    2 +-
 tests/xfs/770       |    2 +-
 tests/xfs/771       |    2 +-
 tests/xfs/772       |    2 +-
 tests/xfs/773       |    2 +-
 tests/xfs/774       |    2 +-
 tests/xfs/775       |    2 +-
 tests/xfs/776       |    2 +-
 tests/xfs/777       |    2 +-
 tests/xfs/778       |    2 +-
 tests/xfs/779       |    2 +-
 tests/xfs/780       |    2 +-
 tests/xfs/781       |    2 +-
 tests/xfs/782       |    2 +-
 tests/xfs/783       |    2 +-
 tests/xfs/784       |    2 +-
 tests/xfs/785       |    2 +-
 tests/xfs/786       |    2 +-
 tests/xfs/787       |    2 +-
 tests/xfs/788       |    2 +-
 tests/xfs/793       |    2 +-
 tests/xfs/794       |    2 +-
 tests/xfs/796       |    2 +-
 tests/xfs/797       |    2 +-
 tests/xfs/799       |    2 +-
 tests/xfs/800       |    2 +-
 tests/xfs/801       |    2 +-
 241 files changed, 246 insertions(+), 248 deletions(-)

