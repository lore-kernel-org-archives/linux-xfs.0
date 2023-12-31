Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BD3C13B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gz1fTgmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55518C433C7;
	Sun, 31 Dec 2023 22:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063203;
	bh=y98u+KsOsj914TkccHMiJ4vGcXOaZPJrNAOA1jHAyQ8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Gz1fTgmpvE3+5OY5oKUoQT28aMdf/rjHOIPUwVSs8100gSS2lOzhQjEV3kbDaUYAA
	 xs92bz51i40lC5DOhUM7IzelFXEHY9HyIxkWhO3BYSHaXH/7e1lmf1Tf0XoNNK0Cy/
	 xkKCqYVoJWn5z+7/1orzrideXQJJKKKW1cOo6hzW5bnrzLvztxH6uWWwGLD34YTvp2
	 /HKhebkbKdv46otgmDv92YmwHShEW5U/YiA982lJOLHJBrGo2RNFUoxudiHgeCTBaK
	 OmPwPYHNImYxOwBhmq2xzjqYnFrYG22Oi/dnMotWwiT5osxxpuptBtcGep8gTo1uvd
	 2akZTtM3KDDrg==
Date: Sun, 31 Dec 2023 14:53:22 -0800
Subject: [PATCH 4/9] xfs_scrub_fail: fix sendmail detection
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170405001898.1800712.12623844675618759314.stgit@frogsfrogsfrogs>
In-Reply-To: <170405001841.1800712.6745668619742020884.stgit@frogsfrogsfrogs>
References: <170405001841.1800712.6745668619742020884.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

This script emails the results of failed scrub runs to root.  We
shouldn't be hardcoding the path to the mailer program because distros
can change the path according to their whim.  Modify this script to use
command -v to find the program.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/xfs_scrub_fail.in |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/scrub/xfs_scrub_fail.in b/scrub/xfs_scrub_fail.in
index 0bceda6403d..d6a3d92159b 100755
--- a/scrub/xfs_scrub_fail.in
+++ b/scrub/xfs_scrub_fail.in
@@ -7,13 +7,14 @@
 
 # Email logs of failed xfs_scrub unit runs
 
-mailer=/usr/sbin/sendmail
 recipient="$1"
 test -z "${recipient}" && exit 0
 mntpoint="$2"
 test -z "${mntpoint}" && exit 0
 hostname="$(hostname -f 2>/dev/null)"
 test -z "${hostname}" && hostname="${HOSTNAME}"
+
+mailer="$(command -v sendmail)"
 if [ ! -x "${mailer}" ]; then
 	echo "${mailer}: Mailer program not found."
 	exit 1

