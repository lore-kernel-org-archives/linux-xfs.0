Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA152116E6
	for <linux-xfs@vger.kernel.org>; Mon,  3 Feb 2025 22:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738622441; cv=none; b=nKwk+FYUTNHKHBoLQeve/j0eg/gtiBEREsJz9BxhQwMD5DUT+TxZY2QK+F5xXuSAFQE/6bBm92MV7CNPdfYB5s7aeBvPj+QHFvHDrixqmSzT71iOWhmYBoXQlImdJ0O4HpYmTF2msrhe6/DXsuWJrCWeDCWft5KEQW7vp5mmP3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738622441; c=relaxed/simple;
	bh=19H71VHcjwdMutC2ZYwxdIceJxqIwhZm15tJcWligPA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jsqReB3tql9HWybH25pciH7HaH/TbMsb8kkrp8QGUv5IStXI1zV7E54Vc+GipughPHyY6R6kHu2WfqvmdzH3HMyZNTgWyNpNfsahttRAXKuWBBoQvsZyDmp5ksJDwAhk5a822VvI6bar/Nq4qUi813wFpkaJz+MUEUUmyqbGF4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b3cVbOl4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b3cVbOl4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46363C4CED2;
	Mon,  3 Feb 2025 22:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738622440;
	bh=19H71VHcjwdMutC2ZYwxdIceJxqIwhZm15tJcWligPA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=b3cVbOl4TIU8qtC7lkL6KWpR25Rmb981Nx5LvfS3Tf0Wc5NrmiBgBqvCnBy5sJ97B
	 FYwABcLcWmsiE3bw36As44yPZqwCyPbht+L0KX0Mb5+NstjmVDR/3vsYeXnaWbm/JI
	 NJnE5HLKhpKmA+pgjKqKv+r5b1v8UsZ1Lfq3jHp+AhQ5GZtE/esQlLfpdNNY+tiNo6
	 hFCRc1xoZsa9FkWBRuEUU/o+qixaJB08Vu0rCQLz9T2WO3P9WzxHS/9u+FNBS8vwEl
	 QncmMaH3FqVy/ZJ2+6xSykfzQc5Ktaa55+QYrQmqfE3QBheCnCT8rOJ6GeI2+r35sE
	 +h5uvItpnPU1A==
Date: Mon, 03 Feb 2025 14:40:39 -0800
Subject: [PATCH 2/3] xfs_protofile: fix mode formatting error
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173862239063.2460098.16773056715229696499.stgit@frogsfrogsfrogs>
In-Reply-To: <173862239029.2460098.9677559939449638172.stgit@frogsfrogsfrogs>
References: <173862239029.2460098.9677559939449638172.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The protofile parser expects the mode to be specified with three octal
digits.  Unfortunately, the generator doesn't get that right if the mode
doesn't have any of bits 8-11 (aka no owner access privileges) set.

Fixes: 6aace700b7b82d ("mkfs: add a utility to generate protofiles")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/xfs_protofile.in |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/mkfs/xfs_protofile.in b/mkfs/xfs_protofile.in
index 9aee4336888523..356d3d80b32521 100644
--- a/mkfs/xfs_protofile.in
+++ b/mkfs/xfs_protofile.in
@@ -45,7 +45,7 @@ def stat_to_str(statbuf):
 
 	perms = stat.S_IMODE(statbuf.st_mode)
 
-	return '%s%s%s%o %d %d' % (type, suid, sgid, perms, statbuf.st_uid, \
+	return '%s%s%s%03o %d %d' % (type, suid, sgid, perms, statbuf.st_uid, \
 			statbuf.st_gid)
 
 def stat_to_extra(statbuf, fullpath):

