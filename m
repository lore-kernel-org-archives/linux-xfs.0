Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62F538F82
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734989812; cv=none; b=kvAyDcmpk2dzeXV2QRKhLfnMhdJ5gVY/Vo3Rc7m6aZ21MwYHVtaytZ9IP6F3iSm/PwGnDUZKQzQ8YyetZSJb5XwrgTzmKjKtw6JwYM4RCs90vo0WrygU1wxzn7PnvdND6V8UzJyuW2tUaX3e46itOGaCChsCMWnUP8UD389pIDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734989812; c=relaxed/simple;
	bh=r4LRIVltITO21AbPivmzhRo80jBA8npW90ONb+XUkYY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TUAdLTeG1Gpn1PwqFXRNsmPGW2uUaUpAsCnfQyjZE8vULhCytbos78XwEBJqm2Rdy19aACd/f6sboIfUy3AUMU3marhO+7qZa8hsfh1pUdZfvoAERt8I8t1ZNeosDQ3vz1aL1gx5HfVlB7CvaPG3X5M9iTlSXjHXT7I2vErCtCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t64C6Mte; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t64C6Mte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6115FC4CED3;
	Mon, 23 Dec 2024 21:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734989812;
	bh=r4LRIVltITO21AbPivmzhRo80jBA8npW90ONb+XUkYY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=t64C6Mtex75gIdFNHz4UEI0HGtWzX0g0Z5dhBFaQGK7NXwROgYwCEUCp/PyBXUdTW
	 OJOGdsvv5m+w8BLEi6kB4mDIJyA4UWBytD2ORigts0FUg2BekN0enQHevaVf6RMJ5l
	 32DAvjeoxdNVys34uwDv873zCVpkGVSJjkRQ5MaTNw9fvwFAgRGSsN2RB6FDISKmEK
	 qs9rVV+20uwAhdYqr8Z/wxurTLquADf05moPdPp236XdJ05JvG1bu1i4cRBwvWpEhJ
	 kJORLfboHbBQQaWAnYtiARJBIpVS/4LPrQ6iY22/+QTJws9PYTU0pz9k0x2Fjtp6Ji
	 lSyTAgktHh14g==
Date: Mon, 23 Dec 2024 13:36:51 -0800
Subject: [PATCH 2/3] man: fix ioctl_xfs_commit_range man page install
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: jpalus@fastmail.com, linux-xfs@vger.kernel.org
Message-ID: <173498939512.2292884.4133253243786267430.stgit@frogsfrogsfrogs>
In-Reply-To: <173498939477.2292884.7220593538958401281.stgit@frogsfrogsfrogs>
References: <173498939477.2292884.7220593538958401281.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Jan Palus <jpalus@fastmail.com>

INSTALL_MAN uses first symbol in .SH NAME section for both source and
destination filename hence it needs to match current filename. since
ioctl_xfs_commit_range.2 documents both ioctl_xfs_start_commit as well
as ioctl_xfs_commit_range ensure they are listed in order INSTALL_MAN
expects.

Signed-off-by: Jan Palus <jpalus@fastmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 man/man2/ioctl_xfs_commit_range.2 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/man/man2/ioctl_xfs_commit_range.2 b/man/man2/ioctl_xfs_commit_range.2
index 3244e52c3e0946..4cd074ed00c6f2 100644
--- a/man/man2/ioctl_xfs_commit_range.2
+++ b/man/man2/ioctl_xfs_commit_range.2
@@ -22,8 +22,8 @@
 .\" %%%LICENSE_END
 .TH IOCTL-XFS-COMMIT-RANGE 2  2024-02-18 "XFS"
 .SH NAME
-ioctl_xfs_start_commit \- prepare to exchange the contents of two files
 ioctl_xfs_commit_range \- conditionally exchange the contents of parts of two files
+ioctl_xfs_start_commit \- prepare to exchange the contents of two files
 .SH SYNOPSIS
 .br
 .B #include <sys/ioctl.h>

