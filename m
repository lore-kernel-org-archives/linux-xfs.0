Received: from mail.itouring.de (mail.itouring.de [85.10.202.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44976253F13
	for <linux-xfs@vger.kernel.org>; Sat, 30 Aug 2025 17:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.10.202.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756576543; cv=none; b=VjAF5483BpHxt22hU8VPyN4U91SVeaKybjJHqg86DCOv2stP5eg2ritKeZybMnfDRNTOru9IEB6owsfFZhSoehgU1bMLmdT5zR02OUhi2vBg7wTMExHpwBb7WoZ1Z4+BhHZY/JfhdEN2XcvMResnxDkLa+Sn6R+YZH9uc0TiyU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756576543; c=relaxed/simple;
	bh=JR1SQQ9OyhVJkD/ma77NtAb5rqae1/UzpV0yqP6q1NM=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=IAAm2YUK2o5m/ORbwmOUou2ccPnYSf3XSdYOTyS1d3Mta/pZwvocjfQ+iIOPH4wX34hod+BRnf9GwLTAirS2/ei4KFrlUAuxqLzBCvez6l8ov140UFx774/gpfaOdsRwvuRRyTrIV90OsJQ+NBRlp3/MgOHtPtQtaFCHwa+W6xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com; spf=pass smtp.mailfrom=applied-asynchrony.com; arc=none smtp.client-ip=85.10.202.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=applied-asynchrony.com
Received: from tux.applied-asynchrony.com (p5b347a18.dip0.t-ipconnect.de [91.52.122.24])
	by mail.itouring.de (Postfix) with ESMTPSA id 7ACC8103762;
	Sat, 30 Aug 2025 19:46:01 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
	by tux.applied-asynchrony.com (Postfix) with ESMTP id 3379C6018B7C9;
	Sat, 30 Aug 2025 19:46:01 +0200 (CEST)
Subject: Re: xfsdump musl patch questions
To: Adam Thiede <me@adamthiede.com>, linux-xfs@vger.kernel.org
References: <ba4261b0-d2a2-4688-933f-359a8cc6b75e@adamthiede.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <81fc13da-9db8-3cf2-2a17-30961e0543d5@applied-asynchrony.com>
Date: Sat, 30 Aug 2025 19:46:01 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ba4261b0-d2a2-4688-933f-359a8cc6b75e@adamthiede.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 2025-08-30 13:23, Adam Thiede wrote:
> Hello - I'm interested in packaging xfsdump for alpine linux.
> However, alpine uses musl libc and I had to change a lot of things to
> get xfsdump to build. Mostly it was changing types that are specific
> to glibc (i.e. stat64 -> stat). I'm not much of a c programmer myself
> so I am likely misunderstanding some things, but changing these types
> allows xfsdump to compile and function on musl libc. xfsdump still
> compiles on Debian with this patch too.

You might want to double-check with Gentoo's Musl porting notes:
https://wiki.gentoo.org/wiki/Musl_porting_notes
esp. 2.6: "error: LFS64 interfaces".

We currently still take the "workaround" route:
https://gitweb.gentoo.org/repo/gentoo.git/commit/sys-fs/xfsdump/xfsdump-3.1.12.ebuild?id=33791d44f8bbe7a8d1566a218a76050d9f51c33d

..but fixing this for real is certainly a good idea!

cheers
Holger
