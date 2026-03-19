Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50BC2BEC57
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 17:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773940245; cv=none; b=QApdKW79jGVJUsgFw0F+SQrsCDFA6uaCRBxsrJbR/Ie11OUC323A2HSh7FRxfabXTE6mgERRqJBh7OKn099rT2vAunPw+BOmkHd5zDTYQcv04Jx9mRIQZWlsAqwbxA7kA0eplmOXzOERLOf5M25IQ2TowhXTdF+9AhrLx/+x09c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773940245; c=relaxed/simple;
	bh=vPxgUrXkwcKAcsLIHNY5Z7AWPQNF70vDhXd69dnbjOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dvcpXKjMG9W7lkS90+Wd9WUrIHe+OjV/9HND2bI1yjeIBWs9Zbme7rWIQ4Jq/fzLlK7F6DGsITs7yCr7+Ek/6qNDehESv6cdcxu5BJHwNkWZujfrlbk8IcXyqNVO8Vv2EGP33bS7C4OFpkts42xfn6BMq3BGd9iaCyKGYRNPYtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r0n2MXS/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r0n2MXS/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588AEC19424;
	Thu, 19 Mar 2026 17:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773940245;
	bh=vPxgUrXkwcKAcsLIHNY5Z7AWPQNF70vDhXd69dnbjOs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r0n2MXS/2octNoi4N/p2xTPMw714cOF1keVazIw8P1GGTPbC3uW7pqywRLWqS8EHO
	 ATODlQWaiR3nbh1XjPT25APuFYKSdl4k/mfF9NTZu4d8s/MvrVRooWTIOwcwkg4Jp3
	 /eJKwx5WyN6fcOJttewZK92WXVRiflp5h/s/nHyCYGq91ikRMwVbRnL9cuT/Wp0jBy
	 LYJW8hBwN28wuN4kmREf8wsgnQC5fwDtH/+VaTxuqvU8e9WLgTth2NPEJeH//J41EM
	 fheF+NBkv3JppIbHfJvnsGwHKUHkEfbQeBHhTTHpy0nVy9LtgWjJpEpULxGz2jfD8B
	 70z8uZLz0ZXFQ==
Date: Thu, 19 Mar 2026 10:10:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	lonuxli.64@gmail.com
Subject: [PATCH 2/2] xfs: don't irele after failing to iget in
 xfs_attri_recover_work
Message-ID: <20260319171044.GT1770774@frogsfrogsfrogs>
References: <20260319170938.GS1770774@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319170938.GS1770774@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

xlog_recovery_iget* never set @ip to a valid pointer if they return
zero, so this irele will walk off a dangling pointer.  Fix that.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: ae673f534a3097 ("xfs: record inode generation in xattr update log intent items")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 354472bf45f145..fe909bc44c3a79 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -653,7 +653,6 @@ xfs_attri_recover_work(
 		break;
 	}
 	if (error) {
-		xfs_irele(ip);
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, attrp,
 				sizeof(*attrp));
 		return ERR_PTR(-EFSCORRUPTED);
