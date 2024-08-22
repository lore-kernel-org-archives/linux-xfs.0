Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02olkn2082.outbound.protection.outlook.com [40.92.48.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991A617F4F6;
	Thu, 22 Aug 2024 10:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.48.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724322311; cv=fail; b=a8lP1hWew3+d8HIZNB58g9rORAKNfplFTARafgx/Hif3chn/Y6zn0xmW4ZXa/3ksbq5r9SzvhEEEPCl9Djy8qY+99KbtgnpOYGX1WBdA5hCQRlzVh8rFl93V54Zmvj1Q5Rr+Iz7C89IV+fRIYvwTVdxE3QqAwz0aZ1WeTd34Sc4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724322311; c=relaxed/simple;
	bh=MBD5fldz+/lHoYAGTT4kzmEt9MYSrXR4azrpetOGHPo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gXeGHy1TDFa45zvdPcONsvHKj10tb5CQTRPf1muWCIwEAr4hX4gmzkrEV+ynA8NbQyBoLZEWNeKqE4oXI08YSml0xprXXRclNk7mFTIVAMBYSnYpN3X4RDmKG3BfQPzXMvUgiqHQ8OVeJy+UFH9uRRbwGjBTl+opKLiZMrNQOV4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=rykG+ntP; arc=fail smtp.client-ip=40.92.48.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="rykG+ntP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=brlIHgPMGiOcyGMIrqVj5c/wDyev514DaRjN1cZYonhT0Dvj4PRV5g1kSvhzzrzVATLOdHPRHDU5/0qcT9IOqVz7V9n93nYGAowSkFqIjWIbCiHeBGXwByYna5Kkn7HFRMyOVS2zSFHbJHJ/kL6anFLMP1DIHJ0d1d/lKV8xxwtMoz6XhUEjFbnMbtJHQtjirPFackRhHZ2B7JRG9QTHdVtZPRDIQgXIYLiv3RXkMWYbjNkG55gIu33Yz1hwcj0CViBcmWH5jnYATD31n+1RSC8RKLfqPaECp1FVclP1YsUq147Ui2evxH8RAHq8XPx/67aTa6JBhk03eWDlZCkr5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OC55v+Pd6XNQbgNxPAx9kUJ/cG7Y9OhufqMJbq191kU=;
 b=rMbYzru9ZboCkmeYlvAqi4rqW25JQivvisEXy3g+mcShA4errp8pwaTWA8gVomksnuPFGKuOyHRCpiPTbw8xcc9ekwX5rt3CkakaT8LTfOnsfCktzGRLtiecT6r4JEq1A9rMBVW9UB4hT4zFtazsOR9lOITFGniuSkAazgnVZjQjNxvkmoAfBSFYM1EIMixywVG+DSZ1/rTZnM2+Ul7NJPuHu/5MV5a9ceWg93Bh84Wmg+edkiOsWZLKfRtSjLkjUoMrt1ZDqw0UUbZ4secB1vrFdfH9cTUHDNCOI/+U+cbzoGedPJA765oYcUCecO2u4Dm2b1/0GnRSUWYu7L5W+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OC55v+Pd6XNQbgNxPAx9kUJ/cG7Y9OhufqMJbq191kU=;
 b=rykG+ntP21tKkdte62jMIleBgk6hyzTmLrfbK8yOQsVSS6NzU6jpOC1Zci5xEviFzSuQI+khUOq3pb6XG/ZMDzh9xUIZxeUJVEfodQk+5ZXl6pFz4nlg5/LlLj7sjb2iBeMpN+oRtCaIQvjN2v1zYZcF7dmgS+6XrQGbhiRBy/SCl+rv56EXSFF7MnuMUZeDLhHcXG8ma2tLHlSw0BiiXv1uM/1fCp2Q8JiMKqyeS1Zew4q/fAR7CRRAOAmS1Q5umKnM+CNM+oQ1z6U9Jn0PbRpC4zrbRGq0pLpADJGFsGWMkdb4T0dPQxrR7NUqTis2PmME4y/MmsQCQy6QPyEnug==
Received: from AS8PR09MB6580.eurprd09.prod.outlook.com (2603:10a6:20b:610::22)
 by GV1PR09MB7241.eurprd09.prod.outlook.com (2603:10a6:150:17c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25; Thu, 22 Aug
 2024 10:25:05 +0000
Received: from AS8PR09MB6580.eurprd09.prod.outlook.com
 ([fe80::13b9:9a83:ab29:23c7]) by AS8PR09MB6580.eurprd09.prod.outlook.com
 ([fe80::13b9:9a83:ab29:23c7%5]) with mapi id 15.20.7875.023; Thu, 22 Aug 2024
 10:25:05 +0000
Message-ID:
 <AS8PR09MB65809D71E78A5E1FA20013EBE48F2@AS8PR09MB6580.eurprd09.prod.outlook.com>
Date: Thu, 22 Aug 2024 12:25:03 +0200
User-Agent: Mozilla Thunderbird
Reply-To: anders.blomdell@control.lth.se
Subject: Re: XFS mount timeout in linux-6.9.11
To: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>,
 Anders Blomdell <anders.blomdell@gmail.com>, linux-xfs@vger.kernel.org,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Chandan Babu R <chandan.babu@oracle.com>
References: <71864473-f0f7-41c3-95f2-c78f6edcfab9@gmail.com>
 <ZraeRdPmGXpbRM7V@dread.disaster.area>
 <252d91e2-282e-4af4-b99b-3b8147d98bc3@gmail.com>
 <ZrfzsIcTX1Qi+IUi@dread.disaster.area>
 <4697de37-a630-402f-a547-cc4b70de9dc3@gmail.com>
 <ZrlRggozUT6dJRh+@dread.disaster.area>
 <6a19bfdf-9503-4c3b-bc5b-192685ec1bdd@gmail.com>
 <ZrslIPV6/qk6cLVy@dread.disaster.area> <20240813145925.GD16082@lst.de>
 <20240813152530.GF6051@frogsfrogsfrogs>
Content-Language: en-US
From: Anders Blomdell <anders.blomdell.at.control.lth.se@outlook.com>
In-Reply-To: <20240813152530.GF6051@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TMN: [wWwUsdHXgsctPH/CWtEjoaMn0z3Wqk9j]
X-ClientProxiedBy: MM0P280CA0114.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:9::11) To AS8PR09MB6580.eurprd09.prod.outlook.com
 (2603:10a6:20b:610::22)
X-Microsoft-Original-Message-ID:
 <81f9bc3b-bcb4-4bba-9c41-e2848f94d441@outlook.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR09MB6580:EE_|GV1PR09MB7241:EE_
X-MS-Office365-Filtering-Correlation-Id: 28819b45-60ec-4471-6870-08dcc294b068
X-MS-Exchange-SLBlob-MailProps:
	Cq7lScuPrnqXS87dsRU8TFjFXLmvjnT6HfywUNILzfdhlxO82WbuCFahSk+kaaS9y0qNypsy0HegMwERS+bDxzgGPgwjWwqMKcoXc9gbfTjhl100tASJ+ehkBM2AhM6WM5KcZUto1v39fewiyVyr8qseuaFy/csbyWOEVH5QaB0OFLZjd7GIDKIYMWvqM+U1s6o4bPfon9h3/2NUWfvA+CYloWUg1G8IUI5k2Lf19mfu4gVcTnvQPYVYxBw/EnwpJdlcG0BBnkK/Fe/r+ZYN0/M6NJwnySm4k4KKB3v1Hw0zjh00GAAbl/RzsIb3rra6VM2QEmaXDaIX7U7HG6RTZ0aRmwnX6R3oQCxkyfRT+/cpi+0bA5ulxeDmMSOHYpN5fY8ypad1kMT+aCoNq7nKOI6UOAl0Ikg23C3MLNV9mGrYJzj9RQopnqJzz4XDhXU8uuGE134d3pf6WikWb8mpN6kjoHOMtKX9vrpI/EEYqtaIpTsi9X9kmHKgR77/tFMvqY3rInONtteKN3WyO4EYY1+dLNiVn7y2KtLzmqr+3wijInXVAP1kkHlRW0DdB5Na2lVymt03bIt8hh5ZWSLPnrZgdJO5N+D6IFa/tMBcrkKdoxTqowWeXRU6zttTi0qnHDTB8gvxNdLYu4au2aXyJa8vJZTDy21+NxKCd/+roELzwv9WGkrPbcvmTedFvSK2PZm8wQqwzkqXLy2Afxe7qQoyTuEMzQ4w1RuJGR68vTB1l5LqxuBiARPHkLyEEtxpT1u+WK03u04=
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199028|15080799003|8060799006|5072599009|19110799003|3412199025|440099028;
X-Microsoft-Antispam-Message-Info:
	i3YaM3lwSjEtfUOI5fGksAAU2lSUmkBjDJootc8n19XiL2nQdMOrNBqhFRzFB1VDl9mPg1+FL14GLgZGR2jfm5TggTtj+kwuT3Hk4avsVYTy44JaWm3xQCmCnzx+3hLY8H+gEJ1AWLpvMRoTBi+bJY2JAdOY9G74rxLlJSlqyrNbtZfVNZy/A+NMUSYA3zt9V2ZL2x78hM26rtjxyTxY04sNMiMo+y2FiMYXmSKm5bKjsRZsy2r3lB9b1h4oyJus/m2G33r1VhhK0gu2tZXqn6wFcXtWXAh8Yhbu/+e0i4mCLl5kL7D/rHJIdtE71MOxwK2e7Sp2vm60jcU6qZLVltqnQkTXGdVSiY/vY5MkcEmr2yTFkJCcJnSJEOADzXO5CgPf/TTElgEeYtcUeX16iF5Z+T508O3e+j4nregzfa6cm9kC3pey4ofoYBEHSWr+UQo6Md94Nkn1YXAeZZJ4iVoRnukW7SA0upAFl8Eb6fB78uI5iBvd4+yXh7lVsgmeItVT7k46+hqxAR+YbhzrZuq4Kzf/TKSDLZQe4HcK882hkmB3xUbaqcLgOkSTgcl1vxou9DZfq6ITUvJVUl4Pt1D3KHRB/ob5FGbD8I5n1QmyCj5IZSA3ITtyFtJSWG7RrlZHelLZfhd93tSMrKZOFd1oMOIt2j0D06UBfOys/ZTS8ZV5yXFXFzlUuJTcJx4mjGEQl5UfLKo8XlUUa4VTUQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MVByNGhxZ0dSMW9DazNhUDNRK0dNdUxPMXdua1ZZVVFTN2xOZ1dXUEIyV1NP?=
 =?utf-8?B?bTQ0RG5handxYUlhaHdyQU1Zc05rRFMxTWZ6bFVqMDRPVlhwRXZERGZHWjZW?=
 =?utf-8?B?RGlzWFVSd0RyM1VFazdIUkR0RVc3M0VlNUZGaVlmdjEwcTd1S1d3SHN5c2JL?=
 =?utf-8?B?TCtZQ21GVVZtaVhCM29oaExJWFpYNFg0Z0E2UDVXaXhlRmNma0tIb1pHVjRS?=
 =?utf-8?B?RmJ4MEhobTFGWXRDU1l4bTNLcHFjcCsra3ZjWXlqT2V0VE9VYlNBUTJRWmFk?=
 =?utf-8?B?OXhlUzIrYTIxblZCZHAxMWorSTFCeThkdlNUaVdlczM1eUNYRnNQM3NkejV0?=
 =?utf-8?B?aUsyc05OQlZXYlE5Wnp1d1ZHQlJLZDREWWtNelZzTVZIa0ZuRWdONzROMjRr?=
 =?utf-8?B?SDJKb1gyMldkQmIvdWFUNloyR1JVbE5ZZDVFOUpFaDIvTXRWaFF0bnVsVFJW?=
 =?utf-8?B?WC9qRzV5QlBxVXVkNGp2SnJwMjFmQTQ3UTQ5M2MvTkJqaEdiWjZrUGliYlRH?=
 =?utf-8?B?S1hEK2lEMHBFOUkzYnhQcDZRaWdYS2E3TzVPWktESjZFQUVzdDRnWjZkNmZ4?=
 =?utf-8?B?dU5aMlZTc0NRcjZVVEhrWGVQMkxvVm5RV3F0Yzd3OW1kMklPaU1LeS9JNmpZ?=
 =?utf-8?B?b3pFcGtCNXNYSTBrMndoZlZKNjhpZlNSZUJhMllxNkZ4Ni9SYjRHMUUyTnJE?=
 =?utf-8?B?UW1IaGhJdGhCaEFsSC95OFJrZzVHSTlEQTB3Tys1NGl4SHVPNXJ6WkdOZG1r?=
 =?utf-8?B?aWdUMTk5WVRNNWtDaGVZcnZCTWZVTko3ckpQK3BIT3M2eXk4THh6ZWFkenEv?=
 =?utf-8?B?NE9QMzl0UVUvV2NBcTIxbGdSN2tENVpYVGR2YVVTZ2NsTGV5bnI4Y3hkbUwz?=
 =?utf-8?B?UHpFTlNFS2x5NDVmTkFxak02dEgybFRxcmVWTDc2cWZFeno1aDVtSFZ1Sm5r?=
 =?utf-8?B?ODZjalFQeUJXUHJjT0U3ZkRzMWllaHorU3Q3RWZIR01oQWVJY1FGUkJ5WWht?=
 =?utf-8?B?NVdpbzF1NVdOdXk5bWNUMkRuSEJJek52UU1GeENzVW9nbTQ3Zk9YUWhTOHht?=
 =?utf-8?B?V0ZPYW5ScUsvRE9OQ3VwbE9pZ0JDemErUjdidlJTdnhZbUd3cjFhSHV0THhY?=
 =?utf-8?B?aEV6dTMwQ2FXK3Y4eEd2MW5IRUtxcURSS052SUt5SGpNWHN0MDBESVVjK0hn?=
 =?utf-8?B?bEtwak9nMFJEMGVnK1NWcDNsS1lCb1Q3UkZod3MzOXhMRUh4eXo1UURyRDN3?=
 =?utf-8?B?aVhCT1VuN3BqQ0RRN01GMWR1V0hDQWRGR0RlTWlINEtiOUVWYUZET1pvMnVw?=
 =?utf-8?B?UjBxdmlIUkNDTnFDQ0RWV3JMYTNJT1FEclhnOGJRb0ttMEJnTFR0eC9TNnpr?=
 =?utf-8?B?TWIvN1d4eDV0QXpZS3l5TjdmZnVrTkliQ0FyQyt6RUxvZlZiNzZHN1h0dUJ3?=
 =?utf-8?B?V25XL0lkWVRhdEsydFVsRHNMZ1g4Y2VHWVJZSWtpam1aM0ZidlhyK1E2Y0ow?=
 =?utf-8?B?K21xbGNmZTdTOFJ1L05YaWhhWUl1VUVUK09qQjJNcW45ZlA4NEZuYktqY0F3?=
 =?utf-8?B?U3ZYUXlZRGtSYmdFL1ZRVi95Mk5VbEZONnlPTkVmMTVIbUdweHRoVXJaQzRa?=
 =?utf-8?B?M0c0Q05EOVM3cnpWUWdoTnlJRGZyZW5ucFplRHFuNm5GWUJzS0tnTUtpa0Rk?=
 =?utf-8?B?VFFBMzdDR3RaeW9DWnloZE5TZ2Q1ZUx3SVNRbVNIZ0JPcE5sdGt6dXd4Tld2?=
 =?utf-8?Q?2QyRSIwFGKFI0ATK5Y=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28819b45-60ec-4471-6870-08dcc294b068
X-MS-Exchange-CrossTenant-AuthSource: AS8PR09MB6580.eurprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2024 10:25:05.4984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR09MB7241

Anything I need to do to get this patch into the affected kernel versions?

/Anders

On 2024-08-13 17:25, Darrick J. Wong wrote:
> On Tue, Aug 13, 2024 at 04:59:25PM +0200, Christoph Hellwig wrote:
>> On Tue, Aug 13, 2024 at 07:19:28PM +1000, Dave Chinner wrote:
>>> In hindsight, this was a wholly avoidable bug - a single patch made
>>> two different API modifications that only differed by a single
>>> letter, and one of the 23 conversions missed a single letter. If
>>> that was two patches - one for the finobt conversion, the second for
>>> the inobt conversion, the bug would have been plainly obvious during
>>> review....
>>
>> Maybe we should avoid identifiers that close anyway :)
>>
>> The change looks good:
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Looks good to me too
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D
> 

-- 
Since Lund University (allegedly due to insufficient funding/manpower) prohibits
sending email from Linux clients, mail from me will come from the address
anders.blomdell.at.control.lth.se@outlook.com.

Anders Blomdell                  Email: anders.blomdell@control.lth.se
Department of Automatic Control
Lund University                  Phone:    +46 46 222 8793
P.O. Box 118
SE-221 00 Lund, Sweden
