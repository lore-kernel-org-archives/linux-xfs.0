Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8808013AF2;
	Thu, 20 Feb 2025 22:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740089076; cv=none; b=m8p1irCPkCWQEIkxQzH7t7fO3JYHfy3IF/0sF1msJ19Qz59qo9LgoaoxktqFh/mgn0AFS4nr/2wQCO68hZG7UO4iqysGaRDamfgECZvs7lXg8bCxTnJsQu/3vsiIhBEIBMo66NeYOpuym3xtnUk/lGBGHq2dZsg7euB1ioq7srg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740089076; c=relaxed/simple;
	bh=dnOHDTcnA5mYU/5G3vbZCU1MwR4PGEiISGK0fRegAEI=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=eE7oDZZK1Zz3YA/wkIZ7T9szskzPzVquUwg8iyxrVy8tG0dZwPcJOggJgN+YX+PAe1PZPrCUbA3VJjbZ6kSObjIDv0q+/rBrqCEb2maBwvMu/odea8y+hx5oPFWRa8v7MW0Nj+s8Y9E+w6fQWeNB+Hz81ZCfChFgpZKiXScm9JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YzlWXNLi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YzlWXNLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE190C4CED1;
	Thu, 20 Feb 2025 22:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740089076;
	bh=dnOHDTcnA5mYU/5G3vbZCU1MwR4PGEiISGK0fRegAEI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YzlWXNLi6bN7IWim+haFtOvNFR9gxhlFIEHMCJb8uE9JpVIOmHxAgGe1zvq1JP9kK
	 vDGGqyUGpmtDaJhUc4un1Zqr8RIVYUN+W40oy/Ww+PTIK7CgA7Hqhm9vVJC+hCQrvd
	 U4FkP5GMG2sADBWk6AcUvk1zy+49uuBgkETChQVUqIAEeVltdeAqpTxwAOfRUuggAX
	 38cPpYftkWwWrexf3oJUqXVNMbCoGW8uJB4IgAUyejr/7xFblPG7JIeX8bUpOKJsXD
	 /IR+0ABfQT6mlJID5OC/QKSpilpVi/2z0/Zm/S82bBOhUsWyPddkYvM/q0t6f0uhTE
	 JNTwOM/EmGvnQ==
Date: Thu, 20 Feb 2025 14:04:35 -0800
Subject: [GIT PULL 02/10] fstests: fix online and offline fsck test groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <174008901548.1712746.15590408272052576647.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250220220245.GW21799@frogsfrogsfrogs>
References: <20250220220245.GW21799@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Zorro,

Please pull this branch with changes for fstests.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 977d2533c261382a656417d4288ca79f15fc7655:

