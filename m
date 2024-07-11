Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CD010A36
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2024 23:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720740373; cv=fail; b=ChVlja4MOju8Tihk+cZDC4ZAfrF9Hb96cvmvHWIZxYl8Olh7GPxXc7ThiZsw2hJr7SDVSfF56HkGTT75CSwpZCSgKVrVVzUtWrnoZKiNnBh8g9JmlDqia/2mJ3NdvpPQvGTz+CKbM0A1fWwolPe2UBzpm/yjvvkY1mVm/fE3s1k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720740373; c=relaxed/simple;
	bh=QG0S1RkCI6d3yMB9zZeWYiGGXsH22aeNk5oFa+t1Wyo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fTN2snGbjv/pbXYxkDUyUin3MPglLjQPTNBiK9PgsXnjFXsnKE/LYxFFXbtoO2s5MASnvCMj8WCbuPA5CrorYlJg7+Gx3s29aEFwukXzGPyoJDBA1H6j/eu3jFpcwVCCqeeBIoDk+aqleTy/IWBONyjOwy6/VJ93p49XBl7Mixo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RPaDHL78; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=s9J8/k1X; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RPaDHL78";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="s9J8/k1X"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46BKXZ47006979;
	Thu, 11 Jul 2024 23:26:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=QG0S1RkCI6d3yMB9zZeWYiGGXsH22aeNk5oFa+t1W
	yo=; b=RPaDHL78R0fSxagnHkwNSu8/6KATcOaTdS1Z6Zm8O0wyj2SMvoNQ349K+
	7NEG5iLtsNn4M2PNAKuJogJhoy3b0N/5CPnDrO2h0v9WORXmPlIMz1IqG0GNVMNh
	YKn4qAf4/MRG7D3fdKVewH30hGkpLwSc9kgY4Nv8i2SM7Pw6Omvg5DpJW2CjlJLl
	MhObTL6pA4JlFIUuMNqmlaeQ37wCxrKR2XxWjZ0mt9gT3D5aNgXU27ZXCpLklp1k
	iKq43gacl8ednKlOWKKpcKfGRfkdgPs5PlOFvxM6kgfbl16SpXWfaVG8ElrEWpzb
	Ldfd9+7Vn7disKqcJsgwpMr7G/08g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wkyau15-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 23:26:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46BLb3Y9028784;
	Thu, 11 Jul 2024 23:26:06 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 409vv5ng91-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 23:26:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uy3iNNP6ZFmt99eCPXZ+qkRFbz4XUduJclDf3QJhxXAVzfngnL+MXjhpqL9hMX6CVxcPHnzEdlpP14ukrqnhcxT1XwTVP/vpbxKs/bhRvBFiSxLbo/dxKnuyRXrqkuOtpQq8p8Q7LdIdhJHZhpLV/MGWIXzqmAG/njz/wiPxreoYUMUCUB1lI4/ZJWTyupAKR3faLElPJ5otqqhjHn9ZOHHzTq3HYdq7mZUsRV4LaC8gZbPbfMZm5q95vGa2QunGTeNrDQdtCMnPHjVQAuu+ETNJPwglQsFd+mSTVONJIDvxdszhEQ5ATycptRo7vIN4ucZt5q4YxyMV896EaQ5kSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QG0S1RkCI6d3yMB9zZeWYiGGXsH22aeNk5oFa+t1Wyo=;
 b=xOohn7JfivilBgEu9Xpx8jG+49QLGU3HlyQpjdPnmjlFix2a3Qo/v7pdMEoVMz7WvxNcySXeWgjIERvsVzOVkHymt0h/OElHuxV0x4THm+DGfdHwG/HohitUNWnRaM/DB2sS1NvHX/nh5BBfw12tyTxqXU2rc2YMSEMXlWPSdb38jaz1tuCtRFJYvG3BHc06jJSSbO3Vb2XNRhz+CNgsXuCilWKbzGORLtLsxGXeqDydUQ1cL/YzajLtao2FDtAt7pp+Oz4aOkwzLdt+w5BePhYuuljfxO3whoCg2eDwPVV2DfF4LiaGajvX0o6Pxy9EjqakKxBWO1ZBewpi6x51Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QG0S1RkCI6d3yMB9zZeWYiGGXsH22aeNk5oFa+t1Wyo=;
 b=s9J8/k1XQjtyLIE3MRRue+TmfEhVHQ9gZtpdX0iCMvBujZK9tNfGQTd0LFbmn5PvS7Ua2ou+uRxiB/mg54pMWdIxhDErtgF1NG64MEZYkwWgjgFntmTlInfwrQE92mAiu5aDi7bDLOMXfizCulXUTIuyVLMW0yfMTeDoNnZ6WKk=
