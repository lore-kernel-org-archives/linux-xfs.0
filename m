Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C8D64A98
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jul 2024 19:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721329429; cv=fail; b=F42CJDvOOHAV2BzCkOkfRNylmFa2FoCpfrkbZNC7FD/z3YPFHgyCR/og2Fa//ED7UJQN6+XmcHnhWCZ4t7QNnZndnS869dcBz65tGQC+NAt6S/TC8ZmvvQxLp79Nq4lxgNDsuNIhlu9PmxmHeK79440MvEyMBT33pAH1DKjz5KA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721329429; c=relaxed/simple;
	bh=mySIp+adKUoc3Qi5JJUwxnj+lOU8JKSFRY3SAY/OJmA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sgqScjMCRVc9zyUnG3/ESgOHg1omSzjKzdLVZeZMu6V9TLfsCO9alRXKqOiYPh6oDBi76G3a06iHAtSaxntoaYQGoIoPaEpKd8naU34Cd+qt6leiBF8QHsnJXWD9EOu9K/LmmY51xqOsF18CVu5XwrKiRo32aqyEm8s27NDgy4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Q4fRb+Yz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=R8a3ER+5; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q4fRb+Yz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="R8a3ER+5"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46IIoKF2009889;
	Thu, 18 Jul 2024 19:03:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=mySIp+adKUoc3Qi5JJUwxnj+lOU8JKSFRY3SAY/OJ
	mA=; b=Q4fRb+Yzx8wEaXitmSkAtpyBqeRHiG63vdPdubv+3Ly+U2otS1qmKnerq
	sebGCPIsLMyRNw5mynqG4hWhvEcoJxyx6GAlQ+/PybystokQ9afcvftizNNJ3V96
	yqr6XCSCu4bdifCgD8c9OtPcnYoiU6ENNiq+ACUmrcH/PlabDCj9+qxM8aKm2rJY
	PpaGc7QQLqAA/Jm4RIGFEOmiDqj8wZLk7NAup2rav6JZJHGSqUQjQtBkNl72u+uP
	YNi68DDIqSizbTz6qpp1hkB5XDrNQxndICi/VE7ptyQM5f2bmKOlGLNhRlFyYS9f
	u90NdFYfZyqcuKOdo17JTpqOkXz+g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40f8p501ja-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jul 2024 19:03:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46IIcD7H031676;
	Thu, 18 Jul 2024 19:03:44 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40dwf06stx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jul 2024 19:03:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xTMj47ycpfxsW1inHOzEZsCLS24sCrSzwV5XhfYW79/El3xoOc6SqCMZilNHxgqkNwo33qaAc1g+jB7+K+KTHxWWrN5jqRChKoGmI7ohmPVwhlJm8iSZb+Uk1X8os/PClrV03l3cy4RTVW+ej4m1vpNCV8qppRZOSyQ1HagmZAcaFdT71WELcygD0yV7Ol5hIeisRNZkab3RcXVQ2f89ZPKS1QRF4Cjck3Dy3SbpT/kOd7WfQRjVRlAUMjx0aMM4yfRZpxWEqvBHs47dFOt4QfJZoOGkMq+v0xn/I6Xpt+rcIMIowIWOmQ18qqMHHJWVHmEBcKbKzE0zscmEpavG4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mySIp+adKUoc3Qi5JJUwxnj+lOU8JKSFRY3SAY/OJmA=;
 b=WKjIVZXj9Y/yNjSMTaLKvP2Y72xqbVdD27fxqxy3CGZaGayIqHDwfrobwBGEJrpGpvVkfhV1SC3invlcJe5zXsXk5Qp2ijpna+hQBjzg2QR+nhtnDy2L89jjpjd1LGaAezPgnxt1szHu5TYCj2qeAKuqvTINUGjzSSjQe1FWSWEB8OixhR7YhMbjvNrrNEv8/2dQpG7QEOc8Dkb6mzgH2BCCov/dGnNGM+Glrk4ePLeF4PgncO/QLDPY35h/SUnUNG/cBWnHUznrH94v5rYCDO1M+fyIAtWafzcD0HOolHQipqNozEvyIIQ9SVbwace2daJ5cTb1C2rfZkGHMac/ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mySIp+adKUoc3Qi5JJUwxnj+lOU8JKSFRY3SAY/OJmA=;
 b=R8a3ER+53xjzV+eOUTWxcG0fQhAuir4Ncpxri0TWSIgQDGOwdJyzHqHGqixW9jVmaMrSi+wczb9zUuJkqPrlcrjXz/2gPz8dyZ/J3lrLD6Tv/G4Tv7CK2Cdvsg9ENm2m3TWr9exe0R8jwQxG1T4PrxXwq6jj1VBhX0CdHIpeqsc=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by SA1PR10MB6390.namprd10.prod.outlook.com (2603:10b6:806:256::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.19; Thu, 18 Jul
 2024 19:03:41 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%4]) with mapi id 15.20.7784.017; Thu, 18 Jul 2024
 19:03:41 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: Dave Chinner <david@fromorbit.com>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/9] spaceman/defrag: pick up segments from target file
