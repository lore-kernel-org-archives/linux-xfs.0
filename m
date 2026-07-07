Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7807B3FAE1A;
	Tue,  7 Jul 2026 11:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783424259; cv=none; b=VV4cnmSxNnCq8lp5l0WRZjob9N7n8/uuh6DuoJjJDlgjweRBi0LdUy/98xU0Rr+hO711ec34e7i3kcp3kl7pqHs4wppqMWNbyknM8j6uz62DEXdpmJ47J9Us184BQb85AT1uSuklNVgJwU1JEvaGCkY9F9vDTI9OExV9vdIaOlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783424259; c=relaxed/simple;
	bh=nxLRtyZV5uhR3MmF+Bv4Z3jCboLy297tLwn8sDjV8DM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=r1qZUwRGrNnNHGBSh/XvYrEVhmb/t4LlTbWToq+BHKmRcZcCWsTsN/gQv4Jipa1o9S3/92Loy3tqGPyLp9RhuxZVV0bL5AaUXRZaRRwAWlbH6v84z2FYOFgTZWJ6dO9dir052eGbzv4lwUNGoXfLhGLbZnUAYzII21O8Lwaj20o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jszjGOCf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jszjGOCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6051F000E9;
	Tue,  7 Jul 2026 11:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783424258;
	bh=KLtN4T2yWQxsPrJ1fLRXF87VMXmi3H2CE+pR75C8H88=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=jszjGOCfbfq7pZo2UnXVLEXkDa2OKlGuvEqfyhOMmHjHxkHmMPjI51Hjhbnpy0c03
	 8VKnkkc1gL/0q82mpzQ4fP5i5L+QPtfS/ICvGQVKyF9N7BhdASj8ZSUW7iRiKIZkSP
	 eYMJVy/95CWGNl8F674aYhRNW+0uzym9PVdFros0apLGxaj8UfFhbxyLpcd0ltUUJX
	 huKD/TtMn84aV63YtBji/jFCHRg62IdOfJ3XOGMIxacRL3/N38HK4atdczSMclVl3j
	 urUyldKw7ZFve5qqH2L2sub/Nc/pmgURX6UQgERrV8nAp7/zO0uWwpJlumNtnW6017
	 Z7anxOwk66M1w==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 alexjlzheng@gmail.com
Cc: Jinliang Zheng <alexjlzheng@tencent.com>
In-Reply-To: <20260702115611.3605810-1-alexjlzheng@tencent.com>
References: <20260702115611.3605810-1-alexjlzheng@tencent.com>
Subject: Re: [PATCH] xfs: use xfs_csn_t for xlog_cil_push_now() push_seq
 parameter
Message-Id: <178342425683.389943.1273930158078103552.b4-ty@b4>
Date: Tue, 07 Jul 2026 13:37:36 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2

On Thu, 02 Jul 2026 19:56:11 +0800, alexjlzheng@gmail.com wrote:
> The push_seq argument to xlog_cil_push_now() carries a CIL checkpoint
> sequence number, not a log sequence number (LSN).
> 
> Change the parameter type from xfs_lsn_t to xfs_csn_t to correctly
> reflect its semantics and match the surrounding types. Both types are
> int64_t under the hood, so this is a type-annotation fix with no
> behavioural change.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: use xfs_csn_t for xlog_cil_push_now() push_seq parameter
      commit: de7400fc098b6aa4acbae9c3f5167c91e8ced908

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

