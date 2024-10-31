Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9671D0E0D
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416498; cv=none; b=BArtUxqtouCYZWoQMmO41gPD3KI45hisKKsMBUuozwHQ3ztpBp0rVa1QBsAvGAHvIeXjZI1y8DJFAtwECx5+0Hjh66aKT6Vq2dTog/DFT3dIEU8jvHA7ZOtJHdZADGa8T2U73nJMT8PRFwtlvWjsAfMzrnO5XNyBaS2YegPpdvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416498; c=relaxed/simple;
	bh=17HU7dAC0sPq6dTovl+2c7ds9+4XBTYKqbTpAuKBSuI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ObvWRzR+ZJh0b88LK4WHWmKLhKrNGdCwTThYniyJKKKW9C01eYXMsAHDefHCFC9UAQ7H1HKpwgiYF5dahqmRIPhSeJs7cGD9BxhuAeZosstAgWTi+NCicOH+CoP/j2SZyr1YxiMmHIegtk/+cBT1PQPNbbfNIc+1HA+ZkvAcdVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F9jnrK+s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F9jnrK+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84FACC4CEC3;
	Thu, 31 Oct 2024 23:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416497;
	bh=17HU7dAC0sPq6dTovl+2c7ds9+4XBTYKqbTpAuKBSuI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=F9jnrK+sh+nNQ7CWzxrZY7dJfazZiq52eysPnR+IGJFWyUBC7hcf4GqrkatMTEVEA
	 5GLEQ/KJPZ0C7yIbgIxeHhQ/1CVZ57/8/SnGP/eeGBAq9Sps881LTY9Zo1mF8qXFg+
	 1SQImF1VnXJo7BnUnS/nS+byCGYThfrXstqXM1DLyWAZTf5DGJHMh2FBaltjT2iuwl
	 2FElOhbL0FFMk/L/0jDHnX9wnyt35NsOpWkVv+r9ID8DmKYPKJbXATnVAJpAi9/dML
	 5ZVL1hv1mnAV2QaY3wBuV7RQoQfLMHr3973Va9dzCm7b3bGTWS3KnpVbJBf5OVq66f
	 WoQ7Gtju94eUQ==
Date: Thu, 31 Oct 2024 16:14:57 -0700
Subject: [PATCH 24/41] xfs: remove unnecessary check
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566284.962545.2375464901774938397.stgit@frogsfrogsfrogs>
In-Reply-To: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
References: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Dan Carpenter <dan.carpenter@linaro.org>

Source kernel commit: fb8b941c75bd70ddfb0a8a3bb9bb770ed1d648f8

We checked that "pip" is non-NULL at the start of the if else statement
so there is no need to check again here.  Delete the check.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_inode_util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index 74d2b5960bf0f2..92bfdf0715f02e 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -305,7 +305,7 @@ xfs_inode_init(
 		    !vfsgid_in_group_p(i_gid_into_vfsgid(args->idmap, inode)))
 			inode->i_mode &= ~S_ISGID;
 
-		ip->i_projid = pip ? xfs_get_initial_prid(pip) : 0;
+		ip->i_projid = xfs_get_initial_prid(pip);
 	}
 
 	ip->i_disk_size = 0;

