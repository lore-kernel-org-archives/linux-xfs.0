Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C02716DC06
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jul 2024 18:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721671279; cv=fail; b=G2dAkcMEYHqkQx81FZGYhJGpp/HefdvB6HjthX9GkHv/qG6btUFxGVcz6vjqfnKw3qe+q0WfPXgbIfPyaskJrsbTp09nmlFPRWaU9wLD+RuV+BkvQpRInVPsmhY90gHGQLTmkBidALVoSfEQvKq7P7usvltmt9sOmXF32msSoTE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721671279; c=relaxed/simple;
	bh=geZJYdtEs5f5/XYQwKc2ScCHMDOX8JLcqy+i/ednCRo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FA/qPwBfa5VRgItTWClRf978/f/QfQV3x+ESzw2kiJ0vIPxjKOasygwpV4Kn+ZMGH1zGgqQT4dvOk+2lt1dotQzL2p7S4XEovMOmEWJOIr0R1H7ed5E9/k1uk1bWDRgeSAItpyssjcYtZ+c0NFRadJPBkxJbyNL1X5bENvSFyLI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ecGA0b59; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kBpW4Upx; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ecGA0b59";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kBpW4Upx"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46MHMYkh014906;
	Mon, 22 Jul 2024 18:01:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=geZJYdtEs5f5/XYQwKc2ScCHMDOX8JLcqy+i/ednC
	Ro=; b=ecGA0b59Fp2BvLf2z/J/h2d7WeUE3p7Ymnl1gKNaCh28I4hZxkrjhbUE2
	l73Z4Jpn9XZCf7FBXH95VoTaN/4Hoftbr9XMWF7Q5luokvFjd4rP7WLenOKxvhZH
	ThdrTp+x+13uu2FCQ0sNpfqJEZF7Gk0qkWuvQ+C1TgQgfRb/iN2qMxQUB6wd5/M+
	1Xfm71JIuR2n/pSRiHNAi2QT3POzAkNoSTCyPRtjsYzh46VIKnDyizAWZM5BtX0d
	k6OpcKBJJk1p7eZGXwCAHRoI0Nr985HzfOb51Xp7HJFCVdmHdauIc1LqVF/xKIdA
	O1cv4frm6IHEPxp2hXXDa3C1Bh+KA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40hg10tqh7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Jul 2024 18:01:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46MHSJ9v040149;
	Mon, 22 Jul 2024 18:01:11 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40h26kb03g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Jul 2024 18:01:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LhpknnOGS/xeANb9qD+UDSLj6uTqzN5yY+UpQA+uMOXer2xuaaKcr/hLjAqxaalwRx4+Q89eRBv6ITgcdjMTFMh4q2DDa8UeiKSn95QDtmjtFvwPGQUl18S4R9Pgi3Xa33Jm0oICsyC4ujLlTQr5wtL5ovoilFAL6hQyLCLU6L/4MQr9NUcJMP+FUUPzFQC3Rn50sBxsmmxFf0R9uCs1R+RzPdGL1V9QfwXQ85QUMZ7F8SZp+7Iut22i/0OS/+HiZDI5QKrXchMeU1ytRvh+tIK5XJELbGJDgLtx2PDoavlSgbp5eY8hHq+4oPSXOzC6UHn2uuqBofkb17Bd7Mk1vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=geZJYdtEs5f5/XYQwKc2ScCHMDOX8JLcqy+i/ednCRo=;
 b=svaj8G9RhEYJ7N7x50ysKb0D7yd7f5Uaes6BtEInck+6Nj13tKgjpl+leP06vdZXqW0k3iYqDR6rSgLVuyfegdrzX+hWd+t+46HNfHmyqM++yBGTuXyArvoevHpWRvgtx1ZRJ6KACVSNG5sgIJuRLemR1IWAXH4cNo5MxrzRGkjG+BTZsuGB2rKUcGeNh5F8Mt5SHKh1yCBiEUhvrYYyeUGrBKeXHZWMOtwVQsXJKxOd9tnB8yiLud68mCEBZPJ0Rd1snJ0BZ37/gL20kaAupbZpLAOJE6k3GxrDQSmfMjPYrTIqmcY8qr8gA46mbp6H+ql38qZCssF9Vw2F5Q6aZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=geZJYdtEs5f5/XYQwKc2ScCHMDOX8JLcqy+i/ednCRo=;
 b=kBpW4Upx862aVysoeTyHzE/oMsHe2b0gDrjgVF4yb9SsPtQJ71ge1PQ4bIejDyNOLB9oj8e6KKHkjU3/S5Q+h7PFN3BmIQr0ODigdu+z+yGQCRlxRLwdipIrPfs3PZhfN1OuYbCWY9akZbolKxktAgTXXzYrW1i1uZZb5bdsHdU=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by CH3PR10MB7988.namprd10.prod.outlook.com (2603:10b6:610:1c2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.19; Mon, 22 Jul
 2024 18:01:08 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%4]) with mapi id 15.20.7784.017; Mon, 22 Jul 2024
 18:01:08 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: Dave Chinner <david@fromorbit.com>
