Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794232128;
	b=kFTEQ7ONRYnX3k+ann0qDTJus7TobLO6jkiIs1KB769O1YFnMhtBg3ek/xBV9gKqkvsq
	 z/1bryOvaU5WBNuscmZsDg4ch/6NRvkkmVa6sfeUN1Iwh3A/BGkMzhENwPbgEa5vcLC01
	 35oyVzDHNNQHlUMtoEe0v2pBSs8EtwhtOiCyJFUGdcJz9SXIyUHOKzRr+nmhBzwnnjpHC
	 Pb7IcrxD5WH+mTXnrHWI3ZHafZSQhxKEVKjcgBiUoVemGQclUSG6g2qeJciQyzpi1R8Ni
	 ASU1vdL9q2zF1P5TwDxxtxadl9g+29pPJlVUu4yC9mt4UGvxJ8/hz+XPt89gL5NGD6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794232128;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=TgteWz5nxISOkvoNvgqxcuvs8ZFwGHxIOk7hzMlusnE=;
	b=abHQwJj6sCQLumes3tWi47lA9N2hs6Oeci2Qh2m6ht+WNNit9Wj9qGWQ6dHLulG3cQ5U
	 fAJjUcckauTi0Q2mupNi8O/1vT4ez+7i14L8qTSqL9Hx5lvcXWE4XZTG/+zXiB0zA+0ZE
	 lN+uX6UsVQfcvHrmiQfmeQAlZoCbmz4xKlyNCqGoDvDUrbkcb3lJkjQZG0laS3RZa4sJ1
	 8pmWpuo1aopdeGOmuY1TDEjhcg+8Vi5oLvQvnG7ukcCWYILNgMFPCa2z1SB+zK0+XqX+b
	 rKKDsJzqFzEB4J7L5N/McyL+79hMiNGWVjTWtTcf2Gpy0OtbEoz4bbvFGH3kY3fke0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RgZQoVVg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84577606A32A
	for <linux-xfs@vger.kernel.org>; Mon,  9 Nov 2026 13:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RgZQoVVg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2641F0089F;
	Mon,  9 Nov 2026 13:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794232128;
	bh=TgteWz5nxISOkvoNvgqxcuvs8ZFwGHxIOk7hzMlusnE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RgZQoVVgjmbc8yrSFYGS72JlTenys2MAbbjx6PlK8avkZJrvVs1mClPqKgWyyJdnR
	 rP8i0xV4YjsW0UObuFzzpjQNQfPF/CWvjucLf0Le/gSGzHsYorTfQBD+AZr8LGptDH
	 EsfsPKVoWAAs9BIeZhhbbvDd3OJcZudZs5zXrKGevIX+h/nCEkB2pD3Q4fz/DSO6FJ
	 v6WvYECxkVAEhINyh8HTlYVkrRtasA9MiDESNsW2djKQlYNAI1iTCNe+KP7TYYcDcU
	 Jxg78OB0jvtd5mBCvNlBweFC/n97a2ODJbBkoGXZNXAC3Ip+XH9sO/gaMqRe2Lqlmb
	 59W4loi4wQkcA==
Date: Mon, 9 Nov 2026 14:48:43 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Tristan Madani <tristmd@gmail.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, 
	Tristan Madani <tristan@talencesecurity.com>
Subject: Re: [PATCH xfsdump 1/2] xfsrestore: validate dh_sz in read_dirent()
 before reading name data
Message-ID: <avHGFcmqDq_xbobw@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20261101162753.1443201-1-tristan@talencesecurity.com>
 <20261101162753.1443201-2-tristan@talencesecurity.com>
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
In-Reply-To: <20261101162753.1443201-2-tristan@talencesecurity.com>

On 2026-11-01 16:27:52, Tristan Madani wrote:
> read_dirent() reads directory entries from dump archives into a stack
> buffer. The dh_sz field (uint16_t, up to 65535) is read from the
> archive and used as the read length, but validation was assert()-only
> and compiled out in release builds (-DNDEBUG).
> 
> Replace the three assert() calls with a runtime check that rejects
> entries where dh_sz exceeds the buffer size, is smaller than the
> header, or is misaligned.
> 
> Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
> ---

Looks fine to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

I haven't checked if there're any other assert()s worth converting
to detect corruptions, but these looks worth converting.

-- 
- Andrey
