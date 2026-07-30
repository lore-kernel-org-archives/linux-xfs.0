Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F4A3EDAA3;
	Thu, 30 Jul 2026 09:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785403084; cv=fail; b=I+xZvSDfHTGzZTR8ZSX3RieDrlJPks/ls8RpDsgUyX5+f7f/Z32VO78uGq0DGfmyWs3X+wjLAmTCVtcgElTmr5/tLWxZkX88okzT5UA7Sinqc/1CyV35PAlHgyG0GgTRlEiBTXR/RAxKjKoO8DcQ8XQYe6ww9AbEPta/FrVrTik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785403084; c=relaxed/simple;
	bh=DVHqCpFjZ2o39iKmXRipS2NIEkXvN49cuQUWKy7sr5I=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uRNdcjiqMZI60LpJGiqSSjpPBUK0dSlSH/4I91BxrwfOSbk7UjElke4O8cDR4Ekiez+aGTpEfbxUxE8RjnTx0GolrBnEnXkHR0RgP5qJh3Tzjm0qXlh23m7iwkjFehuw4wm7SmCwzRSWUPvuIOFoV1FaUKOsgIKDWCWVIrecdZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=fail smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=iBMCkw0X; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="iBMCkw0X"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U85ugH3534465;
	Thu, 30 Jul 2026 02:17:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=8ZjElzyOMnCFvT20qn/i0XrqmeFR2FECF6E9XB6WSbQ=; b=
	iBMCkw0XuCIowSrbQjBsAY+ja7QLQTEppJw+5HFcIU3MjOQFMXHBZ+5o23gskPdK
	OZRnm05fAoYE+rxAm1LsexZdKEkmmGSyjngCtE/gQH2T8ULQd1Mn/W3PWii2Mnqs
	/qA5wGLGxDzfTm0vM8o01NCIeRret3ADrn0QVzHjS3AyyWARjHQpJGWwZ46uwnpT
	le0eNcYd+040yfYlmFZYT8vB9S/TAkCnCq8w5TXIhnpVSVmzJ8DAKVzTzkvwNM95
	4mJ0q11ZKDQtUyLQZpkjdqDh70plP9/TeUEMOYHYgkgQiS+kpvvE2dBAWC5+53zg
	2EUB4EiFdUD8aKSSoPLP+w==
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010028.outbound.protection.outlook.com [52.101.85.28])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fr2t6r2eu-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 02:17:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bm0bCvQ4nE9t2wXT4JPPfAKVH6EgyV0yoKlQSqf6MXV1rZADkMirB0bSCDP5+N+ATBW77bUBTGikEmjtZDDfiA2D0WraFieQLOxBYsqTe6DFl54DIduytT1TS+w+wH5S9OtcohcWyVhFYFC5ObKQlHoYIRUfFM+tVE8nL7zoKaLqNOzUlFqr48krVhGgJyHR1EwhyavtcdH4use0tPDKXNuGHUPG1RernN2oMjFndvt6Bfp2arzQ9TDSH+Xdj8TU8FyTCUDnla4O6oY8lc8EYMMER21BdKqDHqvM+sjyllfMoIRAeRLN/33X/cFyKdtLplCFW8uF4pAgefCkV0rSpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ZjElzyOMnCFvT20qn/i0XrqmeFR2FECF6E9XB6WSbQ=;
 b=sFcAEdzJ2tHAR8qqQuQqR+4YcLedWnElvBL05ZYU1dLZ2fHJa41zwjenRK2soYzEShR4D+vMc8KncQ4mt3AlavbNN+XGSLxTMZifRV5gjvSvCMgwL18T6ekzbG98ih/tKDEQeeNWicFE0KeDt2uRsLHa36viU78GNlyFDhZBsgG9aiRbgBloDYHdTlEDdQ3f3ttT3xi330ORfEcQ2sfbtDDJME3O/fIN2CU136gKQOxD+WJYrN9TwxDMGajdh20PURcIhYrgQAnnH7tVK0my9XrpVcvrx1DknsmP0dtAb/GaaD5DDOzNhdA3frLlfkvy3jS/rB21CiNFB2J307DNmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by IA1PR11MB7774.namprd11.prod.outlook.com (2603:10b6:208:3f2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Thu, 30 Jul
 2026 09:17:32 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0270.009; Thu, 30 Jul 2026
 09:17:32 +0000
Message-ID: <3abfa19f-0273-42d3-93ce-dcaebdb1166b@windriver.com>
Date: Thu, 30 Jul 2026 17:17:24 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] xfs: don't hold buffer locks across sync transaction
 commit in xfs_sync_sb_buf