CC: "Darrick J. Wong" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 9/9] spaceman/defrag: warn on extsize
Thread-Topic: [PATCH 9/9] spaceman/defrag: warn on extsize
Thread-Index: AQHa0jOwaQZbabfy90qdsexMqm2q3bHu1uCAgANa+ICABlgxgIAKk8IA
Date: Mon, 22 Jul 2024 18:01:08 +0000
Message-ID: <C635810C-9669-42F8-BD6F-48C15B1AEFD7@oracle.com>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-10-wen.gang.wang@oracle.com>
 <20240709202155.GS612460@frogsfrogsfrogs>
 <3DC06E8A-486F-44D3-8CEA-22554F7A5C7E@oracle.com>
 <ZpW+6XCI4sf6kC+n@dread.disaster.area>
In-Reply-To: <ZpW+6XCI4sf6kC+n@dread.disaster.area>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|CH3PR10MB7988:EE_
x-ms-office365-filtering-correlation-id: 9cbb9245-be1f-4f58-1d8c-08dcaa7843ae
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?SHBSN2tKVENUelVjSVBpbXl6enMzc2wwYUVtdVg1ZkgwNkpVSVMycHpUOGtZ?=
 =?utf-8?B?VE9uR1lvd2RCQ0R6UlRWcGZMTkVpbWlYTEhxOWRtM3pIR0tBNlRXa0I0ZVcy?=
 =?utf-8?B?UnY2Um4wdXVCNENwbTRQamFPWEFwYS9kT2l5enVFV0EwRUdtNThIMy84Y282?=
 =?utf-8?B?VjJQajRFanJ2L2lSdlphUWhqRm5POEV6YXQzV081Z0cvQjIvUXFNSytwT04w?=
 =?utf-8?B?UVNZNXByV1UzS2xzOERQT1d5ZWZTMTFLT1ZJNHcyVGc1aXl6T1dLNGFXUDg3?=
 =?utf-8?B?M3BxSFdmWmpEaXNzcW9pU0s2eWRlc0J5VkphQlBlOE01b3docjZaUVFYYWhK?=
 =?utf-8?B?aWNUNzVrS1krb0cvOEE1R0ZUZTVXOUYvYkpyNytoSy9xa0NERXNIc1h1UmVN?=
 =?utf-8?B?TTVHbHU1bTdnb0hQL21DdXA5aGZtdnhOakJlRDY4ZDBwNS9kTFVXRnFrcHJ3?=
 =?utf-8?B?QW43ekFYRFFXUGNnOWUxbTRVVFpaNnk4Z1dzR3U4WUZQZEdxU3RtYmFuRFZs?=
 =?utf-8?B?YWh4YzdVUTlqUVdWbzlZckNvSkcvaHJoWXRzR0xIZjU5MWRBVjRWY3ZJdkt6?=
 =?utf-8?B?ZitjM1c4R3M2WWJjMDl2NWtaMjUxZUZZR25TRW5uRE1xTG56RE1tSVkrSzZM?=
 =?utf-8?B?WjkveUd0YVBDeFBmeFYrVjNIeCtEby9lcG9aaGJkRlRMbVlYakU0M3VBRlpB?=
 =?utf-8?B?cGphU3lqVVA5cUhrbVJ2L3lKeUc2d3hEaG9pS1cyQmRZbHIzVk1WdTNiT2ho?=
 =?utf-8?B?aFVua1BYeVlaNmR5RjBGRENSYi9zZ1RGZFpnSmt1RGw0MmxPNXV0NHQ5KzVv?=
 =?utf-8?B?VUlGOXZNWFBjcTAxT3BPQWpQdHFpU3plVXRkakJITWJ3ZEIzbTVVbzFCNXJM?=
 =?utf-8?B?WTJja3FXTWdrVlF5SnErZzBaUjlsbm5pM1hoMm9CZ2NmUUV6TW9Iak5YZFFG?=
 =?utf-8?B?bnFlZ0twRHI1Rk5LNUxjc0oxNHJGV21GUlJnU2JqSk1UMDFmZStKNmVtVDNY?=
 =?utf-8?B?L1ZSbWtEa0xhUnBRNkRaS3A4RUpCWlpOanZ3bjZ1TFM1aEZlbGk1dDl1anFK?=
 =?utf-8?B?RmVxSlVxMGxNdFJoOVR4VWR6cmRyV3RvQ2NCTnJhakZWbG1FTG1CVk1EZUVZ?=
 =?utf-8?B?NU53dnR0cTRFdFZXMHFVd1R4eEIvMzMxN281YXdoT3ZHczkzZ2hvU3BFaFFU?=
 =?utf-8?B?emcyb0xlYnpMc3VMekVSSURkV2k2UVd5TmlCRnFIdG1Hc2hJM1RDV3hqK1dD?=
 =?utf-8?B?cURrSUpNY1N4U0ZEYTNob1hQUUxGT0Y3QW9lVkU4V0JXUXM3ZEFVTWkxM0lR?=
 =?utf-8?B?K0dCMW9MNU9yVFo1TW4vWUE3L0wxTzRRMkd5bUNDMThERnRVUGhNdTlkbkdn?=
 =?utf-8?B?R2NVZTEremsyNjIrSGFWc095WDFvcmdDSS80bmQ1WHZMaW9FQkxuWFhmYis1?=
 =?utf-8?B?M2tQYUZwRDZQMEZJZ0hLQlhqSkJmdFkrK2pJRmU3OUNJenpzRXVOREhub01Z?=
 =?utf-8?B?Z21xa0QrS1FsKzZDUjA5WDlYTTkxc3RKejRNbWR3aERJYmRldEM2N1lDUEdw?=
 =?utf-8?B?aDJheGh3bHZYV3ZJZVBwNHNNUXBuUDVFOGJRYThucHVNMHNsa0dTd3ZzV291?=
 =?utf-8?B?QXR0ZUVYZkd3MkhhQzF5eHh2SnVTRVkyUnNNQWw5UzNGL0YxOEc3K3kwQmRN?=
 =?utf-8?B?RDRhczQyZjBtS0FlVHpmTW5WS21aWHZVVTVnQmhmOHFrUElEN1YxS2dkdTIz?=
 =?utf-8?B?QTdya3UvUmMxeSthZm81NFczQkJWUDdnc21XaXNocUI3ZGZOVllMMStDWTMy?=
 =?utf-8?B?L1lMQStyNS8vVk94RjBhamNickdoMXhWdUp5ZXNlZlZZajhmY2p4cWt0ZE10?=
 =?utf-8?B?TkExUFJFUE9KNkdXU1grL3l2RUpYOG52ZWdoMGNBWXBZRlE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VTZqQ0F1ZnFPblJaanNYTGZBdm53SUxxdnFjTTZQbDBIWEI2bUdwVjVOWkho?=
 =?utf-8?B?NWFTQnFwZE9nZ0pSMTRTRFJyclNJSVpBa1MxbGZMaFg2YUl6VnN1ZTdpc0dE?=
 =?utf-8?B?cnRqUGVCbnpheGpxUGZvdlFRL1FMcWMrQzNkVDVPcnFubHBkYitBNTFtL244?=
 =?utf-8?B?Z2dvY0RtaVJqdTQwaE1MOGlsNHlLTmNkek4rNXdTaGJJaTBybmxaL3ViMkNt?=
 =?utf-8?B?NlVpeXgvZTVPQUZxZmpNZSsvMGtTRDNNSGwvVkkzRHVBZnpVSjRvbitKUWxC?=
 =?utf-8?B?Y3p1Z1pEZGFsN25rdVpUYlFldzJIZlJ3U3B3OGU5dkNpa3hRS2tUY0pDeGhP?=
 =?utf-8?B?SFlLdUExU04vYVg4clAzV1FybC9Ia0drc1hSS3hZK1RKc1BqZ0pPd09MdEFH?=
 =?utf-8?B?NWpGaWJPcElnZFBlZ0QzY3d5SXBUd2prU0wrNVVvVUphU2tOVGtyK1J3ZHlt?=
 =?utf-8?B?akEvUUx5cE5nUzFUOGNJNzA2NHY1NGozZnJwUXlwQytYcjhoU3MvTEpmNTRB?=
 =?utf-8?B?aHM3RXJxN0xpK1lGWGtFQTQvVzlLQ2hsbkcyZGFrTlA3ejhTWlU5NFdNckpD?=
 =?utf-8?B?bGU2ZGZ0cTVHMEEyRXBpb1RrdVd2OHhZTlZsTFhib2xKMVNMUWdjb29iUXJF?=
 =?utf-8?B?OWxtM1VtWEF0MVV6emNrS2RmSFErNE5SZnF6Z2RQNUFRMUYxeVpYUVhJTkw4?=
 =?utf-8?B?Qk4zdUJmNW5PNlF3aUVPdXVIYUpNZFE1cWJ3djFYclYyTExxMGxVRTVlQzJF?=
 =?utf-8?B?UldwemFTcDlnNFlha2FYNGdlNTlSVyt3MXBJUkdNcVp2LzEvL3BiOEl3NGtn?=
 =?utf-8?B?TTV1amo3TlpCbms3SHZ6Tnd1RFVWUEdxZTYyT3ZLei9ENWplemU4SUdBOHFj?=
 =?utf-8?B?VjA5b212RXFiV3BPNjhNUVliekp5K3MxOTB4c2hmNlpEMEg0QnMwVkJYMlQx?=
 =?utf-8?B?ODREWTRyZE0rNFVHcVlIRU9XM25VTjR1WFBKRFlLSzRkdzgvQjFDT25BdmJx?=
 =?utf-8?B?M3JqUEVmK3JLTGFUVW1ZVlJjemdTK2lGdzVnbUVUeTAvYkJsZ2RPVjBFRDVG?=
 =?utf-8?B?VHpEbzV4eVpZZDd2MzRWcStnM3NxcmJ3SmpqNWUyTFpSaEU2YVNkQlJCcEFR?=
 =?utf-8?B?ODRhSG9LTW0relJlZW9DRXlJRzVaMnpEL1M4QVhGWjlzVnBQcDl3YzZzaUp4?=
 =?utf-8?B?RnBqTVVPR0Y5bWpQWk1YTkVrWGx1UGMvbXlxYWQvRUdoU2V1L3p5UnJxNWVh?=
 =?utf-8?B?ZmJJZTQxUHMveXlHTzFZa01STXNncytOZ0NNTnlveHJnN3pDY200c29zNm5E?=
 =?utf-8?B?clphejFvdXFuK0N0L1M0bFJsSkhjT21aNnA0N0h4ZHplRjlKQlJrODRXWFlI?=
 =?utf-8?B?WG1mbmIxSXQ5OGhWZlNiSHIzbzUxQTJPZW96YVNwcWlxRXdBRDUrQ0MwMFdj?=
 =?utf-8?B?R0VySlgxYk1CRnFnTEFrc0d1djJ1VHBBQ2lnNk02TWN5Z3dhOW9CZGkwbUNx?=
 =?utf-8?B?ZHBDdTJEeGRDWUd2eU5VZVBJSVhPQ0x5bXU1a05lQXZMdG44TGdHS3JCWGkz?=
 =?utf-8?B?TG9BQzdrdzJIU0dJTHFzSEFSUTNoMmVNMEwvK21Fb21aZkc0aHp1MGlFaEpR?=
 =?utf-8?B?Kzc4ckZ1cm1hb21PWUR4MFMrbG80SytsY2FlVjdmSjVPRFNZc2hqQXZNV1FQ?=
 =?utf-8?B?TGxhOU9KYTZseWVtY2hhckljZitlSVpOSm5NUVZCeTdPS2hTcVkxdmVJMW5k?=
 =?utf-8?B?bGxEM2dSM2NBMFlhNHFtNFhWZVFKOXZzZUNPVDA2ZElDNTBVZ3dwMnpkSGJn?=
 =?utf-8?B?cjIza09NS3diSU5ubnJJYmVnZFlUanNub2gxRHJTMUVGWVVrNnlvdi9SV25P?=
 =?utf-8?B?b3VaMmRKbzJ6allURDRPVWpxMks4YkU1aE5yd0RJZ0ozaWpTanB4bzh1VkVB?=
 =?utf-8?B?bmtxQnFKS1ZPTFFCQ2FXUEFVSXNyaFpVOXRhVHhxelcyeHNTbnMyUXZTZi9M?=
 =?utf-8?B?YTBNSE1IWXpUckFvWUNXcUVWWHMxQ0lZTS9DWXZ1b1ZxTkxzMzZqMmVjWkFS?=
 =?utf-8?B?b2VsajRPYlB6TGVLcmZqa3NoVW9wa3ExVjh4Nmp2RGxxNHZ2VVlTRnhWQVBs?=
 =?utf-8?B?ZnU5dlZwUDlrMjM2UXF1RjFtSVJsVlFBQ1FGYVVka3BhaDhrNzl0L295TXEw?=
 =?utf-8?B?Vnl4WWY4T3d2T1UwdTRSY3RzWm5VbEluVlJhT2phNElFY3E4VTJIK1lnbDNi?=
 =?utf-8?B?ekQvUndKdWc0cml2d3dSb1ZpRkxRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2F65EC9F32F14641A5611BD08AD2F775@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	f9FLMjL1OTVCoGGQkKKL308uSVG1WkGhhfQBM7QSr1FDl9o4UWhmfGuwzaNGdRroE9AFekLQfeJLjNavMTLNalR6PRa86lAyulR6Tw8jgMENVZWUk6kcWeOGcsAoQp7DJZPX0R2pKyuCQJLaSwBPamI4PFw8op1luqSXXvXMQrP438AL4NKt3EhkkKvm1wlJ1PSs2aq0ngn52aZKn35D7D4LX/JWL8ra6Acb9ujx8rudG5gx48YH81tH5yS1++lNJYj7TUzuWHTTgAQZrfQS7daZZ6isrm5MeA97JPZvf0WgW5gMvj8/ov7Kp18h2Cl/6FwPTyCbSNnKHJd7dgt5prPXi81mNStTh9qKdZAaxGRu3uftBrnFsK/4Hizg9loqAaLFUiylk9U/VMaih2+Fwbjyny9r8WgyrIUA94hWEnFWQtZP5nnK5a6YjxCsX4LskEFLfK3EZNnfE9FejFL5bX74CJxPlhih4BjF8UoUqFNYkrrMgs8SO94zqC9gNllqYp9nBBZ51y9tRdSio8mjNO4ObwrhhJmOeVjX5UZYH1stjdOwu8yYq2b18mmDYAia2fXFXwEJiwF/k3cwn4HEKDXBW0pRA8qRb8BK0ZjoAJ4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cbb9245-be1f-4f58-1d8c-08dcaa7843ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2024 18:01:08.7564
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZRDTJ/d9adoYzC8jygKolmJ5txYdBWjnI4SCcEvTM/VARWgR6oLOqnhzsT5eHE7586HCSdF1IllqvImIk1aG3lh//BF830fb58m0SuybfkA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7988
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-22_12,2024-07-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407220135
X-Proofpoint-ORIG-GUID: aizwjEBalK-oA_SqBEuvs0GqIoGz73pg
X-Proofpoint-GUID: aizwjEBalK-oA_SqBEuvs0GqIoGz73pg

