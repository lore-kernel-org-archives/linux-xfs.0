Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8BA54656;
	Thu,  8 Feb 2024 23:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707434461; cv=fail; b=tsZRQqZP1hhAVqEqPl7uC3mhbq1QFtkKjID+DF8UKokEiuio1pAQqRWoG5XhtaIH3IUVUgQsfnN1u0kJk2ADjMJBY4T0bqu0IT0MAx+iv29igH/JodQ723yAaksgysssM4l4ELzPYIvlP1uVsu57zViGo361jcHuNCHOuP9zzmk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707434461; c=relaxed/simple;
	bh=nX/18T7OCbICXhGLgNACvCWH5XrXlpFb5Boxd5+9x3s=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=fBmhaegd3TowUFxnUUqs+oyQN04r+kUBJZlebwlfhpWed6u3SirOmOcllC5eiiftwkyBcMNbuYXc7mkBFxc8bp4W2oRSfipFrTZybmQbuUvOI1rFMtB3Tvn9KQJw+X8TF40KWljjTa1B+G4zT2lzLmsFO7nmUhkDVkFc8aVr5YM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UlvflOlF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eqZh7Z6B; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UlvflOlF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eqZh7Z6B"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 418LTWM2000531;
	Thu, 8 Feb 2024 23:20:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2023-11-20;
 bh=Gya5PlNh5mB5X1DIgkAuf40M9s9kPhPtXYTaihsNcAI=;
 b=UlvflOlFwU/LxwW7JzBqC2YUvvXlFrqVs07fP7/vR8yDMD4Xt+OeOkOVl2Bh397F9GV0
 2ztFTWZVqR0LI3NlEiSPyNWJAbOjk8Z1xVqGuhFjiaRD9dW///bGaeeFagX+LdWTkIh7
 GtD38NIMftcYUrdI9ls4DJeewskh9OIT1wNtmsFROq+lSnz9PBOsKXWXFCEBs8Z0Qq33
 jiOz41aIrXsu7bFaqs5bkF3uXDGXHxq4TMD6YYHjnSFvFCTHUAgftZuV/n7GxyS1d2Cn
 qbQCF2HKs8rSmb8qW3fmXvlStLREPZraWfTfvxosEoxquKO7yzRkcTfs7GQBpGU2xrnp Ew== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1cdd666k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:20:58 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 418MBiIu020070;
	Thu, 8 Feb 2024 23:20:57 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bxhq4qy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Feb 2024 23:20:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MYJaqbvI+dsM5UJ+N4tUaYjSlaFtwSw3fhxRjVh5BJgJsLaEkvs6NB8gY02Sis2PJ6jUg9RAK7TL3MlAsD/hYQiZWRs+pIcjQXU9tw66I8a1OOF/Xa96ilxZIQJ4hKEFCQZM6+GSRjUL7LzQyW2/lRLX7oUt0ymn9NUd+QRzUHNC72pgZfTWQdZs+//fzipn6ZU4aInqY9l38MBPuydryqk4IlpBeMJvmfm1QtgihUh3yqLLaa6tTe273w18S0dyClwYX1Pu0oqO9PSjvBYWM6R2UAsN14M8N82DW2EYaujliN6p6W43CSP/9S6IUZiNKdth9N/pgHafv3CYVL9sdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gya5PlNh5mB5X1DIgkAuf40M9s9kPhPtXYTaihsNcAI=;
 b=I1yZVPEFITVWMXPKlBXF13eQ36xNkgw/FoTA4ca6bWXUNi8OyJmq1uhK+bjNSK3vCt6SR6MXlJQlQIkWpbL1B6bMuAs83Pc6aTni5g08Z4ffvKcnn9Aho4PiSEMyNEm5YkDUrqroMyFkMs42Dd4+2nmavQ3xsCEVwVqqcYmkd5jfb21GV0HnettV0zSNLR1CpOCltFhIuHvKTZF5zerHJZ1AWQDmzuP9SbwimT0kEl1IbIfAY9Ja/fBU+zBoVYeLEfk+LoyzliwA32J+KeTaS8vkoGFy4tzozFct5ARsrKR2iLFAt6uKG5bV10L/hrVnZP8gFXEoGOh8DWVV9s2tqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gya5PlNh5mB5X1DIgkAuf40M9s9kPhPtXYTaihsNcAI=;
 b=eqZh7Z6BO4g1cjINRGyF6ZMYYPcDpwVph480do1xewC/JNNmqHG9txiV8YZPreJSQmDeo2c6OsOSgJwJHzN9FRtDsjVrRLEqvXDKvB3E0sEotyUvYrTvgQ6Nkhn0ETqrUO4FcvvuU+GGjyVQU/TDQAiCzo++kB9eio8jVSW6j30=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by IA0PR10MB7255.namprd10.prod.outlook.com (2603:10b6:208:40c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Thu, 8 Feb
 2024 23:20:56 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::abec:4916:93a1:2f72%6]) with mapi id 15.20.7270.024; Thu, 8 Feb 2024
 23:20:55 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 00/21] xfs backports for 6.6.y (from v6.7)
