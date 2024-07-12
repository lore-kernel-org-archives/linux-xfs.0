Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2D68F70
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2024 19:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720811232; cv=fail; b=cifMOodlR1e9FCMvomGjXzbEbzQQBrfjtN3/a7pcq/FXN6LjTsc85LVF5lcwoAt2Tg+Ok6/1UjS6qO5/kxtxzYVr7kKfBSXNdpVrGiBmJNugZLi10lkrsI4WUNp+M6poHL8RXK9SzfsoV+hB72EtS83pDcCahzQ06R40VF/bDdE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720811232; c=relaxed/simple;
	bh=mAX2+LieyjqPf/qsl6wJUJNdi5CQ0/N+5wlsKbNpNwo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hwZLDGnbybrmdV5qGZ1bRcrWTWQaRyBEVYWt/1Yijp5y5ErpEMY9gYDu0I3mVwGKC7RniQvq1elReWvtrfIKAkuUwtGct+Jd0NzIR2pYVbvLwsTtdA9yQUQyn4VQQ6+emuqyDnkODkO2h84z3NXLRAPuDKszcUDXZtAJ3jTcgE8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SHnBfSP2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=djlgP0OM; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SHnBfSP2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="djlgP0OM"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46CIXXBn018268;
	Fri, 12 Jul 2024 19:07:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=mAX2+LieyjqPf/qsl6wJUJNdi5CQ0/N+5wlsKbNpN
	wo=; b=SHnBfSP2ueK/irghu0BL2zIyueigYa9ikNHk+OpQ7tWB2HysZKgwdSFG+
	H+4Nnr1woLAkr+y/8g7/L5hZomnCxyDv262G2CgoRxMbP/Iu3FICj4X3+XSSWlh5
	qWzfraMUw/KOozC1GjuNgFsz7sQn9tZiRWOJfg5AypyX4j7h5OYm729VgW0TIDUl
	R2yptFL7+DpME3ttKD9Ee6IM0T6hgi3GHqmyqYSWGnzzk2BkEMUmsIY8o6MCn1AM
	XZrZfkmTFHbHErdBsTwP8MVN8sQ/kpiUkaMNzv74B/k73JVsxyDQ7jen53u04YdD
	9K8/52T/eIqNnf82NU1qTXLtCea8Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406xfsvng8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Jul 2024 19:07:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46CINvtR030012;
	Fri, 12 Jul 2024 19:07:05 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2174.outbound.protection.outlook.com [104.47.73.174])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 409vvcyj47-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Jul 2024 19:07:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gQOAlvkRHogFG3uN/f6Br5itNASm/r1sC/RDSjdMHJA46S4avWpczDCPT0ZakSCEC/PZ928COb/cGwrSK6VBrJ+wg8Sf+TQHHYtmPfIKaa1KHUV8G103pXodYxCihLZ1sAQHxWZ9sTXhrbEbUc/Ute2nZyBM+uZFjlKUo+12P56ToAJ+tQ8aR2V2jwpZpUuHkWqq1nxpXwn5/IXAfviuY1qD9BgAD5lP7UoyZngyK/pP5pQhS1hmmpzWd0w3kmAKbkxy8YxSEJFLhqMqxezNGT8OtiwOq+keajmj7HZS4MHtECiyN6LTAFJL70fxUKd6S84uzwgwcWjRJyjefV45mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mAX2+LieyjqPf/qsl6wJUJNdi5CQ0/N+5wlsKbNpNwo=;
 b=TqKCYLsHtWLGmGEyvgnEc2iWcin8L62trYm3QE9DhKn+gzLFlMs0KtULINrxDfA0iCIWQcovgx4a4opIDZKbpyJ4p0hQUY9ef+BC2jbNMLXeZ1bfnA49QViPViMIklwDLr3EPiSK2lfvsAgvLmH4vkjTdNRYtB60MbxUTfKq7fUiu9Aez5c6Ic5xn0n6LD6fR8+irbBQD0SMLZO/boTAdMmfSpgBUdjl6dpyQF9ralWmZeccAl03B3HjWYF5jfULWr713Mlz5/HBV3goXtzWqewz4yFj3F1OWLVQQQbZGF8EemIphT+Ujs0NiTKzFrluX6x96BK8tktw9idOZkcc/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mAX2+LieyjqPf/qsl6wJUJNdi5CQ0/N+5wlsKbNpNwo=;
 b=djlgP0OMdLmNxBMfNs3iOXDjyjZG82zJTb/WFy+hPP9dPjb9ZUfAOroPgszddfObddG+oc26STJQCzg/JE+06BAq7zzNIRpqTz4jQ2daaeuaEibi4aq30nVuu7DfEjIaxghWiUVN+WPhJOhgi5Y2vxqdoEj6SoKSw4We12JqAjY=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by DM4PR10MB5941.namprd10.prod.outlook.com (2603:10b6:8:ab::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.23; Fri, 12 Jul
 2024 19:07:02 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%3]) with mapi id 15.20.7762.020; Fri, 12 Jul 2024
 19:07:01 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 3/9] spaceman/defrag: defrag segments
