Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714077F7F5
	for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2024 13:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708952828; cv=none; b=sMs3UnJ2ijPSMZ1V9fNhWnka2rEPpgebN7/urlHFSdY3dcY6mtaQxvm2kBEwhx+ZWfMtMSp3iMbRTO5DIo9/ydwImnKXLkMp/eFuZ4xe8fBA9FuXqv0BEpEY4annK+bO20VnXX1MnUxXU8NG0BOas/cxD85UOPFbpzCYbHKH9VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708952828; c=relaxed/simple;
	bh=thO+7xJ6QFFutyGSdFip9mdd51zpgqpdOfG/1Z5q+kA=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=sv9JWwiVBra9RSv8JIeWX6REP9gSa66GLAbdTjV56uXLXhL7xtNHWAtNTltclKMVGAPBvXhjaAM69Lgokmw/LwSoOeMfDSjqlEF4aYG+ZHMDeMvY59dVkzzcNdQ61zHTFprJgNz3/AVh7d9rSAjLzDkc/F2xK0CFX79NDf5PWw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rBuyD3B9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rBuyD3B9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6890FC433F1;
	Mon, 26 Feb 2024 13:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708952828;
	bh=thO+7xJ6QFFutyGSdFip9mdd51zpgqpdOfG/1Z5q+kA=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=rBuyD3B9+a5QvCoVLw/+l4jbLBQT0a3O5+waTpKOIaDmUiBlgcRRZYwa2oajrtgUb
	 xqLDWek2toCkrE0ANKFB0ncvfjnvvX03TCxmYCKrkt56fB4i3xurT9AUmEud7YWidi
	 a7oA+nEMB2p7RnjTBh8vT9CyECkwPp39TZlZ0qbVDcoLL+TPaVKA4SxTAgIm+53WDB
	 qwdFJBdwvTODCBFORBLCtecwBN0Pu/HjyfsQAOO8zhnBEycw2TGXMofAbO5d8XcLX6
	 kcXXodIkOZf3ujrMErTSQHoz7Elu9pRsWBsa44SQtj1lKEE52+8ijFhMFYunVptIMp
	 XOyRv4eikkpag==
References: <20240224010220.GN6226@frogsfrogsfrogs>
 <ZdxnZnmNvdyy_Xil@infradead.org>
 <874jdv5qdh.fsf@debian-BULLSEYE-live-builder-AMD64>
User-agent: mu4e 1.10.8; emacs 27.1
From: Chandan Babu R <chandanbabu@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong"
 <djwong@kernel.org>, Chandan Babu R <chandanrlinux@gmail.com>, xfs
 <linux-xfs@vger.kernel.org>
Subject: Re: [PRBOMB] xfs: online repair patches for 6.9
Date: Mon, 26 Feb 2024 18:34:57 +0530
In-reply-to: <874jdv5qdh.fsf@debian-BULLSEYE-live-builder-AMD64>
Message-ID: <87zfvn4bnt.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Feb 26, 2024 at 06:29:43 PM +0530, Chandan Babu R wrote:
> On Mon, Feb 26, 2024 at 02:26:46 AM -0800, Christoph Hellwig wrote:
>> On Fri, Feb 23, 2024 at 05:02:20PM -0800, Darrick J. Wong wrote:
>>> pc : kfree+0x54/0x2d8
>>> lr : xlog_cil_committed+0x11c/0x1d8 [xfs]
>>
>> This looks a lot like the bug I found in getbmap.  Maybe try changing
>> that kfree to a kvfree?
>
> CIL context structures are allocated using kzalloc() (i.e. kmalloc() with
> __GFP_ZERO flag appended to flags argument). So kfree() should work right?
>

Sorry, I read Dave's email now. I had mistakenly thought that the call to
kfree() is the one which frees CIL context structure.

-- 
Chandan
