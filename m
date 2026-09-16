Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE48377004;
	Wed, 16 Sep 2026 12:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789560423; cv=none; b=vEw60XbuEouIdjTHo5e0bWnawMxFkskhqgjKh97k5NIFTndLcU7xtITAKRNNgJRC1YxcxwvOU3nm7LHoxxs9wBekhw4pD+WdMDTD3N0uN8VHPuBZENl24ZEXkzIC7h0bSiP+qovlQy5wmyALMYmX6eXkj1lYnlBWoC+OKmEFVIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789560423; c=relaxed/simple;
	bh=qnsS/THUvbFpG2tkKYuenXLXKYmGCD48lEe9++9Wtl0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=cuaBLAvZkuP+X/ewIr12gxeJtd8uzYkfzGmY6MYibPeS2dWdmdX9KmwOg1RKLkno8/HMelXx1hT/nf/nkh5qAhlLKczGR+ZIoqedZ4Wc5vQ/ipgvotexzC5aBdKquAGZEBF/b1gbg7jhoFcvA9EH2VE8CNJiVeDr7X5c9qdklOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=drlo5kv1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="drlo5kv1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBEEC1F0089C;
	Wed, 16 Sep 2026 12:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789560408;
	bh=X8lcAJmUcXqnrC+UEGlYp5KMa/5pviL4RkBYBUO0Zvo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=drlo5kv1ZXYL7l5ltHlLSzy7A+zj/eV8GL5fZhdk+tLr0G9roQpWINLnr3iMG5K5+
	 n9ujM4CSxuuOyAxgJqp2RYAv7zXaeh5rCw10t+bnhHScjEqEZh8rLyRIloiOyKUY9/
	 LsTJ7hLUfaB5kCkyHnOzylW4qY3ch4p4wJwYrORPkN+dDJ0HfPJmRoDGKEsu4gx6I6
	 8eZAlJCOdr24baLxPZoT7URICGSeLWdrCRRKpSbf1AbMw/KTsMoKsMgf9httUG5gES
	 bCiOvRWq6DUrQ1he2ckIA0+c5e+VMrPbhGnbqFwexmMRU13TbPQX9H0H3IDSZGuu2E
	 j/5CjHELsN6iw==
From: Carlos Maiolino <cem@kernel.org>
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260911073007.22530-1-hemanth.selam@gmail.com>
References: <20260911073007.22530-1-hemanth.selam@gmail.com>
Subject: Re: [PATCH v3] xfs: fix typos and repeated words in comments
Message-Id: <178956040745.10466.4414118980786144351.b4-ty@kernel.org>
Date: Wed, 16 Sep 2026 14:06:47 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Fri, 11 Sep 2026 13:00:07 +0530, Hemanth Selam wrote:
> Correct ten misspellings and eight accidentally doubled words in
> comments.  No code changes.
> 
> The doubled word in xfs_zone_alloc.c was not a duplicate: "so that is is
> reused" is "it is" misspelt, so that one reads "so that it is reused"
> rather than dropping a word.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: fix typos and repeated words in comments
      commit: 2f3c2a6f963e57cf4f0f34cbf24ab11abb64d118

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

