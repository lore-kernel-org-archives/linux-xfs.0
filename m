Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A78CC147;
	Sat, 28 Dec 2024 07:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735371490; cv=none; b=YyN+o0aAyYRBtq46GIhGK3h/veEKBI+cVVjtmvIlDXhXGkKWD4XkSPmE+R1fl9YTf2dPi5ufaH64RT5uCYQhAgyeo+EHB14BZZprs9FLWrGK36U85p0JUvYUVO/t3/b5FpsGikbUdenHxjjX/dlVo6piucW6d2XcfCKtRaFkPGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735371490; c=relaxed/simple;
	bh=/d6Xu27rVh604n66mT74p4P2U/uXqHcBxSkGXasxhp0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D5eemPNjZn+Tq9Lv5QjXbnM3QSLEZALcPsX6f6Si8mmTqlQJywYCmj/OeI1joRk+4Vz5FksaBfNbvPWJXum9XDVifbUmVVDYewHfQWlBhuCeXNejZ3D9nsScyR95TVRJY3rU7rHTmE10qeZCOjDEHBKVXX4XrULbFrra4Vzd/Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Dh3tbDFk; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Dh3tbDFk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:From:
	Content-Type; bh=Q4mkLH4g3jWYbhVKdZDzHwemxYyPYdetRKQlvE3jCss=;
	b=Dh3tbDFkaM0idBpkqqinN+QBReWm8dh5LilKpqvF2GhGqVAjQlRIHS6/jjQvNd
	9ehBYva35Cjbm9tfupNIhA7fBSw9qC4NF8/MXAq+wJR3AURg1uDzW8tjSdGCqCtV
	UROJWUqU6k8NKaJXhZBy97aEAr6Z6iUX8BrrTjbjxpVGk=
Received: from [192.168.5.16] (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wD3_yXFqm9nip7mCA--.38001S2;
	Sat, 28 Dec 2024 15:37:41 +0800 (CST)
Message-ID: <2ab5f884-b157-477e-b495-16ad5925b1ec@163.com>
Date: Sat, 28 Dec 2024 15:37:41 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: Remove i_rwsem lock in buffered read
To: Dave Chinner <david@fromorbit.com>
Cc: djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, Chi Zhiling <chizhiling@kylinos.cn>
References: <20241226061602.2222985-1-chizhiling@163.com>
 <Z23Ptl5cAnIiKx6W@dread.disaster.area>
Content-Language: en-US
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <Z23Ptl5cAnIiKx6W@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wD3_yXFqm9nip7mCA--.38001S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Cw4kKF1Dtw4UKrWUAF4xJFb_yoW8uF1fpF
	WYga1UGF4DtrWxAryDC3yxXryYq34kGFW3Crn5KrWrKr15ZFnaqrWSqF1j9ryrWr1xGrWj
	qr429FykCFyqyFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UBq2_UUUUU=
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/1tbiTxHDnWdvpy8xGwAAsq



On 2024/12/27 05:50, Dave Chinner wrote:
> On Thu, Dec 26, 2024 at 02:16:02PM +0800, Chi Zhiling wrote:
>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>
>> Using an rwsem to protect file data ensures that we can always obtain a
>> completed modification. But due to the lock, we need to wait for the
>> write process to release the rwsem before we can read it, even if we are
>> reading a different region of the file. This could take a lot of time
>> when many processes need to write and read this file.
>>
>> On the other hand, The ext4 filesystem and others do not hold the lock
>> during buffered reading, which make the ext4 have better performance in
>> that case. Therefore, I think it will be fine if we remove the lock in
>> xfs, as most applications can handle this situation.
> 
> Nope.
> 
> This means that XFS loses high level serialisation of incoming IO
> against operations like truncate, fallocate, pnfs operations, etc.
> 
> We've been through this multiple times before; the solution lies in
> doing the work to make buffered writes use shared locking, not
> removing shared locking from buffered reads.

You mean using shared locking for buffered reads and writes, right?

I think it's a great idea. In theory, write operations can be performed
simultaneously if they write to different ranges.

So we should track all the ranges we are reading or writing,
and check whether the new read or write operations can be performed
concurrently with the current operations.

Do we have any plans to use shared locking for buffered writes?


> 
> A couple of old discussions from the list:
> 
> https://lore.kernel.org/linux-xfs/CAOQ4uxi0pGczXBX7GRAFs88Uw0n1ERJZno3JSeZR71S1dXg+2w@mail.gmail.com/
> https://lore.kernel.org/linux-xfs/20190404165737.30889-1-amir73il@gmail.com/
> 
> There are likely others - you can search for them yourself to get
> more background information.

Sorry, I didn't find those discussions earlier.

> 
> Fundamentally, though, removing locking from the read side is not
> the answer to this buffered write IO exclusion problem....
> 
> -Dave.

Best regards,
Chi Zhiling

