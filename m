Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 295BDC7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:54:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbjEZBye (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjEZByd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:54:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C9D189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:54:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A173764043
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15CD8C433D2;
        Fri, 26 May 2023 01:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066072;
        bh=GSASybxWIZOkgNdWWtk4XvykyKbow7NjpJEz28HoGPU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Py8095wJyXubB91xjTgdPwNu08Tda7rifBra1tI6Ar7sdj5W4xajoqwxLpC9C58A4
         1bFUGvOTOgZZ2xA4juUOmBuO/hC/D8TMMNKKVBCX+LuuBiYsMX83PEsK4KpQYpGDZ3
         seQB/cU7qKFCtUFRofQsqjd2MoynY7GIdnXUarz7xmTmuGG+D4iw23lLp0A6mCidL+
         wsjHDS3Cfv8rcl5Vve6VtWZTrjnQYbOq7hMqGkUcEswjxCq0Gh+vpOYB4bhgj+PMWj
         Sdij51mFYzEfwTl8z4gQt6ViNtzkHNBv3qOC+pjUj7c8wEO5J0t/FRYVFk5wQbP2Fu
         rv1dYCyieNzlQ==
Date:   Thu, 25 May 2023 18:54:31 -0700
Subject: [PATCH 3/4] xfs_scrub_all: simplify cleanup of run_killable
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506074216.3745941.15053679918709139887.stgit@frogsfrogsfrogs>
In-Reply-To: <168506074176.3745941.5054006111815853213.stgit@frogsfrogsfrogs>
References: <168506074176.3745941.5054006111815853213.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Get rid of the nested lambda functions to simplify the code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_all.in |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index 75b3075949c..0cf67b80d68 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -72,14 +72,14 @@ def remove_killfunc(killfuncs, fn):
 	except:
 		pass
 
-def run_killable(cmd, stdout, killfuncs, kill_fn):
-	'''Run a killable program.  Returns program retcode or -1 if we can't start it.'''
+def run_killable(cmd, stdout, killfuncs):
+	'''Run a killable program.  Returns program retcode or -1 if we can't
+	start it.'''
 	try:
 		proc = subprocess.Popen(cmd, stdout = stdout)
-		real_kill_fn = lambda: kill_fn(proc)
-		killfuncs.add(real_kill_fn)
+		killfuncs.add(proc.terminate)
 		proc.wait()
-		remove_killfunc(killfuncs, real_kill_fn)
+		remove_killfunc(killfuncs, proc.terminate)
 		return proc.returncode
 	except:
 		return -1
@@ -178,8 +178,7 @@ def run_scrub(mnt, cond, running_devs, mntdevs, killfuncs):
 		cmd = ['@sbindir@/xfs_scrub']
 		cmd += '@scrub_args@'.split()
 		cmd += [mnt]
-		ret = run_killable(cmd, None, killfuncs, \
-				lambda proc: proc.terminate())
+		ret = run_killable(cmd, None, killfuncs)
 		if ret >= 0:
 			print("Scrubbing %s done, (err=%d)" % (mnt, ret))
 			sys.stdout.flush()