Thread-Topic: [PATCH 2/9] spaceman/defrag: pick up segments from target file
Thread-Index: AQHa0jOt/CIGTtEk2UiPk1YdzgTPfrH4fHKAgAFbKgCAAIK5AIACi54A
Date: Thu, 18 Jul 2024 19:03:40 +0000
Message-ID: <13B63D08-4EC3-48B3-B043-D38DF345611F@oracle.com>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-3-wen.gang.wang@oracle.com>
 <ZpWzg9Jnko76tAx5@dread.disaster.area>
 <65CF7656-6B69-47A3-90E4-462E052D2543@oracle.com>
 <ZpdEZOWDbg5SKauo@dread.disaster.area>
In-Reply-To: <ZpdEZOWDbg5SKauo@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|SA1PR10MB6390:EE_
x-ms-office365-filtering-correlation-id: 05f3268d-c7c7-4f75-5af1-08dca75c5689
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: 
 =?utf-8?B?Y1JnSG0zSSt2V01sRmhyQXhOeENQUmpMQU9yZFhzZGltZWhaQ2NGZHlJdjF5?=
 =?utf-8?B?YldTQUtGTjJPQXpJRFlPUzNBS3oyemFGR04yNUluSTJHbkhuemVERjBZWGdO?=
 =?utf-8?B?L2V6NXBZeU9DMHpqNi9wSDVWK0FMcW9SbE5PTC94U3BFcEprOXlySEV5Q3dQ?=
 =?utf-8?B?RmZyY2NnK1NSTXRLbzM4MnlYOWROd1NTL0xqcUUwS0tIbTh4V2dma1VGZnV2?=
 =?utf-8?B?aVBZcmZzZ3kvL2NEYkZvbDRoNXFna1llWHBZa3pFMFR0QXZ6WVZSdmdtSlNI?=
 =?utf-8?B?S3VuR3VLa254YVl4SmdCSkI2MDlheEZ2UGo5OEFVTlNqMUtLem9aZDFNUzVK?=
 =?utf-8?B?Rzc2dDQzZDYxNGZieDUzM3d0ckEwYUlCV2FUdkt3azRIaXpBWGIrTEMwTXVQ?=
 =?utf-8?B?R3V5N0tBVkc5T0s0YjhySVVFTzA4UU1DTVBuUEsxUmRjY2IxVktYUXpmekcy?=
 =?utf-8?B?WXlHajk3eW9lbHdMVGUrdlJmL01wTGh6U2tZWW41M3d2RHFmWFc0QmJRRlhL?=
 =?utf-8?B?eUFGdTRmVWZFUURra1c2L3BSLzE1R0YzZ0tOKzdyemsxdEFobnZRc3RHREdO?=
 =?utf-8?B?NFF3ZmZzRXk1MWtxSE9ZdndyWVFoUitRWDVNQ1dsYXdHVzEvZnd1c1o3emhl?=
 =?utf-8?B?ZUhLVlc1bU1ZbkQ4bXJlUzB1RXovOGx6QkJKdk85K0JlQ1dKREk4RFNaNTVN?=
 =?utf-8?B?QTNQUkkySTlSdDNhbUZFakExQTBJOGhsTStlWmp2WlBLcmJpc1hmbUVTWG9C?=
 =?utf-8?B?aG9LSjI1RkF0YURuZjlhaXZRY2ZFcjNHN2U2SnNQenpxUGhNK3NoVGpYRkF1?=
 =?utf-8?B?QzRldGMyUkZhY3lRVU9aNDlScExqdlhad2RLTEJFRkF0ZE1QSXZHRnNqaTQ5?=
 =?utf-8?B?azNuZ0dwVFhpUjd2dEplcnA2bkxGK2tmWVVxRUV1b2h6MVZ1RkdNSU81Mk4y?=
 =?utf-8?B?TWdmT1hHTTVkWEpXNVdIS2pVOW01WGxvQ096QlNNcFA1MDYvVnBSVTdWUFlh?=
 =?utf-8?B?MXdaMldwTFI2WFpMRVZqT2dyRExxVGtwWVJOSXh5bm1QbnVEb015WU5JR25H?=
 =?utf-8?B?NFFtT3VQMTVrcUUySkpXZTR1N2ZQZFUzUW9CVTlZajJ3a1l4cXZMMmtWd3hi?=
 =?utf-8?B?SFNudlY0UCtUSkVEaEtkS1JhbDB3NHZLY1Y4YXptUzYxUCtjaHAxYmJKWSs5?=
 =?utf-8?B?clBjOWFYN00rMlFja2plUzdJenhvRThsVWZCaTRVSE9pNXJSUXBHUWs3T2dI?=
 =?utf-8?B?d0Nnc1JJNkhJOGRadFdwYjZzektFM0Y2eXJpZ1JqRThYL0xRZGNLc252Vkwv?=
 =?utf-8?B?RHQyc3JnVjN4STNVaHJxcG1zRnBQcU8rTWpYdkdKT2xWZlliRE5DVnpUZnB5?=
 =?utf-8?B?VEFGTHVSR3VPZ045THJmWUxCWjF0WkxJTXZXYjNJWWw2WkhySjE3V1ozVnhp?=
 =?utf-8?B?U0tTUXlWaVpubkhYNFZ3THNXSk5sd3pSZjZFb0tGbGUrUEhWajI5WitXLzdW?=
 =?utf-8?B?T0UxQjlvdHpLcU5rTXY4ZTVsaWpqZ2ZqblJSc2JqNnFMRFBkWUNlUFdrZEFw?=
 =?utf-8?B?d0VTcW90ZTYrbHJrTnhpRkJGR2xYVG9xN3FNWFl5aFk2MDFYbDczMm9XVG54?=
 =?utf-8?B?ZU82SHBkQVNlTno4YXRmUUMvVHRwVEpKTVFKSGdORUhIREdJNk9LTHJmaTh0?=
 =?utf-8?B?MlRTbU5GYjk4UDlkVzR1Z1krZjU3VVliKzhlTG1jZ2RqUG5OWXJxNFhycEtG?=
 =?utf-8?B?NHZ6YURiMUh4RTRwQkxXM0w1NThFRW82enJwRVRRMnRyUG5MWnpDUmVHYXpP?=
 =?utf-8?B?YlgzS1NFM0w1MVpva3FiN1ZEblVCM1RLdnZoMm12cC9aNHpUZG9pTmlTVVE3?=
 =?utf-8?B?Q2N1MW5ab0FMSmhIZjUrNXduWU4zMVNCUHA4M0lOTitvWWc9PQ==?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?THhkQVhPTmJjT1JDR0MxRWZoYldSdSs0aHY0S1hndWpiaWgrTEE2dmNqVTlU?=
 =?utf-8?B?aWszdy9JYTlnYkpKZWF4ejFwaWR2dVIrMUFPRnE4OGlFTmxYNklFSG9kZzgz?=
 =?utf-8?B?R3JXdTF1dnFGV2psY2xlQ29TQlB0R25rR3h6Q0tTOGxnbk1aOW90SmZWbVc2?=
 =?utf-8?B?Y3V4L1FrYUU5UTdnQW9FT0xmNnkyUE1vU0hLWWJCTTFSQktndHp2ZzZybUJK?=
 =?utf-8?B?WTZUSjJ6ZFBKWStSd2ZneSttbDBGV2l4dFVUblpvbGFXYUlld0UxQWVRUWdD?=
 =?utf-8?B?NWk3UmxtRWdEa01ZaTQyYm0vSVlLaGdFWEtvbFUrcDRhbXBTSFU2eUFFTEFw?=
 =?utf-8?B?QTFEOHVJN3JRT2krRUE5eUdWQUNEMHlDWGJlUTlOWHZPTVBxVkxIUmhDbDdF?=
 =?utf-8?B?c0dPckdZL0NvcUpkMmVHU3dLU0xveEZsM0tPNzdwaHdIbm55cHFGaHFmRnA0?=
 =?utf-8?B?RVJyeVhKMis1VFhRaGhJYmJRUFdzQVlTS3Qrd052U1FCVVZlMkdlNktVVW5i?=
 =?utf-8?B?ZjJnOGR5TlE3NGI5WU5GOWRIaHRheHdIREg2WXk2Nk80QWRuakthZ3g3R0Qr?=
 =?utf-8?B?N2IrTDZLTDRkZjYxSGZIM1l0OTE4YW5CaG4wWTV4elkwbXkxS3htYTQ1Q0Ex?=
 =?utf-8?B?NGc0WEE4ZkQ1UzVuNlNpZmJCVXgyYkVaczBuZ1JHWmk0bE50bHEzdHBOcDlF?=
 =?utf-8?B?c0FUSkszOHV4ZTExc2lJS1ZMRnIxSzBFT0pKYUZUeU91enJWS05HSi9lM3Y3?=
 =?utf-8?B?VndnZ0syU1BpbFA5Zi9RM3o5SUxRN2dKM2FCSGx3SXRYNXJEdXpSQUx6ZENE?=
 =?utf-8?B?ak9iVU1ZL0MxVXZmdThRbWZtUTdBb1gxSENoNXA5c0VqSnNMSC9nSXNXbkpZ?=
 =?utf-8?B?MXZBamZhd0FuTjRLTTdLWkVJVUt3QzBhMVVjclVBa2lxQnJOL1YyYXZIOU4r?=
 =?utf-8?B?LzZGN0liR205L1pxL1JQNnFBdExzM0QzMzd0aUtSTVNVaUZiYlNXc1pxdTYw?=
 =?utf-8?B?aWozMXcwL2ZVU0VQSEp1Q29jVUNQUzRNSVlVcmZtNnYxQkxSYWM5R3FBT0tT?=
 =?utf-8?B?Wkc0S0I4VkFJcS80ajRvWUpvZnI1U1gzUnQ2d2NVay9rbE9OaGFwb1B6bkRo?=
 =?utf-8?B?TG9PQkloSlE3VkNyb1QvVTBCeG5IOWhWUS9odlJKWHBoWHR2dUVyUWRUQ2xS?=
 =?utf-8?B?Q082TkYwdk5IYi81aUYrelNOSjNoUmdQbWQ3QkJrTDFZNXF0akZ1OXlGZXdT?=
 =?utf-8?B?YTltTHd6SUdGUXVBNXF5VC9oaWFmNGJaWDM1V1F6aThBOERpb2VCenpTR2Vv?=
 =?utf-8?B?eU8yNEN6SlpOYXoycG0vVU9MNTFtMURSZjV4dUN0Z1FBODZkTFNlVTVuTFNP?=
 =?utf-8?B?QXpIUEFrYUkyKzI3SExMNUx1eW1URGJEeGN0RHJhbU45SlNtZ0gzdlRiSU9q?=
 =?utf-8?B?Vnl1YjhVYjhpT0oxVzZrb2JiZmtFUjRGSmlWZ2FnaWl6b2R3MnZyaEovM3gz?=
 =?utf-8?B?ZXc3R05RTFNhNTZZVFQvcWwwUEdyeVIybms2NDNWZjBmVEUweDg1Y1ZXK2lV?=
 =?utf-8?B?VVpyeWtUdXQxVExqY2JNYU1aSlAxK2Rva2poRlVrNDRYa3ZrbTMrUzhnQWo3?=
 =?utf-8?B?SFRrVnlPaWtGQmZROTAwb1N4Qkk2OUlwU1kvaEpvWWZJVDdqbnRSVWN3SWpu?=
 =?utf-8?B?bDJwYThqMEx6dm1oWEYxNDF1bElMbVVaRElvZjZsaTJoR1IvK0tpcDQ3d2sw?=
 =?utf-8?B?clQxekxyNEtmRzNHRVdtcUk5R01tMCtkNzhXT2dRSmlWT3EwdUJRZkkzdnRK?=
 =?utf-8?B?VE5BQnZIWHlaNyt0M3JDbThyajJGM1RnbnJzeGRtVEhhRlhyckM3SFpMQjNU?=
 =?utf-8?B?aEVsc2NtclA1Ty9zQ2JTS3JkNDlraHVRZTJ0UWRkM1ViSXMvcUJmNlRaZE5p?=
 =?utf-8?B?ZDhHVjJNWG1hSEU2VW9aS2hDeG1VbmppYlNub1NwL0NmcGw3cmhad3BKZ3lh?=
 =?utf-8?B?aDltbEZzeHNqS094blBEcS9rRjRCWW13U01IVWVlQzFCSFFacVdpbE9YZzlt?=
 =?utf-8?B?NXJINVpuVlNQc1BjUDJ4QWdNcCtVZXVrZDlEbzBHVmhCdW9wWWplVFhoVkdY?=
 =?utf-8?B?V1htZm44V21ILzJPcDBSWE8rZ21RQkpZanduN1UyL3VscHNLeHlHTVhCaUNl?=
 =?utf-8?Q?IPqN90PuyQgWLJaQWP98a48=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A76DA8E110B61C428DBA2D6068D6BD28@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	tVb7zZuE/NWCf98Ffp902bJ1p1FlTeuYmBYgQ0i0HUm9ONiSlJn0TtFkDQLnoYh6QAex+LY3uXNdkFRA/O/TgVEmnrCXyk2XlYdp7yeF9ODC/GkDob8+fH+Ud6ku7Z/rOGT9ityYK24Zbk3lL7Lv7O3nzwYSnIwunvnlDZbLKp91Dd/EYzNAZTbQpsEFvjW+4NkoOOw0W2ULbIrr4J67qHQGnZtYC1SNizbJWW04GMaBB4GU0ZbsqESaRtA3xBz1O0Dzr5MDm0woFifirkXYGD9cGhYMcvncZcp6LojLbz3DEqhs0yQhGmkyUeDErytpnGfzbsqvLMRHdRFePTbF438T3lGsiIEMxs2tYajxEZHf2JlXr9NK/aXkCgrL1Fb0rX0slA8WbXZHd3mHUPhizJNIL1RhG8oHlD5ru5U3z5ehl65NrRmNWJqkeay80hvdyiz6twRyFETRqIS+2kT7oC9D5EXxSXy5QfoSPvQNdaG5rnekdaRNdq/31sgqbIzz40p394IVDzDWuEX66sBC+EwxRuiRCF8mTm1Jlg7VJHYmhoGU2qggwX+iEWW7SINAFtcuP+M3Mxe/PkGhtJC6bkDJjV6HRmITIyTGXIl8dGo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05f3268d-c7c7-4f75-5af1-08dca75c5689
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2024 19:03:40.9854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8AwC6HM9+W+t8/UIAoCBE9UxGEsgQgTJJ8HuW/7TpTbT2NCr7rfBaH+kX15CzPWeEybblIeJNnYDLN+jHFJrcNBp/26yMGUrrpLOstqyppw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6390
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-18_12,2024-07-18_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2407180126
X-Proofpoint-ORIG-GUID: Ut0oFxdKJj8eOvriylu3_BpeOPoY1yjc
X-Proofpoint-GUID: Ut0oFxdKJj8eOvriylu3_BpeOPoY1yjc

