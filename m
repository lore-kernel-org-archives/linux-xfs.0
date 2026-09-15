Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB394A3F0F;
	Tue, 15 Sep 2026 14:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789483622; cv=none; b=shb0Q+ZWDy1O19UxvCUFhTaj4EgaQKnzY1U6Aslmhg5XYl7U4CPOMiQipEjcJAD5JrTIWIN//VRks4Z40yhWNeOEshUENO6HG+EPRODHjt2fqZigRBF2ryQ1E3mTwWRm9kkTYn6C5V1HFb1d43cYv2+ebwtZkRn9BZPwcQAH0vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789483622; c=relaxed/simple;
	bh=GzlxikgKcP58QrC2XpftUX6QdHoPzGsBNgyfudO1yqQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fAfXYTrhTmnsKaw0IJOO+FuLy1iCvNNPyc59Kq77SdzADjlsOhQtgDc0e5JOJwp5PwCyfV5Im7RefSF3nKEg1M/kICbA3XO+CpFKB9sSnIAnPnPtoSQThxIxIMfHwtJoc+eynxE5DNU0miN84lEb2uxEKKxkJ5n4yebO/6HDo/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DFX8FH8j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DFX8FH8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3301F000FF;
	Tue, 15 Sep 2026 14:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789483615;
	bh=35qZg+bj5nGKRVslcAVBYHun+Ac6P3OZO7Vfrb8Jcig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DFX8FH8j3W04/KOTNATMYaXoiZDcrbW7LMEnqwlAHnX3rv26rCWonRnT2a8JihAtr
	 ITQRIvYnN5moZDne0ZWqJR8MnOcTxFNqwqQKCFPxTqAswOhUA5ZmykbfoWRdnOZt0m
	 994i97lW7Ke5/KZXMJCvD0zG1kf4dCCDkTSC6Vwjc72OLk3Kua+pSssCJNzLOzg5hl
	 ALzs3J43Ck2+5AuNAwhXo+qwoICOHmyfBAVImtCOury76j6eEcofz8VgxE3BmzxqZq
	 i0enQx3BGShKhDeN0dfQ0UpHpAW1dG10oQcu07qC5IYWpy41CD1KLUnQpNFVQ0aXrc
	 JhdgPhqqZW3NA==
Date: Tue, 15 Sep 2026 22:46:48 +0800
From: Zorro Lang <zlang@kernel.org>
To: Christoph Hellwig <hch@infradead.org>, 
	Anand Suveer Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, Chao Yu <chao@kernel.org>
Subject: Re: [PATCH 2/5] common/sysfs: adjust function naming
Message-ID: <aqlXp3ySGW8VCQIk@zlang-mailbox>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>, 
	Anand Suveer Jain <asj@kernel.org>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, Chao Yu <chao@kernel.org>
References: <20260914172509.3799016-1-zlang@kernel.org>
 <20260914172509.3799016-3-zlang@kernel.org>
 <aqjsZZD4RPVK-uBn@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqjsZZD4RPVK-uBn@infradead.org>

On Mon, Sep 14, 2026 at 11:57:41PM -0700, Christoph Hellwig wrote:
> On Tue, Sep 15, 2026 at 01:25:06AM +0800, Zorro Lang wrote:
> > Add the _dev_ infix to helper functions associated with
> > /sys/fs/$FSTYP/<devices> to distinguish them from upcoming
> > /sys/fs/$FSTYP/features/ related helpers.
> 
> Should these even exist as separate helper?  And if so they probably
> should have btrfs in the names?

Hmm... as far as I know, btrfs is the only filesystem that exposes this
"policy" concept under /sys/fs/$FSTYP/ (correct me if I'm wrong). I'm
not sure if this was intended to be a generic design; if not, it makes
sense to add the btrfs prefix and move it over to common/btrfs.

These helpers were originally introduced by Anand. *Anand*, what do you think?
If you agree that too, I can help to do that in next version.

Thanks,
Zorro

> 
