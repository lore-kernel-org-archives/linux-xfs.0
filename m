Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81A560EE4
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2024 20:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706041319; cv=none; b=GxAgPwRsWpot6WjfGNJzIHE+SlOv3QN/pId44GkV6M3Ghi5k6ReWjM2lGBIwxfR7c41ligShxuqc83bWbpT9vGBR+jMtPlP5a0R51uYTYICYdi6Chn/FcwCyJItpihlawKhMkbXrCY6vN1ramMZmrAG8ZD9la9i4UPeUw2fE9xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706041319; c=relaxed/simple;
	bh=a5tgK/aTnnjACVzrqksLemIpLKs4RQtp9MwaMjfUq/k=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:From:In-Reply-To:
	 Content-Type:References; b=hXmg+bxfmAox7VwVhlQJe5N+5zg12Dz1kXW41bI210XZFdPQzpTodkUIPWVvY04v/8t8AxXNae+AO/Ob6BNvzYYoUJ7jrYFIFV3qEAmQ3B37bI2vAOPmsTCf8ZqUsSuhwjIk0cHVyirVtD8qO2fpV3upG8WFw4uYHTONDdb92fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=qFJ1kaZE; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="qFJ1kaZE"
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20240123202153euoutp01bd73ef6a342e2b7c297f6bf9113dd713~tE4kn0i7A0704607046euoutp01K
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2024 20:21:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20240123202153euoutp01bd73ef6a342e2b7c297f6bf9113dd713~tE4kn0i7A0704607046euoutp01K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1706041313;
	bh=MvGh9buHSZ+Gy/tCalbJdHrT0do0dko3fJqcKcXiAYk=;
	h=Date:Subject:To:CC:From:In-Reply-To:References:From;
	b=qFJ1kaZEuNh6ujDjBhiuYvymoXWexnH5KPlThDOx7ih1SiXxIlVGaaFu/IarTLEGL
	 qwNsXdZU49QXnuU74gLliANXkQ/ecThW5bFZMeq1OsZj6WvHoAB83LArlrFsxergNX
	 2RxwdOV69LPooqyiNu3pbwmykGAa1rJlq5DfK14I=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20240123202153eucas1p10ec2137f76207ef331535e657b319059~tE4kB2s4K2335423354eucas1p1q;
	Tue, 23 Jan 2024 20:21:53 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id 29.11.09814.0EF10B56; Tue, 23
	Jan 2024 20:21:52 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20240123202152eucas1p1f1b0521a757583e3d7e772a3e4e27563~tE4jUIj3A2334223342eucas1p1n;
	Tue, 23 Jan 2024 20:21:52 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240123202152eusmtrp1327bef1de6a74ba9c5451cd60134fd31~tE4jTlxnY3097530975eusmtrp1f;
	Tue, 23 Jan 2024 20:21:52 +0000 (GMT)
X-AuditID: cbfec7f4-711ff70000002656-ff-65b01fe0405f
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id B7.04.09146.0EF10B56; Tue, 23
	Jan 2024 20:21:52 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240123202151eusmtip2426e7b528a9678e6a4c1bddc19b37b48~tE4jFqQ_M3000330003eusmtip2T;
	Tue, 23 Jan 2024 20:21:51 +0000 (GMT)
Received: from [192.168.8.209] (106.210.248.230) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Tue, 23 Jan 2024 20:21:50 +0000
Message-ID: <d1cd9f19-21ed-430a-b146-906a6b6f0f70@samsung.com>
Date: Tue, 23 Jan 2024 21:21:50 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] fstest changes for LBS
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Dave Chinner
	<david@fromorbit.com>, "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
CC: <zlang@redhat.com>, <fstests@vger.kernel.org>, <djwong@kernel.org>,
	<mcgrof@kernel.org>, <gost.dev@samsung.com>, <linux-xfs@vger.kernel.org>