DQoNCj4gT24gSnVsIDE2LCAyMDI0LCBhdCA5OjEx4oCvUE0sIERhdmUgQ2hpbm5lciA8ZGF2aWRA
ZnJvbW9yYml0LmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBUdWUsIEp1bCAxNiwgMjAyNCBhdCAwODoy
MzozNVBNICswMDAwLCBXZW5nYW5nIFdhbmcgd3JvdGU6DQo+Pj4gT2ssIHNvIHRoaXMgaXMgYSBs
aW5lYXIgaXRlcmF0aW9uIG9mIGFsbCBleHRlbnRzIGluIHRoZSBmaWxlIHRoYXQNCj4+PiBmaWx0
ZXJzIGV4dGVudHMgZm9yIHRoZSBzcGVjaWZpYyAic2VnbWVudCIgdGhhdCBpcyBnb2luZyB0byBi
ZQ0KPj4+IHByb2Nlc3NlZC4gSSBzdGlsbCBoYXZlIG5vIGlkZWEgd2h5IGZpeGVkIGxlbmd0aCBz
ZWdtZW50cyBhcmUNCj4+PiBpbXBvcnRhbnQsIGJ1dCAibGluZWFyIGV4dGVudCBzY2FuIGZvciBm
aWx0ZXJpbmciIHNlZW1zIHNvbWV3aGF0DQo+Pj4gZXhwZW5zaXZlLg0KPj4gDQo+PiBIbeKApiBm
aXhlZCBsZW5ndGggc2VnbWVudHMg4oCUIGFjdHVhbGx5IG5vdCBmaXhlZCBsZW5ndGggc2VnbWVu
dHMsIGJ1dCBzZWdtZW50DQo+PiBzaXplIGNhbuKAmXQgZXhjZWVkIHRoZSBsaW1pdGF0aW9uLiAg
U28gc2VnbWVudC5kc19sZW5ndGggPD0gIExJTUlULg0KPiANCj4gV2hpY2ggaXMgZWZmZWN0aXZl
bHkgZml4ZWQgbGVuZ3RoIHNlZ21lbnRzLi4uLg0KPiANCj4+IExhcmdlciBzZWdtZW50IHRha2Ug
bG9uZ2VyIHRpbWUgKHdpdGggZmlsZWQgbG9ja2VkKSB0byBkZWZyYWcuIFRoZQ0KPj4gc2VnbWVu
dCBzaXplIGxpbWl0IGlzIGEgd2F5IHRvIGJhbGFuY2UgdGhlIGRlZnJhZyBhbmQgdGhlIHBhcmFs
bGVsDQo+PiBJTyBsYXRlbmN5Lg0KPiANCj4gWWVzLCBJIGtub3cgd2h5IHlvdSd2ZSBkb25lIGl0
LiBUaGVzZSB3ZXJlIHRoZSBzYW1lIGFyZ3VtZW50cyBtYWRlIGENCj4gd2hpbGUgYmFjayBmb3Ig
YSBuZXcgd2F5IG9mIGNsb25pbmcgZmlsZXMgb24gWEZTLiBXZSBzb2x2ZWQgdGhvc2UNCj4gcHJv
YmxlbXMganVzdCB3aXRoIGEgc21hbGwgY2hhbmdlIHRvIHRoZSBsb2NraW5nLCBhbmQgZGlkbid0
IG5lZWQNCj4gbmV3IGlvY3RscyBvciBsb3RzIG9mIG5ldyBjb2RlIGp1c3QgdG8gc29sdmUgdGhl
ICJjbG9uZSBibG9ja3MNCj4gY29uY3VycmVudCBJTyIgcHJvYmxlbS4NCg0KSSBkaWRu4oCZdCBj
aGVjayB0aGUgY29kZSBoaXN0b3J5LCBidXQgSSBhbSB0aGlua2luZyB5b3Ugc29sdmVkIHRoZSBw
cm9ibGVtDQpieSBhbGxvdyByZWFkcyB0byBnbyB3aGlsZSBjbG9uaW5nIGlzIGluIHByb2dyZXNz
PyBDb3JyZWN0IG1lIGlmIEknbSB3cm9uZy4NClRoZSBwcm9ibGVtIHdlIGhpdCBpcyAoaGVhcnQg
YmVhdCkgd3JpdGUgdGltZW91dC4gIA0KDQo+IA0KPiBJJ20gbG9va2luZyBhdCB0aGlzIGZyb20g
ZXhhY3RseSB0aGUgc2FtZSBQT1YuIFRoZSBjb2RlIHByZXNlbnRlZCBpcw0KPiBkb2luZyBsb3Rz
IG9mIGNvbXBsZXgsIHVudXNhYmxlIHN0dWZmIHRvIHdvcmsgYXJvdW5kIHRoZSBmYWN0IHRoYXQN
Cj4gVU5TSEFSRSBibG9ja3MgY29uY3VycmVudCBJTy4gSSBkb24ndCBzZWUgYW55IGRpZmZlcmVu
Y2UgYmV0d2Vlbg0KPiBDTE9ORSBhbmQgVU5TSEFSRSBmcm9tIHRoZSBJTyBwZXJzcGVjdGl2ZSAt
IGlmIGFueXRoaW5nIFVOU0hBUkUgY2FuDQo+IGhhdmUgbG9vc2VyIHJ1bGVzIHRoYW4gQ0xPTkUs
IGJlY2F1c2UgYSBjb25jdXJyZW50IHdyaXRlIHdpbGwgZWl0aGVyDQo+IGRvIHRoZSBDT1cgb2Yg
YSBzaGFyZWQgYmxvY2sgaXRzZWxmLCBvciBoaXQgdGhlIGV4Y2x1c2l2ZSBibG9jayB0aGF0DQo+
IGhhcyBhbHJlYWR5IGJlZW4gdW5zaGFyZWQuDQo+IA0KPiBTbyBpZiB3ZSBmaXggdGhlc2UgbG9j
a2luZyBpc3N1ZXMgaW4gdGhlIGtlcm5lbCwgdGhlbiB0aGUgd2hvbGUgbmVlZA0KPiBmb3Igd29y
a2luZyBhcm91bmQgdGhlIElPIGNvbmN1cnJlbmN5IHByb2JsZW1zIHdpdGggVU5TSEFSRSBnb2Vz
DQo+IGF3YXkgYW5kIHRoZSB1c2Vyc3BhY2UgY29kZSBiZWNvbWVzIG11Y2gsIG11Y2ggc2ltcGxl
ci4NCj4gDQo+Pj4gSW5kZWVkLCBpZiB5b3UgdXNlZCBGSUVNQVAsIHlvdSBjYW4gcGFzcyBhIG1p
bmltdW0NCj4+PiBzZWdtZW50IGxlbmd0aCB0byBmaWx0ZXIgb3V0IGFsbCB0aGUgc21hbGwgZXh0
ZW50cy4gSXRlcmF0aW5nIHRoYXQNCj4+PiBleHRlbnQgbGlzdCBtZWFucyBhbGwgdGhlIHJhbmdl
cyB5b3UgbmVlZCB0byBkZWZyYWcgYXJlIGluIHRoZSBob2xlcw0KPj4+IG9mIHRoZSByZXR1cm5l
ZCBtYXBwaW5nIGluZm9ybWF0aW9uLiBUaGlzIHdvdWxkIGJlIG11Y2ggZmFzdGVyDQo+Pj4gdGhh
biBhbiBlbnRpcmUgbGluZWFyIG1hcHBpbmcgdG8gZmluZCBhbGwgdGhlIHJlZ2lvbnMgd2l0aCBz
bWFsbA0KPj4+IGV4dGVudHMgdGhhdCBuZWVkIGRlZnJhZy4gVGhlIHNlY29uZCBzdGVwIGNvdWxk
IHRoZW4gYmUgZG9pbmcgYQ0KPj4+IGZpbmUgZ3JhaW5lZCBtYXBwaW5nIG9mIGVhY2ggcmVnaW9u
IHRoYXQgd2Ugbm93IGtub3cgZWl0aGVyIGNvbnRhaW5zDQo+Pj4gZnJhZ21lbnRlZCBkYXRhIG9y
IGhvbGVzLi4uLg0KPj4gDQo+PiBIbeKApiBqdXN0IGEgcXVlc3Rpb24gaGVyZToNCj4+IEFzIHlv
dXIgd2F5LCBzYXkgeW91IHNldCB0aGUgZmlsdGVyIGxlbmd0aCB0byAyMDQ4LCBhbGwgZXh0ZW50
cyB3aXRoIDIwNDggb3IgbGVzcyBibG9ja3MgYXJlIHRvIGRlZnJhZ21lbnRlZC4NCj4+IFdoYXQg
aWYgdGhlIGV4dGVudCBsYXlvdXQgaXMgbGlrZSB0aGlzOg0KPj4gDQo+PiAxLiAgICAxDQo+PiAy
LiAgICAyMDQ5DQo+PiAzLiAgICAyDQo+PiA0LiAgICAyMDUwDQo+PiA1LiAgICAxDQo+PiA2LiAg
ICAyMDUxDQo+PiANCj4+IEluIGFib3ZlIGNhc2UsIGRvIHlvdSBkbyBkZWZyYWcgb3Igbm90Pw0K
PiANCj4gVGhlIGZpbHRlcmluZyBwcmVzZW50aW5nIGluIHRoZSBwYXRjaCBhYm92ZSB3aWxsIG5v
dCBkZWZyYWcgYW55IG9mDQo+IHRoaXMgd2l0aCBhIDIwNDggYmxvY2sgc2VnbWVudCBzaWRlLCBi
ZWNhdXNlIHRoZSBzZWNvbmQgZXh0ZW50IGluDQo+IGVhY2ggc2VnbWVudCBleHRlbmQgYmV5b25k
IHRoZSBjb25maWd1cmVkIG1heCBzZWdtZW50IGxlbmd0aC4gSU9XcywNCj4gaXQgZW5kcyB1cCB3
aXRoIGEgc2luZ2xlIGV4dGVudCBwZXIgIjIwNDggYmxvY2sgc2VnbWVudCIsIGFuZCB0aGF0DQo+
IHdvbid0IGdldCBkZWZyYWdnZWQgd2l0aCB0aGUgY3VycmVudCBhbGdvcml0aG0uDQo+IA0KPiBB
cyBpdCBpcywgdGhpcyByZWFsbHkgaXNuJ3QgYSBjb21tb24gZnJhZ21lbnRhdGlvbiBwYXR0ZXJu
IGZvciBhDQo+IGZpbGUgdGhhdCBkb2VzIG5vdCBjb250YWluIHNoYXJlZCBleHRlbnRzLCBzbyBJ
IHdvdWxkbid0IGV4cGVjdCB0bw0KPiBldmVyIG5lZWQgdG8gZGVjaWRlIGlmIHRoaXMgbmVlZHMg
dG8gYmUgZGVmcmFnZ2VkIG9yIG5vdC4NCj4gDQo+IEhvd2V2ZXIsIGl0IGlzIGV4YWN0bHkgdGhl
IGxheW91dCBJIHdvdWxkIGV4cGVjdCB0byBzZWUgZm9yIGNsb25lZA0KPiBhbmQgbW9kaWZpZWQg
ZmlsZXN5c3RlbSBpbWFnZSBmaWxlcy4gIFRoYXQgaXMsIHRoZSBjb21tb24gbGF5b3V0IGZvcg0K
PiBzdWNoIGEgImNsb25lZCBmcm9tIGdvbGRlbiBpbWFnZSIgVm0gaW1hZ2VzIGlzIHRoaXM6DQo+
IA0KPiAxLiAgICAxIHdyaXR0ZW4NCj4gMi4gICAgMjA0OSBzaGFyZWQNCj4gMy4gICAgMiB3cml0
dGVuDQo+IDQuICAgIDIwNTAgc2hhcmVkDQo+IDUuICAgIDEgd3JpdHRlbg0KPiA2LiAgICAyMDUx
IHNoYXJlZA0KPiANCj4gaS5lLiB0aGVyZSBhcmUgbGFyZ2UgY2h1bmtzIG9mIGNvbnRpZ3VvdXMg
c2hhcmVkIGV4dGVudHMgYmV0d2VlbiB0aGUNCj4gc21hbGwgaW5kaXZpZHVhbCBDT1cgYmxvY2sg
bW9kaWZpY2F0aW9ucyB0aGF0IGhhdmUgYmVlbiBtYWRlIHRvDQo+IGN1c3RvbWlzZSB0aGUgaW1h
Z2UgZm9yIHRoZSBkZXBsb3llZCBWTS4NCj4gDQo+IEVpdGhlciB3YXksIGlmIHRoZSBzZWdtZW50
L2ZpbHRlciBsZW5ndGggaXMgMjA0OCBibG9ja3MsIHRoZW4gdGhpcw0KPiBpc24ndCBhIHBhdHRl
cm4gdGhhdCBzaG91bGQgYmUgZGVmcmFnbWVudGVkLiBJZiB0aGUgc2VnbWVudC9maWx0ZXINCj4g
bGVuZ3RoIGlzIDQwOTYgb3IgbGFyZ2VyLCB0aGVuIHllcywgdGhpcyBwYXR0ZXJuIHNob3VsZCBk
ZWZpbml0ZWx5DQo+IGJlIGRlZnJhZ21lbnRlZC4NCg0KWWVzLCB0cnVlLiBXZSBzaG91bGQgZm9j
dXMgb24gcmVhbCBjYXNlIGxheW91dC4NCg0KPiANCj4+IEFzIEkgdW5kZXJzdGFuZCB0aGUgc2l0
dWF0aW9uLCBwZXJmb3JtYW5jZSBvZiBkZWZyYWcgaXTigJlzIHNlbGYgaXMNCj4+IG5vdCBhIGNy
aXRpY2FsIGNvbmNlcm4gaGVyZS4NCj4gDQo+IFN1cmUsIGJ1dCBpbXBsZW1lbnRpbmcgYSBsb3cg
cGVyZm9ybWluZywgaGlnaCBDUFUgY29uc3VtcHRpb24sDQo+IGVudGlyZWx5IHNpbmdsZSB0aHJl
YWRlZCBkZWZyYWdtZW50YXRpb24gbW9kZWwgdGhhdCByZXF1aXJlcw0KPiBzcGVjaWZpYyB0dW5p
bmcgaW4gZXZlcnkgZGlmZmVyZW50IGVudmlyb25tZW50IGl0IGlzIHJ1biBpbiBkb2Vzbid0DQo+
IHNlZW0gbGlrZSB0aGUgYmVzdCBpZGVhIHRvIG1lLg0KPiANCj4gSSdtIHRyeWluZyB0byB3b3Jr
IG91dCBpZiB0aGVyZSBpcyBhIGZhc3Rlciwgc2ltcGxlciB3YXkgb2YNCj4gYWNoaWV2aW5nIHRo
ZSBzYW1lIGdvYWwuLi4uDQo+IA0KDQpHcmVhdCENCg0KV2VuZ2FuZw0KDQo=
