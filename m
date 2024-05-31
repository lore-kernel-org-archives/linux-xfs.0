Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB472E63B
	for <linux-xfs@vger.kernel.org>; Fri, 31 May 2024 18:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717178634; cv=fail; b=QBHeTdZp9IeSjBy4QsUbdaYuWwVHNBE+iKYGGbEUOXkI5GpRXlJR7fqI8Kd3TZ3dkqR98rXnVkP9A4j2IxxczwaFKoxjnIyk8UPqQFBdGirKdQSLOV4VGRzr8auyqBQPrK74gZjaw3Yln6N2nzFhi2PVV17k25SAsu0AYrppLMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717178634; c=relaxed/simple;
	bh=NNjoBZWu/zXqfyYEFTSPHPeuir7fNR9IY7fhlA5SokA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KcrCXZ+9QtcfH/F49pHnbbR9gFEeXu9jBlRsMWiYzDGzWUc7x9F6tmVr3bbfkJ7GsW8UdwB0QIOsvWKn5o3gmcHBRGM2IiIrA1BWkwvp4vhU8XezkDuD5/ykul6ad5jCTKHaQ3++DKOhKbEEtUzFZoLZIrngdbyEJgATvLSQuxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44VI0p73019218;
	Fri, 31 May 2024 18:03:48 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-id:content-transfer-encoding:content-type:date:fr?=
 =?UTF-8?Q?om:in-reply-to:message-id:mime-version:references:subject:to;_s?=
 =?UTF-8?Q?=3Dcorp-2023-11-20;_bh=3DNNjoBZWu/zXqfyYEFTSPHPeuir7fNR9IY7fhlA?=
 =?UTF-8?Q?5SokA=3D;_b=3DS2gMTxyIXa/wF0/2Dqo2QihWhqwKAzqT0lCq61mjTAARNykKA?=
 =?UTF-8?Q?xN1f2VBdCh7vHdSAXSk_IbF2fAeBxoc+/odAygYWrHk1GMLul21/DMspRqw1Z78?=
 =?UTF-8?Q?aO1J77bA2FO9xBBWMb4bhZ48s_3/3j3monsv/JWmTSHzykgXztBoVvu++nkYBlF?=
 =?UTF-8?Q?b9bucVWcNLd84DJGa4ge3qNojTf8vXo_pPzBlfjlyfYdr8k4liByvJTvi21oJBI?=
 =?UTF-8?Q?b89vW6wyMXEpp/+YrDlYcXDLq3pZs5mOKa5Q5_FFi3+tCPcJn/DYvZnF5rpxLoS?=
 =?UTF-8?Q?sbx38uoLH/lkRyixOY3g7NqffMgSIRXMj2K+X4AQ0Dx_mA=3D=3D_?=
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yb8fckrrc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 18:03:47 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44VGisBt016340;
	Fri, 31 May 2024 18:03:37 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3yc50u63nr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 18:03:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RPOivsH+38jwJd8mRnz0VFxy2Pd9v7GSZuXfN1/VTLUKbSHGmsehYHetm2u9lvQhu4dxmlWNrNm1KM5FSocTNlYF3p6JFf7Xy/Ng7cq1agxWx1zP9AD/gz3ofXa1SENXNF9nQDOaNsMItwysXd96xCS0vNCiLn4GuIcZHtmBiIno5dK9yF8fioXITaVsCH5/rADHA1n5iLJJbsPmSn+6j4yeCJtC+WtjBlFZi/U4ExmqKx+jae0MhUSkxgM00zL7SSieI4mY91Gq4sOzQ6Dg3KOmXnI1nE7kVRdh1C+YUSabv2ARoYAu2Y/u/1pe06bs2aFFNA0toFUXMrVnTwIBlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NNjoBZWu/zXqfyYEFTSPHPeuir7fNR9IY7fhlA5SokA=;
 b=mUO6VuQK1lyJseV00zILh2/XVadKOjy8H2+dvNekWIOX8Mp00vQA1kEo8Fkg5/MDTCEOZ1yKQm555DMJgBx+jMt+PVx0EMqnUHHQl8EiN5p7QMOcITBhREMzTpFuJ6Rp1kAu9tuu+Te+ymfZVqk7GPx2sXo3udpQBiEDvoZ6KMZxnkHEPd1cYX8Q7xNy89Z0kF0QlYgPy2+ZyNjjg8OaaFkq0w402tPzw2VTo1Ep0Nwun0+G+xT8B/XJoRrZoqHivQh4gFkCCHu9NAQHtXil7vFQN2thz7xrkXg5mRN+o3THaCbpWnZdmxJ1ah94NaNzJ/cCnvjq/3WubQNIN2mWXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NNjoBZWu/zXqfyYEFTSPHPeuir7fNR9IY7fhlA5SokA=;
 b=W9MNL4Vyqu1QfBeI8Caf7eXl2ZfZjRP8vJBW//jSMpfkQnfeRXPvNWk3mWeJNu1+KkcMJRIdYcuBkiS19xDqh/tp2stDlQeLff4EYgII0fRT+uhjDEkCox1YRhRfjpl1M2ZnZAIS8wvCaCI/f61b2coQlAQVJ9mBbEEIzenl3AI=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by IA0PR10MB7349.namprd10.prod.outlook.com (2603:10b6:208:40d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Fri, 31 May
 2024 18:03:34 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%4]) with mapi id 15.20.7633.021; Fri, 31 May 2024
 18:03:34 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: make sure sb_fdblocks is non-negative
