Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782371DDF8;
	Wed, 28 Feb 2024 01:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709083625; cv=none; b=mAZzbAzrebBi87l1WXqUDER5eUXC3e88iGYNdl7672KvSLpMNKPR7w22bJv2SewY5J+3/48oEo7PU1cKHf3cHF/HIf+2WvsbClhSKiaFitsty6gN2QtBDsFB0FxaOfSx9sOqjx/BoRJoInNfR1FkTANuHIbtTsHqttcWDJGQBxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709083625; c=relaxed/simple;
	bh=HOEE0xujAAq2KJYPVoli/5kqsDE/deKgZtnU7b8XHpQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X5dnC8B/mqNLco9uqiP3GGzrMiyqzOkYhaGL5AH1Pmoi4EgLPE2jb1xQdHpEtJEEIykGsP6BtKvVlFbDsNmKqLsm8ircOnaPLxj/BKvfqmSsjQPXZGRkZOUqaEvdOTIOwaRiD7loxif5TfXzTKbJQw1FOlNeZwB416NffeGQTSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OAEojhkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OAEojhkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4F7C433F1;
	Wed, 28 Feb 2024 01:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709083625;
	bh=HOEE0xujAAq2KJYPVoli/5kqsDE/deKgZtnU7b8XHpQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OAEojhknPzZepY+qULJtQ+R0lijU/HvW6GtqraSkMpkXyUTOeTJPmym84zzpWSz+P
	 2ZuBTkoFEmyFtdyw8I5pPVJGiY4E/vVqirBwWXeMBw0Al4vtbA/OKQfdQuldfGWm/M
	 YpLX49gGROneAz7PJy/05EjJhYUr5j20Vj9+HrH8KIFwmHsZpz6HDipCz9avo2VkRu
	 wJwm20gq0LM0AtbEZTvtZzeq+8UXUUDzT+0ygS5sXH5hwdIve8oZ1GwTW2S4W31IS8
	 9/6P2q4uZ1BdTPeCW6py7N6Wt8vlvmljy1XUQFtRa3iQRscSzxixAFHg+YL1Yluw8a
	 sSEczpiVZhu/Q==
Date: Tue, 27 Feb 2024 17:27:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, guan@eryu.me,
	fstests@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs/122: update test to pick up rtword/suminfo
 ondisk unions
Message-ID: <20240228012704.GU6188@frogsfrogsfrogs>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915304.896550.17104868811908659798.stgit@frogsfrogsfrogs>
 <Zd33sVBc4GSA5y1I@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd33sVBc4GSA5y1I@infradead.org>

On Tue, Feb 27, 2024 at 06:54:41AM -0800, Christoph Hellwig wrote:
> Can we please just kill the goddamn test?  Just waiting for the
> xfsprogs 6.8 resync to submit the static_asserts for libxfs that
> will handle this much better.

I'll be very happen when we scuttle xfs/122 finally.

However, in theory it's still be useful for QA departments to make sure
that xfsprogs backports (HA!) don't accidentally break things.

IOWs, I advocate for _notrunning this test if xfsprogs >= 6.8 is
detected, not removing it completely.

Unless someone wants to chime in and say that actually, nobody backports
stuff to old xfsprogs?  (We don't really...)

--D
