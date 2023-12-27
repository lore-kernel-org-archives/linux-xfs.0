Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3586E4A02;
	Mon,  1 Jan 2024 00:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AyW60qky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F015C433C8;
	Mon,  1 Jan 2024 00:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070554;
	bh=9r3YWrd97eMRBfrifUnTj7hpJqxR5akt/XOxxgrKmGA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AyW60qkymBz3WOAphUlCmOk+8FtBQ4exfaay0TutvFi4/VcqlPI1+WS9l7QhtJ+vv
	 lsUdYddkLbwwCVkY65ssvjrBdnElegPHCYFwVi2EU14JpHtCiOgchc2y41ld1OwWx7
	 dY42g35QsINqejdwIu0ZV5EDSKYERYXdwivaOccEYxeZ5opY5RXHzfsNmblCSJpoQZ
	 gLJLKO58ezR874j1WJOJr9qKxpmAoibM+orTsNdL5ufi/Ys3K6uEvsrAchFb0DMnR8
	 3us4JwwJt8PCU+WPCvRF/1lCRX/UCPXh/nZ0IL83U6tmzel/JMd7y4mxEWjLYETibG
	 ksqxZBXQSwPKw==
Date: Sun, 31 Dec 2023 16:55:54 +9900
Subject: [PATCH 12/17] xfs/449: update test to know about xfs_db -R
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405030495.1826350.15828125246602313048.stgit@frogsfrogsfrogs>
In-Reply-To: <170405030327.1826350.709349465573559319.stgit@frogsfrogsfrogs>
References: <170405030327.1826350.709349465573559319.stgit@frogsfrogsfrogs>
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

The realtime groups feature added a -R flag to xfs_db so that users can
pass in the realtime device.  Since we've now modified the
_scratch_xfs_db to use this facility, we can update the test to do exact
comparisons of the xfs_db info command against the mkfs output.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/449 |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/449 b/tests/xfs/449
index 5374bf2f85..66c443e994 100755
--- a/tests/xfs/449
+++ b/tests/xfs/449
@@ -32,7 +32,11 @@ echo DB >> $seqres.full
 cat $tmp.dbinfo >> $seqres.full
 # xfs_db doesn't take a rtdev argument, so it reports "realtime=external".
 # mkfs does, so make a quick substitution
-diff -u <(cat $tmp.mkfs | sed -e 's/realtime =\/.*extsz=/realtime =external               extsz=/g') $tmp.dbinfo
+if $XFS_DB_PROG --help 2>&1 | grep -q -- '-R rtdev'; then
+	diff -u $tmp.mkfs $tmp.dbinfo
+else
+	diff -u <(cat $tmp.mkfs | sed -e 's/realtime =\/.*extsz=/realtime =external               extsz=/g') $tmp.dbinfo
+fi
 
 _scratch_mount
 