DQoNCj4gT24gSnVsIDE1LCAyMDI0LCBhdCA1OjI54oCvUE0sIERhdmUgQ2hpbm5lciA8ZGF2aWRA
ZnJvbW9yYml0LmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBUaHUsIEp1bCAxMSwgMjAyNCBhdCAxMToz
NjoyOFBNICswMDAwLCBXZW5nYW5nIFdhbmcgd3JvdGU6DQo+PiANCj4+IA0KPj4+IE9uIEp1bCA5
LCAyMDI0LCBhdCAxOjIx4oCvUE0sIERhcnJpY2sgSi4gV29uZyA8ZGp3b25nQGtlcm5lbC5vcmc+
IHdyb3RlOg0KPj4+IA0KPj4+IE9uIFR1ZSwgSnVsIDA5LCAyMDI0IGF0IDEyOjEwOjI4UE0gLTA3
MDAsIFdlbmdhbmcgV2FuZyB3cm90ZToNCj4+Pj4gQWNjb3JkaW5nIHRvIGN1cnJlbnQga2VybmVs
IGltcGxlbWVuYXRpb24sIG5vbi16ZXJvIGV4dHNpemUgbWlnaHQgYWZmZWN0DQo+Pj4+IHRoZSBy
ZXN1bHQgb2YgZGVmcmFnbWVudGF0aW9uLg0KPj4+PiBKdXN0IHByaW50IGEgd2FybmluZyBvbiB0
aGF0IGlmIG5vbi16ZXJvIGV4dHNpemUgaXMgc2V0IG9uIGZpbGUuDQo+Pj4gDQo+Pj4gSSdtIG5v
dCBzdXJlIHdoYXQncyB0aGUgcG9pbnQgb2Ygd2FybmluZyB2YWd1ZWx5IGFib3V0IGV4dGVudCBz
aXplDQo+Pj4gaGludHM/ICBJJ2QgaGF2ZSB0aG91Z2h0IHRoYXQgd291bGQgaGVscCByZWR1Y2Ug
dGhlIG51bWJlciBvZiBleHRlbnRzOw0KPj4+IGlzIHRoYXQgbm90IHRoZSBjYXNlPw0KPj4gDQo+
PiBOb3QgZXhhY3RseS4NCj4+IA0KPj4gU2FtZSAxRyBmaWxlIHdpdGggYWJvdXQgNTRLIGV4dGVu
dHMsDQo+PiANCj4+IFRoZSBvbmUgd2l0aCAxNksgZXh0c2l6ZSwgYWZ0ZXIgZGVmcmFnLCBpdOKA
mXMgZXh0ZW50cyBkcm9wcyB0byAxM0suDQo+PiBBbmQgdGhlIG9uZSB3aXRoIDAgZXh0c2l6ZSwg
YWZ0ZXIgZGVmcmFnLCBpdOKAmXMgZXh0ZW50cyBkcm9wcGVkIHRvIDIyLg0KPiANCj4gZXh0c2l6
ZSBzaG91bGQgbm90IGFmZmVjdCBmaWxlIGNvbnRpZ3VpdHkgbGlrZSB0aGlzIGF0IGFsbC4gQXJl
IHlvdQ0KPiBtZWFzdXJpbmcgZnJhZ21lbnRhdGlvbiBjb3JyZWN0bHk/IGkuZS4gYSBjb250aWd1
b3VzIHJlZ2lvbiBmcm9tIGFuDQo+IGxhcmdlciBleHRzaXplIGFsbG9jYXRpb24gdGhhdCByZXN1
bHRzIGluIGEgYm1hcC9maWVtYXAgb3V0cHV0IG9mDQo+IHRocmVlIGV4dGVudHMgaW4gYSB1bndy
aXR0ZW4vd3JpdHRlbi91bndyaXR0ZW4gaXMgbm90IGZyYWdtZW50YXRpb24uDQoNCkkgd2FzIHVz
aW5nIEZTX0lPQ19GU0dFVFhBVFRSIHRvIGdldCB0aGUgbnVtYmVyIG9mIGV4dGVudHMgKGZzeC5m
c3hfbmV4dGVudHMpLg0KU28gaWYga2VybmVsIGRvZXNu4oCZdCBsaWUsIEkgZ290IGl0IGNvcnJl
Y3RseS4gVGhlcmUgd2FzIG5vIHVud3JpdHRlbiBleHRlbnRzIGluIHRoZSBmaWxlcyB0byBkZWZy
YWcuDQoNCihBcyBJIG1lbnRpb25lZCBzb21ld2hlcmUgZWxzZSksIHRob3VnaCBleHRzaXplIGlz
IG1haW5seSB1c2VkIHRvIGFsaWduIHRoZSBudW1iZXINCm9mIGJsb2NrcywgaXQgYnJlYWtzIGRl
bGF5ZWQtYWxsb2NhdGlvbnMuIEluIHRoZSB1bnNoYXJlIHBhdGgsIHRoZXJlIGFyZSBOIGFsbG9j
YXRpb25zIHBlcmZvcm1lZA0KZm9yIHRoZSBOIGV4dGVudHMgcmVzcGVjdGl2ZWx5IGluIHRoZSBz
ZWdtZW50IHRvIGJlIGRlZnJhZ21lbnRlZC4gDQoNClRoYW5rcywNCldlbmdhbmc=
