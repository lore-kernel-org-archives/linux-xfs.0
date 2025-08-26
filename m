Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816A1393DF2
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 12:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756211016; cv=none; b=NZbPzi5xmJ4mVLJP03t8+tTqolRmHWfUQSwBocTc4lPo2e4Ib+d4aySd2IBoUlifCayf6urCma0+nys0IOBmVxv95FZpSnZnr7NBUKDPNJ1SuDqib/x4AkKfyVN1jIVHvL0mPEiuBIZQCjJYa5xeVaYX/0InYPHSsfUXIIuXaG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756211016; c=relaxed/simple;
	bh=iAv0hJ/aJ5/RitAtwlqSDCuJBWO+H5Btf20RBoE9mlY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=umg/Wx7nI420B1dt4TPTotwkYseDimnwxdB7r2x5zy/LnZjBFbZ0grmdRi3uuOQhUBfzHyKdfndO8OAdG+oaR07A+oeiOA5UPByvD17ulAGPXD2w9Q3WEjpkt4UWOSA9Zb5zfRO6o8L9PSWxQTld+LQbgcjdW1DJG+Yf36oidsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XxdhxNkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XxdhxNkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98305C4CEF1;
	Tue, 26 Aug 2025 12:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756211014;
	bh=iAv0hJ/aJ5/RitAtwlqSDCuJBWO+H5Btf20RBoE9mlY=;
	h=From:To:Cc:Subject:Date:From;
	b=XxdhxNknQsSKiDd2xa0TGMsSEw/rOrctTThuFmnDe8Iojr8NNHnXtqtCNFW5LwYza
	 zh1U1Ib7VMC04VdYH6BCVgy6+ynrcuE3Z3goZmxREHgtaJdrw5Mf9GQynjiKY4vApp
	 Wgvp0BpgTDwDonTxrGlzUdIBsJfF3fKyupF/4esNYs4Jm7VK4IVt/CqptDdyczvkUJ
	 l4JZ/3UKCyObODq1lovnkwsVDhl9hdvhXAIeElOQsi+7RS0DD2Z3JPPiTW825wHlnB
	 FgLPVVIDpZI8nLSu90mcDkjiwZdNRD/reNUO4LwTmk9QOkDK28erKsaBwByK9kLARB
	 Z2Ydh5SsFvgew==
From: cem@kernel.org
To: aalbersh@redhat.com
Cc: david@fromorbit.com,
	djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] Improve information about logbsize valid values
Date: Tue, 26 Aug 2025 14:23:12 +0200
Message-ID: <20250826122320.237816-1-cem@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Valid values for logbsize depends on whether log_sunit is set
on the filesystem or not and if logbsize is manually set or not.

When manually set, logbsize must be one of the speficied values -
32k to 256k inclusive in power-of-to increments. And, the specified
value must also be a multiple of log_sunit.

The default configuration for v2 logs uses a relaxed restriction,
setting logbsize to log_sunit, independent if it is one of the valid
values or not - also implicitly ignoring the power of two restriction.

Instead of changing valid possible values for logbsize, increasing the
testing matrix and allowing users to use some dubious configuration,
just update the man page to describe this difference in behavior when
manually setting logbsize or leave it to defaults.

This has originally been found by an user attempting to manually set
logbsize to the same value picked by the default configuration just so
to receive an error message as result.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 man/man5/xfs.5 | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/man/man5/xfs.5 b/man/man5/xfs.5
index f9c046d4721a..b2069d17b0fe 100644
--- a/man/man5/xfs.5
+++ b/man/man5/xfs.5
@@ -246,16 +246,18 @@ controls the size of each buffer and so is also relevant to
 this case.
 .TP
 .B logbsize=value
-Set the size of each in-memory log buffer.  The size may be
+Set the size of each in-memory log buffer. The size may be
 specified in bytes, or in kibibytes (KiB) with a "k" suffix.
+If set manually, logbsize must be one of the specified valid
+sizes and a multiple of the log stripe unit - configured at mkfs time.
+.sp
 Valid sizes for version 1 and version 2 logs are 16384 (value=16k)
 and 32768 (value=32k).  Valid sizes for version 2 logs also
-include 65536 (value=64k), 131072 (value=128k) and 262144 (value=256k). The
-logbsize must be an integer multiple of the log
-stripe unit configured at mkfs time.
+include 65536 (value=64k), 131072 (value=128k) and 262144 (value=256k).
 .sp
 The default value for version 1 logs is 32768, while the
-default value for version 2 logs is max(32768, log_sunit).
+default value for version 2 logs is max(32768, log_sunit) even if
+log_sunit does not match one of the valid values above.
 .TP
 .BR logdev=device " and " rtdev=device
 Use an external log (metadata journal) and/or real-time device.
-- 
2.51.0

