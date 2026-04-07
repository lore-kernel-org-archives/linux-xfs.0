Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC51F35AC28;
	Tue,  7 Apr 2026 15:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775574271; cv=none; b=NRa++PioF5J3oWqrGmiSz/yyibZrOL6FH91lPYu9raqE/M40aXGoUwBYjeH2QL+JmeJyKhN21R+GBEpfWNAXoBmQqz5v7pSJWlazBMqGOLBnqIE/mQFeVnG3SNpKmN7e9sBsrKvWtK49wUX8tRwa9fJqxZvBdp9U/h9hR1F4JMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775574271; c=relaxed/simple;
	bh=HcrBDmmJv4yYKxVAJ61q0H20ajQsk738BQsiyU8PHd0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rG/BfmNTVr+lugL/ave+Tf37hCYoeI3cBSAItQwCqtZthDfCLA/f9fUlSz8SbhmO4PCwi6c3iV5gBkcKub7hj3WHPZCUf0QLdxi/H+VlHWLL6+gXDe62J4Qah4NFUVxFHEphX7EvfiXZE7XZvq/mx3poElC8Ukpe5JT3IcIXp0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=iFu5Er2O; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="iFu5Er2O"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fqqH10dtJzlgr41;
	Tue,  7 Apr 2026 15:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1775574265; x=1778166266; bh=PnDhbd6bP51AGi/HkPD2H6xj
	qKHyL8lacvfprdOpms8=; b=iFu5Er2Ofp7/bvdr9b5hryboVbRTg1Cfx0S/7bPN
	C7e0niTQFO14rUdQP2VQYKkukUxpzg93bGvS6HXooxM3OXyY3Vg5J2Rx3ALidAep
	s7Kfu5xU7k3pdvCgKx9hWDVRC1124U9Vpnr+SzwWOAHBcSSvzQ3dFnu7dE8G8o3q
	78+Uwb8Wd56MYwxwhdjQv+UcX2LpEpnV3WKs/wXu8iA+poDCBp7yyQIifs4vlGtN
	J7N9PILQOXw6KlcQJ+rTB/5/objJTE4uwDCzw/UZWP56bKOiF4eUy3GRQS6g7Ugh
	yobX9FepWi9IdYGfwyhiA9AJm39dSfvtaKsqX5YOQCPTNQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id SaMOiiRr0yKu; Tue,  7 Apr 2026 15:04:25 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fqqGv0X6Rzlfc3v;
	Tue,  7 Apr 2026 15:04:22 +0000 (UTC)
Message-ID: <22212d59-2041-4ed3-be21-f4b23e3f0d52@acm.org>
Date: Tue, 7 Apr 2026 08:04:20 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] block: add a bio_submit_or_kill helper
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
 linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20260407140538.633364-1-hch@lst.de>
 <20260407140538.633364-5-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260407140538.633364-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/7/26 7:05 AM, Christoph Hellwig wrote:
> Factor the common logic for the ioctl helpers to either submit a bio or
> end if the process is being killed.  As this is now the only user of
> bio_await_chain, open code that.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