dio_writeback_race: align the directio buffer to base page size (2025-02-20 13:52:16 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git tags/fix-fsck-test-classifications_2025-02-20

for you to fetch changes up to 84b69f0072563cbfe23f02bd462f092339976c8a:

xfs/349: reclassify this test as not dangerous (2025-02-20 13:52:17 -0800)

----------------------------------------------------------------
fstests: fix online and offline fsck test groups [v32.2 02/22]

I've been working on online fsck for years, and hardening offline fsck
whenever I notice easy to fix discrepancies between the two tools.  Now
that it's been a couple of years since I've seen any problems, I think
it's time to open this to wider testing by dropping /some/ of the
"dangerous" tags.

While working on this I also noticed that some of the fuzz tests were
misclassified, so this patchset fixes those problems too.

With a bit of luck, this should all go splendidly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (12):
misc: drop the dangerous label from xfs_scrub fsstress tests
misc: rename the dangerous_repair group to fuzzers_repair
misc: rename the dangerous_online_repair group to fuzzers_online_repair
misc: rename the dangerous_bothrepair group to fuzzers_bothrepair
misc: rename the dangerous_norepair group to fuzzers_norepair
misc: fix misclassification of xfs_repair fuzz tests
misc: fix misclassification of xfs_scrub + xfs_repair fuzz tests
misc: fix misclassification of verifier fuzz tests
misc: add xfs_scrub + xfs_repair fuzz tests to the scrub and repair groups
misc: remove the dangerous_scrub group
xfs/28[56],xfs/56[56]: add to the auto group
xfs/349: reclassify this test as not dangerous

doc/group-names.txt | 13 ++++++-------
tests/xfs/285       |  2 +-
tests/xfs/286       |  2 +-
tests/xfs/349       |  3 +--
tests/xfs/350       |  2 +-
tests/xfs/351       |  2 +-
tests/xfs/352       |  2 +-
tests/xfs/353       |  2 +-
tests/xfs/354       |  2 +-
tests/xfs/355       |  2 +-
tests/xfs/356       |  2 +-
tests/xfs/357       |  2 +-
tests/xfs/358       |  2 +-
tests/xfs/359       |  2 +-
tests/xfs/360       |  2 +-
tests/xfs/361       |  2 +-
tests/xfs/362       |  2 +-
tests/xfs/363       |  2 +-
tests/xfs/364       |  2 +-
tests/xfs/365       |  2 +-
tests/xfs/366       |  2 +-
tests/xfs/367       |  2 +-
tests/xfs/368       |  2 +-
tests/xfs/369       |  2 +-
tests/xfs/370       |  2 +-
tests/xfs/371       |  2 +-
tests/xfs/372       |  2 +-
tests/xfs/373       |  2 +-
tests/xfs/374       |  2 +-
tests/xfs/375       |  2 +-
tests/xfs/376       |  2 +-
tests/xfs/377       |  2 +-
tests/xfs/378       |  2 +-
tests/xfs/379       |  2 +-
tests/xfs/380       |  2 +-
tests/xfs/381       |  2 +-
tests/xfs/382       |  2 +-
tests/xfs/383       |  2 +-
tests/xfs/384       |  2 +-
tests/xfs/385       |  2 +-
tests/xfs/386       |  2 +-
tests/xfs/387       |  2 +-
tests/xfs/388       |  2 +-
tests/xfs/389       |  2 +-
tests/xfs/390       |  2 +-
tests/xfs/391       |  2 +-
tests/xfs/392       |  2 +-
tests/xfs/393       |  2 +-
tests/xfs/394       |  2 +-
tests/xfs/395       |  2 +-
tests/xfs/396       |  2 +-
tests/xfs/397       |  2 +-
tests/xfs/398       |  2 +-
tests/xfs/399       |  2 +-
tests/xfs/400       |  2 +-
tests/xfs/401       |  2 +-
tests/xfs/402       |  2 +-
tests/xfs/403       |  2 +-
tests/xfs/404       |  2 +-
tests/xfs/405       |  2 +-
tests/xfs/406       |  2 +-
tests/xfs/407       |  2 +-
tests/xfs/408       |  2 +-
tests/xfs/409       |  2 +-
tests/xfs/410       |  2 +-
tests/xfs/411       |  2 +-
tests/xfs/412       |  2 +-
tests/xfs/413       |  2 +-
tests/xfs/414       |  2 +-
tests/xfs/415       |  2 +-
tests/xfs/416       |  2 +-
tests/xfs/417       |  2 +-
tests/xfs/418       |  2 +-
tests/xfs/422       |  2 +-
tests/xfs/423       |  2 +-
tests/xfs/425       |  2 +-
tests/xfs/426       |  2 +-
tests/xfs/427       |  2 +-
tests/xfs/428       |  2 +-
tests/xfs/429       |  2 +-
tests/xfs/430       |  2 +-
tests/xfs/453       |  2 +-
tests/xfs/454       |  2 +-
tests/xfs/455       |  2 +-
tests/xfs/456       |  2 +-
tests/xfs/457       |  2 +-
tests/xfs/458       |  2 +-
tests/xfs/459       |  2 +-
tests/xfs/460       |  2 +-
tests/xfs/461       |  2 +-
tests/xfs/462       |  2 +-
tests/xfs/463       |  2 +-
tests/xfs/464       |  2 +-
tests/xfs/465       |  2 +-
tests/xfs/466       |  2 +-
tests/xfs/467       |  2 +-
tests/xfs/468       |  2 +-
tests/xfs/469       |  2 +-
tests/xfs/470       |  2 +-
tests/xfs/471       |  2 +-
tests/xfs/472       |  2 +-
tests/xfs/473       |  2 +-
tests/xfs/474       |  2 +-
tests/xfs/475       |  2 +-
tests/xfs/476       |  2 +-
tests/xfs/477       |  2 +-
tests/xfs/478       |  2 +-
tests/xfs/479       |  2 +-
tests/xfs/480       |  2 +-
tests/xfs/481       |  2 +-
tests/xfs/482       |  2 +-
tests/xfs/483       |  2 +-
tests/xfs/484       |  2 +-
tests/xfs/485       |  2 +-
tests/xfs/486       |  2 +-
tests/xfs/487       |  2 +-
tests/xfs/488       |  2 +-
tests/xfs/489       |  2 +-
tests/xfs/496       |  2 +-
tests/xfs/497       |  2 +-
tests/xfs/498       |  2 +-
tests/xfs/561       |  2 +-
tests/xfs/562       |  2 +-
tests/xfs/563       |  2 +-
tests/xfs/564       |  2 +-
tests/xfs/565       |  2 +-
tests/xfs/566       |  2 +-
tests/xfs/570       |  2 +-
tests/xfs/571       |  2 +-
tests/xfs/572       |  2 +-
tests/xfs/573       |  2 +-
tests/xfs/574       |  2 +-
tests/xfs/575       |  2 +-
tests/xfs/576       |  2 +-
tests/xfs/577       |  2 +-
tests/xfs/578       |  2 +-
tests/xfs/579       |  2 +-
tests/xfs/580       |  2 +-
tests/xfs/581       |  2 +-
tests/xfs/582       |  2 +-
tests/xfs/583       |  2 +-
tests/xfs/584       |  2 +-
tests/xfs/585       |  2 +-
tests/xfs/586       |  2 +-
tests/xfs/587       |  2 +-
tests/xfs/588       |  2 +-
tests/xfs/589       |  2 +-
tests/xfs/590       |  2 +-
tests/xfs/591       |  2 +-
tests/xfs/592       |  2 +-
tests/xfs/593       |  2 +-
tests/xfs/594       |  2 +-
tests/xfs/595       |  2 +-
tests/xfs/621       |  2 +-
tests/xfs/622       |  2 +-
tests/xfs/628       |  2 +-
tests/xfs/708       |  2 +-
tests/xfs/709       |  2 +-
tests/xfs/710       |  2 +-
tests/xfs/711       |  2 +-
tests/xfs/712       |  2 +-
tests/xfs/713       |  2 +-
tests/xfs/714       |  2 +-
tests/xfs/715       |  2 +-
tests/xfs/717       |  2 +-
tests/xfs/718       |  2 +-
tests/xfs/719       |  2 +-
tests/xfs/721       |  2 +-
tests/xfs/722       |  2 +-
tests/xfs/723       |  2 +-
tests/xfs/724       |  2 +-
tests/xfs/725       |  2 +-
tests/xfs/726       |  2 +-
tests/xfs/727       |  2 +-
tests/xfs/728       |  2 +-
tests/xfs/729       |  2 +-
tests/xfs/730       |  2 +-
tests/xfs/731       |  2 +-
tests/xfs/733       |  2 +-
tests/xfs/734       |  2 +-
tests/xfs/735       |  2 +-
tests/xfs/736       |  2 +-
tests/xfs/737       |  2 +-
tests/xfs/738       |  2 +-
tests/xfs/739       |  2 +-
tests/xfs/740       |  2 +-
tests/xfs/741       |  2 +-
tests/xfs/742       |  2 +-
tests/xfs/743       |  2 +-
tests/xfs/744       |  2 +-
tests/xfs/745       |  2 +-
tests/xfs/746       |  2 +-
tests/xfs/747       |  2 +-
tests/xfs/748       |  2 +-
tests/xfs/749       |  2 +-
tests/xfs/750       |  2 +-
tests/xfs/751       |  2 +-
tests/xfs/752       |  2 +-
tests/xfs/753       |  2 +-
tests/xfs/754       |  2 +-
tests/xfs/755       |  2 +-
tests/xfs/756       |  2 +-
tests/xfs/757       |  2 +-
tests/xfs/758       |  2 +-
tests/xfs/759       |  2 +-
tests/xfs/760       |  2 +-
tests/xfs/761       |  2 +-
tests/xfs/762       |  2 +-
tests/xfs/763       |  2 +-
tests/xfs/764       |  2 +-
tests/xfs/765       |  2 +-
tests/xfs/766       |  2 +-
tests/xfs/767       |  2 +-
tests/xfs/768       |  2 +-
tests/xfs/769       |  2 +-
tests/xfs/770       |  2 +-
tests/xfs/771       |  2 +-
tests/xfs/772       |  2 +-
tests/xfs/773       |  2 +-
tests/xfs/774       |  2 +-
tests/xfs/775       |  2 +-
tests/xfs/776       |  2 +-
tests/xfs/777       |  2 +-
tests/xfs/778       |  2 +-
tests/xfs/779       |  2 +-
tests/xfs/780       |  2 +-
tests/xfs/781       |  2 +-
tests/xfs/782       |  2 +-
tests/xfs/783       |  2 +-
tests/xfs/784       |  2 +-
tests/xfs/785       |  2 +-
tests/xfs/786       |  2 +-
tests/xfs/787       |  2 +-
tests/xfs/788       |  2 +-
tests/xfs/793       |  2 +-
tests/xfs/794       |  2 +-
tests/xfs/796       |  2 +-
tests/xfs/797       |  2 +-
tests/xfs/799       |  2 +-
tests/xfs/800       |  2 +-
tests/xfs/801       |  2 +-
241 files changed, 246 insertions(+), 248 deletions(-)

