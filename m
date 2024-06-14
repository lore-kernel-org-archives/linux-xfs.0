Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63917193075
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 12:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718368320; cv=none; b=mojVE+9WHccWBDhIsIOclFNdUKMLI5e8B1mNo5Jnx8UHyhATyY95YcwqUixhRN29SUsOABIDBRoxizzWEnEpCoYNr32J6qYND+FUALQTl5H3dtUxHJzYA5koGumTvTJdBviVzZjkOf+/iJHph3COWTWGqQOzLzrl8qD5BRj/Bhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718368320; c=relaxed/simple;
	bh=smVhv7xliZsZPDLjKkPXQg2PQOYH03h5HFma3Mgk5wM=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=Nukc1yOyi0cRpNfJJ/0Zow9upbopTuRC73WkKgPdhrnmYS7kF1THG7aSLZAACL4cYujg2KpQyMJZzxsgG6hKr1nE+z5LMpZu73KwpztuXdhJfc0fehoWGomU/HwCdzBO8z3/O4Ocz/7kxdBDf6XUt2whmWxWFQ+aclDfX/L2RVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=err5ME+B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="err5ME+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782CBC2BD10;
	Fri, 14 Jun 2024 12:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718368320;
	bh=smVhv7xliZsZPDLjKkPXQg2PQOYH03h5HFma3Mgk5wM=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=err5ME+BbqC34Wj2cef8j4tQFyQ9szm+RtYiYPK+Uqjygr+BhQPkozKnop+HX57PJ
	 P/qDknlfp5eFx7t2swoH5vIOcAWr++LlrnnFC0zn5e7GA3NxqElvmCaIN0u9cQtkk9
	 0u/H81Yrn7ljADtG/4C4W4M3xk+31r3ztEXHIHYmvlGP9O5cLDFMUodEsoGrhjmI49
	 C3ypK86munqHop4UOBqnItiywf5+ZiEnqOBcuhOBlylAchNQPOH9qmnZdlWTH1ztMt
	 1WWCY87TwlobCK7/RIpJoY8S21DQdfexVs+sOHAv3Aoj2L21SouLC5N0KU4WhOZCQw
	 CoA06i/0LUDAg==
References: <20240612225148.3989713-1-david@fromorbit.com>
 <87frtfx2al.fsf@debian-BULLSEYE-live-builder-AMD64>
 <ZmwX91xXpuvPnPh7@infradead.org>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix unlink vs cluster buffer instantiation race
Date: Fri, 14 Jun 2024 18:00:44 +0530
In-reply-to: <ZmwX91xXpuvPnPh7@infradead.org>
Message-ID: <87bk43wvr7.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, Jun 14, 2024 at 03:14:15 AM -0700, Christoph Hellwig wrote:
> On Fri, Jun 14, 2024 at 03:31:23PM +0530, Chandan Babu R wrote:
>> I am planning to include this patch for v6.11 rather than for v6.10 since -rc4
>> is generally the last release candidate where we add new XFS fixes unless the
>> bug fix is critical. Also, linux-next won't have new releases until June 30th
>> i.e. the next linux-next release is on July 1st. Hence, we will miss out on
>> testing/usage of XFS changes from the community.
>
> It is "critical" in the sense of it fixes a long standing bug people
> had to hack around for months with things like this:
>
> http://git.infradead.org/?p=users/hch/xfs.git;a=commitdiff;h=ea8d9cd0eb485c53eac01a3cf8524278381c31ee
>
> it also is trivial in terms of code.  Not including it would be a
> really strange decision.

Ok. I will add this to the queue for v6.10-rc5.

-- 
Chandan
