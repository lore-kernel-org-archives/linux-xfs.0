Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4362110E
	for <linux-xfs@vger.kernel.org>; Thu,  6 Jun 2024 18:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717697793; cv=fail; b=Gpd9wU20vbu4SeMx4z3zV23XRiCDoZbp7HneuS1GS9iQyDR3VU9ohVxeKVlw5bnSMHEw9e9cgFVW25vmjAaHj7OGRmQ5B0OtpVVg47xBqo9cgvs+sDDE/Aaep5xrLMy/o7sGGFEwoaU7UR3DfYaMyAM2rTL9ub1XnuvH0tqOdi8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717697793; c=relaxed/simple;
	bh=pIyK1Ve8lMjuRqgN0cGLOGm7uPnrtwG8DqZFPujjn3o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UV2VlrqQ0lgOKYFM3gtHTlB+M722g6d8vNlcVVO2d7F9Fzxl9PMMemBoG5l8wZAu6iM5MbRb8ovHbPSh0UnNJj6bd6mKe78PES5qwSPmNKZ9aAPDpSL8e6qaB7AqAsP3ZFxkup91lI5/wh5+AFRweHRPlgywKLekU7hVl1e6jUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AH05RAAO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kHOtmg6l; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AH05RAAO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kHOtmg6l"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 456Hxbli021769;
	Thu, 6 Jun 2024 18:16:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc : content-id :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=corp-2023-11-20;
 bh=pIyK1Ve8lMjuRqgN0cGLOGm7uPnrtwG8DqZFPujjn3o=;
 b=AH05RAAO/xgl5iSrk9dUrw2bNXh5RtnQQjkGaMdGTw9vRx5stCiumt7qsNTeFcpiv4gN
 DRN4jHtzDfVr+Sk0Ix3eoPw6hmqBYTiApiRpIEABpo+nntVAxP1oU1NFWeWV2vS3nzPf
 9c4PEOII8+BI+vri8VhQnWAb7XkpC2lBaWRCdl23uWxJz/jk650rs9zE8H2sGe3K1fDp
 piZJZHtGK44SQEz3IVIIDCtpw+gzn3l6hFI36aYmKyTXxWaeKckxzzlNCBJOJVqledN6
 8bV69B8sHWhHBQNDGI8rl7OZhxFSBSr20QStGK/oyqHe4uT+3tTRNDHl5zq0AJzNTqT/ 9g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yjbsyc4q4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Jun 2024 18:16:27 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 456HQQpq016172;
	Thu, 6 Jun 2024 18:16:26 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrsdfm2b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Jun 2024 18:16:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aFHUix9X2IpB8NM4NRXBJuRszJQ+eV9dejEm6TS9nTG34GcTh46/pqhygMbOxsZ2xgsEgybPxrJlFSEYIOt2/H1/g+eH/HOzSMwUSM+Em7n9zLPt7snlErIggQ6SnspOviOLtxbnqEGpJKsb2bBTkLusUpEhJ41VUJx1Bz9wJRT6awd5IffVfxYkBdXGT5V49QN0N6VTQ/3MidXYVwMcPbHGTth6bdIQCdCSPYkzqqVXR5VTSwsE57q8b6IpLkvZP+EJ40zdvsWfmBvKyrwod28K+yFYIDfjZ+5EEy8DnAwBdy3Nqei8C6TVaKIDQPFnI9b92hbBlOK5tAm3M+2kIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pIyK1Ve8lMjuRqgN0cGLOGm7uPnrtwG8DqZFPujjn3o=;
 b=AfPZ6jDBmfJOrlTColyvE3hl51RZ3iZkJC2xYhMldImDpFmg6GzKehwgt84+oG/PhJJdNTyU8XnqQ37vB3wfcIEGTNXKRjMrYhc4fmeUTVAc+Ns839OKKiKpNXFpKgzkh8v3GaLTCasxLuGp18acfHv1H/mqarnzQD3LTm8ZrqMgtSH9uJer/yZqN5/BOV5vgGnC6BnbfpMoGtmcyCU9dgsMQ1JG6bPXh2Br2TMFSl28B3OCtqC6M1Eyqh2SFj1gDw2FPf9cJaBm+opnjbWgeLg4fsnrmSZVQzmSjv+nlmgF7Aeb5Yv9gzzjJPVskWfpvX566DGisYr0HHvpxMWQMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pIyK1Ve8lMjuRqgN0cGLOGm7uPnrtwG8DqZFPujjn3o=;
 b=kHOtmg6lullPP9mbjxKLCEnxENvxH2+gwUs9tMY8v+gSzjXAql1AodL/7OeRUmgNFOAL0RTvEfTYogRMLQ9/k2/9F/QwyWpKSCd3ZGxJzp91HvI24hfPE6D966xKyk4lpOcgDosoLNC+8dN4ijPGBoxxUnaqr00SQa59JMTJCzA=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by MW4PR10MB6347.namprd10.prod.outlook.com (2603:10b6:303:1eb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.33; Thu, 6 Jun
 2024 18:16:23 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%4]) with mapi id 15.20.7633.033; Thu, 6 Jun 2024
 18:16:23 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: dont remain new blocks in cowfork for unshare
