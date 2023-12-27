Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C564A02;
	Mon,  1 Jan 2024 00:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iT4Hh7Z7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08468C433C8;
	Mon,  1 Jan 2024 00:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070586;
	bh=AEilMhwmNuVwAphEtZ+8Nm71OoXMByvNCvGyNzKbFFs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iT4Hh7Z7UZZTxUxlWHsC1Mo0BUz5WA/b7GijUue0W+KYyutqUrbx+9gap2/7B42re
	 eP9FlTRr/OZ5FbL88bU1+GQWqMbNq5VMLxzyFYZAKNCVgU9bseEz2/14794JevNRiy
	 jUMjFitoug1jfqE8HXTBjpQhdczkLdj7YcsTviX/uLisP7eThaQ8B1cy+6/U70um3+
	 mZPDbnagA5KU5XExbsOapOhRMU9QKcClUqjCffv5bfLkIjLtHpoQ9pqdIGQiMcZe3Q
	 zvk7IVOGc6kVYBXQnwKhO5J4holfvEEAvYCG1kN4C1kTw7H/ae15HNFtpvkd2M/JrN
	 55Mp++Ko1uWPA==
Date: Sun, 31 Dec 2023 16:56:25 +9900
Subject: [PATCH 14/17] xfs/122: udpate test to pick up rtword/suminfo ondisk
 unions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405030521.1826350.7421441043948772796.stgit@frogsfrogsfrogs>
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

Update this test to check that the ondisk unions for rt bitmap word and
rt summary counts are always the correct size.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122     |    2 +-
 tests/xfs/122.out |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/122 b/tests/xfs/122
index ba927c77c4..4e5ba1dfee 100755
--- a/tests/xfs/122
+++ b/tests/xfs/122
@@ -195,7 +195,7 @@ echo 'int main(int argc, char *argv[]) {' >>$cprog
 #
 cat /usr/include/xfs/xfs*.h | indent |\
 _attribute_filter |\
-grep -E '(} *xfs_.*_t|^struct xfs_[a-z0-9_]*$)' |\
+grep -E '(} *xfs_.*_t|^(union|struct) xfs_[a-z0-9_]*$)' |\
 grep -E -v -f $tmp.ignore |\
 sed -e 's/^.*}[[:space:]]*//g' -e 's/;.*$//g' -e 's/_t, /_t\n/g' |\
 sort | uniq |\
diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 8bb79ba959..6b03b90c2d 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -134,6 +134,8 @@ sizeof(struct xfs_swap_extent) = 64
 sizeof(struct xfs_sxd_log_format) = 16
 sizeof(struct xfs_sxi_log_format) = 80
 sizeof(struct xfs_unmount_log_format) = 8
+sizeof(union xfs_rtword_raw) = 4
+sizeof(union xfs_suminfo_raw) = 4
 sizeof(xfs_agf_t) = 224
 sizeof(xfs_agfl_t) = 36
 sizeof(xfs_agi_t) = 344

