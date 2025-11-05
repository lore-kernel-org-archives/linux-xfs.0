Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98954306496
	for <linux-xfs@vger.kernel.org>; Wed,  5 Nov 2025 10:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762339196; cv=fail; b=snHQ8ev2PglNxQxmcvRg7mJ6J+EQAXmneluoB06w7oLgrR1+PNcPyvU0Wfiys+hLBCCkaxHg3Pf3cooxSBNLzEqQsVTrXZntYKx4h/gL2u3+PhAdioQNl9JyOmPR8SzXEDNj1yd21voBI6M6rNmHmjBNdfFnf4OnljRyMCANfNw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762339196; c=relaxed/simple;
	bh=qiSqZn8F/SwxpHJ4ilOKfpfPnJY1FdZPQojmZHzE+4U=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Llh2sMBWjf2cLKePYbuDQ9SJiCoynBdx4efETQc4ZPjW6aGUjwUQJG7abU6GwbGVJlI9Rl70Qy2WbQpnuv1B+xTnTq2BwdklREvNZDmJcH9putQAZNwKR9akZSvEWJY+PqzoN+DfveZXDnHFXhqqifKRcECqt/BwdOG6OyrvrTk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JYN09YoN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yjfQUK4G; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JYN09YoN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yjfQUK4G"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A5AaBx9026306;
	Wed, 5 Nov 2025 10:39:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=CQ+Lru3DViWmwdS9r7e4gWWWSXY60hFxuwdKd+Q1hSI=; b=
	JYN09YoNS4SVjOA+X8U6M2oIW0omZMmN6LH0pP1GOCr/P6xpvn3wq/SbaDvqMY7l
	E+W11r6r0j9uCraq5lvuIPuqoUAvubbeqPySxOoSdDP1GvVaBV55VsELgry5JiiL
	FlW0N3Wk+L4Ta75GVTbmDjUU7DtVGiHHU0V2O1rhfrkcmyb4E2+R8HbrI/YFQuoD
	aR1rnLgDz6RCyk0vlrNNMi0DY/dRmT0FTQkpiB5a3h5y9IvrtiS2wQLBPuXBUP49
	5lQG650HNJzUS1JhrvnjlX7OjtX4p4D6FS4RAuMi5DR1xRPvuhGo18m6XdewEied
	I2Traz7jNq187RlsGwkr5g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a84xrr097-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 10:39:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A58OPXw038344;
	Wed, 5 Nov 2025 10:39:49 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011001.outbound.protection.outlook.com [40.107.208.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58necew7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 10:39:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nCCt12Go+25uCHpXb5jMl91njo0tt2yhhPDTVqyo6B1EjRwq301rp8+n7PVdVtNVH3W6f5cTlNNgpjj41uXkVwR2+vMHVlnZoIffkcptRN5HCDmY82otdfhdqpbJlQgVwXs+K0G74xXJaooGI9RqwzIDzYPhZuXEWJDGo9HTtLlDgz37zmOSAtfQbNjL5CQSahKB9eFPqITCQ53V8xX6+dGqbnGamkXWKms9970k1Wcvicq3SsUSx+jHczV8cZSBVFOahfNIEeYEihdBiLpmYTtdhqF6vVC8xNRIeOvwxvHOuuteeyo/dRJweQBhBriZPAhGXkL6muFkiY1dpQ8jKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CQ+Lru3DViWmwdS9r7e4gWWWSXY60hFxuwdKd+Q1hSI=;
 b=Xk5FDfaW5pFIiBxwZQpmFLh33yWd9ppXXwmFdyB7RaBleOOjlc3gHuaS7Cq/LxjoKKjQhKeZ0jKxdOA+39xR6mctPwicIYQbbanRG4jMDVgWSD2+swqvVpDxaS2IjcntmG/4oSFJCvDY/MaNb18khlgtCxwdnOH+YBgBjyQFE5u/p56Q8uHu+ZuoNVGsOtBudfV8u1QzYqST7kd7Aya847uszBr2JwKUlwA0n4Fpr2eOlx2wJpbecV2RLf6PuxB8zkTA8Mx8rZ7m2Lt7vLbj5uyK6N6eBlu/4FRdky47bPxHaXaE+aNksZpEZroU+g0F30O98fj4KGJRC6JNK2FTBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQ+Lru3DViWmwdS9r7e4gWWWSXY60hFxuwdKd+Q1hSI=;
 b=yjfQUK4Go3SLaTYyO4nHGmhKFXKH6TlVJfpxX3//WBNTL6Y8POVyqaMlO3eMMMMasue8IEPHkqhmG5zE3h4SMTXT6JhSaKeiqT8RDuE2kyRJEWVG7FZmdZ+GBzEEh1EdmjSlJ/l5ybZ/BSC6llYvjnfGuKtU09LUca2BO+zPWbc=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by MW4PR10MB5775.namprd10.prod.outlook.com (2603:10b6:303:18f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.8; Wed, 5 Nov
 2025 10:39:46 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.006; Wed, 5 Nov 2025
 10:39:45 +0000
Message-ID: <2c4d144b-81fd-4e4c-90a8-fd3c2082246c@oracle.com>
Date: Wed, 5 Nov 2025 10:39:43 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] fstests generic/774 hang
From: John Garry <john.g.garry@oracle.com>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "ojaswin@linux.ibm.com" <ojaswin@linux.ibm.com>
References: <cmk52aqexackyz65phxgme55a3tdrermo3o4skr4lo4pwvvvcp@jmcblnfikbp2>
 <20251105003315.GZ196370@frogsfrogsfrogs>
 <mx6gzhhkvcdnadmmxziu77cuywq4ql5u2hp6fd673vorhx35pz@jmyv74f236ka>
 <c5cff4c3-cf0a-47cc-9ae5-20d7316b3c09@oracle.com>
