Received: from sandeen.net (sandeen.net [63.231.237.45])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15A3E10A22
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 16:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.231.237.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713285564; cv=none; b=ZO+Z84oeQNO3KRG3GA55djXiuk/VmPxLZLPVqqdeg6lNGMnab34RDjP+5XrB/VLJeGAFDOx/iEZZ2sa11xVVmseOp71C3uCqrEoQ6Cw7sonD+Kd9axDvgmgt5QEvD5clUn38THFVJhUY1p0PV/S1xUHCPvoNgCGQJHRl84l4iVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713285564; c=relaxed/simple;
	bh=o4oQAZJ0b2r0e5YSaaButHC8O9h0ujpbJO+I2TYcYPU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H6jZP6Kwz1DmD7B2bRHNNrJAAjrbLRBPIWt6gdSgJ9/eJzczJ1NL1R7yndAPg+gFgwZtaxyOCLABbsOLPSln92DFWzVr5e9rrmIPPMHM79StqwH9FKgIfGIL+IQbMB438/iFa6qoyEU3kT5DkIw+CiiFD7GZ62lbk7QktaWdBMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=f8tFyBDM; arc=none smtp.client-ip=63.231.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="f8tFyBDM"
Received: from [10.0.0.71] (usg [10.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id C32DB33505B;
	Tue, 16 Apr 2024 11:39:15 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net C32DB33505B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
	s=default; t=1713285555;
	bh=BjcA5QwFs8gYu21OYzNT+oIuDLy/s4V4mc5+vOP+o2I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=f8tFyBDMlNzQuKJRLTWVj6auP6HXx+0cH1amjuOq9DFPZ9vjBN+uuTd+Vrr+KoifH
	 jwTnXreIxsPzCB9wBGy0tQnsGgCUwHY2HJh4tP8WPRg34L+6RjMhuFyRIfp52U9P3u
	 8LGo6W5no2Pn77b4rLbJKrm0L8NcCORO8PFgUcR0rNw1550XUuu/MZK0RgV1Of6tmW
	 aPLhH8NBXsW/S+pesrEVSdLD139lRedMwkSfYaBP0VlAIsaBl/3v7hE6BHRe9Jek97
	 UpaNbhEXVgFvmT6cjGxvwUGqNnxq6w296d8IKMSC18LTXvJIMwhEdpTlNsBePED7sP
	 3c/c29ucZKFdQ==
Message-ID: <2269d1fa-670d-440c-9f37-1724c3b5aa4e@sandeen.net>
Date: Tue, 16 Apr 2024 11:39:14 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] xfs_fsr: convert fsrallfs to use time_t instead of
 int
To: "Darrick J. Wong" <djwong@kernel.org>,
 Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
References: <20240416123427.614899-1-aalbersh@redhat.com>
 <20240416123427.614899-6-aalbersh@redhat.com>
 <20240416162125.GN11948@frogsfrogsfrogs>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20240416162125.GN11948@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/16/24 11:21 AM, Darrick J. Wong wrote:
> On Tue, Apr 16, 2024 at 02:34:27PM +0200, Andrey Albershteyn wrote:
>> Convert howlong argument to a time_t as it's truncated to int, but in
>> practice this is not an issue as duration will never be this big.
>>
>> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
>> ---
>>  fsr/xfs_fsr.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
>> index 3077d8f4ef46..07f3c8e23deb 100644
>> --- a/fsr/xfs_fsr.c
>> +++ b/fsr/xfs_fsr.c
>> @@ -72,7 +72,7 @@ static int  packfile(char *fname, char *tname, int fd,
>>  static void fsrdir(char *dirname);
>>  static int  fsrfs(char *mntdir, xfs_ino_t ino, int targetrange);
>>  static void initallfs(char *mtab);
>> -static void fsrallfs(char *mtab, int howlong, char *leftofffile);
>> +static void fsrallfs(char *mtab, time_t howlong, char *leftofffile);
>>  static void fsrall_cleanup(int timeout);
>>  static int  getnextents(int);
>>  int xfsrtextsize(int fd);
>> @@ -387,7 +387,7 @@ initallfs(char *mtab)
>>  }
>>  
>>  static void
>> -fsrallfs(char *mtab, int howlong, char *leftofffile)
>> +fsrallfs(char *mtab, time_t howlong, char *leftofffile)
> 
> Do you have to convert the printf format specifier too?

Hm, yeah. Another approach might be to just change "howlong"
to an int and reject run requests of more than 24855 days. ;)

*shrug* either way.

> Also what happens if there's a parsing error and atoi() fails?  Right
> now it looks like -t garbage gets you a zero run-time instead of a cli
> parsing complaint?

That seems like a buglet, but unrelated to the issue at hand, right?
So another patch, perhaps (using strtoul instead of atoi which can't
actually fail and just returns 0, if I remember correctly.)

(sorry about the navel-gazing over coverity here, s3kuret3h folks have
prioritized some "findings" and sometimes it's easier to tidy up
small issues like this than to argue. Thanks for the reviews!)

Thanks,
-Eric

> --D
> 
>>  {
>>  	int fd;
>>  	int error;
>> -- 
>> 2.42.0
>>
>>
> 