Received: from PH0PR10MB5795.namprd10.prod.outlook.com (2603:10b6:510:ff::15)
 by SA1PR10MB6415.namprd10.prod.outlook.com (2603:10b6:806:25a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.23; Thu, 11 Jul
 2024 23:26:04 +0000
Received: from PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27]) by PH0PR10MB5795.namprd10.prod.outlook.com
 ([fe80::69c5:1e7c:5ad:7a27%6]) with mapi id 15.20.7762.016; Thu, 11 Jul 2024
 23:26:04 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: "Darrick J. Wong" <djwong@kernel.org>
CC: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 7/9] spaceman/defrag: sleeps between segments
Thread-Topic: [PATCH 7/9] spaceman/defrag: sleeps between segments
Thread-Index: AQHa0jOvjV+kQND83kGIOOr4jV+8W7Hu3aIAgANRToA=
Date: Thu, 11 Jul 2024 23:26:04 +0000
Message-ID: <E4D4C059-16BC-4975-AEEB-087DC2E131EE@oracle.com>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-8-wen.gang.wang@oracle.com>
 <20240709204606.GU612460@frogsfrogsfrogs>
In-Reply-To: <20240709204606.GU612460@frogsfrogsfrogs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB5795:EE_|SA1PR10MB6415:EE_
x-ms-office365-filtering-correlation-id: 5670ba18-4280-438c-71a6-08dca200d549
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: 
 =?utf-8?B?U0NGRDViSGNzYkpUTGgyZE0wcXduRHlXL200QzduaVc5OCs5Y0xPVkVJVnpk?=
 =?utf-8?B?bnd1VVE1ZHhHYkY5SHZkOUIwaHdSclpWSTVUaFRHQ0tnOTFpSktXZXNpS09U?=
 =?utf-8?B?OVg5T3hWbks4TTVnU3BDa0hSZnVRd1VrWlI0Ym1GOTdzYVYrTERZak9ReE9v?=
 =?utf-8?B?SW1adjFMZW5aU1YrdlBjQ24yQ3NXWTVKby9YVTh5RzZHeTM5d0QrOEtkUnVE?=
 =?utf-8?B?Nzdrc3R2WHdtQWdRVjY2Z2htdmtkQnZScUFQcjFSSG5LbmZIZ2ZTNUMzTmNK?=
 =?utf-8?B?TjBaZTFlRGlQNUMvNExvRWV6MTEvdTh3dVAxRHloL3BDNWdRbUJ3NVpnUHNJ?=
 =?utf-8?B?bWpqdW9xT3FDV2M4UWMvYWVKWWVXYjRpeGNyYkFPWDA4cVZNZXFHMVJncm5T?=
 =?utf-8?B?YXNzRlZFTWNVRm5RNUZWaHZQSDlsRHl6cW53bzRDM3VHZnd2Yk1MVTBySmhs?=
 =?utf-8?B?aENXeWIxWmU0RnRiK1ZFNW9HbzJIOUtxWnlmWnI5SVZYN00zOFpPcXBMRUpW?=
 =?utf-8?B?SDhqNTNSMStsU1NKekNQbWtIbHNDQzlmbWFJaG9CUHMwS1oxeEFLZFBCQlk3?=
 =?utf-8?B?aXFNQ3Q3RFgrNWhBZWllMGs2dWsyWGVKdTRVd3JVTEdVUzR5VDB0NDZCak45?=
 =?utf-8?B?b1dKRVJadTR6WkszN1pIbHdTRXNlMnNnSGNhVGIxVE1zQXYxY3FzZmZBS2hT?=
 =?utf-8?B?dno2cVhlQXYvMTNVMVB4UjFqSmllRG9NZERzcVZtTzVRMnhTNVQ2L3FWdWtY?=
 =?utf-8?B?UVIrUzFHNnpucUpTdWoyRmt5NUMxSFNaOVdUZ3R3SUFER3ZIYVFOM3d2OEVK?=
 =?utf-8?B?RG1MOElLM3N2ZVlZSGo5a05TSHI1TGh0MURFWnVGN2UxelU4NHl6MTAzcnR2?=
 =?utf-8?B?aExKeDlwOW9MM0w1OE5DUTR2K0MxV3lHcTd4K2FCNzNkeE9lQW1Kamw4Ukdi?=
 =?utf-8?B?UU9lRFhmK3ZXS1dTb2FSK3UybkpRdmRCYVV0WG9QSzlNRE1hNkVUbnZ3TWpX?=
 =?utf-8?B?YndqZTJzcTg2dW91a1VyVDU5OHQ1SlNsTGVDWGNTMUJzT1VFK0hteXMwUkJp?=
 =?utf-8?B?SGxUanBmQ2dKbk0xckdRcmFOMUlxdVJBWDVLc0JGU2d4NEVnT0lCVlVYNUND?=
 =?utf-8?B?VTlPYlBBRlVTalRpT0Nhd3lzUTZSUGc1VW56d2oraGx2VzN0QXNUT3dOdDVG?=
 =?utf-8?B?RjJsY1ROZERnUGl1M2FpbUZBY2lWRG9RYm40VGFBVW1pVDE4WXFtcDB1MkFD?=
 =?utf-8?B?VkFrRTd5VEZvZ0Q1STdpUGhoeHhFM3Q4NjZRTmF2bWhkMmROSHdZb1VTSnJa?=
 =?utf-8?B?dEFLQWZjWkIvUmFYMnV6UlVTOHdsUlljT1NRWC92bExCTWdQYVBzOTFFT3A1?=
 =?utf-8?B?d1FjczBaTnNvT2hWQlkrTjZTRThkbkpXRlRJRjBYc0R6TnJMMmNFaWhHbUZ2?=
 =?utf-8?B?OWVQa1YvQ2ZXb0JkeWFCTlVKZjN1YTJKeXc0K1U1UU1PbE1ZRkcxcHNLd25Z?=
 =?utf-8?B?eXRhZXVYc2MyVVptRGMycnFXNGN2MllkUEhWa2hyZ01WK3FrcUExY2dFcE50?=
 =?utf-8?B?VDdNNDVLWHRpd2VVcWJ1T3NyTW8zSkJGWU5kTGw5R1hYQlBlQ1FxVEQ2SzB5?=
 =?utf-8?B?MkNGUHR3YWRUQnJ4eElHSVVYeklwb1VpaG9qaG0rU3dFOUtxVEN0WWJRSUE5?=
 =?utf-8?B?S3oyeE9maTdlNUFHejhmWnR0czRqUDBLNXE2cGJHZE9BL3ordHdVM09wWTR1?=
 =?utf-8?B?MGJRNUtkbVVPeStKeVBWeWVXVk5weC90emNlbGRzbnc5UURLYXhIU0MyRGt3?=
 =?utf-8?B?M29PSnh1SXVzL0JEN3RoMjB6bXMxT1BVYTM2cHlqOUF6UGQ3dXlMZDBjSisw?=
 =?utf-8?B?S3l0RHJiTUI3dzZHYUhJZDAvV3dJMk5HR0JqSForU1lkVmc9PQ==?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?NVdXL3BLOHdJM0JKYS82d2M4U05vR1lKaE1Xb3orZjlTbkg4VkFDVVovVWll?=
 =?utf-8?B?NEEvZHkwS3dMY1VtZWI3Y044RFl2dUNNSWU3Z3VZMHF6bjFGL0dUVU5nZ3Qw?=
 =?utf-8?B?SWVxeFErY094SDhvRENuV0l0V0xqYURyWWJKM2tOc2lNTDBuUGFWL0c3bDB3?=
 =?utf-8?B?cWhhbmMyaG9vSW5tU01qQXNJMGlwSlhOQkhRMnJFSkoreDJ1emRRVzdaRkc2?=
 =?utf-8?B?NDZOMVUxK3lISis2WXY0ZFRjL1ltaE8yL1JLOFVLb2dPeGxDbHNOL2w2dTgw?=
 =?utf-8?B?a3l6bHV0bVIyOFNjTHVTYTZJSmJUaVo0OFNnMGJHSUVQTUt6RitoL1JCNlZZ?=
 =?utf-8?B?TGRNa3QwY2t4L25VUGJuQllITmRETDRaejBhdnVLbzUxc3VCcVZxNmNRanR4?=
 =?utf-8?B?eVhRNmVENGFDMTJoRk9YYzZpcUFTMnVGZnoyWU9VSkZpRWU3cW50WkwvNnpy?=
 =?utf-8?B?dFliSkovZm1XM1FzVzNsbTUrckgyVWdsRDVNS1R2cFN4N05KSXNkZVBrTFoy?=
 =?utf-8?B?am9pb0djYkdRd0ljWHJSSUg3aXhlaFBMbWxIazNjNEhMNUNXK2VkMi9VQm1l?=
 =?utf-8?B?ejN1bHhaYlJBbDhXL281U3VnSmJ1Ykh0YXUvS3M1cEVWNTJOUFdGWm9zM21u?=
 =?utf-8?B?RHVkRUEweFdRaFZCUkttbGdWSm9HQ0Q1YjFadDF6RUdzV3RKM0pwdWZhTU1w?=
 =?utf-8?B?WSsxR0tkaFNrUHBTWWFlOU1velNjZGsrQmlUUTVSRFhuWkhEQkhxWnVPSExp?=
 =?utf-8?B?aVdLTEQ1TUpwcm1SQTJNL0VwejZNOTN1VE55enZjaU1IWHFKYzRrTWZneTBJ?=
 =?utf-8?B?dVFHUXlHSjdEL2tRZG5KSTFQZVVEWkp4NmswNk9XNzByejFaYkhVbVlEVDZY?=
 =?utf-8?B?b09TUUZFRFA2Vm91SzlJcEZERW1tQXB2bDlZQW5VUXcrbVoxLzY5TFU0SVJJ?=
 =?utf-8?B?UmM3S2t4Q0sxeFZ1S2xGY0ExTDBJdkx0Y0w0TUM1YU14c1MyNFJXSkxEbTVY?=
 =?utf-8?B?WlU4S2NTVmFCSklPdlEvTWY4Yy9jck93THdHQzlVa2UxczRxalZrTTVQZkxS?=
 =?utf-8?B?M01TK000ZlFvbmRVYnFtY3NhTGV4VHdGL0dyRkQwM0VmYS9UNUVUTEpDa3lO?=
 =?utf-8?B?RTRVR1FEVTl1NmlySGZGd2o4NHpxbWpTenlXdFZWTUo2UTJBNUpCY2tYSmJI?=
 =?utf-8?B?Mlg1UUNGbzM1dDZhL2pVT1lqYjk1SXN6TndOcHRiTjBCdDJ1a0lnbTN4alpD?=
 =?utf-8?B?Sit5UlJDSkt6SzdNVk9Cc1hySWhESHFTYjJxeXk1WSsrMGQ1OHltYzBUbklk?=
 =?utf-8?B?RG56dTdZZDVTeDluT2EyLzBaRHdzTDlYK1V2aWMzR0h6T0xTa1FzQWRnMXRn?=
 =?utf-8?B?Nlh2Yk1xVVQrcnF4TVhUMTIwOXMycnVoeHVhN1RHZzdIS0xBS3NaUnRIbDVK?=
 =?utf-8?B?OFJnOWJaVHgyL0NxN1pXMzZXYXg1Nm9uQ3c4TVhOamRpMEdBeUdSWmZyanRr?=
 =?utf-8?B?T3FpTnNFSWNJWit2NjNYSGJweXZmMlhvTU45OVV4TjE3QjBIYk5DSHdsNkRw?=
 =?utf-8?B?TmlETWJYenB6QTRsZC9WYmdLRWtLRUk1S0tlSjdIZU5TQ0FNN3drMG9LdkZv?=
 =?utf-8?B?K0NDbVQwTDBuWFY0Yis4ajB3OEErUDFlMDFNeDkybHNpQU5CMjhYRlVLeVBn?=
 =?utf-8?B?b3UyWkhNeXM0NjZEWnhBOTN2QTVTSEFLM1BqMndkM0VTVVBCSFVyNWRsbEJs?=
 =?utf-8?B?eFlWbzNPanVwZDVjUEd1SWJDa1JRV3IrTDlOSFlIa1VnK0pvZlFrZk1NdytK?=
 =?utf-8?B?SUJsbXR5b1VmcGtmZ1JIRjdSTDVqZWJVbVkvcTNNSXlQNWtKSit5WG41YjRs?=
 =?utf-8?B?cUhBZlBGOWlBY2xXamMyck1GTE1HMlBtWE1Ha28ySFhxZGdvTmRBemRFSlZW?=
 =?utf-8?B?cmhRYVVYbDRDbFozOUczTGFaOGo3L0d5K3BidXNncUN0UXB3Z1lmNHBmOUlj?=
 =?utf-8?B?NTdYdUxzSU13bVQzcFBDZ0RHdzgxYkNrd3dCblJ0Zko3OFVZT0toUVd4UXZG?=
 =?utf-8?B?eUFRdzdITDVuSG5TN3dLbFZEZVUvb0lJbEk4eWZZOFJkVlUzeXB1SDA2bE5z?=
 =?utf-8?B?Z2djWjhiZ2lDTTlvTVFDVW84aXVHOWh0RjhBaGJZY1BvZU1Jek9XZ3BJelU0?=
 =?utf-8?B?U2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <383F94654ACF344783D54DFD2A86D90E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	CG6rqp8Gsi3Izc74JrtGGaGGDUEm5GBowwzKqcymz2owcK8J+yVZsh/b1+xcr/j6PKQrJT9xLROEsxN/WwjtbqPSuub7FAWxWEcUe1nk86HdoN7my/ET/f/+BfXhzJZ2znI/YXomzoU5goL4n/OYgspfoxSoWOUvDFXz4PQ91Mg+BhRv6Z0wgCbDDBgakPG5iwo6aFhvxQ/yv7BlVoQrUfQce/xaBmk4imgu8BqGTQvenJHopWD0VZfbF9rqw256IEQJnmfnC2SZ83KphBue+Hyyy9bzmn2Wl1/sb+9VKeVVCs1GEweR/tjEX5m3YWT0sf2vvIBnJqPUnNiJPAr2gXECzBadlQ44ZtU5mlT0widYtyNr1we67HFYrQtc4BxxpTi3GvYqNqsr5LLGfg1dEzdmZCEibk+mzWHrECC4WVRLRQO80MZbOSH90NSbUTuz/ItSFiPhSUlfbBjYNNTI8iBxngs+V6ItMcTIu45lIrZzUGLSlYU/es2E6p/+jhdCu8rEnrXzbcvhj92Dkngcq7SLKcQdFQDi7117gl0UUeRfHqQN1WVfKCmkyZR0miqZVneBnd8i5eLTaexYXjZGuLx+L6XDIQOIA1gZGla3Tow=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5670ba18-4280-438c-71a6-08dca200d549
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2024 23:26:04.1487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I5Y6RRJRQoxFspwMsKsNgFVgnKi1+2hsMiaVz5r4yClfFdIopR1MFeDJ7u6IaqY7enXb5JVhv/dpqa7gzGPiO4I20vnNNqkocOOYFNsvUtU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6415
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-11_17,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407110166
X-Proofpoint-ORIG-GUID: OGeXr_H8U2YA1ntuEPfOU0Z6pi5waXyE
X-Proofpoint-GUID: OGeXr_H8U2YA1ntuEPfOU0Z6pi5waXyE

