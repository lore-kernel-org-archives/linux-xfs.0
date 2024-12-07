Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382FA4A07
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530352; cv=none; b=elwZtpcq7JI3Q/avEIOAA+rHBfMQdsNsciXkVc4BfqNUR/Y2SeGLalyEW/3VbyXgg3YRyarOVDeOqNHJw1ISoWConSY/vmEDjyD3djTxdTeOfLipQCoRgAwNVPfAianv7+HUx7NCR6Eup/5t8Qc+uVRxQnd0eMiOCc54+SkaJsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530352; c=relaxed/simple;
	bh=ujpZ8/GHjJVULljRJqGMS0nOJZht8C2J5CR9TQ9VH2Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TwkPAwhC6TlF6x5gMMjOt8aTci7y03GoFZNXkb4+aK6NlzKT6i3n4E6QqPZrGN0zIAKOxSs214D+o+FfmoUt21yq3T2y7fYOYoibWM7tUB78RrZnf/F/EioWF1gX5qoqsNG9oCSQipZRxE+A5Nk0yW/+VvMBnyi1YHzkvwwE4wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ws6HwkD4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ws6HwkD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10353C4CED1;
	Sat,  7 Dec 2024 00:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530352;
	bh=ujpZ8/GHjJVULljRJqGMS0nOJZht8C2J5CR9TQ9VH2Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ws6HwkD4pWlGZ5tR9euSJbsWDCoMLDgRFqpd51/4iETJLnDXXow5PIp2Q2GWNRbQ7
	 ofOg0WuSccX2dJTwU5y1xfE9/keg1g8iqhTYDNX2OWZ3d8yDr7K6Uk2HXetzjcyy+s
	 uNEK+X3d+0oz61qBA8YcFslM2YjXugHcGXwCgxt7SRtnzqwnTErxbiri1/kCcYowR3
	 W44Lw0amJQch1Jpftv1YMgKQtrd+u5WUqu6OX0qwOLF79clCxu6QCOua1HRSkfGpW0
	 0V43mjISWh0Guka8uIqUALJ/ftOKqDwwLnoDWupd9a24ev6CEmqsMtzGQpFtQ15Bjn
	 1Og0sF7TCblVg==
Date: Fri, 06 Dec 2024 16:12:31 -0800
Subject: [PATCH 29/50] xfs_db: support changing the label and uuid of rt
 superblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752388.126362.13051985148596315963.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Update the label and uuid commands to change the rt superblocks along
with the filesystem superblocks.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/sb.c |  109 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 98 insertions(+), 11 deletions(-)


diff --git a/db/sb.c b/db/sb.c
index de248c10cb27f5..ba5a2d5851f602 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -27,6 +27,7 @@ static int	label_f(int argc, char **argv);
 static void     label_help(void);
 static int	version_f(int argc, char **argv);
 static void     version_help(void);
+static size_t check_label(char *label, bool can_warn);
 
 static const cmdinfo_t	sb_cmd =
 	{ "sb", NULL, sb_f, 0, 1, 1, N_("[agno]"),
@@ -332,6 +333,65 @@ uuid_help(void)
 ));
 }
 
+static bool
+check_rtsb(
+	struct xfs_mount	*mp)
+{
+	int			error;
+
+	if (!xfs_has_rtsb(mp) || !xfs_has_realtime(mp))
+		return false;
+
+	push_cur();
+	error = set_rt_cur(&typtab[TYP_RTSB], XFS_RTSB_DADDR,
+			XFS_FSB_TO_BB(mp, 1), DB_RING_ADD, NULL);
+	if (error == ENODEV) {
+		/* no rt dev means we should just bail out */
+		pop_cur();
+		return true;
+	}
+
+	pop_cur();
+	return false;
+}
+
+static int
+update_rtsb(
+	struct xfs_mount	*mp,
+	uuid_t			*uuid,
+	char			*label)
+{
+	struct xfs_rtsb		*rsb;
+	int			error;
+
+	if (!xfs_has_rtsb(mp) || !xfs_has_realtime(mp))
+		return false;
+
+	push_cur();
+	error = set_rt_cur(&typtab[TYP_RTSB], XFS_RTSB_DADDR,
+			XFS_FSB_TO_BB(mp, 1), DB_RING_ADD, NULL);
+	if (error == ENODEV) {
+		/* no rt dev means we should just bail out */
+		exitcode = 1;
+		pop_cur();
+		return 1;
+	}
+
+	rsb = iocur_top->data;
+	if (label) {
+		size_t	len = check_label(label, false);
+
+		memset(&rsb->rsb_fname, 0, XFSLABEL_MAX);
+		memcpy(&rsb->rsb_fname, label, len);
+	}
+	if (uuid)
+		memcpy(&rsb->rsb_uuid, uuid, sizeof(rsb->rsb_uuid));
+	write_cur();
+	pop_cur();
+
+	return 0;
+}
+
 static uuid_t *
 do_uuid(xfs_agnumber_t agno, uuid_t *uuid)
 {
@@ -376,6 +436,7 @@ do_uuid(xfs_agnumber_t agno, uuid_t *uuid)
 	memcpy(&tsb.sb_uuid, uuid, sizeof(uuid_t));
 	libxfs_sb_to_disk(iocur_top->data, &tsb);
 	write_cur();
+	memcpy(&mp->m_sb.sb_uuid, uuid, sizeof(uuid_t));
 	return uuid;
 }
 
