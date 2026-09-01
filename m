Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB8238236F;
	Tue,  1 Sep 2026 22:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788302398; cv=none; b=ZYxDfA3P5b4wZqNtUYRpwExeeAqbiSmIGfxpWIUYS8PJ5nVmxM38udzE1BXbRrdMfwLTRdUckWZfQlL5PFwPC1ZzrwWFXRG2Dn30zfYdYUy+QWGxatJvIHgY0d7nmHRNUZK3wxlD2VxPSOWZNYcBoJDsbAWzQj6VKUjCbcYZoN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788302398; c=relaxed/simple;
	bh=fq2RXiC4ns56jpfGo/RxeoERmywaFkc1PATDXONp4PQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=pVCuS4Sbaistd58c27cDpMkaUXk8cVh9458XBc2FJ+1jQ05AXXhzt7vKMMR0JG+Ys+AaqyndjCAy1dyMXjo8Wh0woj+jXhavfyVQJc0Zo8KPLQSAWlEQEjEQ3Gl+80dESBjiqa1H0nlqgcz1oTRUg0hoB6WRicHZxSRMjOznWs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KxmKD2Js; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KxmKD2Js"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00EC1F000E9;
	Tue,  1 Sep 2026 22:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788302393;
	bh=Y3GyRQmkNcYKTCnekW4yN3hnOUmTS5cdA7r1xqXY2rI=;
	h=Date:Subject:To:References:Cc:From:In-Reply-To;
	b=KxmKD2Js69YRZhBqZss88pSHzX8mF3Zs5PDYIT06m2QTQIpgC9JPfxSYoLf/bGmWp
	 wRv9n1GL+wPf9L+lJ7Ipy+kZv6vdNYaEenr3uiERL6BSmBh3eRPB4psunwmEfIp420
	 gozI7GqV9KqdHuUaFeAWOzgNCcX3i887v5XFjfZ8X/p1ed81vY/yUtq8ed3Te53RDw
	 EGJXiLOE46vIpd10IPkFmm1hdY6OIqMW6fC1e+P8T+azC1DrYaGxKechrxXYa6I7ZH
	 L501wuggBwq5pgj+SuUUQp3iX/Sn/CvNSuNg6uotHCIun4tiTspGI/n5kPMEQEEtMo
	 YsraSJQWGldhw==
Message-ID: <ab106ce4-d8ce-4667-a73e-58a93504bea1@kernel.org>
Date: Wed, 2 Sep 2026 06:39:49 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 04/13] fstests: add _require_fanotify_function
To: Zorro Lang <zlang@kernel.org>
References: <cover.1784949154.git.asj@kernel.org>
 <d8fb7f5c0d67cf01249e8fc4807e963cc1a353d0.1784949155.git.asj@kernel.org>
 <apbxt_WcZOYfmfd9@zlang-mailbox>
Content-Language: en-US
Cc: fstests@vger.kernel.org, djwong@kernel.org, linux-btrfs@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <apbxt_WcZOYfmfd9@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/9/26 23:42, Zorro Lang wrote:
> On Sat, Jul 25, 2026 at 03:39:01PM +0800, Anand Jain wrote:
>> fanotify support may not be compiled into the kernel. Add
>> _require_fanotify_function to skip tests when fanotify is disabled.
>>
>> Signed-off-by: Anand Jain <asj@kernel.org>
>> ---
>>  common/rc | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/common/rc b/common/rc
>> index 53e5d9d43af6..21b516accdf7 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -6329,6 +6329,13 @@ _require_max_file_range_blocks()
>>  	esac
>>  }
>>  
>> +_require_fanotify_function()
>> +{
>> +        if $FSNOTIFYWAIT_PROG 2>&1 | grep -q "Function not implemented"; then
>> +                _notrun "Need CONFIG_FANOTIFY and CONFIG_FANOTIFY_ACCESS_PERMISSIONS to be enabled"
>> +        fi
> 
> What happens if $FSNOTIFYWAIT_PROG fails with an error other than
> 'Function not implemented'?

The known failure conditions, the availability of the fsnotifywait
userspace tool and the kernel configuration are checked.

For any other errors, the test case (generic/801) will fail
during monitor setup and log the error to stdout for debugging.

Thanks, Anand

> Thanks,
> Zorro
> 
>> +}
>> +
>>  _require_fanotify_ioerrors()
>>  {
>>  	local x
>> -- 
>> 2.43.0
>>

