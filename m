Received: from esa9.fujitsucc.c3s2.iphmx.com (esa9.fujitsucc.c3s2.iphmx.com [68.232.159.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE5318CC19;
	Fri,  9 Aug 2024 08:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.159.90
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723191847; cv=fail; b=IRJD4sfML9JPXL1kyaYlTDRb4jkSPr+ifF0JAUhqukfl4uHKG5tO4sC10RjTMx/ApW/W6v8IUM5769lSFDbDnbvc2k0QAhekeqMV+T1r2aQjzOnqXzkM6pGFqsoo2D1BXHSF53G/8dIsYdrcBYuXCdiuxqOGmJ+SuVMej1ehDls=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723191847; c=relaxed/simple;
	bh=ZcyDeWPRBzmjKjQar5LS5oqj7haJffmQ0yv0uSg3g5c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=G24LY4Fuaxdp/Dwytu0Ybkdx2isJv8A4Q6yG1AdKQnn3wh3p1NRyXgE/+1Km3s3M7g4o55vsQk+PjthfAKONblE4axSI1ZbxKGgNBbEfr/FrF/uCQfMeyJAvMyKTjmx9yZ/zX9p+gjaZ1UQEB93v2N9Ip234Y0hEMrL6aBf0IF4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=wY9HtdOj; arc=fail smtp.client-ip=68.232.159.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="wY9HtdOj"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1723191845; x=1754727845;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZcyDeWPRBzmjKjQar5LS5oqj7haJffmQ0yv0uSg3g5c=;
  b=wY9HtdOj9Ba3beEEOwTqzY1/znoBoTOAp4VI2O15FRoEuOoLnAb+tU+B
   z4POzX0STDF47gdoYDlE9nFfaltuBiiDvTNX0kvZWoALZtvSLBNmJeK3u
   850z9UMFbJpMzVdDUbDHGGd+xPsn2G2cc6xmxCSHT6ImQ3P1HaXCYSf32
   CYvPwrl52oNtQug/jCwFfqfEbbDXr/qB9dmiWe0s1fe+ZSueLbWK6+0aE
   zxm9NkKNKsLbS4RiLLtPgBPIhvaHtnBIRSSN4vx2CgNYuJQVoGD1D/f4p
   gra9sR6nDjyFgttaTxOb48LuEysCyQgTr+gLhzvJHnMUS918OLmOyIKvV
   Q==;
X-CSE-ConnectionGUID: bDfhX85mQYW6Enj4wlfq/A==
X-CSE-MsgGUID: fjjOPI2FQ3WOmCgGxdjyJQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11158"; a="127835983"
X-IronPort-AV: E=Sophos;i="6.09,275,1716217200"; 
   d="scan'208";a="127835983"
Received: from mail-japanwestazlp17010005.outbound.protection.outlook.com (HELO OS0P286CU011.outbound.protection.outlook.com) ([40.93.130.5])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2024 17:22:51 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iSVIiLPSuAhQJiWlco1+gu6QC/qutalueVz8f50OBpQoRjbXiqph3NlKDxWhS9d/n6dmrK1IpLI0wdIXwBRlZsEvVZ7gp/x4U5qIs1+qvGkKv51E8p5MdP1obWSllqOlQceJl6GcTcl63QOJYQpB7rd3YjHFKHLg5NIWdH2J7alHXiVXZUAJm3rGlH3uvOSXgjgdAXp4tJXUsADBn2poGXEhD6y9vLD/yfvitWjLSZBqkffmu90sjYXc9QIXjmgea6j/B+x433xCyYtKnbQy8VDISDmYtnNTuRmsATJ7PvLj8xgnrQ2UO6A3IRDCVZRPFopky6CxtyuyQehlK4GppA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZcyDeWPRBzmjKjQar5LS5oqj7haJffmQ0yv0uSg3g5c=;
 b=fq+VnzkNtP26TCLL8XGxg0rGeRNNgseFp+O2PKzwVz95VWIpJE623tCDrn4kpr189zfVIjBlCL0AoyXfUtSQ46lDLqIukzxgv/5c+vjcnnVAXiHm3QSEV1NracJrrrM1gY4iX3WpUBcn8Kddt8f60ypWXutIyOflizFa8c/BKAncxGXfqe+n/+cfBwBHCw24/XwTroSGzf67Ij3R6N7TNp6V0pVa9Gtz5ZgCI3NZSOiR4Pt0l9IqGMkTNwpfoYrqueHazFZbc6fOzfxDZ8Jzd31bX2AwCZGiLk7/VsWbA+y1s9/SfKULL1/zcegOb94cIfqvw9kYZFWNr5goGaMKyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY3PR01MB12071.jpnprd01.prod.outlook.com
 (2603:1096:400:3cc::12) by OS3PR01MB5992.jpnprd01.prod.outlook.com
 (2603:1096:604:d6::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.15; Fri, 9 Aug
 2024 08:22:48 +0000
Received: from TY3PR01MB12071.jpnprd01.prod.outlook.com
 ([fe80::479:9f00:f244:9b9]) by TY3PR01MB12071.jpnprd01.prod.outlook.com
 ([fe80::479:9f00:f244:9b9%5]) with mapi id 15.20.7849.013; Fri, 9 Aug 2024
 08:22:48 +0000
From: "Xinjian Ma (Fujitsu)" <maxj.fnst@fujitsu.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: Zorro Lang <zlang@redhat.com>, "fstests@vger.kernel.org"
	<fstests@vger.kernel.org>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: RE: [PATCH] [PATCH] xfs/348: add _fixed_by tag
Thread-Topic: [PATCH] [PATCH] xfs/348: add _fixed_by tag
Thread-Index:
 AQHa4lW9OsfX98L4XkSKvoN54kZuobIPWjuAgArng4CAADEFAIACnqqggACBTYCAARGeUA==
Date: Fri, 9 Aug 2024 08:22:48 +0000
Message-ID:
 <TY3PR01MB120710F03A5212C1E1528CAF7E8BA2@TY3PR01MB12071.jpnprd01.prod.outlook.com>
References: <20240730075653.3473323-1-maxj.fnst@fujitsu.com>
 <20240730144751.GB6337@frogsfrogsfrogs>
 <20240806131903.h7ym2ktrzqjcqlzj@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240806161430.GA623922@frogsfrogsfrogs>
 <TY3PR01MB12071F457962A3AD2B50C878BE8B92@TY3PR01MB12071.jpnprd01.prod.outlook.com>
 <20240808155741.GA6047@frogsfrogsfrogs>
In-Reply-To: <20240808155741.GA6047@frogsfrogsfrogs>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 =?utf-8?B?TVNJUF9MYWJlbF8xZTkyZWY3My0wYWQxLTQwYzUtYWQ1NS00NmRlMzM5Njgw?=
 =?utf-8?B?MmZfQWN0aW9uSWQ9MjA1ZDA4NzYtYjEyNC00MzA2LWFmNjQtMTQxNTNlMjMy?=
 =?utf-8?B?YjJjO01TSVBfTGFiZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFkNTUtNDZkZTMz?=
 =?utf-8?B?OTY4MDJmX0NvbnRlbnRCaXRzPTA7TVNJUF9MYWJlbF8xZTkyZWY3My0wYWQx?=
 =?utf-8?B?LTQwYzUtYWQ1NS00NmRlMzM5NjgwMmZfRW5hYmxlZD10cnVlO01TSVBfTGFi?=
 =?utf-8?B?ZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFkNTUtNDZkZTMzOTY4MDJmX01ldGhv?=
 =?utf-8?B?ZD1Qcml2aWxlZ2VkO01TSVBfTGFiZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFk?=
 =?utf-8?B?NTUtNDZkZTMzOTY4MDJmX05hbWU9RlVKSVRTVS1QVUJMSUPigIs7TVNJUF9M?=
 =?utf-8?B?YWJlbF8xZTkyZWY3My0wYWQxLTQwYzUtYWQ1NS00NmRlMzM5NjgwMmZfU2V0?=
 =?utf-8?B?RGF0ZT0yMDI0LTA4LTA5VDA4OjE3OjIwWjtNU0lQX0xhYmVsXzFlOTJlZjcz?=
 =?utf-8?B?LTBhZDEtNDBjNS1hZDU1LTQ2ZGUzMzk2ODAyZl9TaXRlSWQ9YTE5ZjEyMWQt?=
 =?utf-8?Q?81e1-4858-a9d8-736e267fd4c7;?=
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY3PR01MB12071:EE_|OS3PR01MB5992:EE_
x-ms-office365-filtering-correlation-id: 6de130e8-5241-4b5b-7b30-08dcb84c73f8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700018|1580799027;
x-microsoft-antispam-message-info:
 =?utf-8?B?TTBiSGV0Z243VWhZV3JsbGRkRFZ2WFZMUXduWVJ6Q0Jlc25nblZranJtMkZR?=
 =?utf-8?B?Z280L0FCL2ExRFc0RVBjV0w3WmMra283eHc3YS9ZNUJwOHhjZHI5ME1rV3VW?=
 =?utf-8?B?dUVpcmpHYXlzNTNSV0pWM2pTN041eGk2VW11QUh5aE9wRjNUbkVqUzlUMXRG?=
 =?utf-8?B?OE8xWjdxb1FYTFBQdU02dVBDNDJmZmJOa2dCVitsSUtKSmpGVWRIMzhFMW9E?=
 =?utf-8?B?U1RIR1VaVitDNjFQb0dtMHBBOElFTTJrMkttYXBJa1V3RmJ3Y0FzRHdTRW84?=
 =?utf-8?B?NVV2QnVoZkJhbUg2NWJIbHhzYW9Da200cVRMaUtLOXJ0UG5PZ25mcjc1Uzgr?=
 =?utf-8?B?Qk5mZGcwZWQ1SmVpK1NXaG9WMldFbS9OOUJrQ3Z4aVNVMkFyUEpHTWUva2lC?=
 =?utf-8?B?S28ybWdQUXRBUFZyWkZUak5XMXlRZnVLVjl2QVZZUTFzU2tpM2ZuajRyZkM2?=
 =?utf-8?B?Q1pzQktpR3pSbG15S3hwYXJaNTUzNitrQWdpeXc1NmxJL2J5VnU4VEZERlNv?=
 =?utf-8?B?UzM0bFpBK2RxYStsOTA1RXhhTkd5WUxJRnBObEhueWJzalM3MXk5QVB5S1hn?=
 =?utf-8?B?Sm0xZFFKNWh0M3pjQTl3Z3Q5VmJNYmVNdzBpZWJUcWR3U0JmTklaYWRnNWZt?=
 =?utf-8?B?NGNrRXdFMG5rSDBKYzIxSjJBSURTaElxc2xsN21KNHVoRFB2L0IxZWFuS254?=
 =?utf-8?B?MTh2alVlY0Jxd2tlRit2R0dHbkdhcldURklWbE9qR084MEZDQU94aDRkUkxS?=
 =?utf-8?B?V1pPTHZFc1hTczk3YzJ4RnB1cERNSjFCb3duRUFqSit2SVUwblF5L1AvZU5z?=
 =?utf-8?B?TUdMQVhtb1YzeDJ0M2hZTnA2bGMzNWhheHQvS3RabUljenlZd3B2WXplRS84?=
 =?utf-8?B?T0Q1c1ZvclhzMWdoRDVhL2JBTmpRb0Nnelk3blhkL1E3VDNPRHNIVVB0eGVL?=
 =?utf-8?B?NGtVOGU3UTFhQStCNWcvK1NIUkZzZzNHTmx6ck5IRzJtcWxDaE5tZzVPQTdl?=
 =?utf-8?B?OVczeE9YTVAwZHJCTjVtNXdEL1pTaHMxQ1hIcVF4dHlrS25uSVg2NkNlL3pv?=
 =?utf-8?B?OEtiTEs3YnFXMnhqMWUxeitqeUdqTm5XaW9XOERwQnk2ek40SDlUbDN5TzBo?=
 =?utf-8?B?R1B5SmVnY0tIOGNBZmNKY3djNzVxL0I1OGRvcTNBZ01MK0JqRXlpUVR5VDhm?=
 =?utf-8?B?dXJoTFBFcmxDQjhVL2lTRThVQjloL1dFNEc3UUx3YlBnN3VETlhKWElmRjg1?=
 =?utf-8?B?ZUhnTG9SV3JHZFhTOTNZM3NjRDV3MndHd1lrMXJJdmxNcytlalZhMWZJWVdG?=
 =?utf-8?B?aVRPWWVRSnozK044MHZhdUxVaVRPTTdyQUJObTFSTE00R0ZNbzhGMjkwWkRT?=
 =?utf-8?B?ZjA1WnN6UTgyT29VZUowN1dZYTcwRGJNaCsyZGs1djRycDdUVTdqUGxvK2pI?=
 =?utf-8?B?M1VxWTFISlpWQmdaUGYxZU5pWko2TG5YcEw4QSt1U0FpR2svbnFDSjRCUFRX?=
 =?utf-8?B?RkxlMENJK2F4L0ZGSldYdEtBQ0liWHFYMXh5bHYzTzhQM1ZvVlk0cW9CK2dm?=
 =?utf-8?B?QmY2WWtIUHNpK2J1WWM1bHB3V2lqbjBZRlVtMVAyanRnSGl0Z3ByVE95SlVl?=
 =?utf-8?B?L3lQdG8wMlk1dm9VWDdXOFNJZEttdnA2RHo5RnFqR3kwRWlwT2k4VnBtZDFz?=
 =?utf-8?B?Nkd6amh5RXdKNGZRTlFoZ0RUTTM1R1pJdDZOaTg1U1ZCMDJHbEdGUEUzSDN2?=
 =?utf-8?B?QW13QUNJeUpiTC9BMWR1UW1YY1BSRG9qT1NWT2hLSW9MUnpLOG9zRWppYkhY?=
 =?utf-8?B?L2dNREIvU2RxemRSVCt3RWw4OEpyaDB0YzZNWDZ6ek5IUE0xYk5udThseUZ1?=
 =?utf-8?B?SDloVk11SGpVaGJsc3llRUNUalNRSWVMbFo0TTl0dnlsMDVqMzJMUGpzeFpO?=
 =?utf-8?Q?eD/i4KJj/fA=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY3PR01MB12071.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018)(1580799027);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bWZsV3VXL3lJVmZKUGt6dnV4alZMU2RHNkZDbzVEenJXZEZ0dGFKZFZGODI0?=
 =?utf-8?B?ZDQvdUVWSmRtcnFhNzA2UE13dy9kR0dIYmJ1bjg5OThuN3ROVjJYRDRiSXZC?=
 =?utf-8?B?cVJ1WFQrRnVUMjlMR3lHMDhJaTV1ZFZrbGY0eXZYeFFaL240bXlzN2VmNnN1?=
 =?utf-8?B?WW9EZFIwQnY4UjBwQ0JuVW9JU0dybU5WYnZCYVNiN3hiaHlDbTJqYkJLL01U?=
 =?utf-8?B?V3RIa2I3Sml1YzRKZDV2aTFZZllLbGlta28zRFlBZFFJTER5TWpFWWRCNlpW?=
 =?utf-8?B?bTVzV0hmbzZGVUpTZDNYM0NBOTRtMzhTNW1tUm1EbXlaWE1ZbGNXWW9lYmFM?=
 =?utf-8?B?a2lRQjJWK2I4L01VY2hOUDloZ0dZNWI4UHdrc1hMVlJtcnlSOTVNMXcyZzJs?=
 =?utf-8?B?VkQ4ZFMwVFUxbGNFKzhPbGhHbG05bDB5dTQvcitpd1RyT1MrWjlLcG1saXNo?=
 =?utf-8?B?dWd1M1ZycHlGZDl2MlJQYWFIK001b0poQXVoZnhDakFPQ2FhM0UvN0VPQzRs?=
 =?utf-8?B?TkZXTjFXTGFId1dIRnpBWXFnNFJNczdRQWFXTGp6NW9LRTVNKzRkQTRDUjI0?=
 =?utf-8?B?ekljTndvZGFqcE0vTENaQjVmY1lVZFBGTVdIbzl2SUYyVk1DTzVmSjdnNm9P?=
 =?utf-8?B?UWJjSVJvZVNPM0NqVWJwM25aZVozVE5qZi85MlRSWWx0WENhZ1o0VEhqQlFV?=
 =?utf-8?B?aGlzM3N6UHNXV0RqOEtUNEdWNmJMaHdtUTl0dDQ0ajNJb1pGd2RxRmV3aGwy?=
 =?utf-8?B?T2hKWmlOQlRZenRIb3liTFlicFZRUThOcGUvN2dOZE5xaHVhTldBdFNkd0t4?=
 =?utf-8?B?OHRab0NsVUhieElKOTA5TW1YMFpuNEJFcHpIaGpudGtkcTFpSnVmRTl5RkVS?=
 =?utf-8?B?cUNVc0E4YURHelo0bVZycFJFYkU5MTdKNzQ0d1oyMVpObkpsVExvVG5rQXVw?=
 =?utf-8?B?enlIdWtVMk1kRkphSDZnVEpnVWJLS0NOMldCMHgyRW1MRnlFb3ZrNFJrZ05P?=
 =?utf-8?B?ZTRYS1pRU2RiWXBmQnFveUd0VE5wTzhxNnVuMHllc2lOTG1QN2YzUEtrazBr?=
 =?utf-8?B?Y1hkUkQ2SCt4YjZ0WlBGOFpOQ2t4OGw0Ymh5ZjhxYjczTEU3cFBXSVNoc2FJ?=
 =?utf-8?B?VWl1RXI2WFhYTlpKNzFCZTdqbDhZbzRrc05KRXVBNzF6Q1dzTlFoWmp4OGFs?=
 =?utf-8?B?WGt5SnFLUEpnTCt6YUJZTmdvb2x1K2JkTVMyMy9QNUNEV2FJNkRFRWt0V0Fa?=
 =?utf-8?B?ZmRXeUIyREFpemhCOUh4OGJocUZFeENkUC92RVVzYXJGOHo4blZUWVRkYnJr?=
 =?utf-8?B?ZDJvRVhLTFltdHk4R0t1VnprMjhuM29oU0Fpcmx2V3ZEVVZ4Z1Z2WDlxcDYw?=
 =?utf-8?B?ZXJWYjlMMUVqR3M2UTJzb0ZuV0FDMmw0TzE4RWU0Z1ovOHJRZnR3eVJRV25X?=
 =?utf-8?B?KytRRm1zRTd4cExlOCtZeFAwd3lUeWI4OGY4NFBjZHpGQlJXSmtKMFBWS2Zu?=
 =?utf-8?B?QlpoTm9KSVIwaG9BKzFLdlVublF1TnVXb0JJbkFLc3gwZUMrZ0tyNCs4OU5P?=
 =?utf-8?B?elV5Nkd3ZTI5VmNIWjVKcm9GUzFOSGllSVg0Y1NCakg5RnpWbkVkd1EzTS9Q?=
 =?utf-8?B?a010ZzZGS1dIcHBFdnI0cDU3eTBJcWN2S01wWkRnM3pUWWJpVUZMZ2hqSU1Q?=
 =?utf-8?B?aWNxSG5CUE9HSGR6UElBZ3V4UEcxNVZTUHFPMHZzZENzQlYyYXE3ODBSVkdx?=
 =?utf-8?B?OHBaMURPWUdnelAyenh0ekI2Y2xPaW5IUlNaRWZDZ3Z3WDl6WkZ1TVVIR1FR?=
 =?utf-8?B?Ui91YzVFbEY1bVpuMlIrNFduY3ZpREllKzE2cE4rU05vc2ZHZytXcVgrU2Zw?=
 =?utf-8?B?MEw0eUJlQ1FRbk9rWHl3NG1XZUpoS3NhWVB4dDVRU3RScXlHM09KZlhndDBr?=
 =?utf-8?B?dmxQRCs2TFU0SFpwekFQSVR0Tm5qTzNwUzhRdktxenEybWROVDQxaUhoRmly?=
 =?utf-8?B?Vjdub1VxMGdSWFJSQlk2K1ZPYjBBTHpOVityR09DZnZlTDVtQ1VYWGw5VGtO?=
 =?utf-8?B?ZkdVbUtLL1p6d1ZSMGpSNEN0a2tLZVhERkJxZWtIOXlscVNuMWlhaWRHdlkv?=
 =?utf-8?Q?xDB2Vul4/ZTmdbEevWLG4JhKB?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DiQaoxsF3ONeFUeKP1NYmF81VZ1syGuls6eF4JLjBdQ3wqD3oDdZVi281ZJzegGZOtqoj/zlVQwpJPD8gm0LP8HNa/uHpcQSrXgcwLKGT9Pince9XHXZY+GMoVL8hlH7fNQaOSs7XdF+hdLM9TCisca1ZRRbFJo7edULitCSmnbrQJu9Sz5qg0/dHXb1+BzGY9b3vNqXVT26JPRsRgsMEuvOIywvqDWiy2vofAZe6+oE6gT6M3BjlqmNqehAFJJv9VI1/ZK8IWW+2u+PHBk3nqbQoevjzXJaQppb6JnSliN2lvEXb9rudjW4wX0z+GTEsWGGMuIlGtFB6Lcbu1nwCTtEPtWCs+YDIMhP/8BJceF4FvmUNTW4LK1eyMtIC+36dsqTLgqduHkdE2422772tPtz0CC56/qzm5pK1WS/NzJUhQZRC8H16NBiB3UQLR8NKdNAaWden68eNgfxLhczhxiWZsjuodXbk/t3dOtpEyUK8KiGERhyndJqILpj75X3FpWN8WWy/AO65PIHZwnPtHgq8/PJqRkgLHkhQXaFqYu8SUdGc5QdkSKAa38T8gB8ByS9FbpabuFkd3iUlbOnztfucQw/vKwEKHpeQJqHen3WJ8Zqs3CqXCwGstYga5M0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY3PR01MB12071.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6de130e8-5241-4b5b-7b30-08dcb84c73f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2024 08:22:48.2310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PdAnpab/z2aSN8HHP76zzaOzhN/8R2ctCWw2J2K8XV1Xs21TNXFnc+NnSXNmklEQDY/AN1b6Ri4dHyNZ93GdUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB5992

PiBPbiBUaHUsIEF1ZyAwOCwgMjAyNCBhdCAwODozOToxMEFNICswMDAwLCBYaW5qaWFuIE1hIChG
dWppdHN1KSB3cm90ZToNCj4gPiA+IE9uIFR1ZSwgQXVnIDA2LCAyMDI0IGF0IDA5OjE5OjAzUE0g
KzA4MDAsIFpvcnJvIExhbmcgd3JvdGU6DQo+ID4gPiA+IE9uIFR1ZSwgSnVsIDMwLCAyMDI0IGF0
IDA3OjQ3OjUxQU0gLTA3MDAsIERhcnJpY2sgSi4gV29uZyB3cm90ZToNCj4gPiA+ID4gPiBPbiBU
dWUsIEp1bCAzMCwgMjAyNCBhdCAwMzo1Njo1M1BNICswODAwLCBNYSBYaW5qaWFuIHdyb3RlOg0K
PiA+ID4gPiA+ID4gVGhpcyB0ZXN0IHJlcXVpcmVzIGEga2VybmVsIHBhdGNoIHNpbmNlIDNiZjk2
M2E2YzYgKCJ4ZnMvMzQ4Og0KPiA+ID4gPiA+ID4gcGFydGlhbGx5IHJldmVydCBkYmNjNTQ5MzE3
IiksIHNvIG5vdGUgdGhhdCBpbiB0aGUgdGVzdC4NCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBT
aWduZWQtb2ZmLWJ5OiBNYSBYaW5qaWFuIDxtYXhqLmZuc3RAZnVqaXRzdS5jb20+DQo+ID4gPiA+
ID4gPiAtLS0NCj4gPiA+ID4gPiA+ICB0ZXN0cy94ZnMvMzQ4IHwgMyArKysNCj4gPiA+ID4gPiA+
ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+
ID4gZGlmZiAtLWdpdCBhL3Rlc3RzL3hmcy8zNDggYi90ZXN0cy94ZnMvMzQ4IGluZGV4DQo+ID4g
PiA+ID4gPiAzNTAyNjA1Yy4uZTRiYzEzMjggMTAwNzU1DQo+ID4gPiA+ID4gPiAtLS0gYS90ZXN0
cy94ZnMvMzQ4DQo+ID4gPiA+ID4gPiArKysgYi90ZXN0cy94ZnMvMzQ4DQo+ID4gPiA+ID4gPiBA
QCAtMTIsNiArMTIsOSBAQA0KPiA+ID4gPiA+ID4gIC4gLi9jb21tb24vcHJlYW1ibGUNCj4gPiA+
ID4gPiA+ICBfYmVnaW5fZnN0ZXN0IGF1dG8gcXVpY2sgZnV6emVycyByZXBhaXINCj4gPiA+ID4g
PiA+DQo+ID4gPiA+ID4gPiArX2ZpeGVkX2J5X2dpdF9jb21taXQga2VybmVsIDM4ZGU1Njc5MDZk
OTUgXA0KPiA+ID4gPiA+ID4gKwkieGZzOiBhbGxvdyBzeW1saW5rcyB3aXRoIHNob3J0IHJlbW90
ZSB0YXJnZXRzIg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gQ29uc2lkZXJpbmcgdGhhdCAzOGRlNTY3
OTA2ZDk1IGlzIGl0c2VsZiBhIGZpeCBmb3INCj4gPiA+ID4gPiAxZWI3MGY1NGM0NDVmLCBkbyB3
ZSB3YW50IGEgX2Jyb2tlbl9ieV9naXRfY29tbWl0IHRvIHdhcm4gcGVvcGxlDQo+ID4gPiA+ID4g
bm90IHRvIGFwcGx5IDFlYjcwIHdpdGhvdXQgYWxzbyBhcHBseWluZyAzOGRlNT8NCj4gPiA+ID4N
Cj4gPiA+ID4gV2UgYWxyZWFkeSBoYXZlIF93YW50c194eHh4X2NvbW1pdCBhbmQgX2ZpeGVkX2J5
X3h4eHhfY29tbWl0LCBmb3INCj4gPiA+ID4gbm93LCBJIGRvbid0IHRoaW5rIHdlIG5lZWQgYSBu
ZXcgb25lLiBNYXliZToNCj4gPiA+ID4NCj4gPiA+ID4gICBfZml4ZWRfYnlfa2VybmVsX2NvbW1p
dCAzOGRlNTY3OTA2ZDk1IC4uLi4uLi4uLi4uLi4uDQo+ID4gPiA+ICAgX3dhbnRzX2tlcm5lbF9j
b21taXQgMWViNzBmNTRjNDQ1ZiAuLi4uLi4uLi4uLi4uDQo+ID4gPiA+DQo+ID4gPiA+IG1ha2Ug
c2Vuc2U/IEFuZCB1c2Ugc29tZSBjb21tZW50cyB0byBleHBsYWluIHdoeSAxZWI3MCBpcyB3YW50
ZWQ/DQo+ID4gPg0KPiA+ID4gT2ghICBJIGRpZG4ndCByZWFsaXplIHdlIGhhZCBfd2FudHNfa2Vy
bmVsX2NvbW1pdC4gIFllYWgsIHRoYXQncyBmaW5lLg0KPiA+DQo+ID4NCj4gPiBIaSBEYXJyaWNr
DQo+ID4NCj4gPiBTb3JyeSwgSSBzdGlsbCBkb24ndCBxdWl0ZSB1bmRlcnN0YW5kIHlvdXIgaW50
ZW50aW9uLg0KPiA+IENvbnNpZGVyaW5nIHRoYXQgMzhkZTU2NzkwNmQ5NSBpcyBhIGZpeCBmb3Ig
MWViNzBmNTRjNDQ1ZiwgSSB0aGluayB0aGUgY3VycmVudA0KPiB4ZnMvMzQ4IHRlc3Qgc2hvdWxk
IGhhdmUgdGhlIGZvbGxvd2luZyAzIHNpdHVhdGlvbnM6DQo+ID4gMS4gTmVpdGhlciAxZWI3MGY1
NGM0NDVmIG5vciAzOGRlNTY3OTA2ZDk1IGFyZSBhcHBsaWVkIGluIHRoZSBrZXJuZWw6DQo+ID4g
eGZzLzM0OCBwYXNzZXMgMi4gT25seSAxZWI3MGY1NGM0NDVmIGlzIGFwcGxpZWQgaW4gdGhlIGtl
cm5lbCB3aXRob3V0DQo+ID4gMzhkZTU2NzkwNmQ5NTogeGZzLzM0OCBmYWlscyAzLiBCb3RoIDFl
YjcwZjU0YzQ0NWYgYW5kIDFlYjcwZjU0YzQ0NWYNCj4gPiBhcmUgYXBwbGllZCBpbiB0aGUga2Vy
bmVsOiB4ZnMvMzQ4IHBhc3NlcyBUaGUgc2l0dWF0aW9uIG9mICIgT25seQ0KPiAzOGRlNTY3OTA2
ZDk1IGlzIGFwcGxpZWQgaW4gdGhlIGtlcm5lbCB3aXRob3V0IDFlYjcwZjU0YzQ0NWYgIiBzaG91
bGQgbm90DQo+IGV4aXN0Lg0KPiA+DQo+ID4gU2luY2Ugb25seSB0aGUgc2Vjb25kIGNhc2UgZmFp
bHMsIEkgdGhpbmsgaXQncyBzdWZmaWNpZW50IHRvIGp1c3QgcG9pbnQgb3V0IHRoYXQNCj4gMzhk
ZTU2NzkwNmQ5NSBtaWdodCBiZSBtaXNzaW5nIHVzaW5nICJfZml4ZWRfYnlfa2VybmVsX2NvbW1p
dCAiLg0KPiA+IElmIG15IHVuZGVyc3RhbmRpbmcgaXMgd3JvbmcsIGZlZWwgZnJlZSB0byBjb3Jy
ZWN0IG1lLCB0aGFuayB5b3UgdmVyeSBtdWNoLg0KPiANCj4gMWViNzBmNTRjNDQ1ZiB3YXMgYSBi
dWdmaXggZm9yIGEgbnVsbCBwb2ludGVyIGRlcmVmZXJlbmNlIGR1ZSB0byBpbnN1ZmZpY2llbnQN
Cj4gdmFsaWRhdGlvbiwgc28gd2UgcmVhbGx5IC9kby8gd2FudCB0byBudWRnZSBrZXJuZWwgZGlz
dHJpYnV0b3JzIHRvIGFkZCBpdCAoYW5kDQo+IDM4ZGU1Njc5MDZkOTUpIHRvIHRoZWlyIGtlcm5l
bHMgaWYgdGhleSBkb24ndCBoYXZlIGVpdGhlci4NCj4gDQo+IEJ1dCBJIHNlZSB5b3VyIHBvaW50
IHRoYXQgeGZzLzM0OCB3aWxsIHBhc3Mgd2l0aG91dCBlaXRoZXIgYXBwbGllZCwgc28gdGhhdCdz
IG5vdA0KPiBtdWNoIG9mIGEgbnVkZ2UuICBJbiB0aGUgZW5kLCBJJ2QgcmF0aGVyIHRoaXMgd2Vu
dCBpbiB3aXRoIGFubm90YXRpb25zIGZvciBib3RoDQo+IGNvbW1pdHMsIGJ1dCBpZiBab3JybyBk
ZWNpZGVzIHRoYXQgb25seSBub3RpbmcNCj4gMzhkZTU2NzkwNmQ5NSBpcyBvaywgdGhlbiBJJ2xs
IGdvIGFsb25nIHdpdGggdGhhdCB0b28uDQoNCkhpIERhcnJpY2sNCg0KVGhhbmsgeW91IGZvciB0
aGUgZXhwbGFuYXRpb24uIEkgdW5kZXJzdGFuZCB5b3VyIGNvbnNpZGVyYXRpb25zIG5vdy4NClNv
cnJ5LCBJIG9ubHkgY29uc2lkZXJlZCB3aGV0aGVyIHhmcy8zNDggcGFzc2VkLg0KSSBoYXZlIHN1
Ym1pdHRlZCBbUEFUQ0ggdjJdIHhmcy8zNDg6IGFkZCBoZWxwZXIgdGFncy4gUFRBTC4NCg0KQmVz
dCByZWdhcmRzDQpNYQ0KPiANCj4gLS1EDQo+IA0KPiA+IEJlc3QgcmVnYXJkcw0KPiA+IE1hDQo+
ID4gPg0KPiA+ID4gLS1EDQo+ID4gPg0KPiA+ID4gPiBUaGFua3MsDQo+ID4gPiA+IFpvcnJvDQo+
ID4gPiA+DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiAtLUQNCj4gPiA+ID4gPg0KPiA+ID4gPiA+ID4g
Kw0KPiA+ID4gPiA+ID4gICMgSW1wb3J0IGNvbW1vbiBmdW5jdGlvbnMuDQo+ID4gPiA+ID4gPiAg
LiAuL2NvbW1vbi9maWx0ZXINCj4gPiA+ID4gPiA+ICAuIC4vY29tbW9uL3JlcGFpcg0KPiA+ID4g
PiA+ID4gLS0NCj4gPiA+ID4gPiA+IDIuNDIuMA0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+DQo+
ID4gPiA+ID4NCj4gPiA+ID4NCj4gPiA+ID4NCg==
