Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA348BE2
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882407; cv=none; b=BjbcqFbzEZrZvDyh9y76C1quuMlUB4R8MxPxu0G/0tF2kydYAib+PC14s4qOHxdsNO4jjYjoKQ+QOdgMeQ5lWUa2EYOnX6YlLhKSgAeJchk7M5YCdPQSjmwVVEyI6PzHExeER+FdpFF+zWOqhm61/FQ8TtbzUTN5cD2wtz9tl1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882407; c=relaxed/simple;
	bh=t0UlHfzSDydRduZ5/ttHdy21TLtLG984/0bJiDQH/rE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LqRqp2epopqa8yoOuUz/i9lWwWV1AEddxfiwFlpeAO+u9ZmRc+wKXAawUw+cQvVj8rMNL8s8RUfgLeIv3CMw7e6oXDpCEgbl91ZCezPPzvrtvoBtIU1xywsanN60CCIMX+xM2GAOhx5OvRGzNsGU8uINXDQmlDmjGfZaBphFM6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=okcKbf48; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="okcKbf48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C67AC116B1;
	Tue,  2 Jul 2024 01:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882407;
	bh=t0UlHfzSDydRduZ5/ttHdy21TLtLG984/0bJiDQH/rE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=okcKbf48sUJIUrmh1+r5MEhNA3XLqp2PrkO7nz0ksEznJkmvZGGOU0LrXOByNX/W4
	 QrQkHSkg0GLiYxisCR2sm9sNCCUqGYjfDTJBSJBRZbEehCJ+2uLsB9SnFf0aZdERq9
	 VnjfTwizn0edpBl1Zv1mrMToJPVna3C9O53lo0mhCty/X4ft3fHCwxiMJBua/Oyryc
	 nWELPiaPjDTp/QcSc8s0Hxhd61SO/LWQd0D8eh8aKxzRcyA9FsLQ/zE2PIDqHTmHpr
	 6Ti7G2zfs4i1xN7bC2qXmvml0ciXfB4/soKOgDtpmys8W3o71XnP8kd2S5184dIa2h
	 mVo7fGr0TtTZQ==
Date: Mon, 01 Jul 2024 18:06:46 -0700
Subject: [PATCH 2/6] xfs_scrub_all: remove journalctl background process
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988119439.2008463.11717166273939123673.stgit@frogsfrogsfrogs>
In-Reply-To: <171988119402.2008463.10432604765226555660.stgit@frogsfrogsfrogs>
References: <171988119402.2008463.10432604765226555660.stgit@frogsfrogsfrogs>
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

Now that we only start systemd services if we're running in service
mode, there's no need for the background journalctl process that only
ran if we had started systemd services in non-service mode.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_all.in |   14 --------------
 1 file changed, 14 deletions(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index f27251fa5439..fc7a2e637efa 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -261,17 +261,6 @@ def main():
 
 	fs = find_mounts()
 
-	# Tail the journal if we ourselves aren't a service...
-	journalthread = None
-	if 'SERVICE_MODE' not in os.environ:
-		try:
-			cmd=['journalctl', '--no-pager', '-q', '-S', 'now', \
-					'-f', '-u', 'xfs_scrub@*', '-o', \
-					'cat']
-			journalthread = subprocess.Popen(cmd)
-		except:
-			pass
-
 	# Schedule scrub jobs...
 	running_devs = set()
 	killfuncs = set()
@@ -308,9 +297,6 @@ def main():
 	while len(killfuncs) > 0:
 		wait_for_termination(cond, killfuncs)
 
-	if journalthread is not None:
-		journalthread.terminate()
-
 	# See the service mode comments in xfs_scrub.c for why we do this.
 	if 'SERVICE_MODE' in os.environ:
 		time.sleep(2)

