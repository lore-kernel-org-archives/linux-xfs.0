Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC21C13B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cyXkuwxQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CFBC433C7;
	Sun, 31 Dec 2023 22:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062749;
	bh=kFA5tWs3yTNVUj+zf4qi5Zab3qiV1Z+YkwwxhlwsvEU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cyXkuwxQrqug9pojvqMnfrCOcHVQS1VFp93ISEF3u+e9IU98NXD1bQATP6F7kuVbz
	 Qr4LKoGQbkQpdkcijBi0rEHxowqHvyYijXUwyg0xotXYsoZmRU2Ds8EXrQUuxS1dVl
	 Qc2ADEx9+TAJHLKc2jGMQjxmAy0oLfpoAGQ+n/puV4DYcXwNKI/RHyDID8arfjuQt/
	 VGv6c+yhqqRiGGdRvDSANHKjsNQbwmuH8/ZSGYNcrIzrVbYvRkvc9mS4jDYTosuloM
	 KvDFkEAnjdLSTOo3My+V9kEiaXlG5fBMLf/2z1US1dGBPAMguyXuwT0Ph5G+iZs61b
	 X01mJO7C4hJBQ==
Date: Sun, 31 Dec 2023 14:45:49 -0800
Subject: [PATCH 03/13] xfs_scrub: add a couple of omitted invisible code
 points
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405000623.1798385.4977637928922163287.stgit@frogsfrogsfrogs>
In-Reply-To: <170405000576.1798385.17716144085137758324.stgit@frogsfrogsfrogs>
References: <170405000576.1798385.17716144085137758324.stgit@frogsfrogsfrogs>
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

I missed a few non-rendering code points in the "zero width"
classification code.  Add them now, and sort the list.

$ wget https://www.unicode.org/Public/UCD/latest/ucd/UnicodeData.txt
$ grep -E '(zero width|invisible|joiner|application)' -i UnicodeData.txt

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/unicrash.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 96e20114c48..fc1adb2caab 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -351,15 +351,17 @@ name_entry_examine(
 	while ((uchr = uiter_next32(&uiter)) != U_SENTINEL) {
 		/* zero width character sequences */
 		switch (uchr) {
+		case 0x034F:	/* combining grapheme joiner */
 		case 0x200B:	/* zero width space */
 		case 0x200C:	/* zero width non-joiner */
 		case 0x200D:	/* zero width joiner */
-		case 0xFEFF:	/* zero width non breaking space */
 		case 0x2060:	/* word joiner */
 		case 0x2061:	/* function application */
 		case 0x2062:	/* invisible times (multiply) */
 		case 0x2063:	/* invisible separator (comma) */
 		case 0x2064:	/* invisible plus (addition) */
+		case 0x2D7F:	/* tifinagh consonant joiner */
+		case 0xFEFF:	/* zero width non breaking space */
 			*badflags |= UNICRASH_ZERO_WIDTH;
 			break;
 		}

