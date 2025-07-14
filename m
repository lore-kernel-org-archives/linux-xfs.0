Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CEB1474CC;
	Mon, 14 Jul 2025 07:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752479588; cv=fail; b=SalepijI3Tp7c5NYDKszU/oLu+yFLfjN3lu8ltO6y10UB3GfPFjKvPsShi7wpd95P402J0MA5AXqtFm5ubME78s6RroGHlewUqn0/vQNdfw755e98LTr4OONFTyX1cfm9LqysgK2ogdUyETemiSy24q8FtEn2AbM0Y/9dDbFJ5o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752479588; c=relaxed/simple;
	bh=LlGLXqtrlZsd8NuYsOmJAS/QsYSHj1PHdRWMFavWkIw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pW2YpSBWHj0nML4OeNxpnrVUomz3Tw0eP5gyF05CE/3sinjdYqcCndufJEBJPd1Y8TATppzCNF/jJMohripeB04Pn2x8CzXMbb6neRjL8Pj38bjMECHMrOIx+aeUSzl+FoSEqoIg2ayz2u+vshnpsX7BTpVfVkaNJ7mhyslgR4Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HgHNeTVD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cLQYRQPs; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HgHNeTVD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cLQYRQPs"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56E5Z5fs027551;
	Mon, 14 Jul 2025 07:52:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3gFfjPV4oiKqV7gf9SD4e+WR7X2DkDWldYZ06rkSwI4=; b=
	HgHNeTVDLNiPV/zgGk+1Ubltjq5jlFzIJZXA2tQha4rYrMWKxvoalo81mbknwlnU
	2uGVNsfs6F+/Dq5PNJVT0HdP37PlXcgUI8kuLUvcYZ+XaIbrudXFD/tjq6y9n+g2
	TiuWURBdZjqb8eSq+hzlUj0NnCkxnSqYQ8/KMBlPErBG0zbSqxrJdhJ/4hM27DoK
	y5Chndv7cYah9BD4XILebSS6XFGgCd3juT/ervs7nvoYMzm3XSbYluSD7En0ghKj
	dyShL2QcQmDj/XQGZ1AqBjxbR337XYgTqOBm7WJQgkiykzBYMzCtmh26afAUDmBc
	ipVTq7PbwPMvQS/HgG6Pkg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ufnqmcpc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 07:52:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56E5uclg028968;
	Mon, 14 Jul 2025 07:52:45 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ue580k42-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 07:52:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wOkUM/9GIT1J2SmmgbUmmgqVZnd+/x3DNd7fKeLw2PHHjuHq0LNhVFfEAtQwYOC3nmSVyI8+rbvMlARXharsPFIYDNxJhmYc8M72E/Sms0vAtb1qRtbf4uZr3ELfUI4oSa5fbR3hNiivnJJtYFChRounQuNLXv3miDvwo07ByEoJAuXeSIuTq+L/PCxx02lajTURG0/dURp/G0vE8i9icIs74cdO5zOiK/9w3M6nHoyXkHhIRS+A+XOZpnt4sLE5VKfcxw89B/o3Iq/g0cU5TFhTo9+oGoJeSchQshM/c606SSEnhihqw3WZbEPwiVaBIgz+2Pt8pcCNBHgzzSKKyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3gFfjPV4oiKqV7gf9SD4e+WR7X2DkDWldYZ06rkSwI4=;
 b=ZuCjAXzeBsTOqOQ5lhXds6XUqkHL8DBOTW2nnPC1YJzzvwQWtmTbkaBZMYpXQCxrBMVk9Di234pE4IQ8zchanErRTDJi71WgU31uyOVSPRPuTZGGbto6jbe9OMXWwoQ3jgvjxX541de0oQnYoV09L7W/rDQOfpx4V7D9IpQKGEr2VZW4KscvAz2JXc9qRjQpiU2r7vlco8nZyxErCNdptpsclZHC6VcUHs/09pkkLEBqDyF/vdg4B1RIz1NbMkIL333BAYeAABo5H7hjCf37k0bpI96EmG+jNFWLNoBwP0wpsyWd8nm/+YRanJCbpSZErWFLH+TVzTxwPZch3tEoxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3gFfjPV4oiKqV7gf9SD4e+WR7X2DkDWldYZ06rkSwI4=;
 b=cLQYRQPslAgiCjZsoVULxB2XQtujL9zWyLu3IiYImF7hyDhFV5VQGt4jOohsujgnpGdwlnh9+zNURzhmVts12CZZQljpjbjmH/g3hn5BZl3aKxb8CJ97eHTRHJXEl44f2+FsIH9u0D6ARUKeKsQpuyiX3/hhc8TuottDlECWP3U=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by IA3PR10MB8396.namprd10.prod.outlook.com (2603:10b6:208:583::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.32; Mon, 14 Jul
 2025 07:52:42 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8922.028; Mon, 14 Jul 2025
 07:52:42 +0000
Message-ID: <706d13cf-d0e2-4c30-8943-2c719f9be083@oracle.com>
Date: Mon, 14 Jul 2025 08:52:39 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/6] block/md/dm: set chunk_sectors from stacked dev
 stripe size
