Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CBA2AEFB
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 08:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711614181; cv=none; b=A6w95ywjSj1TEkflSVgoTPPIn7baZkDd2WnSdqpmbx6yRBSaJxeon1523/xknPBTP0jAWsflI++5nxEp/eWTohEUkCtk5tiQWwTp9hxWeH2g9FyGIx+VmswcWLnLTgAtbjN1xaWI4YQ8l++EifPJgX9DYcShysy6asBCCNGvTts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711614181; c=relaxed/simple;
	bh=FVi8Y8QwJY4/LC3qaJ8Hnp7/EMvZ9a1W2nY6/5IIT4Q=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=bA0ZmkB5mR9WsEPUgsZybD0QHoEViGYIE2oPnsJOoRYrdd1sT28QKtHvLpyUnijjhJIAnVjXpsWTOyRo1Kkr+eEDTRK1t73rqMfvucoEmz+6gU5rqoa/eXiTE045qF32vFJYApnvfWyCHLWREmZ8R4PfAaVzMgOTPEQBCHW+Lcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XxTV/9xp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XxTV/9xp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A16C433C7;
	Thu, 28 Mar 2024 08:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711614180;
	bh=FVi8Y8QwJY4/LC3qaJ8Hnp7/EMvZ9a1W2nY6/5IIT4Q=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=XxTV/9xpm6gaU6q6tX1SfJ3mAsQPpVj1CmCi/aFzwBWuNpjL/mPQoOxiW6ZQkOWUk
	 zjZ/95Rn7FWsDEcjvwi+xxFnHHq2RSyB/hN/F4xvM74KkKHQisVinsI5PdIpoeXdcA
	 ZLylAswBRQdIUErTCs79yh0Q2HQ2GaOTp/VHuu2T2Hc99enDRWSwk3BRoj5Yef+Wy/
	 av998ETNvHNdpfXCkwvBbKGdmyZWGtl+jHqg7zMJEin56W/6lsLb2pvs8kBkl2GwTj
	 tCQL7VT5npfExpJdvUY393pgluJGpy3jRPZ7zHjCC+jgp60PIrtS3O5nrQsbb81yqF
	 q8fbcnuXBhw9A==
References: <8734sa3o0x.fsf@debian-BULLSEYE-live-builder-AMD64>
 <ZgUWptdgdBrcFZ1O@infradead.org>
User-agent: mu4e 1.10.8; emacs 27.1
From: Chandan Babu R <chandanbabu@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-mm@kvack.org, linux-xfs@vger.kernel.org
Subject: Re: [BUG REPORT] writeback: soft lockup encountered on a
 next-20240327 kernel
Date: Thu, 28 Mar 2024 13:50:27 +0530
In-reply-to: <ZgUWptdgdBrcFZ1O@infradead.org>
Message-ID: <87y1a222al.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


On Thu, Mar 28, 2024 at 12:05:10 AM -0700, Christoph Hellwig wrote:
> On Thu, Mar 28, 2024 at 11:11:05AM +0530, Chandan Babu R wrote:
>> Hi,
>> 
>> Executing fstest on XFS on a next-20240327 kernel resulted in two of my test
>> VMs getting into soft lockup state.
>
> What was the last linux-next tree that did work fine?

The last one I had tested was next-20240319. I did not encounter the the soft
lockup bug with that kernel.

Btw, I have restarted the tests with persistent journal enabled. I hope this
will help in figuring out the test which caused the soft lockup.

-- 
Chandan
