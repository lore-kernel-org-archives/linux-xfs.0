Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039401DFC7;
	Wed, 10 Apr 2024 19:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712777903; cv=none; b=BZW9SYFYPbWruBqAxDXmmEm5gbxulElFhXCrHnjGxOp2RoROS3vJk+GFn2O3KluC0Go7oAuf+YYcylya1jyJpqA+bb8JG+KvHV+XAI1ML8wZW28Sn5AXM222pEnUNn5MfZpwUYMJgOMUfnhEW27mMn6x3cWFofhrzKVz4hbuHuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712777903; c=relaxed/simple;
	bh=7hBCC6ywCyJIa/cVrT9SYRnB+UaMeotrDbjLGzG8utU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RL047F1zIVu7KTSW46lj5f+po38z1rLD3pHkARQ9ugBvIwr9u4FwAAbZtyyQ2+rZ3/TMGbsBxtC+b+7NzZofBynzky0tU8Ri8jzhovqEqbZsz5bQA9NR22SDmR7fcKbHim5L8u3o3rUIyZki4RJ26ijLfiCriIPKLkwFH2MhvOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a+HUwLQi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a+HUwLQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1FBC433C7;
	Wed, 10 Apr 2024 19:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712777902;
	bh=7hBCC6ywCyJIa/cVrT9SYRnB+UaMeotrDbjLGzG8utU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a+HUwLQi9g/bhYdDw5rlpmgKnktntcFu+03L2gwnxQ8wO9SqBoJiB+Dz7ubHT7QeT
	 nAyfVsV6eruADdyMLh60/jy3PBPx23Lo05zcvtlvMCPUdQkz6ZhRJNpPnqlvLdyBrF
	 pFtTDyfomtkc7C3IBla8mX1KkP8+O9iaMQnbBvflV32LIMi2Y9st83cL+clLtBhabB
	 xUpzx4/QGUjzSWH+gqEvX7jaCqxSXYSCLF+tlx3PyU7ig+XNPYfFGkIpcrn1N+FqeL
	 QMrTMdJNjBX1QYWh5QonW1Fs5Ujj/IsaJcJSOJeVYgDDVgjdO18VCqXbRWZ5PBQaO2
	 bMt/oe9CSjhBQ==
Date: Thu, 11 Apr 2024 03:38:17 +0800
From: Zorro Lang <zlang@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@redhat.com>, "Darrick J . Wong " <djwong@kernel.org>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: fix kernels without v5 support
Message-ID: <20240410193817.lu5t6khar4edflh6@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240408133243.694134-1-hch@lst.de>
 <20240408145554.ezvbgolzjppua4in@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240408145939.GA26949@lst.de>
 <20240408190043.oib4lmiri7ssw3ez@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240410144254.iiqrxlm64xc6mqa6@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240410145140.GA8219@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240410145140.GA8219@lst.de>

On Wed, Apr 10, 2024 at 04:51:40PM +0200, Christoph Hellwig wrote:
> On Wed, Apr 10, 2024 at 10:42:54PM +0800, Zorro Lang wrote:
> > But as the review points from XFS list, looks like the patch 4/6 is better
> > to not be merged, and the patch 6/6 need further changes? So I'll look forward
> > the V2, to take more actions.
> 
> Maybe you can take 1-3 and 5 for now and I'll rework the others?

Sure, you can find these 4 patches in "patches-in-queue" branch. Feel free to
tell me if you hope to change something.

Thanks,
Zorro

> 
