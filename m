Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4999939A059
	for <linux-xfs@vger.kernel.org>; Fri, 29 May 2026 18:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780077767; cv=none; b=Wmqv9pffgAyX8H6OBp0BuNpOa/hO8o2Ay32HwoAo2zPDHcvUBBV/Po0tH8jpR+yhtYG3M5+HSYNn5zyuAVJ32KGxyOowdJcMAUgi3Hk/sgoS9GUv5inL+WfD+ZW5P4bed7ROginOqudfo23yD2fFZwTdbmpPfrKQ3w0fsBnwLic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780077767; c=relaxed/simple;
	bh=7BGJSHUkTlbLMFYfTei0GBqz5A5uN+FNKC1uBdi161U=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=HdXYBcbcXWXjvaBy5MeQks2kTUHYBt99fGJZa2FW/QJLNyeN1u7wyT7tSiwhp7I/PcGOuN9eBeVKKgZ6hsV2fLxIdRrY9qtib+VwjZ1U+TnYbgpSVZ00ACEL40kklXkAlfDfF5ikNKiXvV0IvAA0aLpAUvjBD30rwi5Oa/IRsQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 97C7B180F2C1;
	Fri, 29 May 2026 20:02:40 +0200 (CEST)
Received: from mail.herbolt.com ([172.168.31.10])
	by mx0.herbolt.com with ESMTPSA
	id rZSHJMDUGWoEAz0AKEJqOA
	(envelope-from <lukas@herbolt.com>); Fri, 29 May 2026 20:02:40 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 29 May 2026 20:02:40 +0200
From: Lukas Herbolt <lukas@herbolt.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: sandeen@sandeen.net, aalbersh@kernel.org, dgc@kernel.org,
 linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/5] xfsprogs: mkfs.xfs Add buildtime default
 cli_params as global variable
In-Reply-To: <20260528045059.GC6078@frogsfrogsfrogs>
References: <20260525075752.4159504-1-lukas@herbolt.com>
 <20260525075752.4159504-2-lukas@herbolt.com>
 <20260528045059.GC6078@frogsfrogsfrogs>
Message-ID: <3e25162c841b6c169da7580c7eb07b8e@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

On 2026-05-28 06:50, Darrick J. Wong wrote:
> On Mon, May 25, 2026 at 09:57:48AM +0200, Lukas Herbolt wrote:
>> This patch unites the settings of cli_params and mkfs_default_params
>> into one global variable and then it copies its value into cli.
>> The behavior should remain unchanged. It is preparation for next patch
>> implementing the default config file.
>> 
>> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
>> ---
>>  mkfs/xfs_mkfs.c | 116 
>> +++++++++++++++++++++---------------------------
>>  1 file changed, 50 insertions(+), 66 deletions(-)
>> 
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index dd8a48c3633e..349afe65c9fc 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -1190,17 +1190,44 @@ struct mkfs_params {
>>   * values directly - they are inputs to the mkfs geometry validation 
>> and
>>   * calculations.
>>   */
>> -struct mkfs_default_params {
>> -	char	*source;	/* where the defaults came from */
>> -
>> -	int	sectorsize;
>> -	int	blocksize;
>> -
>> -	/* feature flags that are set */
>> -	struct sb_feat_args	sb_feat;
>> -
>> -	/* root inode characteristics */
>> -	struct fsxattr		fsx;
>> +struct cli_params bld_dft = {
> 
> static const?
> 
> and please spell out "build_default", we are no longer being charged by
> the byte for source code.
> 
Thanks noted!

-- 
-lhe
