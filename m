Received: from sandeen.net (sandeen.net [63.231.237.45])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34BCB433DF
	for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 22:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.231.237.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707777563; cv=none; b=MX1j05MvS2qlZXgR/JBdVD2zg/5Y0zNMulQTwmdKaRngNZD8Zv1FoSBDB13C1l6WewsIgKmVa7x7CmYfPJEVVVhm0oE2maYhqTKlCyZnF1/QW3qMlflcYjpdaoCsX6dj+VtWlXVRTyBnwqebWDJ7Ax0QF9Hpb12r0EJMfde7XSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707777563; c=relaxed/simple;
	bh=x2Zyzfml82YNuuaG7gEkJ/fP6/75CvT8uHnCo+A7QAw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fuukqRL+aNaVY4EkHItAA47vELaQ8dynIPSGNkfg55a0CG4FG1VWulbJ9qj2ODYWOD6KkpNVjjxdX3EiBRQ9zulG0YnhytKQphtZ1bi6ddAxgl+Zsicx4WScW6YAQ5APIjUW1rH6gdcgU6NSxZLw/wSX15Qcn/kusIoEkmj9QdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=h+xmt3bx; arc=none smtp.client-ip=63.231.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="h+xmt3bx"
Received: from [10.0.0.71] (usg [10.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 9BBC222E2;
	Mon, 12 Feb 2024 16:39:13 -0600 (CST)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net 9BBC222E2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
	s=default; t=1707777553;
	bh=vfrAeGh/XOrY04U6j+BJQAGFQwse+ARGVuzQw7b3Q2I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=h+xmt3bxyq4lRgoFsQh/og1PasW0ZcbE7di8wieaOokSulEDhpdVF26xhQJ1AFs2x
	 YX7htu88RYb6dTYRpkgGbQkmCxgOBw+tuie+AOZy1E67g00tFBHvLZAPk+M+CzpDdd
	 v6LaMG9mQnpnWbx7xqEdXwvJLxLFOEQruSmfocHZUmNEuZ2/q41galHp6JkoB+z02f
	 iUlZ1d3mM04bG+RiuO5IsvMzhLyLjLYpAJDRKHxaRMx2xTTujRnMAdROQ6ya40Be2m
	 fbBuo80xuCG+otL4igp3WwXyrCgKP8trCmpxEXtkyEH1ijOoZmSvpcqEaiGN6Ue6Q7
	 y/ZJqNIQLScFQ==
Message-ID: <fd31d2df-0378-4337-8841-7d811a8de1d0@sandeen.net>
Date: Mon, 12 Feb 2024 16:39:12 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: XFS corruption after power surge/outage
Content-Language: en-US
To: Dave Chinner <david@fromorbit.com>, Jorge Garcia <jgarcia@soe.ucsc.edu>
Cc: linux-xfs@vger.kernel.org
References: <CAMz=2cecSLKwOHuVC31wARcjFO50jtGy8bUzYZHeUT09CVNhxw@mail.gmail.com>
 <6ecca473-f23e-4bb6-a3c3-ebef6d08cc7e@sandeen.net>
 <CAMz=2ccSrb9bG3ahRJTpwu2_8-mQDtwRz-YmKjkH+4qoGoURxQ@mail.gmail.com>
 <ZcqITqNBz6pmgiHJ@dread.disaster.area>
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <ZcqITqNBz6pmgiHJ@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/12/24 3:06 PM, Dave Chinner wrote:
> That has the XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR bit set...
> 
>> I wonder if that is because I tried a xfs_repair with a newer version...
> .... which is a result of xfs_repair 6.5.0 crashing mid way through
> repair of the filesystem. Your kernel is too old to recognise the
> NEEDSREPAIR bit. You can clear it with xfs_db like this:
> 
> Run this to get the current field value:
> 
> # xfs_db -c "sb 0" -c "p features_incompat" <dev>
> 
> Then subtract 0x10 from the value returned and run:
> 
> # xfs_db -c "sb 0" -c "write features_incompat <val>" <dev>
> 
> But that won't get you too far - the filesystem is still corrupt and
> inconsistent. By blowing away the log with xfs_repair before
> actually determining if the problem was caused by a RAID array
> issue, you've essentially forced yourself into a filesystem recovery
> situation.

Everything Dave said, yes. Depending on how bad the corruption is, you
*might* be able to do a readonly or readonly/norecovery mount and scrape
some data out.

Ideally the first thing to do would be to make a 1:1 dd image of the
device as a safe backup, but I understand it's 300T ...

-Eric
