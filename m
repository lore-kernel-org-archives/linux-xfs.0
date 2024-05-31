Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE2E17545
	for <linux-xfs@vger.kernel.org>; Fri, 31 May 2024 15:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717170385; cv=fail; b=SqkYvFaXdAUw5M3PTaqqlR9MYEURVT+nWgnJCDtATFKFS8c+5FYHwPXzayqz9RhDfxu247Mr4ptFOGdjWNqm286YH3vOP1ES/L7ZCXB1z9y5Knkkl66qyF4z7ASzMOg0p3xItFDqtn9z85+rTucJ6P4IF4gPCdY/gVXipjkaNYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717170385; c=relaxed/simple;
	bh=jiAkn11p8veHVbrsm/uFMuukgIgUsxg+bnIK1xqdxrY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nBWgusKS0XH1rzL31CvZ5E6rBGZV/Qu8co7X7XYeAVWNOQV3CZeUGSftOsqSRM5rgKbYTu4zjqcYp5TUSEKlsTS+3mg0lpkWjgyOZ32rswAr9Tw26EZ4MSeoa8ArOcfZTe94OeLZFyuxkzm2j1viTIeOuBvIdnwN4yF8R6oQNm4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44V9VTcG002647;
	Fri, 31 May 2024 15:46:20 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-id:content-transfer-encoding:content-type:date:fr?=
 =?UTF-8?Q?om:in-reply-to:message-id:mime-version:references:subject:to;_s?=
 =?UTF-8?Q?=3Dcorp-2023-11-20;_bh=3DjiAkn11p8veHVbrsm/uFMuukgIgUsxg+bnIK1x?=
 =?UTF-8?Q?qdxrY=3D;_b=3DAK7Fb2KKOAAAodIx7u+1gKLs0snqOOmNNeBw41//pqz9QIhUz?=
 =?UTF-8?Q?7GBEwEHVl96AGNGogBk_QqzmISCwhS/xh38NiWAMY0ANDlUYMBoQOjbA4QmWBKm?=
 =?UTF-8?Q?Kjh9kgBpUY9QprUwfFwUbF8NI_WgaRsOXJsIvVWv/WRapIqEDC//snbZHaMpURa?=
 =?UTF-8?Q?3rdQw77OA2S/rJBXDW+LV9AHsMTqeDA_ykCwfcVQ8fX/Ww9vam3W32smWl/6dF0?=
 =?UTF-8?Q?5jFeFBPbEQ7Y8qriOaY9I1W625DOCaZQf2tcG_CxkPErJjxjpxP8z6f93hj7lMA?=
 =?UTF-8?Q?yMBMwwSBYo75GpqIGpr8cB/rnFOCf1KB9oXCwleCs1k_Bg=3D=3D_?=
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yb8hubh9a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 15:46:20 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44VF9w1x019306;
	Fri, 31 May 2024 15:46:19 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yf7r2md5j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 15:46:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TX21rJ3dXSuI2EkeFJ6m0d1vlJL7C1RBWhqMeOcr/vKUHtl/Ivfo9FF+dy91V7lNCELF6bZRcobYKtCg01sEZFH+KrE30G22bss0sG517t/lt7rW7/q+kerDjM3REQ89yZiPcPnn88hKeU/rxBFDNsti2bNoWcJKMyX4B5EWKxxTD7KecrRce342Zy9MwOAwOE81C1Qt+8NLm0/3Z1wcTb0vsJkLWQp+wnwZ0diePtlk+Xsaza37IOAyF2Heb9zmQSBuA5yKE+/YE0kUP7Gkwhiq2IU9SC/w2NigI+d5qzTPPN1TM3tbwoACK08z+htQg/WXSGNln6zSDa80bb9m8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jiAkn11p8veHVbrsm/uFMuukgIgUsxg+bnIK1xqdxrY=;
 b=L6RlU114M2B+njaPRo5+MXn/5bs/RRwjVnd27DTxQD0GLhrOp5yRF28AEySC+eFEbbw0cpTUC4luC+RwPBtaMuQtw/dfre1Qzub+ha6GudO1Ife1u2Q7lx8IQ1YUgmyqfFERDaMNgsc2elnX7dCGXYtB0rawsnQFlRWXXc1Ob7UGuu35V8ZBdq8nGOcoksxwJ3pA9Qu4oGJshKHAQfu7d5CHjs5zWd0GNuij0u40mAiH0p6rM9XtWZeth7+6sLMD8wRqlOGIWUNx/SaoCoFID9XeCS0eefUNAHBgmml/oboJ6KbBN9NNyFLOUa4wVHnfYH0mryFE3YCliv8Rjca7gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jiAkn11p8veHVbrsm/uFMuukgIgUsxg+bnIK1xqdxrY=;
 b=YW9h/NW7hl3bfEzRkzTbUjLogcj/+MBG1KWQ8V19PGTxhDXAM8vqWzTJo0SxUQsXup46jgdWVYsk5XegYL/iLopZj6Y7zpsEfQWDOqUrzoZQ5XKGoF2sN5cJKKHkj4F2t+zP728WaTUfyIscFHP3rvMHf7o80lE3pCVZohMguQw=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by LV8PR10MB7750.namprd10.prod.outlook.com (2603:10b6:408:1ed::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.19; Fri, 31 May
 2024 15:46:17 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%4]) with mapi id 15.20.7633.021; Fri, 31 May 2024
 15:46:17 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: dont remain new blocks in cowfork for unshare
