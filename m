Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475CE56B76
	for <linux-xfs@vger.kernel.org>; Thu,  2 May 2024 10:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714644555; cv=fail; b=GN7DI6/7F50wjGXEyDfA75qcOVLKxhPy7qtaGHpVs/0LYq/IU168NEGBdjfey/L56o4uTNEQJot49hp/7aNigjxyYffV3+MWZ24qFEyMYkrHHcA0QrjGtdTfej68Oqq4teBAVy5CIdxz5sONgHy6q+gHZY6dzIbq9FDeCCIzdsU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714644555; c=relaxed/simple;
	bh=iGPeF0x+unKGgxam9nG7wSNkKRWmOtBlrJGvm7vbqmE=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=IWuwV9vW+Ka6QbBA7AbFs0Q2ApwD0SxtUome04yWQRYP9waWulvqt29u4HPkHgQX6dBKyo42fhhNAsYJnvt+vN11xazqw6fT5LTQqNH/dRCaJRgsSnDcSH8B1eGP7Os1chS1tWQgCqRNXmH07ybghsqeCxcdyjauzSizl5oO8rw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=h0Z2H2b5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ihHf94p6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h0Z2H2b5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ihHf94p6"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44283vkX030861;
	Thu, 2 May 2024 10:09:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2023-11-20;
 bh=ovQTCyutKKVUfT6UqOE5SIWn6G04j4C+CmhEOLCir5s=;
 b=h0Z2H2b5T43JAqrDvcTxl0z9eo/MMsbl/N9b7GZMzY//z24ZxH/2cr16FxBhIhWzW6JO
 Dy2v1EpQedz269EmezbpcchexyjetCOmvg+YTx7k1wLLyyhTPEYT3f6K+zKAQVU4no57
 8H/E4aCIHw5MsYQcwxhu9URJv47DwUxvUIHS1cmBKlT5HZdWSbhb+LurYXGAucE+9PtA
 z1F2khpMTL3YGYoQTPjRF81a4bkgAx8/4TQP2gOpLCK+0hM+zohauKKSDb6kTM76Ir6t
 dOVtDL6hbwwbcpEOnTS5xdTQtiIPdbybvofiL+pY60GSBHGKwzGRe0D9KtGHZ5hP1kD6 ZA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrr54ny2u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 May 2024 10:09:06 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4428oBtr006039;
	Thu, 2 May 2024 10:09:00 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqtapc71-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 May 2024 10:09:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KRhwOyARNbDZaZrjKCcnKUQhcTbzQaKHrtu8cYK5RFxx3i/KHfh9G+qAFNbVWbsI6/LZFrJkU3ypmlA3zK+SuHgPhkulVMZ8sE9j6KM8Y2/Z3WzrB2dv49IoeCIkW1Ga5E1A0c1nMpdO68cx2hKE1RfjTFiZ/OP7ZcgqFM98mh+TswGRyW7vnFrjQlNKTrPNmfpHM5RjbpTJAfoj6ncBer6bmW0kl75a1e4EHVL8Q9FLa/JdKcjGUb8S+yW1Va2qomYmpsLqrOFBDX2+dskPVNOp8YwmVm9O/qUscx6bKiUSXMiftE8Gl1yq5bpqiSgXj64Hu5VfS+JqEJXCtcKM0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ovQTCyutKKVUfT6UqOE5SIWn6G04j4C+CmhEOLCir5s=;
 b=XE1pleZnkJWLZYMvQUdaHdNF8nqHg/M/gC6PCxNcyk+ldhZi1lZmyBbBIxzaq2X9oHl3woWwk+TxI071003WA4Hd8L75q4IiemnslJMEDa5NT7AA4ZDZBGocsjd71e6nOiaHMevVrgxJYCvsE8urcOOz+vXNXYrslcbEukU8pKEpUrAo02kEr5IflfT3Bgf5QEROa6eakeQL830WB49GDpsqeywyJo9/6VXLtup33sdY5ADgw3P2tXp1QtKWrgf7FFrURw/+bs2W6ZfPT8aelqLcZeK6yFGy2LtIkUTNMxwQojsCPp85Gq5XveFkP9tTjs6Q8PNSqqMY/kOL4MwG2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ovQTCyutKKVUfT6UqOE5SIWn6G04j4C+CmhEOLCir5s=;
 b=ihHf94p6+xVb9dhxT5SLJfH4nsnnOdXl7WSFdgfYIBJNoiTQyXVCMrtTLJ+L/q3BB5WPDHtB+C8XfrU1YDcah3QhRX6mErMO7OGHhBnXOSZFTyGNyvWzpPpJwSZ4pBmpCQfThrTYr6NMONQc5L+W6O3T3HPWaVJ1bE2UCfqQzZk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW5PR10MB5737.namprd10.prod.outlook.com (2603:10b6:303:190::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.40; Thu, 2 May
 2024 10:08:57 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7544.029; Thu, 2 May 2024
 10:08:57 +0000
From: John Garry <john.g.garry@oracle.com>
To: chandan.babu@oracle.com, dchinner@redhat.com, djwong@kernel.org,
        hch@lst.de
Cc: linux-xfs@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 0/2] xfs: Clear a W=1 warning and some __maybe_unused usage
Date: Thu,  2 May 2024 10:08:24 +0000
Message-Id: <20240502100826.3033916-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0120.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::36) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW5PR10MB5737:EE_
X-MS-Office365-Filtering-Correlation-Id: 466dd8ba-f312-4567-a8d0-08dc6a8fe162
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?dVdpUWVjSDZJY3JNMEl0WjhWTnJiK0RESTdtcVZSNTVobVBjRGZvMXpQSStI?=
 =?utf-8?B?eU5jNk9DKzVqOEt6ZEw1WllxcjlNVG5RVnprcys3cG1mak1HQWJUZFptSnVB?=
 =?utf-8?B?QVFjNkJMa1BKWXhQY0lqdTZ5cmFYaGtmL0QrT3UreHYxMDJ0N1F1c1ZuMjF3?=
 =?utf-8?B?ZkNaajNvbTVPUzNDMDhnazhFb3huTDZNVTB3UDZyTS81ZDNBTFl3VnRhaHRC?=
 =?utf-8?B?T3dnL3NSK2hOemw3a3A0TXlQYWZ1c0Q2eGJLSGV3eTN5V0EwaDdkRXJqcnBi?=
 =?utf-8?B?cG54ODVGN0dXRnRNNDQzaW9ENEhLUjh3akRIYkh4TGVCeXYyekZMRUxYV3BP?=
 =?utf-8?B?aGlHTzFBWHh5WjFLOEtnNFFQR09hY3YxVlF3YUgvM2RHdGZxMjJ3Y2Q5ZUI1?=
 =?utf-8?B?dWU0MkduK1FCbDdUS1Ryc2U4eE5OS1NwZExQMWxhUjBiVyswVmtFSE5mKyt6?=
 =?utf-8?B?ZXFSOXNZVEtwb1N1TDY2S3Bud2I4WWR4aUg3MVJac1lFQitneVBGcHZCNnd1?=
 =?utf-8?B?U3VOMmhTbDIrb0ozT0dLcGRac01WaGJXSDFQRXJyU1F0TTlHYnY4T1BoWWpH?=
 =?utf-8?B?YTBYeGtqWUdOemxGN0hrWTkyV0M0V2FNWWs1RnVsZXplWFV6citPOTNMd2RR?=
 =?utf-8?B?REpnd2Z3QTQ5NVJmeG42eW1SWHphKzBRdEl1Nm1XejFGcWdLN1ZjRlNrSWdu?=
 =?utf-8?B?RU1JUWRpNEpkYXBWZkRZY2ROUDVaR3hTdzVucU5jdklIcnVvZ21tckoxSG42?=
 =?utf-8?B?Vk5sVUp4NFVzYjF2TUMxWTNTMGtwS1pRUEQ0WVBRSUxuK0dwRkREVkozNnJM?=
 =?utf-8?B?SFNEUEJNcDdtb3dIelRkWnFpV2hteE02dTBSKzdwYTArQVkxNFVKWVVCV1Vj?=
 =?utf-8?B?MVB1dm5oa1VNdnVseXE0ZGliU2dYcVdLbWJMRUtPRXg5UzhseUllTGxJdTVj?=
 =?utf-8?B?ZjJORmJFSU5kSGRpU0FHTjdRdm5YQmhhaXhHLzJMMW8wZXBNbllwTE9zSUsr?=
 =?utf-8?B?WWRTVGJGcDdBQnBVemRadVgxZnpnS0F1VVUrSm5HMzJCSWRhbis0WVBxNU5O?=
 =?utf-8?B?VnVwbjJPbjBlOE91YkVqOUN6S2NCbGx0L3cxSVJSbndZQThhVXBSWlljQkdH?=
 =?utf-8?B?ZGk0T3FiMDY3MSt0ZDBteUhTWGFabTRkUG56Q2V6Z2dlcFJ5N01LSlpiWkJT?=
 =?utf-8?B?M3VtbjVQR293dEx4WjFGaXIyRW9RbEhKclhLQmxwdXFJU2F2ZFNlNGl2ZFRB?=
 =?utf-8?B?Z1JTMjNhRUdqZlUzQkl1OHoyZ2VwUVgzQkRnQWlIdy8rUkR2MmxwWEx5WmpI?=
 =?utf-8?B?UVU2ZURFUlY2QTNSdWNqbisya3pWMFExMFh0MlZ2OUQyV3pMNy83WXBxY1hZ?=
 =?utf-8?B?WUNvSS84QjZDOWh2SHAyRkFPNURVV3pTaVVaZkFvUzJzNUp0YzJxUEF3R29W?=
 =?utf-8?B?STYvSFRONEo4V05aQ0hGTFFHMGYyWmJoRndLbG5mQ3dwUEhEMHBLeHZrcXpO?=
 =?utf-8?B?VWd5R2g4TXN6WHl3Mms4YnRwZEZGbUQvTGdrNTBEWEhaQW5tUGYrRjhweGIw?=
 =?utf-8?B?STEydnVDd3FCZXVNZnJyTWhrS1BsRERNSnpzSkZ5d1Z5ZytsdmNra0lYci9l?=
 =?utf-8?B?YVNUOTVzY1hRU09FdTU0QXNGOU5mN1h5QzduTEJYbjJMMjJhVjJMVUFFcTNm?=
 =?utf-8?B?YktweVRsRDZ4SkZacjZ6bnNwd2c4WTBzUEZJWnpRa0JES0QyeXR3WWlBPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ek9Vd0x2WloxTnQ4dWV1NkV5OVBXQlJVb1p2SEJ5NVgzR2FUQlJNSlJCLzdT?=
 =?utf-8?B?MzhrYkY3OTNnaEJlTWhwd2dqRGZMdTZESk1DTmFobmxpbnVtMy9STHZQcUdM?=
 =?utf-8?B?YzFDOWV2aElBd2tjMUkxbElGWTBsb1doN0VFaUZhSG9jUlR1ZUJDUEdITW1r?=
 =?utf-8?B?Z0x5cmdLV2lUNkxkaEhKNHk4SERpSzd5NWlNY0RSL3ZoVHRsWVN6MGpQU2kx?=
 =?utf-8?B?T2cwS1FXS1h3a3QxKzJIalVQcHBXa1M1ZStXd0duREZPVG94a3lhcDJ0Ymkv?=
 =?utf-8?B?NkhPMnB4dHZNMWtQeGFqelhtTnFRc0tlMklZV3VHTWMvd2U5dDNxRGYvcEpL?=
 =?utf-8?B?U0pkTlZ5VEQ0bnNXN1J3WUNGU3VSeWVkUktZNERka0F5S2d5L0p4VDZRb1Ra?=
 =?utf-8?B?TDMwNWJsSUxJU3UwQlZYdHdhelRCd28vb0I0enJOUTlOUGFuTGo0UmxOM2o3?=
 =?utf-8?B?VmkwUk5KTzExcC9NZ0hFeVZKQXJzcjUvejZUME5idm5kTVMrMllyUjFsZ25D?=
 =?utf-8?B?QnAwT1lJWStNRzVjYkZUMmhqUUt5ZVBRMGZDQWxEbnR4WnVRUFd6WHlkSGlO?=
 =?utf-8?B?eU9hU3ljMEtpQXVpcjF2b0NwTDBBakVMbWFSUHZkaGRydGZ1SHp6bzBpckpw?=
 =?utf-8?B?emViRndXU2V6dThYcmg1UkVmMTZYTER4RSttRThFa1J4TlBOMFJVeFdCdkFQ?=
 =?utf-8?B?Tk94M1pTcUFyL1NjY0hEbDBRL2RBZmNGUzQwYVFPNkNYYjhLOXJ3b0h2RU9j?=
 =?utf-8?B?TGU1TTVtaWsxVzhEaUtoSkhWcmZWL05zbE04R1E1VzJROWgwS3AzbHZZQUNN?=
 =?utf-8?B?OFljc3NJSTY0U2tpaDJVdGRsamJvanFaVVZCWlcxTnRsb1paemUwWUxvL0NK?=
 =?utf-8?B?RkRIVXBQSCtJYzlXVmYrd3d6RTFmdXZLNUpDSTFHM3E0d2UrL2pLZ1pnZ1hJ?=
 =?utf-8?B?eE4wM0M2K2xQQmM0RmIvbzJJOE9KbmdMUnF4TkRZbmlFNURpZlUrQXM2cnhm?=
 =?utf-8?B?dE1NRFdqUjhNdG9BSXFhQzhpUEZ3WVVLYUtRREU4djlROGkrNlU1Ti9QOTBV?=
 =?utf-8?B?T1JKZm40Wld1bnkyV3YxOEFudTh1UjQ1UzVrTjBMK0pTR0lSajZWcVBvdlpq?=
 =?utf-8?B?Rk9rUzh1MkYwT0I2UDVISXQ4NnRMaGRCWUVZZjJBV2k4Tlg5UkZKUElQcEJE?=
 =?utf-8?B?cThlaWl0YWFYY28wVHNSUjVHbGJMeVBOeG1sVEduV1lwT3MxQ2JJSFVOT3RB?=
 =?utf-8?B?eUoxNjgzSWtEKzdSQmZmd2VKMWx2UlNVSFhWRTR0aXZrSjFGYy9XUWZxTGVZ?=
 =?utf-8?B?aWFHWFFJODFTbGt4aGIrVVluWEhHbm1ZYXNYVWFVN3E5UjdBTCswQXJBZmlL?=
 =?utf-8?B?OURweWJhQkdXWi94dE9ZMU5UNkQ1bUJZQjcraERYWnNmZjluVlk2Q3V3ZVVW?=
 =?utf-8?B?VEh1aUJ5SHJ4Ykd0NE5NNmNHTGpJQWF6WnBCTFUxdVlya1ZyOWIyZEJENkRu?=
 =?utf-8?B?Nm5laXhScU9VMyt3ZTlhUHlnclhiZlNhclFka2g4aDk4STYzMisxOFBDL056?=
 =?utf-8?B?V2VLZ2ZQeTlxNHhBTjlIbkMwNnVMR0VBT3VVd3NHMmhDWFVJaXBVaUFhc2Ry?=
 =?utf-8?B?WklSYVNiN3FyTnV1S3lpeDJKVlBEalgrNWVaK2dRNVMyYVJta2FiWDNWYUQ1?=
 =?utf-8?B?QTFoN3cwY1NGMVZMMUR1LzJqalI0Vk9vNFRBRFRwczVRamZPaitkZzdab1dT?=
 =?utf-8?B?MG1ZSTc4MEtmUFY3UzRzWmZYT0JJNlYzN0YwQTZHcU1KYU44NVNTcDVkN1Bq?=
 =?utf-8?B?SUdwdXpYTDhJSUR3cmVOZ2Y4QURodWwxbkF5N25keGhsQXc1TEdjVWVTd3Zi?=
 =?utf-8?B?bFBjWU0wcnBXYVBBVnRlTVF0MVFyVkI1Nk1aa3lyOTZqa0hUV1lXek9PUzdQ?=
 =?utf-8?B?S1BWVi8rN1pJQVZHTnVJNDRadk1YQzFQYVdvc21haWZveFJJeWViV1J1R1po?=
 =?utf-8?B?emdrbU9MQ29uemJQODNhU3FyUzNxRFVwclE5OExPaDJuYU83LzdKNlgxYU5E?=
 =?utf-8?B?UlMvTDQ5TERyYmgyREZGV0svT01reDdaVVJFbkh2QzlOZWlYaDBHOTArbGhn?=
 =?utf-8?B?aWlSTVB1UlJtRUFpejEwdVkzcUJxVXI2d2R5d3NQeTcyeVVCcEhJUnQxMGxM?=
 =?utf-8?B?Qnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	rAqu7eJtLAgvL8act0F8x7HfrBeNndWU5efjQ8V/YJN5mE3KrsfijI6n0aWexKsZhmzXY3nHGuwyU04LeiLw76QGCOHy7qvddCNso9DdYtUhMLWuLChtNlxsqT68ikr0OFm8S7WqBXyVoXiawGx9egOGyHw+gjNJANoxN00OhCaHfHhPTBFf0QBzmLhPuy7LuYshdd1aIVcO4fYfqXh0fxatEJhyxaZfySYDF80PNm0KNHL4CNM5abnu5lRDlj4CuBE773ZDDtZ3+3n5jqaCP3PK+hlHmFF9M8P/BJHxSrwt1B+V/SwCOPE0o8VZfs+tVt65HEQqnFJoxYxdJ0Mj7URCvXkLmajnUGQG8uJBUlvkTw9KLJTCCJyDqUtWUy7CqJpRaIFB5oI1FVIQf65egoibjymZHXpyq9vXWhdiGdpII9EN+G554C7htf1rB5vE7AOQQYYZ0M0P+u2wHDu5NIN4b1eD5GAwbhJTa5mlpv6FZV9jFMeHS+z1/3NOlh82tS8uAI7TWRSgym3+yV4h9a/fU2i2T/SooP2nyssboi4yc8Uvzh1ZcxiJrvbBWcQLO9ekKSG8Jycsf6FkMdMBd9I7EGMZB4SBzTZ0xNs/1Js=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 466dd8ba-f312-4567-a8d0-08dc6a8fe162
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2024 10:08:57.4739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lGSv2NQ1tL+jwF23e4mZAioRBzvtTZ5wz/0NxUOQN5pyxzLzopDnABaXTM+o7a45pC86gAG95bdbE4e6BzL8Jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5737
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-01_16,2024-05-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=815 malwarescore=0
 adultscore=0 mlxscore=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405020063
X-Proofpoint-ORIG-GUID: 1uVFgv8XWXRF00r-3-XiPLWFJBro7VT2
X-Proofpoint-GUID: 1uVFgv8XWXRF00r-3-XiPLWFJBro7VT2

For configs XFS_DEBUG and XFS_WARN disabled, for a W=1 build
xfs_iwalk_run_callbacks() generates a warning for unused variable. Clean
that up.

Also remove __maybe_unused usage in xfs_alloc.c, which is for protecting
against the same type of warning.

John Garry (2):
  xfs: Clear W=1 warning in xfs_iwalk_run_callbacks()
  xfs: Stop using __maybe_unused in xfs_alloc.c

 fs/xfs/libxfs/xfs_alloc.c | 6 ++----
 fs/xfs/xfs_iwalk.c        | 5 ++---
 2 files changed, 4 insertions(+), 7 deletions(-)

-- 
2.31.1