To: Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, nilay@linux.ibm.com, axboe@kernel.dk,
        cem@kernel.org, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org
References: <20250711080929.3091196-1-john.g.garry@oracle.com>
 <f80713ec-fef1-4a33-b7bf-820ca69cb6ce@kernel.org>
 <20250714055338.GA13470@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250714055338.GA13470@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0310.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::9) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|IA3PR10MB8396:EE_
X-MS-Office365-Filtering-Correlation-Id: 3545a381-d488-49cf-a6e1-08ddc2ab696b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bVdVMXlPek1CaGdsSmJNbHRDVWlCREUzVkFCRENNSUdWd1hjbWVldHVIUzE2?=
 =?utf-8?B?Z3BodG9ZSUxGaGQ4bkZNdlQxOFFtNVdvTE9VUnZiYVZGbGVDWlBHenFTdGVZ?=
 =?utf-8?B?cUNDUU90QU5kUm4vWHBTWGttS0xYQVpBM3E1ejJkcStWeFNjYUJUYXcyWWM3?=
 =?utf-8?B?TTVOUzUxT09ZMjJHcGZVc0pzWkl5RUlvNGRVQVlRUWIvRG1CdkFvd1BibXhv?=
 =?utf-8?B?SDJYQ0haRFdSc3J6YXhsR0xrQnJZWFljem5CZDJNVGtIbzlzWmNOSVZ0Nno4?=
 =?utf-8?B?MzlhMUtqN3A0R1pCWFQ1RFZkSTFjbnZZa2ovU01uSWczWHBkTHVkWmpMRWpa?=
 =?utf-8?B?VzM5M2JpVGliUE10NENVVFBJSzVveis5QkMxaFhyM0hFMzVqYlVZbnB1eE80?=
 =?utf-8?B?NjBXSk12RXp6U1JqV1p6OU0wUHZpRHZrb0RucmRaVTJxWWpib0JmRVQwb28x?=
 =?utf-8?B?VFlVdFlsM1N0Kys0YnAzZGUxQmxFNUZ5WHYyS00zME9hVTE1WjVaQ3FOSHVw?=
 =?utf-8?B?aFhTSXR6LzZKTG5TZTBxLzNYRVRnY25tUlBFdC82bDJvOUppMytKYk1qQWp3?=
 =?utf-8?B?SnF5L0JBSjB1czVleWVqWDVXN25kR0o5VnlXdWtxa0FOenVtNXNCd3g3UXBK?=
 =?utf-8?B?N3Qrejk1WHBObmJTRml1Yy9IeEZkMmkzN2RzanROSEYzdVl2cURteDVCcnpI?=
 =?utf-8?B?Vjg3K0taTXNja3E1WjN2V2lxcW5SckZnWlFKRjZud0c2TEZUNlcrNU1hbUQ2?=
 =?utf-8?B?Um5xQTFUNnh0UWx5cVlMcTMwRUdCdzlpTWFDSVM2Y3dkQ29RbWExL1I1TEda?=
 =?utf-8?B?QitjR3VUTTR6VHJnVlZCRG5yVUR1NmtOSThBZjd6VUh2Rm9ZNnZCcnRWTDFG?=
 =?utf-8?B?cjd6c3N6RVlaNTFySmtzZExocDgyRVhoemZ6Y0pvcVVrUzlyZ2VYMHdhK1dG?=
 =?utf-8?B?SWI0L1NxcnRwaE53cDNpRkJTU0c2NmNlbFFYRVE1YTFUckxNYmI1YTJhSzk4?=
 =?utf-8?B?bGFmVWgycmoyM3IvSlhVaW5FUW1EOVJyUHVBREN2VkJURzcvZVJGbGdQRWxj?=
 =?utf-8?B?clpab28xY1VkLytuTlNTNmJtN2NFT1krZ1JwZ3dnWmtDcUNFMW4wS0NHM3Nk?=
 =?utf-8?B?ejZodUV4MzBQZGV2Z3RUMXc0Z2s0eERCcTEvUVNvekFCcmkya2oydmZ0bVly?=
 =?utf-8?B?QmpubUdiS2NTbkxFZE9OaEhOWVZGMGo5bEFtc3k4a0pLdjBQVmhwZm1Rdnho?=
 =?utf-8?B?QU1aY3A3N2hCc1RYaE9maDR3bkJhbm5wQ09DQVJwUUlza1pEbm11b3ZNNG5k?=
 =?utf-8?B?ZisrRXFLRWRuUmR2R0tKUUNRVW5FWGFZbWpiVVQ0eG44RW9IS1pwRkkxdU51?=
 =?utf-8?B?dHdLNmFoTFlpMnNBcmdqalE1OTh0UG9GSGpCQWY3a1lEUElwaTlMVzZEeVhN?=
 =?utf-8?B?ejZBQjdiVHRiTUhYWHdUNUNLVklxOGd4MGU5ZFFQM3BLTjNVTFlPNVhNaDZu?=
 =?utf-8?B?QUpxVUhueXlHdTRPbUYzNDRBcENCanYwdE1oTVY3a3d1RjRaN0JWOEgvVFZ1?=
 =?utf-8?B?NDlwSytPTVYzZ2hNVjE2RU5senVHdVZLVm5qZVNiVzNkS3dzSTlKNHhWTDVw?=
 =?utf-8?B?bmFXTEpZYzFUdmJkQnNXNXVuMnl3VktWSjBqRktOSGpUNHBnQzFHTTFFSVlj?=
 =?utf-8?B?MWlFKytKMFN6TlF1RlpwaU5TYVFyU2E5Zk1tMVVMeVZvU2ZxUGNkcGYyaG9n?=
 =?utf-8?B?NkZ1QXRvS203VFBHOXdncEJTUUE0czhlU1RqTVRzY1pjcFBGbGYrREpIbEhw?=
 =?utf-8?B?cHdobTduTWRBN2xNdkNxZXk4S2NEZDNmTkJnQURFT2dLamRpa3NvZ2w0RHd1?=
 =?utf-8?B?K1RkZWdlTE1xL2xrYUpza1pKbFFaTWI1MnJZdWd5TE9keEgvZ2F0YmVwZ1ND?=
 =?utf-8?Q?+muMZjLeALM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UXBrNStTaGtNUU01MUxwZHZQVmtxeEg4MUJuRlhIejdnRVNLWjhxT25TcUo3?=
 =?utf-8?B?QXMrZlRIOG85bUNrMFM2QmtFTmhsQ2hhcEx2UGUybTB2Lzh5UCsrYXZyMFBk?=
 =?utf-8?B?L1d5QlpLcHFMb2I0QjhMTTkxdXVlUE5wQVRORlgzc1ZTRXpwdzVQSlZmTE1V?=
 =?utf-8?B?MXdjZkZRU0ErcnNwd0Flbk9HWjNOT2Z4ZER6QW1Zd0lyMXZTTjVkcytKaXFO?=
 =?utf-8?B?RXZxUGw1Ui9yeGFwMjFUSDQ5bmdWclk1dXJoMkJIOGhrY094c2gyN0tDemNt?=
 =?utf-8?B?djR1REcxTWoxR3F0bVZBYTJlay9PUURFTGFGSWIzNm1qMFhPcnBKYy92MEly?=
 =?utf-8?B?TmFDK0FSd0xLN0RudW9yUzlUaWlwTE4rbFEyVGI5SmxONE1TMnNLdHV6UGNr?=
 =?utf-8?B?eEdiMmNrNmo3d0JodlUyRjBFV0NmL016WTY1TkZOVUJTUXF6TnU3VVoreGU4?=
 =?utf-8?B?Smd0Z3hYbG51Y2l6K2lzWTc5MnNDUWFrZmpObmlheGxCazVIdUQzdVJ2MUtx?=
 =?utf-8?B?YnR1L2pwUVd3ckFjMklqSzY0L2wwUG5qa1RZZVM0a1c0S3FNRGx6WDFZZlhJ?=
 =?utf-8?B?Rm9WcXJIeEFPcEVvQXEwRGZMUXZkZDZHR1VVMDNRT2hDek1PU3Q0SGt4VnIr?=
 =?utf-8?B?MHBIemdvNjBWcldLSGJsWHptY05ZbEY3enpBSEkvWkdobk0rdEZhV0Y3ZWZG?=
 =?utf-8?B?cWo1MGJLTFA2TkgxcFZDWmd4TkdBZUdsRWx6OVJ4VkkzRG1vViswZVFZMURo?=
 =?utf-8?B?TWVrRWZBZCtSU0dOVjZyaTY3bERZV2tjVXRzYThrMFRsaWtXTFhXVWVuTGxF?=
 =?utf-8?B?TjJSZjhFRXI1NlR1aDUvSUUxSE5KeXlqcm9EV0hPSEhSWWVLSWlmLzlZblBk?=
 =?utf-8?B?dVljK290NHFSTXpHY0VaQXV0TENZTFFoQnREb1ZZbUMwSFFRU2FUZ1h3R3hn?=
 =?utf-8?B?Vy9Jei9aNjNOeGZwRXdsZUswLzBxcm01bDlybmFHWjJwUGxOZmVJSlhVb3ZE?=
 =?utf-8?B?VUtrWFhDdUZRZDlrSUduK0o2UXF4NzlUZ2V6ak54b2V2Z1doOEdUc2w1RWo3?=
 =?utf-8?B?RmZ6Yk9mNjVNM2Zqd2ZCWGF1Vi85VGVGUDd0S29uNXF3KzUrZXBpY1pFcWNK?=
 =?utf-8?B?RTN4RTBMcTFaMjBhVURyMjZKQXdxd0Era0FOZjlSWlhwRVFCM2tJd3RMVWhD?=
 =?utf-8?B?aEVjRW9ib2R0Sm82dlY4V0ROazZFNkNRMnRFNHpwOGpjZG1CT1FFNVo2azhB?=
 =?utf-8?B?YkFuNDZUTTNMU0VmeFRtN0E1V3g2VlVhUGFONnFMMU4vS3lEZDBIYmJpVThi?=
 =?utf-8?B?VmpaYzZRb3p3cDhjVkFOWjZqMldjbm1Za3ZqSmhBdVFDSENiMXhjNzU1QTVz?=
 =?utf-8?B?VEUwdTlXZHpreFFuYTB5UFRjc3AyVXhDZnRYL2JSUDJTaG5iU2xXbStyeHVO?=
 =?utf-8?B?OUNSMzNneGlyT2Z4dVJhSmpwa3R6N3dXNTRMTk9wTVBSZnhMZ2xWN0s0dURW?=
 =?utf-8?B?ejF0c01rckd4TjJNYWxQNklSemp3OTJZWWZEN3QyWEl4cXVzVVBlbVZVcGkv?=
 =?utf-8?B?SmZSNkxYNWwxYWo1UlBsWWZXU0hVMitEZjJrN0JleHZlcUhIQy8ydUR0VGVP?=
 =?utf-8?B?VzlMemhhRjJCU3E4eHI2WkxMMG0zdzdmelZZYlQxblZuYWVycGJwUjVLL1RQ?=
 =?utf-8?B?UU9mUGQrUGJ6cW5vK3dTS0JxYlpnakI5SjJhUG9vbTJDSDc4ZDhVQ3BvMStn?=
 =?utf-8?B?WmVHUFZXTVYwOUdMOUVKZ0RsbE53aWdhb29Ka1YwR0NZQ0NOWjAwbWM3Q2Jv?=
 =?utf-8?B?Qi9xUjI2SC8rSUpGSi8yMUN2VzBpMjdSV0x3Y3dpR1o0VFdpc3ppODd4Umg5?=
 =?utf-8?B?ZWxwOGpKaFMzQlpQSlB5aWsyOUZiZVRSSnJFSVRaOG12Vm13SkZDYUNBMnVo?=
 =?utf-8?B?UXdHVTRDQnBMQnpSd3pLWFZ4VVZ4bHJWQnRFRE1Fdm14TzZOUUN0eHJuc0hp?=
 =?utf-8?B?Rk42WGJpbkdmTHQwQlh6L21pZHBWd242bkNHS1F4UWpWMVNtU1NyazFUU2ll?=
 =?utf-8?B?UFNFb2duZjkvN0p5VG4xV09ZTFRob0tYZ1lPZThpOFdhUXZPazJKM1A2Q3JX?=
 =?utf-8?B?TitqMis1WE5rQ2ZocUdWVXRpS3lReWg4amJWWjdkYW5GVGRvbSt3anFNbEVr?=
 =?utf-8?B?VWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KGVflA00wfig+wMxrVgVH3kCypN+XrboEFQ9jc+tvli+HbIKMbOtQZUwtD4AtDG/D0KMzCrpt283ZUi3G7H2QyHXccc9mBb+PGaTexrsb0nNguvSAno9Wq8ht4NeNthC8lmwyqFtpYTV2KK0XjpDkOuaxf4mS3Ov78kDBm7Ot1QdizRFl+RCRxATDCSCYZ0iTV+Z6n+xpeu1ah+HY3sZCGjPHjOLKUzW5/uLExThwvKJ3PyWY0EP7ZjS/CFhqh6Zax93TUB/YlMKy+J5F3wCokmMqtUx6pqFbCXA9jovbkaXJXvrfipgbjZVPxZSTeIAqGsalYCzmU1rcUJvk3JxuW1d8lnJ+thDbSmyL9+kmEbX53Hp75hFlowhxL4F1CGy9IgcS/vhSelFZ4WxCTPjlvQGdFz5LHuFKsjZcnhYzhCY9wc7G3ry2hPIrZLh4gA0ECiNQvIUG37Mk0RJyN0B6OH+DhitwvpNzUGf6GLd2PFMFoyCxVDB67t9J1Pz7MObLPVU+uFHWPwukZD9Vk1+TTKdPZZX9xcwgZ+oq9V+KD0o4dgdkoEyS+c+d4jYI70WqC7e6VOdkPT6iiA0rnoxCl1vVO78ixZDWljyt40/kTw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3545a381-d488-49cf-a6e1-08ddc2ab696b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 07:52:42.2808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RVyy5qxhIukD1oWhgb2NH1XCEzW+vbjJRwWC9d+XyoeyK0jXPCl9JCjTbtQNvIzf9mgg2F9ogz0B4VN1woeQmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8396
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-14_01,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507140045
X-Proofpoint-GUID: IjAFZC6Jm_j_2YofM6INv_wH60mBHgs2
X-Proofpoint-ORIG-GUID: IjAFZC6Jm_j_2YofM6INv_wH60mBHgs2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE0MDA0NSBTYWx0ZWRfX9igmvKzjV8sz kBkQcdU9sHRgQZaWpjCQhNiUozsj51lbPphYBD7yxUlfR13wpLrPqOpFSJRBLSafmyw3Ie2Q0Zm qkRIckjuIj2rNLw5ow7UD3VTN46LuAkpKOqM5y6fNPTZPBDpyWLcucQ2iqciWFGaD0BYBlN5ggR
 OGda/15otaF6JDtkl+p49ESlo23PJThQHb/fSQgJlCXH0KPtV4aj0Y8uu4UPhafcVcD/5StfwtE LrPgJvJhfI9M6E0kASfbxXNOm01m/EZbYqG42qky6fO5d3ykIp5EZi3+iTTJxRWzYzu5tmWCoX+ qdgPuHkFIgyW8gLcVV8XRm0B28BAA78ipz09hoa804sC4AHswTGIfS1TqTAwKWvZ3zjP81RUYpd
 VOhDQJRl/AqsyKNhKIId4DGafvH8bwd++G1kdafJUM7yjDwt3lG8mN4E7llvKiX8fUZRfFNr
X-Authority-Analysis: v=2.4 cv=U9ySDfru c=1 sm=1 tr=0 ts=6874b74e cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=Ozfqf5gX1RBgB8i_YtMA:9 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10

On 14/07/2025 06:53, Christoph Hellwig wrote:
> Now we should be able to implement the software atomic writes pretty
> easily for zoned XFS, and funnily they might actually be slightly faster
> than normal writes due to the transaction batching.  Now that we're
> getting reasonable test coverage we should be able to give it a spin, but
> I have a few too many things on my plate at the moment.

Isn't reflink currently incompatible with zoned xfs?

I don't think that there is even anything else needed to automatically 
get software-based atomics support for zoned xfs.