Thread-Topic: [PATCH] xfs: dont remain new blocks in cowfork for unshare
Thread-Index: AQHaqKDf/Bk+8/H/PUavladS1T7uCbGgcEQAgABMSACAENmfgIAAH2OAgAl0aQA=
Date: Thu, 6 Jun 2024 18:16:23 +0000
Message-ID: <03DE362C-9CB7-4D14-AAEF-AEB29DB37052@oracle.com>
References: <20240517212621.9394-1-wen.gang.wang@oracle.com>
 <20240520180848.GI25518@frogsfrogsfrogs>
 <DA28C74B-7514-48E2-BC86-DA9A9824CDA5@oracle.com>
 <20240531160053.GQ52987@frogsfrogsfrogs>
 <B19C20F1-CFD1-47A3-B0F0-F69C66CD58F7@oracle.com>
In-Reply-To: <B19C20F1-CFD1-47A3-B0F0-F69C66CD58F7@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|MW4PR10MB6347:EE_
x-ms-office365-filtering-correlation-id: 7c40bb47-4433-47a4-fb72-08dc8654c5c8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: 
 =?utf-8?B?RlZlRFpZZGJvYVFmckRPUkNMOVVCV01Fakh4bkpoR0IvWUN6RmdSb0MzelQ4?=
 =?utf-8?B?MTZDeTFycWlObGVndVpTVWU0TFgyRis1OFR5N2g3dzdHUW10dUtMS1hsOWc0?=
 =?utf-8?B?UkNRdkZVc2lGY3JuTWtIZG1Ea0VzMG1kc1V5a2JsSlo5eSthZE4zcTlqcURH?=
 =?utf-8?B?aGlvT3oxTHlQcjVwYmRNU2tJRThhQkE2SmJ0enpnZkhyc3pVRjV5SUJTeHFO?=
 =?utf-8?B?YjRYY21KM2JsS2E4MlgvSnRmbk9FWm5IZHFVK2JOV1FxUWRFTUVZTm9mNHZU?=
 =?utf-8?B?Ris5N0daQ2NCUmRJVEUyUmNmY3BJbFNIZlVqZ3BrMzhjWEtDZklXVW9ITDJE?=
 =?utf-8?B?TUxUN3NGTFBrVUJOUDg1bnFzekJZSlorR2RiVVNGK2dJMklmQjFhNVZHM3pN?=
 =?utf-8?B?b2E4dTVkcExhWVphZjNWUUx1Nk92VVNQb1RpZG9rZ2RkMC9VZUdORFVZWDk5?=
 =?utf-8?B?YXBOZ2hOT0FoaFRIdjlaZ01xV2UyMmVSVVlKbStYVXV5MmlOdkdWZDFJNWhK?=
 =?utf-8?B?K0Z3eWw3QnVVeEJBRzNCYVk4bEVXdS8wSm1zOUNybjJyUlZ5elBvSlBNbitF?=
 =?utf-8?B?T0xsZURBTWU0MXdNd1ZFcE1BaDZVcTVSZ2RHSDlhMkNlQVV5VTEzczNxdHpk?=
 =?utf-8?B?RkRlY1A5Y0NvNEtibTBsdnh4OFZXZ2YxOTNnc2ZGSnlnMlA0ZWExOW9YdkFF?=
 =?utf-8?B?NWZ3RllqWnhEVjN1K1RzL3R2S3A0c3JFcFRGYUZVb3FtU3NQWm4wekN4VVNT?=
 =?utf-8?B?MHY0WDFaUmErcEpISzFCUVdMekNHWllvZGRtQlZwZms0alN2VlJYbDVaUTIw?=
 =?utf-8?B?bTRCWVg4YkMxQ0REOXNKYkR5QXREc3hsVWUxZGp5SE5ndnBYYkJjVFA0Qm1Z?=
 =?utf-8?B?eUp3ZlJmSzN3ZWp0Y1dSaXlyY3JMZXc3ZG1DMUw0TUt4MHRiekZqcXE5aGhP?=
 =?utf-8?B?QkswTGVFbGN0MWJCalVWemdMTGl3c3hka3JVdHVGTnp2cDFhK3lXMVREUTRV?=
 =?utf-8?B?bHVmOXFKV2REQXloNHo0WUNJVG5aUFp6WVltTGZZNC9TOTQrQTUwbFlDbHNS?=
 =?utf-8?B?TXBnKyt2dlJKWDQzTTdSSkozWG5lbTdseGNJY2dhMy9PUEovWXoyczhvblJh?=
 =?utf-8?B?K2tTTDBGdDBRUEV0cFBHRnpSZVdVbkloL1F6N1duK1hmSGFBTWVQNTFFWUlU?=
 =?utf-8?B?SE5uUlFwd25NZ1A1N1VVLzlwTTJNWFJ0NzRpWHVpTU4rYk10KzRIYW9IcW8r?=
 =?utf-8?B?eUNzT0t5cEkzc0ZERW9HQ3ByOUlxaXcwTjNmRnViZUVHcStCMCtsdkM4aFQw?=
 =?utf-8?B?NGM0c0Y4aUJXTXNTd0ozak5LOEVReW1IVG0wRC93NGR2ZC80TVM1bGFUYnhl?=
 =?utf-8?B?T2R1RWpKa1g2MFYzeUMycU9xMGViVm1zOFZhbHAxNXV3RHZkZjRXYTd6U3dM?=
 =?utf-8?B?ZEYvOExRbUhscFV6bGthSm9LS1NyWEx1Y3RqbWduN2tURERtaTNyNU1mUzNG?=
 =?utf-8?B?dzMxUkVsMWlWTUlYSlZPUG5SMWxpV0d0S0xERUdVSFpBTHdJd2RUNlpBb2R2?=
 =?utf-8?B?a0NVZXZtTC9tbTBsL2dER08wTnR3ZUtySTR6cmlab3kxbUdHRnU2ZmV1V2p4?=
 =?utf-8?B?di92Z01RbDhNbTQwRkllTDcxR2ZURjM5Ym8yYmRFL1ZDSmwxUFdFdFRTSmwv?=
 =?utf-8?B?RVp1RU52SnhRR29ISW9TOXRock51eTRDNGc1UXBRdGtMMmg3THJneTl2Nkdv?=
 =?utf-8?B?OUdGZnB3R01WU1NPMHB5WEh2NW4yTFRzallxZXVtam1veEthU3B3NGxWVi9t?=
 =?utf-8?Q?25mcCGEJv1zgXwUDCBGoINjKw4ZmCQ1PLah6w=3D?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?eDl6L2xJZmtmUks3V3JQNHpyNnNmdVJTQ21KK3Q1VUVjWThlaWErUTJ1NDN3?=
 =?utf-8?B?QjE0OEdEbEZhcS9zK0duTTNvenJ2blJ2cThNSmJFYjIzc09DalFhZlFNZHpG?=
 =?utf-8?B?SjR4SU1udGhGbk5CV0NJcGZna0czblR3bHM3amZRMks2WXBtUENpeFU4aXNM?=
 =?utf-8?B?ZnFDRExqMnByT0t1a29vOWQ4WExoOFdxcUxvclBrdEJVUHdZbHY0SzBQdFEr?=
 =?utf-8?B?T01lK0V2ZFdBem5TVXltemxDbU0vbWlmMFd2K0pKRDBuTXBOenRNMEVzU0NG?=
 =?utf-8?B?aVlGK3BsWlFYdktUQjRIYlY3NTNMRTdrc0RJeWNWbENYenJuemwxcTRuUE1i?=
 =?utf-8?B?TkJoTE1GWDJhRlRWSEpUSXd3ejJQVW5hVTJMcnNTbzF2aDdTcFFGUmxnR3Ux?=
 =?utf-8?B?b2dSSW1peXJWcmU2K0hUNjY1ZklzcHkzRzc5UG9NbWVnWVF2dGdESElHdlNl?=
 =?utf-8?B?UmhLTHRrWkJmeXFGTFhwUG90ajdUOWNxeG1xNUhwakg1RW1ESGp0VkZKZVp6?=
 =?utf-8?B?QmFFVzFqQ2tIMS80ME5TUWlaUWtXZG1pSUVscGlBTElOT3JRaUZRMFlRbzBz?=
 =?utf-8?B?Ymk3OVN4cVNWdTkxWVpuN2lNYTNyenVtOFpwWXdXcm9vVk82N2o0SlZ5L21h?=
 =?utf-8?B?bWZveHBCNGsxRi9TL3psVjB0QUYvVE9ReVpXMXlVbndjcVQxRnFNVG51eUpz?=
 =?utf-8?B?YW5WVjd3eFdPUzFoWTZnSHlrVy9xMFF2QnZPTURTRytFenpyK2ZDZlpXUk00?=
 =?utf-8?B?L01RdUpNMTIyV1RMdVh6RFZVdkkvM1RzZUJGZ21aQm4xaEt6aStwbHlvRFph?=
 =?utf-8?B?ZjlNajVrWnJxYXBPMnBHYUI4aTJVMTJreFJuUFllMUJlVXYzczdwdlUrRWZk?=
 =?utf-8?B?YWROanUyQjg4aTVXczhwSkV1TWlNbzIwWG9JUE9wY2FkRnI5VWdYUWtDNmhT?=
 =?utf-8?B?UlpJTENSNVhSMjdUVWlOa2EwSmkyQTVmbi9LNDA4RmRFdWRBZzRvY0pEeS9W?=
 =?utf-8?B?NnZXZlREVDNlTXhwVnJhdVJRTE9tK0NkZURiT21LWGl3YnI0Unp1WlBMK2Rt?=
 =?utf-8?B?Sm9XWG82MWRBdjhWOEpJajJCS1VHZ0ZaSXlVaEpodnRUd1hMeUVSOHIzL3pF?=
 =?utf-8?B?bk80VjhNWUQxdkJTS1FUeTAwSDVhSlBLaXVpbVdKeFhxNlZZeTZ0VzBKaWpz?=
 =?utf-8?B?eWFXZktWUHJoc1BlVzhsRXBuZVlGMnEwSndqSDdLd3RiTnFkamxkSTZ0ZGVz?=
 =?utf-8?B?cTA3TStka1QvYi9lYUFNTTBnTHprUW1aSUUvNEd2b0U3VEh6aUNNNm90aUF1?=
 =?utf-8?B?RlhyaDJRcWU3dXlBTGpZNTVaM1gxbFQ3SGgycTZEb2dPc2FaZ3AvSzM5Mmtj?=
 =?utf-8?B?dVJCYnU2aXBsV2lIekI0WnBLaVNOTXR3dXZCZkV1YlpRSm1hbS8rV0RSYVEw?=
 =?utf-8?B?UWw5alhyZ3U2MUY3d1pFbjBKNVhuWFRPSkNzRFFhcFlpWXpRSUl2V3cwcDlr?=
 =?utf-8?B?dUR6QVc2eE9yakJyck4yaElBWkNONVZxTGZCMnptTndYY29ESzROZk9DaXNG?=
 =?utf-8?B?TkxYQnhFZjVuVUxPMVBXVG4xVGV4aUsvS004TTBaYUdZOTlla0ZhZjJ2eVFm?=
 =?utf-8?B?ZDQxRWJGbUVHRk5RSnA5ZVY4WXRIQ2ZuYjJxQmZvYUswVFJnRVRkcTRvREgx?=
 =?utf-8?B?TndMd0NIbFBiMmkxNHpGRlo4dlZsNStoREFPSU9icnAwcFl1T1NnbEpKRkJZ?=
 =?utf-8?B?dWw1VWJ4RkF2U3RtSVE5bUhRRE5RYjR3VEdNWVpiRW92dzQ1Z2tBQ2IzUzlM?=
 =?utf-8?B?Y1dObHFQYUlsaG9SRStoYit1RzZRN09HdmdQcUxCT1BzMTJLVHZFYVdDbjY1?=
 =?utf-8?B?cTdET0hQcUFsVU9KUkxtSXEwMm1EL0duSUZqVWVrLzg1MkdobThibzZUaHlQ?=
 =?utf-8?B?NVBITTZuR01WS1UybW9VQ2sxSU1yUDNLQUNxaGFpVHZ1ZTd5L1crYlBlUlho?=
 =?utf-8?B?R3BuYzhyV0xLV3QzZFRaK2NSTWNxN1dzRm56RDVnZXh0aGxoSkoxSnVUUmhq?=
 =?utf-8?B?amRoMDlzdGFqTkJud3JZbzUzLzFLVU9hVlJjRDBtMlZGVjNDZ2N2LzgzQ3FC?=
 =?utf-8?B?VzNCTWZ5c3VxejNMWmw1Vkp2RkFaWU0zeWtuODZNd0lVNzZVRkRyZklaeXVP?=
 =?utf-8?B?UGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <99CF67224351B544B57816506D16B987@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	cRFHKOnXkCVAC21fgXzxLatWgELdUGUI1//d0ZK/bF2hJxbX/6uPpFsajtmr9nuz4P5BaYLp5elxx8FjC7h3h9yJUf8q0ihXDoQt+sIpKmx3gJQlQM6yAeL2ygkOWEjk+MTsGe6Hajc7VOgyNwGm4PEdci+6YnfJHJi3pz6TvPd873ny8qY0V0biGrxKrNMusH1zyDjK64nVnXSK0sxEMnlTKc2jvgBNvuXCwpVt+PDx3Qxx2v4YJHIThabDlNYnondERcd5AE5IUX0skjKu3EbcHAo0Hibsh4U4JN610k2v6cDKSd40mCHevWikSBXaTwEJtklwejw4Fj+r0O234hWweA+ByQcKM0ksDqtzGwn9QZENhHH13CpQZTkuvNswybvep3HR1RvazBOYD3LR33Ds42vLeDFc81yy/CMyl/s6AhWpHy+Ec47RiMX0sKTvI3E1N2/Er4rcAxMPostAICROELmvMTi5A7K72IQVfqnSC3GBx4+VTWpgsIyo6hyArEtNEDgtqX6J/cTi0UKldOz0YFruq6jmbNfsCr55Rags9IskChgXT7QuCF/BQ7XZDh8oaptazDMLIbLesNzFrNiqMtRq0fO+nClixEidEkM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c40bb47-4433-47a4-fb72-08dc8654c5c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2024 18:16:23.3090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xcyvsDD5fI6V5Cu/yOm/Dhb+PX8VtztkvmM62AkQ9mTEKfXOCTe8uCMPEbQKMxsmoOmvKJ5IeA1AE2iYo28h/+EAUzw64imgqYTISI7y3OU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6347
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-06_14,2024-06-06_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 malwarescore=0 suspectscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406060127
X-Proofpoint-GUID: VZU9PMyLkMSoLp2ePRU50unCckk-XT43
X-Proofpoint-ORIG-GUID: VZU9PMyLkMSoLp2ePRU50unCckk-XT43