Thread-Topic: [PATCH 3/9] spaceman/defrag: defrag segments
Thread-Index: AQHa0jOuXyFSvutJ4kmLNdUbwmDQsbHu8YqAgAMzDoCAAVRNAA==
Date: Fri, 12 Jul 2024 19:07:01 +0000
Message-ID: <8700A82B-0A70-4C04-B6DE-00F759759C05@oracle.com>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-4-wen.gang.wang@oracle.com>
 <20240709215721.GA612460@frogsfrogsfrogs>
 <88831781-0D65-4966-8E95-F429178C9A79@oracle.com>
In-Reply-To: <88831781-0D65-4966-8E95-F429178C9A79@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|DM4PR10MB5941:EE_
x-ms-office365-filtering-correlation-id: d0af0e0c-a01f-4d74-e2d8-08dca2a5cfcf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: 
 =?utf-8?B?UEJDVldJRUNETVFnME81c29sTzd0WTN6bkp2enJMeHBHZVdRd043SFIwN0lP?=
 =?utf-8?B?elFHMmcwWUwrRmIveUZDSGVLK2pKNThSYklLRTAxWFhha3ZJL0dZVW5OaE5Y?=
 =?utf-8?B?VjcvdEJkRjNSd3drd1UydlJqUEdFdjdPd1RsSFJjdE9hWmhYQkRmMFdLY2Fu?=
 =?utf-8?B?Zk4vaFdBZERZZ3ROUDFCbUlDVXlPUGg5V1ZncXgwMVlXV2tIRFVENkN2L1ZL?=
 =?utf-8?B?L3MzZXozZlhJSUJOU2ZZRk02RHNTZEJ4QWVpUitVcnFYbVB1UHdManhVN3Vi?=
 =?utf-8?B?OUY1SkRmSUlPazU0eHdFZHJva2M1UWlEWEZLZXNrdW9BcnN2QUpVek5hUVFD?=
 =?utf-8?B?MWNEMTBXK3lpd1NRN1J0RnZxTEJ6ZCtudHpPZXlDU2pUOEFNTW5ScU9CSEJI?=
 =?utf-8?B?NGJrYkdpdWVSYnpaL2o3MCtqZGNURm9qOTZFdEVCeTBmTGovL09VQ2FmUHNX?=
 =?utf-8?B?em9GUjk0Q3RlQlh3YW52OEhRRVdyY2lYdHd5T3Y5cVZ1MWNYdTlJdFZ6UnJC?=
 =?utf-8?B?YWJOQlQ3cW5WRWQ3ZEt5SFA5Zmo5VVgvcWdYMkpveG1kMHZkSERrSmJ5a3Vq?=
 =?utf-8?B?aFdkM0JsLzVFMFQrWXVnaUdpUEVqOWs1S1I3SGJtR1lTWlNnMzhHWGgyN2pL?=
 =?utf-8?B?ZXRjYXpTUFJhdlQ5YzBVRlhUK0RZRmxJK3YvMW15TDBwcmtxdGI2QSs2NUFN?=
 =?utf-8?B?MHVrNHNsNlRGK0d4b0RUS0x4eUNmYytmV3RFTGl6K0dHZCt2Y1hBQmZjVmVu?=
 =?utf-8?B?azgvcFRMZ0FEQXhIYUZsU0xCTVBwVVdWY0RjRnQ1dFFDQjZQQjExQXJpMnlQ?=
 =?utf-8?B?Ulk5R0JRYkNybTQxWTRQb0IzcTVsbTZzQ1lQNXZ5M1dCUFZRMEpQVFRYUzVx?=
 =?utf-8?B?OFJoMGh2ZUxvUS9TbVpUVFkrSzRDNXQwZzE5ODZnUG5TMTFUVVVmUGdCN2ZH?=
 =?utf-8?B?VDlvcUlPWWExVkhsY2Z5YktEWHBSRnZ1Q2IvL0p6VWJQcEdqZXBSYXRZZFNq?=
 =?utf-8?B?SzNTWU9jQSszV0pGZnlqcklia1plbDViMmhpdTF6S01CY1RxOWFRWDBoUkJS?=
 =?utf-8?B?UXg2NE90MkQzT1UxbzVCR0FwVDhIb2RiWVJ5QlZhTXhydTFCdjhFY3hnWkt6?=
 =?utf-8?B?SWV2YWVRZUFNWlV2dXNjdXRyYTV2RUZrSHhDcFViUUJVZ201OFA2ZmF2Q0RO?=
 =?utf-8?B?TUNRRkZlZnNwZ21UcTMwVzE1bXplM0ZVT25ucXZuUUg0SHE4UVpvMUNtWmg5?=
 =?utf-8?B?cGExZ0VXbXlET3ZVTjBleVI0ZXV1V1hNQ3BNMzVOdHhsS1NvemN5amRaYzhP?=
 =?utf-8?B?cmxicitOK0MzK2pNOC90dVBxSzRGNE1RTUNCRHJudkJ6NW1HNnpGWWYrbllu?=
 =?utf-8?B?ZktBUWwwOHBHLy8rNGluRU9RYjl6R2VBbGJZZGhBU1F4Tm1YTHdKZ05YbG9L?=
 =?utf-8?B?eVlYMGJPSlJhWGRWT29tL3F5UnFlTWFGMWtjRjU4NkU2Z1lyTnNZWi9TSi9u?=
 =?utf-8?B?Yk41M3B3SzgyeWVsVnhYT2ZHZ3hFOHJEeThwcVdnYmN1MGwzUmZGSWF2RU5I?=
 =?utf-8?B?QnNKQXhaSUFFeVJOS29ialh4YlFzVWV3UktxYlBLbUVPeG5ucHdLQ2YwcUxO?=
 =?utf-8?B?bktOa3ZRVmJwblcxd3FPanlyQTNqZHM4YVdyVnRVS2hyWmh4WUloZGlvbVFC?=
 =?utf-8?B?QkdkeTgwUjY3Z09lOVdlUC9ibzhWdElaQituczlVVUYxakh5cW91Uk9LKzdL?=
 =?utf-8?B?U0pOSGNwNi9yT0Uwa0tkSFVOVXRweGVtODBRSFg1SVZha0Y1REh0dmVOT3lt?=
 =?utf-8?B?cWtCdmVxQWxBbnhCQnZYbk9wcEp4bTY0QTBiUTRDQ2Y3K1BtM0dLM1o0NldV?=
 =?utf-8?B?cXlpN2hINVRzbTBFMTFIRjJZSTJNN2liQ0xNd2FMM0t2c0E9PQ==?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?Q2hpOGZNVnNjb0tkY280Z3ByNzJHdHJGdGRhWC9SSEdJOXAvUGtTdEdYRFJ6?=
 =?utf-8?B?UGl4VGhiZUxaclBIaGNkWWY2YkVMWWtkRjFSOGhPR1dzVXNXMW96TUh4SldJ?=
 =?utf-8?B?Y2ZBTnd2eTFxWlZ0VHo4VUpsVFBkZUs4QUJuL0t4SGZuS09vd0VvQUNCWHQv?=
 =?utf-8?B?LzZZRFRFZmE4YVFhZkRLbzZjenFHNEppZG9xZm5CTlNIa3U2bUtYbUFZbkxy?=
 =?utf-8?B?b0puaERyUWJsbEY1SStqRHEwcHM0a1dWM1QvcEd3NjVGTTJ4TkVZbnV5Tzh2?=
 =?utf-8?B?ZHhRZU56aEJpUDhxZEYvUXRGMGpNTDFmcERreEFJN0Z4NHpzNlNzMGJSTkhx?=
 =?utf-8?B?VnFTOEh4WGFtMzFHb1RVTGJRSG1lUlVra2V4RjJCQW53WlRCZy80VTJHRDRk?=
 =?utf-8?B?Q3k5dnBnTjBlZERBZmtIVkR4bFRLbmZmL3pBeEQrQXVYKy9Xelgzb0R3bUNZ?=
 =?utf-8?B?K2M2dDByQk5SWVRxc0p3OHNVYTV2V1QrYmtIMENpRTZzSUlkcy9lc0Z5Umwv?=
 =?utf-8?B?ME90cTRJZXRrS1FmQjAyb1Z4ZHc4Ri9JcTBFM3BRZ28rZU1ycG1Va2xQZjZB?=
 =?utf-8?B?UW1WTXFndVlkTXFCVndCMFV2eEZMY01pNHRhTDlUTStWYlpUNzdMWkZjVzFm?=
 =?utf-8?B?RmI5UEhqS1U1cTVVNEFkYVIxdm9WY3J6ZG1zT2RjSkxMdlBBUlVLNWFPN3Qw?=
 =?utf-8?B?aitYT0Fkc1hUVHlXN3c5SHZXVHo2YkRuRnRadkRVQmVFL1prTkErcjZBOFpl?=
 =?utf-8?B?b1RXYjVHTTJuTVVxemJja04rOTU5UEhrYnRndlU5V0RvOE0vYVNXTzhpdHhB?=
 =?utf-8?B?RnZPUTJ5bmZLYnBoQlg4OTdKWmNrenlHeGJwTS8zVHBveWU5aThwSGlDcU1o?=
 =?utf-8?B?NE8yTUU0ZXZINjhOOGVpYVMxdUxWV0t5K0RTM01UYnY4RXhUTWVYcjMzQStE?=
 =?utf-8?B?aVBPUXNqaHpMZ2lRRVhZQ1pnYnJRSTJxdXZZdkRRSzByMTFmeFBLUFRpWFZ2?=
 =?utf-8?B?dHk0QS9rVkVaalZJNW90Q2ZPRWNkaDJkK0tOTEhyWi9Lc1o4QldlRGFwc3RH?=
 =?utf-8?B?c204OStFMENSWUhqNXVGVHVqVlVNMVhYZ0FvWFQ3aXgwOUZXQ2xnbkxGVm5t?=
 =?utf-8?B?T0dkcFZHT2hSd1g3R1hGTWZOeDMyRjhJalRUU2YwbVBGV2pQblRMTGNUMXJx?=
 =?utf-8?B?MEg0bmEzcXljNk1zSkJkTXR4UHYwMFpRM0JFMEFMaDdZSkhIbDFtSFNIbnNu?=
 =?utf-8?B?TWkyU3FWRm9tLy9YcjJ2TTlEWGpSVFdlQjFPNThETEFva2h6Z3A2RFh2cG9w?=
 =?utf-8?B?Yk1jUjUvSlVXaWxpZlJic3RvdFdsTTJza1QvRGJnRTdEYzFsRTFjZHQ3NkRs?=
 =?utf-8?B?dTN6cG41c0F1QXdPMUNiSlNNLzhTeDI2SWtLWW5TVUUxOFE1amZhODViU2lT?=
 =?utf-8?B?M0I1V0xsT1V3bDFhSDF4aEFndkJ5Z0dHOW1MeHN0a0drcXFQdlZpalowOG8x?=
 =?utf-8?B?Y2hsdGN5eWNZZTgrbFc2OWs3N3BKcW80N1pqc2l2eVRuZytISkpTZ08rMkRH?=
 =?utf-8?B?T0JZelAvSEp4NGwrUktub09HakNNbVRNb2thcmp0TDdBbVBFL2orbnpJK1V3?=
 =?utf-8?B?bVJyUDFqVjNYcCt1Vy9JUmZuMzd6VjlOREd1K2tHLy9SSU5JLzlzL1YwbTBj?=
 =?utf-8?B?UDZ4Q0RaN2Q4dW8rV3RNb1FobWlyNWV5QW9XYUZMaU9NbTdrZXJwc25QUzRm?=
 =?utf-8?B?MVVPdE04R0RaNmNsbzRFNE9IZzdKLzJBZHBMODdWZjRpV2Q1eEdZMlB6UXA0?=
 =?utf-8?B?UkUzekc3c1YxSTRBOWwvdWorMWJsVWxUZGt4cWlFMDZ5aWJWdWJxZjE4VGVn?=
 =?utf-8?B?MGdvck5VOENiellYckpjSzlPVDRNdDdHRVUrRUlFOWRScm94dFQwYk9KbHBu?=
 =?utf-8?B?Q2lVOUp5OStuZngrZCttZ0dpUVZVRjhvMGdnRWliVFR3THAyenc5MW1DUDRS?=
 =?utf-8?B?WmZIOUF5SUg0S3dXKzBwY3FzeFFXWFFlNDdRSTNqcmVPNGZCVElLYTJ1RHR4?=
 =?utf-8?B?R1crTFJySC93QTJhRmlnUmF5cHd2dWl2UWtaYVVaRzFzQTFjWXIreS9iVmtw?=
 =?utf-8?B?cHhhczBBRjJrbEdTSkZyQVN3b3F2N0ZTSXNSWnJrS1I3QzhTU0lvbWpBdnlG?=
 =?utf-8?B?bVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5DB626E54CE2EE488E4279EBFC5F2AA0@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	9c2N3ycGrNGtCrLNHrxlUQ1lZ1RXL/fOGHAjtdc8EMXqljS6+HMVLfISvZpqk9+FCG35XZom6Z4q8opNTr+8jI9n8ulQ9ZdTYjFq7Jz0OZz69NcqovoZmNqIqDWbL82Tz+5ZVBwpsWKGRq8NS3WMzV7CAg4Q0MiBtTNx5faUuZZiJNNz/uVEK6eLeXAFmD1Kl9lE6E54oKJod2PI8LCksY/VHfGJOwQB36Fe5soGAzTCF4HTc0NBctbcyTFiH8AcEZhn6GOfDXF+VE6tYEwGJwpGBb8LtDCdm+OgzBSP7vMS7P7Ufo240uyq99IG8K9ro7DkrW7SbPKu2zegpR3scoeF4LJSFLlBmRCIwDRmUYq6xSKs6xZ862fYn1Pz++M/MY7NfU4mdsHew8oxXw8vHi2ft9JDh/SLlLFPWR7W5KxNfMhqAEXkfYCmBV3Jbwsn9aGDoZIdJrXAZBMRTUrNTGfs+zTS70GQk5eBu8gVVe3k5cxfD6AwOuzozxRzVMQe6v3XMwVfsKB7HFGW2ZY4XlGeTuVPEgi910BpuvbyFU2D3CEikmIYBF2kYQspKLkHtpuFwu8JwrUbnOXt4tDSsfepAVDCxsdkPFfpEIeOxyc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0af0e0c-a01f-4d74-e2d8-08dca2a5cfcf
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2024 19:07:01.9145
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uWs74/bEAzXOyRH8eXEwN51sHR58OCHwolvad04E9dylLWClxFJaQi9eskzaCGJ2Ub9umVjwJStk8yZXw12/BtrLcbvjRraXkSuUdPhHI7A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5941
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-12_15,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407120129
X-Proofpoint-ORIG-GUID: 7E-amJMwWBMS1lLMTekqBzSGR5GR_EzL
X-Proofpoint-GUID: 7E-amJMwWBMS1lLMTekqBzSGR5GR_EzL