Thread-Topic: [PATCH] xfs: make sure sb_fdblocks is non-negative
Thread-Index: AQHaozr8E9KmCgD/tEKemp9zonfvu7GxnrGAgAAkgQA=
Date: Fri, 31 May 2024 18:03:34 +0000
Message-ID: <09314C07-B326-4D0A-9FE5-0605DF849E4B@oracle.com>
References: <20240511003426.13858-1-wen.gang.wang@oracle.com>
 <20240531155245.GP52987@frogsfrogsfrogs>
In-Reply-To: <20240531155245.GP52987@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|IA0PR10MB7349:EE_
x-ms-office365-filtering-correlation-id: f2943fe1-35b7-44c2-0808-08dc819bfcf8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: 
 =?utf-8?B?OGtmNmVQUzh0aG90ajM2d05FRGtoTC9ZaHh5L1lCdzZUdDZqY01udWdqSDg3?=
 =?utf-8?B?ZWdVaWErVzlKS0p5am8wS1BEUDVQQVZwM2RVWUNXaEh1THorOTZYanh3RHZY?=
 =?utf-8?B?T2N2ZFhMcTlyQmNQaGh2RjBhYVJ5OWY3eWc2Qi84TFZTR1BDQnJmSEpkb0NX?=
 =?utf-8?B?QUZvblhGVlhTZ0RzS1RjVXREZmhEemkwVmxxN01Fd0syVHFDTytHQTdVcTNZ?=
 =?utf-8?B?VnpkQ0VFWThWRktjeU1BdjlKeXQ2ME4zaHZuSjNOVnR5dWdUZk1za3gyTU4x?=
 =?utf-8?B?Y1ZNVXhGZ3FBbXo2UEYwbzVNMURXRjJiR1pZRWxFUDhpK05wRkpQMnBhYlRR?=
 =?utf-8?B?bUxvdnVHTG5DQktSSWdTUmJFZ1dkZ1VmMXlaaGl2MnVQd3ZFb2ZkWTV5Umxo?=
 =?utf-8?B?ZTBXdENMUDg0RlFsMGttenVTUStLbVcxUWJIR3JiUjNld1lDcWhQb1c1U0Fu?=
 =?utf-8?B?NGN3bFF5RzFSVUtzZVlLOU9zVWhvT0V6Mm5Ld1dUNnBxMUpvTkNXMHg5YmlC?=
 =?utf-8?B?UDFFT1NLRjNodlpIV2ZtaHFWYUVpeHJNa2hmaHQ1bTFhZEhiZVU5VDJvYUYv?=
 =?utf-8?B?NDBCMExGYmVTN0tmZjdyd1U2Qy85Z2VWTWtGNVhrVGVUN2wvUTBlb1Nacys5?=
 =?utf-8?B?UzhCUzJYODhNcVlLUExhTGdIVXlUSjBjdzFXODRhWDhvTnVOSUZWL3Nldjc1?=
 =?utf-8?B?MzFsNTBja2JMekJaZ3NuVFIrR3dUSkVDVVpGWlc3NUZEaTdKNXF5dXJjYUQ2?=
 =?utf-8?B?OHkrMkZTeG51enRMM0FpN1VTZVRMdElJcXp6UjZVUFNlODk3OWtSWFg5SjdW?=
 =?utf-8?B?TXBrckxYeTdLZHZ4SmFRTlZhVDk5cjJsTCtRVGxMQi9xZFAzTkd0cDVxcy9p?=
 =?utf-8?B?M3JyUFpRUEpRTG1ZTTc3dExraUxYQTdlZUJXSlJ5N2xMaldURGJEVmxMcFd3?=
 =?utf-8?B?eUx0ZU9ydjBvRXd0bGxXcGNDdk1CZmZrS2F2UUpvOC9CL3phV1R6bE9WYlRK?=
 =?utf-8?B?QXU2VktjS0pYTjlnUXA1ODdqd1NMcS80ZFNyTUt6Tm1pSWZ4TEJnMnUra0Iv?=
 =?utf-8?B?NFFseTZKbEVZSFFGdFQ4YUUwWENESGpRNmlscmFLeWtoTFV6Qnc5Vkt2dFBU?=
 =?utf-8?B?RDVuMmtERXJacEtXS0E5NWFabi9NUy9nQVdYcGE3b2c5RTc2bytWQzN6MEhw?=
 =?utf-8?B?Y2RUWkNra21XdlNEN3BsK1dPVCtuTVVVTDE2eHdZbHE1K092V1JaTjFNak1p?=
 =?utf-8?B?WW9ieVdEZkZBVTdvZThlUU55aFJWSG5YNmZPb0tzZ2JvdWI0T2dMZGZqUkIx?=
 =?utf-8?B?ZTlhbU02cGpzYmNNRk5WM0tVaE9zaXR0NmJyeWt5Zm9HSEZFMDQvTTlQakNZ?=
 =?utf-8?B?QTZIK0I1eE9xSm11MjVXZkJIYjVHNitDN2p1bDRtUkltenMxK1hZL2hsWDR5?=
 =?utf-8?B?Rkh1OHlQN0g3eWtyZU5DN3oxZmx6TVQ2UXNBSStadFI4aktzQWVBNk1ZcFFK?=
 =?utf-8?B?eHJKeW9MUG9jQllTajZVc2M5TWh6WUJsTFprNlB0RndwNXdXU05nTUw1U2Fx?=
 =?utf-8?B?bVdYZXUrN3BDSWszUUplc05BdmRaRUdMZE9aUEZmSUhSRTlTTWVKdTc3R2Ri?=
 =?utf-8?B?bWNXTzYwTUtVTjNWQjJ2bnl6WWtzclpQUUVmaHBwNWZlcFRVZHBnQ2lUZ1lX?=
 =?utf-8?B?cUszRXg3bXJyWlU3REtTeTdqc3NTTHBxWW81SmUwU3VzalNXUzJsazk4RUhu?=
 =?utf-8?B?Mm15c21sVWxWMVBLUThKWEtyeEo3UVBiU20vblZoTWxVWUs0YUV1OVpENXVL?=
 =?utf-8?B?dkFOd0pBam9nY2M2UHhjUT09?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?VXRWTGE3dzJKbkZrYy92MzhLaVM4WHUzQUF6M2FoRERrUG5qT1ZpREVsZTF0?=
 =?utf-8?B?UmRSTDY3NzQ3SUhWdW5GSlBvMC9TL3RQMWRyaFAzR3ZBaWlMZzFTYk8ySHA2?=
 =?utf-8?B?Q202QnZsZEZ2TVdTWVUwazRjSHNOWWlUWDRwd2VONGVYNll3SVlNTUxnSy9k?=
 =?utf-8?B?WndReFdPWXFhNTFJNlA1T3JRdEVxN1VFaTJaYzZDczlsb3N3WmlEVks2OFhk?=
 =?utf-8?B?OTYrRXFYNS82VW5hNVNXdjNXR2d0S1lBcnpxSGFwaDd6SCs1aXF2VTI5MmtI?=
 =?utf-8?B?b2hVMitsQk41U2RQQmFyZE1XcFZpM3hoUng1alVRbXdIRDNVTCtsWlprVG84?=
 =?utf-8?B?WjE3ZjQ0U1Yzd2QrUk1RamtLVmswTm84dnJBM3BCbzQ5S2c1NUxVUktVQmtX?=
 =?utf-8?B?MjdWcnNuMFpNems3bFJuazFlNzcvd3YxSmd4SmtIdXU4SzhwY1JncmlaYXcz?=
 =?utf-8?B?ZGFha1hTYXpYWXEvdHVqVGlyMkxmMzJlOUZWSExxc1VzMmNmY2o0dHNueDNr?=
 =?utf-8?B?Wk9SM3JIVkwvUUIyZ1hnd1BkZzBUdnNOYkhUblBIcTA0TjkvTGdSMEZYVFVE?=
 =?utf-8?B?d0RTczdkRzY3N2VRNXlGQmNILzB3TytJVUE5dzZGRXU2R2NrYWg4azBLR3JK?=
 =?utf-8?B?RWtkRmdvZHU0NGtDa3gvSkxTVlJsVDJvS2hpZzMzQ2dEWjdxdEdjRHVXNjlQ?=
 =?utf-8?B?V2JGOG8vaVhvVmlGMjB5WW5yL1RyOThIMEFvTEg0ZTR3YmxmTVJWVVVSa3FC?=
 =?utf-8?B?c1lqZ20vK1NFK1d5QzU1OE9naW5DQ3A5K1FEMWtEclZMVmtVWG8yRDhKVU9m?=
 =?utf-8?B?TXRaVEFUMk8wbHljalZrR1psZ2VQekR4Y01WZDNWZk92NHBpSnh6VVN4Z05z?=
 =?utf-8?B?dnhSNXhkZTRiNExuZDdWeTUyay9LUXN6dU9QdmZxVWx5Z2lMZjg2MWF4MWtM?=
 =?utf-8?B?QXNBZ2pKZGprM0N4MkNndWFLeWZIQm5vUlh3dVpFVXgzVEMzRTZXc0ZrcmZR?=
 =?utf-8?B?dW5nSDlITW1HYUdrTlpCbUhQc0w5RENTNyt3VmkwUm1oV2o3ZEtSSlgxQTVv?=
 =?utf-8?B?OFRCSlFaMXBTTlFCYUpEVmFJTzJuTVBROUlQblp2VmxhZWxTcFRyRFl6Slds?=
 =?utf-8?B?d0NaR21QZy9TL2xaRno4MGRnQTF3TE1oU28rWENiMEUvNFhnd1UwR2FGVTU1?=
 =?utf-8?B?N2d0dm5HK2ZJeGVuNzJUamdaYkJBamRSaXNlTWtESEo5bTFSbFlLUEV1Y0tT?=
 =?utf-8?B?S1JSVkx6VUFFY0J2alVhQ0xUcm93cjljM1NPNHN0NUt5R04rV1RVQkRET1lQ?=
 =?utf-8?B?YldSR2taVnpnbi9oL2QzWFEzMnF3eTRtYm1iOGVCek1WbE5maVhzM0ludFUw?=
 =?utf-8?B?cy82K0JZV0YwNnRPa0QrQ2hTRTZIalkzamR4K3ZuNXFFSU96TjZXOUlxVlhH?=
 =?utf-8?B?dU1hNCtyQ3Y1bWxockxRTk52d3dFWFJIeHczTW1LWnRKUFovOEM5cTMrV3p4?=
 =?utf-8?B?RDRacWdHUDFvZ3l6SjBRRnRndnQ2ZDFQZkdxMGhmTUZYR0pIR01HdHdKcEgv?=
 =?utf-8?B?S0lXd0FKWXVvN3oyKzBnbG1TYVNnUXRsbUxubzBzMzRhOTU5MzRycWUyVm85?=
 =?utf-8?B?WGFQZ3BoV1NCSlE0K2lMbWlTWXViM2t6TjJ4elp4VUFMZ1RhTmdSRGtBQ04y?=
 =?utf-8?B?Mjg4R1h6UW9ndS90d0R2dHptS09kM2ZPWjZZcHpmeHN1QytQMGdzMEJSNElh?=
 =?utf-8?B?aDNYeWlmSEhZYjBHaCt3N1NkdEFrOGNWVFFOWmJHbitTOGRUVkxkNlprNEpi?=
 =?utf-8?B?RURBWGUxUE1QMmt1R2JqbVF1YWxIZzhlT0tEOWZSbFp3dWZTVzRoT3RUOFo0?=
 =?utf-8?B?amdXdmg5U094VnBlUENDUEpuZTY3bG5mYlVSTjV6N3lMZlRiaFZDeDJKWGlH?=
 =?utf-8?B?N0p6RytPcWsxNzZLdnQrOFVycXcreVlNNVd2NVQyTllVZCtWQ2JZbHlmY2Zk?=
 =?utf-8?B?ZXJlWlE0S0tnai9GcnNSeGF0UmwvTzM1d0hyeXQ5eTkzMlZHT2tDZmJ4blc5?=
 =?utf-8?B?czhDSUErWldYd2hHeWhUUnJGbWRLclVPWDFMZFg2Rk1ZZTUvdmdFK08rNURn?=
 =?utf-8?B?VVZCSCsrdlVERWxnb2hKbU5HZ0Q1K3NqQmdvOTJjSDVjWk1NNVhtZ2VORW55?=
 =?utf-8?B?cEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7FECBFF494DCEF4992DAF4006CC3A217@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	e1gjqN6GXSKq4si3Z+mt90zNoh5zCUSJ/cYILT4OFASYEsvDqam/splb4diIHav/u6XzI41/9rM2o/ruHNXSe9+pTbm+AzNnClDp8PYio5EQNsKXmI4II4ZKbueX6cXBDIGMzn/QPYCi1uckY8D6AuYznBpxvdRJX9hWIJqs56bDLQp+d8rS/bAi5F0kWdz3eaKuQJgxNx4M0APlxvT3vI6FsWBo4pMJ+m6xVCcyRoNQ6GrDtHeWx8CvnWzNUAjOgFjVazI97FF1t5s4mCmCt7bJHoaYiGQXPDI3QPw2a/KMiV/p2UDhg5ltnsDfE33V67wk43XSqyZzmun6q9Zr2eQKkUrx3r5vUHhdVQzjVZOQPzT9nam53nUf3d9733PsmqJQ2w0eEgijfta7WvApFYwzovjTHklZHVcgLWmrzOgc64eY1z27va0Su2h1IEwYFUyeLkdNXvqPgxVVnGlgKduA2/HeihorEKJokv1HoCyYOQkjBxYlXpAkV4E4j2Zq2Yr+xTncI+1wtB2U/zgFqodcudUOBvA/NzgMsFdQ4OfmftcTg5/wYzs3p4utG1sA7dBzrsC3qyLyTa4b68iUk/S5Aa+qyXLE3YpJ7/sGjnI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2943fe1-35b7-44c2-0808-08dc819bfcf8
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2024 18:03:34.3300
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vZa5uaCYRoadGhKWWNN6BecjOlguRuoStga0zpZDQNTU5r/LUhI6LsbfKCu105Q+8gXpQMjHctnz19sOUUZioikSemUzMZ0ye5YQ6USQaeQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7349
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-31_12,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405310137
X-Proofpoint-GUID: qVox65N67r0PqxfuTKEW1OeTvqOKQsPN
X-Proofpoint-ORIG-GUID: qVox65N67r0PqxfuTKEW1OeTvqOKQsPN

