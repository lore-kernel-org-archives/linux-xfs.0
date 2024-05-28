Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104FC17085F
	for <linux-xfs@vger.kernel.org>; Tue, 28 May 2024 17:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716916548; cv=fail; b=E2Me2exnKne+DUmjYJp1v/Epy6M+db+a7vr3PUuTYHc29Ac851shz1Dd5+Q5K2SvVWEqZgtc6Nl+N/Elkks/ZpX+KxWJX5HZqhedbMxmnMm40vk9kscAP3vTHxKvcRGaKZMDWBNKIL0xi5GHVi8Fpu8e2lqYKQbnge4h2jt7QcE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716916548; c=relaxed/simple;
	bh=i7WzV804eUb9/zVKaPBaolc+t0XDggaRxZIXTB6NnX4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hSBAfMfKNRT3CTKBXLWR1+SbzxPXFO0k1A3P27z2P01wY08TSsuuKNqp784qy8GYU/iiLhSXh8+GkfIkpJOsw3I9b34SJHrBC+C1fJ2B8DRI0foWgZoXf7iJpWxlYk+z6+V4vA4/x4ZzF9LIe/Hcd1U1rYe3fhLYy5UNIig65FY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44SBpL7r002895;
	Tue, 28 May 2024 17:15:36 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-transfer-encoding:content-type:date:from:in-reply?=
 =?UTF-8?Q?-to:message-id:mime-version:references:subject:to;_s=3Dcorp-202?=
 =?UTF-8?Q?3-11-20;_bh=3D4nix+1ihE+kJxK0Ilee9IdZ+/K9IGCSKUme5R3KcTw0=3D;_b?=
 =?UTF-8?Q?=3DZ08XUaDuXupeQFzRSd35jw4L9WxD/zWCQTpqB/F1ceZ25NLAHDzZS2V+5Zik?=
 =?UTF-8?Q?25Z90k5h_ezj/FCPEMmZ232GDJYzIRm+Ql583mW4jXr+bDdYeunNj6CnTIgFAaV?=
 =?UTF-8?Q?evVkexQNqj9YmA_keBBXfvWjLvKPlvembJbJZTR9oMblxydrIY6qwGJLbPkIEfR?=
 =?UTF-8?Q?lE54yY5SUgaPliGFevnt_isT+Mtt4hQWgAmw+MVmnlwIdexk8Q7WP3Sen2qsfWx?=
 =?UTF-8?Q?ir5SyaBKWADhFA+T3vVQwCSPvf_CXiuw98VYoqQ0vLX0ndNjNwFBPkR007CfVzD?=
 =?UTF-8?Q?f1l0c+/qAHVahbyyAXtyFdhzmItazKoi_TA=3D=3D_?=
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yb8g44y53-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 May 2024 17:15:35 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44SGPcsv037637;
	Tue, 28 May 2024 17:15:35 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3yc5065t00-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 May 2024 17:15:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZGpBtJtZTJYnATJI5DGtpDcpo6S7FmEuAZuG8SJnPj6cyS8rq0bVjQGjlmhXOLn/KVQM8KkfOWZHiDCAzlPBrKUWrJ6BS8qjkdroDfB026kExwizsctr1SioowGPcwTTTk+Hi8FTG4mZnRiumkgXnejlVDBJd/3X8G3H8hDCf0WZVL34qPQBaFTzpmj1QREKHs5vK3zaBFC6GEuOV8Gh2mHAjm+F1oF7sJZpL2i5PKOM1J+DppXvTIMvur0S2rwAF7zvczbd0EsvH91HaX3VXGe7gEoupl5k0Up2N5v49L69YrFZB4eEqPk4ES0nQ1QkUnaSTEJ1nogqcp5ByLQKrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4nix+1ihE+kJxK0Ilee9IdZ+/K9IGCSKUme5R3KcTw0=;
 b=Mzt4I6ZLiM8Su8E/4ilS66tloy9EQiUuAm/hgO8klW3/GUALUk3VmW2eDAg+FTPC+r/NblZ0xCHbfLhU1WFBp5DUEMUfFF6DvEfywhZy+8qrGDydSHwv7airXGxihZI1p/GTsxcMeptR0PNLWU0CWu0rR5Tf0Fww7zNpjAz82vpr/f6m6kkFC8EiW0O+4BtVgi/hxLqWy3MeMtJsqwNGMyuKer7UNIgaCSXHzYgbawMihdcvDawsuMejdypB3xHhPt8mJiT57asHqMvciNhVM9HLAZYNGcOlyY9kh+5cBe3z+C4qIQfVu/XnBphoC4iBZ2Go3Wq7o2A0yCktgWM1Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4nix+1ihE+kJxK0Ilee9IdZ+/K9IGCSKUme5R3KcTw0=;
 b=Eh1gqknUijTlKfJEsY4y0M6ULQE1ZVmSai9CgUCJ1lw9sSGJMrKplr5oJrLmpgpXBIHgKVqb3YtaXsqFhxQpXvWbQ6pL1oTJQrMJZRV3SKZW7q1xcVjXUQFYbbHjHVnR9uLolzeCTE5fv3UcqAfSeacFs+IAFq4mLrNOcCdkXMQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MN6PR10MB7999.namprd10.prod.outlook.com (2603:10b6:208:4f4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.31; Tue, 28 May
 2024 17:15:31 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7611.030; Tue, 28 May 2024
 17:15:31 +0000
From: John Garry <john.g.garry@oracle.com>
To: chandan.babu@oracle.com, dchinner@redhat.com, djwong@kernel.org,
        hch@lst.de
Cc: linux-xfs@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 1/2] xfs: Fix xfs_flush_unmap_range() range for RT
Date: Tue, 28 May 2024 17:15:09 +0000
Message-Id: <20240528171510.3562654-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240528171510.3562654-1-john.g.garry@oracle.com>
References: <20240528171510.3562654-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0048.namprd02.prod.outlook.com
 (2603:10b6:a03:54::25) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MN6PR10MB7999:EE_