DQoNCj4gT24gSnVsIDExLCAyMDI0LCBhdCAzOjQ54oCvUE0sIFdlbmdhbmcgV2FuZyA8d2VuLmdh
bmcud2FuZ0BvcmFjbGUuY29tPiB3cm90ZToNCj4gDQo+IA0KPiANCj4+IE9uIEp1bCA5LCAyMDI0
LCBhdCAyOjU34oCvUE0sIERhcnJpY2sgSi4gV29uZyA8ZGp3b25nQGtlcm5lbC5vcmc+IHdyb3Rl
Og0KPj4gDQo+PiBPbiBUdWUsIEp1bCAwOSwgMjAyNCBhdCAxMjoxMDoyMlBNIC0wNzAwLCBXZW5n
YW5nIFdhbmcgd3JvdGU6DQo+Pj4gRm9yIGVhY2ggc2VnbWVudCwgdGhlIGZvbGxvd2luZyBzdGVw
cyBhcmUgZG9uZSB0cnlpbmcgdG8gZGVmcmFnIGl0Og0KPj4+IA0KPj4+IDEuIHNoYXJlIHRoZSBz
ZWdtZW50IHdpdGggYSB0ZW1wb3JhcnkgZmlsZQ0KPj4+IDIuIHVuc2hhcmUgdGhlIHNlZ21lbnQg
aW4gdGhlIHRhcmdldCBmaWxlLiBrZXJuZWwgc2ltdWxhdGVzIENvdyBvbiB0aGUgd2hvbGUNCj4+
PiAgc2VnbWVudCBjb21wbGV0ZSB0aGUgdW5zaGFyZSAoZGVmcmFnKS4NCj4+PiAzLiByZWxlYXNl
IGJsb2NrcyBmcm9tIHRoZSB0ZW1wb2FyeSBmaWxlLg0KPj4+IA0KPj4+IFNpZ25lZC1vZmYtYnk6
IFdlbmdhbmcgV2FuZyA8d2VuLmdhbmcud2FuZ0BvcmFjbGUuY29tPg0KPj4+IC0tLQ0KPj4+IHNw
YWNlbWFuL2RlZnJhZy5jIHwgMTE0ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysNCj4+PiAxIGZpbGUgY2hhbmdlZCwgMTE0IGluc2VydGlvbnMoKykNCj4+PiAN
Cj4+PiBkaWZmIC0tZ2l0IGEvc3BhY2VtYW4vZGVmcmFnLmMgYi9zcGFjZW1hbi9kZWZyYWcuYw0K
Pj4+IGluZGV4IDE3NWNmNDYxLi45ZjExZTM2YiAxMDA2NDQNCj4+PiAtLS0gYS9zcGFjZW1hbi9k
ZWZyYWcuYw0KPj4+ICsrKyBiL3NwYWNlbWFuL2RlZnJhZy5jDQo+Pj4gQEAgLTI2Myw2ICsyNjMs
NDAgQEAgYWRkX2V4dDoNCj4+PiByZXR1cm4gcmV0Ow0KPj4+IH0NCj4+PiANCj4+PiArLyoNCj4+
PiArICogY2hlY2sgaWYgdGhlIHNlZ21lbnQgZXhjZWVkcyBFb0YuDQo+Pj4gKyAqIGZpeCB1cCB0
aGUgY2xvbmUgcmFuZ2UgYW5kIHJldHVybiB0cnVlIGlmIEVvRiBoYXBwZW5zLA0KPj4+ICsgKiBy
ZXR1cm4gZmFsc2Ugb3RoZXJ3aXNlLg0KPj4+ICsgKi8NCj4+PiArc3RhdGljIGJvb2wNCj4+PiAr
ZGVmcmFnX2Nsb25lX2VvZihzdHJ1Y3QgZmlsZV9jbG9uZV9yYW5nZSAqY2xvbmUpDQo+Pj4gK3sN
Cj4+PiArIG9mZl90IGRlbHRhOw0KPj4+ICsNCj4+PiArIGRlbHRhID0gY2xvbmUtPnNyY19vZmZz
ZXQgKyBjbG9uZS0+c3JjX2xlbmd0aCAtIGdfZGVmcmFnX2ZpbGVfc2l6ZTsNCj4+PiArIGlmIChk
ZWx0YSA+IDApIHsNCj4+PiArIGNsb25lLT5zcmNfbGVuZ3RoID0gMDsgLy8gdG8gdGhlIGVuZA0K
Pj4+ICsgcmV0dXJuIHRydWU7DQo+Pj4gKyB9DQo+Pj4gKyByZXR1cm4gZmFsc2U7DQo+Pj4gK30N
Cj4+PiArDQo+Pj4gKy8qDQo+Pj4gKyAqIGdldCB0aGUgdGltZSBkZWx0YSBzaW5jZSBwcmVfdGlt
ZSBpbiBtcy4NCj4+PiArICogcHJlX3RpbWUgc2hvdWxkIGNvbnRhaW5zIHZhbHVlcyBmZXRjaGVk
IGJ5IGdldHRpbWVvZmRheSgpDQo+Pj4gKyAqIGN1cl90aW1lIGlzIHVzZWQgdG8gc3RvcmUgY3Vy
cmVudCB0aW1lIGJ5IGdldHRpbWVvZmRheSgpDQo+Pj4gKyAqLw0KPj4+ICtzdGF0aWMgbG9uZyBs
b25nDQo+Pj4gK2dldF90aW1lX2RlbHRhX3VzKHN0cnVjdCB0aW1ldmFsICpwcmVfdGltZSwgc3Ry
dWN0IHRpbWV2YWwgKmN1cl90aW1lKQ0KPj4+ICt7DQo+Pj4gKyBsb25nIGxvbmcgdXM7DQo+Pj4g
Kw0KPj4+ICsgZ2V0dGltZW9mZGF5KGN1cl90aW1lLCBOVUxMKTsNCj4+PiArIHVzID0gKGN1cl90
aW1lLT50dl9zZWMgLSBwcmVfdGltZS0+dHZfc2VjKSAqIDEwMDAwMDA7DQo+Pj4gKyB1cyArPSAo
Y3VyX3RpbWUtPnR2X3VzZWMgLSBwcmVfdGltZS0+dHZfdXNlYyk7DQo+Pj4gKyByZXR1cm4gdXM7
DQo+Pj4gK30NCj4+PiArDQo+Pj4gLyoNCj4+PiAqIGRlZnJhZ21lbnQgYSBmaWxlDQo+Pj4gKiBy
ZXR1cm4gMCBpZiBzdWNjZXNzZnVsbHkgZG9uZSwgMSBvdGhlcndpc2UNCj4+PiBAQCAtMjczLDYg
KzMwNyw3IEBAIGRlZnJhZ194ZnNfZGVmcmFnKGNoYXIgKmZpbGVfcGF0aCkgew0KPj4+IGxvbmcg
bnJfc2VnX2RlZnJhZyA9IDAsIG5yX2V4dF9kZWZyYWcgPSAwOw0KPj4+IGludCBzY3JhdGNoX2Zk
ID0gLTEsIGRlZnJhZ19mZCA9IC0xOw0KPj4+IGNoYXIgdG1wX2ZpbGVfcGF0aFtQQVRIX01BWCsx
XTsNCj4+PiArIHN0cnVjdCBmaWxlX2Nsb25lX3JhbmdlIGNsb25lOw0KPj4+IGNoYXIgKmRlZnJh
Z19kaXI7DQo+Pj4gc3RydWN0IGZzeGF0dHIgZnN4Ow0KPj4+IGludCByZXQgPSAwOw0KPj4gDQo+
PiBOb3cgdGhhdCBJIHNlZSB0aGlzLCB5b3UgbWlnaHQgd2FudCB0byBzdHJhaWdodGVuIHVwIHRo
ZSBsaW5lczoNCj4+IA0KPj4gc3RydWN0IGZzeGF0dHIgZnN4ID0geyB9Ow0KPj4gbG9uZyBucl9z
ZWdfZGVmcmFnID0gMCwgbnJfZXh0X2RlZnJhZyA9IDA7DQo+PiANCj4+IGV0Yy4gIE5vdGUgdGhl
ICI9IHsgfSIgYml0IHRoYXQgbWVhbnMgeW91IGRvbid0IGhhdmUgdG8gbWVtc2V0IHRoZW0gdG8N
Cj4+IHplcm8gZXhwbGljaXRseS4NCj4gDQo+IE5pY2UhDQo+IA0KPj4gDQo+Pj4gQEAgLTI5Niw2
ICszMzEsOCBAQCBkZWZyYWdfeGZzX2RlZnJhZyhjaGFyICpmaWxlX3BhdGgpIHsNCj4+PiBnb3Rv
IG91dDsNCj4+PiB9DQo+Pj4gDQo+Pj4gKyBjbG9uZS5zcmNfZmQgPSBkZWZyYWdfZmQ7DQo+Pj4g
Kw0KPj4+IGRlZnJhZ19kaXIgPSBkaXJuYW1lKGZpbGVfcGF0aCk7DQo+Pj4gc25wcmludGYodG1w
X2ZpbGVfcGF0aCwgUEFUSF9NQVgsICIlcy8ueGZzZGVmcmFnXyVkIiwgZGVmcmFnX2RpciwNCj4+
PiBnZXRwaWQoKSk7DQo+Pj4gQEAgLTMwOSw3ICszNDYsMTEgQEAgZGVmcmFnX3hmc19kZWZyYWco
Y2hhciAqZmlsZV9wYXRoKSB7DQo+Pj4gfQ0KPj4+IA0KPj4+IGRvIHsNCj4+PiArIHN0cnVjdCB0
aW1ldmFsIHRfY2xvbmUsIHRfdW5zaGFyZSwgdF9wdW5jaF9ob2xlOw0KPj4+IHN0cnVjdCBkZWZy
YWdfc2VnbWVudCBzZWdtZW50Ow0KPj4+ICsgbG9uZyBsb25nIHNlZ19zaXplLCBzZWdfb2ZmOw0K
Pj4+ICsgaW50IHRpbWVfZGVsdGE7DQo+Pj4gKyBib29sIHN0b3A7DQo+Pj4gDQo+Pj4gcmV0ID0g
ZGVmcmFnX2dldF9uZXh0X3NlZ21lbnQoZGVmcmFnX2ZkLCAmc2VnbWVudCk7DQo+Pj4gLyogbm8g
bW9yZSBzZWdtZW50cywgd2UgYXJlIGRvbmUgKi8NCj4+PiBAQCAtMzIyLDYgKzM2Myw3OSBAQCBk
ZWZyYWdfeGZzX2RlZnJhZyhjaGFyICpmaWxlX3BhdGgpIHsNCj4+PiByZXQgPSAxOw0KPj4+IGJy
ZWFrOw0KPj4+IH0NCj4+PiArDQo+Pj4gKyAvKiB3ZSBhcmUgZG9uZSBpZiB0aGUgc2VnbWVudCBj
b250YWlucyBvbmx5IDEgZXh0ZW50ICovDQo+Pj4gKyBpZiAoc2VnbWVudC5kc19uciA8IDIpDQo+
Pj4gKyBjb250aW51ZTsNCj4+PiArDQo+Pj4gKyAvKiB0byBieXRlcyAqLw0KPj4+ICsgc2VnX29m
ZiA9IHNlZ21lbnQuZHNfb2Zmc2V0ICogNTEyOw0KPj4+ICsgc2VnX3NpemUgPSBzZWdtZW50LmRz
X2xlbmd0aCAqIDUxMjsNCj4+PiArDQo+Pj4gKyBjbG9uZS5zcmNfb2Zmc2V0ID0gc2VnX29mZjsN
Cj4+PiArIGNsb25lLnNyY19sZW5ndGggPSBzZWdfc2l6ZTsNCj4+PiArIGNsb25lLmRlc3Rfb2Zm
c2V0ID0gc2VnX29mZjsNCj4+PiArDQo+Pj4gKyAvKiBjaGVja3MgZm9yIEVvRiBhbmQgZml4IHVw
IGNsb25lICovDQo+Pj4gKyBzdG9wID0gZGVmcmFnX2Nsb25lX2VvZigmY2xvbmUpOw0KPj4+ICsg
Z2V0dGltZW9mZGF5KCZ0X2Nsb25lLCBOVUxMKTsNCj4+PiArIHJldCA9IGlvY3RsKHNjcmF0Y2hf
ZmQsIEZJQ0xPTkVSQU5HRSwgJmNsb25lKTsNCj4+IA0KPj4gSG0sIHNob3VsZCB0aGUgdG9wLWxl
dmVsIGRlZnJhZ19mIGZ1bmN0aW9uIGNoZWNrIGluIHRoZQ0KPj4gZmlsZXRhYmxlW2ldLmZzZ2Vv
bSBzdHJ1Y3R1cmUgdGhhdCB0aGUgZnMgc3VwcG9ydHMgcmVmbGluaz8NCj4gDQo+IFllcywgZ29v
ZCB0byBrbm93Lg0KDQpJdCBzZWVtcyB0aGF0IHhmc19mc29wX2dlb20gZG9lc27igJl0IGtub3cg
YWJvdXQgcmVmbGluaz8NCg0KVGhhbmtzLA0KV2VuZ2FuZyANCg0KPiANCj4+IA0KPj4+ICsgaWYg
KHJldCAhPSAwKSB7DQo+Pj4gKyBmcHJpbnRmKHN0ZGVyciwgIkZJQ0xPTkVSQU5HRSBmYWlsZWQg
JXNcbiIsDQo+Pj4gKyBzdHJlcnJvcihlcnJubykpOw0KPj4gDQo+PiBNaWdodCBiZSB1c2VmdWwg
dG8gaW5jbHVkZSB0aGUgZmlsZV9wYXRoIGluIHRoZSBlcnJvciBtZXNzYWdlOg0KPj4gDQo+PiAv
b3B0L2E6IEZJQ0xPTkVSQU5HRSBmYWlsZWQgU29mdHdhcmUgY2F1c2VkIGNvbm5lY3Rpb24gYWJv
cnQNCj4+IA0KPj4gKG1heWJlIGFsc28gcHV0IGEgc2VtaWNvbG9uIGJlZm9yZSB0aGUgc3RyZXJy
b3IgbWVzc2FnZT8pDQo+IA0KPiBPSy4NCj4gDQo+PiANCj4+PiArIGJyZWFrOw0KPj4+ICsgfQ0K
Pj4+ICsNCj4+PiArIC8qIGZvciB0aW1lIHN0YXRzICovDQo+Pj4gKyB0aW1lX2RlbHRhID0gZ2V0
X3RpbWVfZGVsdGFfdXMoJnRfY2xvbmUsICZ0X3Vuc2hhcmUpOw0KPj4+ICsgaWYgKHRpbWVfZGVs
dGEgPiBtYXhfY2xvbmVfdXMpDQo+Pj4gKyBtYXhfY2xvbmVfdXMgPSB0aW1lX2RlbHRhOw0KPj4+
ICsNCj4+PiArIC8qIGZvciBkZWZyYWcgc3RhdHMgKi8NCj4+PiArIG5yX2V4dF9kZWZyYWcgKz0g
c2VnbWVudC5kc19ucjsNCj4+PiArDQo+Pj4gKyAvKg0KPj4+ICsgICogRm9yIHRoZSBzaGFyZWQg
cmFuZ2UgdG8gYmUgdW5zaGFyZWQgdmlhIGEgY29weS1vbi13cml0ZQ0KPj4+ICsgICogb3BlcmF0
aW9uIGluIHRoZSBmaWxlIHRvIGJlIGRlZnJhZ2dlZC4gVGhpcyBjYXVzZXMgdGhlDQo+Pj4gKyAg
KiBmaWxlIG5lZWRpbmcgdG8gYmUgZGVmcmFnZ2VkIHRvIGhhdmUgbmV3IGV4dGVudHMgYWxsb2Nh
dGVkDQo+Pj4gKyAgKiBhbmQgdGhlIGRhdGEgdG8gYmUgY29waWVkIG92ZXIgYW5kIHdyaXR0ZW4g
b3V0Lg0KPj4+ICsgICovDQo+Pj4gKyByZXQgPSBmYWxsb2NhdGUoZGVmcmFnX2ZkLCBGQUxMT0Nf
RkxfVU5TSEFSRV9SQU5HRSwgc2VnX29mZiwNCj4+PiArIHNlZ19zaXplKTsNCj4+PiArIGlmIChy
ZXQgIT0gMCkgew0KPj4+ICsgZnByaW50ZihzdGRlcnIsICJVTlNIQVJFX1JBTkdFIGZhaWxlZCAl
c1xuIiwNCj4+PiArIHN0cmVycm9yKGVycm5vKSk7DQo+Pj4gKyBicmVhazsNCj4+PiArIH0NCj4+
PiArDQo+Pj4gKyAvKiBmb3IgdGltZSBzdGF0cyAqLw0KPj4+ICsgdGltZV9kZWx0YSA9IGdldF90
aW1lX2RlbHRhX3VzKCZ0X3Vuc2hhcmUsICZ0X3B1bmNoX2hvbGUpOw0KPj4+ICsgaWYgKHRpbWVf
ZGVsdGEgPiBtYXhfdW5zaGFyZV91cykNCj4+PiArIG1heF91bnNoYXJlX3VzID0gdGltZV9kZWx0
YTsNCj4+PiArDQo+Pj4gKyAvKg0KPj4+ICsgICogUHVuY2ggb3V0IHRoZSBvcmlnaW5hbCBleHRl
bnRzIHdlIHNoYXJlZCB0byB0aGUNCj4+PiArICAqIHNjcmF0Y2ggZmlsZSBzbyB0aGV5IGFyZSBy
ZXR1cm5lZCB0byBmcmVlIHNwYWNlLg0KPj4+ICsgICovDQo+Pj4gKyByZXQgPSBmYWxsb2NhdGUo
c2NyYXRjaF9mZCwNCj4+PiArIEZBTExPQ19GTF9QVU5DSF9IT0xFfEZBTExPQ19GTF9LRUVQX1NJ
WkUsIHNlZ19vZmYsDQo+Pj4gKyBzZWdfc2l6ZSk7DQo+PiANCj4+IEluZGVudGF0aW9uIGhlcmUg
KHR3byB0YWJzIGZvciBhIGNvbnRpbnVhdGlvbikuICANCj4gDQo+IE9LLg0KPiANCj4+IE9yIGp1
c3QgZnRydW5jYXRlDQo+PiBzY3JhdGNoX2ZkIHRvIHplcm8gYnl0ZXM/ICBJIHRoaW5rIHlvdSBo
YXZlIHRvIGRvIHRoYXQgZm9yIHRoZSBFT0Ygc3R1ZmYNCj4+IHRvIHdvcmssIHJpZ2h0Pw0KPj4g
DQo+IA0KPiBJ4oCZZCB0cnVuY2F0ZSB0aGUgVU5TSEFSRSByYW5nZSBvbmx5IGluIHRoZSBsb29w
Lg0KPiBFT0Ygc3R1ZmYgd291bGQgYmUgdHJ1bmNhdGVkIG9uIChPX1RNUEZJTEUpIGZpbGUgY2xv
c2UuDQo+IFRoZSBFT0Ygc3R1ZmYgd291bGQgYmUgdXNlZCBmb3IgYW5vdGhlciBwdXJwb3NlLCBz
ZWUgDQo+IFtQQVRDSCA2LzldIHNwYWNlbWFuL2RlZnJhZzogd29ya2Fyb3VuZCBrZXJuZWwNCj4g
DQo+IFRoYW5rcywNCj4gV2VuZ2FuZw0KPiANCj4+IC0tRA0KPj4gDQo+Pj4gKyBpZiAocmV0ICE9
IDApIHsNCj4+PiArIGZwcmludGYoc3RkZXJyLCAiUFVOQ0hfSE9MRSBmYWlsZWQgJXNcbiIsDQo+
Pj4gKyBzdHJlcnJvcihlcnJubykpOw0KPj4+ICsgYnJlYWs7DQo+Pj4gKyB9DQo+Pj4gKw0KPj4+
ICsgLyogZm9yIGRlZnJhZyBzdGF0cyAqLw0KPj4+ICsgbnJfc2VnX2RlZnJhZyArPSAxOw0KPj4+
ICsNCj4+PiArIC8qIGZvciB0aW1lIHN0YXRzICovDQo+Pj4gKyB0aW1lX2RlbHRhID0gZ2V0X3Rp
bWVfZGVsdGFfdXMoJnRfcHVuY2hfaG9sZSwgJnRfY2xvbmUpOw0KPj4+ICsgaWYgKHRpbWVfZGVs
dGEgPiBtYXhfcHVuY2hfdXMpDQo+Pj4gKyBtYXhfcHVuY2hfdXMgPSB0aW1lX2RlbHRhOw0KPj4+
ICsNCj4+PiArIGlmIChzdG9wKQ0KPj4+ICsgYnJlYWs7DQo+Pj4gfSB3aGlsZSAodHJ1ZSk7DQo+
Pj4gb3V0Og0KPj4+IGlmIChzY3JhdGNoX2ZkICE9IC0xKSB7DQo+Pj4gLS0gDQo+Pj4gMi4zOS4z
IChBcHBsZSBHaXQtMTQ2KQ0KDQoNCg==
