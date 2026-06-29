Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3B22980A8;
	Mon, 29 Jun 2026 18:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782756017; cv=none; b=CieLhbq7l/t3q7lCO2LIo4Pd0lFejTl14fm1VLqJtbvViO72zW/Q78f/GL6nSLN+GRtnlkCDQPyodOg5EhG6W35IKtqn4DoQLwKHOl56CBYs2Bv4gpZ/PhL9PUwq8A+t5kmAtLAfOIl3KevHg2+Dsvq6KE8VvKBv0kAgXn0bhR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782756017; c=relaxed/simple;
	bh=sIG75y5yRyz6iyGR0gFdgnRLe5u/851DT2ULuAj8/vM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eE910ORcyLeInmjOjetuEs9vvgdAjl8GIIAWfpDFyQXqGTpxrKlLv9V2OctfuLRelXEPY9uP8nzie8CrVPb+hMRhguNZyrVgtt83kYA6GVb638AC9l3Rm9m1E8d7PTPGE6SnZxV2eoizIAsm9D4AukhXJe9uV/TLZ+L7MpECuTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XFaCoqtz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XFaCoqtz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643C41F000E9;
	Mon, 29 Jun 2026 18:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782756016;
	bh=9juhSUvCWu8l6tUw8+3omrLG1Yhz3U+/V/oBXIniBa8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XFaCoqtz3BOhVSiRY8l2WfFNT9R50f5hd4o2gW6WhHZFamrXWfkghNdcsWE22BSX0
	 fL7An+HRKHyWUZI9W90R4Ye8F4Ao4wa+ipRK3BpGNUGn9eIrgiil1u3O3D+Gq6uJ0t
	 3NlMPpQoB2RoCUfyWI/ET6/FK2E/yQ4G2Kzr+/rjKpWb9nPGvLRNWLYgvAxh/CG2KA
	 59zJIrQioyO83oJjxY00uCky0medAbKOVq9+dtbcTk+k/0LrpXlhXf4vPosVrhf+4f
	 wI/zpKIR+FPIgA+CKB7qk7X7pVXQ53nShW7ChdfVtS+KJGMlELz7BdyF9VjhtCQ1lD
	 iuW4ShIY45eIg==
Date: Tue, 30 Jun 2026 02:00:10 +0800
From: Zorro Lang <zlang@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	Lukas Herbolt <lukas@herbolt.com>, Eric Sandeen <sandeen@sandeen.net>, 
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/216: disable all concurrency scaling
Message-ID: <akKye7hMwSw3Vc8L@zlang-mailbox>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>, 
	"Darrick J. Wong" <djwong@kernel.org>, Lukas Herbolt <lukas@herbolt.com>, 
	Eric Sandeen <sandeen@sandeen.net>, Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, 
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <20260619050937.444488-1-hch@lst.de>
 <20260619050937.444488-3-hch@lst.de>
 <20260626045353.GA8735@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626045353.GA8735@lst.de>

On Fri, Jun 26, 2026 at 06:53:53AM +0200, Christoph Hellwig wrote:
> I'll retract this patch in favour of the btrfs fix from Darrick.
> We'll still need patch 1, though.

Let me make sure I have the current status mapped out correctly. So we
should apply/merge the following patches:

[PATCH 1/2] common/xfs: fix _scratch_mkfs_xfs_supports_concurrency
[PATCH 2/2] xfs/21[67]: fix mkfs log concurrency detection
[PATCH 1/2] xfs/078: disable all concurrency scaling

And revert:
[PATCH 2/2] xfs/216: disable all concurrency scaling

Is that correct?

> 
