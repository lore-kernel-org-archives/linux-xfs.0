Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9A1AD31;
	Wed, 16 Oct 2024 00:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729037516; cv=fail; b=CIXdenDn1v8Y2jUqODyTYPoXyOMk4ONp5xNgM0/hizBkOGqGB/gnxZAPobctlAy5crxCRrTW8ZilqjTvMiqkR1bd8Uq1+9g3t777c/iNMOB+lNelV5Bf0Z3pgmyJUTKJaK/NJ5J70GavUj6BMsNVASOVsyTBa4xi9fXIFeWap1c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729037516; c=relaxed/simple;
	bh=4PB/xfDY+Y/6SrJPTBASc1v91Ryvnf1Sc6zqjIzAvWg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M0PmK+vw038Jcet1ePme+0YKgJwqefiwxWCVmi/dpCW/EUPYnMJ/g4DMn1GusSSjm9JuvTLLp9UqPT3ZtAoTh9QYWN7pRgnng3He8X4aCOvUqPhDsJ0vQTMEG/A2/bvKGD82/x0pSzj0aJSKEJJlAyw7MuIAyzHAL3PBkjvoy6E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=c+BXSj5a; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fqQvN/zA; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c+BXSj5a";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fqQvN/zA"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FHtgWP019350;
	Wed, 16 Oct 2024 00:11:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=L9UPSOEoKnhh6tf2DU773pm8/ov9rui1NHaRdEVH+Vc=; b=
	c+BXSj5aYdxK9KR5ztcVWH+jgrXtHyoVs0O8ZeQqOgGkyHpRSVl7CYip7iarG9j5
	V1BfQakxJ1YhAzsd+tTGYlyYqpgAs2wzCjsLxmpCAznJKR8mclhQ608pCyrKa+SE
	f7H345TVf1HvVxnFj1KZTm6FVd1ehx40lcYqRY1Euq7aF9rEde6sF585/CR07uZY
	70MqsEs3t2otEo2AdClNyVLQL+Qx2k/CUz/FBzDRNblWflE0SFCk9qlCkZ5nMCpE
	xdtJAbYaL3LnVTKvJYB6ar+mfO+ymMFrtfehcAbqYp9aCtP+LDu7k3gw070FaxBE
	zqDbMz51MbPzyNB0U0Htpg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427gq7jhq6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:11:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49FLKOWT020102;
	Wed, 16 Oct 2024 00:11:36 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2043.outbound.protection.outlook.com [104.47.70.43])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 427fj85maa-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 00:11:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l5zMwxoTEAd6WOndoRrsx9V1mCrE6U0uVxXvwc+l5j/7yQ3fBeQqDrwQVCRBkoCm3cU5XgCgXIr5adM3xXwr6Td5Sb3Jme5Fgwte7VZAaqFsFax8SuuaVCfaKQWxRP75+EocC7LbiMUGkoexL1/7BT0Uh6XPRGbf8jdvSzkYaKBFDITKPwi31T/1JHqpGdsylCMxcPsk948CmBGOs/onVtg3NTx66EBy+HAm8SZ0RbmD7qd8fzYeEYCm8KN3npHlMb+MYGx59eIWz0n4q4Q0Xi2VHk7H4TeWHdOI4j16zt1uK9vRgQaCIV0rXdklURut1ZIRghwX3FjgMDGfLcauBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L9UPSOEoKnhh6tf2DU773pm8/ov9rui1NHaRdEVH+Vc=;
 b=gwfSKxwdHb0ShnQz7Ef0YHDnep8PnsWodgXPlU6YL/vOXzUdJJAeADMkEJAZGBHlmPFupUg02G42nubAXfklVZICeAOAshAWpYwG/vOJ6Q3ZHPEo0OD+7H3Cd6gmc6w3qsLTSSC7YiZZGC+oCP9CHdYk2+FZT9/tfsJQt9MlgtldN+L/Rt6wBKuOy2xgNAu4bNMXl7ysf3p3JKu+2xQZR50fzqJkmesOP4vajtKi3nCqd2PFupl+igTlH33Sd9aOj4COtRO/o+zlfLBE2WRJ/KNZ0lCh1XYC7LxOy94aA19WymCWwA13/hJoq2b411oQCP0B3oR7feG/4bedc52atQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9UPSOEoKnhh6tf2DU773pm8/ov9rui1NHaRdEVH+Vc=;
 b=fqQvN/zAEHMM3MnogmxpjBckVp0apaM26baH2GduAl9QSClNJ2MSKgjI3f74/yEjjmXazHhyjoEi7XUPKdkYZOmGS3V2pTxyPi3lTYRcNW7fZiqXMGfxLtGyrhtPp92dOpJTvwSFfgliVKKVfmyOUJZBL+c95MqqV3h4zQXQTNQ=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by SN7PR10MB6977.namprd10.prod.outlook.com (2603:10b6:806:344::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Wed, 16 Oct
 2024 00:11:33 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8069.016; Wed, 16 Oct 2024
 00:11:33 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 01/21] xfs: fix error returns from xfs_bmapi_write
