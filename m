Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587A123768
	for <linux-xfs@vger.kernel.org>; Mon, 13 May 2024 17:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715620981; cv=fail; b=BITlgBy2S6WyKSMWCRxf4ChD+A9HY6dJ4M7SQmXTa1Zv8XzJn7tI3VYe/cEJPJGSryXY3x7VpMsIHFNq1XWFUbHLZNbOSSBN/ilHEZOYkIZg2xshpjYbMoC1Bd6NPMHXRJj9Y0yWZwCbf3QrixgF0smV3KTRDU7eEDPxUB5ur78=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715620981; c=relaxed/simple;
	bh=sfxPhJuGS72M2GQf/CdMEcaBevORMb1YtD5WuA/wieA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ueSfgKm9I1FlLKfXzRLOiiggCTZsSFG0m7XUBNNsaigjhUBEerb53pJU8ko/r0BsZiaoUeLIGEX7rvw1ArLGtntTsihXc4c/h+eUMYDjISXT5Gtzws9XGmmRnW1Byl50BHIDzEGDS1tjKsyL9vFDKY5xoQONCG9Ovr5JbDlC4bs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SOksBGh1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=M2VOb8QH; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SOksBGh1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="M2VOb8QH"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44DHGrTx015942;
	Mon, 13 May 2024 17:22:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=sfxPhJuGS72M2GQf/CdMEcaBevORMb1YtD5WuA/wieA=;
 b=SOksBGh1Gjb8TCenVnLtfEzIwSVjoyTCyPIPuipGiCieZQGLZjiP13EFR5P2/eDyAStg
 R/LDC6SpbY6Nfb7kDMXrdNtUpblwrLoaTDXVV4tnlJOL3dSZuoXYIxZ0NudCJVTzyA17
 vK56A2B23wl5RAwagob3rfA5DojsTHBg5BByTiUAbjiLlFe17+liBQsIPKI5KhNjALxW
 F7iIT1qDaFuXBc3DNUQ6I/oNF7vUCuKblDJsgNzh4SvR6hEJMK0+YagW4BwccKUAb190
 yjzswKMrTcmAEPNUQgRburQz8Ps0xWQVorC89tK9Zs8lailY//DY0VZpo/CEZ7eHoP2w aA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y3q4880sq-9
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 May 2024 17:22:57 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44DGTwdf017330;
	Mon, 13 May 2024 17:06:49 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y1y462ww5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 May 2024 17:06:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cOWXo14tMxHLoU4IUKenQVlkaSFA5yM6lIpEyaJuyHoyc3by63JxSMneglgjXEdGBUQGQmv/rac+80nAoJc1K06a64vm/Y6PG1h3AAhvsmISmpR0xLovSg13t8KS8QGncmGr20phjODwHM/md3t3eNJsIqIb+OF5dFwLqzXG1KJn9aNdBCW3fwx0UmE9/+EYzUIAqGxfbS4NVlkBLbR1aNf8GDDoK4uQ//6Ou1VOv4JBOtUmr7k0Ciu6ts0X65kAweJ0W3p42uSREUEpcloSTSSfKRJVi78IFPZbvGbgxU8SdaBbLLDyA0xizDVh0BbWUW84/0VNkdzvwKWS9OTtwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sfxPhJuGS72M2GQf/CdMEcaBevORMb1YtD5WuA/wieA=;
 b=DqMHRQs+KItCdvtapQP3eGq4ZzbZCINhJ0/FZp/jrcDfdh7uGCEsAKvkx8rsYSJPZkLH8VgOVWr3hQtkLIdZPFZSqZ00v0lbvbZerHE9neb3nZZp4gZJyIRWJt1VJv+pVCt6gnpSh5aUUlEKZKhmfJusOJ68dslUVascbRCZ75UYdesgtFlkxNNFnWsEal5U98qpwBdHozzOVy0ysNReYL2ajaME3dBwfsrw2WcTokz23FErxO2ost9YdUaCeHAl8/q/v86voxeFRe36JStXpkf0idZDyQrhGoO9ht3ZXyp7EzKdlWKR9xvUDhfznBZMVksRxvogto2lFW5HNqdFFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sfxPhJuGS72M2GQf/CdMEcaBevORMb1YtD5WuA/wieA=;
 b=M2VOb8QHrqKp99Ilf5HfsoJK5iG2RrvDjuE3R5+KyY1UJ14axLBMgb87LxsarXhQZVmrlpy8myHNnjcdUe3hkSELaRCZiy8gHqtnW4CiTBqioFPnTN+PVCYUACYx63qOce34Anq1cEc/ADabT0N5XqwfqNT8M/PNocDva1JRDLM=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by IA0PR10MB6769.namprd10.prod.outlook.com (2603:10b6:208:43e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Mon, 13 May
 2024 17:06:46 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%4]) with mapi id 15.20.7544.052; Mon, 13 May 2024
 17:06:46 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: Dave Chinner <david@fromorbit.com>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: make sure sb_fdblocks is non-negative
