Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E054419F12A;
	Wed, 30 Apr 2025 08:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746002432; cv=none; b=DkmLTTz6AJCqG6bZl/8lQFxfAgrFzkzdSa3zTWmVzJdtLAKbGKUx5zoLCu5pWlzMi/9BZSs3cORrZ2x2g1AID4iR6J5GD28PUas55GQzwvCgOmFN+bdu2WmW+d2/7JgUUJRNQkOrUIizvVw78dhDe+nMRGsZeRVyyGHpEMr1AEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746002432; c=relaxed/simple;
	bh=2+aS1p+PIYdi3k8LcT5oOa53e0Y/LyJrIsHBGjCqonA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U846VdqwYiW5Gj06C9lRYJAVJUoNyFAHifiCgBC8Q0GZH2+fKDj2ROPd+OqShuKD0/RZg0VtfKYEXPOILsVW5r0Eg0GqmPH0QVC2UqkXiZ40hjY7S1MLfrnmdI0Porp86/r7yMN+8F30Ob1q2N1lvLxL6FRw41pjZ54/7u82vao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=jltcpZYS; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="jltcpZYS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1746002427; x=1746607227; i=markus.elfring@web.de;
	bh=X1mUU3VPwnTSUxenCA8+bclJ6MM2rVJBcib3CeUVPWs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=jltcpZYSnrCblEj25P5F1p8d8zTIUqTBgmI4793hFvVh8iDrVkptJKVM9Ku7XiBq
	 Q3SzaZjKaHvrfs2C48W+X62zSM66vsU0DoG30+WVw6Qu98NeCgrymTx0oeLI0J8yv
	 E+UJCoASpQrn/rr3B8L7Dmz9eSXRocjv6TfZcYc9+aFeLeJsBV+c7sbB/mBeShpLY
	 agP55fmIOk6YXapem55viYTbuOHaeGGnj3OLS/1iPsVVZ5/d93GLWqe7zQXVokQQI
	 1xchRoh9A7X9O1oz2L2PlkN+1V/cJUga2zR9mnO9Y4g+raUGVSnBSbq5RIb4SbDs+
	 e++uePKzdLW/7l+64w==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.70.59]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1N7xeb-1v5IRc43Ot-012E80; Wed, 30
 Apr 2025 10:35:00 +0200
Message-ID: <f35da51a-d45a-4be2-81c3-4da25b65c928@web.de>
Date: Wed, 30 Apr 2025 10:34:59 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: Simplify maximum determination in
 xrep_calc_ag_resblks()
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
 kernel-janitors@vger.kernel.org
Cc: Chandan Babu R <chandanbabu@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 Qasim Ijaz <qasdev00@gmail.com>, Natalie Vock <natalie.vock@gmx.de>
References: <oL08RYG1VC2E9huS2ixv9tI5xAJxx88B60-95yE-8PIDHIdkDkYdqKhA9T_qDEoFzv4qGpCn0M0WtI3JV3f5EA==@protonmail.internalid>
 <2b6b0608-136b-4328-a42f-eb5ca77688a0@web.de>
 <wv2ygjx2ste2hfusgp7apsp76wufeegrd26kdkzqmergwhwfqd@spof2npy32p5>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <wv2ygjx2ste2hfusgp7apsp76wufeegrd26kdkzqmergwhwfqd@spof2npy32p5>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:mISh7OMO6D4kdz8YMi3ydRMkqS9ARLWSt+jxV5qzNcvv937L/ht
 4QCBWdU/Xqe3MFWEy6bP4O3MaP3/YKmkjDfXJVSche8nc4mXAdTqVPUaZxzVUyp/0VlkrBW
 EofM7q6FyD9N04i9q6xWrVXdd8YQ5+S5QmPT0RAhCWbfEgxwtPfq95aRWiZOV7dxZ0Ry1bj
 uSn6Hg4gtRZB4GjwyPx7w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:8yKJgPX0AZY=;z/ArDk9DKbE+LAagr7fDHcml/sm
 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

=E2=80=A6
>> +++ b/fs/xfs/scrub/repair.c
>> @@ -382,7 +382,7 @@ xrep_calc_ag_resblks(
>>  			refcbt_sz);
>>  	xfs_perag_put(pag);
>>
>> -	return max(max(bnobt_sz, inobt_sz), max(rmapbt_sz, refcbt_sz));
>> +	return max3(bnobt_sz, inobt_sz, max(rmapbt_sz, refcbt_sz));
>=20
> I have nothing against the patch itself, but honestly I don't see how it
> improves anything. It boils down to nesting comparison instructions too,=
 and
> doesn't make the code more clear IMHO.
> So, unless somebody else has a stronger reason to have this change, NAK =
from my side.
Would you be looking for a wrapper call variant like max4()?

Regards,
Markus