From: "Zhou, Yun" <yun.zhou@windriver.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Carlos Maiolino <cem@kernel.org>
References: <20260722133844.2900030-1-yun.zhou@windriver.com>
Content-Language: en-US
In-Reply-To: <20260722133844.2900030-1-yun.zhou@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SEWP216CA0022.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b6::19) To BL1PR11MB5333.namprd11.prod.outlook.com
 (2603:10b6:208:309::23)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|IA1PR11MB7774:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c0467ee-7732-4a05-3b9a-08deee1b626e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|18002099003|22082099003|6133799003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	hkYOKC0LlswwoxwPzeqIoC1sAF2EpTiWQdqsCvgetrxGCuAo9XGp32+MB+JBzoKjQKYL0B8j0dfKJ/1QrQcxb1f+RlIGeRw4WoQ/XSQ5TJXcpS70ojdDh/BPADN7sH8CnS2ORpKLX90FyHan573zmCPuI7U5AoiFuJAWCMl5yju0dBhp55Gwaj7K1NU15UW9nSiNvJyiApiza+Rq9oenh/8GmB9qn7qyRQaglPawKlFID/IWNBWMBbMm5e/Fgv44ph34UPlOk5fuC9ALFFSh1iP762Nl8yLr69k+FzRRDcrsf7NpHUcNrFeczKFQr1+td1fFe5IIoz7lAvJ5F46844XgwH0BfhzdlkQwjSE90kE4ObuHc60zPxrsJjkK8doCVKuN9RPOWlMyvP7FeimZrp/f/ohIo4+4Oqjt5Rxlm2O6CZ7vbhigE8LtEQc6m3p7h9NaNn/sGdsox+toPfmGwwLNK9Ypxh8W47YG9YMtukKkebnDHNWwkYaICuePjBKOKC80LL0p6SuJZ/c3CPTUprD0arfAtkw7OPzR5WCEIQeHbKTPRsf8FK9qPP8Biry66TXhtnpAqGojQ9Pwo77yHj6l5OmKLMhsYX+qEtua9YZIL67Y4aPmG40frrE1mvVJ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(18002099003)(22082099003)(6133799003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WjU2eXY2M2lERjl5TXZvbHF5NU1IOGozSmhhTk9wM2VsNnBUYmcrSE9qMVAz?=
 =?utf-8?B?bDdaZkhDYmxHVGhoSUFtSjc5SlhHc3ZVbjhTcnMyMFB5QWJXVW9OMkVEWHpT?=
 =?utf-8?B?VC9FUy9PMXJWcHpmbjl0N21zcWN1OXBJaVIzeDBVL2FXaFdrYjNJSTBUbWp0?=
 =?utf-8?B?UEdEWmhYWmVHaGpmcUx6eUMrVjZyMEZ4RzdBaXVKTU8rMVErOTlYWm9UbFFS?=
 =?utf-8?B?TjJTRkNrTVV4dUNQd2kzQzh5NGdRaTF4ZVp1Y0FzQVhXZ3ZXUWtLQXV1SXQ1?=
 =?utf-8?B?UVB1aVo3QTRFdUI2ZHRFU1BrcDZNMGpNSm5HaE1USzRmNzNGb0t0TXZoa2Za?=
 =?utf-8?B?OEdYczBsYnJwaWw3UnREdHRjSWp5aEVsK0F0R3QvSUQ5NnhTSEVGRVloL09R?=
 =?utf-8?B?UllrUVd2YjIwdDZyNzRjRHNQUjJXNHNsMHg4d1NRUGFnMFI5aUhScGZCL2Ry?=
 =?utf-8?B?Yk1Rb3Z3OXdMejBiSW9YS0oxbWg2Ylc4NDB6MjFZSmVUSmdBeDdJMlhmN05w?=
 =?utf-8?B?WTVpS0p6SUFwcG9Dd2xLUTZvR1g2Nm9oOTlyNnlNS2drSHZyVGFkeTY3QVZ4?=
 =?utf-8?B?YU0zbUNQRlYrOU9aMzMreDVENFBLaWdUemM5NjMzZis3UnVmdGt1bUNKcW1S?=
 =?utf-8?B?Yk43eEdsWFlXRzBrNTFYbkZUYS91VjlxbHdncC9qN1cvR1RoSFkwZDUwdlBO?=
 =?utf-8?B?MHljY0RRZTlMbHhnWk92RkRza1ZsZTBlUTdsaURjTzduMWpNb053SFlLT2po?=
 =?utf-8?B?V1lwWHRqb3Y2Y0I1RWxiT0hPcTlYeTAwM2dNSHdGZVB6RE1jcjJ0ZkttQnhK?=
 =?utf-8?B?TUtkYTNjaUJwaTFZVEZnTzdvNGMvbDdpTTRGeWpHMittbzJjSGRXcUJ1WVVC?=
 =?utf-8?B?OXYvRnA1VStlTzlyL1kwV0pOZkE0MG9EcmJaUTZOdXZsd0tvRWVsZHMxdXlI?=
 =?utf-8?B?cDF2czlrbTJ6UUluS1BZNHlFUnpvMCswTFAvRXJNdTZBY0tPamVrcTRja0lB?=
 =?utf-8?B?SGs3M0hNNUpaQWZ0M0lRSkFyNk0xVWNFZTVUaVJjOUs1Ty9qTHlVOUpIcGhi?=
 =?utf-8?B?bUZzK3FXM09qenBRcStrb0tRUGtzNHY2bnZuZzJ2cjRtWUg1b1pDMGE2QldK?=
 =?utf-8?B?VWxOMVdyWnNlTWRuMXVaQ2UrQ1ptSG5HQXpxcklrdlV5M3Z3SmtDSVJvUHY4?=
 =?utf-8?B?Q0xvUUZ4dzVlZitlYlY1ZFh4TmhjY0VZVGYxMHV1cGxoSHdZeFowWSszRUI0?=
 =?utf-8?B?dDBDRExvaTFWREtwNkNVRlEza3NMMzh1QmtwR2psSU1YNGtsV2pwTmp5eXMv?=
 =?utf-8?B?dmdEMVYyOXFBNG91SEoyYXBwY0VZUXR2cmNzNTZkbERWZDFFd3VJWUl6b3VI?=
 =?utf-8?B?ZnRwQitzUkNTemYwMlJlMzVDZnRyTWdEL3JOeW1hL0JNNy9FNkdSUUQ0dmd5?=
 =?utf-8?B?UUZ3Tm01eW1VTlRhOC9ZQktvakMxWGdFZ2JrVTJ0MC83aVgyQkovK3YwemRo?=
 =?utf-8?B?YUFxaVNzZThJVXBNYWNmdDR5TnJKbmlvdTdhZUVzQnBHaFVUU3NzWWFSQWs2?=
 =?utf-8?B?QUlkeDRkRVl5TXQrRVVaWm5aRGh5bjdHeWZQNnh4UU9yYnd3N1JFWGMzaHlH?=
 =?utf-8?B?dFRHV2c1YUdIa3hNSmZodDYxU1ZqTFZFQXE3YTkvNHlUWjBvbGYvZ1ozaDFO?=
 =?utf-8?B?MXZjMzRvOHRqQTR0RDBMTEVKa3FTTFdPM2l4dUtvQjlGK0hkVGRzRU1nLzNy?=
 =?utf-8?B?VDByc1RuZlFIcEgwV09xcjdVWng1UmR4dlFObjlzMFRRS3MyZkpPeTQyY3pZ?=
 =?utf-8?B?ZVBNaWF3aUpwaHRqaUVMYVlyTGZaRlpueVRqTHlsdGJncGxpTmk3NHk0SHVP?=
 =?utf-8?B?Wkx1bUlaY09qcHg4WDJHa0xOYTZPaXhQL2RiZzhPbDdxR29iM3RWTk84cFRo?=
 =?utf-8?B?VnVXZTh4b3I4aGQ4MWlZLytTU1ZlNUw3RFdXSnZsTjBZQ0o1VWVkT0pGZXp5?=
 =?utf-8?B?MXhESzBVcnVScnQ1RFdDcG1UTGJJcHFtdnpTS1dwUXA2T01zcnRsc1doVFA5?=
 =?utf-8?B?QlczbHZSUG5tek04TlkrbXg4VTZRSWJOYXEzcm1VbDAyMmdjWjM1QVowUlJH?=
 =?utf-8?B?ck9JeFkrRURZVitIM1pvOFM3RGo5ZXlaTG5lcllWaENJU25wM0M1eGxuVzA1?=
 =?utf-8?B?a2ZoL1ZkZlZGM0RJRGJIc2ZtV2pFYkNQL2o1Y1Bva2dielFKcDJVNkhEaDNs?=
 =?utf-8?B?TzBwUFppVmJ6dXhtMHIxN3pxbDNPSWxQVGJFcVpxelZYUzBlSHIrWE5kSGZL?=
 =?utf-8?B?VE5RSDJ5V3NqUmQwY3VhQTlvVG5jNE5ES2F1aHhwbUllN1Y4ZC9vdz09?=
X-Exchange-RoutingPolicyChecked:
	Jm/6ou54FNdc1gGJvhuzJUPUn3+E5XbqdppuMr5avd6kN/9Q0CyvhDHMfRsCR5Qe5yjH0H4FKHNFyTyE/Tufk+w21w3Fd6ztcHZprKoYs4I8EXcpVnh9094jtvBn7O/fh+KXPz7B45o01iVLFRAOpM/vm/8eMbPQuLip5oRhxYxLfmlAI9bnS2yUlmeNBwQfWK5yTj/QC5skAVV0BCcsboBt8Zht84s3phFGiMTlxQRcspPAc014H8fJ4JQQ2KiAcUhIOTZmzMw/f0iGjC3MX2h0F46TG68q7vEXS6VYhC3HiS4SVcBFaszu+s4xa4t8IEeXuBQwVz85vuNhGvrPeA==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c0467ee-7732-4a05-3b9a-08deee1b626e
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5333.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 09:17:32.3304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JwAyuJE1TnvCj1IxlQ6EGCWulr1Edtmlw1N+jLa6Ulpc2YPfcnQwVd01xFEfa3GX6j7YP7pupjigjnfux3mjVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7774
X-Proofpoint-ORIG-GUID: 98rdftMBVTtpIK-5Z42FoEBbZ8zHWG-s
X-Authority-Analysis: v=2.4 cv=bY9bluPB c=1 sm=1 tr=0 ts=6a6b16af cx=c_pps
 a=mniIB+Hk/8HPdz+5sH7poA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=HK-ge7EqtdluswH-FwHe:22
 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8 a=t8zTbzarqOMVmqVNsMUA:9
 a=QEXdDO2ut3YA:10 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA2OCBTYWx0ZWRfX4ij4lmr0Z2qR
 pyy26cHt42YO93x0vfS/1GPuKtNULXrE5/v0Th0noXsbzwz1T47LUvtUKnyv9T+uhtlazjVannq
 A69mJ2qCRcEX/p7F6jQArph6PieVljpeXA4/t9EE1mLBvPkHyJ8u
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA2OCBTYWx0ZWRfX/mdY7Ao5oF0N
 1hnHADHYW7rPkX6d1Iq29BKm3U9Iga9WGkpSIMeyR0MZTLqZonlxvdZvJye2QaJ/NoKqB0VMF3l
 FDDFVAUo0kL1+LKoBUT2qthptTMG4e+OLl3+2zBdnscxb1894X1sCvU2G6ZpTLtVtMMyntdS6n0
 azzWPR/Io19/IqYDcN3XSkEczSUYvwfvO6ybSen1WzMLn5uUN9dkAAjVEUxDy7ZHKl6+qNSP0bZ
 GukIO5lgohLcuIaldTSOc0Lz4zM1jegWRqL9LV0rW3kpXUD23+NsB9xBuzTq0e9odgDKkkkgSl6
 q08QohHPMYL/rsENyY+DIs/wxu1r005whZhqzjcSrE6VWuZJZvVVQoKiQz1KKU3qgRf7Az+WsXj
 Qn1rqNOqtf7jhv7GPxQmfLld+8ASop8U0zxbv/QnGAVs8wsG089dVoIypoKj4HZ1l9qHGBHg0sF
 Y5CRkrUVUtTJ7ftITjQ==
X-Proofpoint-GUID: 98rdftMBVTtpIK-5Z42FoEBbZ8zHWG-s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_02,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 adultscore=0 clxscore=1015 spamscore=0 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300068

Hi Christoph,

I've addressed your feedback in v2 (converted the stub to inline 
function). Could you take a look when you get a chance?

