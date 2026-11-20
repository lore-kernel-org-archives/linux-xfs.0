Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795183187;
	b=I4AQqpekSbVadr87xThDlVwD/q/9N5Ph5LWg9kibOk2/jRSMAXgtylhnZHkEGPjBkVU1
	 t4SsV30ziJLZudrCbPjWezYlA1h7n/G3elrnLHng+7Hq1EZkBYaXn/aatUxcrueXjL4So
	 /8aPUvKxdDE2bBGvNGNlCReBYdJQSKZlhbT6VwTWhQ5HZq39TLYoNSU9ye1MnDSj0+Em8
	 O8BaOfywIpvyZV1+YjNdVC/tAKOYi+0yqx5q02PHOT/Ji2t5P4IlUvT7nBBjgThRAgwct
	 DNl6LIe/VwhnsOG1RoIEhEO71ilwR4FFSwXrMRRtYw7opevpqH9Zm2AuxO7NvC0DtOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795183187;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=7JaNYxK4X8yxNYm8rdmxFoyXmY4o3BW7XgKKDu8Qt+g=;
	b=I+k2B6tr7XyZIhkEXzEu51MRnz0Tq9firNNOuD88M9MdAL05lJBLrTgWQVZWYtoHjiTN
	 nRjXRBcMSuVA8NAV+vs0yL1+kIa1N08C3ZS8UKxQTOfGIjDWE/M2Ezu1GH0KGQQrQRoTa
	 aOkfRYNXte3EpEcdvg60s94njS4VuwuwLKpRD3s8xGPrFc1T1UdlRZ+7J750EAVL+419Q
	 fQgYba7MZw4KocaJgsLPG/GE+4Z0lMRAqUUUd2dFcux/ez1dbJMtOa5zt5j42oFCs5lGD
	 CW0DKu54xTpVx1CJ70M+M54MsucbjPZ2LpPoOhgjo/MBFv2np4e8scXsJlw07ACRaZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MN0E6XnP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019FC606A326;
	Fri, 20 Nov 2026 13:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MN0E6XnP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42471F000D0;
	Fri, 20 Nov 2026 13:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795183186;
	bh=7JaNYxK4X8yxNYm8rdmxFoyXmY4o3BW7XgKKDu8Qt+g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MN0E6XnPRgrY3D7fs6mQxSVuaM0nmp8pHXDF0EP00FdXxkuB7haXceD2evIPE2Fky
	 obaB6TMb3yyJKBPsYdMgL0jQf3Ntl1oGbeEeeDRN55wAMxE/WGtXeGffDeKOt+mJVy
	 Af1bSYBWAcFOJPL6b9PWI8RBBkCs7XpYU2cfgj3R8HSkQQHHmxveI09pbvWR2LDujc
	 Ox6K8a0lwrg4YSw1jV4UeDNN/9lJoccj1BO4mFYhgQAvkrSKZqMQ3MbXamk4mqa8wP
	 6+tWlvCoNUm55wI7kGUi4mjFpTyOFdw55FqDBjsQ/TjQaQ7TzWQ8HP+ibC0itgJSyJ
	 QLcXoRTc9A1zw==
Date: Fri, 20 Nov 2026 14:59:42 +0100
From: Christian Brauner <brauner@kernel.org>
To: Qing Zhang <diasyzhangqing@gmail.com>
Cc: viro@zeniv.linux.org.uk, jack@suse.cz, raven@themaw.net, 
	djwong@kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] namei: revalidate the symlink dentry before invoking
 get_link in RCU-walk
Message-ID: <20261120-desillusionieren-holzhammer-mieten-8ec8551ef2b0@brauner>
References: <20261118083945.1449264-1-diasyzhang@tencent.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261118083945.1449264-1-diasyzhang@tencent.com>

On Wed, Nov 18, 2026 at 04:39:45PM +0800, Qing Zhang wrote:
> XFS can recycle a reclaimable inode in place without waiting for
> pre-existing RCU readers to complete. The recycle path calls
> xfs_reinit_inode(), which calls inode_init_always() and resets i_op
> to empty_iops. A reader retaining an inode pointer from the previous
> VFS lifetime can therefore sample a NULL get_link callback.

Thanks for the very detailed analysis. This can't be fixed by namei.

> +			/* Reject a stale snapshot before invoking the callback. */
> +			if (unlikely(read_seqcount_retry(&link->dentry->d_seq,
> +							last->seq) || !get))
> +				return ERR_PTR(-ECHILD);

This only makes the window smaller.

XFS can still reinitialize the inode right after this check and while
get() is running. Then ->get_link() operates on an inode that is being
reset underneath it. And the !get check only catches the case where the
that re-init already finished before we loaded ->get_link.

RCU pathwalk relies on inode memory not being reused before a grace
period has passed. XFS itself frees inodes via call_rcu() but the
recycle path hands the same struct inode out again without waiting for
existing RCU walkers.

So that should be fixed in XFS, either by not recycling an inode in
place while RCU walkers can still see it or by keeping i_op and the link
state valid across a recycle.