Date: Tue, 15 Oct 2024 17:11:06 -0700
Message-Id: <20241016001126.3256-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241016001126.3256-1-catherine.hoang@oracle.com>
References: <20241016001126.3256-1-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR06CA0056.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::33) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|SN7PR10MB6977:EE_
X-MS-Office365-Filtering-Correlation-Id: 51e14aa8-b83c-4eba-f0ef-08dced771785
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bmhoVE0xL1Q1T1Q0dkpLK2dxY1Fqa1VrbmNOaXJQYjZwS0FjdkFGL3YzQ3cy?=
 =?utf-8?B?QjZkMHJrajQvYlpXVVQ4VWYwQ3JFVlk2eFgxNTBiblZzR0JRRnhxbXA1MWts?=
 =?utf-8?B?eW5NZThFY0dwYWtWRFpKcUFmcXRMT3RnV3BmTWhRbjVVRVFqRU01VDhMU1gv?=
 =?utf-8?B?azlaaHZWYXVSaTJ3djhyQnBacTZFQ1pPc0Rtc0tMOTE2aHVoWktyQzViamNm?=
 =?utf-8?B?V2JxWnovQ0prQWdyVGRrL0EySjI2Q1I2eDBydDViNG94WTdRekZueTdPc3p4?=
 =?utf-8?B?dnNveUpTd1dnY1Z2YlpjVmtVUDM1YmZTZFdXTXlFcDZRNFg4eEtCWlJzNHAv?=
 =?utf-8?B?b1BXNmc3Uk9JbEpRN1pZYkFPYUVnQ0N6Ui90Vm8wbitIWjBIamFpZEN5YVFx?=
 =?utf-8?B?ZkFMc2swNldGeFJ0dUFQVndsL2wycXZGVVNicVBlZkJkajBKUDRmZjkzbUI4?=
 =?utf-8?B?WmlVTVA2YXovOUZnd0pQbmJyOCtEUUhUbVV0WGwzcTkwZTJaSi9PVXdhSjhq?=
 =?utf-8?B?b0NNZnZoV1VvT2EzWUtqaWhidjByUmtFdTVkdDExOEdBNXVkcmR5MXN0cUlH?=
 =?utf-8?B?M2pTQ0M5L2duVnhjd3h2ejFQL290K2pnTlpqOFBPWGplVlJCOExOWllMNW5O?=
 =?utf-8?B?R2FhaDExcmJTZmFkSmkySXQ0Wk5Ic1hTbTUvMjdjTW9QbVFBTDFOOHBzNzNE?=
 =?utf-8?B?emZlRTE3RnlMaHpLelMvbzllSkp2Vm51ci9ibVhYQ0ViaERDc2w2bmFYdGc1?=
 =?utf-8?B?NklOMnp3WjFMTzdka0kyV2YrOUVrT1BtZ0NrMEVqTzJyVzluZ3ZhL1FmTmRM?=
 =?utf-8?B?RFM0WFN0MnJBK2xpR3FJWkI1bDlxV05xck1FUEhXNk5vRllvajJwazY3eXJP?=
 =?utf-8?B?NnFESC92Nkx4ZG1ONzg1d3d1YjZ1U0J3ekFJdEVaZHZaOXUyUGtqd0d5WEY5?=
 =?utf-8?B?UHN3Skw2cGJLWC9uN3Znams1N1ROenhrTlNUMG1veWpRZkpCVkRHZGJqcmNS?=
 =?utf-8?B?d0RodE5ORkFLa0VqMTNrcW9uMG1tWWl6L216MG1LZkFTRWswd2tuUGgwcXVS?=
 =?utf-8?B?ckgwM1BJUDhiZDZqbzZNTE9ocVlENXpCMks4QkRyODBuVUJjUkhBMFFpeHpw?=
 =?utf-8?B?L2FoTHM3c3EycmNieStzQ055QXp1MXg5dlhoT2x1Z3pDb1loeHlrZEc2elZV?=
 =?utf-8?B?NnZQMFYzb01iVmdoWWZzaFI0T2NMcVhvU0dvdXEzTmZuMTRvNEFiM21LZFpD?=
 =?utf-8?B?Um5aS2R5bzNuZlRRcE1wWFp0dUhRemYwNkxaSlcvelRLTytBc3ZrdjcwNEU0?=
 =?utf-8?B?RHJmNzFlY3hCMmN6cW1vWU9jcFlhUk9aSDNNM0hPYm10M2lwazJiT0dZOE9C?=
 =?utf-8?B?L1NvMm1wNVhxRi9ZR090RkdpeVRERFFqb1BTZGowTWQyaCtBWFNPS0dRcVRh?=
 =?utf-8?B?ZG8zdWtyLzFJU3ZNdVZvS3YvS1N5eHJSNmpzQlowa3lFQ2JYV3hPMnh5YTNY?=
 =?utf-8?B?T2lyeVkxMGprcERQNHZEZExqbkIrVTJDbFZoMTgwdFgrL2RmV3h0a1lEanpB?=
 =?utf-8?B?TjVZeW9MOFhjYU4vdlhNMnpvb013SE9QTEFmM1pMdXlEZFF6bFNtMGllRjBp?=
 =?utf-8?B?SHRwR3d3MjNUemRmdE1LckVMVlZ2UU8wUEppYUpCUkY2ZHAzQzNQZGg5UFFB?=
 =?utf-8?B?blpiNGFNdXdSb2pwWHk0UnZMUkFHN0Z2TVduOCtROTdCRGxjYVdRcTRnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MTFIVVU2OUdkREpGZG91dE4vamJleWo4NTA5eGRWakx5WForNGFXRjdFWk8y?=
 =?utf-8?B?VnJpb2E5ayt0c2FnekkzbFdoZzRzUWJBZHNQV2lYajgwWERjbElWV2FOaFB1?=
 =?utf-8?B?aEpPemx5ZFphV1g1ZjB4eFBjanliZCtiaktQa0VNcXA1YkdXcXZQSEt5QlRE?=
 =?utf-8?B?cUtQUVBma0Yxb1JrSU90QUtocTRyRGdWMFgzRkZxZ2FPTVZKNm9jVTMyYk1z?=
 =?utf-8?B?STFwY1k1NWVsSE5UUkV6a2lvZE9PdWdVenRaRmZUTUNVQUlHZk52YllnVytK?=
 =?utf-8?B?NGVicmJRc25QWG52ajhVNGRqMXIzZ0thSzBscmkxeTRTcDYrMTN0bTdFUkVQ?=
 =?utf-8?B?VTdhSlpTcVVITHlhNnVKVit4cnNhRHhsd3Z2NWUzWnQrajYvZFVmcmI1SXJB?=
 =?utf-8?B?d1dmbFFoVXRoZHhmc2tyNXIwV3JEWll6NDh5MnFiTVhPbngzVFZrMGNkWHcv?=
 =?utf-8?B?SDBCdU5BNUdwcHFUeGs4Y205NUh1bEx2WkFSVTYrb0FpTHBPc1N4ZFdycDRY?=
 =?utf-8?B?M2lCUXE5VUZQaFNYNkpWaTQ2ZVFWdC83L2x6TUhtKzhxanE3aEFramRHNUlv?=
 =?utf-8?B?WGUwTjR6SllOQ21ZcXpkNnJXQkF5LzU1UXdZU0VGcVZUSU4ycGF4QmNDWFo0?=
 =?utf-8?B?eVNsVGNVTVNOV3dLNW5WbENyWVZrdGdDeWRWdHk3TjlHVTlHRGt0eUd6ZGpw?=
 =?utf-8?B?NmhPOFhtR3REbVczeTFSZG9kSlNHWTMvajZwS21wZFBvQUp1dmhHcFg1cU1X?=
 =?utf-8?B?WEQ2Mnc2YmpCd2swLzdjKytYK3hpeTc4T2tCalQwTytnVHJQaytZdWZLSUxX?=
 =?utf-8?B?dGdPdTVLRkVLRVBja04vUWpXZHAzeENNU2ZSQkhkL1Q0QWdRd0VIV1VZanBF?=
 =?utf-8?B?MVhqaXloVUp3UUhDZE4yV255c0lNYjc1dE5yb25vWnJ0N0V1ZlJic05lY1Nh?=
 =?utf-8?B?YW9ybXBTbWpueVhIQmhxL1pZRlFwRVdVd1gyRllOYy9JUXREcGhGWHFsU3pF?=
 =?utf-8?B?S29uY2dSQ1p4dnkxYVVENFIvZFVCUjJUdENPaHN4SDR4aFJVZHdFaEpOaWtO?=
 =?utf-8?B?eHZwYmFTano0Ri9tV2hHN3ZIUkxLUmU5bTZnKzlvaCt1V0FEVkFxT2l4bHZQ?=
 =?utf-8?B?QjA5anRRdG9nMGhXSFVic214bSs0MHJhZ29uSzJkNWFSU0dTb2dwYXhNZ0h0?=
 =?utf-8?B?VDUxSE15ckdRK01manllcUFVd0pMVkVIdzhKeHpsYmdiUUNCN093ZWhXUlNJ?=
 =?utf-8?B?cm14Z21Mek90TFI1TGtWNFJQL1VhTHJpeldscFFYMjhMaE9DaU55d0ZYck1P?=
 =?utf-8?B?OGV6VzZwdlU1WDEyYnpPRGk1RllSV05hUkx4U2hOU2ZtNlN4bTd1dTV3MHBQ?=
 =?utf-8?B?U0RFNjY1WVQzZEY1Ti9MUVI3UXAydGEySURsMUI4TkpkVzRPYUc0UkVDek9C?=
 =?utf-8?B?YVlOenZKWHJtcUYyZTZwU0hQekdEWXV4OHdHVVY2SU41YjJjMmZNVlF2OXB4?=
 =?utf-8?B?VjBLYXk1RDFTUEc4Mjk3MTRDcWJoRzZuLytkRjl3TWxKemFwVVA2U0M1SlJm?=
 =?utf-8?B?L2NXZkpnN2tvUjBnN1p6NkJEOFU0UXI3RUZhMi9tT1JyTU9QbVBSNExXVXBX?=
 =?utf-8?B?ZStwck85aDR5V01PT0dxYjFqay9PaVRYUUNMVlV0VS96TjJuaEJ4alpDSW1P?=
 =?utf-8?B?NkhPTVdXeDNkb2U2c2U5MzJYcEhrYXJqaUY5dkI2VDRhY1NZSmJaamFxaG1h?=
 =?utf-8?B?THdLNjdRMlkvbGQ1dldwUEJTK2tjVWcrTHE2VzBOa3pTV3hVOFl3d005SmhS?=
 =?utf-8?B?U0VTL0dpV215T0M0ZTBaR0Q4MFRkTjdyblhIWnhmN0dsTkR3blAwNSs3N1ZU?=
 =?utf-8?B?czd1QXlGc1pxblMvSHkrK3JEUFE0bW9HMk5IVy9EN0o3MjRtSnFETkNlY2p4?=
 =?utf-8?B?Q3hxblYxVzAwSFBIemNRc0JxRWZydmhjZXFwbGh4dmRCTEtFYU1MM2cwLzZV?=
 =?utf-8?B?ZGZ1cUtVd09URklxOTFjSm1Ub2F3MlY2ZjZaemdwVGwzb3ZhWlBrNUdmOTRp?=
 =?utf-8?B?T0dUZ0wrUSt0SldvUktucHF3WE5hRTM1SGNCeDk5WFNBeHRmUUE1aW81Mmlk?=
 =?utf-8?B?VGRPNGZQVkxRaGJITUhXbWM3cGgwYTk5UEJUVWpCNE80Yk80RU1UV1M3OCs3?=
 =?utf-8?B?V3BGMXpISlZFczJ2K3FMMnIzeGRSZkYzWWFXZlU0MG50cjZITFljU0hzTHlT?=
 =?utf-8?B?Q3ZyNHh3cXpmQmpWMThlU2ZUeldRPT0=?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HKQ6REozXZjcAIonIjYsBurHa376KRYN7MZ5zOeo3ReiKUOcD5DLSqHkULk3BMl7jYd6MTTuaklnpDZboHiT9qwjB4xRrEX9ZyGdKTz3vVZ7l/uj39RwDdbdvcAZaQvP2Tf8x4Xo7PJVFS3dD10WRXXrmNEZrkIMzupEtQMxDJU/kt1OeKnmPnV6zQFmZQd/pbksftTVvZz7pmKFMHOiHqsRgotTDtp04PftJ9kbIJqe2WuLJsza4gLuSIJNvcEHDFxOV3+C5kAnhH6/J68sB/k3uN77d2v9dpddsiN5HcU7E50iwoS8Eja0CPFzbvhOGf5DhVGpSoLDUE7VqAxtMHbRDhjYHUTmgXO3PTUBPI8fggJkcZlM+ZXXMke9q9fgoj/DBeEX9AMFfGt0iYiaJ41lF/hSeD7HyhmReTyIgMsrsPXnU9y6WvH6g6W5spUmHgzf5wdqORhjX/lBgu7Ryj1hZGFds4t9g/4likurRKHHg0JHAGUi0FVoif5UYApARMSRSVBuf8vMCgd2XH6Z53kYvV1Q9wKprUP0YyZIYqrZ4NXuJNUeNzf/eql+hcwxZofxkWJSbaUVNIqgqSTnalc2B57AhxeiGZ/sLm30ufw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51e14aa8-b83c-4eba-f0ef-08dced771785
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 00:11:33.2799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eR97kEHXM4+uJe8LyWjhFRX9o2l8jIBoEfyEPyqHa8Zyp6R2omt8ta6F7VVuAf6/VCwHmg5BmWfuLdQgL/0ex6xTuZtadDPon600mR9LiLM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6977
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_19,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 phishscore=0
 adultscore=0 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410150158
