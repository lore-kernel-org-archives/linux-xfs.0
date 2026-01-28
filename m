Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azolkn19012047.outbound.protection.outlook.com [52.103.23.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B074C34D90D;
	Wed, 28 Jan 2026 09:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.23.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769594112; cv=fail; b=FKIgQELp1UloV+Ks0bZqWZ24UsQnB/GHPpUleeBoG8dsEn3OfQ6aF7hkXYeG2WDFAXkhCSmUeQ/yr71Osy9Ujshk6iYhNqDTcJVwRhAh30zXEPVa/4cXr5qXtdYCGuCvMYKVu0NEO+l335NeKc8WnqUq1asQrPOm+X+fgNcSQRA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769594112; c=relaxed/simple;
	bh=pP2qZuZVm5iz8LxuOmmJnJcat9oB5G6KbeTBbfAoC3M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ILMR2vXDGzCkk0YVKzmn1IDsfkQQiMk/VkTS0cZ1dBso31QMfJnIkmBYWfXcf2JjwLBH+JSAYmrOEighjq3CG1cUM9eY4nh54A0o7MqJqWXezoigFqnW0J3HjDsiA9P3bMqpxmJTTBHsj++y77mbwVudYhzJlz+t+F0gNofl40o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=tMuqlQrQ; arc=fail smtp.client-ip=52.103.23.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="tMuqlQrQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WwY9iOe93gipOa0PdhE5V2Pi5RsQAGxi3jPibApy70GpfGHWvgcLWycm3rhk2uGt39QT87ocGHH675ahUrw83S3jJNhBZ/1dpHP1zuLO1JEKPVp6Gm7w+PrkGDolZIwcumu7elrXxVxVTd6JHJ5TTGczkOG426uTHq5783gXBnXUFRK0SAMiNNNB+fJk2wzB1OlbPSRGdoyW5zVka+fH1E40G5aSyJD86msbP8GP38zhCl0EGgG3dgszJsUEHQgXWTnVJo4fNhgs24tAmAr4TIH0bxv72Z6wxVzSSAP7++xjKvhhlwPVuW4cAnoQBzRxlzg6wzmUFZqBKsfnAeRP2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QsVRpXhf6zGdLKxf5cGPpMrHOMMSneSDQ1AVkTp2Pbo=;
 b=eDxeecLvGjpMwB6hRtRFn6EWKmSEp1OlP85RX9ilWrKOhkE7wJOCIZvEBUReOkn73+VM9uckbOv+yc3/yuH5GiW8p8Pc33sEOvYalv9cxVW627ktJ8rQyllZl9YC+y9NOMWTtF8QMH71+2aerI4Vx+eNdIlu+MeTYmYVgK3AxUFpp8CBZKkR49Qm5OonGSk8caNs9wLuH5ev8gJc5ly+0Ry1ca1kKKbdowMqAJg02yCuaS2yJmZOokY2ZPakqlyjWFeU93CAtm1jcHMcZ6y7eR48CMCrpJKWd90JVEPIVyvAWtNobqL2T1bFvbY2dRX0+AvePxpLVPn9qmLMckHMtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QsVRpXhf6zGdLKxf5cGPpMrHOMMSneSDQ1AVkTp2Pbo=;
 b=tMuqlQrQzuvxb3lkyZJANfoe/Ctr5+CpDf7n9a0mdriS4k0HQur7sWBkglFSOjjgoJLJqxVSjVKnivgf+cm8e2Kg8HMjrSbBJy7kcj+nUbzoeyJGALw5lvJHwGGciGgTxZaWT6wjWrV8FSQ4a951GC8deb50wq30gelsgRGLdrE266/8lkoR8e7WCMbKrrZ2RFRfdcfxHdOXYhqWjYqGOEGiopMOVRZpRzyJMua1VtQR8tGzNAi8GByW1IbqlHXXDUTS9yq4g+A4YIw1vOnJGvLBq0tp2d2YegF6JGvlZxJYdfBC1S2Wq0o2DcZl6x3wodFC8wEPY785hrdxaH6+Dg==
Received: from IA1PR14MB5659.namprd14.prod.outlook.com (2603:10b6:208:3a4::16)
 by CY5PR14MB5726.namprd14.prod.outlook.com (2603:10b6:930:42::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 09:55:08 +0000
Received: from IA1PR14MB5659.namprd14.prod.outlook.com
 ([fe80::63c6:55d3:c704:5510]) by IA1PR14MB5659.namprd14.prod.outlook.com
 ([fe80::63c6:55d3:c704:5510%4]) with mapi id 15.20.9542.010; Wed, 28 Jan 2026
 09:55:08 +0000
Message-ID:
 <IA1PR14MB565903564F4AA105AF6A21099791A@IA1PR14MB5659.namprd14.prod.outlook.com>
Date: Wed, 28 Jan 2026 17:55:01 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: rcu stalls during fstests runs for xfs
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 "rcu@vger.kernel.org" <rcu@vger.kernel.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, hch <hch@lst.de>
References: <aXdO52wh2rqTUi1E@shinmob>
Content-Language: en-US
From: Kunwu Chan <kunwu.chan@hotmail.com>
In-Reply-To: <aXdO52wh2rqTUi1E@shinmob>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2P153CA0007.APCP153.PROD.OUTLOOK.COM (2603:1096::17) To
 IA1PR14MB5659.namprd14.prod.outlook.com (2603:10b6:208:3a4::16)
X-Microsoft-Original-Message-ID:
 <8af638fc-ebcf-4838-be5f-bb329007f5c7@hotmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR14MB5659:EE_|CY5PR14MB5726:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ed64bbc-6ce1-41e9-d11a-08de5e535199
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|5072599009|39105399006|461199028|23021999003|6090799003|8060799015|15080799012|19110799012|40105399003|440099028|3412199025;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bWNyaW9VcnFmZXRLTGQ5QzJDU2FiTFk0dzFxMVYvLzU1dkc1VzV5dWRjdGti?=
 =?utf-8?B?OC9lMUxMOXliOUdKTGdCOEZ2YTMxcndtbHp3ak4yZnorL1ArcklaeUYrZHRl?=
 =?utf-8?B?cGFYV09hb3kvQzhKNC8vbFkvUkM5d0F5QjY4VFVydHBDSmh4aVM1elN2ejUz?=
 =?utf-8?B?YVR4UjI1WlkzSlJLL0V3d1FSeWwzQnA4cTRmT3pkcG5IWC8yR2pabk5rODJx?=
 =?utf-8?B?T05Wcm5qUnJMRzNkUFhFSWRBbXBCbURheDYxeFJIZGpFNFNiUmdxaUlLWVNk?=
 =?utf-8?B?ZE5UM1R1YXpWMHpaYmNSbkFZblQzMnhGWmM2Y3pQVDdNVDdoV0xpcWNJYTZa?=
 =?utf-8?B?MEFzY1ZiMThvQWpNdzl1anJPaWQyRFFUd0ZEeklUeVZYTUNid2V4blVPWXVo?=
 =?utf-8?B?Rk5SenZwb0tidUY3S3RaSHpZUTBMYmNoMlplcE1SSUROZGxiY0krMHhaV1Bz?=
 =?utf-8?B?d011dTdmMXRyakc5OFcyS0d4QkRuNUdONi9CUElpVURnZXlrMitLNEdGeEht?=
 =?utf-8?B?cVhaU3pNTnBnU1ZubmVHT2VrTFJiWkRHUkxTMUZxcTZTVzB3YnJZU1BsdUtl?=
 =?utf-8?B?N1lWT1JOZU5WWmRtenZiSm1FWWtCdWV1NnZPVGpxcWxnWWdtRGcxNUxnUVVu?=
 =?utf-8?B?c25SZ253bW1SQUJXYWJHRjhuNFNwRHNBUEl6OExpdkp3Y094M3VxRytXK0pz?=
 =?utf-8?B?SzlmTmlJK0NTVUE4QStUVEcwR1ZLKytNeXNTWWNlN0xSdlBmcFQ0eWhGWExi?=
 =?utf-8?B?NEs3LytNcTdaalpxVFBZTFhSdlBTazZRSFI0ejhXL3l3MUZrNWlGWGFXdXUx?=
 =?utf-8?B?TDltaVlKWXNSMFJMTjVvNjRxNTVvdTFuM3VlWENWb21Vb04xTUo0UWwrMUNS?=
 =?utf-8?B?eTNEalJLeEQ4WDlXVmRvSlEvcXZsOEVXQlRjN0FuZXpWRk5mSlROOE8xSTFY?=
 =?utf-8?B?L1FsUkpFbVZNbzY5ejNRZEdZcklnSGlFcld5WUZIaElyaEFuSkxEU1ZQbWRN?=
 =?utf-8?B?aXJFdnppZmRkM1FEMWV6VWVGTU5PTk94V1VQOWI2UVhvUzJtSDJxVHV1OENS?=
 =?utf-8?B?Vi80aDEwWFk3ODdJcWdCNEVBN0p5bzdPeHpOVU8xVXVPN3BkbHpEdXRwdnIw?=
 =?utf-8?B?SnJtdXhoNDZOQ3ZLVHQyZ1JZanZnWjRJbllwcnJ6WkZjOFVVcUFCN01RczZn?=
 =?utf-8?B?SS9CdFo0U241R09CWTI3dnFuSTg4MUVoclVmS2JtL05iVm9rb1N4dmltZDk4?=
 =?utf-8?B?dWdENy9udXYvb2JXb3h0SmlMUVVJRFZoRmt6ZzNTTnlLeHM3blNCOW9YZzB0?=
 =?utf-8?B?aEFwRGhucFpyeVFzNjZLVWg0eGJGV0V3Ykd1THVZcUlvN2xHb2hLdDNKbFky?=
 =?utf-8?B?a3h6SVlmN09QWGhKNTdZTCtpUHNEeDYyYlZXcC8rcHF6L1hJM1NhdEFBRUxO?=
 =?utf-8?B?OUJuRGZBRkU0VWdzWUhUQ0VHOVArUFBOeHpZWGpjT2wxSHJUckhGd1gwTUtm?=
 =?utf-8?B?bjZHMEttT3BuOXJObU9FQklKdXBjM3NoRW42WGxHdUhWZHQ0d0FyR3h6UHhX?=
 =?utf-8?B?ajRSYXV4eXJIQ0lHb0tqcis4cEd4M3JNVzNlL0JaVHZCaFMvOFlMNWZWUVYv?=
 =?utf-8?B?QjBHV1JrTXpxbVUzUXIzSlZTZmJtMVE9PQ==?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZEpnWXppblJWT0VtaUtNNUQ3UTMyeHdLc0tiQmJ5R29qQjhBVzlBc0VncUQv?=
 =?utf-8?B?bU1KOGhpTU1tWmxneXpOb2M1cUt0RlhMS0N0S2FsbGZmYWlZSk5DZXp4dXJs?=
 =?utf-8?B?Y2hkVXUzZTNmUDZnOUlRdFBDOGpRNUJnYVpIY0hxT3p6dStvZEU0TUJ6elVD?=
 =?utf-8?B?QmhVV0oyeXdVdVVNQ2lGa1dmS0NlZUpSU2pQZWdtWHVnOEllYXJ2V3gzMWRa?=
 =?utf-8?B?SXlPTlVLc05oYklUbTRiVG8xSERKNlQvZFRuTDhMSVQ1aldnTFgreS9RMFA1?=
 =?utf-8?B?ZjNGZUdndDNHUWQ2T01KKy83SDBhVGtWbjVrSC90bktpbHRtcFBCUmk5czF3?=
 =?utf-8?B?Q0MzMnZEVHliMnRqc3VnLzArVUU1N2FsclB6TkdzNC9KSkpKdHQrNk96YitB?=
 =?utf-8?B?SW1DNkh3SVlOU2ZPTVpYYzlEZ3BZaXp3enFiRlVTUFY3Y0dkeUxsYWtLNmNo?=
 =?utf-8?B?b211OGJ3SFp5L2pqcm9ycVBPZUpsbVNBS1dBUWZFWVJPam1CS0ZiaXBJeWJq?=
 =?utf-8?B?eDBtRnIyMkxoTmpuM2pIY3U3N3RvMkptelI5UlExbUZtSlU4L3hzVy9UcTdu?=
 =?utf-8?B?U1Fka1pRMmZtNGtTQTdvYmttMWc4dVF3Z25Eb3grZzBOcVBHZk10ejdYbGFk?=
 =?utf-8?B?M0JWKy9iNDlMeTdUSW9qV241U1V2UlRlSWx3OXRMUlRrQmVPK01Kby9QektV?=
 =?utf-8?B?Z0Y5dEhvbHRPRUpvVUc5bUo2akJ4TTUxKzEvVSt5eHNGVStMeFEwckgxdUky?=
 =?utf-8?B?WVcvWUkzRXRjNHk1bVFxMklYY2IybFdZazE0VjE4TlYya1AxeFBxS05VR1VU?=
 =?utf-8?B?TzFGcVpOa1lCYnJwUkgrS2x6Z2pzV2lYbzFENUxMWUlQUm1kRlJ6N0NHRlNB?=
 =?utf-8?B?dnJhdXc1RTRRak5FSk5INzhOQlZLeVZQNzNocWwrdnFHQkVRdlJBclpnU2pO?=
 =?utf-8?B?b0R5Q1J0ZmJtMW9mN05sQU1NRi9sTXVkcUMzRHdOWVJMcE92SmVDSXBxWkg5?=
 =?utf-8?B?cVRiOERDNnhVaUJCSTJzRjVFS25wUjdnek5KMU1ncTVGRkpJUWV4NTFVbEVz?=
 =?utf-8?B?VDJCN05yTmNnS3NBWVZtUWVndm1SZy9aaDNpY0R5bGtvWEtiZXhDdHZGd0RD?=
 =?utf-8?B?d1gyOStKZGo2NHMxdnNjaGFwQ29QTXR2aUVrZzkxN0ZhMnVQdS9jWEs2Umta?=
 =?utf-8?B?cit5RHJraWl5aTB3NVJXUFlPV3NrQS8zTUhMdUR3VDhrQVpKUHJUTGhWcm55?=
 =?utf-8?B?SVkvanYzVUFmWlRYbDRQUVV2SWdOanVicmpoTjFrbUZ4WllUWVhGbWpuQ1RX?=
 =?utf-8?B?YjZLQzhndnpWRDVEKzFmUGdNRm5OdHZmUGNDcGFjZjdaWGVOMldjWENJS2l6?=
 =?utf-8?B?M3d6Y2RobW8wTFJIR08xTFZiQisrMzJKWGZWMGRCYTR0blMyblRWMHR0SC9T?=
 =?utf-8?B?WjNZaVIyQWFuNTBEa2hzYksrdUVSWXJsUVlBQ3BJbDIxamdMenBEQ2xiRkZh?=
 =?utf-8?B?WjdrcmFpWFNFMEJIWGZXeHRkTFpwVmFCN0I4enZCRzlVdlBUL2l4T2x4dVdI?=
 =?utf-8?B?K3pFMm92bEQvQUdzbzBTVFR0TTYvUUpGdkRxQStGT1FDUCtoRVNrVytFWUxz?=
 =?utf-8?B?UEdTRld5OFgxTlZnMFN1NDF1TS9UY0tNRGIxMVpzYWpISzJGZmxkQ3pKNlVY?=
 =?utf-8?B?NHZ2VTB1VHAxaGFFc2NhajNaUHNjN0FCSW5ZWWVHaTNNbm1FcmhiM29sY3ZY?=
 =?utf-8?B?MmQveUU5b2JjdnlhUHlOTWhqUXhDRkY5MVZYSCtpcnRYalBiRjdmOEF2Z0JK?=
 =?utf-8?B?Z0I4NFYzVldZWStjUmpCMTk2dHFiVm5sb2hmbStlY3p2SUQxdEV0VjljRmts?=
 =?utf-8?Q?YriNTOTbGPWTi?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-71fd1.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ed64bbc-6ce1-41e9-d11a-08de5e535199
X-MS-Exchange-CrossTenant-AuthSource: IA1PR14MB5659.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 09:55:08.5666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR14MB5726

On 1/26/26 19:30, Shinichiro Kawasaki wrote:
>  kernel: xfs/for-next, 51aba4ca399, v6.19-rc5+
>      block device: dm-linear on HDD (non-zoned)
>      xfs: zoned

I had a quick look at the attached logs. Across the different runs, the
stall traces consistently show CPUs spending extended time in
|mm_get_cid()|along the mm/sched context switch path.

This doesn’t seem to indicate an immediate RCU issue by itself, but it
raises the question of whether context switch completion can be delayed
for unusually long periods under these test configurations.

-- 
Thanx, Kunwu

