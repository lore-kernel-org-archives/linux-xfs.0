Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410F31DA4E;
	Wed, 14 May 2025 23:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747266171; cv=fail; b=sussJ+f+Z7Dg6KPOZUdKDenfOouyLsKmZNHIE2bpgSn4RoWwKOLO435Zy0wot9DujelkOzuBRx7GoZtqc1D2GlR7jr+QAUEvV3DA7iILSBJ1lkSjJKBJdtsuMNf8s+7JVaVF8G5Du7Qkm/StOI+9o4Al/RlFO+Pj72eRydogfvw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747266171; c=relaxed/simple;
	bh=Bd6m9MYImvCdOmslKaZfMUUzOgdYDPOHohg90FkQDQs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RR5bVYDKICpfIQDAje2fzBQCyNNAPZeURkLg4WeHrhqAtlkSqj+iCflNdZZ36aSrm8kPlh3WTBBgnKlyD5fcZrdICUDyROqSE+N6Haq9GLisZdH/FKO2KxBbTzWUH0tYTrIAnVWH3xH4lkt4ZrA8D1O5Eb3lzMHlvmGvMvp+kYE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HNVLPFTU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YfiHOq1/; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HNVLPFTU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YfiHOq1/"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54EJHLD5020605;
	Wed, 14 May 2025 23:42:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Bd6m9MYImvCdOmslKaZfMUUzOgdYDPOHohg90FkQDQs=; b=
	HNVLPFTUnJm9uHC3NugMPpoiWzlKlbr2fe54KAC4J+nGDSYIeic6aMJCyLgMKfUR
	E7XvwX3U7u3bB5mbvvaRNERPX6iXSQQWx5C2gD+Y4HBM2/mVU/56uBAwwexPM010
	jx1jaXN2iKmTzaXfulWF2EsRWTotoIlG/3DUT4mfCFtHuIsSEPLW6bHkjF0lz8A0
	xU1uqmBpBBJI4zFUjYNyb+Xwkk6AKQRtkwZnjQPUZiuiNNKMr+eUoHh9rc7XYVGe
	QIZnkDQ4m3t6VlHjfRb+iWj75kwKxneKDXBFg7frAvmUTiyfqiL+42X/QQkQqmnE
	yHW25NvmarGs+8mdyeogpg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbccu162-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 23:42:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54EN0KlE005110;
	Wed, 14 May 2025 23:42:44 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2040.outbound.protection.outlook.com [104.47.70.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46mshjuxd5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 23:42:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LPXYmWU3faX/SioTTaWJx3O7C9Nvbru8htx7/GveLSmMbEXn/I8Uqcq4b/inu4FOBsW7TtDtVileQ/vyde+OrYRP/X+6VcpjdTqzNmfQddOK1S9Mgm2sBMJ6o7zkILoTjimgJOkydwJt0DS4jOhxI4vR2ZAeCJBHjA6U5xNuGc7lOHgOLkTF4kFtLCMloVTtwCVBpa/+zJLr8WZ65xD0DL5Y7cDpfmK6fKk+o/KOgEnXxgNnYY3ySVFq/03MpUvCZgVdc9xulcyR3PU+d5RhBJWW+dN+tGXt6fkcT6cOG16Hhrjcl0OmOW9BSIk/aAsrICJSjrAFC2WSGx4iMQ/W6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bd6m9MYImvCdOmslKaZfMUUzOgdYDPOHohg90FkQDQs=;
 b=ib17k5UGI94yJ0QAHzpy2avulWDwHPNcTBJAmWSN2jrNqU0Dh//tWLXYia2JdtjHHsJ+AI8jZZXDagkNOVibZC59mOcwOXnaWDRRJhgeEoWT7JO6xqFMiBi3xQvK0NdFAe2Q5NR4MDIqdnfyvreLM2UB9gVcw449v2b2yv6JZclSot/Yhtc4d9HSoaFEnlfYoMqUrpFUM7JObK/rkAEoNZrZSBcx2Ndd7gTyI5QT9utdEZtfijymK49IZwE7JpHTuKRBdlr54aW3NCzgeyHvPJzVxSK0KYuUeuUrcONlM9ykAuMKLjNL7RMDskSsGmF8dO9PNXyg1F8xzBAS1HPoaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bd6m9MYImvCdOmslKaZfMUUzOgdYDPOHohg90FkQDQs=;
 b=YfiHOq1/sjXuIYucVYs3z5jJOHtbjhkI2z96WWK1gBbzs4LG3DdT+Uforu6+IwYCv7uMB7RXg3VAsOxLi1RGp81q2arbrBvgdohAJjqjrqyRDiKDCLxgH6we0Wnkm6cBsVqcVhiSC9nxs/nZChOhzn5cCF0UdUFsmIwAwEPRLyM=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH7PR10MB6275.namprd10.prod.outlook.com (2603:10b6:510:211::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.31; Wed, 14 May
 2025 23:42:40 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8699.019; Wed, 14 May 2025
 23:42:40 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: John Garry <john.g.garry@oracle.com>,
        "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>,
        "fstests@vger.kernel.org"
	<fstests@vger.kernel.org>
Subject: Re: [PATCH 1/6] generic/765: fix a few issues
Thread-Topic: [PATCH 1/6] generic/765: fix a few issues
Thread-Index: AQHbxGc7lNZgNJBHoU2TWBD/rJyz+rPSE9oAgAAvvICAAIdSAA==
Date: Wed, 14 May 2025 23:42:40 +0000
Message-ID: <D599CC99-C8C3-4BF9-908B-B115ACA565A4@oracle.com>
References: <20250514002915.13794-1-catherine.hoang@oracle.com>
 <20250514002915.13794-2-catherine.hoang@oracle.com>
 <52fc32f8-c518-434f-ae29-2e72238e7296@oracle.com>
 <20250514153811.GU25667@frogsfrogsfrogs>
In-Reply-To: <20250514153811.GU25667@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.500.181.1.5)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR10MB5316:EE_|PH7PR10MB6275:EE_
x-ms-office365-filtering-correlation-id: 82e08e6a-772f-476f-d325-08dd93410407
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?eDFRVlRIYnFvaXJudXM4cEFXNldhSS9xZG1mUERJWWJTMjAweFNTTC9UclZG?=
 =?utf-8?B?blJNNjdxZk9EUTNhWUFDUWlTVjFBcUJsUDBKclNwQzY1OW4xQlpIRTRiaHND?=
 =?utf-8?B?bUxRMTc3c3VxTXA2VjJEU2NjSXBWQllidERhK1gvQS9oZ3JBaW0xSGdtYmhY?=
 =?utf-8?B?MG1WU252YWdqY0hYWWtyTG1XUUdRSHBTVWRjbW5XNHJmNVBXc1ZJUE1nQThp?=
 =?utf-8?B?VENnK1VWOUxKRGo5VTJDS1BSL1JaUHpzZXR6Vk5TdnlzaWxDL3A3ekIxaUsx?=
 =?utf-8?B?aFlpbnIvdmtWRzVnV0hpOVA0Q0duMUE3WDV2a1ZxSS9qMWUzWlIzekVWRXRO?=
 =?utf-8?B?YUthNWNzSEExUGIwUDJjZ2Zrdzd5dmRIb0NoQWM4WCszUW9pakFkVW8wWEIr?=
 =?utf-8?B?UklnZEtYdU1BNDZ1OHVCc3cxZkRiZCswdGJ5RmNxTGxLNThrOSt5Vk1sSDZ4?=
 =?utf-8?B?Vm05NzMyY0ZHWitEUnMrYnVoY2xjYWs3a1F6QzFVQmllTTBJbWJiZTA4UWZa?=
 =?utf-8?B?dlR3RXo1d054L1k5ZGlBeldlRGNyNGliMVVNMnFmZGp4d05jUjByTFBVRjhW?=
 =?utf-8?B?WDRKSE5FV1Z5dVM5NisxRG0wYkxMMFNPekwwa2JDaG9aSXVWR3RFaFhrL0tt?=
 =?utf-8?B?c0xudE5WdkpJYSsvVXlaVExIMUFHaTgxaTVEc1U5VXZkL3VLbnh4SUpsdUVr?=
 =?utf-8?B?QVlIYm1XdlYra05Tb0EvWXhmc0FYNGo3SHpHMENybVFpTXY5YWxQSk1aVzlY?=
 =?utf-8?B?UWxSZ2RWSmFzY1QrWXNscGxjc3QrK2lyREZRRGFQcVJCMCt3QXVibHB1RXNJ?=
 =?utf-8?B?eDJxbklYMkNMQTkycGptbjAvSGg4OU5GZUpEYTRTQ0d3eWJQUzFvaCtCbW55?=
 =?utf-8?B?NFZ4WGlwMndOcEtBMjdsblNKNjFrdzJRZm52VEErS3I0bXhIazZLVzBUNXVl?=
 =?utf-8?B?L1RBQzlDb0dxUHFjOVgrTUpZVUZEdlF4TmYvcTkxakx4YitXWjdtT0RjL1Nq?=
 =?utf-8?B?YTl2QXRLeVIwelRhaGpPMVdLSUpHbW1aL2VOWlJxUUw2ZGtNZjVySlpCcmJY?=
 =?utf-8?B?OGp0WGJlSjVnZkh2WEdZYld5YVJmTVRLSnB4alZYanpYbWtNOTFveStBQzFj?=
 =?utf-8?B?bFZTOE05T25la1k2bGJwR0N0NWk0VHVpYjZuL0E5eC96U2tIUGFBRjVsRHpk?=
 =?utf-8?B?R1kzaXM1aUk3NDVxKzlrQ0hjSzVKeWR6NGlGMzZCb1VGVFZURVpEY3NGWXUz?=
 =?utf-8?B?OTdUVmpzQjNjSEtRNExyMWhvRU91dzc0eDVDem5vakw0SVBYSnZZekpnZWd6?=
 =?utf-8?B?QVNLaWtENUN6cHZkeW4wQVFxL1hqMUszZEV6TXVKUDZ5dWIyTEJERUN2N0pC?=
 =?utf-8?B?UXE4dGQ0aFBqcTlZQ2NnMkxnbEYza0hpa1RZSzFkSlM1cVFyZ0ZYaHZpeFFY?=
 =?utf-8?B?UWhndWtIY1Z6Z0c5N2ZGVFNHSUdad1dLUGRYUEM4MTJSUHNlbVJvUHBHd3Uy?=
 =?utf-8?B?NllSTVpQSEYyWnZkU05xUXNHR2grbmpocVpZVGNLVXRkb1MwckRSdFhqWGIw?=
 =?utf-8?B?ejBRRWtVYUcyRzZRQVh4YzB5aUpWazFlK1R6YzREV0pkK2kzd3YxRHdNeFBq?=
 =?utf-8?B?aUhyeGFNYzZNb3lxNjJicWFHRmZkNklrVUhjUXR6L1Q2dWhtMDZ6YkpmK0lG?=
 =?utf-8?B?KzdxU0xvdTFGQmdZVkJlMXFNZFFqQkVvWE5KUzZTZ3FtSXFIejg4RytBSkps?=
 =?utf-8?B?TXpqK0lTa0FBTHRhK1k1K0ZCVldDbWFKdHB6ajd2aHl2M0tKeHZnNkdsQjl1?=
 =?utf-8?B?MWNXcERjb0h2RmFLUzVkWkdrenBieFEyeG0xZ29yNVVrQldTWktjS1FYWldl?=
 =?utf-8?B?STlNZkk0bTY0ZHRwRXpUUFN6TWRTZk1RdlQ0aVp0eGh4NXR4eTU3a0llUGdD?=
 =?utf-8?B?NXNZYWVtUW51SzJ5MEJ1V1VvRTdFUldTS0tqNmtvS1AyQzlxSCtSRkFsU0pw?=
 =?utf-8?B?M2gzaVlJVkNRPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(10070799003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RUhkR3JBMVpmYTlBd0JoSkpIUDVoUERLbWJPNi9DdEhNQWo4Z1ltODVjRTUx?=
 =?utf-8?B?UXhFTldpaW5rWnY3d3RCNHMxbVJsc3hLamdxVkFab2FLa1hkd3RYOFQwV3F2?=
 =?utf-8?B?azFiK1Flc2M4VXhtVlBsSXdJRFFrU0NmcXRsNlhyZWRFWVlvRVJSVWhLVVBE?=
 =?utf-8?B?QU1iK0tDcjh0elRubUNwbFU2U0I5ZEJIcjdwV01OY2RTVHVzVHZ3UkFNdEQ2?=
 =?utf-8?B?VnlURTFGU2EwejBDb3pNcDVGS293a245Z1RYRTV0bzZJRFRnVG5maW9QSTc4?=
 =?utf-8?B?bnZvT1ZJN3hvcDRxN3p5aW84WEQ5WjRtOG0zcUdQZW9zOExqL2FQWXBWTnlZ?=
 =?utf-8?B?WVY0aDVrRGNpVjNKRWRVVzk1elJRWnBJVWV2UmhaUElTemZoYmx2TEJyMDk5?=
 =?utf-8?B?citmd2hNMzkxNzZjSHZ5RTIvOUdxSisxZUZqd2JJb2l6SGlob2ZxUU82eFpy?=
 =?utf-8?B?QmJSTkFaMDBsbW9paEFSVUVzc01NTDlLeDgydGI1MzdnUXJ5R3dyWGNrclF0?=
 =?utf-8?B?RkZLQ1R6b0haUFlROXNaOS9tdlFhUWZReE05bUc4cnFwelhSeVAzR095SzlE?=
 =?utf-8?B?Z1dtaXhFZ2U2Q2RhcG1VMUhvbHNxQWFDVFphbkczTEd3emtQV3JtcVRsOWtI?=
 =?utf-8?B?N2psSVhOODRyMVNlWkM0SHpNaDB1QlRHN2ZMSWg1cGtXR1NPWFczYVlMVE9H?=
 =?utf-8?B?clIwTHBqTHJhZkFEOGVRSlhPSmZ3L2pUNGs3dkFYQzhLb3BEaExuV2NPSE1S?=
 =?utf-8?B?Q1B1UCtNdHhWbGdQMWhlU0NNNSt2RmdXZUhJOVBjV09OUTZsZTBTY1h3NVNu?=
 =?utf-8?B?RDgyNWFPTjAvdGk4bnlDVlcvSUtNbmtqL0xwK1VrbUVZUVI4cFhXUktPK1JK?=
 =?utf-8?B?a0dzd0hYZGhPN1hBOWs5ZlVObllJS1BUYTVFN1BjOXVZN0NFa2NNSEpOU0lS?=
 =?utf-8?B?TG1SWmhzUm9XT1dLMGVPeENDUWdiWUhCQmpGLzlLem83eDNRSzRaNXRNdHE3?=
 =?utf-8?B?VGVvWmFOV000QzhrZlZiNGZ1R3RUdVFzQjA2Z2t1R2Q1WFlhMzBITnlZR1Q5?=
 =?utf-8?B?UDRnRnc2VEFDL2cyWTU5ZW5oaFBWc1JtNCtienZKblhHNTFUUWhhMkNheWhH?=
 =?utf-8?B?SjhmRVRXWlR2YU9ZMi9HSFNZWnBIV1EzdTVidkUwUUZoL20zYkp6RVh0Y0ZV?=
 =?utf-8?B?SGw4RVU3MmRzQkU1ZWlMZHNqVHZyaklKTW9HMXVZUExxeXpTZGtBUGJSVUhV?=
 =?utf-8?B?MXZ1QWU3VWdlS2x6Nm5mV2w5cGs1M0RtVmpUK3NDajZkQ1A5cXRLbEtKMVUy?=
 =?utf-8?B?dTdBaXpCYkwyOWx3Y1k1ak0vRlovMDdZeGo1OEVxNlhpeTM3ZXZxcGVBcTA1?=
 =?utf-8?B?SlcxQzJlaFN0T3VBOFVhc1BXRjBCTUszbWFteGVmMGIzaWR4bnhTMDF0MnJt?=
 =?utf-8?B?ZmM3SmZWK3duNWZJM3RZRG9ZUnZkbjZESDY3VXFkVFpoaUNzR0Z1SDZYS1pz?=
 =?utf-8?B?c0NDOEcxYzJ1RXBPWS9iUTBnVmwzTlBHRG9YSUlCa0UrZy9rRG5LNHFpbUs0?=
 =?utf-8?B?UlBsYkJ4OTBOWkZkSEJaVmQ5SHBVNG04ODJxazQ2SzBXRHZkY25za255Wkhi?=
 =?utf-8?B?akowNHhwSVI4QnZGbTl2N3dyWCs1RWVzZTVyZUR1YmtReVR4Zno4WWtoZ0Jm?=
 =?utf-8?B?NG1NVEdYQ3JhYmZZWURhb1dmdkF4RG9JQkhTOGlzVWEzNnVhdGp3M3hCY1kv?=
 =?utf-8?B?OEVmSzJnbDRmS1Z4N1FpaUUxc3R3L0JQZmMyWUpqd1RTRkZ2bWxCMWZlaGtK?=
 =?utf-8?B?Qkg0eWFtVGJQazFUQ2FaWlNtNWpyQ0YwclA3MmhJYlBvdlFZY2dyZFN1dTBU?=
 =?utf-8?B?dS8xUDhnZ2lVdy80dG9UazBGQTlHSlptc21ZeTE5SWI4QVd1a1FhRkFtZlZS?=
 =?utf-8?B?dlZKaHFQNGRXamtxU3VpTVBVb2VtV0FxSmZGVk1wTEsxcjZiU3J4R0tJbEJu?=
 =?utf-8?B?RTJOUGxnL2pMVFFUMFlzSFkrTUhuSmJtS3kyZ0FxMWROb1pSSlhyZkIrbldZ?=
 =?utf-8?B?bkwvN25YZjJXOWx5Rm9sYWozS3pmZjVwaThpblYxQVNXR3RMVjlKUlU2NnAr?=
 =?utf-8?B?dVBYUkk4UVR5RUZrOEdySmQ0YW1Ia1JsbUFodTZidGJGOXdVVUM1N3NqaUxq?=
 =?utf-8?B?SGswZ3hRR0NWMlJoa1lScUNkbTFqdnc0OENvQ3NYTG81OGNjdUlrVFU4ZmV3?=
 =?utf-8?Q?NZJMvRNiaO2jNCdWDrhPPvPQDTT/ZVcRVn7WEmVS84=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FFBA81EFAACA924F8FC3D33482DB9FF8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IJhKqQctROyILyeD8cdZc2h3oN/Uc0j5T2zHSBXkKTCoIWRzMFyGqjhtj2P7qEoxwM7khzxkkG/qJtIwe3qbeqs1ZdTaS7ub6nSmzMjQBtoRCnWhIHiuN4vE/7qd+1bZ35tas4C4VplKVAWJbdB+o/AzENEku5gnUsklWRH+Os/ahbryR1+ypF6amWoDy0sY6CpvHxeJpjVHZfMXIbYORArEHfK7If/a0KkdXuWBiARmiGPwRiZ59/R8G/NtThq3JBobAz+OZKRP2BknLVsjoS9m/5VURedqQBPeAtvya4n8nL+Lx/QIpdxtAWcDTjuiricfBvSRvnGsHHya73w5L//9rayEzHeUkVIxPEMv3YTKXg/uWHC8YgjCDkpAFeDnxpmAfTpb9DQldyukY+rGl6q2MPTkGj+FXyIMD7eovvnVkvOpp1EsbB3Jliylg+oCvb1g2XLtouACW5/PtgoMnWTKqWLCukjcZAhH4aBrWZnWQfM7U8weWByZjazE4LkGQ8DyMMjKvn5uOBXtzsG5e/t3nm6TifU/pqXVOizCPoeMSfIxhexUjSp32lHYgHdvStYFx9G3Cn2CuTmFzVvZNxnflJ+zmW7GFfHPs1LYUCg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82e08e6a-772f-476f-d325-08dd93410407
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2025 23:42:40.6166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y9D5PBFkte16AYv+aDsjcfs6HO4QzWDJ2Gsih7MON5bJJsXYTxNx2n4/cdnL+JHrIc7fkN+yCTiSC9hGPyiiVylt7iOe+1U/SkIlEJQQM/g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6275
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_04,2025-05-14_03,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505070000
 definitions=main-2505140220
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDIyMCBTYWx0ZWRfX5wghTf2Yi3BT PutpY19hGpb0oxLxPJuNgKgZ0AwL/rZYS4mq72C5EW3rePw5euFmc30LfAggkV+NSutumoy97Jb wNZ7T+oywAiczBL/8xw8m5ctWVMHulLLmj/WdLE1OWIllLBUU61jNOHcPJdq7yryjYONajHCrVe
 Xt0upr3/BkH+95koZZ/dTrxTVSQ00NP1V4ahget6NjH4OkSA+Db873hIGqq2yfL7EQNLamIUBP8 vivlsiN9Sn3Bo99G3R1xvxXbCEVDwGwB3YSc7fyMZimh+RQNjGicmEJXgxeLbjxllrC1fo7r8Wz Qy9CEXn8tJlVXdxspDs1aO/euZbtkWUYzRJ3dvrsnsYDWTj2M1vuIez14Fla7v6az/8/lDPsKZ8
 QkFBOQ+h3HuqRWz0jfue7lYjhG3p8QWgFUzagRy8hF+R35/1nTC5TGQaTMIR+01DOuvX2Fhx
X-Authority-Analysis: v=2.4 cv=Y+b4sgeN c=1 sm=1 tr=0 ts=68252a75 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=hHzQVcelVpfyPJDFL4MA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: msQGndYLDi3VYwDt6A_TpoItszOiqxXQ
X-Proofpoint-ORIG-GUID: msQGndYLDi3VYwDt6A_TpoItszOiqxXQ

PiBPbiBNYXkgMTQsIDIwMjUsIGF0IDg6MzjigK9BTSwgRGFycmljayBKLiBXb25nIDxkandvbmdA
a2VybmVsLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBXZWQsIE1heSAxNCwgMjAyNSBhdCAwMTo0Nzoy
MFBNICswMTAwLCBKb2huIEdhcnJ5IHdyb3RlOg0KPj4gT24gMTQvMDUvMjAyNSAwMToyOSwgQ2F0
aGVyaW5lIEhvYW5nIHdyb3RlOg0KPj4+IEZyb206ICJEYXJyaWNrIEouIFdvbmciIDxkandvbmdA
a2VybmVsLm9yZz4NCj4+PiANCj4+PiBGaXggYSBmZXcgYnVncyBpbiB0aGUgc2luZ2xlIGJsb2Nr
IGF0b21pYyB3cml0ZXMgdGVzdCwgc3VjaCBhcyByZXF1aXJpbmcNCj4+PiBkaXJlY3RpbywgdXNp
bmcgcGFnZSBzaXplIGZvciB0aGUgZXh0NCBtYXggYnNpemUsIGFuZCBtYWtpbmcgc3VyZSB3ZSBj
aGVjaw0KPj4+IHRoZSBtYXggYXRvbWljIHdyaXRlIHNpemUuDQo+Pj4gDQo+Pj4gQ2M6IHJpdGVz
aC5saXN0QGdtYWlsLmNvbQ0KPj4+IFNpZ25lZC1vZmYtYnk6IENhdGhlcmluZSBIb2FuZyA8Y2F0
aGVyaW5lLmhvYW5nQG9yYWNsZS5jb20+DQo+Pj4gUmV2aWV3ZWQtYnk6ICJEYXJyaWNrIEouIFdv
bmciIDxkandvbmdAa2VybmVsLm9yZz4NCj4+PiBTaWduZWQtb2ZmLWJ5OiAiRGFycmljayBKLiBX
b25nIiA8ZGp3b25nQGtlcm5lbC5vcmc+DQo+Pj4gLS0tDQo+Pj4gIGNvbW1vbi9yYyAgICAgICAg
IHwgMiArLQ0KPj4+ICB0ZXN0cy9nZW5lcmljLzc2NSB8IDQgKystLQ0KPj4+ICAyIGZpbGVzIGNo
YW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4+PiANCj4+PiBkaWZmIC0t
Z2l0IGEvY29tbW9uL3JjIGIvY29tbW9uL3JjDQo+Pj4gaW5kZXggNjU3NzcyZTcuLmJjOGRhYmM1
IDEwMDY0NA0KPj4+IC0tLSBhL2NvbW1vbi9yYw0KPj4+ICsrKyBiL2NvbW1vbi9yYw0KPj4+IEBA
IC0yOTg5LDcgKzI5ODksNyBAQCBfcmVxdWlyZV94ZnNfaW9fY29tbWFuZCgpDQo+Pj4gICBmaQ0K
Pj4+ICAgaWYgWyAiJHBhcmFtIiA9PSAiLUEiIF07IHRoZW4NCj4+PiAgIG9wdHMrPSIgLWQiDQo+
Pj4gLSBwd3JpdGVfb3B0cys9Ii1EIC1WIDEgLWIgNGsiDQo+Pj4gKyBwd3JpdGVfb3B0cys9Ii1k
IC1WIDEgLWIgNGsiDQo+PiANCj4+IGFjY29yZGluZyB0byB0aGUgZG9jdW1lbnRhdGlvbiBmb3Ig
LWIsIDQwOTYgaXMgdGhlIGRlZmF1bHQgKHNvIEkgZG9uJ3QgdGhpbmsNCj4+IHRoYXQgd2UgbmVl
ZCB0byBzZXQgaXQgZXhwbGljaXRseSkuIEJ1dCBpcyB0aGF0IGZsYWcgZXZlbiByZWxldmFudCB0
bw0KPj4gcHdyaXRldjI/DQo+IA0KPiBUaGUgZG9jdW1lbnRhdGlvbiBpcyB3cm9uZyAtLSBvbiBY
RlMgdGhlIGRlZmF1bHQgaXMgdGhlIGZzIGJsb2Nrc2l6ZS4NCj4gRXZlcnl3aGVyZSBlbHNlIGlz
IDRrLg0KPiANCj4+IEFuZCBzZXR0aW5nIC1kIGluIHB3cml0ZV9vcHRzIG1lYW5zIERJTyBmb3Ig
dGhlIGlucHV0IGZpbGUsIHJpZ2h0PyBJIGFtIG5vdA0KPj4gc3VyZSBpZiB0aGF0IGlzIHJlcXVp
cmVkLg0KPiANCj4gSXQncyBub3QgcmVxdWlyZWQsIEkgbWlzdG9vayB3aGVyZSB0aGF0ICItZCIg
Z29lcyAtLSAtZCBhcyBhbiBhcmd1bWVudA0KPiB0byB4ZnNfaW8gaXMgbmVjZXNzYXJ5LCBidXQg
LWQgYXMgYW4gYXJndW1lbnQgdG8gdGhlIHB3cml0ZSBzdWJjb21tYW5kDQo+IGlzIG5vdC4gIEl0
J3MgYWxzbyBiZW5pZ24gc2luY2Ugd2UgZG9uJ3QgcGFzcyAtaS4NCj4gDQo+IEN1cmlvdXNseSB0
aGUgdmVyc2lvbiBvZiB0aGlzIHBhdGNoIGluIG15IHRyZWUgZG9lc24ndCBoYXZlIHRoZSBleHRy
YQ0KPiAtZC4uLiBJIHdvbmRlciBpZiBJIG1hZGUgdGhhdCBjaGFuZ2UgYW5kIGZvcmdvdCB0byBz
ZW5kIGl0IG91dC4NCg0KSG1tLCBpdCBtaWdodCBoYXZlIGJlZW4gZnJvbSBhbiBvbGQgcGF0Y2gg
b24gbXkgYnJhbmNoDQp0aGF0IEkgZm9yZ290IHRvIHVwZGF0ZSB3aGVuIEkgc2VudCB0aGlzIG91
dC4gSnVzdCB0byBjbGFyaWZ5LA0KdGhpcyBzaG91bGQganVzdCBiZSANCg0KcHdyaXRlX29wdHMr
PSItViAxIC1iIDRr4oCdDQoNCnJpZ2h0Pw0KPiANCj4gLS1EDQo+IA0KPj4+ICAgZmkNCj4+PiAg
IHRlc3Rpbz1gJFhGU19JT19QUk9HIC1mICRvcHRzIC1jIFwNCj4+PiAgICAgICAgICAgInB3cml0
ZSAkcHdyaXRlX29wdHMgJHBhcmFtIDAgNGsiICR0ZXN0ZmlsZSAyPiYxYA0KPj4+IGRpZmYgLS1n
aXQgYS90ZXN0cy9nZW5lcmljLzc2NSBiL3Rlc3RzL2dlbmVyaWMvNzY1DQo+Pj4gaW5kZXggOWJh
YjNiOGEuLjg2OTVhMzA2IDEwMDc1NQ0KPj4+IC0tLSBhL3Rlc3RzL2dlbmVyaWMvNzY1DQo+Pj4g
KysrIGIvdGVzdHMvZ2VuZXJpYy83NjUNCj4+PiBAQCAtMjgsNyArMjgsNyBAQCBnZXRfc3VwcG9y
dGVkX2JzaXplKCkNCj4+PiAgICAgICAgICA7Ow0KPj4+ICAgICAgImV4dDQiKQ0KPj4+ICAgICAg
ICAgIG1pbl9ic2l6ZT0xMDI0DQo+Pj4gLSAgICAgICAgbWF4X2JzaXplPTQwOTYNCj4+PiArICAg
ICAgICBtYXhfYnNpemU9JChfZ2V0X3BhZ2Vfc2l6ZSkNCj4+IA0KPj4gbG9va3Mgb2sNCj4+IA0K
Pj4+ICAgICAgICAgIDs7DQo+Pj4gICAgICAqKQ0KPj4+ICAgICAgICAgIF9ub3RydW4gIiRGU1RZ
UCBkb2VzIG5vdCBzdXBwb3J0IGF0b21pYyB3cml0ZXMiDQo+Pj4gQEAgLTczLDcgKzczLDcgQEAg
dGVzdF9hdG9taWNfd3JpdGVzKCkNCj4+PiAgICAgICMgQ2hlY2sgdGhhdCBhdG9taWMgbWluL21h
eCA9IEZTIGJsb2NrIHNpemUNCj4+PiAgICAgIHRlc3QgJGZpbGVfbWluX3dyaXRlIC1lcSAkYnNp
emUgfHwgXA0KPj4+ICAgICAgICAgIGVjaG8gImF0b21pYyB3cml0ZSBtaW4gJGZpbGVfbWluX3dy
aXRlLCBzaG91bGQgYmUgZnMgYmxvY2sgc2l6ZSAkYnNpemUiDQo+Pj4gLSAgICB0ZXN0ICRmaWxl
X21pbl93cml0ZSAtZXEgJGJzaXplIHx8IFwNCj4+PiArICAgIHRlc3QgJGZpbGVfbWF4X3dyaXRl
IC1lcSAkYnNpemUgfHwgXA0KPj4gDQo+PiBsb29rcyBvaw0KPj4gDQo+Pj4gICAgICAgICAgZWNo
byAiYXRvbWljIHdyaXRlIG1heCAkZmlsZV9tYXhfd3JpdGUsIHNob3VsZCBiZSBmcyBibG9jayBz
aXplICRic2l6ZSINCj4+PiAgICAgIHRlc3QgJGZpbGVfbWF4X3NlZ21lbnRzIC1lcSAxIHx8IFwN
Cj4+PiAgICAgICAgICBlY2hvICJhdG9taWMgd3JpdGUgbWF4IHNlZ21lbnRzICRmaWxlX21heF9z
ZWdtZW50cywgc2hvdWxkIGJlIDEiDQo+PiANCj4+IA0KPj4gVGhhbmtzLA0KPj4gSm9obg0KDQoN
Cg==
