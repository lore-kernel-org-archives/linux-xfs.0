Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5763370D48
	for <linux-xfs@vger.kernel.org>; Thu, 12 Mar 2026 14:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773325184; cv=none; b=YZEPThIpiiHZmj+Tt8UK8kipPvuosglkm84l31EZTT9JhP1TSLBi6yEHHtZ60S3Mt4fvOcH/7KGl1FkP/8haYFdeLCm7acfg47kJHG5jjt12QKZ3FvB2H+vlQZqfIdNwlGvsLy+GovRlBgnSgwjJZ4T5/7C5+XP59N4NTeYXRxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773325184; c=relaxed/simple;
	bh=b1f2tBl2YI2oB1m2BEW5Sk+6/4IcrZj9kY0zJ4VKP2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WpYkpNw+WwBq5mj+q/SbH2gvj5qgD7PYJthBQi7YJ7gFKE+aZ/vkCyNohFVknMf2QK187udWU0tbnLlr9QRxzW8EkS4ZpnrDL8k3AfMLQEiruHZWcpEJjWEuRgTccxtL5WEkGbSoo7G0/pefccJXegadW5rO8w4D3kXKQAugHPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VPRLya3F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VPRLya3F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BE1C4CEF7;
	Thu, 12 Mar 2026 14:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773325184;
	bh=b1f2tBl2YI2oB1m2BEW5Sk+6/4IcrZj9kY0zJ4VKP2M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VPRLya3Fek8RIN7y+RRLeaHKNy06ZwsNmKdRSGJZIqmQRsgGYoFqDvovM7DLWgnZd
	 q5GaRtL+rseFE95nYeiv9fpfZQwccZ57WoRC9EHoZ85sz3gM0Q9nUq0JlE2AmTiKaB
	 UMSEfmQrh3skhv+xFtVwxEJRMwLwh1lreb2qzxq7ix0n5WvIFmpWOwyL++14UI6xFW
	 YoGR7DSTO8YqU3A1Dr/rm946gTLef3gBBlWrLYtreKpwR2OJa7Zgbud8t0fpuT0r0R
	 jygtmDh4lqT4QYIZuFsgY8nXKE5bDvsGIDtkdE1cOF1R2OZu3pbvmPEHrrSfU3t+k3
	 SlRq9XKVItwjA==
Date: Thu, 12 Mar 2026 07:19:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/28] xfs_healer: use statmount to find moved
 filesystems even faster
Message-ID: <20260312141943.GF1770774@frogsfrogsfrogs>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
 <177311401806.1183235.3840165745930552108.stgit@frogsfrogsfrogs>
 <aa_kSzpFeT7nuJeW@infradead.org>
 <20260310185622.GT1105363@frogsfrogsfrogs>
 <abJmBzRhCK46DcVk@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abJmBzRhCK46DcVk@infradead.org>

On Thu, Mar 12, 2026 at 12:06:47AM -0700, Christoph Hellwig wrote:
> On Tue, Mar 10, 2026 at 11:56:22AM -0700, Darrick J. Wong wrote:
> > Yes we could, though the risk with dropping the previous patch is that
> > someone could introduce a third-party seccomp policy that forbids
> > statmount() even on kernels that support it, and then xfs_healer would
> > just fail if the mount moves.
> 
> Trying toi protect against broken third party security policies is
> impossible.  If people do cargo cult "security" they get what they
> pay for.
> 
> > I'd rather keep the getmntent stuff around since that's the classic way
> > linux programs (including xfsprogs) have handled scanning the mount
> > tables.  But if you feel strongly about not having getmntent it's not
> > hard to pull it out.
> 
> I'm not a fan of keeping code around that doesn't really get exercised.
> Although your next mail suggest we could exercise it, so maybe we just
> need goot test for both cases.
> 
> I still hate the fragility of all this, but I can't immediately thing
> of a better way.

I'll think about this more today, but my gut feeling is that the
getmntent patch should stay because it works for both cases.  But let me
post my new testcase exercising mount --move first.

--D
