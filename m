Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2993229415
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688973; cv=none; b=be9gXItgJPQtWJIuhIX45yZlugkNoUvsmEOLyz3jMfIeTXICullaGSG7B0xTUL2FA0/jMRexok+y/tqSVdO9yOsCiETFeYjfXkyxFm0CH0Hvl5naLIEY2mk+zrgdQs7G7UHNWWlKBMc9Oag9ZU+J30ldvjcuyLtldyOlyRDgHxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688973; c=relaxed/simple;
	bh=KXC01zJz8dH5M49sRgQAXrKP9VbnYyAZzoQqBYdL3Gk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CwKOdYh62IkIZUWDpMIhBMG0IXbKO9vXB3oQB6hZ3fWS71j+G1fcjRmkx+fXZ1H+aCLcoJA/dyRHf9i0+D7B3FdDXn0fLztpxQxP0Fp/E370pBZgrByJYB4dV1biCT3CNm4LVlHqTOYwq2HPhBQ0jxQK4wRIp1+ZZJb8pCGxLNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GiKFkx/F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GiKFkx/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC95C4CED2;
	Tue, 31 Dec 2024 23:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688972;
	bh=KXC01zJz8dH5M49sRgQAXrKP9VbnYyAZzoQqBYdL3Gk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GiKFkx/FqNxuVQQmnVlNs3/e/lBtEA28YacjT0GfeKidxLEWinCm1PT1kEK8wGhGU
	 JidQcPfYRSEWbBf5Zq2/oMduwBnJ2kWVsoXetDATkyi4FqjTNpAAwRYTQH4czN00Sh
	 VFinfqQaeRak6ehqNyIPHB7C7JrA3VJ/8QQEIzpH3FRbkxQSCJuME+kQruYU9G8GE1
	 1LboflXTJegadQ61i/m7kDIluS7/khh113wiDhHm55bVGGUKy2IuPac/2itbcnwmak
	 8xBDgjOnGrL+vs0CWhFfYaAoxFtSuK0XHKJ0w4/IA7/Br3IzqsTXrUQzgrUXfGudsm
	 cR8EFqiocdUtg==
Date: Tue, 31 Dec 2024 15:49:32 -0800
Subject: [PATCH 07/21] xfs: report file io errors through healthmon
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568778567.2710211.14890698351890932186.stgit@frogsfrogsfrogs>
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

Set up a file io error event hook so that we can send events about read
errors, writeback errors, and directio errors to userspace.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/xfs_healthmon.schema.json |   77 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)


diff --git a/libxfs/xfs_healthmon.schema.json b/libxfs/xfs_healthmon.schema.json
index 006f4145faa9f5..9c1070a629997c 100644
--- a/libxfs/xfs_healthmon.schema.json
+++ b/libxfs/xfs_healthmon.schema.json
@@ -36,6 +36,9 @@
 		},
 		{
 			"$ref": "#/$events/media_error"
+		},
+		{
+			"$ref": "#/$events/file_ioerror"
 		}
 	],
 
@@ -67,6 +70,16 @@
 			"description": "Inode generation number",
 			"type": "integer"
 		},
+		"off_t": {
+			"description": "File position, in bytes",
+			"type": "integer",
+			"minimum": 0
+		},
+		"size_t": {
+			"description": "File operation length, in bytes",
+			"type": "integer",
+			"minimum": 1
+		},
 		"storage_devs": {
 			"description": "Storage devices in a filesystem",
 			"_comment": [
@@ -261,6 +274,26 @@
 		}
 	},
 
+	"$comment": "File IO event data are defined here.",
+	"$fileio": {
+		"types": {
+			"description": [
+				"File I/O operations.  One of:",
+				"",
+				" * readahead: reads into the page cache.",
+				" * writeback: writeback of dirty page cache.",
+				" * dioread:   O_DIRECT reads.",
+				" * diowrite:  O_DIRECT writes."
+			],
+			"enum": [
+				"readahead",
+				"writeback",
+				"dioread",
+				"diowrite"
+			]
+		}
+	},
+
 	"$comment": "Event types are defined here.",
 	"$events": {
 		"lost": {
@@ -513,6 +546,50 @@
 				"daddr",
 				"bbcount"
 			]
+		},
+		"file_ioerror": {
+			"title": "File I/O error",
+			"description": [
+				"A read or a write to a file failed.  The",
+				"inode, generation, pos, and len fields",
+				"describe the range of the file that is",
+				"affected."
+			],
+			"type": "object",
+
+			"properties": {
+				"type": {
+					"$ref": "#/$fileio/types"
+				},
+				"time_ns": {
+					"$ref": "#/$defs/time_ns"
+				},
+				"domain": {
+					"const": "filerange"
+				},
+				"inumber": {
+					"$ref": "#/$defs/xfs_ino_t"
+				},
+				"generation": {
+					"$ref": "#/$defs/i_generation"
+				},
+				"pos": {
+					"$ref": "#/$defs/off_t"
+				},
+				"len": {
+					"$ref": "#/$defs/size_t"
+				}
+			},
+
+			"required": [
+				"type",
+				"time_ns",
+				"domain",
+				"inumber",
+				"generation",
+				"pos",
+				"len"
+			]
 		}
 	}
 }

