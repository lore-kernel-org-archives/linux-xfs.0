Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C384D5AA
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 23:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707175469; cv=none; b=pnS/hGbHPWE3kBPOflznBIqNSjTn6NMv+xRlAMZGoGFrtgP3dUpt8ezV6T1JqiAYbXL+G1q6cBT1KhRIy47VV6TaSy1sm9285318u7M8I7igRv46UL/1B+t/IG4jMp4O0xNL+2GUfuSpRpNIypqoIkUaYNcAeGuzbjQyTIE4RGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707175469; c=relaxed/simple;
	bh=1VU0EF4DM5md2MM+lNuqzDkslrfQchIsM7bO2oq7q3w=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=rk0eq8ot6uGPsQCR8UlOyh9oQZ4yRC9qLWXAecHSrDLQ1P5nBOWEvL3BFyrs3Y8w/MvACKdoGBuEOQilhnkALxgmrSm16WJSXMcfAm9ULpl7cUASqnh1J1hBOTjaMv0NcqNUQCN01j9NYurgWFvFgogIdewNM0OmhOpg0KfzZeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
References: <l6nxtgxvlwmcejoylpuevoyzxxylkcl2vcsw4pwzilos6rph2k@o5ontnahuhz2>
 <87ttn3jawv.fsf@gentoo.org> <87jznncqo2.fsf@gentoo.org>
 <875xz7cqg9.fsf@gentoo.org> <20240202164410.GJ616564@frogsfrogsfrogs>
User-agent: mu4e 1.10.8; emacs 30.0.50
From: Sam James <sam@gentoo.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Sam James <sam@gentoo.org>, carlos@maiolino.me, linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsprogs: for-next updated to 3ec53d438
Date: Mon, 05 Feb 2024 23:24:11 +0000
Organization: Gentoo
In-reply-to: <20240202164410.GJ616564@frogsfrogsfrogs>
Message-ID: <87wmri8pg8.fsf@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


"Darrick J. Wong" <djwong@kernel.org> writes:

> On Fri, Feb 02, 2024 at 06:47:26AM +0000, Sam James wrote:
>> 
>> Sam James <sam@gentoo.org> writes:
>> 
>> > Sam James <sam@gentoo.org> writes:
>> >
>> >> I think
>> >> https://lore.kernel.org/linux-xfs/20240122072351.3036242-1-sam@gentoo.org/
>> >> is ready.
>> >>
>> >> See Christoph's comment wrt application order:
>> >> https://lore.kernel.org/linux-xfs/Za4Yso9cEs+TzU8w@infradead.org/.
>> >>
>> >
>> > Ping - I think it missed another push too. Please let me know if I
>> > need to be doing something different.
>> 
>> (Oh wait, maybe the other one was a non-progs push.)
>
> Huh?  The off64_t -> off_t conversion and the TIME_BITS=64 changes are
> both xfsprogs.  Carlos hasn't merged either of those into for-next.  I'm
> not sure if he's just going to release 6.6 as-is and move on to 6.7, or
> what.

Yeah, sorry -- I'd misread the email and realised too late.

>
> --D
>
>> >
>> >> thanks,
>> >> sam
>> 
>> 

