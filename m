Received: from sandeen.net (sandeen.net [63.231.237.45])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10636446DB
	for <linux-xfs@vger.kernel.org>; Thu,  6 Jun 2024 19:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.231.237.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717702065; cv=none; b=Am6xKJpGHbBAzSJzfOzoOcY1Sl0J/edJXYN/gNRU4gVyImB3sDs7DUEFa8cF2dv3gFzkw4Bcwy7kHYOV7p0F9vNWt/5ZcDkXJ7I3efX4KHJZ2MtqmUrOYTNrs0cv3rFohq41yGRnRv5q4ByA1v3X9fC88is3OdbnBDJYrs/thw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717702065; c=relaxed/simple;
	bh=cA84tf6iu1De8hAznkkK5MyKhagyD4aiInx1QRNwPgE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pJ/WMPWhNjcnSpVXZ4n+dcU37u4eDIInCFR2OQ35a/8gyT5UjuIYJOZnjxJtgw5jLg1ly7+jlDn3fquUS3p339Nm50Iv7X4C3doa19z3T+a/MTwKcNt7ARhRnfIEYt2q2SAYLjZyW+sP7ROlCcqxQ0bEnoQdsOWyoI5aaTXyi5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=E9pM4DMd; arc=none smtp.client-ip=63.231.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="E9pM4DMd"
