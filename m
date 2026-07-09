Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DB1351C02
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2026 11:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783594828; cv=none; b=AGnqjfgWNbhk0RhGcc1XtcnXzqs3t+jKf6d182lr7pS1kCpU48RXikCN3uorldHtij4//BBErvXAsP3q7iqKDJFGwmbNN0zLtEBqgcYh3u+yglHCxPrAEOHODVG/guVU+nMYSlWqouF+uWLE7VhOLgMyq/w5qPD/VzlHoEPhb9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783594828; c=relaxed/simple;
	bh=mqyzOAe8ojW0sXIrguNkzp9H0ns6VfH92FyGYfFZa7s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mKQ+la5pFdgXiDiLt1Hf5gqV/7FWmRVrEFh+UbqZnqMTNx+0hD12IRhHmOGDvQIjCv1QGvOsXew6LYW69TrrlhC8QBIFdIpplpysSM09RTmb9HppvxtFblSr/xBNLSZ6Cqp0u90fud3ia9Mxyqr/AHatDq927e/oycIT2TriizM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nvhfxCEJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nvhfxCEJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBBEC1F000E9;
	Thu,  9 Jul 2026 11:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783594827;
	bh=+70x/XAd6Rx5z+fbhIiKYsWLg6ac/BE5nF1dqAa510c=;
	h=From:To:Cc:Subject:Date;
	b=nvhfxCEJ0YUYUXDVn4iZvPe7rfytpUMN/EihpFxuuQF9N12I++zx45aaioEnaewvy
	 HOuddWVnNUQmLqPoky/MaF1FVTLUh6WWflWJn/AH5lBDaFM0whdy3A3HyxtOBpi6dv
	 pNI1Frij74v5d0MENGsHJiOO9+VTFPvobLA5Ejtjjat88uAupY4i5ButnI8KtZpuKr
	 oWSU3/hhjjO4/GQZG09knpmRTGJA21AbDD6mctlUymVJZSwFxX1cp7sQc/GtUEAwxE
	 qshzjnHPv+1sPbhPQMwxolo4kGkHvCzIB+GaDZjseL+7tSAVr8WAoxjMad/r3kqIQR
	 zsuE0Z5LiOsMg==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: dgc@kernel.org,
	hch@lst.de,
	djwong@kernel.org
Subject: [RFC PATCH] xfs: add new policy guidelines for llm-assisted patches
Date: Thu,  9 Jul 2026 12:59:56 +0200
Message-ID: <20260709110006.94905-1-cem@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Hi, this idea came from some observations on the current inflow of patches
sent to xfs, amount of time we've been spending reviewing patches, lack of
testing coverage for them and sporadically bollocks patches that make no
sense or even do not compile.

A talk I had with Dave earlier today made me come up with an INITIAL
DRAFT of what should IMHO make 'reviewable' any LLM-assisted patch
submitted to the list.

Most of the information there is also valid for non-LLM assisted code,
but LLM-assisted code makes these policies exceptionally important
giving LLMs make the code generation way faster and easier than we have
time to follow through.

We do have tooling now like Sashiko to help with a gross review of
patches and some general policies, but none of those tooling/policies
target xfs specifically so I thought we ought to have a specific policy
in place, specially regarding testing-coverage as submitting
LLM-assisted patches also implies the same tooling can be used to create
fully-functional testing coverage in xfstests.

I'll appreciate your thoughts on this.

Cheers

Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 ...m-assisted-patch-submission-guidelines.rst | 59 +++++++++++++++++++
 1 file changed, 59 insertions(+)
 create mode 100644 Documentation/filesystems/xfs/xfs-llm-assisted-patch-submission-guidelines.rst

diff --git a/Documentation/filesystems/xfs/xfs-llm-assisted-patch-submission-guidelines.rst b/Documentation/filesystems/xfs/xfs-llm-assisted-patch-submission-guidelines.rst
new file mode 100644
index 000000000000..1f7921789988
--- /dev/null
+++ b/Documentation/filesystems/xfs/xfs-llm-assisted-patch-submission-guidelines.rst
@@ -0,0 +1,59 @@
+.. SPDX-License-Identifier: GPL-2.0
+.. _xfs_llm_assisted_patch_submission_guidelines:
+
+============================
+XFS LLM-Assisted patch submission guidelines
+============================
+
+Introduction
+============
+
+LLMs are a great tool for improving code quality when well used. But they also
+have been creating a lot of extra workload for developers with the increasing
+patch flow. Requiring much more time with reviewing and testing changes.
+
+Some patches submited fixes obvious bugs and are welcome, while other patches
+being submitted have obviously flaws, create regressions caught by xfstests,
+fixes theoretical bugs that may never be hit in real world (even though are
+worth fixing) and sometimes do not even build.
+
+So the goal of the policies described by this document is two-fold:
+
+	- Increase XFS's code quality ensuring all code modifications are
+	  properly tested and have extra coverage
+	- Reduce developers/maintainers workload with the extra income of
+	  machine-generated patches.
+
+Patch description
+-----------------
+
+Patches description should be carefully trimmed by the patch submitter removing
+all extra and unnecessary data from it.
+LLMs tend to generate extra-long documentation full of unnecessary information
+that won't help neither the reviewer nor anybody looking into the git history
+in the future, and these consumes a lot of time during review.
+It's the patch submitter responsibility to trim it down to a concise, easily
+readable document, removing all the extra unnecessary information from it.
+
+This also helps adding extra guardrails that the patch submitter fully understands
+what the patch is doing without letting the LLM loose.
+
+Patch changes
+-------------
+
+The patch submitter is fully responsible for the changes and must understand what
+the paitch does. And it should be in full agreement with the patch description.
+
+Testing the changes
+---------------
+
+LLM-generated patches should be coupled with a fully-functional xfstests test case
+which exercises the bug being fixed by the patch. This will not only improve testing
+coverage but also provide extra help for reviewers and the maintainer to properly
+review and test the changes being made.
+
+Also, every patch/series submitted must be exercised through xfstests suite
+- at least - through the auto group (and others depending on the change) as a way
+to add extra coverage through the already existing regression cases and help
+reviewers/maintainers through the integration process.
+
-- 
2.54.0

