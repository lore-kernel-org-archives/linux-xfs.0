Received: from esa10.hc1455-7.c3s2.iphmx.com (esa10.hc1455-7.c3s2.iphmx.com [139.138.36.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4FE1427F
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 07:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.36.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708673374; cv=none; b=tWKiVEa+VGmGefaRQKRlUUh98FVnTvg7dsPanDuBh5tiSKzLePgk+wfXiI/BNqHZQM/+eDt1khZpuzWbp+Ti9KjwVlgsTP7qfLBQCJAdSeQmosvaAVW6w4TcUoevO3Bl4mfmT8WxON0b8ZfUff+kJp14w+ccYk1pzMM6Oo50cH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708673374; c=relaxed/simple;
	bh=Am7latsxUZsf2ZaVe94u42IlLWXHZ9jFcBzyGL9c47U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n9dapHA7UEjwtS8qQvdKM5V8MQOsLIAGfShvsIBrYgICGlFuMBgemin+xsURBnOCGf70J9PKndLMua+itGUgprDtCN/+qiLpe3y83EbBTH1jjHsSrn/na8Ol4XNzMYUKHmsjz6fqw13O7I7K8589A3J5TN5Bb9VQBJ07kbT6Ymc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=SL7NpzXD; arc=none smtp.client-ip=139.138.36.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="SL7NpzXD"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1708673371; x=1740209371;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Am7latsxUZsf2ZaVe94u42IlLWXHZ9jFcBzyGL9c47U=;
  b=SL7NpzXD94G7ZxwHLZ6wCQMahgPb4ChdS8afRAYcFOeoquHww693ES+Z
   S0pna9shvevlK/Ct49i2mMrDOle6PMbImv1T450N6u10qbKCG0NEfXFkR
   dCAOHuUiV6ieYIN7ZJFBVAYnDdCWH4I6enU9WYToD5qemTIBXRqHw0Hh4
   jm4qMbuUADeM/KGC1i6vgJVIzQoiYKZa4Z/WNiJ+x52jzTqcw7gOfK2TB
   7E1JvxdUO1iUsETL7hUDICrTYT7/c5hudPCRv3bYgsU/OT5UhvPBL9woc
   tNbvKx2iA0RSrB+ZaOXGp2X3HBcVJV3VGDxXItEq6Bwas0FmnVtKQrXgJ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10992"; a="137842689"
X-IronPort-AV: E=Sophos;i="6.06,179,1705330800"; 
   d="scan'208";a="137842689"
Received: from unknown (HELO oym-r3.gw.nic.fujitsu.com) ([210.162.30.91])
  by esa10.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2024 16:28:18 +0900
Received: from oym-m1.gw.nic.fujitsu.com (oym-nat-oym-m1.gw.nic.fujitsu.com [192.168.87.58])
	by oym-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id 1E318D63C8
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 16:28:17 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by oym-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id 4FF69D4F50
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 16:28:16 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id DDCAC23E1AA
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 16:28:15 +0900 (JST)
Received: from [10.193.128.195] (unknown [10.193.128.195])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id EB9F11A006B;
	Fri, 23 Feb 2024 15:28:14 +0800 (CST)
Message-ID: <d205949b-27ed-4bf3-bfc1-31b13eed3b9f@fujitsu.com>
Date: Fri, 23 Feb 2024 15:28:14 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
To: "Darrick J. Wong" <djwong@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, chandan.babu@oracle.com
Cc: linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
 dan.j.williams@intel.com
References: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>
 <ZaAeaRJnfERwwaP7@redhat.com> <20240112022110.GP722975@frogsfrogsfrogs>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <20240112022110.GP722975@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28208.005
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28208.005
X-TMASE-Result: 10--13.893700-10.000000
X-TMASE-MatchedRID: qeYWT+AUEkGPvrMjLFD6eHchRkqzj/bEC/ExpXrHizxO5pvXajphX7Bk
	jjdoOP1bIx/OqCk5J10fnhC5GP+KBUvuFx00jSkB/1dEgwtQ6NBF5qVUCGhwT282zvsXichajFK
	/NcS7G4nZyfBL0WvJFyS5HVjZaILduBKKB37nRtovz6alF1rVg1HB9PagRph0twi3bXRtaAi/BR
	68O365bn9eOltIlLtr4yf6Jl3/aOS1n6qzMwyUl54CIKY/Hg3AnCGS1WQEGtB4UhBPLRlvhvsf6
	FkrLr8rC24oEZ6SpSkgbhiVsIMQK2u5XqFPzjITWLAmmsEiLinLOUVTa9BVk4bikWtNUsVHwrIt
	a7cE3NVXm3en/dzILH7cGd19dSFd
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0



在 2024/1/12 10:21, Darrick J. Wong 写道:
> On Thu, Jan 11, 2024 at 10:59:21AM -0600, Bill O'Donnell wrote:
>> On Fri, Sep 15, 2023 at 02:38:54PM +0800, Shiyang Ruan wrote:
>>> FSDAX and reflink can work together now, let's drop this warning.
>>>
>>> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
>>
>> Are there any updates on this?
>   
> Remind us to slip this in for 6.8-rc7 if nobody complains about the new
> dax functionality. :)

Hi,

I have been running tests on weekly -rc release, and so far the fsdax 
functionality looks good.  So, I'd like to send this remind since the 
-rc7 is not far away.  Please let me know if you have any concerns.


--
Thanks,
Ruan.

> 
> --D
> 
>> Thanks-
>> Bill
>>
>>
>>> ---
>>>   fs/xfs/xfs_super.c | 1 -
>>>   1 file changed, 1 deletion(-)
>>>
>>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>>> index 1f77014c6e1a..faee773fa026 100644
>>> --- a/fs/xfs/xfs_super.c
>>> +++ b/fs/xfs/xfs_super.c
>>> @@ -371,7 +371,6 @@ xfs_setup_dax_always(
>>>   		return -EINVAL;
>>>   	}
>>>   
>>> -	xfs_warn(mp, "DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
>>>   	return 0;
>>>   
>>>   disable_dax:
>>> -- 
>>> 2.42.0
>>>
>>
>>
> 