Thread-Topic: [PATCH] xfs: make sure sb_fdblocks is non-negative
Thread-Index: AQHaozr8E9KmCgD/tEKemp9zonfvu7GRO4qAgAQt0YA=
Date: Mon, 13 May 2024 17:06:46 +0000
Message-ID: <AEBF87C7-89D5-47B7-A01E-B5C165D56D8C@oracle.com>
References: <20240511003426.13858-1-wen.gang.wang@oracle.com>
 <Zj7HLZ5Mp5SjhvrH@dread.disaster.area>
In-Reply-To: <Zj7HLZ5Mp5SjhvrH@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.500.171.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|IA0PR10MB6769:EE_
x-ms-office365-filtering-correlation-id: 11151d42-4a6e-4d18-d95f-08dc736f1210
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: 
 =?utf-8?B?LzhqZXdodFEvMmVZVHNpYUpBNG40akdvL0t5Zk56YTNwM2t6RFdtK1VoTElZ?=
 =?utf-8?B?NmFRaGFFcnc0Yk1qQnhNb2ZyU1E3YlFHRnoybE9FSk9uaFJUT3N1UlRWUW12?=
 =?utf-8?B?QSt2SkVlOEMxWWZ1OVNqblFmWWU0aWZKY3hPanZRN3Z3ajNBanEzcUkwdmd1?=
 =?utf-8?B?c01zNTR1eW9XbGVWTGtEdWxhSEo2czZ4NVczL3hZcGM3RGlJZnd1R0VrWDZ5?=
 =?utf-8?B?UFZsMmtSMm9TRDVEUDhLMXJFUkpkREJPZ1ppbG10OE9hV0ZrTFhkQnhIVFJM?=
 =?utf-8?B?WlBPdmV6eFE2VUpXcFFJdUlNbW5zcjJ6NnJDdUU0Qzg4SG5XaW54Sms0V1JN?=
 =?utf-8?B?Q0YzcDBCTU9VbXlaWWFQRmxsd0dUdVg2azFFNm1vTFhNRlYwSzh6QWJXOW8w?=
 =?utf-8?B?aDNiRTNPUkRSUzdiTGlNcER1T1UvRFhNdGZjak1Semg5Z3JwSnl0Z0lMcTB5?=
 =?utf-8?B?ZUVhRnUxTWl2Z2FEZ1poN2ZOOFNpaTVwYnl1S3pycE45N05aaHBCcmRzcUx4?=
 =?utf-8?B?Nm92YW9GYXlvS2FvTThxUmNXUEx3dFRzYmtPTFpLY3V1UStyQ0MxY2preitK?=
 =?utf-8?B?ZWhsVS8waTl5TXYvS09wY3lSYXZ3ZHo5UEV0Ti9IWU5wSmdac3FrYUtGTkF6?=
 =?utf-8?B?Q3ZrakhNY1lpT3JnSVFGV25xZ1RDMGp4ZDRBM29lQlpmY2Q3Y0JNYjlESUhZ?=
 =?utf-8?B?cnZLN3FvaTFDRWRoeXJMRnpWbW1RUmpyL0JJV2lCT3BYSGdxbmVIM0RWL1Q1?=
 =?utf-8?B?SGgreUlmdk83VHB1NDRWQ0RvWmdsc1Zqak5WV2h4UUtuMXIvUWtzVmpCSHJx?=
 =?utf-8?B?NjUrZWF5THBJbG5mek9MT2lPREQybFk5ZFN0VUE2c3Izb1RiRFZaL1VyUkxM?=
 =?utf-8?B?MGJXTHJrVXE3QUJ4U3FUR0ZBVnZiaFQ4aG02L1lnajg2TjFoMjYzcXRFdWF3?=
 =?utf-8?B?RVdVRE9JOXJPREVHTml5Umt5OGN3b2JDc0RLZEdHZTNxYXVTUCtpV0h1TFJj?=
 =?utf-8?B?R0tqMkU1MVBoSFRXeVBDRnhiMFZCZWk2TFRTU0lNSTMrVGhtUzExVXBkTXFX?=
 =?utf-8?B?ODI2cHJqK29MUUMyOUdPKzhFSXREK1lyUDUvV2ZrVzYrYU0wR2g4Y1QrY2Q3?=
 =?utf-8?B?ZXFzclRyVnRwMWxpOFRSNUIxUFZOWm5FY2VGKzZoTWNjVktBTDRZWlB5dTk3?=
 =?utf-8?B?elM5eGc4MmNaN1FJOGIrMGErTHhvaGFCbkNEVmNFZ1FYNDN4TCtyOXh5aDNa?=
 =?utf-8?B?aDBSc2RyMTU1b1hmUkw4Q1JSMUpWUVR0YjE5VVpFbFVCd0UzcXNMMll0c2J2?=
 =?utf-8?B?Rm1BcGpGQjBvL2xJVkJ3TElBajFJWjg1Y25IMzNEeUFmM0ZOSEY5bUNsSzFW?=
 =?utf-8?B?Y1Nwems2VWJXYktOakdUMmFpNzdmdDdiSEt4eThHK1NCeUlZS3RpOFh5VjZi?=
 =?utf-8?B?TkxIdTNJTS81M29GVFptUUJJMnh3UXA1Y1hNbWo2R0VKcTZQSWYwR3prVTJs?=
 =?utf-8?B?YXZGVmJOZSsxMjJjZUdiWDYzWE1VdmgvZ2g2M2dOeU45UEMzd0ZaakpyWEZo?=
 =?utf-8?B?bzIwU1g4ODhTbDJjOVQwNDRvdVo5aUVrYlBXV2VkeG1vcEtGSzFJZGZlMUpq?=
 =?utf-8?B?enQxRW90TnVhQ3ViWUZrdU1XS25zS0ZkVlNuY0lWdXc2RWd5MGR3SjhLSDd2?=
 =?utf-8?B?WUF0YkNMQnNkaEsveGxEK0thaTJtSkhHeVZxaHd1V1pqRk5LNUNjSjVhZ2sz?=
 =?utf-8?B?cG9zeWsrTktiVitIYkdUa1BPYVhmN1hjS21GYXB6djRnU1dMZE1pK2Y0WDQr?=
 =?utf-8?B?VWl3b09sbVJCeE54QUduZz09?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?NEFhUDAvbHpNUHVjWnBNUU5yMXEwS0FtWHFoeWdkZ0FndnJMOUFxdlBSTEJ0?=
 =?utf-8?B?RXExRFFxUFpNQjZzTlR5MEdnVDdyODNLRlVxVEtYaGFFaTdVV1ZVNm5qWENO?=
 =?utf-8?B?OWRDT3BZajNiaUxXK2JqNVM0eXdzTDk2SXY2R3hrRFlROGpxOVh4dXZzbTRU?=
 =?utf-8?B?SUFDT0tKNFRpSkxtbTRzOFk4Uk0yN0VMd29HM29ZNkMxUVFxVjBIWEVwUk83?=
 =?utf-8?B?bDlZa2tFeWNYVnhhRWlaZGszVnJBbU9TdHRoZ0Z5V0hSVmorNzNCNCt0RnAv?=
 =?utf-8?B?M09RSHRIc0N5c05mSlJhcVV1VU1NS2c1WmpQeG9VR2psZmd1Ry8zK1hoR3pv?=
 =?utf-8?B?dkJYNy9BWHVlN1h1SnE0UzYvV2VEQW42TU0vZ1lwTkt6Y3MrU2N5eE93bXgy?=
 =?utf-8?B?allDL3ZpbXBWSTdiNjQ3YUh3c1J1Q3JndlFlblZsT2gxQW12b1NpZXM5d0k5?=
 =?utf-8?B?bXVlSUgwcEJ5bHEwYjVkSGFnQklJTzhiUzNudDZOK0FxMFhWZXZTQ3dpZ2ZJ?=
 =?utf-8?B?cjdHaldXcDNyYWZZdUQxT0tMaElXYWsyYnFRcjFncDMySDQ4cEtOdzZremxr?=
 =?utf-8?B?ZWY3eUFpTXk5VENXVnhtSi9iZHcwcWo4R3c5VnFHYkI4Qlg2bkdmOHVKdVJt?=
 =?utf-8?B?d3k5YTVnVFdTSXFHb1ROQVBGcm9mRUFrRXZTN2NLTm0yUEVzK1JYYkNqU3lv?=
 =?utf-8?B?anpaUmQrOFRTOHgrYVBHdUtIRFF4MUloT2dlQ04wNnh6bytnTWpjNkxOTHBE?=
 =?utf-8?B?dzBFb1JxNTBEc3B1Q28zSC9QQ0VJTDBMVUFvYjFhNHFBd00wcDROUXRPQ01t?=
 =?utf-8?B?L2tMN3F4bXBxTlpiMEFEZzhtSjZvRU5qN09VZjViaGlOTCtqYldReWl3Y3pU?=
 =?utf-8?B?R01TUmVSNzdYY1BwVUNWRkh3TXZOMVRsWWlzYzh6dkVCeFdrRTJsdStESTJE?=
 =?utf-8?B?Q3pJTklVVStyVXJWQkFrT1dicWg3WmJhN0FFZnBBTGllMHQ2bGIvTVlNS3M1?=
 =?utf-8?B?T0lCNGtFdm5WSVNaTXR3OUE1aFAzYXQ3ZlJpNlpYVzg0c0VTdVJ0QWxDN3g5?=
 =?utf-8?B?YXJUNkcxYWRDbGFXTmVSSlJ6MFRzOEhNK1pKTDZZdFAvSG9ZNTVNUGJKbVkv?=
 =?utf-8?B?dnlwdGRneUdad2ptSUNtckdCdmlBSjJxVXJiMU1RcGF6TTVNZjNCNzczS2RJ?=
 =?utf-8?B?QllVNGNIY0U5dUFCbytOQ3RBY3UrL0lTb2MyOUZFbXM3VlBRNHU1SnJ0MFpC?=
 =?utf-8?B?eGUxbG1YRUprSkJ5UWtiSHM3aURIZFd3clY4SEhnUWpIUFh1cUswUW9HQWpm?=
 =?utf-8?B?YitEYUw2dkRLZG1xNnIrQ2F2bzNTS1FVc090NkVIQlAxZWlXcWs3NmJCWjhm?=
 =?utf-8?B?bnhpOXM0TWRaakRHSDVmMjZwa2ZtNktuT3dvYWdaTTF5T3g0OUxxSkZrQWts?=
 =?utf-8?B?dDNlM2JEUHJrbG1RcUdmYVVhc0ZDeTF3c0dNU3NDUjR3OEhaRTBQSmtDeXRu?=
 =?utf-8?B?U0o1cnQ2MVBTVTY3L2ZQWHRSeHpvUUNPVCtjazhnY2d4UHFUaXZYS1NxNFlS?=
 =?utf-8?B?NGNQaFBibmZCeDNVWERxVlU5OHZLRVBxZkppY3BhQjZ1eXdqMUdTZ3ViZkZJ?=
 =?utf-8?B?MlIyb2JlSWg2anp5TG5aWksremZtYm5RS2VCQVFqNklhcUFIZ0dSM3E1Yk14?=
 =?utf-8?B?NXc0c204enI4UThyK0hZY2p6cWpwWVRRMHVHN1Z0QzR0elBtSHF6bUJlMnNj?=
 =?utf-8?B?SUIyZzloelpkbiswc2Q0Sll1c3BwTGNCRHREeGVQRWs2NnB5U3RndXFTQ00y?=
 =?utf-8?B?YmRmYnBxeTJRd2dBSWkxSDREbmM3L2FtM3oxcEV3RTVYQmkzWE5jUTFwMGUv?=
 =?utf-8?B?UmtsZko2d2NycWJZelBtZWx4dSs1U25hSEVvRWpCWm13MTVsd01JcGNXQTRE?=
 =?utf-8?B?dStTdWVlRk5MckdLbjZLV0ZFaUJSUmt3MG1kZTN1dkVwWU1CaEZKcFYyOWcz?=
 =?utf-8?B?SXVvckJsMnFzalpscWxmOE52ZFVhUG9yVVMyeTA5UUZwTmMxZ21xQWxkTFdH?=
 =?utf-8?B?NzBxV0dSVEtnTUVKMG9PcXZOOXJoMVVZNTZhY1dZaG1HSzdma1NIdUthN0NZ?=
 =?utf-8?B?dTRaZytqaWtJVEthalJxTlRycklKWnRYUkp3MStlVjNXV0I0TExuRDV1aGxG?=
 =?utf-8?B?Smc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1EE0F824A140894B8C7756CB63209550@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Pzi+6W7sCZpEToO9pWRqWWCMsKqzAQhRNGkN9r/jcDlLtJWPZLhQQjMgaOBciLinMwBmfXG/DWfF8HxW5uXTK//sBGooSg0Db34prw3ov9613+dZ+VVArdqzon1KlG+6Rnml/aixmHdjTDNhUjfBbmacuL1yP8bG7YVObdKJTsC5p9wjH3Loq0QMCNaaD5DOikTncBZqzxufJCivAd8Jy3/jj1N35qONngXWYQ4tiQlYgxq1gwtC2O3UsDMPXHk6aFyVShB3uFaLPczsunKDMxtBuXUrHnptvs0enwlG0BaKz7I/StkLzJxXyEpKBBXEbV+njCwTYLb6sru3NSP/MZiRYR4eKa+E+kGLTC8scKJ+6Hd0TzSoS3WT1sxjuYtS0suePfeIUlWfZj8HBpJfdJfrk8rZDb+NO/yNmAXh2NGzZtdhiQ+OLg0ZZNzLAxLWl+eKW4MWwiErnyyw4CC3LwqUw841KfbB4KoHL6maaZ+SV4mzz2TelagBSzIyTNN5fNdjRpU2IOiX87/1Sa54+8JFTFzP8toiPYFxzk/tkdfgZBnumf0hAThmI6teclXYlrZMuiyqOwzdObJTuYp0A8y+5jzvj5DyO2m6UiHHXO8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11151d42-4a6e-4d18-d95f-08dc736f1210
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2024 17:06:46.1294
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IZZ1UdQNeuGmIiatuP+p2vnInmMcuc2BC4KgE358ums+mXyxEKrTL2IPXzQyx0XhSQU4NEZ9G6Ybx0hHZqveuAJ4Tv3wkxQHBsE03C4x0/M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6769
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-13_12,2024-05-10_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405130112
X-Proofpoint-GUID: yrXCZgbBGGIwqzQWzsZmPNr8A0Imyfmt
X-Proofpoint-ORIG-GUID: yrXCZgbBGGIwqzQWzsZmPNr8A0Imyfmt

