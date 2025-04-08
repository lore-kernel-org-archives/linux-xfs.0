Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AEB225779;
	Tue,  8 Apr 2025 20:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744145056; cv=fail; b=WtWjANXkzeR4o8VECP6KiSLvESSyhKcByZr5/oVySxGmJON5sytb8i9dCR9ugT6LDlscFlZpp15dj4+L/ewkP6PnpD0xJKkvwZ0LzDT6QSELi1l9hCzhTiZK38yS36wjGPhrIEkKNcbOz9QL/J3u1dzibop+kwXSAdS5AVAgtyQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744145056; c=relaxed/simple;
	bh=y/93XPWMQ9GKKEz2RcmiSc5Es3fY7wf/JrnAc1bUcpk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=p6iUaBXKpVkUvGOEZH00sVXnGcL5iAMKzxngyaVOXVdpGJZl+4Osia3q7P3bBhXOohtCmXl63+CdnGRjcUABPlEAmEAg2hijtsi4CoXRf41buAN3IPdlKxdf9kxiaJugc9IauXd3XMMxWsw4oJSxrlepCfdMocOHA5JRXx4wlAE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cXA225Mc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iBRMKFqx; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cXA225Mc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iBRMKFqx"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 538IC1Rs001584;
	Tue, 8 Apr 2025 20:44:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=y/93XPWMQ9GKKEz2RcmiSc5Es3fY7wf/JrnAc1bUcpk=; b=
	cXA225McpseTZ0ODSLPT7NIFXlGQShuCbLfIENgSVEurhY3HFrvSlRmkLYmqY2bN
	/rrceQiAynAyr0VtKrJ13Wx5uccYewt2tgaau5vfUHaWNXVkD+HwqwLS69J1CMHW
	/CP1yd+sV0mT87jJRGcNQh4TrMC4k5w9XNdbBfIWtQ3D46r4jBAm07HWaoXC2Gz1
	gYKEqN2qGGZrKbq6X1xOCqxHJxw9CnasvV4wadSRw+vZ/MBvNxRMRdNX2fXQtBrT
	2XFz18LllLKVXGR1MaTuYGj2BVWyIZ5UElNaW/KihfAys9wzezgnVQTaVZl9v/SU
	7jj6Yw+X7pdJKcyxP9Hoig==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45tv4swtdp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Apr 2025 20:44:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 538KDHc8023844;
	Tue, 8 Apr 2025 20:44:11 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2046.outbound.protection.outlook.com [104.47.55.46])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45ttyg5jbn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Apr 2025 20:44:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qH+ZfAxwUoCxkNQjmnWKH+Zx/TEbK5uDOXVHvhpR8La4UtygQ82eSlNLmEtnAhb8onDrJSYqXh+j1kSLOiaLJvLHLzm9Hx3Jm6ladHhlz/xfAwXSdBZpwjM3EVTdUgFtKH2sK0ofRfyTWJI9gDV0hz4zpDlDHVmaA2FpmI1zPoi0Eik2kdgL4hdQTkPjWU2AEIh8jB1T8rw6DVNdiqSxMjtkxo/jAj09KlR2kSQg0/pxc48QK2lm/DiZl7z3EQri39cBemTBxaFnP814UkaNHs8eEjkYM2+eyH4FJVpX4xcJGFbljIYJU4IpR39txBLQU0IzoOR3uMCeUuNiesarSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y/93XPWMQ9GKKEz2RcmiSc5Es3fY7wf/JrnAc1bUcpk=;
 b=KomCOondTHoPPyhdhGtmT28/WwrEuNDEGzT8IPBARZwnkv4s35WKq1i6OyyTHurqjF5Mf/Ympo0xanZR9XDpAyWdYaqg1Tjnog3nOzwxl3jFVWTgmoFt5JLh7qYM3J8/gcCfkUrWryYGIuHE6wU+/vGrGNMFpYFlLwdOnsEILL1P6aFDr2qJLGeivNt11d++u63PE7RZAuUWs6AVaxLsxN47gAB6AHQJnSmZ0rNrbUKWJUWiKsSC51T1HgEb/Ez5DjLC6AmOhlvex+ktI7oSCPuAhUAEkpgUcQkL6jmPfgrvLjUvEh0gb+t+3U6a65X3V6XV8o37bnZ8gSjKET6KEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y/93XPWMQ9GKKEz2RcmiSc5Es3fY7wf/JrnAc1bUcpk=;
 b=iBRMKFqxeSnPUWu4mjGQNA/CXuYVUtHIOZKnhBJEfmsFROEXcXJEI40ty1loRZAIKYU4deAZfuhauceCE4cR4LhFycl8HO8RwXFyUU6hIOIV6KlFyd8IG5/mWEhfQTCorg76m/1j/3a1hI6ZUF/rtvKFRtpSOWc40uS0PAO13y4=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM6PR10MB4203.namprd10.prod.outlook.com (2603:10b6:5:219::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.28; Tue, 8 Apr
 2025 20:44:07 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8606.033; Tue, 8 Apr 2025
 20:44:07 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: John Garry <john.g.garry@oracle.com>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>
Subject: Re: [PATCH v4] generic: add a test for atomic writes
Thread-Topic: [PATCH v4] generic: add a test for atomic writes
Thread-Index: AQHbqFwr1dNTqmVkDEeDmZ6AtRVZGLOZ9MAAgABIbAA=
Date: Tue, 8 Apr 2025 20:44:07 +0000
Message-ID: <383FA3E5-B8EF-4636-9F3B-658FBF82A242@oracle.com>
References: <20250408075933.32541-1-catherine.hoang@oracle.com>
 <feaabfc0-1fe3-445a-8816-c72d52132ed2@oracle.com>
In-Reply-To: <feaabfc0-1fe3-445a-8816-c72d52132ed2@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.200.121)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR10MB5316:EE_|DM6PR10MB4203:EE_
x-ms-office365-filtering-correlation-id: 751a2552-d46b-4361-1a5b-08dd76de1bab
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|10070799003|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?UEdoUUw0NDRtNXN5dVZLYk9qMkU0QTB6SmxpU2tQTUhsTjNnWm55MXdDdnEv?=
 =?utf-8?B?Sk9LajZDTkNWSlJyUHpKU2o5UENRUUJDYmJValc4NEprZVNqVTdQdFRxSWhO?=
 =?utf-8?B?cmhBbW90NUxlUE5SYUVwK1FVcEZIM0VEdER3dkFGMGtJK09nelM2NWEyUWhB?=
 =?utf-8?B?MFAyUTR4dWFhazJkV1FMYW4wNHRreTdkRG5NOWhoMlNlU1pWamhpdWtMSVNr?=
 =?utf-8?B?VnM1aHFQaEM5alM2ei85U0lLVUJENllwdW96TUpCdHhoTGo3cm1MQ1ZqRmpy?=
 =?utf-8?B?TlVpMENaZjd5WThiOTd0K3d4bkc1MlV0SXpEV0VrSHhtQS9BOEZFYWpTKzh3?=
 =?utf-8?B?NkhnVE1IR2JBN1RxNVY5QjA1dUwxM3pTNkNqM3E0bFg1Zk0wSk9OQ2VNQ2NR?=
 =?utf-8?B?NWpjZklWSjZpLzFLdnc3d09BbldXc2FXVU1vQTNzK3J3M2Y2QVN2MldHWGJD?=
 =?utf-8?B?a3RBazZqODFtdXFPYUREZXA0Q0wvanNiUWx1c2ZUeFNzcDVSZmorZ0dsc1JZ?=
 =?utf-8?B?QzZCdUJQYVA5MTBDaG5zSmoxT0lyaUNTS2hYTG9hc2lZSzdyK1ZucmZpR200?=
 =?utf-8?B?TnhuaExwMldpcitEOWp6cWlicnUzV0hvY3d2b1JPN0orMzZRRTRNckM3c2k5?=
 =?utf-8?B?b1Rac3A2d1VOOTB3VXVpRThwNU5HK1ZtUlc2Y0ppRTV6RFg2UG5qZFVxdWhN?=
 =?utf-8?B?TU5RVFk0Nnk2NXhQc3QvcTB1ZHU1TTJnc0RQQXowbnpTRXZTamZIMVRNdzYr?=
 =?utf-8?B?bXoyTURLUVdIWklIRU56cWh4ZjF0UVlQOVNyYTR6UzlTc2hvNHdNS3FrZm52?=
 =?utf-8?B?aTVpTVE5aVJGVDdRQ3RxNWNKTzhzb0pnMmZTeldHbUJlbCtEUXJ1aWVYME5O?=
 =?utf-8?B?MHE3YVZLaGRlZ3ROWVpkWFJXMWZORGNsb2FNRG02aWs3akdiaStBZ1M2NnIz?=
 =?utf-8?B?NmdBUjIzY1BvamlSQmdoUHJMUFkvTmNGSTlmemh0MzcraGJFTjNhQzVKY2RU?=
 =?utf-8?B?RGRPY1E4UUtSa0Z2bVl5V0RWUXlnVytXREtvb2dhL09uRFI4OXdkL2sxM1lj?=
 =?utf-8?B?ZlM5YlpWZTFjMzlPaSsrQVJOZXBURVhvaGRtbTllTWhSNjM3SzZnK3V5bzdP?=
 =?utf-8?B?K3Y0TFhnZkNvNk5hb0Y4aTVHcUlNRUdkd0FJbitmZlcyUERqdVd0b0VDQkxh?=
 =?utf-8?B?dnlScDYxYVhLZU4yM3ZpN0MrcWdEU1JuOWUyNTBpYU93eWdEcjgzUXlsdW84?=
 =?utf-8?B?eHBsUnVzT1gvMVhLdzVIVDNtRUFCdzR2Y0pFZ3N0LzhoS0I4TXF1cmhxV1JG?=
 =?utf-8?B?NzZBdzBuZEpKWUhDZWxDd0dkVk53TkhJYlZlYXNMRG1SZER6RE5uZ1JzamRn?=
 =?utf-8?B?eTlvNjF1VDlUL2FNaFRZaVQ2Y0N6b2JaSFZyNXYvVWxlNVNUUWJ4dmR6UXVp?=
 =?utf-8?B?SFJyMDlvZ1BpTjhZcFdlSFhiQXJOL1NsK0FsKzZzVytFRHh3QS8xOVhrNEho?=
 =?utf-8?B?Qk4yempYdzlPTTc0TTFsVzhQaVc4Mnk1bTY1RzVyWlh4N0IwS2taMjNscFU1?=
 =?utf-8?B?bm1xcXVGc2lvenRQcVlhQkIrTFYzWVJVTWxobTl4K3dUL1RCNmpiaVd0VGJC?=
 =?utf-8?B?WFUwWXQxNXd5algzQ085QTUwNFEzR040RHNVNGYvL1Rrbmx6ckwwcEhFOWNH?=
 =?utf-8?B?a1BNS0hvMG1DNlBhMGdROVk3b2huUjZzdFhkQjkxc0wreWl4Tkl5aEwwMGVT?=
 =?utf-8?B?MlNVN0h0dm40SHY3alhoQW03dFAvYmJyNGpXY3k1cEhHUWNSYkt1a1N2MzJh?=
 =?utf-8?B?YTg0NDhGU0llU0E3Tm1QNjFnNDJTVi9FcnpiMHBBd3BweUVrRUMyYXAwSDJR?=
 =?utf-8?B?enp6VFR6MTJXTzlXY05OTFNaV0g4bHBSOGcyUC9iaUdETFE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NW9Gd2dIc2gya0xCY1pjWFk2dVpCWVlXTGYvTks2WFNPcG5mQjQzWmNqRlpX?=
 =?utf-8?B?VkVjRlVSbnloZmkxMytTN080NXJPUlpGNkpkeFNPK0JCZXJIWGpHYXZLaXpQ?=
 =?utf-8?B?bm9xSXdGQWtHUHJxQnhYclB3dmhOMUc2dkI0Q1J0dzdoaURJRGVRQ0hRVXZS?=
 =?utf-8?B?d1JMeS8zL3hyTDQyUmgyUjZ2dTBKTGQ5QU5sVnBZSHBYcnZ4Qmc0eHd0NTA2?=
 =?utf-8?B?TGR0NDM5d25SVnVBcHJjVGdQYjlaanY3MUowejRiT3o2bjkvMjk4SVpXMng1?=
 =?utf-8?B?ejJISjI2eENGUFlpZ0RrL1k1anpFRFJvYmorczNIc0wxT1dGNjdYWVBCOWUr?=
 =?utf-8?B?dlpMczNKQVFQZy8vQythZ3A2TEFsaWs5WGFTS3hhR2VXbXZVdWNIZHR2ZlB0?=
 =?utf-8?B?aXFhS05KZW1Qbm5tMEg5YzJScWY3dllzNkZRMFpSM0pzL1FraEF4d1o3T1k1?=
 =?utf-8?B?Z1p0S3l4ak5ZK3c0NVo3cXd0YXc3ZEZaMDh3bDNnRmxSY2hPU2RoMVhkTFdW?=
 =?utf-8?B?NllxZGpLSHJISEl1dzdzQk9XMXc2ejJjaTVoamVYMjdtUUsvUFNldHdtaWhs?=
 =?utf-8?B?NHpoN0ZuZkJrcFIzcE5JeDVxbXYyNG9mK0pJUUJQUm1ReElCR1RzNTZJMitn?=
 =?utf-8?B?V3FxYUorR2NOaXBZMUV0WVhXS3lQMGpyQjdPYjYzTTJEK3RyOU44VjNvTjht?=
 =?utf-8?B?eGJzRnl3YWRtUUZpbHZiZ0lrMTJtSlUzL1NQOUJwZUEvcldMcFIzL1NmVG1V?=
 =?utf-8?B?cjVGNnp5THBNMHZ5Vm5wYmQ4M2N2bDRGeTVUeWJablYxbmZ5dE1QdklBWWlP?=
 =?utf-8?B?U1pFWWdYUGI5dXdhUjdXUXpVMThzSXg2aWNUQ2R1UWtKUzlGRU9Vd3J6K3dy?=
 =?utf-8?B?UjhXY0RvVWZkYXFvZ2kxdDJwbjVCN0htVTJ3NkRUUHBmd0xCMnVKSzFubW1k?=
 =?utf-8?B?YkJyTEcvanozNER4eG9vT2YzN0pkc3dKeU1zMjFwK09nUUF3ZFRvK09yRlg1?=
 =?utf-8?B?RmovMXJ4djdtQ3NjaUdFNU9tVk1kamtjQ2QyT0V1OVduN3M0OG52NWJ6MFht?=
 =?utf-8?B?VzlYSHRwRHRXNkpxNDVqd0pWRVplM1FiaysrRlhTZm9jQ2xNbjVIcmFxUXhu?=
 =?utf-8?B?WjVvNUpXL1BucHlEQWZkZEZqRUhseHNsZGpYb1lrU1QxSkJseHI2bjFML3g3?=
 =?utf-8?B?QklJRytkNDlXOGlFU2Zvd21UdEowYlNwZXdoK3RhUnNOdmJvTTRiZGx4QUtj?=
 =?utf-8?B?WTB6OU5HcUYxbThnOWJYV1haaVU0ajU3MGFVbWJaaG4yUGZmQ2h6UWl4ckpo?=
 =?utf-8?B?YVhJbWMxdTNiaTZhV3hiOEFZbDJMWjVQUUk4UEtKUnJONDZ1NGo5MXNRNU9h?=
 =?utf-8?B?bUk3TnhSVERndmpXQ0RvbmkwYTkwWDB4VUlRYXB6K3lrSk9PZkZLNVlTd3JK?=
 =?utf-8?B?MVdSeWZWN2hQT0ZZUWViS2RyU1A3NVYrZloyWG9zUXBTenprNzg5bHV6MExC?=
 =?utf-8?B?N0dSN2kxeU9mZUxwakQwT1d4UHpraGd4VnlwWXF3aVkzV3lZcU5WOHNYZHBy?=
 =?utf-8?B?UkFBRVdGTnZQRW8vb0E3bmQ0cUlvLzNxS0t2K0dPaUFLbDRTT2pYUXVFdmVH?=
 =?utf-8?B?N1poa1JEYWNidUwwWjFaOHhjejBwUHcyWk10TlRaaXYxNGtoNENSWnFQeG9y?=
 =?utf-8?B?bFVaU3BXYWhUNXNXTGV2L2pvc2pqSjVmcjllYUJsUnJqbmRHK051dFN0STB6?=
 =?utf-8?B?dTg0TTFiTUZXYkx4STdYdGFmOXc1dEdGTTNDQ1g2NVZyd0NXcjc3TlJaRUph?=
 =?utf-8?B?dVpCZEdzcXZKTWp1YXFJNTBOMHg1TVNxR1ZOem03TnZDZFNhZHVmTUU5R0h3?=
 =?utf-8?B?N1ZHcGhoK2FLQm9HeG5VMDJVWHFkblo0OHhQNHNHMGVteTFHQmlGM3FDZW9K?=
 =?utf-8?B?RzFwaVJlaytaeHpVUWxyTHpNdzgyNkJIbnJqTjdtMzd6YmZxU3Q4SWJTUGps?=
 =?utf-8?B?NWx5L25Vay9ocjJKemxpOWhkRG9zcGNVZVZtQnM3dTFxNUZsN3o4dW1TLzRV?=
 =?utf-8?B?K0FCVTh0azcxWVhncHNGTDlwbktoaDBsbExOWDFDbU05SS92Y1M2NjQyUCt4?=
 =?utf-8?B?Qm5KTUR5bDk4UFBxMDQ3UVVYU0JvMUtkOHlheFhvQnhCenpIQUJGaC9YN2xV?=
 =?utf-8?B?djA1TXg3OXRYRkdZWExjRnVXdDdQMDlTZThYd2U3ZS9jMHNKam9xTlNHaGFF?=
 =?utf-8?B?OUJPUm9LaDFBWGhHY0dBbkE0eDVRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <53F562E082505943AD9AC5D317545BD9@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZCCO7is5GA64Vh7Qe8xIfhQzx2MWPWkkR2lGe+AJ+C/eBIza9r6FGmiQTq7jh6Enft96Nk5HpqhppQuocLyA7JBnmyCV/56cHKaFyb8K+bo2mqkJ2wymYMhQsvKsB7XSUMmbk6UG4D1QabchxPZBukkvRI0bKlzTjV/IHX0ViqlYT09S+iBapGNGgEfrYG9goE9UqrckaIKm3CDNomecE80IkKmA0rgA5mlUjBV0ccL8PvzC2JafDWUC2rDaxuBoqnd98k0T1OkWB6cRDZ6aoyHmjAXwd9iNk2+4l4gdzmnpnVQPOwds74XxQSNcJNSZMPmb7uBhLlFQnA4/2rnrrYQpe02rdcYzBB2EIyvTZKw8je4U0YEB4GgQFffO0WLEzhqnDHo+274EvWP2kMHkIiJDLjq71QSZa1VreD3Xs27MMf6USfRhfJVRiGDmBXPUqxEWi594p6YbvChjAL8NxWX5yGWLyes+kWOb/Ig6Gdvliffu+9A6E0Cl38ETvElIu2ZlWF4TBv45BLgDe3e/6zySAy1h6P+g4FhIZ46A/Hyr/xgvRDnaia7i5av6IEQ4jNxpAR15dgfUNhP2NVTjZqW6r+eyWxxuL5OfqfiU0Bk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 751a2552-d46b-4361-1a5b-08dd76de1bab
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2025 20:44:07.5452
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dMfI93p6tCK1PYCcviESGIwdWAAGkLnumfJSwAw0Ga1OZUjEGRvGBV8WWr2v/cZ0LmRPsAViRuVbEEolgjSsdboOEXn3+QxG1WYZ2NExDSE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4203
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-08_08,2025-04-08_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504080144
X-Proofpoint-ORIG-GUID: aU2CzVJujFpOKJu_om0ry6Xn4ZE7I7TP
X-Proofpoint-GUID: aU2CzVJujFpOKJu_om0ry6Xn4ZE7I7TP

