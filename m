Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A31D1C5D7D;
	Fri, 24 Jul 2026 04:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784866173; cv=fail; b=Wwamox64XVHXF2kbhYZWx+nH4CYbnkUFrxyW2mlTrbKxhH27ymlHyhfYZFTmBl49PXKmqBRCsaDRwjIGCUi1mxAHXRfhm9qpWfdMrvDTkM4JkfsiF1B86a7Jn7NDuIeqNHWYeZ9g0EyjQIES0Oi1Qanxx7NXI0EiOXNjhCz2J7c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784866173; c=relaxed/simple;
	bh=rxiLBMPnCredt+akqdvPYcmy8Pnwnp9eAibQvd6DT40=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XFUnlAvtCqKsy2J4IGtqhiIGiul9tz1TLx1relgUMQ+UJpIwp1KrOGAdkVKF1J9UOq5mHQYLU94jyvUROvXysF8Q+hik/UdckJM/YAbwdgvI2374IS8g6IbPtHrgWrSD/BHtxIgRg/Bdk0KrIRyA5xuFA0XJ3SVjKSvmOXHslXk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=fail smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=OMZlh0X+; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="OMZlh0X+"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66O0kpYk480726;
	Thu, 23 Jul 2026 21:08:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=27/T6JY+02/OZIl9U+amuhnpEK0Yn8/YpJBnPEsvYao=; b=
	OMZlh0X+nb2Sq8rsHZFCZVYBMrZZsDJk9wb3GiuA/6PExlRlThcfTkraV95D08oB
	4btNiqnjP7YJ6l+G3QU50ArRvd61+DnLWkl95fIpzu/ssuOUPtanR7Rzd/vmUa8S
	86E24H7g6Ioe2FD5pJ1ZGyzsp5uVfdPIq+6LLZkzNgKgX8UbqCLic1EIYfP9GV73
	UM+cvx5pk/o53A5RzOlNnkCgstlKKkTEz63WQdwt0LiVBvnH7nmW9eUrE76r7vOl
	vZQ36Tw2jeqsMB7Y0PpbMt53tjUgwBpE0l4uLdkR4wLahSTEjZ0xhs4F+tOpWnn4
	YJJMS/EK0OSzoxhWlSPPdA==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010068.outbound.protection.outlook.com [52.101.61.68])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fjt3u42n8-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 21:08:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BoIC0PvmKbyBb0da55ZlFPwmb3OQUlDE1p7m1UjVSk0WGYQ03EkXT1jNj6SHLzGZgq0BZXyBlvx8u2RuYC6Gnz1VNVHrQxWH2O5REyLQsPdzIKQ8Nt2H9UQNeGWkqopWQ6AckLL0CXlo188JCFReKZNLY47+E3zISkhvYDIuauIXIebQ1bGYhj/btkvRZrUpCHteRLITIECU4Ut/7MkbaJbgdq+6f5mgAfN5v8fLe0GDrZFwYOZkiv4ow7WFJJA41hKPPaATkM1OB25sT9hTGA9K30LRQLl+Dh9pPH80iKv5wzGziRhRGNqFAxs2UIzyN6itfxK5AIpxyxOOFFef+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=27/T6JY+02/OZIl9U+amuhnpEK0Yn8/YpJBnPEsvYao=;
 b=knDvy7EPl0KnaYbjlGHXNJqAoXXW5jZar1TMf71pav7Co7XiBfmeh/qPhHVaJYyMEj9E3A3RxGOYNSSxr4KSR3gylXYb59oCtKo1cGs/nLaiJHGaTascBHQQx3ziJrItBlFJYrPZlMhzBns0f61NOtZ8QQMTqmfyn1jXS9oc6XtbcGby/iFTKh4xqG1IuOmRXBYmhMINZZ1ljjZQWv5knScjvdzIAWa+z3dX4bvuTOy+ofFqmVeFWb+5A4gyk0wBPwyj5bMfWSnvPXveFeq8RIpXx8VMARNLaOLh4MI+SDMdTvfJ0MjkcUGelTQC/G8eqX5UTs4nSdtEKlvZiixFRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by MN0PR11MB6035.namprd11.prod.outlook.com (2603:10b6:208:376::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 04:08:43 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 04:08:43 +0000
Message-ID: <f7e7b1f9-ddee-4668-9cea-830264f984f5@windriver.com>
Date: Fri, 24 Jul 2026 12:08:33 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] xfs: restore nofs context unconditionally in
 xfs_trans_roll
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, djwong@kernel.org, willy@infradead.org,
        akpm@linux-foundation.org, hwenwur@gmail.com,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260719095732.1813590-1-yun.zhou@windriver.com>
 <20260719095732.1813590-3-yun.zhou@windriver.com>
 <20260720083940.GA21000@lst.de>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <20260720083940.GA21000@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TP0P295CA0001.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:2::10) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|MN0PR11MB6035:EE_
