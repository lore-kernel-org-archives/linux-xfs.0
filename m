Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E23629415
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688957; cv=none; b=MJlWnCNkR0bokzJ6rB2Op4p8rhxBbv28socyCEkWmmjVL6EoEEeZZTMfUkLqhsT87rnldrVfTGPaPLqjztc8awynERvjxXPS43G5z0YPnLJfMGAClXERoQWEH1vGp1OrVv4dH3r7oFBN/ShwFdZ0KpV/ArGesjhnNC4EwVMH7/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688957; c=relaxed/simple;
	bh=C2G0aTjZlccaxLYCcyxECfcpCR6kxEMTTUCSzzR5XaI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ri8tmAqNMHtyFKQamtbH4+Hn0PQhMREGcGSYw27WQYh3hqZB0EBQLkbuyNwdrDjHoOGKpnz4da4NAD7CefuO9ZmByctM7Uyzc989gi1Tr7b5RyVhzA/Iw3efuI/JfqcajpnYxuPgeJ3QFzRvr7wl1Ll+JCn5uuJZOYppvKg5LP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q8xIQnus; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q8xIQnus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA93C4CED2;
	Tue, 31 Dec 2024 23:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688957;
	bh=C2G0aTjZlccaxLYCcyxECfcpCR6kxEMTTUCSzzR5XaI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Q8xIQnusEwc/ksP1AOYHFgG+jsNGgql6APehPHePdYGeCfEfIfLxC+UyJKYvgvAX2
	 rdv36BTIvVi9DN3Y2FDlp2XL78YFZG3270EMxFvP6r39Ul1ys+KB0ZzR75uX3BH9h4
	 Ksyd0dUDPtt3GfD3JNElhmrb+pdrajEtFVYu0yINWJGhjfLLHJ2Gg+vNCpOrb8feTH
	 ahN0pbpvlrsE+mDgnswmpg6eddQSNtdR15A98qMie1ox/GrA77qjH0S9UmCqxQP79t
	 H8j7mKKiT5qkyv3gkaZvDwLRDwwa35zDajuP0XGju5FkkTiishYVN9iB62T5dfPUUv
	 tClebZwTfTF2Q==
Date: Tue, 31 Dec 2024 15:49:16 -0800
Subject: [PATCH 06/21] xfs: report media errors through healthmon
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568778552.2710211.14335916062488397072.stgit@frogsfrogsfrogs>
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

Now that we have hooks to report media errors, connect this to the
health monitor as well.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/xfs_healthmon.schema.json |   65 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)


diff --git a/libxfs/xfs_healthmon.schema.json b/libxfs/xfs_healthmon.schema.json
index a8bc75b0b8c4f9..006f4145faa9f5 100644
--- a/libxfs/xfs_healthmon.schema.json
+++ b/libxfs/xfs_healthmon.schema.json
@@ -33,6 +33,9 @@
 		},
 		{
 			"$ref": "#/$events/shutdown"
+		},
+		{
+			"$ref": "#/$events/media_error"
 		}
 	],
 
@@ -63,6 +66,31 @@
 		"i_generation": {
 			"description": "Inode generation number",
 			"type": "integer"
+		},
+		"storage_devs": {
+			"description": "Storage devices in a filesystem",
+			"_comment": [
+				"One of:",
+				"",
+				" * datadev: filesystem device",
+				" * logdev:  external log device",
+				" * rtdev:   realtime volume"
+			],
+			"enum": [
+				"datadev",
+				"logdev",
+				"rtdev"
+			]
+		},
+		"xfs_daddr_t": {
+			"description": "Storage device address, in units of 512-byte blocks",
+			"type": "integer",
+			"minimum": 0
+		},
+		"bbcount": {
+			"description": "Storage space length, in units of 512-byte blocks",
+			"type": "integer",
+			"minimum": 1
 		}
 	},
 
@@ -448,6 +476,43 @@
 				"domain",
 				"reasons"
 			]
+		},
+		"media_error": {
+			"title": "Media Error",
+			"description": [
+				"A storage device reported a media error.",
+				"The domain element tells us which storage",
+				"device reported the media failure.  The",
+				"daddr and bbcount elements tell us where",
+				"inside that device the failure was observed."
+			],
+			"type": "object",
+
+			"properties": {
+				"type": {
+					"const": "media"
+				},
+				"time_ns": {
+					"$ref": "#/$defs/time_ns"
+				},
+				"domain": {
+					"$ref": "#/$defs/storage_devs"
+				},
+				"daddr": {
+					"$ref": "#/$defs/xfs_daddr_t"
+				},
+				"bbcount": {
+					"$ref": "#/$defs/bbcount"
+				}
+			},
+
+			"required": [
+				"type",
+				"time_ns",
+				"domain",
+				"daddr",
+				"bbcount"
+			]
 		}
 	}
 }

