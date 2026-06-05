Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C533F822E;
	Fri,  5 Jun 2026 11:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780659873; cv=none; b=nHoQfXVnWxu4liGZrd6o2tqUBj8mzH/EZRPPfEmI6Qqr7KN0A66AqMB4tAr2O2uJ5zxazzAdB9p6dGFEsLNO8y7WdeuYFwc3yjPUdLuvC+jh6vev3nqeWg42QPXlwb4efXObSh/SuwD0d660o8w924Y1i7/20KtlHIahF77/jcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780659873; c=relaxed/simple;
	bh=Wf08i8wdpiYfYxy+tMZ2vCbNe9+cEV3cp9ABzrPbTVI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QVX/inOTP/Wu7VlYa3NgGk47EdY0DUd8Fb/9pn46zyU/F2TGqxTG7ic0aI7vghgI6nE+EmyWZw990JP9AiRIpAtxYhgI/YBe3uDtYb3fbHYFo01s+ajevMzbTMt3I1sYBiZvpA6wwTcFl34Q2otYhStVe5iuDOe4msQl0dQVoeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=ONeLyhnp; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="ONeLyhnp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1780659866; x=1781264666; i=markus.elfring@web.de;
	bh=B35raTk7RVQQJATXQZbZzEF8AWmFS53mMpG2m8qazNM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=ONeLyhnp9CEyVpW5oYyc8qB8zDOjfENetvw1ArqtlKc7WY7QQXzIgJRy5yQtwsuQ
	 Rr8oV0S9iF9m8GL7IRHGKp4gK/HhLleyac7a4CxVd4mhfQybhHxOi+0ga66npwMfV
	 diyZosbxfU8gNQ3kVBQT9zy7froTRThQOkHNjhAGs0BeOgAio3E18SiOBs3WPFeJw
	 qDg4XfrbMuINQl9LU+5t7LeHvz5bg2T/gOTf5oV0iUjzI0+3+kVtz9M14etJiAVfv
	 xNCnUlnpuF2bHpo84qTiBMwPmQZd81XBubmt+kXCvUny/TGmuwGM+YRHcQOdVi7n0
	 5h9LSnhUIQsyQfU+hg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1Mft7j-1xBOQS21yT-00pYpH; Fri, 05
 Jun 2026 13:44:25 +0200
Message-ID: <c6145e3b-485e-49ec-bf18-51b0b31ddcbd@web.de>
Date: Fri, 5 Jun 2026 13:44:23 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: Simplify data output in xfs_zoned_show_stats()
To: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 kernel-janitors@vger.kernel.org
References: <995bacb6-881a-4fa0-b2c8-190882522f54@web.de>
 <aiKL3H1uJUqwZMAu@infradead.org>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <aiKL3H1uJUqwZMAu@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:z8ozuhP/5W/173LSVn22zJHa2XDdMIlX8IhxHNasU7uiqYC/JfI
 c9isQwYCZA5Y0j9zoRXE+Zd6CyMeXwpabDslHJ+HfWOtNXqM0dqtIsm6grjolhYDO+g2OBg
 v66HOEN3S80OhkcQs45J2QmNWv5nu6wFROVah5aYisUKPQq6+U2CePYLM1SZjdzgFyTScep
 kwOem70dNqMhU4qJ0qWSw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:7S+z/5FT+cw=;d8SBqoP+8Lw9XAHISoL56W/aeno
 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
 LVvjir6rfrtEAm3fccIFaiCV6iQ=

>> Move the specification for a line break from a seq_puts() call
>> to a seq_printf() call.
>=20
> Umm, no.  Make the code much less redable for no real benefit.
Would you prefer to use a seq_putc() call instead at such a source code pl=
ace?
https://elixir.bootlin.com/linux/v7.1-rc6/source/fs/xfs/xfs_zone_info.c#L7=
8

Regards,
Markus