X-MS-Office365-Filtering-Correlation-Id: 002d1be2-1d5d-4c24-d8ff-08dee9394056
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|56012099006|10067099003|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	WPv+zk82HUgkdldTYNseQx04lcus3MME+YVtWQrAO/Zy766cfkMJlt2o/tSo0d3Dta6v9T4K30wFfY/e0k/dHETipGV+JCJqCReJCFztP81Ce4dK/dpq4srRVZay+S6/4ylKTeu9dD/rABg2uM/2sKTIAdmymX46dsDc11KeCqk6fM2nPf4wnCXwHFAqAFw8TTdAF7YK/hCoe1QumuDQYeEalTnzV/MtZx0uJ6nnTqoCEWTjW73oIrVEaltDO92N9sM8ke4d1b04Pvpk6DtVrB+W430VRIC2RuUkbtLopbC/AkhKNWqkXsmUSmeUbK9MHIosF86H3oIXNOOmXUEZ8Yq+QwwKQRIcopnbCZ0WMJiMdAJxi6baLUZdIdHgK8fzOK2U7ExcJ2YaU/rpbGCz/Q7pdK7aYIrMXO27a/aVAJg8kPZ87Z0NBUOmghEgE1Fo3gtobo03Ij3Kj/3yplngQTG13BsQzKuho9bLIpD2/Ol5PgfuwzMo9op367Q84X+t8jzuUpBaVZhfafmgp28aKV2gLSpSlGwt54U9J2VF5SmkdkjtILzxpVcRP1fmdZIt2x0TERPfeWZsK6kvm5FYFAitHeEZvTyqzJjvsuwl+js35I81BM3chLo6hRNIjVeCuHGWFYvPg0HSAtXRW3I25Y8USKUFBsOGifCmRDwjeVA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(56012099006)(10067099003)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c0Mvbzl6bVI4TFdNRkZIQXQzVDRvN1l3c3F2T0dOcHZvT1VNdFF5WDdtZmdQ?=
 =?utf-8?B?dTRRbE10M1UyNTNna1Jwa2k0eFllbFFsSDZIUkRnRHlzQ1dyeUw1MWJ0WXJB?=
 =?utf-8?B?WU4zc0NCUmoxNC92NllXTlFmNWprMGNOT0JJNnYrdDBEZzZHWTM1TTJwanZX?=
 =?utf-8?B?RW5RTmoxdXFSZm9YYXUxakxxSk02QUI4WFlYbTd0ejdkc0ZsMk1zM2U2aTFv?=
 =?utf-8?B?K2FSeHdxbnppcm01TGl0STdjM21pOTZsZStqZXIxZVNLb1FsV2I1OEJrRXFu?=
 =?utf-8?B?czBPV3pYWGpYUlcxMWkvb2VXR0xkaUlIT2JLMFRoWFl3WC96QzlkYlhxNy9S?=
 =?utf-8?B?SElTUVNzSFFvWlZiUGFUYzQ3emFrTnJUamc2Nml4YmNPS25RM0VKN1FvRUIy?=
 =?utf-8?B?dCtjcjdPeXhtVTg1UVRkbHNTTjZyeDlUeUM4cUx6dUVEd0d4QTFEZktna0hK?=
 =?utf-8?B?bExYcmxEZHU0T21sWUNHMldBMkVDVFJZTWFYUUM3THZEWjhDa3pmNmtCT2pO?=
 =?utf-8?B?ZGQ3bVd1MFJWRWxKcVl0L0NRS0RwbjBySEV3N0I2dTlETGc5dkZCQy95azBY?=
 =?utf-8?B?OUlxNjd1TXNnWndGeTJVa3c3dGVWV2EvQjlYS084ZE5IVzN6U0piUDVheE8v?=
 =?utf-8?B?UTJnLzNTVk90WktyUkhTb2d4dHdFRGxCeHpoL05rVVFBRnRxRm1pTmtUWGU2?=
 =?utf-8?B?cjYwNGNMck9tVGlrTzZ0REhoVmVPYVBHdEUrRzhWYmVUd0J4ZG1DOVdhUmZ4?=
 =?utf-8?B?WUlFKzFNWldZWHU0S0dXalBMUFh3Q1FDcTRPbzlUemdGS2R4ZERoc1J3bklu?=
 =?utf-8?B?L0tuSzZWMjVCVVRvY0gzcnZBaERici9yWEErY1AxakxaREF4T0R2KzBjbHc0?=
 =?utf-8?B?Zk9pQWZBY3hpMzNrR0YydnJHbjJTdWV1YVhScXFwcm45ZWxKZFpRUXBJSjEy?=
 =?utf-8?B?SmdCc2VYbDNNalFhVjZuMGpKWm8za1k2WmV3RjlNMTRHalI3YzU0TGR4Y1FW?=
 =?utf-8?B?eWVRdW1UNWlENnVLTG9MamV2S2U0QWNETkpscURqTWNKb0N4NzdQVGJ0cVN1?=
 =?utf-8?B?ZXRaSWhBZHk3RzZBRmdOS0prMUNqT0xhTVBoV2RvWnJsV0JFeXdpOHp2eXdo?=
 =?utf-8?B?MEk1REhRTVluY1RVVGcxZW9kdCt4RENER2ZzRk9tTi8rOCsrTm1kWmlzUjVT?=
 =?utf-8?B?Tjl1Q2UzYmlzUTJkU0dsUGRwcURESU1xdVVBaDNKNVNpMmVaUmFuaVA5WmlB?=
 =?utf-8?B?UGc2M1VXWU5NR3Axdmh3MTRVWDlIdWhBU0RPV0gwVHl1M0RHYTBnWGRxb2xw?=
 =?utf-8?B?RFRVeHRLTFRGSWNwcnFMRzFVS0ZON0k0R1BvOUlkWjF0VHZVVGVIeEd0RVFV?=
 =?utf-8?B?R0hlZVhkcmFFTDFUOW5yWDJDcHlVTG9kMnFyTmlMSmJRVndYSW96c3hZSjh4?=
 =?utf-8?B?VGhETWZKS1R1WCtvbUZZdVdObEZUZm45QnFqRXNqbm55LzVBSG9vd0pENUlU?=
 =?utf-8?B?MGk5c3RaZUlKWU8zSTByUGlWcUcrZ1JCWjM2TmlzTGx5VTZHaG55TkNQZzRT?=
 =?utf-8?B?MVJycklUeFdZbGJ5QXA0b0JMdDFhL0JVdHl5U1lwSG1TS0RSMmJhc0RZTnI5?=
 =?utf-8?B?UWRwVFRSOTdqTTlrcU10SGJ3LzNiNXRnaVlWZ0tJTkF1VXZuYnluMG9URjBa?=
 =?utf-8?B?WVlNWVBMUUZWSW8xbGNXcG1tZ0pkNWJTamdDZGpicnhxdDJ4N2RNU3lYWUR1?=
 =?utf-8?B?QUtrVTR4cFpXVDEwWG1uU3pQQjkrZFZOOXZkOFExVXZqZ0p5eFhZVUtqU1A3?=
 =?utf-8?B?cnVxMVhsUm5qNmdHdTFJZ2t1REc2NjhEQ2ZZalpNNmVTUllwaVhrRWF3V1RF?=
 =?utf-8?B?Y2lJTmR4aHhDSGFnczNMTlF4MlZVbHIwYjFSTm5DNE5ld01wUWpuUlc4ZXlR?=
 =?utf-8?B?RUtEMWNWWFkybWR0cHZvb1RocmpOb1ExVmM3RGZuODVLVzRWK3dRWFBudm5S?=
 =?utf-8?B?S3JpN3ExSHJaVGF3aXdBbUdKU2JKeWFtY3FpdDdrMncrbmluYVpTR1NLaDZG?=
 =?utf-8?B?RS9aQitpaGQ5Sy93eTdkMEdBU01jU0lNa1lQNXd4aXFZSGtMSS81ZGxEWjFj?=
 =?utf-8?B?VVI2eXlWQW45UnlOR2FjSFVmUU4zclpmTjVzL3VDRUZvZjFidGM4QTZHN3FR?=
 =?utf-8?B?d2hHOENlNjhLYk52Yy9wOG5zT2RacmhRcFBYajZSU0VGSEd0Sm9sUUpsbDZK?=
 =?utf-8?B?bXpEMzVSMjMwZ1VxQzR4K1JhY3UrL2thOXVuMnB1Q0hwRWEvUnNMMVJISER0?=
 =?utf-8?B?cEpnVXJwRHVFNloxRWtOSXRjQ3kwVHhWSmtONFJvMnhDdWN3dVVXZz09?=
