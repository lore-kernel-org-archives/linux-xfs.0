Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990752D3EFB;
	Wed, 23 Jul 2025 15:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753282891; cv=none; b=EZfio0agFRa1I45RjLXuxb3Jlg/EN23O5QmWj30mWI1/02pxIxLscR91wnvUxl6Ky5HUXnus7vTlMORG7NXSdohphViUZtvQgjrbu0ipTGIN4/e1p4HRHYKzKUVwWUHbMbpCbc/EAt/Qhj48wwAkt1DsFSUu//UW1ROGwcL1LGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753282891; c=relaxed/simple;
	bh=m21SaC0IlLv6BTU6zuvChLqhiP3/AhLoJDrRdogwifE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=bTOV8f7eN9XOeUZ5Ob239EWdUPsANHvfqCSi7ln1Ggz2+X7ZSTgR47NxcCn0Kf+FRXs9PRrXuwCQTRWojZOXthf1ygEPU/CAMh82Ny07VcTZ40DGJlNYtiqc8/U5eDHbYXqOkKVVjmoKhKq+T1S51tfg+dlTxa+9zUL6e96ruLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dPqir2F+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dPqir2F+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345C1C4CEF6;
	Wed, 23 Jul 2025 15:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753282890;
	bh=m21SaC0IlLv6BTU6zuvChLqhiP3/AhLoJDrRdogwifE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=dPqir2F+jYMqbnktdi+u4tGZsnWaeFyV5h94kuq9SXAZ5Adw8lmzBfsSxmSYGi66j
	 g3YLYHcQPO2Bq9jOebM1jFTn2k/Zkqja3arHRb+ifXXswTQu8J1NZux/WQL6nuWvtU
	 0dD8z/SwsKF81MtqULwn1KQzX8hQ1Hf8dk4W7fJEqxTLmEPu/1/4DntS/bJy3h4W+L
	 hXWDVOfMFqFxAk483JZU/inmd1kJhP3X2bsr1jPVV00mmZfr+jfTYcu2akO4fgI8Uw
	 pLPQH8FLqn6MDXQMINX8nR3onqs/R4U/wMk7XI7mJLZrC3Wtes87hb8tOzhOf8ZOlB
	 1VonZSpk/m3uA==
From: Carlos Maiolino <cem@kernel.org>
To: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, Steven Rostedt <rostedt@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, 
 "Darrick J. Wong" <djwong@kernel.org>
In-Reply-To: <20250722201907.886429445@kernel.org>
References: <20250722201907.886429445@kernel.org>
Subject: Re: [PATCH 0/4] xfs: more unused events from linux-next
Message-Id: <175328288785.86753.6771359243622680611.b4-ty@kernel.org>
Date: Wed, 23 Jul 2025 17:01:27 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 22 Jul 2025 16:19:07 -0400, Steven Rostedt wrote:
> I reran the unused tracepoint code on the latest linux-next and found more
> xfs trace events. One was recently added but the rest were there before. Not
> sure how I missed them.
> 
> But anyway, here's a few more patches to remove unused xfs trace events.
> 
> Steven Rostedt (4):
>       xfs: remove unused trace event xfs_dqreclaim_dirty
>       xfs: remove unused trace event xfs_log_cil_return
>       xfs: remove unused trace event xfs_discard_rtrelax
>       xfs: remove unused trace event xfs_reflink_cow_enospc
> 
> [...]

Applied to for-next, thanks!

[1/4] xfs: remove unused trace event xfs_dqreclaim_dirty
      commit: 1edc170bb24082785e5825c46a36af8ae12ac762
[2/4] xfs: remove unused trace event xfs_log_cil_return
      commit: 55edb3326b4b07117d0c26cd67d86fb8518ee906
[3/4] xfs: remove unused trace event xfs_discard_rtrelax
      commit: c17f506f0abe67b6009c0d126da81a71fc1e00c1
[4/4] xfs: remove unused trace event xfs_reflink_cow_enospc
      commit: 10a957e43f28105ceb7b8e31a918d1c47cd4df3e

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

