Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67881BF3F;
	Sat,  4 May 2024 16:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714841184; cv=none; b=Z2TevppPcZYDPBI473XPWSo5gmQb1hRB094WU/930yaVfJldgVlGeoibOkG9559lU9OW1kmhLcd5zTBa7k+hfedEeE4mh/iCMc5hEzUUQlj2DVxxFAvAvUhtGns1ZYrBSlywWrA8M88aOzSYIujOKV72o7mV8jQiecPJbR1nAoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714841184; c=relaxed/simple;
	bh=5jxx8V+nNPqKmPVWdV0+0Ox5zWIAkOpJRRMZFuNa6L4=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=MGgyvq03l2uvaSqPIwOGEMfraie+FuSNCXZuGKJ7u8MHMRWzWyEQbssQ3Ps8cPVbWgtUHfDRnGcMq1HMnFgTB5++G4qpnELDaD+cSIitSZ5b+DIovARxAZg4wwblCzcd9qtFYeRwMB4jbeCPBkZoN1jTGfcqTHd+bFAtA8NUKKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=BKy5KWWY; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="BKy5KWWY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1714841165; x=1715445965; i=markus.elfring@web.de;
	bh=5jxx8V+nNPqKmPVWdV0+0Ox5zWIAkOpJRRMZFuNa6L4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=BKy5KWWYhp5xPKRLCm1dqGHCjFhujx3RlkpaXhrD70QS8DO5vjrL/V/iuWz9X6SF
	 62Qd9tMVeC1OjKoTf5GLMI+2b8Id9EjmbleREhzOTIxlose+2PSEPFgHcuhkxAAdl
	 iLBcxTznnowpYS4qEL1Wu+CdMLxtvpmdiUBJ8cRYamTSMadsgHrSQFPKjlM2SdKGr
	 5DyuYocr8zAoOCE3Ox45uukGBmvC8QLnJB1MkVIDju5nmL2IG0LaBv1oEOyO5j5fa
	 boIfuMwh2msdXY8yv+iG7ws8a2A7EzqtLCchfeQaDF0Z9yxMz0N567FtkbcehmLeZ
	 vWZM+H5gEIUhLYYTwQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.83.95]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1N0Icn-1soOtu0n8Z-00xKWI; Sat, 04
 May 2024 18:46:05 +0200
Message-ID: <264d605d-b7ff-4d92-925d-30332aa2e2bf@web.de>
Date: Sat, 4 May 2024 18:46:01 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Dan Carpenter <dan.carpenter@linaro.org>, linux-xfs@vger.kernel.org,
 kernel-janitors@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
 Chandan Babu R <chandan.babu@oracle.com>
References: <0e7def98-1479-4f3a-a69a-5f4d09e12fa8@moroto.mountain>
Subject: Re: [PATCH] xfs: check for negatives in xfs_exchange_range_checks()
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <0e7def98-1479-4f3a-a69a-5f4d09e12fa8@moroto.mountain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:I1VDS+lXT8gPAkRX4ICsp9DC98KkcW1J2SOrbYqnZK4U7XuEr6x
 ta2sLJYEHpbLUqb6Mo3aohVYyanJlWiC0n+AUIGOZtpZiEpxZTP3vgwrKPpiZeOfGAYpIrL
 MPCO/gXUQgJxrXi/joS1XDeU6S1TgkRuYpuMxP7JFogjpWV4vmQmBaAbRN0d8iqINbzhQWT
 +2WyLNN3XycudG3O0d6lg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:D29nIzUQi/o=;V1kZDU1H7JScLyyRryYo39rd6oA
 q+BedEOjm8FNn5256Izh9+IZgsamG8t8DmYxGQwNHAngTz1ZM5uJBwcbZZ0HXRxitbNWlnqOx
 teF3WKL9jMlEyGVtKDYxY+Hzk+ScEvyfELvTa+yuaWn7GJS2Cm05xvmS9b7JB9WAQPjnuCjI7
 OMxYrUBEl1lCS3hvUcWl0OI/mGjcQr+ZWYYc9goqTo3KR1Lo3V46rAow7zhoaE+hnUs8pE/Kh
 71stxNA8+D/blFtGx8cAV218xDnLIFidqMAP6uax4VWk551DG9A14/J7Vp9J65gm3AeyHk+1h
 2kvyGni2B/WyFgBcIs3wyYJdBZiNcWR0e/P5M8cquNLJsG4IVrdRb99gg2P3LI1sDLmEE5Noj
 AZzzbRyFa63hdk3ysMHg582Tu7zZ5rkOHfVr8e0Q9Iw/yRlBTTMi+I7DIZp63YH9WUZS9BwRb
 ttkNV65utRgl1XmRUDwIG6c6UKLhuUfmJWwpXvHvQoBHiN78B73QfxpmKm/7zEpYYBGcXGham
 3h1MO6gYu7Y6cK8P53tfPltFMP60B4NIaBAbACDFNwuz7Fy7QBnq3zMzsZn/5SUVxERA7QOow
 gBeXFXqkzkabf/G+he7EAHwTZn3ff6Jz6EMc4lPg3PUhTqFA8CWNXUSycEdXDn9xD60eBui6L
 vHX/5JlWjILwKy9xXzyXbwphNpWUGEuBs6Ut0wmfo8zLjxzMT5hB70lv8CxTYgK29Tk4oaOpI
 32po344ssSKv/a2b4Vhc4tyj1TcPdARqOi+l//2DTB26+MV4JxkRtY7E8v9oLnZ0SgEiMTitg
 0AZ5hYG96szpqG+RoJ6uDpSnEw4v7UgS/zu1BhjoQdgNja3tERVh+buqIKWplyHOjr

=E2=80=A6
> Check the they aren't negative.

Would you like to use the word =E2=80=9Cthat=E2=80=9D (instead of =E2=80=
=9Cthe=E2=80=9D) in this sentence?

Regards,
Markus