PiBPbiBBcHIgOCwgMjAyNSwgYXQgOToyNOKAr0FNLCBKb2huIEdhcnJ5IDxqb2huLmcuZ2FycnlA
b3JhY2xlLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiAwOC8wNC8yMDI1IDA4OjU5LCBDYXRoZXJpbmUg
SG9hbmcgd3JvdGU6DQo+PiBBZGQgYSB0ZXN0IHRvIHZhbGlkYXRlIHRoZSBuZXcgYXRvbWljIHdy
aXRlcyBmZWF0dXJlLg0KPj4gU2lnbmVkLW9mZi1ieTogQ2F0aGVyaW5lIEhvYW5nPGNhdGhlcmlu
ZS5ob2FuZ0BvcmFjbGUuY29tPg0KPj4gUmV2aWV3ZWQtYnk6IE5pcmpoYXIgUm95IChJQk0pPG5p
cmpoYXIucm95Lmxpc3RzQGdtYWlsLmNvbT4NCj4gDQo+IFBsZWFzZSBzZWUgY29tbWVudCBiZWxv
dywgYnV0IHRoaXMgc2VlbXMgb2sgYXBhcnQgZnJvbSB0aGF0Og0KPiANCj4gUmV2aWV3ZWQtYnk6
IEpvaG4gR2FycnkgPGpvaG4uZy5nYXJyeUBvcmFjbGUuY29tPg0KDQpUaGFua3MhDQo+IA0KPj4g
LS0tDQo+PiAgY29tbW9uL3JjICAgICAgICAgICAgIHwgIDUxICsrKysrKysrKysrKysNCj4+ICB0
ZXN0cy9nZW5lcmljLzc2NSAgICAgfCAxNzIgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrDQo+PiAgdGVzdHMvZ2VuZXJpYy83NjUub3V0IHwgICAyICsNCj4+ICAzIGZp
bGVzIGNoYW5nZWQsIDIyNSBpbnNlcnRpb25zKCspDQo+PiAgY3JlYXRlIG1vZGUgMTAwNzU1IHRl
c3RzL2dlbmVyaWMvNzY1DQo+PiAgY3JlYXRlIG1vZGUgMTAwNjQ0IHRlc3RzL2dlbmVyaWMvNzY1
Lm91dA0KPj4gZGlmZiAtLWdpdCBhL2NvbW1vbi9yYyBiL2NvbW1vbi9yYw0KPj4gaW5kZXggMTZk
NjI3ZTEuLjI1ZTZhMWY3IDEwMDY0NA0KPiANCj4gDQo+IA0KPj4gK30NCj4+ICsNCj4+ICtzeXNf
bWluX3dyaXRlPSQoY2F0ICIvc3lzL2Jsb2NrLyQoX3Nob3J0X2RldiAkU0NSQVRDSF9ERVYpL3F1
ZXVlL2F0b21pY193cml0ZV91bml0X21pbl9ieXRlcyIpDQo+PiArc3lzX21heF93cml0ZT0kKGNh
dCAiL3N5cy9ibG9jay8kKF9zaG9ydF9kZXYgJFNDUkFUQ0hfREVWKS9xdWV1ZS9hdG9taWNfd3Jp
dGVfdW5pdF9tYXhfYnl0ZXMiKQ0KPj4gKw0KPj4gK2JkZXZfbWluX3dyaXRlPSQoX2dldF9hdG9t
aWNfd3JpdGVfdW5pdF9taW4gJFNDUkFUQ0hfREVWKQ0KPj4gK2JkZXZfbWF4X3dyaXRlPSQoX2dl
dF9hdG9taWNfd3JpdGVfdW5pdF9tYXggJFNDUkFUQ0hfREVWKQ0KPj4gKw0KPj4gK2lmIFsgIiRz
eXNfbWluX3dyaXRlIiAtbmUgIiRiZGV2X21pbl93cml0ZSIgXTsgdGhlbg0KPj4gKyAgICBlY2hv
ICJiZGV2IG1pbiB3cml0ZSAhPSBzeXMgbWluIHdyaXRlIg0KPj4gK2ZpDQo+PiAraWYgWyAiJHN5
c19tYXhfd3JpdGUiIC1uZSAiJGJkZXZfbWF4X3dyaXRlIiBdOyB0aGVuDQo+PiArICAgIGVjaG8g
ImJkZXYgbWF4IHdyaXRlICE9IHN5cyBtYXggd3JpdGUiDQo+IA0KPiBOb3RlOiBmb3IgbGFyZ2Ug
YXRvbWljIHdyaXRlcyBhY2NvcmRpbmcgdG8gWzBdLCB0aGVzZSBtYXkgbm90IGJlIHRoZSBzYW1l
LiBJIGFtIG5vdCBzdXJlIGhvdyB0aGlzIHdpbGwgYWZmZWN0IHlvdXIgdGVzdC4NCj4gDQo+IFsw
XSBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC14ZnMvMjAyNTA0MDgxMDQyMDkuMTg1MjAz
Ni0xLWpvaG4uZy5nYXJyeUBvcmFjbGUuY29tL1QvI20zNzQ5MzNkOTM2OTcwODJmOTI2NzUxNWY4
MDc5MzBkNzc0Yzg2MzRiDQoNCk9rLCBJIGNhbiByZW1vdmUgdGhpcyB3aGVuIGxhcmdlIGF0b21p
YyB3cml0ZXMgZ2V0cyBtZXJnZWQgKHVubGVzcyB5b3UgdGhpbmsNCml0IHNob3VsZCBiZSByZW1v
dmVkIG5vdz8pDQo+IA0KPj4gK2ZpDQo+PiArDQo+PiArIyBUZXN0IGFsbCBzdXBwb3J0ZWQgYmxv
Y2sgc2l6ZXMgYmV0d2VlbiBiZGV2IG1pbiBhbmQgbWF4DQo+PiArZm9yICgoYnNpemU9JGJkZXZf
bWluX3dyaXRlOyBic2l6ZTw9YmRldl9tYXhfd3JpdGU7IGJzaXplKj0yKSk7IGRvDQo+PiArICAg
ICAgICB0ZXN0X2F0b21pY193cml0ZXMgJGJzaXplDQo+PiArZG9uZTsNCj4+ICsNCj4+ICsjIENo
ZWNrIHRoYXQgYXRvbWljIHdyaXRlIGZhaWxzIGlmIGJzaXplIDwgYmRldiBtaW4gb3IgYnNpemUg
PiBiZGV2IG1heA0KPj4gK3Rlc3RfYXRvbWljX3dyaXRlX2JvdW5kcyAkKChiZGV2X21pbl93cml0
ZSAvIDIpKQ0KPj4gK3Rlc3RfYXRvbWljX3dyaXRlX2JvdW5kcyAkKChiZGV2X21heF93cml0ZSAq
IDIpKQ0KPj4gKw0KPj4gKyMgc3VjY2VzcywgYWxsIGRvbmUNCj4+ICtlY2hvIFNpbGVuY2UgaXMg
Z29sZGVuDQo+PiArc3RhdHVzPTANCj4+ICtleGl0DQo+PiBkaWZmIC0tZ2l0IGEvdGVzdHMvZ2Vu
ZXJpYy83NjUub3V0IGIvdGVzdHMvZ2VuZXJpYy83NjUub3V0DQo+PiBuZXcgZmlsZSBtb2RlIDEw
MDY0NA0KPj4gaW5kZXggMDAwMDAwMDAuLjM5YzI1NGFlDQo+PiAtLS0gL2Rldi9udWxsDQo+PiAr
KysgYi90ZXN0cy9nZW5lcmljLzc2NS5vdXQNCj4+IEBAIC0wLDAgKzEsMiBAQA0KPj4gK1FBIG91
dHB1dCBjcmVhdGVkIGJ5IDc2NQ0KPj4gK1NpbGVuY2UgaXMgZ29sZGVuDQo+PiAtLSAyLjM0LjEN
Cg0KDQo=
