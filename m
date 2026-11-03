Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793700147;
	b=3k/xa5QsE+fFUQSxuTRv3gWA9Ka1O0RkZ5pwOqo73hkyoFisq3XGO6gT9p943E0mFhxj
	 xLblNDZC50k0v+WeO4s40oTpBkDnFrtpBbETXHgG4pjoXHWn36YnNX5CQt76SQiiSc6+5
	 8Cbgh4tFVpJtxLGJHHKaPnqsORow5BtVKItZJw58kJcp6DwXA69UOE1X3q8xXtJnfT02E
	 a4aH3wkS12c6/ylqfrd2Z5Wg8kkEk+22ciCnUZWI+yWlE0fsRxQQTfbO6vhce7fwu5HpM
	 68Srblnk60lbVh5Uoz0T5ByzyUMDdQSoCtalg7+WhHU74p0mhiapUJQvmXSDMuCKVJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793700147;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=U+jRsIe3hbOIuakB/IIaObwcL01BzDM7iQo/IOE9Kdo=;
	b=pjvjkQhccLOO96EYJqyDEvob/tQlVmuQXBRE7POKQRNAdP9QWcbiLf09ycAE+bzXGfMq
	 /uakS2mJT3g9rGmlNCBqylOkyy91amjtcc0FTO8CuueSf0E5TjHnmwZuvHrxffRlzJsKJ
	 7Ib4XZLOFWwgOuQ0bX8kwYWFsrm4eHiMln7agvs5BG/5Dy2ttIsKWjIzpbE7N0/MgMmEZ
	 q6JEdN5z9OXdlnbQoHD0lzquQ3IpAS7/irhYRsagR0gh22Q0rYNzLnNOpU+sOeOWHoU1Q
	 xyB1KvA9PRf5mikiQ5AjEKOAt3iGs4jKIjX18R8oTnoX53Z6AHNvKbAx7D/LBJFZ9Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Ost/7BSc";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91613606A326;
	Tue,  3 Nov 2026 10:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ost/7BSc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23BC71F0093A;
	Tue,  3 Nov 2026 10:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793700147;
	bh=U+jRsIe3hbOIuakB/IIaObwcL01BzDM7iQo/IOE9Kdo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Ost/7BScSkw1eZ0ulgw5J36kG6w7xOJJR2uV3NkNHBxVXzclrVv6fB9qRCjG7PwjO
	 E7jpWgjpVKw3BOCxjiM+nEkqkJk0OnwVKEO5ir+c6GDn5ZFmeFq5kw2GAwht06h1iP
	 8LVhlItwoOi1wO2whNXTPDp03qqoCsn0K8AbxDm4sVHREPo1j8wmSMPqXKL7YaUtaR
	 ijXeET6QhBvQMo7XLJC82PtertytEYPwhqOJz9op7H8Df9RqIAhv03v4eXmsGHZ27P
	 ivtbAIg+WoTeFLSBCQlUeF0IJNWQD401JRrI3XQdBsYQL6+X8xt0Dh0psY4OvrWdtw
	 PeHz7BdeipuLw==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, Binbin Deng <18983559317@163.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20261015080225.45215-1-18983559317@163.com>
References: <20261015080225.45215-1-18983559317@163.com>
Subject: Re: [PATCH v1] xfs: set healthmon mount cookie before publishing
 it
Message-Id: <179370014586.413123.10104508891593461029.b4-ty@kernel.org>
Date: Tue, 03 Nov 2026 11:02:25 +0100
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

On Thu, 15 Oct 2026 16:02:25 +0800, Binbin Deng wrote:
> xfs_ioc_health_monitor() allocates the healthmon object with kzalloc(), so
> mount_cookie starts as zero.  zero is also DETACHED_MOUNT_COOKIE, but
> xfs_healthmon_attach() publishes hm through mp->m_healthmon before storing
> the mount cookie.  A concurrent reporter can therefore acquire hm from
> xfs_healthmon_get(), see the detached cookie in xfs_healthmon_push(), and
> drop the event even though the monitor is being attached.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: set healthmon mount cookie before publishing it
      commit: 0344a9492efac4c79202a07cf284a382f7054170

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

