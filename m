Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B80441056
	for <linux-xfs@vger.kernel.org>; Tue, 20 Jan 2026 17:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768931480; cv=none; b=kZf8cMqD/TZ+7lG9nukpxjcemzwfMNFPL6kIAsoCx4SYsXvQWxHpzJvLD6/1mS5M8zmANIdH23ntV8yw9CWBgXZPpmiiOwcVueP5cx6qEGVb8YcVAnJmPNTYlNCHSTZ28MkW553mPf3W+CAGm8O7lLIfPpcCErWq/yPKlITDk0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768931480; c=relaxed/simple;
	bh=xHOy4DPx4HJyjF0v9JMr4cNnGkCMARqaHZNfjkH09hk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZqPxagYySP9l6auy1AZXoK7+x0FPQIPf+0R9HaEZVcLdu3yr0i3uprF/BuP/vIKA72vPeKTezPCIiwBKdMujUvAagh0tFB4lejvLQgSgRcQ0aQxssjZP/sHmU6WG7TbKa4a8MSkctZKyQWypAraQiT6bDBC7H0Bzs175EWZKPBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oVG5lJ3j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oVG5lJ3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E236C16AAE;
	Tue, 20 Jan 2026 17:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768931480;
	bh=xHOy4DPx4HJyjF0v9JMr4cNnGkCMARqaHZNfjkH09hk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oVG5lJ3jYOg4KyXcoE/5aEBYcQGHI9yL50wQ3qd/3zER5nJ6VKj5UIkQ93eeNdqSj
	 yCcyXFCRbMOvop5k1GaOaC29U2qm66JK11CMtgBYoSU8gOIrWQP/jhrkeJfIwq4eqk
	 M5z76SZYojHxwi8JhhdMxTV5v5fuM6L4wk58L1Wtt6bdElGMXo4FfhTxWCNsw0uH+I
	 M01GdKRRDGaaW8026Xsggnf8RQdtHTPHsYBHofCP2Tpx/Zc8+PmliUZZEREZXXEJCk
	 glYf7Fk1+79XnPeBAo6Wq9VwpoRzBtGQ9xscIX4iwwIHXR16uga8cH5v+4xeO2i+Av
	 jY+UaEFypydIQ==
Date: Tue, 20 Jan 2026 09:51:19 -0800
Subject: [PATCH 3/5] mkfs: quiet down warning about insufficient write zones
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <176893137126.1079372.2017206002280736908.stgit@frogsfrogsfrogs>
In-Reply-To: <176893137046.1079372.10421059565558082402.stgit@frogsfrogsfrogs>
References: <176893137046.1079372.10421059565558082402.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

xfs/067 fails with the following weird mkfs message:

 --- tests/xfs/067.out	2025-07-15 14:41:40.191273467 -0700
 +++ /run/fstests/logs/xfs/067.out.bad	2026-01-06 16:59:11.907677987 -0800
 @@ -1,4 +1,8 @@
  QA output created by 067
 +Warning: not enough zones (134/133) for backing requested rt size due to
 +over-provisioning needs, writable size will be less than (null)
 +Warning: not enough zones (134/133) for backing requested rt size due to
 +over-provisioning needs, writable size will be less than (null)

In this case, MKFS_OPTIONS is set to: "-rrtdev=/dev/sdb4 -m
metadir=1,autofsck=1,uquota,gquota,pquota -d rtinherit=1 -r zoned=1
/dev/sda4"

In other words, we didn't pass an explicit rt volume size to mkfs, so
the message is a bit bogus.  Let's skip printing the message when
the user did not provide an explicit rtsize parameter.

Cc: <linux-xfs@vger.kernel.org> # v6.18.0
Fixes: b5d372d96db1ad ("mkfs: adjust_nr_zones for zoned file system on conventional devices")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index a90160b26065b7..f539c91db251fd 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -4579,10 +4579,11 @@ adjust_nr_zones(
 				cfg->rgsize;
 
 	if (cfg->rgcount > max_zones) {
-		fprintf(stderr,
+		if (cli->rtsize)
+			fprintf(stderr,
 _("Warning: not enough zones (%lu/%u) for backing requested rt size due to\n"
   "over-provisioning needs, writable size will be less than %s\n"),
-			cfg->rgcount, max_zones, cli->rtsize);
+				cfg->rgcount, max_zones, cli->rtsize);
 		cfg->rgcount = max_zones;
 	}
 	new_rtblocks = (cfg->rgcount * cfg->rgsize);