Thread-Topic: [PATCH] xfs: dont remain new blocks in cowfork for unshare
Thread-Index: AQHaqKDf/Bk+8/H/PUavladS1T7uCbGgcEQAgABMSACAENV+AA==
Date: Fri, 31 May 2024 15:46:17 +0000
Message-ID: <020963A5-3681-4FE0-AEFA-4ACD58DDE61C@oracle.com>
References: <20240517212621.9394-1-wen.gang.wang@oracle.com>
 <20240520180848.GI25518@frogsfrogsfrogs>
 <DA28C74B-7514-48E2-BC86-DA9A9824CDA5@oracle.com>
In-Reply-To: <DA28C74B-7514-48E2-BC86-DA9A9824CDA5@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|LV8PR10MB7750:EE_
x-ms-office365-filtering-correlation-id: d16dabc9-1e09-4003-cbb2-08dc8188cf3d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: 
 =?utf-8?B?ZXhMU1NxM3JMczRkT3BoT1RkcjZPdXorOFlvQXdtM0pUSVNmZWxaT2laSjYv?=
 =?utf-8?B?M09oZ2d1YXU3QUh0d1ExVlNucTFLY2hCOWxQejY4SU9oQ1dMU0ZwRkhTWWlT?=
 =?utf-8?B?cEZPRTNaQTRlUEhOQTZMUFpSakZ4UWVGREd3c1plaFFyc2RTSGhtaUdxeTdi?=
 =?utf-8?B?ZkFEelhuZmNvaWQ1bCtuVnlxemdJWCtaYWxZRENtdDVMOHRkb2RvbkdTN3NX?=
 =?utf-8?B?NDd6SkZ3UERDMHY1bmVBQ0xId24vcUcwRlA5N1RwVXJRZngwOXRocVBqd3My?=
 =?utf-8?B?VXZqT0VlK05iSVNSdEJXVE1GYVRoNWtPVTFQeWJsOTVCV2RwTy9GcFRWRW45?=
 =?utf-8?B?aUIrZVFtanVIMEdTTnZ3QWdkMmxQb1BXM1l6cnNPc0c3dTJUQ0Yva2JoZ0No?=
 =?utf-8?B?a01JU3V6ZmtoYm04NHVUcjVmaERQdmZsbXFrVGVVK2tqSFZWR2xwZnRhWlpt?=
 =?utf-8?B?U0pQSS9rd3MrRXAzS2hCcXFPSVFnam9BV1lPcFJOYm0xTFBiaGZkWGYvZG5S?=
 =?utf-8?B?amNoUE12VmxnSGtZaklDQ0EwVGFHeGpQRTZSYmxsck13MGlWYXhvdDd1SWw2?=
 =?utf-8?B?SHVJdVhjUEV0WTM5RkRGM2M0UGd0OWY0SW5vWlQ2VDZGUjM2bUtSV2YrSjRR?=
 =?utf-8?B?ck81YkpISDB1SytsUktTSVdDLzhhWlltTTErazljZGU5RFNLNFUzQUd3Ym5n?=
 =?utf-8?B?c2tTVy9XQjY0NEdSeTFWNTNwNlp0WEpPWDYwTGh1dmI2NmlYdDRrUllpNm9k?=
 =?utf-8?B?SGgycC9hOGtoQTQ5cStrQ3NRTFBBckxMbXQ0WkliQjI4bWNFWWYxMnZrMmUz?=
 =?utf-8?B?MlVITmtqQWczaEdSWjZML2Z5Q2FWbXNYeSt3Qmtub0YrbHp1WU1WbVNJKzd0?=
 =?utf-8?B?NWVEOVJ5bDhpUSt2a21rdWU1NlphYVNLL0tmdmEzMzNUd3hCRlhvVGhrRTQ0?=
 =?utf-8?B?ZzJJRjRhSnladlo3YVhRamw5ODJkeCswOW9ydk1wcW5Edlk5N0FadkcvTEpq?=
 =?utf-8?B?SDhLN3hUcStmY3pmODkwYXl0VGZ3UEFPRFpVSEN4VFEwSkhYaXZlNCtFQm43?=
 =?utf-8?B?RDhpUytLM0Fpd3FiUHo4cHBhMEJpU0pld2dvREhSU0hMQUxKMXFOcWxKZVRE?=
 =?utf-8?B?ZnBoYUVZYUgzQUdaSGVxK0k4NjlRMWlON0RkS2h2VHo2SmtBRktBc2x0Z3ZS?=
 =?utf-8?B?OFVqK2Q1Uit4b0lDNFhjMFJPUHNlbkR5MW5GN2lLeTBnVTl2Vk1HVWU2ZlBh?=
 =?utf-8?B?VVcwa3RDSTZ4RjZ2dXVNanA1OUVFNmR5bStvYmJlNWwxaDN6ajZtQW5CUVZM?=
 =?utf-8?B?ZlpnZTNQaGpBcmw4YkdPS2pYQ2htUDM5clM3UW83UUl5bFE5cGRsQmJHcGJR?=
 =?utf-8?B?dTFFcTBtK0ZFMmlCVFRGQnNyb3FIcWhZZ3hNTStXVDNTRTJ2SXpqamZxSWpQ?=
 =?utf-8?B?U3dnZ2xvdXExSG1nYlMzQmxpTTB2VzRiOExJRWZFVTFGL3ZCdFl4bldQbjFW?=
 =?utf-8?B?UWZnZTdXVi9EM0tEcFplUnZGcVpLcm5XZS9zbjhXQ0tJWXFtcCswcnlEcWU5?=
 =?utf-8?B?U1N1UWs1S3hBRDlPUWNtZEJoY1JWbE94aEMydWRzMXFsRGpxVGJSRVZ4SzI5?=
 =?utf-8?B?NExSdzFZcEZQRDI1K0ZGdVN0UlArZ3g1aDZwaHdqUHR6eTVSUXgwa1owYTBl?=
 =?utf-8?B?SWY5bHZFN1VMd1VOUkZnOFk2aitDaldZRDdvQzYrRzY2QzFySTIwQmV1TTRN?=
 =?utf-8?B?YTlqaW4vWFlwRHJmb2llOFdVd0R2a0Zvbm1hK1NHa3d2TmlGOWk0alBiSnpj?=
 =?utf-8?B?cUdtRzVmeWkzaE00UVpHUT09?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?a2EydVJWRnB5MG1wTWw4OU9zQldHNkNLRVo2YkdnL0YwU3EwSWRTdTRBdVEr?=
 =?utf-8?B?aVg0ZE85ZXA1OG1oSnBTWHVsU0dRUlhXb1NjMVh6TTRqcS9vNVVXMEhPYnVD?=
 =?utf-8?B?aDVVVTlZWTgzanhBZ3pOcjNFSlh5S2NsQ0Z2WXZRYlNSWVB1YzBIWVRZNE0w?=
 =?utf-8?B?Q1JoZFNzRU0wYWJaRDJQTjBFcy9DUDk1S1dRYzlMVXRZTmdONWZKbVhwSndv?=
 =?utf-8?B?NVNNN2NLTnRiUEZ1NWxwUWZ1ZVg5elg4eFp1Zy85KzFjKzlZL2RzY0tRSmNK?=
 =?utf-8?B?VjBxMENwdVBlOXBNMmx6Z1U1VTZva3FXYS9LclMyWW5hOWtIckhlMjRPZ0RU?=
 =?utf-8?B?SWZ1OVBOQXE0R1lCRFlmRXlHeE1wb0lTYWxlRnQzR3huNHU2dGp2OFdBQzVj?=
 =?utf-8?B?aG1RVnJpUktGZTM5eUpJQ0Q5UURib25rNDZ1L2VzdWRnSW1IWFhYUndMUmlx?=
 =?utf-8?B?a2NQZkxoL1RaVEVYQ1ZTclp3NDhmQ29sbG8wUWVvalFqZVBtY1RIdUdjU25t?=
 =?utf-8?B?aTAvbWRjL2NLcHdqYll6ekYrQkpNY2dLSjdZbmR1b0lVNEhaNUZHM3h4VVI4?=
 =?utf-8?B?bkJDYUZKempGd0NNM0JnTndQZjI4eEszdkpLOEE5T0xCNC80ZFg5aGJFVlpV?=
 =?utf-8?B?KzJFKzFrSWhZcDJGQXI5VFpIVDh3Ykw2dlhTVkxYeTUyVnF6Z0ZaRk9lQ25a?=
 =?utf-8?B?azRvQWRoYm5GN2VXNGYxaENJUU0zSHBhUStHQ0hvaU5kTDE3c1NVaUNOTlVO?=
 =?utf-8?B?b2gxK0hqTjE5VXZ3c21RNmpqTlkyKzlBV0R2aTBxYnNpcXh3dXZBT2ZUdkdr?=
 =?utf-8?B?cCtHUHM5YllJeDByWlRJT3JvNFZ5S0lsWWpBT3lEclZNLzkyeVppVjdPR0N3?=
 =?utf-8?B?UUg3ZkpSNlhOMk9iYkRSbFZPYW9RamVVYUJCT2U3RzMraXFhNjVORDJZQXNn?=
 =?utf-8?B?SFlkWUdCT0RmUTdqekVodVIvVklQVHB4TVhZM3pUL3dIVTN0V0ZCSzFoaUlv?=
 =?utf-8?B?WXJ6YWVoMDlXaTRnOHlPZzZSUTk4ZUxMbjVUcFFLOStFYWwxRENPR3ZNTnda?=
 =?utf-8?B?bGVTbWtBMG9PdHQycUZ2eWtvMTBaeWErQTJoMjFYOXVqMTNnalloVk5oUWl0?=
 =?utf-8?B?aUQ1bDA1b1ZIRVRFeWRZOEdxWDRpWDhaNytUdnp4d0oxaHJNNkZUMUI0Rmhy?=
 =?utf-8?B?S0xVSXR6N0tLOEFCcERmdm1QM3E4eko1V0lISEk0OHZnUU82UDhJMFo0UlhC?=
 =?utf-8?B?UitMMWtjaTJ0am83dUhkN2ZOc3dhSGNCOEtOT0ZnaEYxZnFmMk9ERzQxMjk5?=
 =?utf-8?B?a0hCY0tDT2VQSTFIeWtwS2tzMU5vWjU1L1RCcy9EckRGTEg3OTlBOU9FcHVa?=
 =?utf-8?B?UWw3c0VTWFhocU0rQWVPZThTc0JyL2dJR0ZKWGR5ZDV0OGQ2d3VRM0JtdUNX?=
 =?utf-8?B?eXFjMXN2U2RiZzdXazJDQWZyc1lYbXZGK29EQldvbS9EVXlWZFZMVk9yTlJ5?=
 =?utf-8?B?WEN2WEJtRzFpQkgvMThJYXJBODNHdmVtRDhTei8vaTRvc2g2czM0eWREeUlH?=
 =?utf-8?B?clRhNGcvTCtIRjgvK01xTFp5K28vSG8wMXZNazhwcFN2WjNKTk9XbHBLc0pK?=
 =?utf-8?B?TU8xUTU2ay9EZWdsS2w3bXJFK0RnUXhJcm9KTHZIL3J6eXAwdFdTalI0NmxS?=
 =?utf-8?B?bG1Vc1JBd1YvenlMSFhVOGZNZ1dYbUZRakt1N3YycHJhekZkUkJWMmpjYk9M?=
 =?utf-8?B?YThhQVhSVkpVeTh4ckNCc29QYnVuS2EzbnlkOFc5SjJjbHI5QlZUUzYzSTlW?=
 =?utf-8?B?UENFY1JialRvQmdVcGRCUnF4Z0s4WHZjSWttY243ZTRpS1dYd2QrMjFkdEdH?=
 =?utf-8?B?UjljUTFhUTllL044MTUxblpBcGFaMi8vdGl1VUw5Y2R6THcrc1pIOFN5SXFR?=
 =?utf-8?B?TUZ2dm9jV0JVQzFqOWJLNFdxa096Wkc5NEVmYjBTQ0l3SzBlQVhFeWs5cFRk?=
 =?utf-8?B?cEtGeFVpbkZpUll6MElWM2pNdUpDdit3dExzdmN4ZTlXZ1lDaExqTXhjbEpC?=
 =?utf-8?B?dGF0SG1za21QVUVqUG5UWDlvaUp0NXYwa0xleWZ1M1VRSXlVU2NjZ09aRWFX?=
 =?utf-8?B?ajl6L1ZGYTBtaUJrZktiWjBnQmwwWkhHSE5OVEVTOEQzNnk4Mkc5SHlqbFk3?=
 =?utf-8?B?TnpVaEl2RTk1VzRBWW5MT21hVEIrV3JNMnl5cGVoQUdUcFdLV1dRQ0JkSHNv?=
 =?utf-8?B?MUJaZlByOTFVNTJtNU5ZYVlsNElBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2E94A83518E7744DB1B2B570A0C0B7E8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	UZdUc/fWMt5Ue7rIwromDf7uZX4kuhOULCAlObeJ4pQSHtHHoCkAYxRoql+kKgfk3CYgFtBmYfMtmZbkEEO96uTJJbzTpRBTsBrT/Dlv9jR434XQbZOQXg+/Iqidhb3II+08pN3FLd40nfBXmzb+Imy10Mj41GSyzQy1mvNi0BdrxO0fxY05v6BBu6B5Zo0HU+zNd0LXAewaYsltLJPBmYho4Oh9hUbogcRQBGFxHuVD8aunmbTigDIHhf2BubfZZ+31LYM7XUWH4l6103JCFvlQmoBE5FAfaZqz/8CpvRqf4IIN1jnASsohpz/pYBdx0g/jri4mjze+o/Ph/GcfQ5Tl/qSx2Azq/qfVEH3wq2LRxdYsEsEVWSotKXLlVd7+/JBrtjJfh5z2y6Pt8ktJfpyVKt1O8THBHoQPneN1Y3JKfYFTnkyny8IBiTY8JdffGPMDpSr5A936GOtGH27GjwOuhpa7YoIQQnYVzcyh+onA9/set36w4DOlMGt+S5K5ZepBIygx+b6P7RZr4Hv2COfXS9fS99QLjHudSyZOdY9VlOyHe5aSRlXODI7tKc5tm0GV7YcudnHTzvIk1nBkmmnlhJ3gQMoMUA6HC0omL/U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d16dabc9-1e09-4003-cbb2-08dc8188cf3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2024 15:46:17.1970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C5y+kHvlx4pqi0J74PmT6r/6oJgUQb86ePI6+fF9BUVKlDCCFTLv4FT6BTgOH7vKkKNd+/nn3/+8zEq3MxZysp/GC7vwLmNNp9YQA1bm3Hk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7750
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-31_12,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405310118
X-Proofpoint-ORIG-GUID: KI6_ytwfaR5Al2n1gCEg5JN3Zw3xA7xp
X-Proofpoint-GUID: KI6_ytwfaR5Al2n1gCEg5JN3Zw3xA7xp

