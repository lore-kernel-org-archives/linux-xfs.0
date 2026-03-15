Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF5440DFD6
	for <linux-xfs@vger.kernel.org>; Sun, 15 Mar 2026 08:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773563747; cv=none; b=q8a6Op5fbHwLhyWDub5sCiQerWVItcWK7KK/8Q1nK2P0qkHe2IFAuUOSyZMHy4Bc067uC7umbgDWFupa+VCKIa6RVMuzcRE7u4NeIlH5/WCPx/cYjp9+tGp6+zZbss6XfSr7LCuTz3V6+/GjH1QjHaJouIDjV3viiPqKT39zfGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773563747; c=relaxed/simple;
	bh=NyjxTfqAUtcXyGwXqxjLeX6xAbq+0TLdZM3Pl6qBOYg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PTxud68IKXwmYTQWsWnlmKVvbelLEOrXzhXhA8YIcpbGJlOiB2lLnD3YqkhmvCrYQpgVHWVkyQR2f6evgRXVaQemtPRBaSVibxGfDoSsF1AALskYIzaSQCK7W1R9WXFQzmksqPfZqBTzBaSUasGXl7k4mqfmNbYN1J6NREepSSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=g+zbH61j; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="g+zbH61j"
Message-ID: <ce1eff29-c52d-43a1-96a9-c4be0fafa3d0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773563733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=me0HhcSUhKz7UI3AVCFJtwbN1kNXFf5JmTE1ZTRoK+E=;
	b=g+zbH61je1LZSLaJXhL2TuW/YPmYLzg5VqUPL4lozXbl0fDUCWvp6Bjqepz41GRxHSEhIy
	4qt6Xuj/jz4RCi2o2j58ESeWVkK0AIamMv194KTqw7Mzj3oAWHS3vGW2YjVbwkmO3+iBwN
	XsVM2i62VY4ki/th0Rh3H3w8Dx/oFBg=
Date: Sun, 15 Mar 2026 09:35:19 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] ltp: add support for FALLOC_FL_WRITE_ZEROES to fsx and
 fsstress
To: "Darrick J. Wong" <djwong@kernel.org>,
 Pankaj Raghav <p.raghav@samsung.com>
Cc: zlang@redhat.com, fstests@vger.kernel.org, lukas@herbolt.com,
 dgc@kernel.org, linux-xfs@vger.kernel.org
References: <20260312195308.738189-1-p.raghav@samsung.com>
 <20260313235259.GH6023@frogsfrogsfrogs>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <20260313235259.GH6023@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 3/14/2026 12:52 AM, Darrick J. Wong wrote:
> On Thu, Mar 12, 2026 at 08:53:08PM +0100, Pankaj Raghav wrote:
>> Add FALLOC_FL_WRITE_ZEROES support to both fsx and fsstress.
>> FALLOC_FL_WRITE_ZEROES flag was added in the kernel as a part of Zhang
>> Yi's series [1].
>>
>> FALLOC_FL_KEEP_SIZE is not supported when FALLOC_FL_WRITE_ZEROES is
>> used.
>>
>> [1] https://lore.kernel.org/linux-fsdevel/20250619111806.3546162-1-yi.zhang@huaweicloud.com/
>>
>> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> 
> Looks like a clone of the ZERO_RANGE code so I think this is ready for
> wider testing...

Yeah. Except the FALLOC_FL_KEEP_SIZE part, it is exactly like ZERO_RANGE.

> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> --D
> 
