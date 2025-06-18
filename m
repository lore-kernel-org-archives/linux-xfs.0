Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72889443;
	Wed, 18 Jun 2025 00:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750206268; cv=none; b=uIaqTav7hPncgktWXvGYVwve+/pe+mbWpO43XRc/NYV4ffiOJvNFo4Q/Ocd1fq2Yz6oGYTQhA3MAYPtQwGx3m7NwgkYXz8Iw+Bmu0Jm/4ocqizCzmT4zWRNRO0T7MSR2tgmN14nvAtRPB7em1PznURdqebXET67a2D5w81NXs0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750206268; c=relaxed/simple;
	bh=8ioRs23MyDYIZ6o8lDsEA08ocIRzh1guGuYuSRR4hUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lUdxoTp6giHlD3zmSP6EdORQeFcf7BVvk5CC/wn/ltn7amJhOutdSEHonLIXpjesfMvMuLLZMqohigKQ3LJFrIKqr6aN0Z8D9mkCP2IMBH/nQNBvVYKvWxBw9UxWN5l3aVNizNVzXQVtzoGnj7QiHKQ9DaS+hIdLqp2Ed2TBq1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HzVTuT4n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HzVTuT4n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA4FC4CEE3;
	Wed, 18 Jun 2025 00:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750206268;
	bh=8ioRs23MyDYIZ6o8lDsEA08ocIRzh1guGuYuSRR4hUE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HzVTuT4n07ncPIFgvoNBa6Iqw9UTprdbcsP9s2DJWMZkhKckoll1Sjuz4mOjqryqp
	 PU3WbIr0aCyRgJusGqfrcwwkpcr1oYkL2lhEXcvF50mIg+TPY2otfE9kkE9u4Udml0
	 YgBKN2puOBCQ26RWk6mA0dmbxswLpeP5xf2TnUuuqDruWXNyd9BCRF/LfIozdlakAd
	 taXL9LWLIuTqejmuSUb+Feawzvdjdop67M9WI4/etwomqpfR1GhokC/ajfQLGsWa47
	 qOA0R8O+Dy27Dq2v3JYCaUecagSkSUpd/tmyM50s3dpGFgbTnMgut2MY9m080k54c4
	 R1sPBjreB3wvQ==
Date: Tue, 17 Jun 2025 20:24:26 -0400
From: Sasha Levin <sashal@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Leah Rumancik <leah.rumancik@gmail.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Long Li <leo.lilong@huawei.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-xfs@vger.kernel.org, stable@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 5.15] xfs: allow inode inactivation during a ro mount log
 recovery
Message-ID: <aFIHOv4bLyGMqSPl@lappy>
References: <20250617205533.145730-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250617205533.145730-1-amir73il@gmail.com>

On Tue, Jun 17, 2025 at 10:55:33PM +0200, Amir Goldstein wrote:
>Sasha,
>
>This 5.15 backport is needed to fix a regression introduced to
>test generic/417 in kernel v5.15.176.
>With this backport, kernel v5.15.185 passed the fstests quick run.
>
>As you may have noticed, 5.15.y (and 5.10.y) are not being actively
>maintained by xfs stable maintainer who moved their focus to 6.*.y
>LTS kernels.
>
>The $SUBJECT commit is a dependency of commit 74ad4693b647, as hinted by
>the wording: "In the next patch, we're going to... This requires...".
>
>Indeed, Leah has backported commit 74ad4693b647 to 6.1.y along with its
>dependency, yet somehow, commit 74ad4693b647 found its way to v5.15.176,
>without the dependency and without the xfs stable review process.
>
>Judging by the line: Stable-dep-of: 652f03db897b ("xfs: remove unknown
>compat feature check in superblock write validation") that exists only
>in the 5.15.y tree, I deduce that your bot has auto selected this
>patch in the process of backporting the commit 652f03db897b, which was
>explicitly marked for stable v4.19+ [1].
>
>I don't know if there is a lesson to be learned from this incident.
>Applying xfs backports without running fstests regression is always
>going to be a gamble. I will leave it up to you to decide if anything
>in the process of applying xfs patches to <= v5.15.y needs to change.

My scripts don't filter out commits with a stable tag like they do for
commits without. This was safe until they also started pulling in
more commits as dependencies to resolve conflicts.

I'll fix it on my end by adding the same filter for stable tagged
commits as well.

Thanks for the fix! I'll queue it up for this upcoming release.

-- 
Thanks,
Sasha
