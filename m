Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4211657CA7;
	Tue, 11 Jun 2024 18:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718130610; cv=none; b=h/CPjuDKGibT/nvmtvvwClVP4A6ywyjt5M3hqGDUtO1Qeuf3avDSNKvuDJy2QoZRZGSimKE21q2pPPHndeu1+iTlKbUZDXfL2PJaYBgfQOCAUA7ld27enZKHRQt6jOKRIpAPLOPKZCYXUh/F2zQ0ac1RMSt106MiOMzbUZ4D9bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718130610; c=relaxed/simple;
	bh=vJdx8v8sntfz3gfNWSEq8B5ZAdWB4ukm3vEn+UDhOS4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZFzv+FxbbNJ39bSQrrniMyXEhNewDEwzXEE2tR9DrOHT6lIdRJvzlIPOPZabZE5R6GEzaIPxUK3TvUwaohXamrEinCUMN5aHXcUSOUANqQWtmgM+RDkw3LwfXA37UJQ2iRUjKFg3jSmGl+6mTxKVZFzKigrdPlGYjcx7F0r8ZeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IO79M3JG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IO79M3JG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC639C4AF1C;
	Tue, 11 Jun 2024 18:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718130609;
	bh=vJdx8v8sntfz3gfNWSEq8B5ZAdWB4ukm3vEn+UDhOS4=;
	h=From:To:Cc:Subject:Date:From;
	b=IO79M3JG8VsurNX2+G7/7uZJwTfKoKZuaPKjI4KKXXSvbX8f0uxeQvjmXAFauVXNu
	 DzMtnfwHUBM7Gd/mqewVaTzo0WLySO/iOLopi/vX3kensUu5AjCDJvGo/HqHplLlkM
	 /m9fv8/KcCrM6YLelCjS2vQYLA1QgS13QOXgMqK9AiUWtnFjB8OdcG/L1lKrVqK5HH
	 sF6/N8/cAsWz02Gljp60ylcqYVQCSFKIOS1B+6qDPZ2iuqhQHuEfkGEyZuLcVWiLFe
	 x1AXXFFh6TvURyzgxwwxzQ7o2bxE7ruDhPO/ptdLxu85CVa2xwlMTyWKZZd9lqrFfw
	 POAn7ikxTOe4w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: fstests@vger.kernel.org
Subject: [xfsprogs PATCH] xfs_io: fix mread with length 1 mod page size
Date: Tue, 11 Jun 2024 11:29:28 -0700
Message-ID: <20240611182928.12813-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Fix a weird bug in mread where if you passed it a length that was 1
modulo the page size, for example

        xfs_io -r file -c "mmap -r 0 8192" -c "mread -v 0 4097"

... it never reset its pointer into the buffer into which it copies the
data from the memory map.  This caused an out-of-bounds write, which
depending on the length passed could be very large and reliably
segfault.  Also nothing was printed, despite the use of -v option.

(I don't know if this case gets reached by any existing xfstest, but
presumably not.  I noticed it while working on a patch to an xfstest.)

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 io/mmap.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/io/mmap.c b/io/mmap.c
index 85087f57..4c03e3d5 100644
--- a/io/mmap.c
+++ b/io/mmap.c
@@ -469,38 +469,30 @@ mread_f(
 	dumplen = length % pagesize;
 	if (!dumplen)
 		dumplen = pagesize;
 
 	if (rflag) {
-		for (tmp = length - 1, c = 0; tmp >= 0; tmp--, c = 1) {
-			*bp = *(((char *)mapping->addr) + dumpoffset + tmp);
-			cnt++;
-			if (c && cnt == dumplen) {
+		for (tmp = length - 1; tmp >= 0; tmp--) {
+			bp[cnt++] = ((char *)mapping->addr)[dumpoffset + tmp];
+			if (cnt == dumplen) {
 				if (dump) {
 					dump_buffer(printoffset, dumplen);
 					printoffset += dumplen;
 				}
-				bp = (char *)io_buffer;
 				dumplen = pagesize;
 				cnt = 0;
-			} else {
-				bp++;
 			}
 		}
 	} else {
-		for (tmp = 0, c = 0; tmp < length; tmp++, c = 1) {
-			*bp = *(((char *)mapping->addr) + dumpoffset + tmp);
-			cnt++;
-			if (c && cnt == dumplen) {
+		for (tmp = 0; tmp < length; tmp++) {
+			bp[cnt++] = ((char *)mapping->addr)[dumpoffset + tmp];
+			if (cnt == dumplen) {
 				if (dump)
 					dump_buffer(printoffset + tmp -
 						(dumplen - 1), dumplen);
-				bp = (char *)io_buffer;
 				dumplen = pagesize;
 				cnt = 0;
-			} else {
-				bp++;
 			}
 		}
 	}
 	return 0;
 }

base-commit: df4bd2d27189a98711fd35965c18bee25a25a9ea
-- 
2.45.1