Date: Thu,  8 Feb 2024 15:20:33 -0800
Message-Id: <20240208232054.15778-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0161.namprd05.prod.outlook.com
 (2603:10b6:a03:339::16) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|IA0PR10MB7255:EE_
X-MS-Office365-Filtering-Correlation-Id: 329ffbb9-cf90-457b-f86d-08dc28fc99d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	o7+qgqj2KJFrTQt38iaq29F8TKFXROzBMm6BdDX2OVl9/nad3VXLAcWmltRZRi/Nxr3n0JgVIilWdCd/aa1qZvnP4+1rgdFey/a7NzKELb83bTMfcXlcKArcIICqq9w7yC79LGRheimU75J8Tymj33CO6GtadECtuzWrluWmkGQAVubYftaGywY89NZRKg0qH6Jh6G4/7Qsq07tnO0jygbrLdnQo7V9ot2DsfV8/CLUbd1NmXiOdNrC5AonW8TxQ1haQ9hd4bljqtwVB1pcz9iRfnA9jxfoWWFCKQStEGKkErwyPkUN0Mf+1+xeBWC+moVm/tVL4cfMsOgLrOnNm6vLrbArC/A2YT0efaJHuoo4jyEM0I5Rt3/hHQNWz9V8pVD/pVo2c2vderzmrmgPBjl4Rprj/1mWBwnwiHyE9V2Qog7Z7nyxh4eRhKe0wGaD7AUaHRGdVjJlNNDQmLXyY/NINVqRX0uGUwI48jYIhz79GQyiy92FwmRPoA/P1qoVIubBqqZHn0ZIRCl/1F7PKmitQ5fTmp3ri27n982p2NDs7mY+wmZwMsmMaIoLMGvRo
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(366004)(396003)(376002)(346002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(41300700001)(6506007)(4326008)(450100002)(86362001)(44832011)(8936002)(6486002)(36756003)(5660300002)(478600001)(2616005)(6512007)(1076003)(6916009)(66946007)(316002)(66556008)(66476007)(6666004)(8676002)(83380400001)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?SksxTmtVK0pIMi9kc0tHSGxLQnNhSFBIZzU5U3Eyano3a1E1enFGN2tPMWlU?=
 =?utf-8?B?ZjExQ1JscUdVYzRBRUFkdHlYajlISDFISTFNS01FZElTRGVXRldzc0I2c3gv?=
 =?utf-8?B?MFM4ZVA0U1FMTU54TFJGQTZtRmpkNEVLc0FKdjFrc2syTVYxeGFPanZlUzZF?=
 =?utf-8?B?K3BSV1Jsa3M1OWsza0dzd1dxWHpPVk9oRXQ1ZFMzUWZEQ2ltbFE1cC9nV2px?=
 =?utf-8?B?dmFWeUl6akcxQW5YV1Awc2Z3dFZ6M2JYbmVhL0VaTnF6aUpQanF0SVVCRjQ2?=
 =?utf-8?B?a2F2dHN3NnQydTNCcDBVdkhRQWhJV3hleXlGU1hEM0VaUEJPQllldHZxNDJY?=
 =?utf-8?B?NmlCcGVWT1dOOU5xN2lGb2FpZUxHM2o4bDNwMGtOSG5xNU12eXBzZmlhai9D?=
 =?utf-8?B?ZjNpdXNZT2J3NVNkUHFqbjhoRStVdWFRMU41ODVRRkpHYXBkWGJ0QWFDblRL?=
 =?utf-8?B?MGJUSWpvNWRSSkd5Y1JwMHJwc3BMUzhqRDV1ck1mNFhSUWpTSnQxWkphSTdZ?=
 =?utf-8?B?dVI5NkFBTUEwZ2c3SzQwd2JWOUd3NXIxUzJXVnMvVzVJUWl4M1RDajBhZ0Fk?=
 =?utf-8?B?aUErRGVDbk1zS1FncHFSbkJyQnNxakFNMUxGcnJvUjVyalg1NVlhZENGRytN?=
 =?utf-8?B?MGdUTCtPVjEzKzFSalhtNXN0eHVzQkZwYkFaUnVaMTFES3lWODgxRmkwM2FZ?=
 =?utf-8?B?aFI2bSt6blJ2STBmZTI2WTlHcmdVTlJpWVlFTWd2ak55SGlyamZNR1lubGxZ?=
 =?utf-8?B?eU02YjFpa2hPbXIyT2FMSXY3dklxUE9jM1JWT0xZL1JWZE9OdFZPaWhrb09U?=
 =?utf-8?B?MDVvSFpIUWZRamRmRGUrUFdOeXRiSG8zNWJNcEkrYjVpS1ROcnBPdy9UTTZo?=
 =?utf-8?B?NzNlVytQNmNSYTIrZDhCT3BnZ1lYVy9hckE0bzdINTVPVk1Sb3NZQ2x3OExo?=
 =?utf-8?B?ZGpJaDBoWUFjSm15em9VNHFoSjhib3FvN2YvbmMrdXhibnRNcDNyb3dqK1Fo?=
 =?utf-8?B?d0hCU1RHTDY4TVhKNXNuTStNcWErMEV3QklzMGVFYWxUaXNRUElmZ2dEUWdi?=
 =?utf-8?B?Q1dEY1hOUm4zNHlPZjlOQldZcjAwZkIwaEFCOUVROEY4bGN2bE5UTkowQURj?=
 =?utf-8?B?TkpZbmNCd3Jsd2IxbWl1enJVajJIdm9id1JvSWRmRTVpU05SU25CS0NIUHl0?=
 =?utf-8?B?YjN1Q1cxMEdWUkdqVkZVcXJvT1ZZWXgxRUROT1RBNUpIUTRBekV1bUpQWHlN?=
 =?utf-8?B?eWtvTFljUmRjckJDaXR5aXY5dzVkcndYWjY5MkJwcEx0eHk5Ukp4SXhqV3Ny?=
 =?utf-8?B?c0FkUU9yR3ozTktScXNjM2dkZkxiSFFSNXZ5Tm5ZdGVzak55Q1dNR1h3QTNh?=
 =?utf-8?B?M2dtamMxcHdkOFdoUTd5ZnVyUlI1UlNkbDJIbmpUaHRZdWhERncvZGJCZE5Y?=
 =?utf-8?B?WFBwVGRJbGZKWGpSSkp5R0trK2RSbFFTNC9zY2FyOTVkYW5vZ1lmY1VVT2o5?=
 =?utf-8?B?Vzh5dTlUOUdYWkhKUjBlNll0Ry91R2JEOEE2OXZtbXppVVY1cFpZQW81Q3Rm?=
 =?utf-8?B?a0luUmx1b3lHNG91NzY5ZENwTEduMWl3MTZmT3U3bzlDUFlCUjZ2N0hpd0tN?=
 =?utf-8?B?NG1rbUNzeUFJaWdUOG95bUVLTU9UbnpUV2U3UnVzWEZ2OC9lQ3R0VWE2Y3hn?=
 =?utf-8?B?L3BNZmZYWGlyY1h4Ym1BWTJUbWRQUmlra0NNeVdEWDdrNzdXTlJpQitJK3BM?=
 =?utf-8?B?TDVyQnZvdForU0JzWXlyWGI1VU80dW1EaGJabmJNVzY2bWNXQ1p5UVIvMm5n?=
 =?utf-8?B?TzRmWHNXQ081NXROSG9BanRRbE83cjlQME1EcDNqNkxYZ3cxbFFWakFJWE9k?=
 =?utf-8?B?WXppMzNvR2xwNzlPQ055QjJvRmNzMEErdDlkb0k1b08zVmhKRnRYOXVBMkpM?=
 =?utf-8?B?aGU1VWlmb0hLUTJtbE5yTlZ3d1VuZnpqeERmS2FRUzMweXdIb1JjYXdpV0xH?=
 =?utf-8?B?NW9yaDNrVkNObnYyYXB0OXZtWGdFTjBHbkhDNzBWaER5MjM3eG1BUitYemtS?=
 =?utf-8?B?LzhvWE9veSt2aVFhYWo1SC9OZDZPbGtncWZ1b0hITGgzNDlLa1BGTEQvQmpK?=
 =?utf-8?B?ZnU1azhrSk9Felk5NnhSSGpXNThpYmVhZHhLcjZMYWFZblMrQkpKNVlmZVF2?=
 =?utf-8?B?dG5HZTN0c04xVTdDSVpFS2IvaWxBMGNvTXBKdHExcmtzMWoyeGtvWFk0WjVS?=
 =?utf-8?B?ZzlRTEE1dVIvSkJBZ1NnVFhVdWZ3PT0=?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	8Jc1gkT73iQDAhq1n2twM0mbRcZ4FOdeuZBDXLR/b2D2TQghrM7VNN+VsliWPvJIOx+eCwiXYALkZwyZgcbBHOaok3Mj3Wmn9i6K3UUt8wzicFw8A3AHBcSDsaDxEBOXBfyis+scwXWrOQuUkrc2EJFV1sQ/8xruQfqCwQyn4PguNRiQC6xH1iYa2STZTqUNANhcdOrZl898LEnvI8MeoYeh9/Hpy1SlJjuFAZjvWQd9Qw7hJA/byX3wAjW+VsJ3zI1WXl5wz9uy8scZs3gL32uyPsFY1DwBs3z7wypC8MtY5qRvK3wZzQhMSsAy84lBWuCkLIW2IFmX19wbeAzFDKkHiS9bzAf/JEvFNBrFaLLoQSYHw7by9RZ4bcSGkcAbFIFzpHlP479gXkgw2zmgxvXEKtn97bafXa3XyAbaolPapiCEqhHMd7S7acjlXd/JrZuL1z/h3wI455cRxNZYEc39ovbOh990Aqgogstz56/tTLEEN70YzKv1rNFAGMx9ZUBCrJBQ+Oez08UAsZ+FYMj/fvJjRAnQgPFXm7/1jg1/irGKgfJ5j84uRreSkRenSuaEzBRadxEFt4I8KfCG1vifjqzvJQtepXNbvb3NI+4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 329ffbb9-cf90-457b-f86d-08dc28fc99d5
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2024 23:20:55.9011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7VXMweUmyAluQ7ZG5aQo5L3zptS3XI40hwx2BbTZoIxjB/e8qDqZxhKFyr2nHPbrVcJ9KyrEwMPd7CUroTQWsHjW667e2PHPdNUQzCjCcgc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7255
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-08_11,2024-02-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 adultscore=0 spamscore=0 malwarescore=0 mlxlogscore=940 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402080132
X-Proofpoint-GUID: FGtP1MVlWTBUhW9HXnIPjFuOalwTQbEN
X-Proofpoint-ORIG-GUID: FGtP1MVlWTBUhW9HXnIPjFuOalwTQbEN

Hello,

This series contains backports for 6.6 from the 6.7 release. This patchset
has gone through xfs testing and review.

Anthony Iliopoulos (1):
  xfs: fix again select in kconfig XFS_ONLINE_SCRUB_STATS

Catherine Hoang (2):
  MAINTAINERS: add Catherine as xfs maintainer for 6.6.y
  xfs: allow read IO and FICLONE to run concurrently

Cheng Lin (1):
  xfs: introduce protection for drop nlink

Christoph Hellwig (4):
  xfs: handle nimaps=0 from xfs_bmapi_write in xfs_alloc_file_space
  xfs: only remap the written blocks in xfs_reflink_end_cow_extent
  xfs: clean up FS_XFLAG_REALTIME handling in xfs_ioctl_setattr_xflags
  xfs: respect the stable writes flag on the RT device

Darrick J. Wong (8):
  xfs: bump max fsgeom struct version
  xfs: hoist freeing of rt data fork extent mappings
  xfs: prevent rt growfs when quota is enabled
  xfs: rt stubs should return negative errnos when rt disabled
  xfs: fix units conversion error in xfs_bmap_del_extent_delay
  xfs: make sure maxlen is still congruent with prod when rounding down
  xfs: clean up dqblk extraction
  xfs: dquot recovery does not validate the recovered dquot

Dave Chinner (1):
  xfs: inode recovery does not validate the recovered inode

Leah Rumancik (1):
  xfs: up(ic_sema) if flushing data device fails

Long Li (2):
  xfs: factor out xfs_defer_pending_abort
  xfs: abort intent items when recovery intents fail

Omar Sandoval (1):
  xfs: fix internal error from AGFL exhaustion

 MAINTAINERS                     |  1 +
 fs/xfs/Kconfig                  |  2 +-
 fs/xfs/libxfs/xfs_alloc.c       | 27 ++++++++++++--
 fs/xfs/libxfs/xfs_bmap.c        | 21 +++--------
 fs/xfs/libxfs/xfs_defer.c       | 28 +++++++++------
 fs/xfs/libxfs/xfs_defer.h       |  2 +-
 fs/xfs/libxfs/xfs_inode_buf.c   |  3 ++
 fs/xfs/libxfs/xfs_rtbitmap.c    | 33 +++++++++++++++++
 fs/xfs/libxfs/xfs_sb.h          |  2 +-
 fs/xfs/xfs_bmap_util.c          | 24 +++++++------
 fs/xfs/xfs_dquot.c              |  5 +--
 fs/xfs/xfs_dquot_item_recover.c | 21 +++++++++--
 fs/xfs/xfs_file.c               | 63 ++++++++++++++++++++++++++-------
 fs/xfs/xfs_inode.c              | 24 +++++++++++++
 fs/xfs/xfs_inode.h              | 17 +++++++++
 fs/xfs/xfs_inode_item_recover.c | 14 +++++++-
 fs/xfs/xfs_ioctl.c              | 30 ++++++++++------
 fs/xfs/xfs_iops.c               |  7 ++++
 fs/xfs/xfs_log.c                | 23 ++++++------
 fs/xfs/xfs_log_recover.c        |  2 +-
 fs/xfs/xfs_reflink.c            |  5 +++
 fs/xfs/xfs_rtalloc.c            | 33 +++++++++++++----
 fs/xfs/xfs_rtalloc.h            | 27 ++++++++------
 23 files changed, 312 insertions(+), 102 deletions(-)

-- 
2.39.3

