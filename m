Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795423348;
	b=vWyR0++Fmb1hMHLZNWqxK3scwRoWsKbHR6uRPav5U8YM74NG42v7UeKR/tsMtzeGJa7u
	 gqjXTVjwkE9Ca23ipO69fvxhiPnHXYGIQk2NlGFN3FPGRUyMsBX1bXwzVqGgOLzix71Sz
	 J/42c2clxMB5+YBlIzjzfTVHSLFABufTyj0tiLHll9pdxg7r2ZgSPOCOWyz14Bvk6TC3K
	 Z+3o1GixNnfhij3WTT/yT3gQWHtfYCsz0aW+K6Q9Vn+c3qPPJ5d5udNa8AyK/zNP4HAC2
	 bZME85czaLP88FEh9L+2UCzmnZythSA2YgsL/52wZ62TYKGMqiTF96vO3w5lR1gp9DQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795423348;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=GnIk51qj01nRrXsnOHu/fIQGm+CWLUJoNK8st13nPwo=;
	b=ap0MAgunPnrZh3c1H6ou/gdp8QXv00yMPE6bZiP7hVmpDgwgHCanpXJnjUNx0rWqm0Z5
	 Zp7+9EUcD33TTqiL9IVRREiotPctPYbSTMzvZLgisCgl1HAu3fIK80nvhgsJ/Wowr0FHg
	 qyt2J0m47ZP/W+U+I3jUXAJ1PEpfmoSuSD3QxCMN6O2zgVyCh3qdFBNZni2KSg8Npr6Gp
	 PGHUhUAszS1v4r+EARr6v8qyI5F2JRv6TfZJNUbGgo5NSvzlCCqrHCJb7c6f+zFUkloIT
	 4OFr6A3Ri8og8cg/uTZEtVx9k9RjwAcGphJAd7nLAkvJPycJlcSIZ1OlQ1izFvN1qPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="EaQgt/Fz";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC16F606A31A;
	Mon, 23 Nov 2026 08:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EaQgt/Fz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826291F000D1;
	Mon, 23 Nov 2026 08:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795423347;
	bh=GnIk51qj01nRrXsnOHu/fIQGm+CWLUJoNK8st13nPwo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EaQgt/FzKze3wJRfPGE513dfCman+8X4AAIAVfKUCMeCfM3/W4f2VAZjMrJgJB6kq
	 C372EOKxHq2ZviLHiLjEagtYFvvN9/INQ1uP41sGgx9Nb+hXWOWwVmPZxDkU8l7ZCw
	 Jl5pSbNVqfOzUZ1/5wXEMF4Eu+k53AAImFVIq8608Pv93NMzeAiZ9Q5sSX8v/KR5Gv
	 gN53wRsAQijIlAcvm+fCUYL/3vuyMyPi8ro5V8lt1q0qldyvIcdamjHDpZGFkjHqM6
	 I39Mq6vo9kacIKif2whQ3zOv5mtGlEPYQX1zi1eiQ7BbX2QZ2/ptBn1r7MYCxIbH1Z
	 Ql8NtIJIprzrg==
Date: Mon, 23 Nov 2026 09:42:20 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: koraynilay <koray.fra@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Darrick J . Wong" <djwong@kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
	Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>, Lauri Gates <lauri.gates@gmail.com>, 
	Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ntfs@lists.linux.dev, linux-nfs@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH 1/3] vfs: use goto out on error in vfs_fileattr_set()
Message-ID: <awP8S5KF9v-nqWVY@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20261122000856.536902-1-koray.fra@gmail.com>
 <20261122000856.536902-2-koray.fra@gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261122000856.536902-2-koray.fra@gmail.com>

On 2026-11-22 01:08:54, koraynilay wrote:
> Switch from using if (!err) { ... } to the cleaner if (err) goto out;
> in the main body of vfs_fileattr_set().
> 
> Signed-off-by: koraynilay <koray.fra@gmail.com>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