Content-Language: en-US
Organization: Oracle Corporation
In-Reply-To: <c5cff4c3-cf0a-47cc-9ae5-20d7316b3c09@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0004.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::14) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|MW4PR10MB5775:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e4d3244-11ec-46fe-ba7c-08de1c57a30a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a1JtWXdpaFpBVlVKNVlGdUloVVU3SVNUUUwweUs4bG5KZUVLYlJOQTIvVVhh?=
 =?utf-8?B?YXlLK09qN1lVUjdQOFd1aWtxbGZCNEJXdEI0Tjc1VTlGRkJhTXBnazRZVlQ5?=
 =?utf-8?B?bXlVZ2FGTENQdU1wdlRnUjRTMVI3eTBxQWh1dC9TdncvNG45ZHFPTEUzSnFL?=
 =?utf-8?B?WkZWUWtoS2dQTTJOZm1nQlhRRm1QL01USkdJcE5SRkRhd2xEUzhGdTlWUFFx?=
 =?utf-8?B?N1B2czY5TE5XY3pHSGhDRXRsZUpJcjJQenpoK1hnMlpOR3R1cXJNWVFBRzM1?=
 =?utf-8?B?dFR4R0tncGxBR3dpeituNHloMXRIblY1QkJ3cTh0WUl4d1piTXZtdXNOU3p2?=
 =?utf-8?B?SzB5eW1HenVoRENwR2xqTzdXVjJKeEdiY2ViMXpxclFDdlFVVllMQTNoZFE2?=
 =?utf-8?B?N1AxdmlKM01aLzhEVTR3VDBlZVNTbzZLYSsvczJNOGM0bTFXazRkTGYrZ1JK?=
 =?utf-8?B?bmQrN1d4WHJ1V25IS3ZHR1ZheDRPQVpOZGY2enZHVDFXVURvMWllMG5SWEVx?=
 =?utf-8?B?dk1vY0lOZWwrM1g3amNBVDYrWUxsT1laZ21teWU5NVNPd2xSbjN2d1NRN09R?=
 =?utf-8?B?ZFFtZVdqVmg4bjY5N3h1NGVHVDUxRXFTbnFpNldBdVNoSXpyMEVraUc3a0k4?=
 =?utf-8?B?dFNjeXppR2NLQ3MraEZ1bkRuME0yOHpDZ0NMeVVOMERjbE9ralBxc0dvbXpJ?=
 =?utf-8?B?Q081eU1WM285d3NMU0ZPcExyTy93R1FBTWNvSWVqYTRzTDNJbnd2VU5hU2Y0?=
 =?utf-8?B?NXdpWElKTUVTdkRWZk8ydEVTWGlnUHpJczF6WlR2ZWxTVjJhQXZLc095VmRj?=
 =?utf-8?B?OENvYmo3TFVuUTIyZzRwU3haZ254TU1RWG8xUm4vNitIQ0NPWSs3THMyOGow?=
 =?utf-8?B?b3RGWEZENmdQUnpqTDUreld4c2ZBUUhqNThoQ2NHSU9saGl6YWNaeHBHeTht?=
 =?utf-8?B?eGZyREtIWm5NaWpuZlJSMDcxZUZtM1QzQ0VtQWpjQTVnSU1JT2prTmNkcVJy?=
 =?utf-8?B?Y1dJQ3JoeDJmeWV3VEgyV2hwbmM5cDZnTDZ1Z3F4T1lLaElmTmQ4RWsrMzc1?=
 =?utf-8?B?VC9pdE9JYjRkcXF0UjZFWmFKenl4Z3RKMG8ySm9zYVZjMmtvQjUyeGlBSGlC?=
 =?utf-8?B?c3Q1NFBUY3RFbVN1NHNjcTVHWjVKZENJTUtzWHhHSWI1QWlnR0gxdXkxY1Jv?=
 =?utf-8?B?dG1WZ3hMR1JlbGU4bVArTTNXNlVRWEtiVmN4cVBUbUJTR09NZSs2NzJDMHIr?=
 =?utf-8?B?cTV3ODU1VmFXQ1RLZHdsK09rSCtLam9wTzYyMTRsZ2Uzd1lVeVZtdndWRXQ1?=
 =?utf-8?B?OXFLNUpHUllqMVhZc2xpT09IQTZkN0lmbDNiUVFQOUdxZVM4OWVFRjFvMUht?=
 =?utf-8?B?VW5hdGxVdUE2b0g0YXlYMDZld1oxenI1SVlCK3E1NWsxYWhXOGkxLzArRHFR?=
 =?utf-8?B?Rmo4WUZDQmphNDRyOW14Z0ErWFljRFFqS2VtdDJGRktNMkFyUlZPcTBmNDV2?=
 =?utf-8?B?azFHRmFkdG9RRGZHVmJRbW1aYW0vYm8yaGgzbE9URFpaU1NUbSs3L201NlBU?=
 =?utf-8?B?bFFKWS9KWHZRa1BEci9WblhMN2dwVkRpeDA2aURSOHVkek9lODFMZ3NVcEFq?=
 =?utf-8?B?MHpFY3IxTTZ5OEtidTJrenZaRU1tRGxreXpmcWdyTzA1QThRZDFaUjQ4NjJl?=
 =?utf-8?B?WjlzbjB5UU0wSE5qRUVNUXYrRTF4TlZwUjg0UHY4M2dhdUlBRzByTnFuQjNv?=
 =?utf-8?B?SUVSZFY4eU1Yd0g1ckdvU2pxNFBsTU9CWUtLTXJaNjJJS2hlSFA1VUFBZkZq?=
 =?utf-8?B?ekdBcllzK0FJOC9qVGZYVUFnUlB1d3NnOU1ieWhUL3B1U2pmOFNEczdJZlBq?=
 =?utf-8?B?R2ViMFljU0ZNenlwcS92cmlHdGNLWDAyMVJyaXNXOCtvRlE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S0RORnJhSHZIWG9waVBjcE9WTUlwc01SKzZ1bENBS1laNnZkVmtDU1BYd0Rw?=
 =?utf-8?B?UUc5cTRyUmgxQkpTZ2crOEE4UHVXeDlBdEFaMGloYnRlUElWTjBZaG9NVXRP?=
 =?utf-8?B?N3NrZG1qaHJIY2MyUS81SGp0dEtvL3lpK203QjFaTEZ3aEJZYnIybENKdEZP?=
 =?utf-8?B?SmVkcm9FMGcxVWgyRUhLUEVrNnJJQStUSUkycUJYZ0dON0V6UTlKNXk2Rmp6?=
 =?utf-8?B?WjVkK1FlOVBBdXE4eW9xUUlyTHJld0tJbVNxaloyT1NsNmRoeXFGdFBXdFda?=
 =?utf-8?B?VmZRMW9hTHFzd0tCa05odEFCcHFldmhHMUxJV0xYREtmT3pvUDc1QjVmNHJm?=
 =?utf-8?B?U2hZWUo1OTlLNjFrbTdMZjF1cDVFc1JlZWs4Q1dCWXQ1UVJRR28zTC80dE90?=
 =?utf-8?B?MTRxVE04NG9DaHJmKzM0eU9CWXNQZElXRkhTSjNvVE1HVXh6SUcxakpZc2Mr?=
 =?utf-8?B?SElscE43Tm94ZmRYVng3S2pjckxlQVByMXlqWVpnRmFUZ3dqUWdkRnZzRDZv?=
 =?utf-8?B?Zi9yMGFHbjVib3d0N21CTkRiSm9TNkNYNHBnNU5LZU42cTdDalRER0tjUDZW?=
 =?utf-8?B?K0RjMmEzZGVlVkxmeHQwcVhqUjRXdzVudmFuampVbjUvTVpnWEtuYW80eCtn?=
 =?utf-8?B?c2NsRVRwcVZkSHF1SXo0Wi9VYUxyZHZtRmlmMzdsUXRNb1dGNE8wbnpWZTRr?=
 =?utf-8?B?S2ZTWWd2SGRCYVllMzk2T0M2MHpGVkhFOTlESUJxRG1pY2hWRzdvckRxTnBu?=
 =?utf-8?B?Rmc3K0twR1d0MjF3YXU1RzhNQUNNNy9Jb21LM2xoenJ2QUwrWVcwb1VUdlU0?=
 =?utf-8?B?TWVTV0I1K1BmUkliWm16VG9UakE5UDdDa244Smo3Zk9TaGU0a3hmaWdULzgy?=
 =?utf-8?B?VHhjT2VINk5TbnRDSllxQW1UNHMwV016anZ0UFVXYVJvODNneDhHN0owWGho?=
 =?utf-8?B?d0FPcEtHcXFqa3h2NWt2ZUhSazM1V1RqeE5Xa1ozdWVxU1FnTEwrOVhwZTZB?=
 =?utf-8?B?WlNiaGZnYkNQQ2liSHhhR1RESElRWG9iMVh5SjhwQ3R2Z1hOcmpUeE5nc2hR?=
 =?utf-8?B?U212alpWdVF3dUxPa3ZXTSsvYkhCYzF1SVhldjNZNGZUMlEvL2ptN09KSTU4?=
 =?utf-8?B?YTU4M1dQQ3M0bFh4Si93cmVIbXZHNTd0STlRSEpRYVlXWjlPb2R3ZTNscFc3?=
 =?utf-8?B?dUk1N1RuZVRqTmRNaG9URm84OUo3RjNSdU0zVnE3MEUrSVlFcElyREhGaVNE?=
 =?utf-8?B?ckdWemQyYW5NRzNNTm9nRWRVVmh4RFVtL0cyRUNKVStRYXBLdTBack4wM3Y2?=
 =?utf-8?B?cjc1dkxJL2E1R2hwTXVTV3FXR1JOWUQ0MzVNN1lpc2ozRU1Xc2Y1Y0IxOUxy?=
 =?utf-8?B?YmNNb05zTVg3SU9yZ3gvNmxPYm9McEtGZHh2QnZvdGtxdlRudlVSaXlVRC9u?=
 =?utf-8?B?QzlyNmhSNlhxakxOVzZsODJGeWF4dStaSDB6b2JsNWVSSUNCQkttN3VOaHNR?=
 =?utf-8?B?Z1JwOEJaWHJZTXRNMndnbWFKVnFGMGIyNE5VeE91c3lob2lYZnV3STJRODZS?=
 =?utf-8?B?S2F0Nm1QY2xxUkVoeDhLNzRra3Z2NGZnZHZybTFJUEVPR245eS9uZzE3cE40?=
 =?utf-8?B?K1crQjZoS3JCWjMvZ1JKc0hyNytEVFZlMlBNSFFKZXJ5WnBLbFNHeE5oQ3o5?=
 =?utf-8?B?Z284ZC9tWjFWUnR2azhURk5SVUFXVitvZTdDakFIYUdyZi9pTitEb0thRHVU?=
 =?utf-8?B?TkJTSjJMOW45OENiSmkzM21yREMrYWtxMzQ1eHVBTkhEVkxLbmMzVmc4M05R?=
 =?utf-8?B?bFlKbVBrSld0cE4zVVJlQ1V6bGc0eExORmZ1b2UwK21OekRQTU9neXF0M3VQ?=
 =?utf-8?B?L0FzTFdtK0dWbVdxMUNOMzcvK05RczZ6ODJaREEvRnhxZkpPSFpKeUYyWm9U?=
 =?utf-8?B?aHgzcUVHcDliUkxXVXExSFZ3enNPSm01eGY3enZNZ1pBZ1pGSyt3UXdnZngy?=
 =?utf-8?B?WVcwKzA2RllhWFRnOUlTN0hBZkVxTjl1L0ZPYytka0JvVmZHZldwd3dMWEF1?=
 =?utf-8?B?d3FpSCt5dnRUVDAvekZDNXNNQTRzcllBeDhYYldiRi8vUlJrNUFuUGxpMFEz?=
 =?utf-8?B?ZExROVY2bkh6LzQ0V25uUFlDbGJiNU42QWxpV1dKQms0QlJmSGMxRnJ0Tytr?=
 =?utf-8?B?V0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8tCHX2Gi1s2283qySSPHt3jjy7utuCz7x+7yRqomkCTHPk/V+Rdp34w+aYJknmIarU1LtQWMgPcjrW4x6nIfVGVHQrM2AhDZKSPaM1EfaL31lYgcgUg2qm290p4A68p+i4rSeVn0wd2wEBTH2dmGcLkGMKnoTVgBwpG2FPjiq4J6NFTKNASwP6t8m7TZlI03abUaB7aEVKEGEzO5dZqyaIGrh1wPVpHk/JySvTej5DzHP0IFpZS/bEMtICxBsrIOo0FuQMvVTxUmq+HcKF9uODLvhKXrZI5uLDGYlefsBaXQBN91R2vKHDy7HaXI7tF4zXGkQAx/q4nWIesLf52BTJ+HITstGkLDxIDipwAnoyhnVPmdYikdf/a5TL5UhtZKWuO3l6VqBlwbiRAWZp9eugL56EyK+NCI+cThopbI92CHwrslw5Gpd2cnP0XOUkrp+SzbSbxnzQeLXsi93hscHViNVvTfC5eE6Q9FKcFQDyBUx3nje0r8ifiB1QCKOsWG70EZKRJIb4KSWuBfzhqXBI6Vb4psfI2PeGcTa8QwzJOxAmUDMdzs16xS0HfK9zHDvenPcs8ajLczL6zx3znHSf4G88+SR3A/PwPdPHZHHYU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e4d3244-11ec-46fe-ba7c-08de1c57a30a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 10:39:45.8751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ChWGF6jJ2OtJ/sngfRKc8etI5ymJhEZYz2Cjg67n6rGc8GFd4B9MKBN9dBTIdXF/12YtCSDkvgL6txB75MH+3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5775
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-05_04,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511050079
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDA3OCBTYWx0ZWRfX+I1AU6y/+hSv
 RR6K6byi+rlexAClC6KV4qqMXKdh7RIXAErcbJS7ULekSLgj/zgz/EwqWwO6UMr9FIAt+r4goX9
 inoN/YIo0EniL7ElTHwY6efhv3StEaF7mGPEuw5nHS29WcZg+VzHVjjUkgQL7j4N71F3JGYl+oD
 9xvlgMLzyCr0VRJMe9C4vjz4ccfNIPFS6pa9EKuXcmM6b8wMpLpyLZK5KeeA2SZHEMOvlNfbgSY
 IR5DN6Qb6t41Z5cdxQURxESQrv0t9L9JKF+yUx8HRYA/T+1XGWh2hGxskPXNwM6frUeEEs87gc3
 nqnr2MqMtmpmz5LNwVkB3AdkpBsoFYF4HNGoYBC0wevPIL1yquh65HoLR//mTGYcLiOpFx5LPP8
 ziurIQ4l/ZopK9A9eoy9AWmoO0SUISFyX158IWxQy1oCsTAwQbM=
