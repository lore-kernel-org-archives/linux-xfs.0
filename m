Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F0DD2FB;
	Fri, 11 Oct 2024 01:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610750; cv=none; b=qWOC/YCEAqXK7LQPkkLDw/JJr8DTR6SYgkgFm1VTQcFkUXu+l8VAvYYOnCrRDuNFEWiFUBHSWZTyb0UjU6GPDAMBHiE6ffOPkiYTXWffGDQ1JICZC98DIxyVUXlswPLdE8JI7v8RvHk2oNthaDTh2vHi7gq0duGGxY1D1B9CIgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610750; c=relaxed/simple;
	bh=RCpBLW8f1X1nKon5OraOTm78Gw4dmejOF+tA/gYj33I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a1nStR6240BQ81qKP5o4nCYVHiqEO2C7OJzukNEqBCCsa7D/aNfd9HfWLNyfv6cMZrSUJ411XuHdxYfxH9aeGJZmEw5xC53s6qMsbPfgx3cbbHV36oN/NyCBBH1gLJ+ee0Y3DFmi/hmUMU7zxCUbIqYfZguoY4xPJXtUZxmsMRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PayRBMb/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PayRBMb/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138D6C4CEC5;
	Fri, 11 Oct 2024 01:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610750;
	bh=RCpBLW8f1X1nKon5OraOTm78Gw4dmejOF+tA/gYj33I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PayRBMb/prwrxpPB3u1hcLqCMua9d5Jy9HP335oXy3Ae9RQG47FJ9jdrXVPGu36ly
	 h5V1HEQvvsx9tcu/p/CaJmnIyGXw+BPqRBG4jMyGz5ttIjlvCd0dOed5RbUO+f3iNM
	 gAfkV+QnJfxJWQ/kvFFS/tSCPCJqkm7gNn1ojBXeuOBizW4XHxdlL9PkuVJViwbJZO
	 Gd320Czi3lqI8RNgP3T/jVPp4o5XrpUMlNQ/UZZ7xJLfey41kKT44mklxaEhqlzj50
	 DMdQ0sdPZjnO38RqdngEvxEb0dz3uZLOQHlmrjF6ZTF5vV7d0CiAWuIdXngrfUH4nd
	 gmhRebd4kXasw==
Date: Thu, 10 Oct 2024 18:39:09 -0700
Subject: [PATCH 04/11] common/repair: patch up repair sb inode value
 complaints
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860658058.4187056.2385244245034025475.stgit@frogsfrogsfrogs>
In-Reply-To: <172860657983.4187056.5472629319415849070.stgit@frogsfrogsfrogs>
References: <172860657983.4187056.5472629319415849070.stgit@frogsfrogsfrogs>
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

Now that we've refactored xfs_repair to be more consistent in how it
reports unexpected superblock inode pointer values, we have to fix up
the fstests repair filters to emulate the old golden output.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/repair |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/common/repair b/common/repair
index 8945d0028c47a4..c3afcfb3e6966a 100644
--- a/common/repair
+++ b/common/repair
@@ -28,6 +28,10 @@ _filter_repair()
 	perl -ne '
 # for sb
 /- agno = / && next;	# remove each AG line (variable number)
+s/realtime bitmap inode pointer/realtime bitmap ino pointer/;
+s/sb realtime bitmap inode value/sb realtime bitmap inode/;
+s/realtime summary inode pointer/realtime summary ino pointer/;
+s/sb realtime summary inode value/sb realtime summary inode/;
 s/(pointer to) (\d+)/\1 INO/;
 # Changed inode output in 5.5.0
 s/sb root inode value /sb root inode /;

