Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A24FBE1
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 07:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705908145; cv=none; b=HQOglzVo51SDMqYREOQfUWfK1vX24A2kPIfr10orPKBOnsp/hdqL8cXcGzRpbcoyq853ToJGNG6yG+hzpZaIc5YShSYo8pUjpPndxn3t6AmEmgzZ/LGnL/Jilm+9P5hMLrErTCdErJqCgSJyowBRSSmtyvJuXf8xLW1NfqeVsXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705908145; c=relaxed/simple;
	bh=A49K0uSqSpVZG7mRvjq9ompHMMjHM50PBXZ+uSC2ovM=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=qMbNDri+4oXMnaybg2PJ4f7hW6PLUNGEHnFP4+HfIz+/djtBd1kysTT7LQIViq1d0BMufSHmyhle3cavxRAUXKlWu+I2fnXY2BlO+g+eL7sw+ZLgaGWrad9P9zaAKLQC6FAt/4eApPYamU1hHpJi4tVrdXgEyWvIFsTBoOs2kMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
References: <20231215013657.1995699-1-sam@gentoo.org>
 <20231215013657.1995699-2-sam@gentoo.org> <ZYEwFUy6bFO3h7Lz@infradead.org>
 <87v88k1yeq.fsf@gentoo.org> <877ck2x8uc.fsf@gentoo.org>
 <Za4MLpu/HlP60Oea@infradead.org>
User-agent: mu4e 1.10.8; emacs 30.0.50
From: Sam James <sam@gentoo.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Sam James <sam@gentoo.org>, linux-xfs@vger.kernel.org, Felix Janda
 <felix.janda@posteo.de>
Subject: Re: [PATCH v3 2/4] io: Assert we have a sensible off_t
Date: Mon, 22 Jan 2024 07:22:13 +0000
Organization: Gentoo
In-reply-to: <Za4MLpu/HlP60Oea@infradead.org>
Message-ID: <87zfwxx26s.fsf@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Christoph Hellwig <hch@infradead.org> writes:

> On Mon, Jan 22, 2024 at 04:58:07AM +0000, Sam James wrote:
>> >>  - we don't really need this patch all
>> >>  - but cleaning up xfs_assert_largefile to just use static_assert would
>> >>    probably be nice to have anyway
>> >
>> > Thanks, I agree, but I think static_assert is C11 (and then it gets a
>> > nicer name in C23). If it's still fine for us, I can then use it.
>> >
>> > Does it change your thinking at all or should I send a v4 with it
>> > included?
>> 
>> ping. I don't mind doing a followup, but I'd love to get this in given
>> there's a bunch of other projects still to handle with this sort of
>> problem.
>
> Well, we certainly should drop this patch from the series.  Adding
> a cleanup to switch the existing odd way of asserting the size to
> static_assert would be nice, but I don't think is required.

OK, sure. Thanks!
