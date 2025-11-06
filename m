Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039D032AADD;
	Thu,  6 Nov 2025 13:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762435633; cv=none; b=E8EKmJIWfzg+3HkyyK3KAq0qSxPyqNFV30Y+1avGkQQ4A9gMhSifp88Vc46egImek5WDz5ssOuRvx4jvvyszGNqZjV/yfEL3nHvu/i2UOG20hYtDyB8nqEltTDVyAd8gqjHaIGgrhXAtEUrj9G1DxqnvFR+TDX1Weztqo4VLA8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762435633; c=relaxed/simple;
	bh=HjwbmFgyyeQwjxfwDWx2/mCtNwWxNP+OGPSvtOzOdmY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Cxbx6/4goDSdEBdDttOGBMBgpmjQbJvaouWa/pgAL5HbRPU0u7ZREPYsbeSUvskck6PcpTQXK3Xp2unuWQHf7sC2D0Y8ifL+1wXSzJMSVcX6JJQEUF2k00JSPtDtLs3aZIX5DGn3iwIrHZqe0ldTMSnaMsbfyTktPTl/RJcO10g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=orlA5546; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="orlA5546"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58F5C116D0;
	Thu,  6 Nov 2025 13:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762435630;
	bh=HjwbmFgyyeQwjxfwDWx2/mCtNwWxNP+OGPSvtOzOdmY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=orlA5546GZH0S/J86Oj0J2LsZKHgF1JJbmMmR/AQHhhHvxUNpZ9QKlpkFdgkVgYSf
	 Y1b2Dvt9BD237Ei1jZlaMQtFpyT6hjxvp//vk7A8AXj378hdZ+U1iv8BMDylIGpv51
	 OtVXI60IapoN4ZKT0ISe3HtPEqfD1ZGaQrtWiVx0pSmJWyqmK8gdq4Z5q9m+gxqqmz
	 +orsK23s35p1t3jyhatiYmJqVNC0R47+iIouV/Z4MgSZdJYIxUXLpJwxaDd+iLW90k
	 3SlMqhTCTVA4YuirzYncfqJGU4cFZRwvafpbIcGkxC67xvgRnb3iRAM4IuZFPkvX+E
	 XvQREepKxT0Cg==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>, Zorro Lang <zlang@redhat.com>, 
 fstests@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>, 
 john.g.garry@oracle.com, linux-xfs@vger.kernel.org
In-Reply-To: <20251105001200.GV196370@frogsfrogsfrogs>
References: <20251105001200.GV196370@frogsfrogsfrogs>
Subject: Re: [PATCH v2 1/2] xfs: fix delalloc write failures in
 software-provided atomic writes
Message-Id: <176243562837.345504.16909430155008949617.b4-ty@kernel.org>
Date: Thu, 06 Nov 2025 14:27:08 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 04 Nov 2025 16:12:00 -0800, Darrick J. Wong wrote:
> With the 20 Oct 2025 release of fstests, generic/521 fails for me on
> regular (aka non-block-atomic-writes) storage:
> 
> QA output created by 521
> dowrite: write: Input/output error
> LOG DUMP (8553 total operations):
> 1(  1 mod 256): SKIPPED (no operation)
> 2(  2 mod 256): WRITE    0x7e000 thru 0x8dfff	(0x10000 bytes) HOLE
> 3(  3 mod 256): READ     0x69000 thru 0x79fff	(0x11000 bytes)
> 4(  4 mod 256): FALLOC   0x53c38 thru 0x5e853	(0xac1b bytes) INTERIOR
> 5(  5 mod 256): COPY 0x55000 thru 0x59fff	(0x5000 bytes) to 0x25000 thru 0x29fff
> 6(  6 mod 256): WRITE    0x74000 thru 0x88fff	(0x15000 bytes)
> 7(  7 mod 256): ZERO     0xedb1 thru 0x11693	(0x28e3 bytes)
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: fix delalloc write failures in software-provided atomic writes
      commit: 8d54eacd82a0623a963e0c150ad3b02970638b0d
[2/2] xfs: fix various problems in xfs_atomic_write_cow_iomap_begin
      commit: 8d7bba1e8314013ecc817a91624104ceb9352ddc

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

