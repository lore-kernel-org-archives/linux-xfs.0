Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A8167E69
	for <linux-xfs@vger.kernel.org>; Thu,  8 Feb 2024 06:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707373628; cv=none; b=CvU8yLOYH6+r2WWCa6rYA5jqO4Va6kbNNymRNFzqEfUZGjt79niGb8kMBFBhRSMITu8mQd0q3AGbuSxe2LMNqK9zQnaamUV0VwGlAVcO7seDFlt5mU9mLFez/CVO3iLwv9HJbm1PJ7QT2FnYRUEmeAZUjUJFNn/tqX4/DL3X1/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707373628; c=relaxed/simple;
	bh=fBkofzdFU1LtPArjaJnsLldiWQrCflkOt1tqM/WoO6k=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=hrCRhhCe9o2qgbf8QdwEosn1uZmvXMNJpwyTn4qLtrPHZIlgDgIywPH4Zn8wEUtPClDxy7wG8P7VlvgFdoZZQZL/3aIXTmFIIG5RnwM1GS7f7KmPZXxPvQ2rVVfHf0AZyKfER46VlY87QjmA3ds3q/r7VnuYwWQ4w1V2Zqv2OUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
References: <l6nxtgxvlwmcejoylpuevoyzxxylkcl2vcsw4pwzilos6rph2k@o5ontnahuhz2>
 <87ttn3jawv.fsf@gentoo.org> <87jznncqo2.fsf@gentoo.org>
 <875xz7cqg9.fsf@gentoo.org> <20240202164410.GJ616564@frogsfrogsfrogs>
 <87wmri8pg8.fsf@gentoo.org>
 <k7znflgh73mksfyetmza4rziakunbppktct346fzakfm5jfmmr@crjkzd3ex4ln>
User-agent: mu4e 1.10.8; emacs 30.0.50
From: Sam James <sam@gentoo.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Sam James <sam@gentoo.org>, "Darrick J. Wong" <djwong@kernel.org>,
 carlos@maiolino.me, linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsprogs: for-next updated to 3ec53d438
Date: Thu, 08 Feb 2024 06:26:52 +0000
Organization: Gentoo
In-reply-to: <k7znflgh73mksfyetmza4rziakunbppktct346fzakfm5jfmmr@crjkzd3ex4ln>
Message-ID: <875xyzv5ca.fsf@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Carlos Maiolino <cem@kernel.org> writes:

> On Mon, Feb 05, 2024 at 11:24:11PM +0000, Sam James wrote:
>> 
>> "Darrick J. Wong" <djwong@kernel.org> writes:
>> 
>> > On Fri, Feb 02, 2024 at 06:47:26AM +0000, Sam James wrote:
>> >>
>> >> Sam James <sam@gentoo.org> writes:
>> >>
>> >> > Sam James <sam@gentoo.org> writes:
>> >> >
>> >> >> I think
>> >> >> https://lore.kernel.org/linux-xfs/20240122072351.3036242-1-sam@gentoo.org/
>> >> >> is ready.
>> >> >>
>> >> >> See Christoph's comment wrt application order:
>> >> >> https://lore.kernel.org/linux-xfs/Za4Yso9cEs+TzU8w@infradead.org/.
>> >> >>
>> >> >
>> >> > Ping - I think it missed another push too. Please let me know if I
>> >> > need to be doing something different.
>> >>
>> >> (Oh wait, maybe the other one was a non-progs push.)
>> >
>> > Huh?  The off64_t -> off_t conversion and the TIME_BITS=64 changes are
>> > both xfsprogs.  Carlos hasn't merged either of those into for-next.  I'm
>> > not sure if he's just going to release 6.6 as-is and move on to 6.7, or
>> > what.
>> 
>> Yeah, sorry -- I'd misread the email and realised too late.
>
> Hi.
>
> Please rebase and re-send them. You can also send a PR if you prefer, I'll queue
> them up for the next release.

Thanks - done at
https://lore.kernel.org/linux-xfs/20240205232343.2162947-1-sam@gentoo.org/.

>
> Carlos
>
>> 
>> >
>> > --D
>> >
>> >> >
>> >> >> thanks,
>> >> >> sam
>> >>
>> >>
>> 

