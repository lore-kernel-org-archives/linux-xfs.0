Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 630AAC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjEZB7C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbjEZB7B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:59:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660B9E7
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:59:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0217664C45
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:59:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E504C433EF;
        Fri, 26 May 2023 01:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066339;
        bh=skCyAirLxWrtT/1U+vU+BH3lguv9XFQYtcvKu35CKJ4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=cwsKXIlhUs78fVCLxDZZyqiRbNbukw3A3+8aXMQo1NKf84fruLnjK0QfcBPk/S9KW
         1+4fxpOYsagomyHoYf0xd591EsAu2ElPhqxGMeNhpXINPiUVY7AxR8aDHp2iagvl3z
         MLJkZTDSBdlnlNOGT068ZBksivV1bRNVZxGWOv3ezCRldQB6nS2/uVh+NDKVGwNMH0
         jsPzMqGD8nC5QNuf0NbacuJz+K2hqLgoOg8XeS9Bn2xOfpjitahc/DMmFE0FJJuVvD
         M26/EPDdbJVgFa0ACdrID6eQjg/eZdjWvPC1oGvdG6LR3eFAjHu5BbXyrsjvvq7UME
         0ghUtQLmWsRiw==
Date:   Thu, 25 May 2023 18:58:58 -0700
Subject: [PATCH 5/5] xfs_scrub_all: implement retry and backoff for dbus calls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506075275.3746473.14724533682438198294.stgit@frogsfrogsfrogs>
In-Reply-To: <168506075207.3746473.18041622129638673219.stgit@frogsfrogsfrogs>
References: <168506075207.3746473.18041622129638673219.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Calls to systemd across dbus are remote procedure calls, which means
that they're subject to transitory connection failures (e.g. systemd
re-exec itself).  We don't want to fail at the *first* sign of what
could be temporary trouble, so implement a limited retry with fibonacci
backoff before we resort to invoking xfs_scrub as a subprocess.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/xfs_scrub_all.in |   43 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 3 deletions(-)


diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
index b5a770c220d..488eafe43f1 100644
--- a/scrub/xfs_scrub_all.in
+++ b/scrub/xfs_scrub_all.in
@@ -165,6 +165,22 @@ def path_to_serviceunit(path, scrub_media):
 	for line in proc.stdout:
 		return line.decode(sys.stdout.encoding).strip()
 
+def fibonacci(max_ret):
+	'''Yield fibonacci sequence up to but not including max_ret.'''
+	if max_ret < 1:
+		return
+
+	x = 0
+	y = 1
+	yield 1
+
+	z = x + y
+	while z <= max_ret:
+		yield z
+		x = y
+		y = z
+		z = x + y
+
 class scrub_service(scrub_control):
 	'''Control object for xfs_scrub systemd service.'''
 	def __init__(self, mnt, scrub_media):
@@ -188,6 +204,25 @@ class scrub_service(scrub_control):
 		self.unit = dbus.Interface(svc_obj,
 				'org.freedesktop.systemd1.Unit')
 
+	def __dbusrun(self, lambda_fn):
+		'''Call the lambda function to execute something on dbus.  dbus
+		exceptions result in retries with Fibonacci backoff, and the
+		bindings will be rebuilt every time.'''
+		global debug
+
+		fatal_ex = None
+
+		for i in fibonacci(30):
+			try:
+				return lambda_fn()
+			except dbus.exceptions.DBusException as e:
+				if debug:
+					print(e)
+				fatal_ex = e
+				time.sleep(i)
+				self.bind()
+		raise fatal_ex
+
 	def state(self):
 		'''Retrieve the active state for a systemd service.  As of
 		systemd 249, this is supposed to be one of the following:
@@ -195,8 +230,10 @@ class scrub_service(scrub_control):
 		or "deactivating".  These strings are not localized.'''
 		global debug
 
+		l = lambda: self.prop.Get('org.freedesktop.systemd1.Unit',
+				'ActiveState')
 		try:
-			return self.prop.Get('org.freedesktop.systemd1.Unit', 'ActiveState')
+			return self.__dbusrun(l)
 		except Exception as e:
 			if debug:
 				print(e, file = sys.stderr)
@@ -231,7 +268,7 @@ class scrub_service(scrub_control):
 			print('starting %s' % self.unitname)
 
 		try:
-			self.unit.Start('replace')
+			self.__dbusrun(lambda: self.unit.Start('replace'))
 			return self.wait()
 		except Exception as e:
 			print(e, file = sys.stderr)
@@ -245,7 +282,7 @@ class scrub_service(scrub_control):
 			print('stopping %s' % self.unitname)
 
 		try:
-			self.unit.Stop('replace')
+			self.__dbusrun(lambda: self.unit.Stop('replace'))
 			return self.wait()
 		except Exception as e:
 			print(e, file = sys.stderr)