X-Proofpoint-ORIG-GUID: ZfTjKls6cHH4Ir6OGPK_CFAZEnG6DrRF
X-Proofpoint-GUID: ZfTjKls6cHH4Ir6OGPK_CFAZEnG6DrRF

From: Christoph Hellwig <hch@lst.de>

commit 6773da870ab89123d1b513da63ed59e32a29cb77 upstream.

[backport: resolve conflicts due to missing quota_repair.c,
rtbitmap_repair.c, xfs_bmap_mark_sick()]

xfs_bmapi_write can return 0 without actually returning a mapping in
mval in two different cases:

 1) when there is absolutely no space available to do an allocation
 2) when converting delalloc space, and the allocation is so small
    that it only covers parts of the delalloc extent before the
    range requested by the caller

Callers at best can handle one of these cases, but in many cases can't
cope with either one.  Switch xfs_bmapi_write to always return a
mapping or return an error code instead.  For case 1) above ENOSPC is
the obvious choice which is very much what the callers expect anyway.
For case 2) there is no really good error code, so pick a funky one
from the SysV streams portfolio.

This fixes the reproducer here:

    https://lore.kernel.org/linux-xfs/CAEJPjCvT3Uag-pMTYuigEjWZHn1sGMZ0GCjVVCv29tNHK76Cgg@mail.gmail.com0/