SGkgRGF2ZSwNClBsZWFzZSBzZWUgaW5saW5lcywNCg0KPiBPbiBNYXkgMTAsIDIwMjQsIGF0IDY6
MTfigK9QTSwgRGF2ZSBDaGlubmVyIDxkYXZpZEBmcm9tb3JiaXQuY29tPiB3cm90ZToNCj4gDQo+
IE9uIEZyaSwgTWF5IDEwLCAyMDI0IGF0IDA1OjM0OjI2UE0gLTA3MDAsIFdlbmdhbmcgV2FuZyB3
cm90ZToNCj4+IHdoZW4gd3JpdHRpbmcgc3VwZXIgYmxvY2sgdG8gZGlzayAoaW4geGZzX2xvZ19z
YiksIHNiX2ZkYmxvY2tzIGlzIGZldGNoZWQgZnJvbQ0KPj4gbV9mZGJsb2NrcyB3aXRob3V0IGFu
eSBsb2NrLiBBcyBtX2ZkYmxvY2tzIGNhbiBleHBlcmllbmNlIGEgcG9zaXRpdmUgLT4gbmVnYXRp
dg0KPj4gLT4gcG9zaXRpdmUgY2hhbmdpbmcgd2hlbiB0aGUgRlMgcmVhY2hlcyBmdWxsbmVzcyAo
c2VlIHhmc19tb2RfZmRibG9ja3MpDQo+PiBTbyB0aGVyZSBpcyBhIGNoYW5jZSB0aGF0IHNiX2Zk
YmxvY2tzIGlzIG5lZ2F0aXZlLCBhbmQgYmVjYXVzZSBzYl9mZGJsb2NrcyBpcw0KPj4gdHlwZSBv
ZiB1bnNpZ25lZCBsb25nIGxvbmcsIGl0IHJlYWRzIHN1cGVyIGJpZy4gQW5kIHNiX2ZkYmxvY2tz
IGJlaW5nIGJpZ2dlcg0KPj4gdGhhbiBzYl9kYmxvY2tzIGlzIGEgcHJvYmxlbSBkdXJpbmcgbG9n
IHJlY292ZXJ5LCB4ZnNfdmFsaWRhdGVfc2Jfd3JpdGUoKQ0KPj4gY29tcGxhaW5zLg0KPj4gDQo+
PiBGaXg6DQo+PiBBcyBzYl9mZGJsb2NrcyB3aWxsIGJlIHJlLWNhbGN1bGF0ZWQgZHVyaW5nIG1v
dW50IHdoZW4gbGF6eXNiY291bnQgaXMgZW5hYmxlZCwNCj4+IFdlIGp1c3QgbmVlZCB0byBtYWtl
IHhmc192YWxpZGF0ZV9zYl93cml0ZSgpIGhhcHB5IC0tIG1ha2Ugc3VyZSBzYl9mZGJsb2NrcyBp
cw0KPj4gbm90IGdlbmF0aXZlLg0KPiANCj4gT2ssIEkgaGF2ZSBubyBwcm9ibGVtcyB3aXRoIHRo
ZSBjaGFuZ2UgYmVpbmcgbWFkZSwgYnV0IEknbSB1bmNsZWFyDQo+IG9uIHdoeSB3ZSBjYXJlIGlm
IHRoZXNlIHZhbHVlcyBnZXQgbG9nZ2VkIGFzIGxhcmdlIHBvc2l0aXZlIG51bWJlcnM/DQo+IA0K
PiBUaGUgY29tbWVudCBhYm92ZSB0aGlzIGNvZGUgZXhwbGFpbnMgdGhhdCB0aGVzZSBjb3VudHMg
YXJlIGtub3duIHRvDQo+IGJlIGluYWNjdXJhdGUgYW5kIHNvIGFyZSBub3QgdHJ1c3RlZC4gaS5l
LiB0aGV5IHdpbGwgYmUgY29ycmVjdGVkDQo+IHBvc3QtbG9nIHJlY292ZXJ5IGlmIHRoZXkgYXJl
IHJlY292ZXJlZCBmcm9tIHRoZSBsb2c6DQo+IA0KPiAqIExhenkgc2IgY291bnRlcnMgZG9uJ3Qg
dXBkYXRlIHRoZSBpbi1jb3JlIHN1cGVyYmxvY2sgc28gZG8gdGhhdCBub3cuDQo+ICAgICAgICAg
KiBJZiB0aGlzIGlzIGF0IHVubW91bnQsIHRoZSBjb3VudGVycyB3aWxsIGJlIGV4YWN0bHkgY29y
cmVjdCwgYnV0IGF0DQo+ICAgICAgICAgKiBhbnkgb3RoZXIgdGltZSB0aGV5IHdpbGwgb25seSBi
ZSBiYWxscGFyayBjb3JyZWN0IGJlY2F1c2Ugb2YNCj4gICAgICAgICAqIHJlc2VydmF0aW9ucyB0
aGF0IGhhdmUgYmVlbiB0YWtlbiBvdXQgcGVyY3B1IGNvdW50ZXJzLiBJZiB3ZSBoYXZlIGFuDQo+
ICAgICAgICAgKiB1bmNsZWFuIHNodXRkb3duLCB0aGlzIHdpbGwgYmUgY29ycmVjdGVkIGJ5IGxv
ZyByZWNvdmVyeSByZWJ1aWxkaW5nDQo+ICAgICAgICAgKiB0aGUgY291bnRlcnMgZnJvbSB0aGUg
QUdGIGJsb2NrIGNvdW50cy4NCj4gDQoNClRoaW5ncyBpcyB0aGF0IHdlIGhhdmUgYSBtZXRhZHVt
cCwgbG9va2luZyBhdCB0aGUgZmRibG9ja3MgZnJvbSBzdXBlciBibG9jayAwLCBpdCBpcyBnb29k
Lg0KDQokIHhmc19kYiAtYyAic2IgMCIgLWMgInAiIGN1c3QuaW1nIHxlZ3JlcCAiZGJsb2Nrc3xp
ZnJlZXxpY291bnQiDQpkYmxvY2tzID0gMjYyMTQ0MDANCmljb3VudCA9IDUxMg0KaWZyZWUgPSAz
MzcNCmZkYmxvY2tzID0gMjU5OTcxMDANCg0KQW5kIHdoZW4gbG9va2luZyBhdCB0aGUgbG9nLCB3
ZSBoYXZlIHRoZSBmb2xsb3dpbmc6DQoNCiQgZWdyZXAgLWEgImZkYmxvY2tzfGljb3VudHxpZnJl
ZSIgY3VzdC5sb2cgfHRhaWwNCnNiX2ZkYmxvY2tzIDM3DQpzYl9pY291bnQgMTA1Ng0Kc2JfaWZy
ZWUgODcNCnNiX2ZkYmxvY2tzIDM3DQpzYl9pY291bnQgMTA1Ng0Kc2JfaWZyZWUgODcNCnNiX2Zk
YmxvY2tzIDM3DQpzYl9pY291bnQgMTA1Ng0Kc2JfaWZyZWUgODcNCnNiX2ZkYmxvY2tzIDE4NDQ2
NzQ0MDczNzA5NTUxNjA0DQoNCiMgY3VzdC5sb2cgaXMgb3V0cHV0IG9mIG15IHNjcmlwdCB3aGlj
aCB0cmllcyB0byBwYXJzZSB0aGUgbG9nIGJ1ZmZlci4NCg0KMTg0NDY3NDQwNzM3MDk1NTE2MDRV
TEwgPT0gMHhmZmZmZmZmZmZmZmZmZmY0IG9yIC0xMkxMIA0KDQpXaXRoIHVwc3RyZWFtIGtlcm5l
bCAoNi43LjAtcmMzKSwgd2hlbiBJIHRyaWVkIHRvIG1vdW50IChsb2cgcmVjb3ZlcikgdGhlIG1l
dGFkdW1wLA0KSSBnb3QgdGhlIGZvbGxvd2luZyBpbiBkbWVzZzoNCg0KWyAgIDUyLjkyNzc5Nl0g
WEZTIChsb29wMCk6IFNCIHN1bW1hcnkgY291bnRlciBzYW5pdHkgY2hlY2sgZmFpbGVkDQpbICAg
NTIuOTI4ODg5XSBYRlMgKGxvb3AwKTogTWV0YWRhdGEgY29ycnVwdGlvbiBkZXRlY3RlZCBhdCB4
ZnNfc2Jfd3JpdGVfdmVyaWZ5KzB4NjAvMHgxMTAgW3hmc10sIHhmc19zYiBibG9jayAweDANClsg
ICA1Mi45MzA4OTBdIFhGUyAobG9vcDApOiBVbm1vdW50IGFuZCBydW4geGZzX3JlcGFpcg0KWyAg
IDUyLjkzMTc5N10gWEZTIChsb29wMCk6IEZpcnN0IDEyOCBieXRlcyBvZiBjb3JydXB0ZWQgbWV0
YWRhdGEgYnVmZmVyOg0KWyAgIDUyLjkzMjk1NF0gMDAwMDAwMDA6IDU4IDQ2IDUzIDQyIDAwIDAw
IDEwIDAwIDAwIDAwIDAwIDAwIDAxIDkwIDAwIDAwICBYRlNCLi4uLi4uLi4uLi4uDQpbICAgNTIu
OTM0MzMzXSAwMDAwMDAxMDogMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgIC4uLi4uLi4uLi4uLi4uLi4NClsgICA1Mi45MzU3MzNdIDAwMDAwMDIwOiBjOSBj
MSBlZCBhZSA4NCBlZCA0NiBiOSBhMSBmMCAwOSA1NyA0YSBhOSA5OCA0MiAgLi4uLi4uRi4uLi5X
Si4uQg0KWyAgIDUyLjkzNzEyMF0gMDAwMDAwMzA6IDAwIDAwIDAwIDAwIDAxIDAwIDAwIDA2IDAw
IDAwIDAwIDAwIDAwIDAwIDAwIDgwICAuLi4uLi4uLi4uLi4uLi4uDQpbICAgNTIuOTM4NTE1XSAw
MDAwMDA0MDogMDAgMDAgMDAgMDAgMDAgMDAgMDAgODEgMDAgMDAgMDAgMDAgMDAgMDAgMDAgODIg
IC4uLi4uLi4uLi4uLi4uLi4NClsgICA1Mi45Mzk5MTldIDAwMDAwMDUwOiAwMCAwMCAwMCAwMSAw
MCA2NCAwMCAwMCAwMCAwMCAwMCAwNCAwMCAwMCAwMCAwMCAgLi4uLi5kLi4uLi4uLi4uLg0KWyAg
IDUyLjk0MTI5M10gMDAwMDAwNjA6IDAwIDAwIDY0IDAwIGI0IGE1IDAyIDAwIDAyIDAwIDAwIDA4
IDAwIDAwIDAwIDAwICAuLmQuLi4uLi4uLi4uLi4uDQpbICAgNTIuOTQyNjYxXSAwMDAwMDA3MDog
MDAgMDAgMDAgMDAgMDAgMDAgMDAgMDAgMGMgMDkgMDkgMDMgMTcgMDAgMDAgMTkgIC4uLi4uLi4u
Li4uLi4uLi4NClsgICA1Mi45NDQwNDZdIFhGUyAobG9vcDApOiBDb3JydXB0aW9uIG9mIGluLW1l
bW9yeSBkYXRhICgweDgpIGRldGVjdGVkIGF0IF94ZnNfYnVmX2lvYXBwbHkrMHgzOGIvMHgzYTAg
W3hmc10gKGZzL3hmcy94ZnNfYnVmLmM6MTU1OSkuICBTaHV0dGluZyBkb3duIGZpbGVzeXN0ZW0u
DQpbICAgNTIuOTQ2NzEwXSBYRlMgKGxvb3AwKTogUGxlYXNlIHVubW91bnQgdGhlIGZpbGVzeXN0
ZW0gYW5kIHJlY3RpZnkgdGhlIHByb2JsZW0ocykNClsgICA1Mi45NDgwOTldIFhGUyAobG9vcDAp
OiBsb2cgbW91bnQvcmVjb3ZlcnkgZmFpbGVkOiBlcnJvciAtMTE3DQpbICAgNTIuOTQ5ODEwXSBY
RlMgKGxvb3AwKTogbG9nIG1vdW50IGZhaWxlZA0KDQpMb29raW5nIGF0IGNvcnJlc3BvbmRpbmcg
Y29kZToNCiAyMzEgeGZzX3ZhbGlkYXRlX3NiX3dyaXRlKA0KIDIzMiAgICAgICAgIHN0cnVjdCB4
ZnNfbW91bnQgICAgICAgICptcCwNCiAyMzMgICAgICAgICBzdHJ1Y3QgeGZzX2J1ZiAgICAgICAg
ICAqYnAsDQogMjM0ICAgICAgICAgc3RydWN0IHhmc19zYiAgICAgICAgICAgKnNicCkNCiAyMzUg
ew0KIDIzNiAgICAgICAgIC8qDQogMjM3ICAgICAgICAgICogQ2Fycnkgb3V0IGFkZGl0aW9uYWwg
c2Igc3VtbWFyeSBjb3VudGVyIHNhbml0eSBjaGVja3Mgd2hlbiB3ZSB3cml0ZQ0KIDIzOCAgICAg
ICAgICAqIHRoZSBzdXBlcmJsb2NrLiAgV2Ugc2tpcCB0aGlzIGluIHRoZSByZWFkIHZhbGlkYXRv
ciBiZWNhdXNlIHRoZXJlDQogMjM5ICAgICAgICAgICogY291bGQgYmUgbmV3ZXIgc3VwZXJibG9j
a3MgaW4gdGhlIGxvZyBhbmQgaWYgdGhlIHZhbHVlcyBhcmUgZ2FyYmFnZQ0KIDI0MCAgICAgICAg
ICAqIGV2ZW4gYWZ0ZXIgcmVwbGF5IHdlJ2xsIHJlY2FsY3VsYXRlIHRoZW0gYXQgdGhlIGVuZCBv
ZiBsb2cgbW91bnQuDQogMjQxICAgICAgICAgICoNCiAyNDIgICAgICAgICAgKiBta2ZzIGhhcyB0
cmFkaXRpb25hbGx5IHdyaXR0ZW4gemVyb2VkIGNvdW50ZXJzIHRvIGlucHJvZ3Jlc3MgYW5kDQog
MjQzICAgICAgICAgICogc2Vjb25kYXJ5IHN1cGVyYmxvY2tzLCBzbyBhbGxvdyB0aGlzIHVzYWdl
IHRvIGNvbnRpbnVlIGJlY2F1c2UNCiAyNDQgICAgICAgICAgKiB3ZSBuZXZlciByZWFkIGNvdW50
ZXJzIGZyb20gc3VjaCBzdXBlcmJsb2Nrcy4NCiAyNDUgICAgICAgICAgKi8NCiAyNDYgICAgICAg
ICBpZiAoeGZzX2J1Zl9kYWRkcihicCkgPT0gWEZTX1NCX0RBRERSICYmICFzYnAtPnNiX2lucHJv
Z3Jlc3MgJiYNCiAyNDcgICAgICAgICAgICAgKHNicC0+c2JfZmRibG9ja3MgPiBzYnAtPnNiX2Ri
bG9ja3MgfHwNCiAyNDggICAgICAgICAgICAgICF4ZnNfdmVyaWZ5X2ljb3VudChtcCwgc2JwLT5z
Yl9pY291bnQpIHx8DQogMjQ5ICAgICAgICAgICAgICBzYnAtPnNiX2lmcmVlID4gc2JwLT5zYl9p
Y291bnQpKSB7DQogMjUwICAgICAgICAgICAgICAgICB4ZnNfd2FybihtcCwgIlNCIHN1bW1hcnkg
Y291bnRlciBzYW5pdHkgY2hlY2sgZmFpbGVkIik7DQogMjUxICAgICAgICAgICAgICAgICByZXR1
cm4gLUVGU0NPUlJVUFRFRDsNCiAyNTIgICAgICAgICB9DQoNCkZyb20gZG1lc2cgYW5kIGNvZGUs
IHdlIGtub3cgdGhlIGNoZWNrIGZhaWx1cmUgd2FzIGR1ZSB0byBiYWQgc2JfaWZyZWUgdnMgc2Jf
aWNvdW50IG9yIGJhZCBzYl9mZGJsb2NrcyB2cyBzYl9kYmxvY2tzLg0KDQpMb29raW5nIGF0IHRo
ZSBzdXBlciBibG9jayBkdW1wIGFuZCBsb2cgZHVtcCwNCldlIGtub3cgaWZyZWUgYW5kIGljb3Vu
dCBhcmUgZ29vZCwgd2hhdOKAmXMgYmFkIGlzIHNiX2ZkYmxvY2tzLiBBbmQgdGhhdCBzYl9mZGJs
b2NrcyBpcyBmcm9tIGxvZy4NCiMgSSB2ZXJpZmllZCB0aGF0IHNiX2ZkYmxvY2tzIGlzIDB4ZmZm
ZmZmZmZmZmZmZmZmNCB3aXRoIGEgVUVLIGRlYnVnIGtlcm5lbCAodGhvdWdoIG5vdCA2LjcuMC1y
YzMpDQoNClNvIHRoZSBzYl9mZGJsb2NrcyBpcyB1cGRhdGVkIGZyb20gbG9nIHRvIGluY29yZSBh
dCB4ZnNfbG9nX3NiKCkgLT4geGZzX3ZhbGlkYXRlX3NiX3dyaXRlKCkgcGF0aCB0aG91Z2gNClNo
b3VsZCBiZSBtYXkgcmUtY2FsY3VsYXRlZCBmcm9tIEFHcy4NCg0KVGhlIGZpeCBhaW1zIHRvIG1h
a2UgeGZzX3ZhbGlkYXRlX3NiX3dyaXRlKCkgaGFwcHkuDQoNClRoYW5rcywNCldlbmdhbmcNCg0K
PiBJT1dzIGpvdXJuYWwgcmVjb3ZlcnkgZG9lc24ndCBhY3R1YWxseSBjYXJlIHdoYXQgdGhlc2Ug
dmFsdWVzIGFyZSwNCj4gc28gd2hhdCBhY3R1YWxseSBnb2VzIHdyb25nIGlmIHRoaXMgc3VtIHJl
dHVybnMgYSBuZWdhdGl2ZSB2YWx1ZT8NCj4gDQo+IENoZWVycywNCj4gDQo+IERhdmUuDQo+IC0t
IA0KPiBEYXZlIENoaW5uZXINCj4gZGF2aWRAZnJvbW9yYml0LmNvbQ0KDQo=
