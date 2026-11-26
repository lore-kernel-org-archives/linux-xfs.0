Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795700969;
	b=BqKxDOT7j8MmGBaVELtf02VETPWeaTUtHXbwStKfDkA0XHvoMLlthqq7eqHfzXxLSYLU
	 STCQWnnc5oG0Bz3xi2dj6+qihAur97k/PmHk/5enNHuwlC+blh60TCMfm2iASaNMjPFEj
	 W5EhYSIgma4w+OuCxqy6BdkYhBpbFct94iMazRU0avrkwL/o0c8FNgpAp9XQuXUknyx9g
	 QrtanEhHpywuHz+RuolXWgN9cngEEk0YspKdG/mwtC+Gpsnqoj6h5mH5XUPSnU7lQtSab
	 oTRBmWUchf3SfmtGqb+AwlwwZ2Zedl1VfGPx5JX8ftVpPDS6XvtryHMUdyIMo4vrObw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795700969;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=Dckl5cZ3WBWmSxFRR2nJW/3y+8t4JCFxv0tEEYaft8o=;
	b=dJElr9W7BVWS3KA8vllNOz1Cn1qE8dRK3MWHI4XxEiPmIuFI0OnW6yqXdNXYN5rit2vM
	 NEk59Zck+Wb2ZineGZEyCeNds2MOGtIUoXCHfHnFLwFebGKnHwMCsLwZmIMWX3CPmx6+W
	 NWPsBbi37c7T0SzCQRDAcGwFwBpWbu0sRPLr3QWyBBOyE0yiHuXQsN2A0v3ibmq8hZe9Y
	 Xc3ngdgfLJzxTKIToEK1uHxOmlOZvudNMW+PjPmLkRpdKJTuvnEPSRHH0eA5/fo7hId1B
	 rllpx1/3UOFAornj0x9VABAszNHgmcuJ2m2FhbIfm27REbemZq1dfWd9//FULyeD3qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CoVYVv0P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6351C606A334;
	Thu, 26 Nov 2026 13:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CoVYVv0P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C0A1F00AD4;
	Thu, 26 Nov 2026 13:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795700969;
	bh=Dckl5cZ3WBWmSxFRR2nJW/3y+8t4JCFxv0tEEYaft8o=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=CoVYVv0Pyud3HwyOON6Wg/7fuwApC54MCMaL+0empd8BaTGSXojGQ1FYmDU8ruERx
	 58y4OAHE0owWukJn8FnrB5nEiRDlUPi2M6CwiwrmMQpEiGmZJO+LbejDybDEVAmE7/
	 Je0+8b4HFZ2zWXw8514SULtCCC0wQ37W0B3AA9iquGoDGAlpip9LjNh+S6QD8Wv0Be
	 pH+zfc8RTacZ6YS8xPi72vlyL2C0mPbuox2F6Ajx6lxfOgkbE1SONwBvMw8oIyNBtl
	 ytGZOTDZQzFRjPp3t40PBBTTNi2AlTUtldfJPPZgQ37tuPjLPTQQP5W38pAsh5zJlm
	 YConAXaQXzhgA==
From: Carlos Maiolino <cem@kernel.org>
To: linux-kernel@vger.kernel.org, jianyungao89@gmail.com
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Eric Sandeen <sandeen@redhat.com>, Alexei Starovoitov <ast@kernel.org>, 
 Yuzuki Ishiyama <ishiyama@hpc.is.uec.ac.jp>, 
 Jinliang Zheng <alexjlzheng@tencent.com>, 
 Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
In-Reply-To: <20261126023419.5727-1-jianyungao89@gmail.com>
References: <20261126023419.5727-1-jianyungao89@gmail.com>
Subject: Re: [PATCH] xfs: fix wrong lookup direction in
 xfs_refcount_lookup_eq tracepoint
Message-Id: <179570096631.157938.2404878356926986619.b4-ty@kernel.org>
Date: Thu, 26 Nov 2026 14:49:26 +0100
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Thu, 26 Nov 2026 10:34:01 +0800, jianyungao89@gmail.com wrote:
> The trace_xfs_refcount_lookup() call in xfs_refcount_lookup_eq() passes
> XFS_LOOKUP_LE. But the actual btree lookup below uses XFS_LOOKUP_EQ,
> so the trace record reports a mismatched lookup direction and misleads
> debugging.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: fix wrong lookup direction in xfs_refcount_lookup_eq tracepoint
      commit: a2a0791c4ef58ce943c7925491f31be95ebc7624

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