X-Exchange-RoutingPolicyChecked:
	dqHM+ntW8KFYO3iHXNiaYlsPRATavntI86s4awlCB3UqEUYlbCuli/WEQ2cFUxg8k/+qyVZ21N8EKQeRNIULH25dNE079tlMCykzohQy7xdJp/Z1NZQTbIkD/GnOPtsivRxlj8IRpSDc76biCkXkNF5nFCDhSdAtaQEKEMlXawKAEMThI5KWqBFlsJrUBsbby2708K6tGeHlyOwRWEJ1jWiToIW6A8V+wrZ+NjPmT0WqMZ2UKzaCDYOeHWLFNEJ20CDE7BomyKOSyseNERZkOhUuwE+uyLZlEzIrxKPJWfqWOj/082wOObWdkx9cTMXuhNg4s8djr8Us1NtxMuRXnw==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 002d1be2-1d5d-4c24-d8ff-08dee9394056
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 04:08:43.6240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LP74QUVWD68mSSHc83LYvoVje48HZyyW3rETWezFaeaSlI2dwN1DiF357S1aNzUCy9Hl1WC1LMaKQ6MhzWaYgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6035
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDAzNSBTYWx0ZWRfX/ay/PKlYwfyD
 bVclKz2dftPqi7XDZeuvYkbTlJXKrsmi/btWJ160Fw4LZYyC0i4SYSYwcw11HLPKJHneR9j7u5f
 1TqZizmNxuuIPgDU/ndTh5FsahwJ/0b4uj4lWZy+tOYcvnHONmI3Tjwr1DjLz2u7CbFReYEP3RG
 9h/e+FTZ93Tus03x3XTVc6th2SUfsmgf/4apF/ZdWmYJOfqMArZwcjohPs+hYww4pwFjvp8AbWU
 qKKNcOA2cI0i3UYHthk4W+KeU/VgSl0axtax0U7r3to9WHPX2ijhLAW9HOvhmq2nGmnchmejh9z
 EswbU40L/7tCi1LJUtcveMuwiPyZ4CnKoGFaMnI99DRmp6b6W1oimhUSd6uatZL7uv8nqv1d81u
 49sBWpLH1XdD9Av4VRX5Gtt4wWZPGys+AaKx7mdJNoV6fkRtDsJCvELKWXC9IAhwpc/bcdMSyDi
 QayZLSk8WbPrX2h71sw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDAzNSBTYWx0ZWRfX/eiStsuDItpJ
 HEs8wLwqhBXjwUypLw+e1if4j/UkBGdGkd0b2Q2UDXH5rm52OSyOXsD6sI5CRci9oERbHf57cat
 pSjCQQm28Zat2wZHJybRBnCMXuzRrEnwSnv1XmBEiKI0h8H0Df2/