WWVzLCBJIHdhcyB0cnlpbmcgdG8gYW5hbHl6ZSB0aGUgcHJvYmxlbSBmcm9tIHRoZSBwZXJzcGVj
dGl2ZSBvZiBjb2RlIHJldmlldy9hbmFseXNpcyBvbmx5Lg0KU2luY2UgeW91IGxpa2UgdGhlIHdh
eSBzdGFydGluZyBmcm9tIHRoZSBzeW1wdG9tcyBvZiB0aGUgcHJvYmxlbSwgSSB3aWxsIHRyeS4N
Cg0KVGhhbmtzLA0Kd2VuZ2FuZw0KDQo+IE9uIE1heSAzMSwgMjAyNCwgYXQgODo1MuKAr0FNLCBE
YXJyaWNrIEouIFdvbmcgPGRqd29uZ0BrZXJuZWwub3JnPiB3cm90ZToNCj4gDQo+IE9uIEZyaSwg
TWF5IDEwLCAyMDI0IGF0IDA1OjM0OjI2UE0gLTA3MDAsIFdlbmdhbmcgV2FuZyB3cm90ZToNCj4g
DQo+IFlvdSBtaWdodCB3YW50IHRvIGxlYWQgb2ZmIHdpdGggdGhlIG9yaWdpbnMgb2YgdGhpcyBm
aXhwYXRjaDoNCj4gDQo+ICJBIHVzZXIgd2l0aCBhIGNvbXBsZXRlbHkgZnVsbCBmaWxlc3lzdGVt
IGV4cGVyaWVuY2VkIGFuIHVuZXhwZWN0ZWQNCj4gc2h1dGRvd24gd2hlbiB0aGUgZmlsZXN5c3Rl
bSB0cmllZCB0byB3cml0ZSB0aGUgc3VwZXJibG9jayBkdXJpbmcNCj4gcnVudGltZToiDQo+IA0K
PiA8ZG1lc2cgZHVtcCBoZXJlPg0KPiANCj4gIldoZW4geGZzX2xvZ19zYiB3cml0ZXMgYSBzdXBl
cmJsb2NrIHRvIGRpc2ssIHNiX2ZkYmxvY2tzIGlzIGZldGNoZWQuLi4iDQo+IA0KPiAob3Igc28g
SSdtIGd1ZXNzaW5nIGZyb20gdGhlIG90aGVyIHJlcGxpZXMgaW4gdGhpcyB0aHJlYWQ/KQ0KPiAN
Cj4gKChXaGF0IHdhcyBpdCBkb2luZz8gIEFkZGluZyB0aGUgQVRUUi9BVFRSMiBmZWF0dXJlIHRv
IHRoZSBmaWxlc3lzdGVtPykpDQo+IA0KPj4gd2hlbiB3cml0dGluZyBzdXBlciBibG9jayB0byBk
aXNrIChpbiB4ZnNfbG9nX3NiKSwgc2JfZmRibG9ja3MgaXMgZmV0Y2hlZCBmcm9tDQo+PiBtX2Zk
YmxvY2tzIHdpdGhvdXQgYW55IGxvY2suIEFzIG1fZmRibG9ja3MgY2FuIGV4cGVyaWVuY2UgYSBw
b3NpdGl2ZSAtPiBuZWdhdGl2DQo+IA0KPiAibmVnYXRpdmUiDQo+IA0KPj4gLT4gcG9zaXRpdmUg
Y2hhbmdpbmcgd2hlbiB0aGUgRlMgcmVhY2hlcyBmdWxsbmVzcyAoc2VlIHhmc19tb2RfZmRibG9j
a3MpDQo+PiBTbyB0aGVyZSBpcyBhIGNoYW5jZSB0aGF0IHNiX2ZkYmxvY2tzIGlzIG5lZ2F0aXZl
LCBhbmQgYmVjYXVzZSBzYl9mZGJsb2NrcyBpcw0KPj4gdHlwZSBvZiB1bnNpZ25lZCBsb25nIGxv
bmcsIGl0IHJlYWRzIHN1cGVyIGJpZy4gQW5kIHNiX2ZkYmxvY2tzIGJlaW5nIGJpZ2dlcg0KPj4g
dGhhbiBzYl9kYmxvY2tzIGlzIGEgcHJvYmxlbSBkdXJpbmcgbG9nIHJlY292ZXJ5LCB4ZnNfdmFs
aWRhdGVfc2Jfd3JpdGUoKQ0KPj4gY29tcGxhaW5zLg0KPj4gDQo+PiBGaXg6DQo+PiBBcyBzYl9m
ZGJsb2NrcyB3aWxsIGJlIHJlLWNhbGN1bGF0ZWQgZHVyaW5nIG1vdW50IHdoZW4gbGF6eXNiY291
bnQgaXMgZW5hYmxlZCwNCj4+IFdlIGp1c3QgbmVlZCB0byBtYWtlIHhmc192YWxpZGF0ZV9zYl93
cml0ZSgpIGhhcHB5IC0tIG1ha2Ugc3VyZSBzYl9mZGJsb2NrcyBpcw0KPj4gbm90IGdlbmF0aXZl
Lg0KPiANCj4gIm5lZ2F0aXZlIi4NCj4gDQo+IFRoaXMgb3RoZXJ3aXNlIGxvb2tzIGdvb2QgdG8g
bWUuDQo+IA0KPiAtLUQNCj4gDQo+PiBTaWduZWQtb2ZmLWJ5OiBXZW5nYW5nIFdhbmcgPHdlbi5n
YW5nLndhbmdAb3JhY2xlLmNvbT4NCj4+IC0tLQ0KPj4gZnMveGZzL2xpYnhmcy94ZnNfc2IuYyB8
IDIgKy0NCj4+IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0K
Pj4gDQo+PiBkaWZmIC0tZ2l0IGEvZnMveGZzL2xpYnhmcy94ZnNfc2IuYyBiL2ZzL3hmcy9saWJ4
ZnMveGZzX3NiLmMNCj4+IGluZGV4IDczYTRiODk1ZGU2Ny4uMTk5NzU2OTcwMzgzIDEwMDY0NA0K
Pj4gLS0tIGEvZnMveGZzL2xpYnhmcy94ZnNfc2IuYw0KPj4gKysrIGIvZnMveGZzL2xpYnhmcy94
ZnNfc2IuYw0KPj4gQEAgLTEwMzcsNyArMTAzNyw3IEBAIHhmc19sb2dfc2IoDQo+PiBtcC0+bV9z
Yi5zYl9pZnJlZSA9IG1pbl90KHVpbnQ2NF90LA0KPj4gcGVyY3B1X2NvdW50ZXJfc3VtKCZtcC0+
bV9pZnJlZSksDQo+PiBtcC0+bV9zYi5zYl9pY291bnQpOw0KPj4gLSBtcC0+bV9zYi5zYl9mZGJs
b2NrcyA9IHBlcmNwdV9jb3VudGVyX3N1bSgmbXAtPm1fZmRibG9ja3MpOw0KPj4gKyBtcC0+bV9z
Yi5zYl9mZGJsb2NrcyA9IHBlcmNwdV9jb3VudGVyX3N1bV9wb3NpdGl2ZSgmbXAtPm1fZmRibG9j
a3MpOw0KPj4gfQ0KPj4gDQo+PiB4ZnNfc2JfdG9fZGlzayhicC0+Yl9hZGRyLCAmbXAtPm1fc2Ip
Ow0KPj4gLS0gDQo+PiAyLjM5LjMgKEFwcGxlIEdpdC0xNDYpDQo+PiANCj4+IA0KDQo=
