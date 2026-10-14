Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE17D49BD7F
	for <linux-xfs@vger.kernel.org>; Wed, 14 Oct 2026 08:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791966517; cv=none; b=mCmNBfc3Bkm1UGpzhsqMIGg/dJykARJgL+u6nqGME8blW6+pRa1qcdwpqgwS4e6Nazw0oCRNrmua3DEtWT03EOrsehyz99Tza98b2/3DROvuvhk3aMYc0PqJjdPsl0zUv11RGPXn9m2XpuU76YRaDXNCahVzCLQF0JFhYLFQmFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791966517; c=relaxed/simple;
	bh=xlu4L8ZgVLSnByi1Dylpqk6czKqWMzlm7KKoWpbDebU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=B5EaJUro4tCjwqv9JANVa8jqPiwIgxqYEIwEI3XxPlvYVRLCBh472pXjTT0/UuC+grnAhUEsnZhRmZAsd6xU9HFGqgZpfuplyuUBvuudtLXCATsQM4AUyFTGg3e+r+6Oji/gySUc4NUUYNLiArdojxXgZNUUf1lF4pVP+cEHY84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RSXYFmq6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RSXYFmq6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A431F000FF;
	Wed, 14 Oct 2026 08:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791966516;
	bh=0/Ud3VHajz22+/a34tJTTrfbgoXstmAwFJu0y5JHcIw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=RSXYFmq6ICrPNYtvBnl+ChY7hJIZJp8EqP+eu1aXs0i00CcK7mb4+VuyXvvS/fBKD
	 VIGKV5ZfjQgQ2BMX0ImQjaFAZ5KYm1fPg4uvKOZja69dmjguhc1rfImAIkaASbP1Jl
	 vyWlMNalhAaOOSGexP5Bi94OCOINtSW8phSEz90IqRl6KCgf80JLAaoX/7g+pkCD8T
	 Mt/wRzRrsYeNmu/OK7Y/EvXpOPHRY4Itl93QKmxAGpzVOhCwmwFNdrCOM5h+LeE5b4
	 5LFnjwwZxgmrCwglHpnFXmbT8W9N8SzqhtI1WIfjas7dBXjGuWOTEd89Kel7Tky8zQ
	 cH+qM/epFy2cg==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Cc: djwong@kernel.org, hch@lst.de
In-Reply-To: <20261013211851.641256-1-sandeen@redhat.com>
References: <20261013211851.641256-1-sandeen@redhat.com>
Subject: Re: [PATCH 0/2] xfs: add missing cursor status check after btree
 ops
Message-Id: <179196651512.20513.11743215029861321737.b4-ty@kernel.org>
Date: Wed, 14 Oct 2026 10:28:35 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Tue, 13 Oct 2026 16:07:45 -0500, Eric Sandeen wrote:
> I've been looking at ways to reduce/eliminate the frequency of the:
> 
> 	if (XFS_IS_CORRUPT(mp, i != 1)) {
> 		xfs_btree_mark_sick(cnt_cur);
> 		return -EFSCORRUPTED;
> 	}
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: add missing cursor status check after xfs_inobt_get_rec
      commit: 5beb41df46f20d8ab5591c5c1f27e79e8a761616
[2/2] xfs: add missing cursor stat checks after xfs_btree_delete
      commit: b47fb1ed0221fd21e696b468ed9eb40dd3c21f4d

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

