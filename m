Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D54144D1A;
	Thu, 28 Nov 2024 12:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732796366; cv=none; b=qzpOguyJMbWjtrur1Lunkl/ryAAmnsl67+FTaWZjXqfYGg5DfAAfZwtlyX32j2FBbdvWeaN05nSGlxWZQtfLqABICyFZgHKaRtXkso94AwEzQDworP6GuH0yAxSwl9V+i+es/tgkOvthEW4IJED9eEvuRDCvy0UC/L8DiRtnxvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732796366; c=relaxed/simple;
	bh=e++nwru0zd4kvvC3DSUfFfq0LtTuOvgYq3EDSt/5JFs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=kffUBvri4ZJRqAJ4B00DrS/7xTIH3nCcxxQaZy9djuRNMRDFvbpfTRpj73+sku2ZMg30OEe+jOzzCr9IGQPHLKjdiGhcSBuxXreNSojfyVjxJPKA8fJ/wdAGBYazTYiP1NkwDIAVEwoVSNPJc8IMUofpvjEED8rarC9gRCAXuT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IzXGFSi5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IzXGFSi5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA80AC4CECE;
	Thu, 28 Nov 2024 12:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732796366;
	bh=e++nwru0zd4kvvC3DSUfFfq0LtTuOvgYq3EDSt/5JFs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=IzXGFSi5QPKOFxewQZZyDqLOJHxqoDHA9Q24a5yM/W+YN8yMjT5iFxWHwp4LWyVBz
	 jKATDx6jtwJnucS3BL+ikjjGjiX1LZeZ+TsVfkFCT5RdgEIKjKbfudmsq7dtEo1PM3
	 Zv9cdBlZgd06PMXkX8y/S07SpHS9RTRygf/ps/dAFEARInvAyvgQNwzkVsNSL4HavX
	 8g38xvWjmp3PYrgnKx3CufF9E/XIgzrMLPeCROc0KKKdUGRcCtF71yecwqgLyC1Bso
	 4wqCFq3zh7BEbp3FzH3YhC6Hb31ZHzkDVdZf06BlXEXU/hwT2HJsnVTRk3tnHugxjZ
	 9AaCTHZAYJ6Hw==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Uros Bizjak <ubizjak@gmail.com>
Cc: Chandan Babu R <chandan.babu@oracle.com>, 
 "Darrick J. Wong" <djwong@kernel.org>, 
 Christoph Hellwig <hch@infradead.org>, Dave Chinner <dchinner@redhat.com>
In-Reply-To: <20241120150725.3378-1-ubizjak@gmail.com>
References: <20241120150725.3378-1-ubizjak@gmail.com>
Subject: Re: [PATCH] xfs: Use xchg() in xlog_cil_insert_pcp_aggregate()
Message-Id: <173279636431.817822.13565572630858949349.b4-ty@kernel.org>
Date: Thu, 28 Nov 2024 13:19:24 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 20 Nov 2024 16:06:22 +0100, Uros Bizjak wrote:
> try_cmpxchg() loop with constant "new" value can be substituted
> with just xchg() to atomically get and clear the location.
> 
> The code on x86_64 improves from:
> 
>     1e7f:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
>     1e84:	48 03 14 c5 00 00 00 	add    0x0(,%rax,8),%rdx
>     1e8b:	00
> 			1e88: R_X86_64_32S	__per_cpu_offset
>     1e8c:	8b 02                	mov    (%rdx),%eax
>     1e8e:	41 89 c5             	mov    %eax,%r13d
>     1e91:	31 c9                	xor    %ecx,%ecx
>     1e93:	f0 0f b1 0a          	lock cmpxchg %ecx,(%rdx)
>     1e97:	75 f5                	jne    1e8e <xlog_cil_commit+0x84e>
>     1e99:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
>     1e9e:	45 01 e9             	add    %r13d,%r9d
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: Use xchg() in xlog_cil_insert_pcp_aggregate()
      commit: 214093534f3c046bf5acc9affbf4e6bd9af4538b

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