X-MS-Office365-Filtering-Correlation-Id: 80b191ce-fdeb-450d-61db-08dc7f39c728
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?2VnrPziZU4qL6EfWgsLcHnhpZaGiWslf18e3KTVRdq+caAtkGhskTbHzCcUI?=
 =?us-ascii?Q?SMHy7iH1Y0GBjd7sfz7EXctSq4pSIXaurZ+w5QlLqwTtl9fye7A2sOhVoWqH?=
 =?us-ascii?Q?rbHIbLvwLcFhsywK/X6IOi6ljsmK/uUqeF00+ZsgKJmNav6vMA0bFk5ZSsQk?=
 =?us-ascii?Q?t8hEJx7/F4qqRz87oy4Wpzz4UILPxyPG8gzzGHZ2tR//2fSlhFgBPhm1JxfD?=
 =?us-ascii?Q?Smof5fHbcM+SDge79CQsVfYPY4rz/oWfIn3CHexDp8wXthYNaM6oRZ62kXzI?=
 =?us-ascii?Q?i8uAwWio/jZ2+yPCzPfEzauHlAD9Rj4fotxlZPUK0PPiFsz7OU4jrRwuX3jb?=
 =?us-ascii?Q?iy0gkDgX0/WHC4qbjvY0pB5wWlyRgXsJpha2aPbgj+b2SQPgoYWRnd+uAUbb?=
 =?us-ascii?Q?3Pq0TSTMnr7YPilqnAjwfkOcaM33yGUWTsqe29Lkjtgze2ilTQFxIT+qHAup?=
 =?us-ascii?Q?cJmMU/g/lvfr3i2OOVvNjMXU4coN/1CeQoNxWLTmv7urIQswjcK3RsbT4HwN?=
 =?us-ascii?Q?AZFpv0Rovr666IJpQjoBCRwDnWcUbAOXUcKiBy7MqB6DGB7yezqjdMyOAHwP?=
 =?us-ascii?Q?4VOoh09EYm5JblH/KnWQQMYe6S5N+tOmJRtYg+UIT3LMtoQZ9IMt4Idy0X2+?=
 =?us-ascii?Q?BbJHJVFfmXOHW+q3vzRg1jb2AAkc5hElXy7puxzgQts1TiAfD5f0mImOVtWy?=
 =?us-ascii?Q?+jkomDr0/GNxE4QxRRxWzfKW2PLHZuTNXqHBTuD9Bs6GIYi+n2h08KtXFuJN?=
 =?us-ascii?Q?M+TZius6y7JggMuWAwAQiuMgHmfWmUpPtPNlRVjTuD9BEPLvaP3ZENLpsCpB?=
 =?us-ascii?Q?vdS0wmeAPdm8GWBo0/C9r4CP1j3y3j1KfmEPRJRLsHJAkMRlgCP8HRouBDAl?=
 =?us-ascii?Q?opKA30udixtgHm3nmqVFGhyznzYY/x1pzTJetKwvrLdK2oOM9LOpTtH5UEr8?=
 =?us-ascii?Q?ZMJQlyJ7aGMiOrklbqkewTXhsP3PI0QA+p6RF6qGKcR9aSPvVnw8LsGe5A2w?=
 =?us-ascii?Q?Raa7sasfi4pMEu8z7Wi9toRWh7vsmQ8yYUn2Mfd8MB7wV6agWpiiuGMzng6o?=
 =?us-ascii?Q?0Z2+J8os8bgEDjiVVfltkjhzbw7OuI5okF38kb80YvAzByMovC9SKLCkVQS6?=
 =?us-ascii?Q?n+s4RSATBJTIJRWqvG3RW4ZPPLD4Jw9xQ1A0Yf4FXz/0jdYBmAM7IkhLK/wq?=
 =?us-ascii?Q?rI195MJHqPuTD4htL76Yd9YVsLidtNUf7dHA2v7M5dA4U21bRL1eSrZubgx/?=
 =?us-ascii?Q?XWkmTk4+5d8nlp1z9PuNKGOJUV0oO6JLIfgJKwq/rA=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?/UIa6dJ5QgBtBXW+Un1R+1f2VAZUV1Yz9ApXeUYwRIrMpkdjgAYNQdSYs+kG?=
 =?us-ascii?Q?4mTI41Xgw4/5UVfNOPr7JBL11pvP/uxDUq1ZeQW5lDWCrD+K12VmK3GiJFjV?=
 =?us-ascii?Q?konWij1s0XxaY+7/muNUjRbpZ84WfUtIll8vfsWvy+Rp0Fl7mji7ieAwn2gf?=
 =?us-ascii?Q?qsxS6mX7wP5Piv/+pyv0PwQSjQYL2DmZQyHWAjZN6TkcBTH3WMG/eybgcK8T?=
 =?us-ascii?Q?LHVZcK+5nMdUE0oNDGSzTrOsFO4Zcj96afwNIeveBgKbfJPo21byFSRhPnAY?=
 =?us-ascii?Q?cniVzi6oldDLSUI13JUx+QVJTifXLquEMCh7f95L/bAt9pVCVYldAhurZmiE?=
 =?us-ascii?Q?PmgTx1fs78V7pNovvReXea5XPc53HVF1fX1ALV4E7TiT2jeWLGDURsOFv1Uc?=
 =?us-ascii?Q?jVp8T5l2RXom0NJI1OIlb+9Mx+upZSdgDzpLNdo2PteXMOw28OKi9M7kgYkY?=
 =?us-ascii?Q?Ucu63V8biUeBLsoW9NPnNul97x03t2UByar0OWVOuoAXc6man8G05J3tXNjL?=
 =?us-ascii?Q?rCNWf/wbXOuno/ZrvKwZYiXD05vtJ4Ls+UseRugzHz07AkzCa8t+ewk3Pu5V?=
 =?us-ascii?Q?wloIpMvVFM2XL7vGXdNMkvp9/qmFXtcrqXncTfgVAWCCUvKtUhEIREdD2sfI?=
 =?us-ascii?Q?Jyfx2/w7Q8D3wGighzNHHPkgsdMQRt7BfPUNU9H6YeqoEJu6i81Yr7wcK00i?=
 =?us-ascii?Q?YYJcFhVFbWWW3LPvVQak52cIKUZPc7txwFbhjeo8iw9q1a6kH3asGV9eZAKS?=
 =?us-ascii?Q?Z/InjMefp614NyY1whgJLh6niQABrVOIhcbZdrwcnBcsUU7jY6hTmwpHVyD2?=
 =?us-ascii?Q?HOJ4Q+PS/X6NQk1hkydwv5csWjoOUUtMZzk92V1RKUCl0Ro0pX2umNyiCQWb?=
 =?us-ascii?Q?yiI4MoLLhQQtash4LH7nKwhlKVY3qLqA65Y6GMkC7rkrZaivIk6stFXEuGtd?=
 =?us-ascii?Q?ldextHVTGNxb87AUMyPfXygQAQFRoUxHmcNCixQ9BuKxYeKorFPViguZNTQG?=
 =?us-ascii?Q?FeSo6sFtEQmS69i11gvsMypOEGN3/Q7aqv+gep/R6ypRAusVfaAFJUpzeL8i?=
 =?us-ascii?Q?viFZKBiH0D1B55ZiGqCl+FFMJn1n231oNtnpeoHXbmpUf23lQsME++Ava7qp?=
 =?us-ascii?Q?HVn9QfjilDW3PWX+RhjlVM4gJ2wbc3YPiAzZYtXBGgtBrjkCCMZs6G/gOLng?=
 =?us-ascii?Q?JQmYdl/mltWHM0Q8RMuQCxpia6hqJZSesknhzBmPKaZn9PVAhX+njMD+zlyR?=
 =?us-ascii?Q?IgfvvVRd+cbugC7xKGrdtmMG1EIb/XG9bhHQNApVnF5olVWEOtNO/Glpu4tq?=
 =?us-ascii?Q?TdQCfPoi64PC97TvmctPfrWC/01KEB/WnBpAhZBbroEvqi7DNo9HgqKM7WPc?=
 =?us-ascii?Q?sn+0U3ya19/e+fKWjw1SJI4VS1KNPVb0TI2MTHas7qwVQK1FtxokbPWi1H4f?=
 =?us-ascii?Q?V5AeK0DUxgu90ffTv9nq6FN86Y7TAzPlx29fi2z2X22jjlgdazmbV5O1TvTu?=
 =?us-ascii?Q?yEpU+i7gtWGBo0cePZg4p5uSYMReoYpt6bZIMskvgeqPUJx+7ck/odx/sFOq?=
 =?us-ascii?Q?GyqGvr5yLwVulXDNWNw0eVhyhhVVvsclBIhYXdVPneuRZG7GL3FrDFSjy/Ea?=
 =?us-ascii?Q?nA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	VrALzXZishPtYypSfzK601TsPlgzJsqwUaKkqjpUFwav9c69fXtn+OsWisw4wN+RBcjUQsjQeCYWTLPwWfT/jyehcSDiYUDahrN/8p+eXQBb23m10mz8BlwPr0+hfn4zGcfR407bE7DZViD74S1ohNSumWNgOd5oPdspMG3MZOaRVZjYYxQdOcSB79JTxu/Fib0+9Wy8NuVC7NL59AZpr6FbNiypyz4WBTbytRx24ldvsL1LfqkUZ2T0RoMwCx+/Bg5rPGyw/EbfyfgSAeKWGKs1GSzK9TBKc7GqdqcFY6HDX3/NGXAKU9K0v6lM9Ez8PltLYP5Gvez+ZvYfZDxGsT6mfP5lI1kq4aH+avyPjFzdr2zfrf7JRtW8x5sK74OOwRMRibTrOOIMqSnqEjA3vMGPyCtinMKmsjdJZbD1QYXCqhnRhzQFSFyPcvRoL5fsM0DK3ulsX9LsdV0j+p5wvkylaNtOd1se0O2cHSPtNX2cjr1ydKmsUUvVU6YzEztN7WgkK0qJ3GK1bjRieEJ5GWc2mDQDRug/+uusNtJcrgGJKmimcK/RQNY3lHR2em39Cr0GyLtaOcMKX6O9Dt2LfGAS6rgZpFAJruuIg8jWW4Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80b191ce-fdeb-450d-61db-08dc7f39c728
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2024 17:15:31.2138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fWBwcu0EQqgjjeSF1gwTG27aqmAJv7ve/PJeABHIFfyZCO1Fdlb+Lmj0arfafrt1vvRxsaGt4u26D7Siy4KsuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7999
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-28_12,2024-05-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405280128
X-Proofpoint-GUID: 3hJjJd_vO89L1tJBkLifyLHsuc53NuC4
X-Proofpoint-ORIG-GUID: 3hJjJd_vO89L1tJBkLifyLHsuc53NuC4

