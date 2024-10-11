Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869A14400
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609313; cv=none; b=VBG/TyrwZKGN7c1NCQznvIlbv90U7DQp0Y+gyCH05qFgP9novws6O4KhCP+UTxd/4c5vASPQmO+hPByGvffYtpB4TPdRLJB3jbTHS/4MNAyBYFtK3J6Ztyr0162kAmuffoBQc25KfkfBvOyS6OkRcudHj71NsHiRXoRMU+4hh34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609313; c=relaxed/simple;
	bh=KQ68ccufzHU77leJ5j3YQ+hxDm76+kQriwxM+Rk+EYE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ruQ/vT0CxBKw26BPIWdB5pnuhjGVkvZta2cYKKXj+xGviULBviWoBOGwfYvANz5ulV5gP5uNZyF8Uw1AngARZtf7oa0gqWM4tLc5G+VOjWOkXU7IZnEfYMuO9dDiTFdnyMqnWJ5/jwY3Pa7nkkK2RpvPZkAWHPH6S36lM2ckVCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b2QnJJ3o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b2QnJJ3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4D3C4CEC5;
	Fri, 11 Oct 2024 01:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609313;
	bh=KQ68ccufzHU77leJ5j3YQ+hxDm76+kQriwxM+Rk+EYE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=b2QnJJ3otJ26cdhyTENYCEnCK1x3C5VpvlFBoqiuszSF4d0alsVMYwP/UjdXvmSAQ
	 JkaukREurUY92AmUhSZxGD9lLp1o0QlBSK5ugaa896Jd6YEdVj/GnBJ7oz7fVl4kCH
	 8q6U68rl4ZTDaF65TDsKd8MSltTRnABmndoMm58gvoRSfkg4ofn2Znd6lYGHdWFQyw
	 U97NvxS2Uz2QLJzEpgvvNQMfI51btG3CxdUTP1TTNuspVFYyX7mfg5DAH9Ste6PYYI
	 vkyfaepOcbv6n5WdUlR3YelWwmVO5D0W5tm4H+ZTTlowhbY8XbEkVY3purtElJ0RMy
	 Lix0R22YZiq0Q==
Date: Thu, 10 Oct 2024 18:15:12 -0700
Subject: [PATCH 04/38] xfs_db: disable xfs_check when metadir is enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654039.4183231.16408883553488478285.stgit@frogsfrogsfrogs>
In-Reply-To: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
References: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
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

As of July 2024, xfs_repair can detect more types of corruptions than
xfs_check does.  I don't think it makes sense to maintain the xfs_check
code anymore, so let's just turn it off for any filesystem that has
metadata directory trees.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/db/check.c b/db/check.c
index 0a6e5c3280e1cf..b2cee05bfc4cb8 100644
--- a/db/check.c
+++ b/db/check.c
@@ -831,6 +831,12 @@ blockget_f(
 		dbprefix = oldprefix;
 		return 0;
 	}
+
+	if (xfs_has_metadir(mp)) {
+		dbprefix = oldprefix;
+		return 0;
+	}
+
 	check_rootdir();
 	/*
 	 * Check that there are no blocks either