DQoNCj4gT24gTWF5IDMxLCAyMDI0LCBhdCAxMDo1M+KAr0FNLCBXZW5nYW5nIFdhbmcgPHdlbi5n
YW5nLndhbmdAb3JhY2xlLmNvbT4gd3JvdGU6DQo+IA0KPiANCj4gDQo+PiBPbiBNYXkgMzEsIDIw
MjQsIGF0IDk6MDDigK9BTSwgRGFycmljayBKLiBXb25nIDxkandvbmdAa2VybmVsLm9yZz4gd3Jv
dGU6DQo+PiANCj4+IE9uIE1vbiwgTWF5IDIwLCAyMDI0IGF0IDEwOjQyOjAyUE0gKzAwMDAsIFdl
bmdhbmcgV2FuZyB3cm90ZToNCj4+PiBUaGFua3MgRGFycmljayBmb3IgcmV2aWV3LCBwbHMgc2Vl
IGlubGluZXM6DQo+Pj4gDQo+Pj4+IE9uIE1heSAyMCwgMjAyNCwgYXQgMTE6MDjigK9BTSwgRGFy
cmljayBKLiBXb25nIDxkandvbmdAa2VybmVsLm9yZz4gd3JvdGU6DQo+Pj4+IA0KPj4+PiBPbiBG
cmksIE1heSAxNywgMjAyNCBhdCAwMjoyNjoyMVBNIC0wNzAwLCBXZW5nYW5nIFdhbmcgd3JvdGU6
DQo+Pj4+PiBVbnNoYXJpbmcgYmxvY2tzIGlzIGltcGxlbWVudGVkIGJ5IGRvaW5nIENvVyB0byB0
aG9zZSBibG9ja3MuIFRoYXQgaGFzIGEgc2lkZQ0KPj4+Pj4gZWZmZWN0IHRoYXQgc29tZSBuZXcg
YWxsb2NhdGQgYmxvY2tzIHJlbWFpbiBpbiBpbm9kZSBDb3cgZm9yay4gQXMgdW5zaGFyaW5nIGJs
b2Nrcw0KPj4+PiANCj4+Pj4gICAgICAgICAgICAgICAgICAgICBhbGxvY2F0ZWQNCj4+Pj4gDQo+
Pj4+PiBoYXMgbm8gaGludCB0aGF0IGZ1dHVyZSB3cml0ZXMgd291bGQgbGlrZSBjb21lIHRvIHRo
ZSBibG9ja3MgdGhhdCBmb2xsb3cgdGhlDQo+Pj4+PiB1bnNoYXJlZCBvbmVzLCB0aGUgZXh0cmEg
YmxvY2tzIGluIENvdyBmb3JrIGlzIG1lYW5pbmdsZXNzLg0KPj4+Pj4gDQo+Pj4+PiBUaGlzIHBh
dGNoIG1ha2VzIHRoYXQgbm8gbmV3IGJsb2NrcyBjYXVzZWQgYnkgdW5zaGFyZSByZW1haW4gaW4g
Q293IGZvcmsuDQo+Pj4+PiBUaGUgY2hhbmdlIGluIHhmc19nZXRfZXh0c3pfaGludCgpIG1ha2Vz
IHRoZSBuZXcgYmxvY2tzIGhhdmUgbW9yZSBjaGFuZ2UgdG8gYmUNCj4+Pj4+IGNvbnRpZ3Vyb3Vz
IGluIHVuc2hhcmUgcGF0aCB3aGVuIHRoZXJlIGFyZSBtdWx0aXBsZSBleHRlbnRzIHRvIHVuc2hh
cmUuDQo+Pj4+IA0KPj4+PiBjb250aWd1b3VzDQo+Pj4+IA0KPj4+IFNvcnJ5IGZvciB0eXBvcy4N
Cj4+PiANCj4+Pj4gQWhhLCBzbyB5b3UncmUgdHJ5aW5nIHRvIGNvbWJhdCBmcmFnbWVudGF0aW9u
IGJ5IG1ha2luZyB1bnNoYXJlIHVzZQ0KPj4+PiBkZWxheWVkIGFsbG9jYXRpb24gc28gdGhhdCB3
ZSB0cnkgdG8gYWxsb2NhdGUgb25lIGJpZyBleHRlbnQgYWxsIGF0IG9uY2UNCj4+Pj4gaW5zdGVh
ZCBvZiBkb2luZyB0aGlzIHBpZWNlIGJ5IHBpZWNlLiAgT3IgbWF5YmUgeW91IGFsc28gZG9uJ3Qg
d2FudA0KPj4+PiB1bnNoYXJlIHRvIHByZWFsbG9jYXRlIGNvdyBleHRlbnRzIGJleW9uZCB0aGUg
cmFuZ2UgcmVxdWVzdGVkPw0KPj4+PiANCj4+PiANCj4+PiBZZXMsIFRoZSBtYWluIHB1cnBvc2Ug
aXMgZm9yIHRoZSBsYXRlciAoYXZvaWQgcHJlYWxsb2NhdGluZyBiZXlvbmQpLg0KPj4gDQo+PiBC
dXQgdGhlIHVzZXIgc2V0IGFuIGV4dGVudCBzaXplIGhpbnQsIHNvIHByZXN1bWFibHkgdGhleSB3
YW50IHVzIHRvICh0cnkNCj4+IHRvKSBvYmV5IHRoYXQgZXZlbiBmb3IgdW5zaGFyZSBvcGVyYXRp
b25zLCByaWdodD8NCj4gDQo+IFllYWgsIHVzZXIgbWlnaHQgc2V0IGV4dHNpemUgZm9yIGJldHRl
ciBJTyBwZXJmb3JtYW5jZS4gQnV0IHRoZXkgZG9u4oCZdCByZWFsbHkga25vdw0KPiBtdWNoIGRl
dGFpbHMuIENvbnNpZGVyIHRoaXMgY2FzZTogDQo+IHdyaXRpbmcgdG8gdGhvc2Ugb3Zlci9iZXlv
bmQgcHJlYWxsb2NhdGVkIGJsb2NrcyB3b3VsZCBjYXVzZSBDb3cuIENvdyBpbmNsdWRlcw0KPiBl
eHRyYSBtZXRhIGNoYW5nZXM6IHJlbGVhc2luZyBvbGQgYmxvY2tzLCBpbnNlcnRpbmcgbmV3IGV4
dGVudHMgdG8gZGF0YSBmb3JrIGFuZCByZW1vdmluZw0KPiBzdGFnaW5nIGV4dGVudHMgZnJvbSBy
ZWZjb3VudCB0cmVlLiAgVGhhdOKAmXMgYSBsb3QsIGFzIEkgdGhpbmssIGEgQ293IGlzIHNsb3dl
ciB0aGFuIGJsb2NrIG92ZXItd3JpdGUuDQo+IEluIGFib3ZlIGNhc2UsIHRoZSBDb3cgaXMgY2F1
c2VkIGJ5IHVuc2hhcmUsIHJhdGhlciB0aGFuIGJ5IHNoYXJlZCBibG9ja3MuIFRoYXQgbWlnaHQg
YmUNCj4gbm90IHdoYXQgdXNlciBleHBlY3RlZCBieSBzZXR0aW5nIGV4dHNpemUuDQo+IA0KPiAN
Ck1heSBJIGtub3cgaWYgdGhpcyBpcyBhIGdvb2QgcmVhc29uIHRvIHNraXAgZXh0c2l6ZSBzZXR0
aW5nLCBvciB3ZSBhbnl3YXlzIGhvbm9yIGV4dHNpemU/DQoNClRoYW5rcywNCldlbmdhbmcNCg0K
