Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4A04689;
	Tue, 27 Feb 2024 02:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708999326; cv=none; b=FXc27T04Ik6TlCz8CUFMtjFBjS/fiC0/7ZOfJEWRlvQVL1/AEwK7Iv7EjTkX7CF02DwpWFJp6ENJ/lmrBZ2n3+WYjZZU73f5O2SV+qiocPrBVcSArabrXK/2KwWDpTBQcgXx9gAEbacBmI/juNQiJC+G1fGhD+acSB34ToNOLy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708999326; c=relaxed/simple;
	bh=ErRMXqTl92BXMhTv9z7imcrpfDzvCmoTs83req+434M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cssDL8KN6W31x5Af4AjXOec9BzfESuXh+W21KrcMOWICEncllUlzHL0ypXJGl4+X8lFxsHngO0T2HaRVMpr/kPEdtQmNXl9g9fpgW6z/c25KB921NC1MrmzjfZDqBB6MEIWNZyow/+5sQp9C3wIBTeQD0dVa9UVChWv2Yy3ZIEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ISczvk7I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ISczvk7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E567C433F1;
	Tue, 27 Feb 2024 02:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708999326;
	bh=ErRMXqTl92BXMhTv9z7imcrpfDzvCmoTs83req+434M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ISczvk7IkMecOOVzRkJ9hX0HHTyI8vy1pPVQd2Ox+9hxwnBLnDjpgzvyW1bpLBT0U
	 asu8wG6LZaSO4J3JIFG2wrFpoo/cXR3T2jkipjzBRaKbqy+7cRcEHFHjotjDayvyyl
	 8oF6u+CeXUWPzE96nKnGEx+NlG2RcC9iZCM3rscvqSBB8apNe4sQGTrTDqNM93Wosz
	 zf+v9YnLe5B9FjtDfyt0vGLPeod7WWPaJjq7CFUd2bbQEnY/9a9h0m1jnmj7JTD33L
	 R7/1JigejLjtxxJIxUBt57Ju/DzdzgtbWjrOrDO94ZK12mso2KznPuG0WVQLelWGLk
	 hJQoJp7s4eQTQ==
Date: Mon, 26 Feb 2024 18:02:05 -0800
Subject: [PATCH 6/8] xfs/122: update test to pick up rtword/suminfo ondisk
 unions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: linux-xfs@vger.kernel.org, guan@eryu.me, fstests@vger.kernel.org
Message-ID: <170899915304.896550.17104868811908659798.stgit@frogsfrogsfrogs>
In-Reply-To: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
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
index 067a0ec76b..a2b57cfb9b 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -124,6 +124,8 @@ sizeof(struct xfs_swap_extent) = 64
 sizeof(struct xfs_sxd_log_format) = 16
 sizeof(struct xfs_sxi_log_format) = 80
 sizeof(struct xfs_unmount_log_format) = 8
+sizeof(union xfs_rtword_raw) = 4
+sizeof(union xfs_suminfo_raw) = 4
 sizeof(xfs_agf_t) = 224
 sizeof(xfs_agfl_t) = 36
 sizeof(xfs_agi_t) = 344