Received: from [10.0.0.71] (usg [10.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 8E03511674;
	Thu,  6 Jun 2024 14:27:35 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net 8E03511674
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
	s=default; t=1717702055;
	bh=Hyy1bjqQgrmnq6koyMsUzLzq67KJaKvSah1IPxD2gVk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=E9pM4DMdT//JS/ZtFqulZ8dCfGERJlfucytnaChByo+XvjmS8TkVvy9y5sYbgWz/K
	 yiHisrpd+AW4RP4q8BUPwc1gYJl9xLZ7BsdhmWsN4KYEn2K0tYC+Fz+HQ7Klwo90kk
	 inIXAIcq3H0gimLWNheyDr4FJEfWxmpfvo+L4QICmu8k/pbJVZnD7fbx0zSyiV7jMb
	 0txkuE84uZMSlpC7UScVcuVPacj0IuaPxP1pOhY811IVeJoTH9bnnOJkkxerQxjDea
	 aoTYGOJe44glliuAJJ+x7PD91HrSnBxJmBZ9xmZpw7BC/bNJNEEBkfxR5kIZ9GI2Yw
	 7e6tfOqhikDPw==
Message-ID: <31e32825-cad7-479d-9ef6-9a086fce1689@sandeen.net>
Date: Thu, 6 Jun 2024 14:27:34 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfsprogs: remove platform_zero_range wrapper
To: "Darrick J. Wong" <djwong@kernel.org>, Eric Sandeen <sandeen@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 Christoph Hellwig <hch@infradead.org>, Zorro Lang <zlang@redhat.com>,
 Carlos Maiolino <cmaiolino@redhat.com>
References: <a216140e-1c8a-4d04-ba46-670646498622@redhat.com>
 <20240606152859.GL52987@frogsfrogsfrogs>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20240606152859.GL52987@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 6/6/24 10:28 AM, Darrick J. Wong wrote:
> On Wed, Jun 05, 2024 at 10:38:20PM -0500, Eric Sandeen wrote:
>> Now that the guard around including <linux/falloc.h> in
>> linux/xfs.h has been removed via
>> 15fb447f ("configure: don't check for fallocate"),
>> bad things can happen because we reference fallocate in
>> <xfs/linux.h> without defining _GNU_SOURCE:
>>
>> $ cat test.c
>> #include <xfs/linux.h>
>>
>> int main(void)
>> {
>> 	return 0;
>> }
>>
>> $ gcc -o test test.c
>> In file included from test.c:1:
>> /usr/include/xfs/linux.h: In function ‘platform_zero_range’:
>> /usr/include/xfs/linux.h:186:15: error: implicit declaration of function ‘fallocate’ [-Wimplicit-function-declaration]
>>   186 |         ret = fallocate(fd, FALLOC_FL_ZERO_RANGE, start, len);
>>       |               ^~~~~~~~~
>>
>> i.e. xfs/linux.h includes fcntl.h without _GNU_SOURCE, so we
>> don't get an fallocate prototype.
>>
>> Rather than playing games with header files, just remove the
>> platform_zero_range() wrapper - we have only one platform, and
>> only one caller after all - and simply call fallocate directly
>> if we have the FALLOC_FL_ZERO_RANGE flag defined.
>>
>> (LTP also runs into this sort of problem at configure time ...)
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> NOTE: compile tested only
>>
>> diff --git a/include/linux.h b/include/linux.h
>> index 95a0deee..a13072d2 100644
>> --- a/include/linux.h
>> +++ b/include/linux.h
>> @@ -174,24 +174,6 @@ static inline void platform_mntent_close(struct mntent_cursor * cursor)
>>  	endmntent(cursor->mtabp);
>>  }
>>  
>> -#if defined(FALLOC_FL_ZERO_RANGE)
>> -static inline int
>> -platform_zero_range(
>> -	int		fd,
>> -	xfs_off_t	start,
>> -	size_t		len)
>> -{
>> -	int ret;
>> -
>> -	ret = fallocate(fd, FALLOC_FL_ZERO_RANGE, start, len);
>> -	if (!ret)
>> -		return 0;
>> -	return -errno;
>> -}
>> -#else
>> -#define platform_zero_range(fd, s, l)	(-EOPNOTSUPP)
>> -#endif
> 
> Technically speaking, this is an abi change in the xfs library headers
> so you can't just yank this without a deprecation period.  That said,
> debian codesearch doesn't show any users ... so if there's nothing in
> RHEL/Fedora then perhaps it's ok to do that?
> 
> Fedora magazine pointed me at "sourcegraph" so I tried:
> https://sourcegraph.com/search?q=context:global+repo:%5Esrc.fedoraproject.org/+platform_zero_range&patternType=regexp&sm=0
> 
> It shows no callers, but it doesn't show the definition either.

Uh, yeah, I suppose so. It probably never should have been here, as it's
only there for mkfs log discard fun.

I don't see any good way around this. We could #define _GNU_SOURCE at the
top, but if anyone else does:

#include <fcntl.h>
#include <xfs/linux.h> // <- #defines _GNU_SOURCE before fcntl.h

we'd already have the fcntl.h guards and still not enable fallocate.

The only thing that saved us in the past was the guard around including
<falloc.h> because nobody (*) #defined HAVE_FALLOCATE

so arguably removing that guard was an "abi change" because now it's exposed
by default.

(I guess that also means that nobody got platform_zero_range() without
first defining HAVE_FALLOCATE which would be ... unexpected?)

* except LTP at configure time, LOLZ
 
>> -
>>  /*
>>   * Use SIGKILL to simulate an immediate program crash, without a chance to run
>>   * atexit handlers.
>> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
>> index 153007d5..e5b6b5de 100644
>> --- a/libxfs/rdwr.c
>> +++ b/libxfs/rdwr.c
>> @@ -67,17 +67,19 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
>>  	ssize_t		zsize, bytes;
>>  	size_t		len_bytes;
>>  	char		*z;
>> -	int		error;
>> +	int		error = 0;
> 
> Is this declaration going to cause build warnings about unused variables
> if built on a system that doesn't have FALLOC_FL_ZERO_RANGE?

I suppose.

> (Maybe we don't care?)

Maybe not!

Maybe I should have omitted the initialization so you didn't notice :P

I could #ifdef around the variable declaration, or I could drop the
error variable altogether and do:

	if (!fallocate(fd, FALLOC_FL_ZERO_RANGE, start_offset, len_bytes)) {
		xfs_buftarg_trip_write(btp);
		return 0;
	}

if that's better?

Thanks,
-Eric

> --D
> 
>>  
>>  	start_offset = LIBXFS_BBTOOFF64(start);
>>  
>>  	/* try to use special zeroing methods, fall back to writes if needed */
>>  	len_bytes = LIBXFS_BBTOOFF64(len);
>> -	error = platform_zero_range(fd, start_offset, len_bytes);
>> +#if defined(FALLOC_FL_ZERO_RANGE)
>> +	error = fallocate(fd, FALLOC_FL_ZERO_RANGE, start_offset, len_bytes);
>>  	if (!error) {
>>  		xfs_buftarg_trip_write(btp);
>>  		return 0;
>>  	}
>> +#endif
>>  
>>  	zsize = min(BDSTRAT_SIZE, BBTOB(len));
>>  	if ((z = memalign(libxfs_device_alignment(), zsize)) == NULL) {
>>
>>
> 

