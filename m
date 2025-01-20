Received: from vps01.wiesinger.com (vps01.wiesinger.com [46.36.37.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4111E383
	for <linux-xfs@vger.kernel.org>; Mon, 20 Jan 2025 06:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.36.37.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737354036; cv=none; b=eEmo4SIRy881W3yzdJI40NJECtWVOhW4n6WaCdNM9v35iCJaG80wlnoxfeCwO7jAu2Q5XgWs3UjdjmIZjAE2LMwBuuPzjjPgzFGBvsNZhD1f/OWamJmb+KpoCEQmwpfzVuR4WA6CoFwdu84rV6DqSuQ1PAoABihQQDmDvApICL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737354036; c=relaxed/simple;
	bh=4p8cN3XYr2XpFRcOMZhQlHAJsO206VrZg24dVWgqi6k=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=B0BawXDN2FMPREc7ZPEfUta1eOmXxP5iG8CZrcqBFAUQEGF6qWy89VXJTHyhLbwJMHCDUOKpths+Ddh+g6M+pFRWzWlB4kpAd3IUUWeY/Qgu5NZfkuYz8t6csorWGDVbKpcB0H0+I31VTw0zKqaZtrQtVj2StDYzD/kvtW6ml+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wiesinger.com; spf=pass smtp.mailfrom=wiesinger.com; dkim=pass (4096-bit key) header.d=wiesinger.com header.i=@wiesinger.com header.b=bPwG9Ts7; arc=none smtp.client-ip=46.36.37.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wiesinger.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wiesinger.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=wiesinger.com header.i=@wiesinger.com header.b="bPwG9Ts7"
Received: from wiesinger.com (wiesinger.com [84.112.177.114])
	by vps01.wiesinger.com (Postfix) with ESMTPS id BDB639F1C9;
	Mon, 20 Jan 2025 07:20:31 +0100 (CET)
Received: from [192.168.0.63] ([192.168.0.63])
	(authenticated bits=0)
	by wiesinger.com (8.18.1/8.18.1) with ESMTPSA id 50K6KVoR781272
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 20 Jan 2025 07:20:31 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 wiesinger.com 50K6KVoR781272
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wiesinger.com;
	s=default; t=1737354031;
	bh=lTqiLQjvvP00e7Gr6tGuPyg1sUHF409Wx4pKPTJGoyo=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=bPwG9Ts7jKKsMhqL42OQIqvJI6FFy3t0IsJIUGHjwp4NTEMKBE61whOQ8XOh4oR0F
	 4ziNUuPchAxS7e/4Ur1dMJjZSdyM340qGc34YyuoZS9MVxD4E3YMuuDmwcPWBogenL
	 lq6O/5x95iQf6TzEMtw9qX3S1WPzeUTgBFzswo2+zBCETTzboHyOwWGMkfdvQ2MVVp
	 ShJLotkAhjf/75FdGSLXk+3fE5zTCvLckPxvaXrDfkGFTPt9u5KwqSuFHYHUrdVYTV
	 5N2aN5bP6JifWuXhT91nQgvu/hAwR00LFcj2VOTAdyYmiKkHi5bFrRZaRT1j7c3/ah
	 6wHK2fCvfGCPQIF8kVGIs3jS5QeBFlqsnAMzeONwOh1AydJJ7Bo5IFtsaIahEXLW2u
	 FEHkMySmvCUhojRVfNFr6sUOCimt6k8PZ3IqHCHvvgIwMdCKMc1JPXHIRbwtt+tbST
	 rdh0enl/CTq4s/N67Gi99lAqkkSz12w92U3ZSsBtEhF1YXMoM69ZXyHJpz4bCJ0PKT
	 HZhshzeGnvaSbnzno1K0nHS60tV6qO1oK5XZkQoGDPesbZqiQ0lPOm/Zk7W+X8/fwy
	 8ujd2a44qHndgcc058XTjMEWUi0hxDuEkfZo5gCXvIP2J5qPygCqg0LUSr3JGg4zU7
	 ytuf+wFOoAgTqaYZmb9bC85Y=
Message-ID: <e0ff2e85-a63f-45a9-a853-6b8e892a80d1@wiesinger.com>
Date: Mon, 20 Jan 2025 07:20:30 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: Transparent compression with XFS - especially with zstd
Content-Language: en-US
To: "Carlos E. R." <robin.listas@telefonica.net>,
        Linux-XFS mailing list <linux-xfs@vger.kernel.org>
References: <65266e1f-3f0c-44de-9dd3-565cb75ae54a@wiesinger.com>
 <0dc323c4-4ab0-4aaf-b3dd-37a9e581b395@telefonica.net>
From: Gerhard Wiesinger <lists@wiesinger.com>
In-Reply-To: <0dc323c4-4ab0-4aaf-b3dd-37a9e581b395@telefonica.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 19.01.2025 22:07, Carlos E. R. wrote:
> On 2025-01-19 13:16, Gerhard Wiesinger wrote:
>> Hello,
>>
>> Are there any plans to include transparent compression with XFS 
>> (especially with zstd)?
>
> I am also curious about this, seeing that btrfs has compression.
>
Hello Carlos,

Unfortunately, BTRFS is to my expererience not stable and some very 
lightly inconsistences (e.g. hardware, software failures) can lead to my 
experience to a "forever" corrupt filesystems and a non repareable 
filesystem. Also devs on the BTRFS mailinglist couldn't help. You can 
run filesystem repair tools "forever" without any success.

Also BTRFS doesn't compress in some scenarios and is therefore not 
useable. No solution to this architectural flaw/bug can be offered from 
the BTRFS devs. See here for details: 
https://lore.kernel.org/all/b7995589-35a4-4595-baea-1dcdf1011d68@wiesinger.com/T/

Therefore BRFS is unfortunately not an option to choose from.

Tried also bcachefs but it is not ready for production use and is still 
experimental.

ZFS is so far ok, but it requires special kernel and ZFS version 
requirements and is not a general purpose solution.

Due to the lack of a compressing stable filesystem which is included in 
the standard kernel I'm asking to include compression into a stable 
filesystem like XFS.

Thnx.

Ciao,

Gerhard