DQoNCj4gT24gSnVsIDksIDIwMjQsIGF0IDE6NDbigK9QTSwgRGFycmljayBKLiBXb25nIDxkandv
bmdAa2VybmVsLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBUdWUsIEp1bCAwOSwgMjAyNCBhdCAxMjox
MDoyNlBNIC0wNzAwLCBXZW5nYW5nIFdhbmcgd3JvdGU6DQo+PiBMZXQgdXNlciBjb250b2wgdGhl
IHRpbWUgdG8gc2xlZXAgYmV0d2VlbiBzZWdtZW50cyAoZmlsZSB1bmxvY2tlZCkgdG8NCj4+IGJh
bGFuY2UgZGVmcmFnIHBlcmZvcm1hbmNlIGFuZCBmaWxlIElPIHNlcnZpY2luZyB0aW1lLg0KPj4g
DQo+PiBTaWduZWQtb2ZmLWJ5OiBXZW5nYW5nIFdhbmcgPHdlbi5nYW5nLndhbmdAb3JhY2xlLmNv
bT4NCj4+IC0tLQ0KPj4gc3BhY2VtYW4vZGVmcmFnLmMgfCAyNiArKysrKysrKysrKysrKysrKysr
KysrKystLQ0KPj4gMSBmaWxlIGNoYW5nZWQsIDI0IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25z
KC0pDQo+PiANCj4+IGRpZmYgLS1naXQgYS9zcGFjZW1hbi9kZWZyYWcuYyBiL3NwYWNlbWFuL2Rl
ZnJhZy5jDQo+PiBpbmRleCBiNWM1YjE4Ny4uNDE1ZmU5YzIgMTAwNjQ0DQo+PiAtLS0gYS9zcGFj
ZW1hbi9kZWZyYWcuYw0KPj4gKysrIGIvc3BhY2VtYW4vZGVmcmFnLmMNCj4+IEBAIC0zMTEsNiAr
MzExLDkgQEAgdm9pZCBkZWZyYWdfc2lnaW50X2hhbmRsZXIoaW50IGR1bW15KQ0KPj4gICovDQo+
PiBzdGF0aWMgbG9uZyBnX2xpbWl0X2ZyZWVfYnl0ZXMgPSAxMDI0ICogMTAyNCAqIDEwMjQ7DQo+
PiANCj4+ICsvKiBzbGVlcCB0aW1lIGluIHVzIGJldHdlZW4gc2VnbWVudHMsIG92ZXJ3cml0dGVu
IGJ5IHBhcmFtdGVyICovDQo+PiArc3RhdGljIGludCBnX2lkbGVfdGltZSA9IDI1MCAqIDEwMDA7
DQo+PiArDQo+PiAvKg0KPj4gICogY2hlY2sgaWYgdGhlIGZyZWUgc3BhY2UgaW4gdGhlIEZTIGlz
IGxlc3MgdGhhbiB0aGUgX2xpbWl0Xw0KPj4gICogcmV0dXJuIHRydWUgaWYgc28sIGZhbHNlIG90
aGVyd2lzZQ0KPj4gQEAgLTQ4Nyw2ICs0OTAsNyBAQCBkZWZyYWdfeGZzX2RlZnJhZyhjaGFyICpm
aWxlX3BhdGgpIHsNCj4+IGludCBzY3JhdGNoX2ZkID0gLTEsIGRlZnJhZ19mZCA9IC0xOw0KPj4g
Y2hhciB0bXBfZmlsZV9wYXRoW1BBVEhfTUFYKzFdOw0KPj4gc3RydWN0IGZpbGVfY2xvbmVfcmFu
Z2UgY2xvbmU7DQo+PiArIGludCBzbGVlcF90aW1lX3VzID0gMDsNCj4+IGNoYXIgKmRlZnJhZ19k
aXI7DQo+PiBzdHJ1Y3QgZnN4YXR0ciBmc3g7DQo+PiBpbnQgcmV0ID0gMDsNCj4+IEBAIC01NzQs
NiArNTc4LDkgQEAgZGVmcmFnX3hmc19kZWZyYWcoY2hhciAqZmlsZV9wYXRoKSB7DQo+PiANCj4+
IC8qIGNoZWNrcyBmb3IgRW9GIGFuZCBmaXggdXAgY2xvbmUgKi8NCj4+IHN0b3AgPSBkZWZyYWdf
Y2xvbmVfZW9mKCZjbG9uZSk7DQo+PiArIGlmIChzbGVlcF90aW1lX3VzID4gMCkNCj4+ICsgdXNs
ZWVwKHNsZWVwX3RpbWVfdXMpOw0KPj4gKw0KPj4gZ2V0dGltZW9mZGF5KCZ0X2Nsb25lLCBOVUxM
KTsNCj4+IHJldCA9IGlvY3RsKHNjcmF0Y2hfZmQsIEZJQ0xPTkVSQU5HRSwgJmNsb25lKTsNCj4+
IGlmIChyZXQgIT0gMCkgew0KPj4gQEAgLTU4Nyw2ICs1OTQsMTAgQEAgZGVmcmFnX3hmc19kZWZy
YWcoY2hhciAqZmlsZV9wYXRoKSB7DQo+PiBpZiAodGltZV9kZWx0YSA+IG1heF9jbG9uZV91cykN
Cj4+IG1heF9jbG9uZV91cyA9IHRpbWVfZGVsdGE7DQo+PiANCj4+ICsgLyogc2xlZXBzIGlmIGNs
b25lIGNvc3QgbW9yZSB0aGFuIDUwMG1zLCBzbG93IEZTICovDQo+IA0KPiBXaHkgaGFsZiBhIHNl
Y29uZD8gIEkgc2Vuc2UgdGhhdCB3aGF0IHlvdSdyZSBnZXR0aW5nIGF0IGlzIHRoYXQgeW91IHdh
bnQNCj4gdG8gbGltaXQgZmlsZSBpbyBsYXRlbmN5IHNwaWtlcyBpbiBvdGhlciBwcm9ncmFtcyBi
eSByZWxheGluZyB0aGUgZGVmcmFnDQo+IHByb2dyYW0sIHJpZ2h0PyAgQnV0IHRoZSBoZWxwIHNj
cmVlbiBkb2Vzbid0IHNheSBhbnl0aGluZyBhYm91dCAib25seSBpZg0KPiB0aGUgY2xvbmUgbGFz
dHMgbW9yZSB0aGFuIDUwMG1zIi4NCg0KVGhpcyBpcyBhbiBvcHRpb25hbCBzbGVlcCBmb3IgdmVy
eSBzbG93IEZTIHdpdGggQ0xPTkUgdGFrZXMgbG9uZy4NCkFjdHVhbGx5LCB3ZSBkb27igJl0IGZh
bGwgaW50byB0aGlzIGNhc2UgaW4gb3VyIGxvY2FsIHRlc3RzLg0KDQpUaGUgbWFpbiBzbGVlcCBp
cyBhdCBhYm92ZToNCg0KIDQwICsgICAgICAgICAgICAgICBpZiAoc2xlZXBfdGltZV91cyA+IDAp
DQogNDEgKyAgICAgICAgICAgICAgICAgICAgICAgdXNsZWVwKHNsZWVwX3RpbWVfdXMpOw0KDQo+
IA0KPj4gKyBpZiAodGltZV9kZWx0YSA+PSA1MDAwMDAgJiYgZ19pZGxlX3RpbWUgPiAwKQ0KPj4g
KyB1c2xlZXAoZ19pZGxlX3RpbWUpOw0KPiANCj4gVGhlc2UgZGF5cywgSSB3b25kZXIgaWYgaXQg
bWFrZXMgbW9yZSBzZW5zZSB0byBwcm92aWRlIGEgQ1BVIHV0aWxpemF0aW9uDQo+IHRhcmdldCBh
bmQgbGV0IHRoZSBrZXJuZWwgZmlndXJlIG91dCBob3cgbXVjaCBzbGVlcGluZyB0aGF0IGlzOg0K
PiANCj4gJCBzeXN0ZW1kLXJ1biAtcCAnQ1BVUXVvdGE9NjAlJyB4ZnNfc3BhY2VtYW4gLWMgJ2Rl
ZnJhZycgL3BhdGgvdG8vZmlsZQ0KPiANCj4gVGhlIHRyYWRlb2ZmIGhlcmUgaXMgdGhhdCB3ZSBh
cyBhcHBsaWNhdGlvbiB3cml0ZXJzIG5vIGxvbmdlciBoYXZlIHRvDQo+IGltcGxlbWVudCB0aGVz
ZSBjbHVua3kgc2xlZXBzIG91cnNlbHZlcywgYnV0IHRoZW4gb25lIGhhcyB0byB0dXJuIG9uIGNw
dQ0KPiBhY2NvdW50aW5nIGluIHN5c3RlbWQgKGlmIHRoZXJlIGV2ZW4gL2lzLyBhIHN5c3RlbWQp
LiAgQWxzbyBJIHN1cHBvc2Ugd2UNCj4gZG9uJ3Qgd2FudCB0aGlzIHByb2dyYW0gZ2V0dGluZyB0
aHJvdHRsZWQgd2hpbGUgaXQncyBob2xkaW5nIGEgZmlsZQ0KPiBsb2NrLg0KPiANCg0KWWVzLCB3
ZSBob3BlIGxlc3MgbG9ja2luZyB0aW1lIGFzIHBvc3NpYmxlLg0KDQpUaGlzIHNsb3duZXNzIGlz
IG1haW5seSBjb21pbmcgZnJvbSBzbG93IGRpc2tzLiBBcyB3ZSB0ZXN0ZWQsIHdoZW4gcGFnZSBj
YWNoZQ0KSXMgZW1wdHksIENQVSB1c2FnZXMgaXMgb25seSBhdCBhYm91dCA2JSBvbiBteSBWTSAo
dGhlIHJlYWwgcGh5c2ljYWwgd291bGQgYmUgc3BpbmRsZSBkaXNrKS4NCkl0IHdvdWxkIGJlIGhp
Z2hlciBmb3IgTlZNRXMuICANCknigJlkIGxpa2UgdG8gcHJvdmlkZSB1c2VyIGEgd2F5IHRvIG1h
a2UgYmFsYW5jZSwgc2F5IGxvbmdlciBzbGVlcCB0aW1lIGJldHdlZW4gc2VnbWVudHMgdG8gbWFr
ZSBJTyBzZXJ2aWNlZCBiZXR0ZXIuDQoNClRoYW5rcywNCldlbmdhbmcNCg0KPiAtLUQNCj4gDQo+
PiArDQo+PiAvKiBmb3IgZGVmcmFnIHN0YXRzICovDQo+PiBucl9leHRfZGVmcmFnICs9IHNlZ21l
bnQuZHNfbnI7DQo+PiANCj4+IEBAIC02NDEsNiArNjUyLDEyIEBAIGRlZnJhZ194ZnNfZGVmcmFn
KGNoYXIgKmZpbGVfcGF0aCkgew0KPj4gDQo+PiBpZiAoc3RvcCB8fCB1c2VkS2lsbGVkKQ0KPj4g
YnJlYWs7DQo+PiArDQo+PiArIC8qDQo+PiArICAqIG5vIGxvY2sgb24gdGFyZ2V0IGZpbGUgd2hl
biBwdW5jaGluZyBob2xlIGZyb20gc2NyYXRjaCBmaWxlLA0KPj4gKyAgKiBzbyBtaW51cyB0aGUg
dGltZSB1c2VkIGZvciBwdW5jaGluZyBob2xlDQo+PiArICAqLw0KPj4gKyBzbGVlcF90aW1lX3Vz
ID0gZ19pZGxlX3RpbWUgLSB0aW1lX2RlbHRhOw0KPj4gfSB3aGlsZSAodHJ1ZSk7DQo+PiBvdXQ6
DQo+PiBpZiAoc2NyYXRjaF9mZCAhPSAtMSkgew0KPj4gQEAgLTY3OCw2ICs2OTUsNyBAQCBzdGF0
aWMgdm9pZCBkZWZyYWdfaGVscCh2b2lkKQ0KPj4gIiAtZiBmcmVlX3NwYWNlICAgICAgLS0gc3Bl
Y2lmeSBzaHJldGhvZCBvZiB0aGUgWEZTIGZyZWUgc3BhY2UgaW4gTWlCLCB3aGVuXG4iDQo+PiAi
ICAgICAgICAgICAgICAgICAgICAgICBYRlMgZnJlZSBzcGFjZSBpcyBsb3dlciB0aGFuIHRoYXQs
IHNoYXJlZCBzZWdtZW50cyBcbiINCj4+ICIgICAgICAgICAgICAgICAgICAgICAgIGFyZSBleGNs
dWRlZCBmcm9tIGRlZnJhZ21lbnRhdGlvbiwgMTAyNCBieSBkZWZhdWx0XG4iDQo+PiArIiAtaSBp
ZGxlX3RpbWUgICAgICAgLS0gdGltZSBpbiBtcyB0byBiZSBpZGxlIGJldHdlZW4gc2VnbWVudHMs
IDI1MG1zIGJ5IGRlZmF1bHRcbiINCj4+ICIgLW4gICAgICAgICAgICAgICAgIC0tIGRpc2FibGUg
dGhlIFwic2hhcmUgZmlyc3QgZXh0ZW50XCIgZmVhdHVlLCBpdCdzXG4iDQo+PiAiICAgICAgICAg
ICAgICAgICAgICAgICBlbmFibGVkIGJ5IGRlZmF1bHQgdG8gc3BlZWQgdXBcbiINCj4+ICkpOw0K
Pj4gQEAgLTY5MSw3ICs3MDksNyBAQCBkZWZyYWdfZihpbnQgYXJnYywgY2hhciAqKmFyZ3YpDQo+
PiBpbnQgaTsNCj4+IGludCBjOw0KPj4gDQo+PiAtIHdoaWxlICgoYyA9IGdldG9wdChhcmdjLCBh
cmd2LCAiczpmOm4iKSkgIT0gRU9GKSB7DQo+PiArIHdoaWxlICgoYyA9IGdldG9wdChhcmdjLCBh
cmd2LCAiczpmOm5pIikpICE9IEVPRikgew0KPj4gc3dpdGNoKGMpIHsNCj4+IGNhc2UgJ3MnOg0K
Pj4gZ19zZWdtZW50X3NpemVfbG10ID0gYXRvaShvcHRhcmcpICogMTAyNCAqIDEwMjQgLyA1MTI7
DQo+PiBAQCAtNzA5LDYgKzcyNywxMCBAQCBkZWZyYWdfZihpbnQgYXJnYywgY2hhciAqKmFyZ3Yp
DQo+PiBnX2VuYWJsZV9maXJzdF9leHRfc2hhcmUgPSBmYWxzZTsNCj4+IGJyZWFrOw0KPj4gDQo+
PiArIGNhc2UgJ2knOg0KPj4gKyBnX2lkbGVfdGltZSA9IGF0b2kob3B0YXJnKSAqIDEwMDA7DQo+
IA0KPiBTaG91bGQgd2UgY29tcGxhaW4gaWYgb3B0YXJnIGlzIG5vbi1pbnRlZ2VyIGdhcmJhZ2U/
ICBPciBpZiBnX2lkbGVfdGltZQ0KPiBpcyBsYXJnZXIgdGhhbiAxcz8NCj4gDQo+IC0tRA0KPiAN
Cj4+ICsgYnJlYWs7DQo+PiArDQo+PiBkZWZhdWx0Og0KPj4gY29tbWFuZF91c2FnZSgmZGVmcmFn
X2NtZCk7DQo+PiByZXR1cm4gMTsNCj4+IEBAIC03MjYsNyArNzQ4LDcgQEAgdm9pZCBkZWZyYWdf
aW5pdCh2b2lkKQ0KPj4gZGVmcmFnX2NtZC5jZnVuYyA9IGRlZnJhZ19mOw0KPj4gZGVmcmFnX2Nt
ZC5hcmdtaW4gPSAwOw0KPj4gZGVmcmFnX2NtZC5hcmdtYXggPSA0Ow0KPj4gLSBkZWZyYWdfY21k
LmFyZ3MgPSAiWy1zIHNlZ21lbnRfc2l6ZV0gWy1mIGZyZWVfc3BhY2VdIFstbl0iOw0KPj4gKyBk
ZWZyYWdfY21kLmFyZ3MgPSAiWy1zIHNlZ21lbnRfc2l6ZV0gWy1mIGZyZWVfc3BhY2VdIFstaSBp
ZGxlX3RpbWVdIFstbl0iOw0KPj4gZGVmcmFnX2NtZC5mbGFncyA9IENNRF9GTEFHX09ORVNIT1Q7
DQo+PiBkZWZyYWdfY21kLm9uZWxpbmUgPSBfKCJEZWZyYWdtZW50IFhGUyBmaWxlcyIpOw0KPj4g
ZGVmcmFnX2NtZC5oZWxwID0gZGVmcmFnX2hlbHA7DQo+PiAtLSANCj4+IDIuMzkuMyAoQXBwbGUg
R2l0LTE0NikNCg0KDQo=