Thanks,
Yun

On 7/22/26 21:38, Yun Zhou wrote:
> xfs_sync_sb_buf() holds sb/rtsb buffer locks across a synchronous
> xfs_trans_commit(), which flushes the CIL push workqueue internally.
> If shutdown occurs during the CIL push, xfs_buf_item_unpin() needs to
> lock these buffers to fail them, causing a deadlock:
> 
>    setlabel:          holds buf lock -> flush_workqueue(xfs-cil)
>    CIL push worker:   xfs_buf_item_unpin -> xfs_buf_lock(same buf)
> 
> Remove the xfs_trans_bhold() calls so that commit releases the buffer
> locks normally.  After the sync commit, re-acquire the buffers via
> mp->m_sb_bp / mp->m_rtsb_bp for the on-disk writeback.
> 
> Fixes: f7664b31975b ("xfs: implement online get/set fs label")
> Reported-by: syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=837bcd54843dd6262f2f
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> ---
> Changes in v2:
> - Remove the bp variable and pass xfs_trans_getsb(tp) directly to
>    xfs_log_rtsb() to fix compilation warnings when CONFIG_XFS_RT=n.
> - Convert xfs_log_rtsb() stub from macro to inline function to avoid
>    the need for (void) casting (Christoph).
> ---
>   fs/xfs/libxfs/xfs_rtgroup.h |  6 +++++-
>   fs/xfs/libxfs/xfs_sb.c      | 39 ++++++++++++++++++-------------------
>   2 files changed, 24 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
> index c0b9f9f2c413..fca2eb74908c 100644
> --- a/fs/xfs/libxfs/xfs_rtgroup.h
> +++ b/fs/xfs/libxfs/xfs_rtgroup.h
> @@ -359,7 +359,11 @@ static inline int xfs_initialize_rtgroups(struct xfs_mount *mp,
>   # define xfs_rtgroup_unlock(rtg, gf)		((void)0)
>   # define xfs_rtgroup_trans_join(tp, rtg, gf)	((void)0)
>   # define xfs_update_rtsb(bp, sb_bp)	((void)0)
> -# define xfs_log_rtsb(tp, sb_bp)	(NULL)
> +static inline struct xfs_buf *xfs_log_rtsb(struct xfs_trans *tp,
> +		const struct xfs_buf *sb_bp)
> +{
> +	return NULL;
> +}
>   # define xfs_rtgroup_get_geometry(rtg, rgeo)	(-EOPNOTSUPP)
>   #endif /* CONFIG_XFS_RT */
>   
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 47322adb7690..929677ad95b4 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1470,36 +1470,35 @@ xfs_sync_sb_buf(
>   	bool			update_rtsb)
>   {
>   	struct xfs_trans	*tp;
> -	struct xfs_buf		*bp;
> -	struct xfs_buf		*rtsb_bp = NULL;
>   	int			error;
>   
>   	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0, 0, &tp);
>   	if (error)
>   		return error;
>   
> -	bp = xfs_trans_getsb(tp);
>   	xfs_log_sb(tp);
> -	xfs_trans_bhold(tp, bp);
> -	if (update_rtsb) {
> -		rtsb_bp = xfs_log_rtsb(tp, bp);
> -		if (rtsb_bp)
> -			xfs_trans_bhold(tp, rtsb_bp);
> -	}
> +	if (update_rtsb)
> +		xfs_log_rtsb(tp, xfs_trans_getsb(tp));
>   	xfs_trans_set_sync(tp);
>   	error = xfs_trans_commit(tp);
>   	if (error)
> -		goto out;
> -	/*
> -	 * write out the sb buffer to get the changes to disk
> -	 */
> -	error = xfs_bwrite(bp);
> -	if (!error && rtsb_bp)
> -		error = xfs_bwrite(rtsb_bp);
> -out:
> -	if (rtsb_bp)
> -		xfs_buf_relse(rtsb_bp);
> -	xfs_buf_relse(bp);
> +		return error;
> +
> +	/* Re-acquire and write the sb and rtsb to disk. */
> +	xfs_buf_lock(mp->m_sb_bp);
> +	xfs_buf_hold(mp->m_sb_bp);
> +	error = xfs_bwrite(mp->m_sb_bp);
> +	xfs_buf_relse(mp->m_sb_bp);
> +	if (error)
> +		return error;
> +
> +	if (update_rtsb && mp->m_rtsb_bp) {
> +		xfs_buf_lock(mp->m_rtsb_bp);
> +		xfs_buf_hold(mp->m_rtsb_bp);
> +		error = xfs_bwrite(mp->m_rtsb_bp);
> +		xfs_buf_relse(mp->m_rtsb_bp);
> +	}
> +
>   	return error;
>   }
>   

