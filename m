Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7705443165
	for <linux-xfs@vger.kernel.org>; Thu, 22 Aug 2024 05:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724305341; cv=none; b=pbEVqlY9ypL0gLEkfIYVyBXF8WaN1Sc5XmEgqHINczCASwYQh5boNsGlzam4z6Lsog6hsxHxM6VW/W7XU4XRRZV+8ejFJAFZwIbRojMFoaXSAK+yYHoFM/uIj89WaVnZFFOSd2nqh4NTDEq5fNkoD0Eld5UIg6K1Qd3bPuQTaV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724305341; c=relaxed/simple;
	bh=bwmizY1vtdtIeLGmX1OwWIQ462J4gqloJpO2g4dw/Zw=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=j7wnpqtEm/ivVy0LltqJk2CdVazoj6pfEQKim3v7keMSeBljQHzUNoBAo383eoJs6201fEn965JgTVIYEAhWAh40y5xHMY41LcP7hW2mqFXiV+OtlV4GKVPzdRUrLht5ZoJ7NXrONU+I4D7anxtOQiwcR20Vatu+dF8gCvQzyaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LhKtSlO+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LhKtSlO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF55C4AF09;
	Thu, 22 Aug 2024 05:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724305341;
	bh=bwmizY1vtdtIeLGmX1OwWIQ462J4gqloJpO2g4dw/Zw=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=LhKtSlO+kq51d1xhMpUcvID87sR8XVzKhnYadmFJVCBnmtnZPEzwLPbYXHH1Qa0uw
	 Z6wNx2/7SO2q420dq76T9djY4G5Y9lxIFq/cS+G6GlOiQopohq1+5Pa44Olf/4pmo9
	 BvOYajVCJB/3mbvKPEntoHNbSRLqpcZ00En0/3CT7Ovm1fn09yRBm7CwHjnwPoEGBJ
	 q+nrpahfsaGD33N6M2LV8ikNq3K1WkZjk/rBeMOjhijOg2cmN8G7nJefCJhRHjj9YE
	 6L5t3idchn/S46JPuBMdT/gncWmEhhB8apjrK1lKOntlLB2prYHFj3RM8IMGIPAEc2
	 be5Jqc54LHWnA==
References: <20240812224009.GD6051@frogsfrogsfrogs>
 <ZrrzUw55-UQZ649j@infradead.org> <20240822050442.GO865349@frogsfrogsfrogs>
 <87r0ah6saj.fsf@debian-BULLSEYE-live-builder-AMD64>
 <ZsbNIxrlympxO8hn@infradead.org>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, kjell.m.randa@gmail.com, xfs
 <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix di_onlink checking for V1/V2 inodes
Date: Thu, 22 Aug 2024 11:10:56 +0530
In-reply-to: <ZsbNIxrlympxO8hn@infradead.org>
Message-ID: <87msl56rlx.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Aug 21, 2024 at 10:31:15 PM -0700, Christoph Hellwig wrote:
> On Thu, Aug 22, 2024 at 10:55:05AM +0530, Chandan Babu R wrote:
>> On Wed, Aug 21, 2024 at 10:04:42 PM -0700, Darrick J. Wong wrote:
>> > On Mon, Aug 12, 2024 at 10:46:59PM -0700, Christoph Hellwig wrote:
>> >> Looks good:
>> >> 
>> >> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> >
>> > Hey Chandan, I just realized this didn't get merged yet, even though
>> > there's a user complaint about this.  Can we get this staged for 6.11,
>> > please?
>> 
>> Sorry, I missed this patch. I have started running tests on "v6.11-rc4 +
>> <this patch>".  However, the earliest I could send the pull request is
>> sometime next week.
>
> FYI, we'll also need to to fix the new RT discard support as it
> currently is broken when the RT device does not support discard.
> Either my series or (maybe?) the patch Darrick just sent, I'm
> going to give it a spin now.

I will keep a watch on them and pick the one which gets reviewed.

-- 
Chandan