Content-Language: en-US
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <87frynkfao.fsf@doe.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsWy7djPc7oP5DekGlxqtrTYcuweo8XlJ3wW
	p1v2slucefmZxWLXnx3sFjcmPGW0OHiqg91i78mdrA4cHqcWSXjsnHWX3WPTqk42j7MrHT3e
	77vK5vF5k1wAWxSXTUpqTmZZapG+XQJXxs89C1kLnohVbHuygbmB8b1gFyMnh4SAicS+e4sZ
	uxi5OIQEVjBKHDv4ixXC+cIo8efRNBYI5zOjxINzS4EcDrCWI/0iEPHljBLvOyawwRV96NzP
	BOHsZpRYP+E2K8gSXgE7iaNzdjKC2CwCqhInd65ggogLSpyc+YQFxBYVkJe4f2sGO4gtLKAv
	MXvDIrCpIgK9jBLnjj0BO4pZYBKjxJMvJ8C6mQXEJW49mc8EchObgJZEYydYMyfQgo+te9kg
	SjQlWrf/Zoew5SW2v53DDPGCssTUpV6QAKiVOLXlFtjREgKTOSWO/r7NApFwkVhx7h4zhC0s
	8er4FnYIW0bi9OQeqJpqiac3fjNDNLcwSvTvXM8GscBaou9MDkSNo8Sv/rlQe/kkbrwVhDiH
	T2LStunMExhVZyEFxSwkj81C8sEsJB8sYGRZxSieWlqcm55abJSXWq5XnJhbXJqXrpecn7uJ
	EZiWTv87/mUH4/JXH/UOMTJxMB5ilOBgVhLhvSG5LlWINyWxsiq1KD++qDQntfgQozQHi5I4
	r2qKfKqQQHpiSWp2ampBahFMlomDU6qBafv1FzMWKWh9fPDuzo7Nab6ve2zEukrLdafJCf2J
	r+5YELios7dx1kqWFVOsd+0/ojA7p8XuTv/fO9FKvpq3TWP/N4klLktQuHh+Vnef2ULlGZU1
	Lxe7akrVL1j5YOFRsTUsnZEfFzjyHvxm8e+37T2GnK7NBtFSHwPrNLZ3NqwKb+1gCw2avSkn
	oq39vz2DyV3pEN1EX88zDTcK1x3wNHHLMf6w4tDfFL55PD+ORPb+vtczIXUz3za+ayWTyyui
	Z8wQrwv8s4hnT9DVV+kC0yeJzgp/pnFD0felOG99Wbpb9g9Phlin61LVj+W3hXwT7t57uWb9
	oTWHnu04PM9dzthB7lC+U/HSaasKwndNV2Ipzkg01GIuKk4EAF6UF8S6AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t/xe7oP5DekGmzaw2ax5dg9RovLT/gs
	TrfsZbc48/Izi8WuPzvYLW5MeMpocfBUB7vF3pM7WR04PE4tkvDYOesuu8emVZ1sHmdXOnq8
	33eVzePzJrkAtig9m6L80pJUhYz84hJbpWhDCyM9Q0sLPSMTSz1DY/NYKyNTJX07m5TUnMyy
	1CJ9uwS9jJ97FrIWPBGr2PZkA3MD43vBLkYODgkBE4kj/SJdjJwcQgJLGSUWtViB2BICMhIb
	v1xlhbCFJf5c62LrYuQCqvnIKPGpfy4ThLObUWJd5ylmkCpeATuJo3N2MoLYLAKqEid3rmCC
	iAtKnJz5hAXEFhWQl7h/awY7iC0soC8xe8MisKkiAr2MEueOPWEFcZgFJjFKPPlyggnipgqJ
	H68mgHUzC4hL3HoynwnkbDYBLYnGTrBBnEDLPrbuZYMo0ZRo3f6bHcKWl9j+dg4zxJfKElOX
	ekF8Uyvx+e8zxgmMorOQnDcLyYJZSCbNQjJpASPLKkaR1NLi3PTcYkO94sTc4tK8dL3k/NxN
	jMBI3nbs5+YdjPNefdQ7xMjEwXiIUYKDWUmE94bkulQh3pTEyqrUovz4otKc1OJDjKbAMJrI
	LCWanA9MJXkl8YZmBqaGJmaWBqaWZsZK4ryeBR2JQgLpiSWp2ampBalFMH1MHJxSDUxB976z
	blLf4CypKdv9rc7f6vXV3kO5+0tXRt26/6dpitWNS2aX1vyOutcfMOXux3DVN9JP17HE31aZ
	9bKo5k950P9NR81WfAo0tb89Z8KbiZ28k5/U+oVwNSz5yfQmYosXr6KJgWuDwfSsC8FlN6on
	bCzRrhPe6Rh87SIzK88aXnO+dybTJX1WrtDXMDqjfHXOBdsTLnXtJSxbX7O+XG7U8OPJb/7T
	+ROK9gWe1mzlnL+KaT+Tws+prbfWW6ts3Dx1WkTG5Bm8FbWzXy6bImnLpXHyXcj+Hx/Fma5v
	Zfg+5aKt/IRU31PppiXz1zjsXM9x7g9r5pV9AianFi2vZzzhuilX/Ublppyld9ifZh2uVmIp
	zkg01GIuKk4EAIDnYpNtAwAA
