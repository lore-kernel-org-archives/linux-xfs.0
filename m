Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1863B895D;
	Tue, 28 Jul 2026 17:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785259714; cv=none; b=EmiD4lZfUYZRaCblDKZHykkCBosPMB6H+ED/RWPJ4ehB4Z8l4J5lCEyFj6gOVb6eWk0SW5DUGd/70WYJ50UH/N+aGAF1yZu36Ia9hHx2DiQcN7htVT/nu22z/HMmGdZwg2u4yRuAn0umXf8fgqB1RY548Ul4cbmIVSZEBxNVeKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785259714; c=relaxed/simple;
	bh=O4rOuNLRTmbkAP1CyY/AA/19geo/K95YKftQQyUZLhg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=qIOOEYpmTmt02E+vasgThLFJO9Ui33NWS2vC1p5nWdYMxgtOx1Xezo0kmehuFB/Ic+ODFC+EVgVF9Xd7ggHaOIApsjGj8ghnqNisMthtoSOZhkyyAdJPIGGDap7te4lKEB7SfReqQ3iHJtYv9EyTmqYIsN5hHne3oU6YgdjpP+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=fWE0KFzy; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="fWE0KFzy"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 5CB36408BD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1785259706; bh=F0D1oVBp1mCNIFF0QrFoBIyEJH9M0+dob1CyNPP+u+c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=fWE0KFzyxHSbSdvp+z+qb7fSOnT2pf7zwiaGMYKHRyO46fg1W0F+kCtlksrGBjXeF
	 JnNVoqSFiNKbkAcP3/lVOY3TgJ9wou2YWoVhkmO4q9OwDNHqYeJW+sAekhg+ragUf9
	 3yDcTUKaS7xpyr0j9G30CTmpPRHK1MSYUf/1IwI+vear/HX0weMtBWbBkP0DpTJc7H
	 mLgWEQgSiTxQYs+91NUS3fJ18Yq5u1tVff2SSAlQz3UVcZ3WBnAbrCMMMniOtXOGUN
	 pIE8GTiMUJsUGyHeIZPZhKZE0Luhdbm7kjK264V46xVvfkaPJZpZKKyY/sA2r32s4y
	 YO0BEWqM+8OHQ==
Received: from localhost (unknown [IPv6:2601:280:4600:27b::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 5CB36408BD;
	Tue, 28 Jul 2026 17:28:26 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Theodore Tso <tytso@mit.edu>, Jakub Kicinski <kuba@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>, Joanne Koong
 <joannelkoong@gmail.com>, changfengnan@bytedance.com, Christian Brauner
 <brauner@kernel.org>, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 workflows@vger.kernel.org
Subject: Re: selective Sashiko replies, was: Re: [PATCH 2/3] iomap: decouple
 simple direct I/O reads from iomap_dio_rw
In-Reply-To: <ami9NUgcJvr0zHuk@mit.edu>
References: <20260722124931.3159664-1-hch@lst.de>
 <20260722124931.3159664-3-hch@lst.de>
 <CAJnrk1a_cc55HcpRAi+H-mqOn7XUt_BxKJTre=Mw=xaE-5A5Rg@mail.gmail.com>
 <20260723045347.GA6641@lst.de> <20260723151021.GC7380@frogsfrogsfrogs>
 <amI3Kf3lFz4FMqXh@mit.edu> <amNerp4LwjSkHS5t@andromeda.toxiclabs.cc>
 <20260728040120.GA19400@lst.de> <20260728072756.7ddc9fdd@kernel.org>
 <ami9NUgcJvr0zHuk@mit.edu>
Date: Tue, 28 Jul 2026 11:28:25 -0600
Message-ID: <87h5ljf2h2.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

"Theodore Tso" <tytso@mit.edu> writes:

> On Tue, Jul 28, 2026 at 07:27:56AM -0500, Jakub Kicinski wrote:
>> 
>> +1, maybe perhaps someone wants the off-list option, dunno. 
>> But trimming the CC list of the on-list reply is a really weird idea.
>> Submissions often CC multiple vger lists, and the bot only replies to one.
>
> It's not (necessarily) "just one" mailing list.
>
> For better or for worse, there are people who have claimed that being
> exposed to LLM reviews would "deman their humanity".

Can I offer a slightly different perspective here?  I am not one of the
people who has said such things about LLM reviews, but I perhaps
understand at least part of where they are coming from.  It's not "being
exposed" to reviews that is demeaning, it is being forced to justify
one's work to a machine.

I can see how that might feel an awful lot like convincing the
customer-service bot that yes, you *have* tried rebooting your router
and you should be connected to a human without having to do it again.
*That* can be demeaning.

The netdev folks are currently setting up this policy:

	Patch authors are expected to proactively look into the
        AI-generated reviews and handle such feedback as any other kind
        of review: either debate it or address it. In both cases a reply
        on the mailing list is expected.
        (https://lore.kernel.org/all/83360de7addb13a3b5f4d5e722148f248fdb2ae0.1784884817.git.pabeni@redhat.com/)

Without taking a position on whether this view is correct, I can
certainly see why some people would balk at the idea of being forced to
"debate" a machine before having their work considered.

jon