@@ -438,11 +499,18 @@ uuid_f(
 			}
 		}
 
+		if (check_rtsb(mp)) {
+			exitcode = 1;
+			return 0;
+		}
+
 		/* clear the log (setting uuid) if it's not dirty */
 		if (!sb_logzero(&uu))
 			return 0;
 
 		dbprintf(_("writing all SBs\n"));
+		if (update_rtsb(mp, &uu, NULL))
+			return 1;
 		for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)
 			if (!do_uuid(agno, &uu)) {
 				dbprintf(_("failed to set UUID in AG %d\n"), agno);
@@ -511,6 +579,27 @@ label_help(void)
 ));
 }
 
+static size_t
+check_label(
+	char	*label,
+	bool	can_warn)
+{
+	size_t	len = strlen(label);
+
+	if (len > XFSLABEL_MAX) {
+		if (can_warn)
+			dbprintf(_("%s: truncating label length from %d to %d\n"),
+				progname, (int)len, XFSLABEL_MAX);
+		len = XFSLABEL_MAX;
+	}
+	if ( len == 2 &&
+	     (strcmp(label, "\"\"") == 0 ||
+	      strcmp(label, "''")   == 0 ||
+	      strcmp(label, "--")   == 0) )
+		label[0] = label[1] = '\0';
+	return len;
+}
+
 static char *
 do_label(xfs_agnumber_t agno, char *label)
 {
@@ -529,22 +618,13 @@ do_label(xfs_agnumber_t agno, char *label)
 		return &lbl[0];
 	}
 	/* set label */
-	if ((len = strlen(label)) > sizeof(tsb.sb_fname)) {
-		if (agno == 0)
-			dbprintf(_("%s: truncating label length from %d to %d\n"),
-				progname, (int)len, (int)sizeof(tsb.sb_fname));
-		len = sizeof(tsb.sb_fname);
-	}
-	if ( len == 2 &&
-	     (strcmp(label, "\"\"") == 0 ||
-	      strcmp(label, "''")   == 0 ||
-	      strcmp(label, "--")   == 0) )
-		label[0] = label[1] = '\0';
+	len = check_label(label, agno == 0);
 	memset(&tsb.sb_fname, 0, sizeof(tsb.sb_fname));
 	memcpy(&tsb.sb_fname, label, len);
 	memcpy(&lbl[0], &tsb.sb_fname, sizeof(tsb.sb_fname));
 	libxfs_sb_to_disk(iocur_top->data, &tsb);
 	write_cur();
+	memcpy(&mp->m_sb.sb_fname, &tsb.sb_fname, XFSLABEL_MAX);
 	return &lbl[0];
 }
 
@@ -576,7 +656,14 @@ label_f(
 			return 0;
 		}
 
+		if (check_rtsb(mp)) {
+			exitcode = 1;
+			return 0;
+		}
+
 		dbprintf(_("writing all SBs\n"));
+		if (update_rtsb(mp, NULL, argv[1]))
+			return 1;
 		for (ag = 0; ag < mp->m_sb.sb_agcount; ag++)
 			if ((p = do_label(ag, argv[1])) == NULL) {
 				dbprintf(_("failed to set label in AG %d\n"), ag);

