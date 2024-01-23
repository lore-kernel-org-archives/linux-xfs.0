Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC6B7F7E3
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2024 16:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706028051; cv=none; b=vE04068Mk+I7NbgOSUqVFXO6igTYNvwnFv8xNsm2RoqFs0IDi7fnX+MOEN0VWwJtXEvDjoENfGVlVZ/Ydjkal3sgj/v87c8TC6PIdrTVCpqohIdzTDnLZym3oy8/og8Q2p8QxXHJGCWQGdsN+qBtsEXrpg2wHYBqj75ds+V1/2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706028051; c=relaxed/simple;
	bh=zEKOZrd79S8mIE6tD5Er8h8lMCDbyemsd3WOfCrC2k4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:From:In-Reply-To:
	 Content-Type:References; b=ofQalnl45KQUQ3UykxhN3Ujs/SchGQ0gSxsSjXDKnT0QpBOJYVSXTiagq6gWkde5SoSWrf/Y7Nb1Ekuyv5LGo/bFvusSjnt8eWMObjefdpT5Mf9iNVjdPjJLlTgBBfMSf1qiN7s/CfwdidDWPB+7KHw4m0R2Vo1G2rTMuV/gd/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=kkptBV8q; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="kkptBV8q"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20240123164047euoutp029fb49cabdde77da21dfb14ec42c8b2fd~tB3hmsste2316523165euoutp02R
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2024 16:40:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20240123164047euoutp029fb49cabdde77da21dfb14ec42c8b2fd~tB3hmsste2316523165euoutp02R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1706028047;
	bh=d+3rmwVGRJ9k7WznkGJM+ZhfWlZzhnkh2hLWmpwqoEQ=;
	h=Date:Subject:To:CC:From:In-Reply-To:References:From;
	b=kkptBV8qvq/b8kr8y5UHKookoHvncjPo166Icf2U4GHXz3exitykN7RscAXBUf6k1
	 jS/jM4PWkFkmW3VQswkRianYeeDigUaFtAEl8D69zXWmsZTzvHZ2uvlSCkvwIUFcN6
	 rT/uFQhRuWYAiUx5dkTdkESaElKLWyWFsX/7df70=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20240123164047eucas1p2fa350075d32790c348a854d1d7062ecd~tB3hSdP4C1243312433eucas1p2u;
	Tue, 23 Jan 2024 16:40:47 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges3new.samsung.com (EUCPMTA) with SMTP id AF.72.09552.F0CEFA56; Tue, 23
	Jan 2024 16:40:47 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240123164046eucas1p297c033627bd506b0bf256e9ebc4639fe~tB3g5FST92500825008eucas1p2u;
	Tue, 23 Jan 2024 16:40:46 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240123164046eusmtrp2c3092dc549020881ec4ec57a5c3bdc0d~tB3g4dVuw1469014690eusmtrp2W;
	Tue, 23 Jan 2024 16:40:46 +0000 (GMT)
X-AuditID: cbfec7f5-853ff70000002550-35-65afec0fad33
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 1A.CE.10702.E0CEFA56; Tue, 23
	Jan 2024 16:40:46 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240123164046eusmtip1fbe8e9570790f99424f59ac815e2d6df~tB3gpk0RR0469404694eusmtip1c;
	Tue, 23 Jan 2024 16:40:46 +0000 (GMT)
Received: from [192.168.8.209] (106.210.248.230) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Tue, 23 Jan 2024 16:40:45 +0000
Message-ID: <803025df-5381-494d-9325-dd0a45312b8b@samsung.com>
Date: Tue, 23 Jan 2024 17:40:44 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] fstest changes for LBS
Content-Language: en-US
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Dave Chinner
	<david@fromorbit.com>, "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
