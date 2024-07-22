Received: from sandeen.net (sandeen.net [63.231.237.45])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D8BA1EB56
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jul 2024 15:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.231.237.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721661142; cv=none; b=tXzIlipCZCh+5jcNDqZYoxXO11/4bHZouWRvINUwHJp9MrYFI7ugZnbpk9Du3yRLkE6ZLYL/tHJv15reSDkZt05EcjXDQTL2jzRCQSJFLwbHjyPXcc+PZhcuQ4virqCvtkBKonNl60R+574LfXIccTl8mitzgLIwW/wYWs7//6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721661142; c=relaxed/simple;
	bh=+k2KEoCipQ9RpSL3bPAs6tbDijn4F6kCqXFHLNvcJbU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=omRNFFMapDVfa9fz2eAkek+OsL2UXviP0lFNtvK0ybPgmeqOovPBOiMyDGIY7phglu6kWrBKRR0VvutPtMnyQbx4Cd96wC1wpifJdLtB32qTervMg3vcc2HkmqgUvouNSZS7mJdtAdpWCZhQfyxko/XL1U+4zBhBwOmAvh2pJVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=xFPzwNuQ; arc=none smtp.client-ip=63.231.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="xFPzwNuQ"
Received: from [10.0.0.71] (usg [10.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 7F59C5CC112;
	Mon, 22 Jul 2024 10:05:04 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net 7F59C5CC112
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
	s=default; t=1721660704;
	bh=cfcrmzC7yB2/O6hTR6nyPhMhWCLpCzahftqGMqPpV2g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=xFPzwNuQrsJsTuTFmFOb85EBpQOehyLHISUHvfkU/eN4kMbpM/2EFUO9hV+DKsm96
	 6w04Ru+S8PyO4Knzv+aa1svHWy2gnac9yCwBzKYTegktJnLqjJkWbGy+2TqxHhaAjm
	 l1U4v9v06Xw6osgqWPX0EZ+sVanTxtrbm13YkkuiQOGqk4cT7VWbtOqHHkf2Nr8z6x
	 bY4Yw+4cI/IrSnEmT3mPBXm+hiR542vrxuxHvdUnQeChASTV+SONYJH2n9oi6g2XuN
	 nMykOyB3k/WAoAzwq6N2vm9zVq0Pp1dG1ds8KmI6weAw9Gxmb9Ow/hmle9IJvo1vyF
	 VyCTsWM2RxvTA==
Message-ID: <da41c7f5-8542-4b8e-9e98-2c33a74ca1a9@sandeen.net>
Date: Mon, 22 Jul 2024 10:05:03 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: allow SECURE namespace xattrs to use reserved pool
To: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <fa801180-0229-4ea7-b8eb-eb162935d348@redhat.com>
 <Zp5vq86RtodlF-d1@infradead.org>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <Zp5vq86RtodlF-d1@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/22/24 9:41 AM, Christoph Hellwig wrote:
> On Fri, Jul 19, 2024 at 05:48:53PM -0500, Eric Sandeen wrote:
>>  	xfs_attr_sethash(args);
>>  
>> -	return xfs_attr_set(args, op, args->attr_filter & XFS_ATTR_ROOT);
>> +	rsvd = args->attr_filter & (XFS_ATTR_ROOT | XFS_ATTR_SECURE);
>> +	return xfs_attr_set(args, op, rsvd);
> 
> This looks fine, although I'd probably do without the extra local
> variable.  More importantly though, please write a comment documenting
> why we are dipping into the reserved pool here.  We should have had that
> since the beginning, but this is a better time than never.
> 
> 

Ok, I thought the local var was a little prettier but *shrug* can do it
either way.

To be honest I'm not sure why it was done for ROOT; dchinnner mentioned
something about DMAPI requirements, long ago...

It seems reasonable, and it's been there forever but also not obviously
required, AFAICT.

What would your explanation be? ;) 

Thanks,
-Eric