X-Authority-Analysis: v=2.4 cv=Nv3cssdJ c=1 sm=1 tr=0 ts=690b2976 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=uherdBYGAAAA:8 a=VwQbUJbxAAAA:8 a=-9sl7hsuoJ_obzmjyfsA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13657
X-Proofpoint-GUID: ehF8pI5m0Om0qm-zysZztuRWLE7KGTsG
X-Proofpoint-ORIG-GUID: ehF8pI5m0Om0qm-zysZztuRWLE7KGTsG

On 05/11/2025 08:52, John Garry wrote:
>> I don't think the disk supports atomic writes. It is just a regular 
>> TCMU device,
>> and its atomic write related sysfs attributes have value 0:
>>
>>    $ grep -rne . /sys/block/sdh/queue/ | grep atomic
>>    /sys/block/sdh/queue/atomic_write_unit_max_bytes:1:0
>>    /sys/block/sdh/queue/atomic_write_boundary_bytes:1:0
>>    /sys/block/sdh/queue/atomic_write_max_bytes:1:0
>>    /sys/block/sdh/queue/atomic_write_unit_min_bytes:1:0
>>
>> FYI, I attach the all sysfs queue attribute values of the device [2].
> 
> Yes, this would only be using software-based atomic writes.
> 
> Shinichiro, do the other atomic writes tests run ok, like 775, 767? You 
> can check group "atomicwrites" to know which tests they are.
> 
> 774 is the fio test.
> 
> Some things to try:
> - use a physical disk for the TEST_DEV
> - Don't set LOAD_FACTOR (if you were setting it). If not, bodge 774 to 
> reduce $threads to a low value, say, 2
> - trying turning on XFS_DEBUG config
> 
> BTW, Darrick has posted some xfs atomics fixes @ https://urldefense.com/ 
> v3/__https://lore.kernel.org/linux- 
> xfs/20251105001200.GV196370@frogsfrogsfrogs/T/*t__;Iw!!ACWV5N9M2RV99hQ! 
> IuEPY6yJ1ZEQu7dpfjUplkPJucOHMQ9cpPvIC4fiJhTi_X_7ImN0t6wGqxg9_GM6gWe4B1OBiBjEI8Gz_At0595tIQ$ . I doubt that they will help this, but worth trying.
> 
> I will try to recreate.

I tested this and the filesize which we try to write is huge, like 3.3G 
in my case. That seems excessive.

The calc comes from the following in 774:

filesize=$((aw_bsize * threads * 100))

aw_bsize for  me is 1M, and threads is 32

aw_bsize is large as XFS supports software-based atomics, which is 
generally going to be huge compared to anything which HW can support.

When I tried to run this test, it was not completing in a sane amount of 
time - it was taking many minutes before I gave up.

@shinichiro, please try this:

--- a/tests/generic/774
+++ b/tests/generic/774
@@ -29,7 +29,7 @@ aw_bsize=$(_max "$awu_min_write" "$((awu_max_write/4))")
  fsbsize=$(_get_block_size $SCRATCH_MNT)

  threads=$(_min "$(($(nproc) * 2 * LOAD_FACTOR))" "100")
-filesize=$((aw_bsize * threads * 100))
+filesize=$((aw_bsize * threads))
  depth=$threads
  aw_io_size=$((filesize / threads))
  aw_io_inc=$aw_io_size
ubuntu@jgarry-instance-20240626-1657-xfs-ubuntu:~/xfstests-dev$


Note, I ran with this change and the test now completes, but I get this:

+fio: failed initializing LFSR
     +fio: failed initializing LFSR
     +fio: failed initializing LFSR
     +fio: failed initializing LFSR
     +verify: bad magic header 0, wanted acca at file 
/home/ubuntu/mnt/scratch/test-file offset 0, length 1048576 (requested 
block: offset=0, length=1048576)
     +verify: bad magic header e3d6, wanted acca at file 
/home/ubuntu/mnt/scratch/test-file offset 8388608, length 1048576 
(requested block: offset=8388608, length=1048576)

I need to check that fio complaint.

Thanks,
John