SGksDQoNCkFueSBpZGVhIG9uIHRoaXM/DQoNClRoYW5rcywNCndlbmdhbmcNCg0KPiBPbiBNYXkg
MjAsIDIwMjQsIGF0IDM6NDLigK9QTSwgV2VuZ2FuZyBXYW5nIDx3ZW4uZ2FuZy53YW5nQG9yYWNs
ZS5jb20+IHdyb3RlOg0KPiANCj4gVGhhbmtzIERhcnJpY2sgZm9yIHJldmlldywgcGxzIHNlZSBp
bmxpbmVzOg0KPiANCj4+IE9uIE1heSAyMCwgMjAyNCwgYXQgMTE6MDjigK9BTSwgRGFycmljayBK
LiBXb25nIDxkandvbmdAa2VybmVsLm9yZz4gd3JvdGU6DQo+PiANCj4+IE9uIEZyaSwgTWF5IDE3
LCAyMDI0IGF0IDAyOjI2OjIxUE0gLTA3MDAsIFdlbmdhbmcgV2FuZyB3cm90ZToNCj4+PiBVbnNo
YXJpbmcgYmxvY2tzIGlzIGltcGxlbWVudGVkIGJ5IGRvaW5nIENvVyB0byB0aG9zZSBibG9ja3Mu
IFRoYXQgaGFzIGEgc2lkZQ0KPj4+IGVmZmVjdCB0aGF0IHNvbWUgbmV3IGFsbG9jYXRkIGJsb2Nr
cyByZW1haW4gaW4gaW5vZGUgQ293IGZvcmsuIEFzIHVuc2hhcmluZyBibG9ja3MNCj4+IA0KPj4g
ICAgICAgICAgICAgICAgICAgICAgYWxsb2NhdGVkDQo+PiANCj4+PiBoYXMgbm8gaGludCB0aGF0
IGZ1dHVyZSB3cml0ZXMgd291bGQgbGlrZSBjb21lIHRvIHRoZSBibG9ja3MgdGhhdCBmb2xsb3cg
dGhlDQo+Pj4gdW5zaGFyZWQgb25lcywgdGhlIGV4dHJhIGJsb2NrcyBpbiBDb3cgZm9yayBpcyBt
ZWFuaW5nbGVzcy4NCj4+PiANCj4+PiBUaGlzIHBhdGNoIG1ha2VzIHRoYXQgbm8gbmV3IGJsb2Nr
cyBjYXVzZWQgYnkgdW5zaGFyZSByZW1haW4gaW4gQ293IGZvcmsuDQo+Pj4gVGhlIGNoYW5nZSBp
biB4ZnNfZ2V0X2V4dHN6X2hpbnQoKSBtYWtlcyB0aGUgbmV3IGJsb2NrcyBoYXZlIG1vcmUgY2hh
bmdlIHRvIGJlDQo+Pj4gY29udGlndXJvdXMgaW4gdW5zaGFyZSBwYXRoIHdoZW4gdGhlcmUgYXJl
IG11bHRpcGxlIGV4dGVudHMgdG8gdW5zaGFyZS4NCj4+IA0KPj4gY29udGlndW91cw0KPj4gDQo+
IFNvcnJ5IGZvciB0eXBvcy4NCj4gDQo+PiBBaGEsIHNvIHlvdSdyZSB0cnlpbmcgdG8gY29tYmF0
IGZyYWdtZW50YXRpb24gYnkgbWFraW5nIHVuc2hhcmUgdXNlDQo+PiBkZWxheWVkIGFsbG9jYXRp
b24gc28gdGhhdCB3ZSB0cnkgdG8gYWxsb2NhdGUgb25lIGJpZyBleHRlbnQgYWxsIGF0IG9uY2UN
Cj4+IGluc3RlYWQgb2YgZG9pbmcgdGhpcyBwaWVjZSBieSBwaWVjZS4gIE9yIG1heWJlIHlvdSBh
bHNvIGRvbid0IHdhbnQNCj4+IHVuc2hhcmUgdG8gcHJlYWxsb2NhdGUgY293IGV4dGVudHMgYmV5
b25kIHRoZSByYW5nZSByZXF1ZXN0ZWQ/DQo+PiANCj4gDQo+IFllcywgVGhlIG1haW4gcHVycG9z
ZSBpcyBmb3IgdGhlIGxhdGVyIChhdm9pZCBwcmVhbGxvY2F0aW5nIGJleW9uZCkuIFRoZSBwYXRj
aA0KPiBhbHNvIG1ha2VzIHVuc2hhcmUgdXNlIGRlbGF5ZWQgYWxsb2NhdGlvbiBmb3IgYmlnZ2Vy
IGV4dGVudC4NCj4gDQo+IA0KPj4+IFNpZ25lZC1vZmYtYnk6IFdlbmdhbmcgV2FuZyA8d2VuLmdh
bmcud2FuZ0BvcmFjbGUuY29tPg0KPj4+IC0tLQ0KPj4+IGZzL3hmcy94ZnNfaW5vZGUuYyAgIHwg
MTcgKysrKysrKysrKysrKysrKw0KPj4+IGZzL3hmcy94ZnNfaW5vZGUuaCAgIHwgNDggKysrKysr
KysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4+PiBmcy94ZnMveGZzX3Jl
ZmxpbmsuYyB8ICA3ICsrKysrLS0NCj4+PiAzIGZpbGVzIGNoYW5nZWQsIDQ3IGluc2VydGlvbnMo
KyksIDI1IGRlbGV0aW9ucygtKQ0KPj4+IA0KPj4+IGRpZmYgLS1naXQgYS9mcy94ZnMveGZzX2lu
b2RlLmMgYi9mcy94ZnMveGZzX2lub2RlLmMNCj4+PiBpbmRleCBkNTViNDJiMjQ4MGQuLmFkZTk0
NWM4ZDc4MyAxMDA2NDQNCj4+PiAtLS0gYS9mcy94ZnMveGZzX2lub2RlLmMNCj4+PiArKysgYi9m
cy94ZnMveGZzX2lub2RlLmMNCj4+PiBAQCAtNTgsNiArNTgsMTUgQEAgeGZzX2dldF9leHRzel9o
aW50KA0KPj4+ICovDQo+Pj4gaWYgKHhmc19pc19hbHdheXNfY293X2lub2RlKGlwKSkNCj4+PiBy
ZXR1cm4gMDsNCj4+PiArDQo+Pj4gKyAvKg0KPj4+ICsgICogbGV0IHhmc19idWZmZXJlZF93cml0
ZV9pb21hcF9iZWdpbigpIGRvIGRlbGF5ZWQgYWxsb2NhdGlvbg0KPj4+ICsgICogaW4gdW5zaGFy
ZSBwYXRoIHNvIHRoYXQgdGhlIG5ldyBibG9ja3MgaGF2ZSBtb3JlIGNoYW5jZSB0bw0KPj4+ICsg
ICogYmUgY29udGlndXJvdXMNCj4+PiArICAqLw0KPj4+ICsgaWYgKHhmc19pZmxhZ3NfdGVzdChp
cCwgWEZTX0lVTlNIQVJFKSkNCj4+PiArIHJldHVybiAwOw0KPj4gDQo+PiBXaGF0IGlmIHRoZSBp
bm9kZSBpcyBhIHJlYWx0aW1lIGZpbGU/ICBXaWxsIHRoaXMgd29yayB3aXRoIHRoZSBydA0KPj4g
ZGVsYWxsb2Mgc3VwcG9ydCBjb21pbmcgb25saW5lIGluIDYuMTA/DQo+IA0KPiBUaGlzIFhGU19J
VU5TSEFSRSBpcyBub3Qgc2V0IGluIHhmc19yZWZsaW5rX3Vuc2hhcmUoKSBmb3IgcnQgaW5vZGVz
LiANCj4gU28gcnQgaW5vZGVzIHdpbGwga2VlcCBjdXJyZW50IGJlaGF2aW9yLg0KPiANCj4+IA0K
Pj4+ICsNCj4+PiBpZiAoKGlwLT5pX2RpZmxhZ3MgJiBYRlNfRElGTEFHX0VYVFNJWkUpICYmIGlw
LT5pX2V4dHNpemUpDQo+Pj4gcmV0dXJuIGlwLT5pX2V4dHNpemU7DQo+Pj4gaWYgKFhGU19JU19S
RUFMVElNRV9JTk9ERShpcCkpDQo+Pj4gQEAgLTc3LDYgKzg2LDE0IEBAIHhmc19nZXRfY293ZXh0
c3pfaGludCgNCj4+PiB7DQo+Pj4geGZzX2V4dGxlbl90IGEsIGI7DQo+Pj4gDQo+Pj4gKyAvKg0K
Pj4+ICsgICogaW4gdW5zaGFyZSBwYXRoLCBhbGxvY2F0ZSBleGFjdGx5IHRoZSBudW1iZXIgb2Yg
dGhlIGJsb2NrcyB0byBiZQ0KPj4+ICsgICogdW5zaGFyZWQgc28gdGhhdCBubyBuZXcgYmxvY2tz
IGNhdXNlZCB0aGUgdW5zaGFyZSBvcGVyYXRpb24gcmVtYWluDQo+Pj4gKyAgKiBpbiBDb3cgZm9y
ayBhZnRlciB0aGUgdW5zaGFyZSBpcyBkb25lDQo+Pj4gKyAgKi8NCj4+PiArIGlmICh4ZnNfaWZs
YWdzX3Rlc3QoaXAsIFhGU19JVU5TSEFSRSkpDQo+Pj4gKyByZXR1cm4gMTsNCj4+IA0KPj4gQWhh
LCBzbyB0aGlzIGlzIGFsc28gYWJvdXQgdHVybmluZyBvZmYgc3BlY3VsYXRpdmUgcHJlYWxsb2Nh
dGlvbnMNCj4+IG91dHNpZGUgdGhlIHJhbmdlIHRoYXQncyBiZWluZyB1bnNoYXJlZD8NCj4gDQo+
IFllcy4NCj4gDQo+PiANCj4+PiArDQo+Pj4gYSA9IDA7DQo+Pj4gaWYgKGlwLT5pX2RpZmxhZ3My
ICYgWEZTX0RJRkxBRzJfQ09XRVhUU0laRSkNCj4+PiBhID0gaXAtPmlfY293ZXh0c2l6ZTsNCj4+
PiBkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc19pbm9kZS5oIGIvZnMveGZzL3hmc19pbm9kZS5oDQo+
Pj4gaW5kZXggYWI0NmZmYjNhYzE5Li42YThhZDY4ZGFjMWUgMTAwNjQ0DQo+Pj4gLS0tIGEvZnMv
eGZzL3hmc19pbm9kZS5oDQo+Pj4gKysrIGIvZnMveGZzL3hmc19pbm9kZS5oDQo+Pj4gQEAgLTIw
NywxMyArMjA3LDEzIEBAIHhmc19uZXdfZW9mKHN0cnVjdCB4ZnNfaW5vZGUgKmlwLCB4ZnNfZnNp
emVfdCBuZXdfc2l6ZSkNCj4+PiAqIGlfZmxhZ3MgaGVscGVyIGZ1bmN0aW9ucw0KPj4+ICovDQo+
Pj4gc3RhdGljIGlubGluZSB2b2lkDQo+Pj4gLV9feGZzX2lmbGFnc19zZXQoeGZzX2lub2RlX3Qg
KmlwLCB1bnNpZ25lZCBzaG9ydCBmbGFncykNCj4+PiArX194ZnNfaWZsYWdzX3NldCh4ZnNfaW5v
ZGVfdCAqaXAsIHVuc2lnbmVkIGxvbmcgZmxhZ3MpDQo+PiANCj4+IEkgdGhpbmsgdGhpcyBpcyBh
bHJlYWR5IHF1ZXVlZCBmb3IgNi4xMC4NCj4gDQo+IEdvb2QgdG8ga25vdy4NCj4gDQo+IFRoYW5r
cywNCj4gV2VuZ2FuZw0KDQoNCg==
