Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A3B29415
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688941; cv=none; b=QHiOKWL0k78hXibMLKmcCyDlAjYfoSFvNVxckflVWTrUx9PViegf5eQaIRANvQ2AriFW9UeOl1wHCHtp+lNskUQSNvLyITmWqw4t74C0sik0mg3BLiEtRBb1F6GSvI0Eb4S5xFnbIA7FAoVRTjJY7nhBaLYp2SjVlQe0jGG6dFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688941; c=relaxed/simple;
	bh=qQfSzOH2pPPaAMh7rgH7g6tp8CR0TvHXzvlL37152o4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RH6PhrNoi07IhTYZj32IkX3eQmpD8V68huB7ajd1EmnwtNktb67dTUnSEH/ymMsZfrDk8HTjTVw0sZw2w4aBo1rYNZZuQEx/uDa2sEfIHTxKjYg8khzF+MUH4ew2ITV3hIOhk3bDxcWaRf49HeMQTNxW26qoScOKt8eKcl5WbeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kewbjaYM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kewbjaYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB88C4CED2;
	Tue, 31 Dec 2024 23:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688941;
	bh=qQfSzOH2pPPaAMh7rgH7g6tp8CR0TvHXzvlL37152o4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kewbjaYMYLPFjxo4LSu5H6vomgIztaG/faQsaBCCZZQKUicm7CnCCl3hB94WNmROZ
	 wAP1oFmdOD95ahaZff/lq2xDCPZcifnlyP+7+hcvOzigso3saC5JBJKDjxf7vbJ2sx
	 MkjrtvBBimZQQExDAQYzDy7oZlDXqOO0qrFPpVjaZzS/MysFB3ppNT+uuinmjkRgId
	 vNQ5850Wu6kkxsr1JRCFOwuC5SXb333gtoEkIhYlqZ+MlB0OTyVyFrp+dTMWl8xiUU
	 BkkuqeXvaFskbvraoEp3R8HJECUUzHP0XG4pQtZaxZQ/uWvXx09WAmuJKLAIXEekCH
	 uQihguARZyi6Q==
Date: Tue, 31 Dec 2024 15:49:00 -0800
Subject: [PATCH 05/21] xfs: report shutdown events through healthmon
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568778536.2710211.13092769848745616981.stgit@frogsfrogsfrogs>
In-Reply-To: <173568778426.2710211.10173859713748230492.stgit@frogsfrogsfrogs>
References: <173568778426.2710211.10173859713748230492.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Set up a shutdown hook so that we can send notifications to userspace.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/xfs_healthmon.schema.json |   62 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)


diff --git a/libxfs/xfs_healthmon.schema.json b/libxfs/xfs_healthmon.schema.json
index 154ea0228a3615..a8bc75b0b8c4f9 100644
--- a/libxfs/xfs_healthmon.schema.json
+++ b/libxfs/xfs_healthmon.schema.json
@@ -30,6 +30,9 @@
 		},
 		{
 			"$ref": "#/$events/inode_metadata"
+		},
+		{
+			"$ref": "#/$events/shutdown"
 		}
 	],
 
@@ -205,6 +208,31 @@
 		}
 	},
 
+	"$comment": "Shutdown event data are defined here.",
+	"$shutdown": {
+		"reason": {
+			"description": [
+				"Reason for a filesystem to shut down.",
+				"Options include:",
+				"",
+				" * corrupt_incore: in-memory corruption",
+				" * corrupt_ondisk: on-disk corruption",
+				" * device_removed: device removed",
+				" * force_umount:   userspace asked for it",
+				" * log_ioerr:      log write IO error",
+				" * meta_ioerr:     metadata writeback IO error"
+			],
+			"enum": [
+				"corrupt_incore",
+				"corrupt_ondisk",
+				"device_removed",
+				"force_umount",
+				"log_ioerr",
+				"meta_ioerr"
+			]
+		}
+	},
+
 	"$comment": "Event types are defined here.",
 	"$events": {
 		"lost": {
@@ -386,6 +414,40 @@
 				"generation",
 				"structures"
 			]
+		},
+		"shutdown": {
+			"title": "Abnormal Shutdown Event",
+			"description": [
+				"The filesystem went offline due to",
+				"unrecoverable errors."
+			],
+			"type": "object",
+
+			"properties": {
+				"type": {
+					"const": "shutdown"
+				},
+				"time_ns": {
+					"$ref": "#/$defs/time_ns"
+				},
+				"domain": {
+					"const": "mount"
+				},
+				"reasons": {
+					"type": "array",
+					"items": {
+						"$ref": "#/$shutdown/reason"
+					},
+					"minItems": 1
+				}
+			},
+
+			"required": [
+				"type",
+				"time_ns",
+				"domain",
+				"reasons"
+			]
 		}
 	}
 }

