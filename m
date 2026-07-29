Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867A033F5A9;
	Wed, 29 Jul 2026 07:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785310599; cv=none; b=dLd0uwg6DPOt2tmzanbiaqkA+mKxspFcma2BuxeH5Gc3wr0C2kbg4TD2in0XK1cK+jrcksSbhbh7gcSHzSubPSpYWAXjsWhuGtmBHhKgswe9TS3ysqvOGiSsQPrXErAtf2qUWuAZ8Rxrxl9Jf7u9gIRm4hZtzkmdgF883sYBzrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785310599; c=relaxed/simple;
	bh=RD5gl7hueEfRL2bHqX6xb4Cd6OE/w6ZsB07th9o/JMs=;
	h=Message-ID:Date:From:MIME-Version:To:CC:Subject:References:
	 In-Reply-To:Content-Type; b=JVgF1H3FaH7OAk1nJcIcqaSRCn9gowePl+RijYiCNBrUtUCC9NEM2J/+Mh06GhZ0zp7VBYb19rN5L8J09u0HU7chFLDG4oXfIL1i7GYCSK1T6HJWrjpf9Q51xf+gsUqVhdWr3OU1tWmaYpM9hVDoZmIhi/Fw9eZ04VluSWrCxow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=HMOLoQgi; arc=none smtp.client-ip=117.135.210.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="HMOLoQgi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Message-ID:Date:From:MIME-Version:To:Subject:
	Content-Type; bh=SX4TffwXdWikfk0KA+x+XZQZEwGbbNV4KU+eu59mMG8=;
	b=HMOLoQgimDCqyjnyDAk1HVUKM7KH5sd5bmFUZdji08kd1ZBvuUYCJhVE9p8V8E
	GWfT//dmxvefVQy7Jl/uKU5/3LqrQ/ZuA6AhOedjwDKe1KjZCx+EPLHDIzwbpQPf
	GHznymye2azERQyBdKIUpIJDddWoBqR35j31lmLrez4Rc=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wA3rC5IrWlqMI_mEA--.27818S2;
	Wed, 29 Jul 2026 15:35:37 +0800 (CST)
Message-ID: <6A69AD36.1070702@126.com>
Date: Wed, 29 Jul 2026 15:35:18 +0800
From: Hongling Zeng <zhongling0719@126.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, 
 Hongling Zeng <zenghongling@kylinos.cn>
CC: cem@kernel.org, djwong@kernel.org, hans.holmberg@wdc.com, 
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
Subject: Re: [PATCH] xfs: check split_sectors validity before bio_split call
References: <20260729063117.54540-1-zenghongling@kylinos.cn> <ammjJTqoOHsW9AXJ@infradead.org>
In-Reply-To: <ammjJTqoOHsW9AXJ@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wA3rC5IrWlqMI_mEA--.27818S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7GF4kCF47XF1rurWUZr1UKFg_yoWDXrc_Wr
	4S93yvvwn7uanYyrWqga4DAr9rWFW8GFyxZa13ta1Sga4DJFsrXrs5ur9xZryUArZ2grnx
	Krn8Z3yag347ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0HrWUUUUUU==
X-CM-SenderInfo: x2kr0wpolqwiqxrzqiyswou0bp/xtbBrwlyQ2pprUlwfgAA3+


在 2026年07月29日 14:52, Christoph Hellwig 写道:
> On Wed, Jul 29, 2026 at 02:31:17PM +0800, Hongling Zeng wrote:
>> Fix by changing the check from !split_sectors to split_sectors <= 0
>> immediately after bio_split_rw_at() and before any arithmetic operations.
>> This prevents both the negative error code propagation and the undefined
>> behavior from left-shifting negative values.
>>
>> When NULL is returned, the caller's while loop naturally terminates,
>> which is the correct behavior for "cannot split" cases.
>>
>> Fixes: 080d01c41d44f ("xfs: implement zoned garbage collection")
>> Cc: <stable@vger.kernel.org>
> Nothing can actually hit that.  It only happens for invalid flags,
> or unaligned I/O, none of which can happen for GC I/O.
>
> I think checking all cases of the return value is fine, but the fixes
> is a bit bogus, and it really is not stable material.
  Thanks for the review. Updated v2 below - removed Fixes/stable
   tags and reworded as code improvement.