CC: <zlang@redhat.com>, <fstests@vger.kernel.org>, <djwong@kernel.org>,
	<mcgrof@kernel.org>, <gost.dev@samsung.com>, <linux-xfs@vger.kernel.org>
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <87le8gjc53.fsf@doe.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsWy7djP87r8b9anGtydz2qx5dg9RovLT/gs
	TrfsZbc48/Izi8WuPzvYLW5MeMpocfBUB7vF3pM7WR04PE4tkvDYOesuu8emVZ1sHmdXOnq8
	33eVzePzJrkAtigum5TUnMyy1CJ9uwSujOU7njEW/GKveHXwK1MDYxdbFyMnh4SAicTJTZeY
	uhi5OIQEVjBKzNzdww7hfGGU6Ju+mhmkSkjgM6NEw+XKLkYOsI6/P5IhapYzSuzrfMkM4QDV
	bFg1gw3C2c0osXvLB0aQbl4BO4lnk2exgXSzCKhK7PniDBEWlDg58wkLiC0qIC9x/9YMdhBb
	WEBfYvaGRWDnMQuIS9x6Mh/sPBGBXkaJc8eesII4zAKTGCWefDnBBDKUTUBLorETrJkTaP6L
	t/3MEM2aEq3bf7ND2PIS29/OYYb4QFli6lIviPdrJU5tuQU2X0Kgm1Ni4bb/LBAJF4nXF/ZB
	2cISr45vYYewZST+7wQ5CMSulnh64zczRHMLo0T/zvVsEAusJfrO5EDUOEpseT+DFSLMJ3Hj
	rSDEOXwSk7ZNZ57AqDoLKShmIXl5FpIPZiH5YAEjyypG8dTS4tz01GLjvNRyveLE3OLSvHS9
	5PzcTYzAlHT63/GvOxhXvPqod4iRiYPxEKMEB7OSCO8NyXWpQrwpiZVVqUX58UWlOanFhxil
	OViUxHlVU+RThQTSE0tSs1NTC1KLYLJMHJxSDUxx9Tn/GDLMfXbIHHKbqyUXp6Siv9y64/bW
	0AkzDY6vnm7TkjjPLU6jxuDUBIPg84yNGtOaO171f+V2KZ4TtjK2cPXi/edkTPVnlt4Ofnbw
	SPqtjMDIP9fa3M78NS83MVSa/zSv0G/7/U1Mk5+eNZ49+2PYvUOnNnbxa1wwMNvUmjWn4455
	kcCDTQkvOj7Y+exPuZ3JkfRi5T/fC5HzZpRbrq3cVbKK7fbeFnbJGT8vm0x4qFq/SFWinj94
	m6DLnyIdnpSvwmbrlm8S2NHk9b3avSdIvmni8lXRP0Q3ds6ZG2xStPu8sfT+yGv/T7C8Pmql
	8Ky1z/DsXef/jbUOCzK+1AU7VF7kuj/rXe7muX5KLMUZiYZazEXFiQAM1ipmuAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t/xu7p8b9anGvTvVLPYcuweo8XlJ3wW
	p1v2slucefmZxWLXnx3sFjcmPGW0OHiqg91i78mdrA4cHqcWSXjsnHWX3WPTqk42j7MrHT3e
	77vK5vF5k1wAW5SeTVF+aUmqQkZ+cYmtUrShhZGeoaWFnpGJpZ6hsXmslZGpkr6dTUpqTmZZ
	apG+XYJexvIdzxgLfrFXvDr4lamBsYuti5GDQ0LAROLvj+QuRi4OIYGljBKfFj8CinMCxWUk
	Nn65ygphC0v8udYFFhcS+Mgo0fvJDKJhN6PEjE87wIp4Bewknk2eBTaURUBVYs8XZ4iwoMTJ
	mU9YQGxRAXmJ+7dmsIPYwgL6ErM3LAKbySwgLnHryXwmkJkiAr2MEueOPWEFcZgFJjFKPPly
	gglic4XErwtnGEEWsAloSTR2gg3iBNr14m0/M8QgTYnW7b/ZIWx5ie1v5zBDPKksMXWpF8Qv
	tRKf/z5jnMAoOgvJebOQnDELyaRZSCYtYGRZxSiSWlqcm55bbKRXnJhbXJqXrpecn7uJERjH
	24793LKDceWrj3qHGJk4GA8xSnAwK4nw3pBclyrEm5JYWZValB9fVJqTWnyI0RQYRBOZpUST
	84GJJK8k3tDMwNTQxMzSwNTSzFhJnNezoCNRSCA9sSQ1OzW1ILUIpo+Jg1OqgcnYZbJwdmHh
	hbbN5Q/fnOJ1ZMtUrbPUj929VPjqll1VNsuSb2nMtNC5zTl1SRlP0dWPMyfxbP/Vp1MSF7rw
	VbDpUQEbW8038wobTblKUrMu8zAcLClYHt36J1IzZ5uTWUfEseRuS8Ze8XXbHsne3feH4YiC
	suDFjZL6+go/OvJfmPL+2sf4p/vM3U0ntXw02QqKy3e5li551//ErlpYXrBmz7qjV35wMMet
	FHsttmqTiyV744PT0p0zD5feSVJokNwdFa+8XexgkE/WHt2smWGh3KuXz52R8fZqu4eDZZPt
	nL0PTOv494ivj7lZ8fSESOSKwM+3o6ISDi3aGmHMsDx84dS+uMJr3fmHm9WilViKMxINtZiL
	ihMBCiUaSWwDAAA=
X-CMS-MailID: 20240123164046eucas1p297c033627bd506b0bf256e9ebc4639fe
X-Msg-Generator: CA
X-RootMTR: 20240123153550eucas1p22e283235d636ce5005321ec694528627
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20240123153550eucas1p22e283235d636ce5005321ec694528627
References: <CGME20240123153550eucas1p22e283235d636ce5005321ec694528627@eucas1p2.samsung.com>
	<87le8gjc53.fsf@doe.com>

>> CCing Ritesh as I saw him post a patch to fix a testcase for 64k block size.
> 
> Hi Pankaj,
> 
> So I tested this on Linux 6.6 on Power8 qemu (which I had it handy).
> xfs/558 passed with both 64k blocksize & with 4k blocksize on a 64k
> pagesize system.

Thanks for testing it out. I will investigate this further, and see why
I have this failure in LBS for 64k and not for 32k and 16k block sizes.

As this test also expects some invalidation during the page cache writeback,
this might an issue just with LBS and not for 64k page size machines.

Probably I will also spend some time to set up a Power8 qemu to test these failures.

> However, since on this system the quota was v4.05, it does not support
> bigtime feature hence could not run xfs/161. 
> 
> xfs/161       [not run] quota: bigtime support not detected
> xfs/558 7s ...  21s
> 
> I will collect this info on a different system with latest kernel and
> will update for xfs/161 too.
> 

Sounds good! Thanks!

> -ritesh
