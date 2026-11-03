Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793716841;
	b=YnI9uxyd9UcNWythz8W27SJd5D/fxjQf2YJXw2HchQ9wu3BHZA9qhYhNqLfERqfP3caX
	 SI+QASsX0vZQzQeZfkNAQhEzVQpa5SYL63UicIoanxQx2h6P6Da+gDLfVeUOfBnMWWi2y
	 y1zzLdVaemVlvH+jk7wyfCgXQhCwoI50ajvdxGHqfLLTw/pDCBGvQbOL+5C1lu01FIbX0
	 qSIU0WvNlQgTjrSnq9Lh+W7x1sAvi8jgduajc2dKU+kDy/RrsvcmzTZ2m3hgN8omgmr4Y
	 LvCnxxFV0Q4ylOUfmqNyfs2ZPHazbKQyP1Z0ZZsa0E6m9YltX7DgsxZZJ5Q2HGKOoOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793716841;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=JxbLReXRYAO/z/ArZsF713bkrdZeZOBvZZAxqH4ZM+I=;
	b=UclfrjIJRM/l0ppVzSwPzmW44zy72Tuh7CRibU2N2qgUk3vTFyvJ+IT7mHHtjIiEbWLy
	 vXIVwaFMZtfQsMv1GZ2uBWDhMkA46p0EUb6vxdH3u3yXQ+TX4ux4TO01kFxPfYqx+K9HW
	 1C9FU67Z9vBrqeHBVCQU/hifhKX2N9VdpDqbbPHHCa5A/lTQLUiwMlFotGlp7u81/9QoP
	 /DJCjXo8ORAbLcBKI+AI9MF5l8qVG7GQZvzgCJ9DsKrVOE20GW5PPkkQFiQFwHla3r530
	 ZAMXTQ7Fpk5gnWAQm38yrUMq74tO/K1kHGbL/jZjA1elKA6Rc4nsqsdKFs4Wad94Nng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=web.de;
	spf=pass smtp.mailfrom=web.de;
	dkim=pass header.d=web.de header.i=markus.elfring@web.de header.a=rsa-sha256 header.s=s29768273 header.b="SW/dGP6M";
	arc=none smtp.remote-ip=212.227.17.11
Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827D4606EE80;
	Tue,  3 Nov 2026 14:40:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 827D4606EE80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=web.de header.i=markus.elfring@web.de header.a=rsa-sha256 header.s=s29768273 header.b=SW/dGP6M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1793716834; x=1794321634; i=markus.elfring@web.de;
	bh=JxbLReXRYAO/z/ArZsF713bkrdZeZOBvZZAxqH4ZM+I=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=SW/dGP6MHqKHgoqlUvAkofUIfRr28KPSIQMTLBL/g8rFXW6SCGuRqGjqUI07iwnq
	 PjipVrkFMVUkccI6ZWovRo9LgGdbNiAdMaYUeKxbqGA+a1eHewYxPMHJ51KyvZ0X4
	 0sIMp28ZEKHobE8J26mdUVdVTTA5L6IvHC+DC7wdnTvU7lzfJv3+jMwsOXG0DB8zl
	 Xm6O4dl5wtsOlkFFrpeZkMk4JEvylICzhqJcxPbYn6vhWHjphvOTKS5qvpdT158bO
	 K9TuAKE28B6JO/RHMBKc8vM8NXFfpgl2LDfbSc39TMnzbXFR/9t+TKDa1vaShaXUF
	 nmr7ivl2pqayb3z5jg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MRW2R-1xBnTr3GoH-00N6Q2; Tue, 03
 Nov 2026 15:40:34 +0100
Message-ID: <3a510baa-b919-4d35-a6b6-db19f9ddaa3b@web.de>
Date: Tue, 3 Nov 2026 15:40:27 +0100
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: xfs: fix temporary cursor leak in btree shift corruption paths
To: Jianyun Gao <jianyungao89@gmail.com>, linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>, stable@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>, David Chinner <david@fromorbit.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>, Viktor Malik <vmalik@redhat.com>,
 Yuzuki Ishiyama <ishiyama@hpc.is.uec.ac.jp>
References: <20261102150146.19777-1-jianyungao89@gmail.com>
 <717984c9-a0c2-43d8-a801-d36c18c7040d@web.de>
 <CAHP3+4BfTma1tQLbGLzy3aAzx05eR0QKOfmL0V-X5vEeOWtAEg@mail.gmail.com>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <CAHP3+4BfTma1tQLbGLzy3aAzx05eR0QKOfmL0V-X5vEeOWtAEg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:peTfrVFNz9TXEqiYpHJiDTEwRh9oW8+gjPONuPDJO2agSzvjWJl
 5cqJP2wKUGJh33afUFPz8oxNL5LFumZj3WDP3Njhf8CDkqAvTHUL6rrPeqSLmALrWvDSO1u
 mOPHoBHPSCxeza11oDkEhtcwl6Ffuw2aZPhWiWhkIzIsawndAVtwL97aV+WkPHC5G28vTx4
 sh0BHgqPN57XzB65wUDIw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Ge0Rg/SSOs0=;pdSABZlrHPuB+GyqLrXcb/OwxFH
 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

> Thanks for the review and the suggestion. I agree that centralizing
> the error handling paths in these functions would improve readability.

Further adjustment possibilities might be evolving.


> However, to keep this patch focused strictly on the cursor leak fix
> (as per the 'one patch, one thing' principle), I would prefer to
> submit the code clean-up as a separate follow-up patch if that's
> acceptable.

This can be the case.
Related constraints can eventually be reconsidered also for clean-up patches
in combination with growing number for fixes.


>             I will review the affected functions and see if there are
> any obvious style issues worth addressing.

Would you find another clarification approach helpful?

[RFC] Replacing special goto statements by direct returns?
https://lore.kernel.org/kernel-janitors/52418f50-b3ff-461d-8e66-c10f70e35b2a@web.de/

Regards,
Markus
