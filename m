Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01olkn2018.outbound.protection.outlook.com [40.92.107.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1795D56B7C;
	Fri, 28 Jun 2024 23:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.107.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719617512; cv=fail; b=N3myJAhuleGORu+AA5xXS9jTjXlWvW64Q4kPnViEChGYoN2IbPpWgXlVVHGY+32Hn1nsJGLknD/4sT2oGwcwcHw9bXJVrWF8GqZQgcG3kv0xseGj7RMKlI3pAwmtDUI6Zgitl1yPpHZZNBE2qNEhiMlzr82ZmD0IVXGdeN76I04=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719617512; c=relaxed/simple;
	bh=NmVzpJrpDmnKW8OnsJV4CWwI9/R3rr3c5pc9IDJq09s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tzyMDIVup5SCCrahHvLoqEM8KR7c7CRJB1ke/lunqVlfTbxFkqXOKhw9MVr0CVJvHbcS19AnBdFGIjWIvroYmX4x6BmJErPQ1hGEurT7AuUFg1gVRQGTWp6xUvAEtUXsjZQzpw9UpzvqC92I/0zTFjXvNFN3l7E+ctjTvYW0eZs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=fuYfYqZn; arc=fail smtp.client-ip=40.92.107.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="fuYfYqZn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FYyCi1fDQ74pop1zwi+vMuaechnhqCPOI+0Dqzyuaw+fRqAqLCXsyU2mtVMtb1snLMc5t44Oj6Zy7dnhxiAdKDdXyaDD+ZBiHxwF5T85s72bjFmfdnq3m51tm1gw/lJSsIKUX5wy5woxQjGYutcOKVsNwkdsliq+MNh6wm15OKEE2e3eCd80+BcvgMdMdIPc4zXEdcMuaNYM/CvL2rG/hM4MZX1pZAgtsPebaX/BidQfC2JY44Q3UfVG+Ug4I8+kJdHX7bWUUQ/O6F+CecjTpbL9Vgqx91ywsJFm/jbwiEUW8Fizis4x+9y8/1UQvSc6tY9NMMU3GkY5EIfprlUeVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ROvhCBxmW+Rns4scaWgXdHlwkaAwdafshuOABG15Mg=;
 b=V+GfKB0ZvonpkS5RbTkBfRnCeuqYZXnjoP6VCWHufd0ARqsZV6sJ6SNLPvNj4B2rYOEUmRAzhNd4niIKh23q8u4QQondY3m95hBzdVqtJ9KAZgeQ4hpSFtj6toQE6fA0hERrwWO29tqXO7IZM747b02GQTHB6r4ZMnvmFxXJbIQ9/OkCi7a88EhRR/Q2tJ5wbU/1Cze9Y994nyY9iUPttNlcjMqXBRIPHxUFbM6I3VjxidCqLn3TnH/lOpQIbLUmMmazQQZCt/WbqrhRHduisEhDdgdf/IHSci+lcWYyh1PwzqOAqNZLfnOLMXSioQsZQ8pzqT/586gNDfu1n33GvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ROvhCBxmW+Rns4scaWgXdHlwkaAwdafshuOABG15Mg=;
 b=fuYfYqZnJyWNW33ImQeJEq39ie95iGGbBFfu9THmJNfnRxRKvkmr5E2suNqAiTolA0vvFxVeUxlFxBejsEHUxf+dH7zhalo5Zpp+wIXu/41u5yZ5oXnxk9+VvV7XI22XOvG/sU0nN1j0XFqo6RYLH1DEXySyZ3+P/YMh4Y7v6JCzPwjc/u5bl2h42wA1uxZ5KihAhon3tY7Pb4eoKvPVRhwaTeV0MFMh5Y1loNIUVOiw/q19HZOmxpDYbtarVsQBDoiI3EJK2Ymn/r37KevYo7bOFvCuGy+eiwKHIPHXQ8hGY3K5QnKrw6sH4LJ067m3UHRbj6b7MXJNctjkP8/e7Q==
Received: from SEZPR01MB4527.apcprd01.prod.exchangelabs.com
 (2603:1096:101:76::5) by SI2PR01MB4154.apcprd01.prod.exchangelabs.com
 (2603:1096:4:1a5::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.26; Fri, 28 Jun
 2024 23:31:46 +0000
Received: from SEZPR01MB4527.apcprd01.prod.exchangelabs.com
 ([fe80::653b:3492:9140:d2bf]) by SEZPR01MB4527.apcprd01.prod.exchangelabs.com
 ([fe80::653b:3492:9140:d2bf%5]) with mapi id 15.20.7698.025; Fri, 28 Jun 2024
 23:31:46 +0000
Message-ID:
 <SEZPR01MB4527EFD6E677E5272E999B11A8D02@SEZPR01MB4527.apcprd01.prod.exchangelabs.com>
Date: Sat, 29 Jun 2024 07:31:40 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: add __GFP_NOLOCKDEP when allocating memory in
 xfs_attr_shortform_list()
To: "Darrick J. Wong" <djwong@kernel.org>, Eric Sandeen <sandeen@sandeen.net>
Cc: chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, sunjw10@lenovo.com, ahuang12@lenovo.com,
 yi.zhang@redhat.com
References: <SEZPR01MB45270BCD2BC28813FCB39AEDA8D72@SEZPR01MB4527.apcprd01.prod.exchangelabs.com>
 <9b8357bf-a1bf-43d0-b617-030882540b34@sandeen.net>
 <20240628170118.GD612460@frogsfrogsfrogs>
Content-Language: en-US
From: Jiwei Sun <sunjw10@outlook.com>
In-Reply-To: <20240628170118.GD612460@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TMN: [nRJG4VMPdXIQW9Vm8F+v7QesxDfaTBT5]
X-ClientProxiedBy: TYCP286CA0062.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:31a::7) To SEZPR01MB4527.apcprd01.prod.exchangelabs.com
 (2603:1096:101:76::5)
X-Microsoft-Original-Message-ID:
 <39f75937-74ef-43d9-88f6-995377be3a61@outlook.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR01MB4527:EE_|SI2PR01MB4154:EE_
X-MS-Office365-Filtering-Correlation-Id: d262ff1e-584e-4bdc-1c36-08dc97ca7981
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199028|8060799003|3420499032|4302099013|3412199025|440099028|1602099012;
X-Microsoft-Antispam-Message-Info:
	IVp1a/sIwBroOjlU/Koc3QXl44l6JFQ2X3PsdbaXOlbcT5+GPUWRoKWUcBaemKmVFJO/SnwMZNSXmQLUVey6cr7pLvI/cGl/23+w4g1f1UwKzKdatWs9nkj0eeWvgItrzXm3B/Wk3HIn8qUJsPvXt2+cgFKFQMpfGWNWO9CN0EEIyUSwWULmAEuFNzsFJxobOA75+Qno5XFRpYQGDQ2uFVW13ebo56Dov3OGQBtuWQwqed64EonFBBiCqf/abnHJO1lIWjc6LjicD1B72Ht3cO8fNm5F1a0rEWPFx6snY7mY0EX19wI3VB8HndkK6EnVBfeup8qY13tnkrd29mVCjpyNCZ60lcZlWd3c/OYktgEojnIlYpI0SoYUwucr+DPI0AdQL0nXb0VJpCcLrCG/ZR1M0psKE2sbqA1W9sVgqi5S0Fe52dyqLZfvQZxmYERZGWMUOp7ZSkim+0+Amx0KcrZD1Gxjq9PnoyDctEFzFZ52B0oY4om4pwTOeBfDP1QT6lx/FN/jc8AlbiAe3BQy1EoZQh6f7FWGBwoaVtZj6CWVoNVsvtseVFN0+YypvLplRyP6wtxVN+PvejIPQ10+ibvJPZMOe4Tevh45JNmaRMbWeV/f/rFjmB82YzSzk4fNrf9lN2U5uUTgwrXuYa10aJ9xVpnBC43Qp/HKcuzFLXFShfT6ZcpNBpSMbRHUpoOi1Ci3ZFs68gLLL3FGLcDP3VeoxEEasjBu4wE93C+eaIU=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?em0rMWsyREVHNTlpY05PSGxUVDhKTStQMjJBVXRGWkEzYzI0dXRrWkVkQzhj?=
 =?utf-8?B?WHo1TlpNTWx5Z0JnWHlxemFQY2VDcUNkQk1rbWJvZ0RvQVNwYU56SVRhbEFC?=
 =?utf-8?B?SGw0MzA3UGE2STdhck13Tkk1ZnljVEFudVpqejNjZFVyNDkvL3JGR2dXNU9H?=
 =?utf-8?B?MC80VS95eFFXZlpFWnV6cnM4VGVGT2s0MUxSSmNMSHo0NmRVdHBURS9ONVpE?=
 =?utf-8?B?Y1M0eVQySTM4Z1NiYWtOSDBGWmtNbXRLY3lWRGZVNGVaNzRzUTRIT0RBU1RS?=
 =?utf-8?B?alg2Z0F3YXJKZVR3RE9ocjFQMzArTHRtOStVV1hoUkQ3VytQZ3ZBWXpBc3Fj?=
 =?utf-8?B?N2xzYUN5TG5HUFRYakR5NjYzbWk5VXllTXBYclVDWG1aMFB3Vk05U1FwZ2Rh?=
 =?utf-8?B?bGZHSHppYU9pK3hBODR4eTRQZUFGLzRqSXhxaWhQN0tWYkc2MCtZNG9hOS9z?=
 =?utf-8?B?NDNFandpODdrK2FhenNNdEtpZFlSdkhnYktQSzMzdFcyQmNEd3BYRlR6eVpH?=
 =?utf-8?B?US9hdGk0b2VQYWFMQWM4MUhsbVpTZlgydngvZ2N0ZndDQlo0YjRWSkM3VHlY?=
 =?utf-8?B?NjRnWVZVc2dJejVHVGJzdXplOVQ2Y3ZCWXdYY2hJSDJYdFVwQnpOWTlFZUVE?=
 =?utf-8?B?RS9tVCs2MWlOTUVFK0xUU2xJVytCYVF4Y1Uwb1k4b0FaODYzZ25iTGFzd1Nh?=
 =?utf-8?B?S2dnUFFOMnF4ei9sNGJ4Q0J0VGhQbldoUW5GdXYvSGdTTGQ5dDB5bFpydFd5?=
 =?utf-8?B?amtKaEZ0R0YrR1E0dUZDMEthZVF6TEZuMGhsQktZQlpqQ1JsOCs0UVdtM2cv?=
 =?utf-8?B?T0QrSDZGbnJwNEEyU3NOSG1WUmYxaFpuWGRFeGp2YkRDRHJEd04rZmc0M3Jn?=
 =?utf-8?B?ZDhOcjBqZHdkMkF5Q0RsQ0pnaTNHWmF6c2dTN1dsZXlUN3NTamVBcC9KZkc5?=
 =?utf-8?B?ZG9yVjBHaFdIWjc2ZmRmRzhyck9XUW0zVVUzcGg4eXhia2x6dk1ucm9mMHNT?=
 =?utf-8?B?Y01xQnBvUlBxNFBIbE5vZWNscXdhNzdlbnFOVHRxU05IVjVTUWdpNjVoRXlz?=
 =?utf-8?B?bTVkVmlxVjJEMmltN0hXbGZRSlRoWjZmcVJlU3ZwcnY0Rmc0c0tjVFZlN3Nx?=
 =?utf-8?B?WVorTFhUdVMwUU5tSGFKY3hObTdVWm4zbTQybU9uRzhuZnBLR3hkakM1T0lP?=
 =?utf-8?B?alhkSERzNGthc2JDUjFzSXl4dTQvM09XbVZrdTNqRldkVWM4U1p1dlZXaXNL?=
 =?utf-8?B?Wk5VaktveXhnS3RNcW5XcGUxUTk3NDJHLzFSVXZZRUY5NnJEYkdUTDFDOSti?=
 =?utf-8?B?Wmo0KzVKbnBrS3lmcWtFVlRWdnlhaVJrLy9QVURkS1NGeVg3K0tZZVZ6Z2xD?=
 =?utf-8?B?a0JKcFBYY0FMbG1nbDZNcVNIZU8zRW1oL01iVDY5b2l4ZXdMcjFVY0VhbUNm?=
 =?utf-8?B?d29ucnlzS2ZpUkRxM0tSNUs3dmNGZm9UQlN6K0krY05WUWoyUWNTRmt4VTFJ?=
 =?utf-8?B?cVhMbHlmZUduQS9USW1DcGU1d2FOcVNjVFYrWFptRmo0YmlscEZweklNa3hI?=
 =?utf-8?B?dklXTDhuVW1NTndackIxWlpmZU0rRlJKTlQ2bkFDRks1azZSaSsvZDhKcXdv?=
 =?utf-8?Q?k7jOrtAWy3jEgh28LVEfe4qta9Mt/yQxy/u6cBl7odbc=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d262ff1e-584e-4bdc-1c36-08dc97ca7981
X-MS-Exchange-CrossTenant-AuthSource: SEZPR01MB4527.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2024 23:31:46.1483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR01MB4154

On 6/29/24 01:01, Darrick J. Wong wrote:
> On Fri, Jun 28, 2024 at 11:25:10AM -0500, Eric Sandeen wrote:
>> On 6/27/24 8:12 AM, Jiwei Sun wrote:
>>> From: Jiwei Sun <sunjw10@lenovo.com>
>>>
>>> If the following configuration is set
>>> CONFIG_LOCKDEP=y
>>>
>>> The following warning log appears,
>>
>> Was just about to send this. :)
>>
>> I had talked to dchinner about this and he also suggested that this was 
>> missed in the series that removed GFP_NOFS, i.e.
>>
>> [PATCH 00/12] xfs: remove remaining kmem interfaces and GFP_NOFS usage
>> at https://lore.kernel.org/linux-mm/20240622094411.GA830005@ceph-admin/T/
>>
>> So, I think this could also use one or both of:
>>
>> Fixes: 204fae32d5f7 ("xfs: clean up remaining GFP_NOFS users")
>> Fixes: 94a69db2367e ("xfs: use __GFP_NOLOCKDEP instead of GFP_NOFS")
>>
>> ...
>>
>>> This is a false positive. If a node is getting reclaimed, it cannot be
>>> the target of a flistxattr operation. Commit 6dcde60efd94 ("xfs: more
>>> lockdep whackamole with kmem_alloc*") has the similar root cause.
>>>
>>> Fix the issue by adding __GFP_NOLOCKDEP in order to shut up lockdep.
>>>
>>> Signed-off-by: Jiwei Sun <sunjw10@lenovo.com>
>>> Suggested-by: Adrian Huang <ahuang12@lenovo.com>
>>> ---
>>>  fs/xfs/xfs_attr_list.c | 3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
>>> index 5c947e5ce8b8..506ade0befa4 100644
>>> --- a/fs/xfs/xfs_attr_list.c
>>> +++ b/fs/xfs/xfs_attr_list.c
>>> @@ -114,7 +114,8 @@ xfs_attr_shortform_list(
>>>  	 * It didn't all fit, so we have to sort everything on hashval.
>>>  	 */
>>>  	sbsize = sf->count * sizeof(*sbuf);
>>> -	sbp = sbuf = kmalloc(sbsize, GFP_KERNEL | __GFP_NOFAIL);
>>> +	sbp = sbuf = kmalloc(sbsize, GFP_KERNEL | __GFP_NOFAIL |
>>> +			     __GFP_NOLOCKDEP);
>>
>> Minor nitpick, style-wise we seem to do:
>>
>>         sbp = sbuf = kmalloc(sbsize,
>>                         GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
>>
>> in most other places, and not split the flags onto 2 lines, since you need
>> to add a line anyway.
>>
>> Otherwise,
>>
>> Acked-by: Eric Sandeen <sandeen@redhat.com>
> 
> Hey, could you all please read the list before sending duplicate
> patches?

I'm very sorry for wasting everyone's time because of missing that patch.
Thank you for pointing out this point, @Darrick.
And thank you also for your review and suggestions, @Eric.

Thanks,
Regards,
Jiwei

> 
> https://lore.kernel.org/linux-xfs/20240622082631.2661148-1-leo.lilong@huawei.com/
> 
> --D
> 
>>>  	/*
>>>  	 * Scan the attribute list for the rest of the entries, storing
>>
>>
