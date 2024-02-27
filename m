Received: from esa3.hc1455-7.c3s2.iphmx.com (esa3.hc1455-7.c3s2.iphmx.com [207.54.90.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A457BAE7
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 09:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.54.90.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709027521; cv=none; b=gmBna3CFCaSfgwOjA+p5UTLcrhQhlXPM+fUZUeonGK+snMEL8wBY4tOlLJoDFJUfwWTivL2uA5VD00tM3vaLTAVvjItzm9RoqSvMjhmIdMifmEQPu1rnvDAtq2ckQ+Of9kU83KmbVa6Y6Gk8NmLFRpWrflx1JhlskUDY3/S7xQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709027521; c=relaxed/simple;
	bh=SMp8UFsNCc3/5RyXDnNJdwhjJJY0E33Z+x2ayDxXCkE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DK18cfRPNVMa2QgE37SwDgBuV/pPAuyI7RI2MWdns1Kb0yYzQEmCyjKQwG1EEHjg5JVUp517l4oPv+tjqBfwGv2Gh2vC4rLxUtJe35jZkmUILY9GdwGyuf88Z/WWxT2b8dmLpX4xDz27TO3O6DHveDUqj/830/xs3KAJfByl/xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=gC2wEyQ5; arc=none smtp.client-ip=207.54.90.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="gC2wEyQ5"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1709027520; x=1740563520;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SMp8UFsNCc3/5RyXDnNJdwhjJJY0E33Z+x2ayDxXCkE=;
  b=gC2wEyQ5gj6gvVeZVQ0YK+7pqzJYg6SkopYzxmFU/RqAoU3R9mQzgGMj
   lamSmaYCX31tYJTt5ZNci04DJJjAfAZCyzPIO5q0EMrUc+T8WMqVohu9a
   MLm6gkP1Y7W3C8WkI0YWfR5zR8h21nPp9TcQ9rxec8CWjxpvVqQNV8cPS
   8hv68QnT6r2DN7w6TWA76xpATl9iqEyNkiMrJPVtQ94eGDfBkLXtem343
   C0GT1HfHMRLrBTpBXObPIbwcrlA/Kl3mn2VJbo+f0YFdTs2vMAJdeBTIN
   Wi7rCRVLr5JVeeYVpYXijEzAw2Aht+cOr1BKme+Bs4z/lnA6+ovE72rfi
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="150535162"
X-IronPort-AV: E=Sophos;i="6.06,187,1705330800"; 
   d="scan'208";a="150535162"
Received: from unknown (HELO oym-r3.gw.nic.fujitsu.com) ([210.162.30.91])
  by esa3.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 18:50:48 +0900
Received: from oym-m3.gw.nic.fujitsu.com (oym-nat-oym-m3.gw.nic.fujitsu.com [192.168.87.60])
	by oym-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id 41EB712B8DB
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 18:50:45 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by oym-m3.gw.nic.fujitsu.com (Postfix) with ESMTP id 6B246D6238
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 18:50:44 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id EB7C841055
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 18:50:43 +0900 (JST)
Received: from [192.168.50.5] (unknown [10.167.226.114])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id D49461A006A;
	Tue, 27 Feb 2024 17:50:42 +0800 (CST)
Message-ID: <cb205046-d0d6-40cc-8359-60685fe37908@fujitsu.com>
Date: Tue, 27 Feb 2024 17:50:42 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
To: Dan Williams <dan.j.williams@intel.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Bill O'Donnell <bodonnel@redhat.com>,
 chandan.babu@oracle.com
Cc: linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev
References: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>
 <ZaAeaRJnfERwwaP7@redhat.com> <20240112022110.GP722975@frogsfrogsfrogs>
 <d205949b-27ed-4bf3-bfc1-31b13eed3b9f@fujitsu.com>
 <65dcc327f2e61_2bce929418@dwillia2-mobl3.amr.corp.intel.com.notmuch>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <65dcc327f2e61_2bce929418@dwillia2-mobl3.amr.corp.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28216.006
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28216.006
X-TMASE-Result: 10--16.439700-10.000000
X-TMASE-MatchedRID: 6Yvl3or3fgqPvrMjLFD6eCkMR2LAnMRp2q80vLACqaeqvcIF1TcLYANw
	091XoRE6WJBPIRIrBsgJKoJfwgWhzfN4L4izsa/ksDpn40N9M3nDAPSbMWlGt7iZ9kaBJryyQiO
	PAdln32kxRNoNs3rgHx0WpAOlOOYvKCGE/H289cG8coKUcaOOvSu3H/wZaHmbEDnWZT9yUvONRC
	PAFosOlLfVElO3d2YLOPOr7Hp7We8B90FcL1q4MBF4zyLyne+AfS0Ip2eEHnxlgn288nW9IM4WI
	FQPE2cOtwKUvHHyXGXdB/CxWTRRu/558CedkGIvqcoAhihTwvh9aCDfozCbh5OtLG3s5HGR7nsn
	pCqLAbEXmeYh6Ckt4m47Fejfs51J
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0



在 2024/2/27 0:58, Dan Williams 写道:
> Shiyang Ruan wrote:
>>
>>
>> 在 2024/1/12 10:21, Darrick J. Wong 写道:
>>> On Thu, Jan 11, 2024 at 10:59:21AM -0600, Bill O'Donnell wrote:
>>>> On Fri, Sep 15, 2023 at 02:38:54PM +0800, Shiyang Ruan wrote:
>>>>> FSDAX and reflink can work together now, let's drop this warning.
>>>>>
>>>>> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
>>>>
>>>> Are there any updates on this?
>>>    
>>> Remind us to slip this in for 6.8-rc7 if nobody complains about the new
>>> dax functionality. :)
>>
>> Hi,
>>
>> I have been running tests on weekly -rc release, and so far the fsdax
>> functionality looks good.  So, I'd like to send this remind since the
>> -rc7 is not far away.  Please let me know if you have any concerns.
> 
> Ruan, thanks for all your effort on this!

It's my pleasure.  Thank you all also for your patience and kind 
guidance. You all helped me a lot.  ヽ(^▽^)ノ


--
Ruan.

> 
> [..]
> 
>>>>> ---
>>>>>    fs/xfs/xfs_super.c | 1 -
>>>>>    1 file changed, 1 deletion(-)
>>>>>
>>>>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>>>>> index 1f77014c6e1a..faee773fa026 100644
>>>>> --- a/fs/xfs/xfs_super.c
>>>>> +++ b/fs/xfs/xfs_super.c
>>>>> @@ -371,7 +371,6 @@ xfs_setup_dax_always(
>>>>>    		return -EINVAL;
>>>>>    	}
>>>>>    
>>>>> -	xfs_warn(mp, "DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
>>>>>    	return 0;
> 
> Acked-by: Dan Williams <dan.j.williams@intel.com>