X-Proofpoint-GUID: tN6dj1fETLVrlQ_Pwub7xAsMqQxHI9jt
X-Authority-Analysis: v=2.4 cv=U9yiy+ru c=1 sm=1 tr=0 ts=6a62e553 cx=c_pps
 a=UdDD+omNl1Ext3Jod4IcCg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=iKiJcTA2PjBS6x5JeXcw:22
 a=n6--6H2Hj1Js-H93pUYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: tN6dj1fETLVrlQ_Pwub7xAsMqQxHI9jt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_07,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 bulkscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 impostorscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607240035

Hi all,

On 7/20/2026 4:39 PM, Christoph Hellwig wrote:
> On Sun, Jul 19, 2026 at 05:57:32PM +0800, Yun Zhou wrote:
>> When __xfs_trans_commit() fails in xfs_trans_roll(), the NOFS context
>> is cleared but only restored in the success path.  This leaves the
>> error path without nofs protection, causing a circular lock dependency
>> between xfs_nondir_ilock_class and fs_reclaim:
>>
>>         CPU0                    CPU1
>>         ----                    ----
>>    lock(&xfs_nondir_ilock_class);
>>                                 lock(fs_reclaim);
>>                                 lock(&xfs_nondir_ilock_class);
>>    lock(fs_reclaim);
>>
>> Fix this by transferring the nofs context from the old transaction to
>> the new one in xfs_trans_dup() via memalloc_flags_move(), so it remains
>> active throughout the entire roll sequence regardless of commit success
>> or failure.
> 
> Good find, but we keep adding more magic here that will just lead
> to further bugs.  Your previous version was much better, and could
> be improved by also removing the hiding under xfs_trans_set_context as
> a follow on.
> 
> Having a maze of single or two caller magic macros that modify global
> (or rather global-ish as it's per thread) state makes hairy bits like
> this really error prone as seen by the bugs now found.

It's been a few days since the last discussion. I'm planning to
respin as v3 following Christoph's suggestion (drop the helper,
re-save directly in xfs_trans_roll). Any other suggestions?

Thanks,
Yun
