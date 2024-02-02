Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95D217C6E
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 06:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706856475; cv=none; b=LQJrLyOuTVYj2utM1EEMAyiqcx16tnSqcsvU/pIQIIg7U5NPvOnWx1vpvpIDbCiIqnDof/iEvDH+RdxUJTkpe3bhu+OAZR2JiHXk+CGVSOyHZiId/fyinnDxzjtQeMuLe3LKNANKn8wwC9+nPdDUdzXJoKBDMJaOJ2C3j0ibQsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706856475; c=relaxed/simple;
	bh=x5DRNfQqdJN17gTOgJAXEyd9xzZMnuwcX7e9l7LNZUM=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=HHhKbfhoRvDyz0LlI8qyss0Koosef9ZuQZA80tcr6u3Wz6cwiDQg5m+sC8CMk232OUjorkul33tVT++dAoAzI5gXNi7s//VGWB6zmBLCr4TRa+UYeCABxjD3ZNDkyEFIFXPlaRtlcFpvJ6bFqAt4diY+CqqCLmFIoVkQaZ2pYJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
References: <l6nxtgxvlwmcejoylpuevoyzxxylkcl2vcsw4pwzilos6rph2k@o5ontnahuhz2>
 <87ttn3jawv.fsf@gentoo.org> <87jznncqo2.fsf@gentoo.org>
User-agent: mu4e 1.10.8; emacs 30.0.50
From: Sam James <sam@gentoo.org>
To: Sam James <sam@gentoo.org>
Cc: carlos@maiolino.me, linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsprogs: for-next updated to 3ec53d438
Date: Fri, 02 Feb 2024 06:47:26 +0000
Organization: Gentoo
In-reply-to: <87jznncqo2.fsf@gentoo.org>
Message-ID: <875xz7cqg9.fsf@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Sam James <sam@gentoo.org> writes:

> Sam James <sam@gentoo.org> writes:
>
>> I think
>> https://lore.kernel.org/linux-xfs/20240122072351.3036242-1-sam@gentoo.org/
>> is ready.
>>
>> See Christoph's comment wrt application order:
>> https://lore.kernel.org/linux-xfs/Za4Yso9cEs+TzU8w@infradead.org/.
>>
>
> Ping - I think it missed another push too. Please let me know if I
> need to be doing something different.

(Oh wait, maybe the other one was a non-progs push.)

>
>> thanks,
>> sam