Currently xfs_flush_unmap_range() does unmap for a full RT extent range,
which we also want to ensure is clean and idle.

This code change is originally from Dave Chinner.

Reviewed-by: Christoph Hellwig <hch@lst.de>4
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 fs/xfs/xfs_bmap_util.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index ac2e77ebb54c..8a8a2102c6ac 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -794,14 +794,18 @@ xfs_flush_unmap_range(
 	xfs_off_t		offset,
 	xfs_off_t		len)
 {
-	struct xfs_mount	*mp = ip->i_mount;
 	struct inode		*inode = VFS_I(ip);
 	xfs_off_t		rounding, start, end;
 	int			error;
 
-	rounding = max_t(xfs_off_t, mp->m_sb.sb_blocksize, PAGE_SIZE);
-	start = round_down(offset, rounding);
-	end = round_up(offset + len, rounding) - 1;
+	/*
+	 * Make sure we extend the flush out to extent alignment
+	 * boundaries so any extent range overlapping the start/end
+	 * of the modification we are about to do is clean and idle.
+	 */
+	rounding = max_t(xfs_off_t, xfs_inode_alloc_unitsize(ip), PAGE_SIZE);
+	start = rounddown_64(offset, rounding);
+	end = roundup_64(offset + len, rounding) - 1;
 
 	error = filemap_write_and_wait_range(inode->i_mapping, start, end);
 	if (error)
-- 
2.31.1