X-CMS-MailID: 20240123202152eucas1p1f1b0521a757583e3d7e772a3e4e27563
X-Msg-Generator: CA
X-RootMTR: 20240123194216eucas1p25b7ad483f93cde66bcfefd22b4a830ab
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240123194216eucas1p25b7ad483f93cde66bcfefd22b4a830ab
References: <CGME20240123194216eucas1p25b7ad483f93cde66bcfefd22b4a830ab@eucas1p2.samsung.com>
	<87frynkfao.fsf@doe.com>

On 23/01/2024 20:42, Ritesh Harjani (IBM) wrote:
> Pankaj Raghav <p.raghav@samsung.com> writes:
> 
>>>> CCing Ritesh as I saw him post a patch to fix a testcase for 64k block size.
>>>
>>> Hi Pankaj,
>>>
>>> So I tested this on Linux 6.6 on Power8 qemu (which I had it handy).
>>> xfs/558 passed with both 64k blocksize & with 4k blocksize on a 64k
>>> pagesize system.
> 
> Ok, so it looks like the testcase xfs/558 is failing on linux-next with
> 64k blocksize but passing with 4k blocksize.
> It thought it was passing on my previous linux 6.6 release, but I guess
> those too were just some lucky runs. Here is the report -
> 
> linux-next: xfs/558 aggregate results across 11 runs: pass=2 (18.2%), fail=9 (81.8%)
> v6.6: xfs/558 aggregate results across 11 runs: pass=5 (45.5%), fail=6 (54.5%)
> 

Oh, thanks for reporting back!

I can confirm that it happens 100% of time with my LBS patch enabled for 64k bs.

Let's see what Zorro reports back on a real 64k hardware.

> So I guess, I will spend sometime analyzing why the failure.
> 

Could you try the patch I sent for xfs/558 and see if it works all the time?

The issue is 'xfs_wb*iomap_invalid' not getting triggered when we have larger
bs. I basically increased the blksz in the test based on the underlying bs.
Maybe there is a better solution than what I proposed, but it fixes the test.


> Failure log
> ================
> xfs/558 36s ... - output mismatch (see /root/xfstests-dev/results//xfs_64k_iomap/xfs/558.out.bad)
>     --- tests/xfs/558.out       2023-06-29 12:06:13.824276289 +0000
>     +++ /root/xfstests-dev/results//xfs_64k_iomap/xfs/558.out.bad       2024-01-23 18:54:56.613116520 +0000
>     @@ -1,2 +1,3 @@
>      QA output created by 558
>     +Expected to hear about writeback iomap invalidations?
>      Silence is golden
>     ...
>     (Run 'diff -u /root/xfstests-dev/tests/xfs/558.out /root/xfstests-dev/results//xfs_64k_iomap/xfs/558.out.bad'  to see the entire diff)
> 
> HINT: You _MAY_ be missing kernel fix:
>       5c665e5b5af6 xfs: remove xfs_map_cow
> 
> -ritesh
> 
>>
>> Thanks for testing it out. I will investigate this further, and see why
>> I have this failure in LBS for 64k and not for 32k and 16k block sizes.
>>
>> As this test also expects some invalidation during the page cache writeback,
>> this might an issue just with LBS and not for 64k page size machines.
>>
>> Probably I will also spend some time to set up a Power8 qemu to test these failures.
>>
>>> However, since on this system the quota was v4.05, it does not support
>>> bigtime feature hence could not run xfs/161. 
>>>
>>> xfs/161       [not run] quota: bigtime support not detected
>>> xfs/558 7s ...  21s
>>>
>>> I will collect this info on a different system with latest kernel and
>>> will update for xfs/161 too.
>>>
>>
>> Sounds good! Thanks!
>>
>>> -ritesh