which uses reserved blocks to create file systems that are gravely
out of space and thus cause at least xfs_file_alloc_space to hang
and trigger the lack of ENOSPC handling in xfs_dquot_disk_alloc.

Note that this patch does not actually make any caller but
xfs_alloc_file_space deal intelligently with case 2) above.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: 刘通 <lyutoon@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_remote.c |  1 -
 fs/xfs/libxfs/xfs_bmap.c        | 46 ++++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_da_btree.c    | 20 ++++----------
 fs/xfs/xfs_bmap_util.c          | 31 +++++++++++-----------
 fs/xfs/xfs_dquot.c              |  1 -
 fs/xfs/xfs_iomap.c              |  8 ------
 fs/xfs/xfs_reflink.c            | 14 ----------
 fs/xfs/xfs_rtalloc.c            |  2 --
 8 files changed, 57 insertions(+), 66 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index d440393b40eb..54de405cbab5 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -619,7 +619,6 @@ xfs_attr_rmtval_set_blk(
 	if (error)
 		return error;
 
-	ASSERT(nmap == 1);
 	ASSERT((map->br_startblock != DELAYSTARTBLOCK) &&
 	       (map->br_startblock != HOLESTARTBLOCK));
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 48f0d0698ec4..97f575e21f86 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4128,8 +4128,10 @@ xfs_bmapi_allocate(
 	} else {
 		error = xfs_bmap_alloc_userdata(bma);
 	}
-	if (error || bma->blkno == NULLFSBLOCK)
+	if (error)
 		return error;
+	if (bma->blkno == NULLFSBLOCK)
+		return -ENOSPC;
 
 	if (bma->flags & XFS_BMAPI_ZERO) {
 		error = xfs_zero_extent(bma->ip, bma->blkno, bma->length);
@@ -4309,6 +4311,15 @@ xfs_bmapi_finish(
  * extent state if necessary.  Details behaviour is controlled by the flags
  * parameter.  Only allocates blocks from a single allocation group, to avoid
  * locking problems.
+ *
+ * Returns 0 on success and places the extent mappings in mval.  nmaps is used
+ * as an input/output parameter where the caller specifies the maximum number
+ * of mappings that may be returned and xfs_bmapi_write passes back the number
+ * of mappings (including existing mappings) it found.
+ *
+ * Returns a negative error code on failure, including -ENOSPC when it could not
+ * allocate any blocks and -ENOSR when it did allocate blocks to convert a
+ * delalloc range, but those blocks were before the passed in range.
  */
 int
 xfs_bmapi_write(
@@ -4436,10 +4447,16 @@ xfs_bmapi_write(
 			ASSERT(len > 0);
 			ASSERT(bma.length > 0);
 			error = xfs_bmapi_allocate(&bma);
-			if (error)
+			if (error) {
+				/*
+				 * If we already allocated space in a previous
+				 * iteration return what we go so far when
+				 * running out of space.
+				 */
+				if (error == -ENOSPC && bma.nallocs)
+					break;
 				goto error0;
-			if (bma.blkno == NULLFSBLOCK)
-				break;
+			}
 
 			/*
 			 * If this is a CoW allocation, record the data in
@@ -4477,7 +4494,6 @@ xfs_bmapi_write(
 		if (!xfs_iext_next_extent(ifp, &bma.icur, &bma.got))
 			eof = true;
 	}
-	*nmap = n;
 
 	error = xfs_bmap_btree_to_extents(tp, ip, bma.cur, &bma.logflags,
 			whichfork);
@@ -4488,7 +4504,22 @@ xfs_bmapi_write(
 	       ifp->if_nextents > XFS_IFORK_MAXEXT(ip, whichfork));
 	xfs_bmapi_finish(&bma, whichfork, 0);
 	xfs_bmap_validate_ret(orig_bno, orig_len, orig_flags, orig_mval,
-		orig_nmap, *nmap);
+		orig_nmap, n);
+
+	/*
+	 * When converting delayed allocations, xfs_bmapi_allocate ignores
+	 * the passed in bno and always converts from the start of the found
+	 * delalloc extent.
+	 *
+	 * To avoid a successful return with *nmap set to 0, return the magic
+	 * -ENOSR error code for this particular case so that the caller can
+	 * handle it.
+	 */
+	if (!n) {
+		ASSERT(bma.nallocs >= *nmap);
+		return -ENOSR;
+	}
+	*nmap = n;
 	return 0;
 error0:
 	xfs_bmapi_finish(&bma, whichfork, error);
@@ -4595,9 +4626,6 @@ xfs_bmapi_convert_delalloc(
 	if (error)
 		goto out_finish;
 
-	error = -ENOSPC;
-	if (WARN_ON_ONCE(bma.blkno == NULLFSBLOCK))
-		goto out_finish;
 	error = -EFSCORRUPTED;
 	if (WARN_ON_ONCE(!xfs_valid_startblock(ip, bma.got.br_startblock)))
 		goto out_finish;
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 282c7cf032f4..12e3cca804b7 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2158,8 +2158,8 @@ xfs_da_grow_inode_int(
 	struct xfs_inode	*dp = args->dp;
 	int			w = args->whichfork;
 	xfs_rfsblock_t		nblks = dp->i_nblocks;
-	struct xfs_bmbt_irec	map, *mapp;
-	int			nmap, error, got, i, mapi;
+	struct xfs_bmbt_irec	map, *mapp = &map;
+	int			nmap, error, got, i, mapi = 1;
 
 	/*
 	 * Find a spot in the file space to put the new block.
@@ -2175,14 +2175,7 @@ xfs_da_grow_inode_int(
 	error = xfs_bmapi_write(tp, dp, *bno, count,
 			xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA|XFS_BMAPI_CONTIG,
 			args->total, &map, &nmap);
-	if (error)
-		return error;
-
-	ASSERT(nmap <= 1);
-	if (nmap == 1) {
-		mapp = &map;
-		mapi = 1;
-	} else if (nmap == 0 && count > 1) {
+	if (error == -ENOSPC && count > 1) {
 		xfs_fileoff_t		b;
 		int			c;
 
@@ -2199,16 +2192,13 @@ xfs_da_grow_inode_int(
 					args->total, &mapp[mapi], &nmap);
 			if (error)
 				goto out_free_map;
-			if (nmap < 1)
-				break;
 			mapi += nmap;
 			b = mapp[mapi - 1].br_startoff +
 			    mapp[mapi - 1].br_blockcount;
 		}
-	} else {
-		mapi = 0;
-		mapp = NULL;
 	}
+	if (error)
+		goto out_free_map;
 
 	/*
 	 * Count the blocks we got, make sure it matches the total.
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index ad4aba5002c1..4a7d1a1b67a3 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -868,33 +868,32 @@ xfs_alloc_file_space(
 		if (error)
 			goto error;
 
-		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
-				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
-				&nimaps);
-		if (error)
-			goto error;
-
-		ip->i_diflags |= XFS_DIFLAG_PREALLOC;
-		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
-		error = xfs_trans_commit(tp);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		if (error)
-			break;
-
 		/*
 		 * If the allocator cannot find a single free extent large
 		 * enough to cover the start block of the requested range,
-		 * xfs_bmapi_write will return 0 but leave *nimaps set to 0.
+		 * xfs_bmapi_write will return -ENOSR.
 		 *
 		 * In that case we simply need to keep looping with the same
 		 * startoffset_fsb so that one of the following allocations
 		 * will eventually reach the requested range.
 		 */
-		if (nimaps) {
+		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
+				allocatesize_fsb, XFS_BMAPI_PREALLOC, 0, imapp,
+				&nimaps);
+		if (error) {
+			if (error != -ENOSR)
+				goto error;
+			error = 0;
+		} else {
 			startoffset_fsb += imapp->br_blockcount;
 			allocatesize_fsb -= imapp->br_blockcount;
 		}
+
+		ip->i_diflags |= XFS_DIFLAG_PREALLOC;
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+		error = xfs_trans_commit(tp);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
 
 	return error;
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index a013b87ab8d5..9b67f05d92a1 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -333,7 +333,6 @@ xfs_dquot_disk_alloc(
 		goto err_cancel;
 
 	ASSERT(map.br_blockcount == XFS_DQUOT_CLUSTER_SIZE_FSB);
-	ASSERT(nmaps == 1);
 	ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
 	       (map.br_startblock != HOLESTARTBLOCK));
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 055cdec2e9ad..6e5ace7c9bc9 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -317,14 +317,6 @@ xfs_iomap_write_direct(
 	if (error)
 		goto out_unlock;
 
-	/*
-	 * Copy any maps to caller's array and return any error.
-	 */
-	if (nimaps == 0) {
-		error = -ENOSPC;
-		goto out_unlock;
-	}
-
 	if (unlikely(!xfs_valid_startblock(ip, imap->br_startblock)))
 		error = xfs_alert_fsblock_zero(ip, imap);
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index e5b62dc28466..b8416762bb60 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -429,13 +429,6 @@ xfs_reflink_fill_cow_hole(
 	if (error)
 		return error;
 
-	/*
-	 * Allocation succeeded but the requested range was not even partially
-	 * satisfied?  Bail out!
-	 */
-	if (nimaps == 0)
-		return -ENOSPC;
-
 convert:
 	return xfs_reflink_convert_unwritten(ip, imap, cmap, convert_now);
 
@@ -498,13 +491,6 @@ xfs_reflink_fill_delalloc(
 		error = xfs_trans_commit(tp);
 		if (error)
 			return error;
-
-		/*
-		 * Allocation succeeded but the requested range was not even
-		 * partially satisfied?  Bail out!
-		 */
-		if (nimaps == 0)
-			return -ENOSPC;
 	} while (cmap->br_startoff + cmap->br_blockcount <= imap->br_startoff);
 
 	return xfs_reflink_convert_unwritten(ip, imap, cmap, convert_now);
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 4bec890d93d2..608db1ab88a4 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -840,8 +840,6 @@ xfs_growfs_rt_alloc(
 		nmap = 1;
 		error = xfs_bmapi_write(tp, ip, oblocks, nblocks - oblocks,
 					XFS_BMAPI_METADATA, 0, &map, &nmap);
-		if (!error && nmap < 1)
-			error = -ENOSPC;
 		if (error)
 			goto out_trans_cancel;
 		/*
-- 
2.39.3

