Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A593B12F378
	for <linux-xfs@vger.kernel.org>; Thu,  9 May 2024 10:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715251291; cv=fail; b=tcLqECQo4wz9AWNFFCwx1h+6iCdsjdc9PS9uw9GtF/DprOhQFajsAg+rCFcq/LtSihxN+B7zfAF16HpO9/asRuxV7jNVViPoY5NcSkFCDaXdCiY2OtQWiQGuk5Lkfsoo2jBoaBKH8I9ZrtUG/HIo9T9u7r+YI/kzwOnUk+BUi54=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715251291; c=relaxed/simple;
	bh=4eC/H6oEkZ9K5xXTNdVgBXqq6+VwK9Sgr6EyEjuhagw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PY9g5mYf+FjeB4PWNw9pGbHa67i++dqN4Il79iWnEqPcSayoJ30sKy3kmH1LvogMQkitCiCmpYszMAieddAtDu1VmwFALmklYiB1l7ncf8K6v4iWQogknegYD/ih6I5ilCC1/Ay8yfpCqDFJuIRMpFX/m2zDI9IHXuC5A0pa/1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FoFaWHI0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gv/RVIfY; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FoFaWHI0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gv/RVIfY"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4499qYKm008277;
	Thu, 9 May 2024 10:41:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=3h3WSVdMqJ8DGIXG/DmA9Y05UnPu8X8FcDSi2UqUDlY=;
 b=FoFaWHI0F8evdiam5rREgy57fOtYRV3OYOz2pCOaXWtuOhr/puUtSxFY9RFTXUL79tyX
 Pn1BtqZGnFvzVgLaUUr86LCep7SjZG4OvC5ZEU61Rl8fbDm37G/FkmlTppch/B7SI3aO
 2cjLI5ZtaCWG2htKsgCx9MOz6TU7nsPitQ2EXKgjkZfdnQVOEMPmcOXLRhLG2w6PGKDZ
 5e/9mhh9+3oQ/dyIgbHAB4u7KElhfWUp3jiAoCyBEdCElEqpy8SPBvwJrGh+jOh9Qe/R
 uHVYojtmvkcgIs1cVnap9dv81ga0yebO9EdCxWmXFMaY0Vv+zfJ7ps+WUPnklrNKWIZZ vQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y0v8302tk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 May 2024 10:41:20 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4498l8BB019719;
	Thu, 9 May 2024 10:41:19 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xysfmxrjp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 May 2024 10:41:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2ib2YXn8ZWa5nFja4Fw0OyCU9i6ECIa0+JRZcb2bXAQz6R/8xTHp27uZPm2Xpnix8FhhHuzaOKaL8quB3ulW8YT2qmFLIMc4Ib4K5srN/NHN+pLjJ6Hk+xzgH5Er1Kup27Xpw9b7rzQuHqoi68O4RsbRMoRpW4/1bc8oPtap7R0/okxC0QrXnYgecacrD3iFDSzW/HWu3ZZQ++MExHClVwCYYSQiWR8GEoHRe1/6qLeRFM7hYsRcK01fmes27t9Mxf+4JIprto09TXQnsvb2iQpQFbUzP0g9MT77BsA0umOtZ+PCHdngN1unY1jBA1K9s38oUsQkSXU0KuNRBgCRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3h3WSVdMqJ8DGIXG/DmA9Y05UnPu8X8FcDSi2UqUDlY=;
 b=GG0spmeSPxwk8Zzc7oNCgSzaseMF04w0RzLCF2w570gGa9rG09uzVIDyB8bKaxq1qw+fsjEN3s9OUsL6tP88YMbpssI0yBPUtu//FBvjB09W3lH4iz+69myrM6IqOGKJlOmXm472jhkz6lBiU0moEwvKtBk7Cz1/YtTH6EUZjOErI7sZm08gwmEZy+Z/CvxOEC56+U6Oh1iP1HvgDPZ+kijmBrcS0+mcLR8t0aDBO48G1NbUqjEdB/oU+ZbLCldSPM7g1CNfo83Ohf6IpVq/RxUMW64kbVF7Q+GybtL/QlnvVXpqvAkAgMEVSyRt91tuhRQsOeqtY+haKGx9z8aZTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3h3WSVdMqJ8DGIXG/DmA9Y05UnPu8X8FcDSi2UqUDlY=;
 b=gv/RVIfYbKYvQYmzXEjaG8ffmjl69F/NmEDez4/X1nbKOy5K1j+o2Ywo/Sr27B7fNr4H7UxGnMjxefuuXicgajM74SJ8LZrg38ecXX3A0TLsGeBxCa78r9Pv8x7azJPHKYb/ccWSmCEdJf0cabHUuoe7z7Ztc/P6ySqoio3xl/E=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY8PR10MB7337.namprd10.prod.outlook.com (2603:10b6:930:7b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Thu, 9 May
 2024 10:41:17 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7544.047; Thu, 9 May 2024
 10:41:17 +0000
From: John Garry <john.g.garry@oracle.com>
To: chandan.babu@oracle.com, dchinner@redhat.com, djwong@kernel.org,
        hch@lst.de
Cc: linux-xfs@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH 1/2] xfs: Fix xfs_flush_unmap_range() range for RT
Date: Thu,  9 May 2024 10:40:56 +0000
Message-Id: <20240509104057.1197846-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240509104057.1197846-1-john.g.garry@oracle.com>
References: <20240509104057.1197846-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::22) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY8PR10MB7337:EE_
X-MS-Office365-Filtering-Correlation-Id: 7071faad-a2b2-42cc-dfe0-08dc70148ea0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?AoHeWWFCK6XlzbYT1Z7sIeIsNdyNvbA920my+Zbo8u2tnHYH1kv4ncJHXe+W?=
 =?us-ascii?Q?dGbe32RPYL0oPvCmZ0tLxO3o/8cEaHpr9bEXYuzENUDwUS8ibZ/Xk2V3NODL?=
 =?us-ascii?Q?4xfQyXBDoB2WuYyAdWdIeOSBElkLvITOFCYaSv6dRgXIwEyuKYPGUh5bv6rR?=
 =?us-ascii?Q?DnYN+CYyj7lnPGvAB5iwWdz+ZnV1LQZ6FNpc33clJt8t4/fFmcqflkR3aFss?=
 =?us-ascii?Q?A+C2gouqmtmO9sr0X9cYn8hbeFAj4AvguzcIfSHiZPIkZGrjOW3R46vExS8D?=
 =?us-ascii?Q?xhcWGvPAWbsoX0Qi935t6oa7I/7OmMv8ObFP4DujNjl3+Y6LMelzEOF6YobJ?=
 =?us-ascii?Q?kSR3JiMt7wlDBQDi7giTD8Ee+OJlBq13FCGQbkPl+EFV96Xgr6LpbHPilTNZ?=
 =?us-ascii?Q?LGL2x77rpfIrv4PPHv9hMNPEGM3QnSGA0Nsqp4WXAG245jJLVJSLhYl5RKjw?=
 =?us-ascii?Q?XNN3OCAJaZ0yKGNwDXKWqSPfGHs0JAQqaBP1KBl3EpF3lah7Ji0yDVcNJj5X?=
 =?us-ascii?Q?lJ8o2MWr0a3CP2sboUCqhVeiE+FPrwjin1UR4clTuauO+BbMRV4cq2foEMtx?=
 =?us-ascii?Q?Bv9rd2ofXQrvE1+AAm8sdbcE2dLDAPvtAeJyGI9lsgTuw3pYS/j7qi+nIMx+?=
 =?us-ascii?Q?PAa1k80PdjXMnryA1x2CtNnmbLYu2C57HVZkJ5JTAGQGj1/j0I1oWza/mnIu?=
 =?us-ascii?Q?QGsm1jilzpV9avc0Lpz7AIQp4JDhLSsUoXp0btzE8dJVoCwVELGhiwybOGBb?=
 =?us-ascii?Q?J/L1NX60evSMo2sr2mPvfGcDHbvq5CDcsJ/eiFrFyyYOC142VSpKGhnurfkk?=
 =?us-ascii?Q?Uv4Jl1OjhC0XtlepEn8xz9dfw0OZ1jWIogQwy1PlXJV69fxMcXMWXb7BLoSm?=
 =?us-ascii?Q?ZrqUBhQSmape3cdXcVkdA0gPt5vKl/2B3VzhkFojZE6V9mYELwdXkFTzfRcz?=
 =?us-ascii?Q?Cmk+N5cR11hcf92vz9/xZZlXp1xeQkoNgVXxYDP30DT2qfiWqW4Zf1KJuGpg?=
 =?us-ascii?Q?5aTejl8tslNJfgbh1bisIOUB1DqaaTBq2/FVTQPfVIY/6fzTdr7v8VB4r5lD?=
 =?us-ascii?Q?NKCGQbup75ueA8zHMHSGlRyzqpkUcYDHvz6JIgiH7bPF71YBSux0dpuJtb3P?=
 =?us-ascii?Q?sjdPy+yNr2WVFJpMhmUfJCkxaTVAVUZex5FRoGvfeIirtpqQqNqaPuCD7yRO?=
 =?us-ascii?Q?CG+kEESuq7St8bEr3qF4GFCTHba9zb6Ls66YVc4vVv9OhJvL7+l6qGBZTB8z?=
 =?us-ascii?Q?P/TGoav/rBPEEJ/noroamMuit4oPzScR8RXnazYHHQ=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?/svl7aOiYBdFWZtWULIELGnu3teBvsvq8JaasDz/NkpwvR6c3fqkUs8jWRQc?=
 =?us-ascii?Q?C1MZXqLlp53CEdZY3JCF80lQQAPponkUMDQ/GF3n0s5ooe5tTCUQbzR1kNHE?=
 =?us-ascii?Q?3M4ZwxRuQejaZr7cek9gNtjhC18dfp6F+3rsPLajWVz8P3yl+0lv+GpdjeZI?=
 =?us-ascii?Q?f2NhyMSV3tSQa83Mn4W5yC3ZJD2T2Kx51OkuANB00ZbTSNzm0unRiZNdZduy?=
 =?us-ascii?Q?PWryLAdMU/X1K/huLPzlZKI6LEpftW7oRI5TE/6twIeS+POWVO84fIJ4Sp71?=
 =?us-ascii?Q?CTc5JVZV+NTUMA7Bce2+FXUkH8T0fG8aA6iTVQcm7jlbfgs4U1iEav7dk+k0?=
 =?us-ascii?Q?mFR3l5aZbE9+cBQEikn6EozsMyXAlHKYEp80klBez2CBRwBTOkXqnLQtEniw?=
 =?us-ascii?Q?VB/xFOV5BYainW+6upIF3ts25GsORpg1BBIrA4DrYdEmqCoWDpD5NDXWwAZ3?=
 =?us-ascii?Q?1pKU2Y+6dkBE5CTEXOE6qLnbhHNdrSECiGulR3ptl15t+BpL+6dl7pyr9dv0?=
 =?us-ascii?Q?VeQk8ZywS0aKIbaYvAx6JxH8vA83jM2FNNHp7Q2tFuxmkYD3m0rlbktVmD48?=
 =?us-ascii?Q?fPJffEejwtiGG73BAWQp+aTLwPvaY7gFBSuP/rekXowjCLD20y7mgBYn5DQq?=
 =?us-ascii?Q?9S09Ve32M/OsY9Z+6Mt93G5b50Oha8zc0y1IEjg/YO3rWcqxY8QHIscuwdAE?=
 =?us-ascii?Q?cMhTPCzTWUpiOStmokcinJQOLl06oKmV15QJT2id24favko4pNi6SGwmdNg8?=
 =?us-ascii?Q?Z52D0sxY3MXPM+X7zOhzWHjpGi80h12On+2rVH5VfUHMmA2XZ/7flwOawF8R?=
 =?us-ascii?Q?elif9J+Fn1Pncl78fKZ7H1AKNSUPBbmvpFXk36E31YuCzqKCeMsXy1U6b6TM?=
 =?us-ascii?Q?OiqcB96BR+/7TB9u0PaytaUCfsGmsEuGJkw+2ZOqBZtuVShufRJHuZraThl6?=
 =?us-ascii?Q?EfRDP1Y4Q1IilzHQ3KRdK6xjyJACRdnh4eXOaOXDyTnhPWp76VRhF1CNVTGh?=
 =?us-ascii?Q?JEUb6lKZpS2CEMC+Afs2OwnuvvoCH1GZdjZVs4PyN3UwWVrzgoSKkdxYMH+o?=
 =?us-ascii?Q?nkq+uiwvbyafQ1QPuGaZFp2wA+1jsbzATWKtwhYfk+nIyBcFVbwtDbrUIswa?=
 =?us-ascii?Q?iBRKVXkgjA6HHZyFGv1l4R6ZfzgM93BrZ4B3jw1/UPJwIBCGlW7zuvI6VfwX?=
 =?us-ascii?Q?vvb4iOe20ZsPn2ha1Vr9K3S5IJqWryaZP2NoHmjmyW5hAVI+FVR+pKk1Lwe6?=
 =?us-ascii?Q?lzBmT4B/JpFICc5PdxU81qCVJMVjk96SfffQt6ONFv+LlHGqm4L+sE/P3/Kh?=
 =?us-ascii?Q?nnnGH0BxGuqMp9ffQkl+DNqsqgCrGiEGqH3SEnFv9jV9enZUgsdQVE04yEhR?=
 =?us-ascii?Q?uvfVOsLWBjp6qOyrdASYxl2DQNyEfYjngOWZrg93tNdXOCHG8b1GwHraTFi8?=
 =?us-ascii?Q?jk8yRSUTN3D5OCIGKT11JcUOOOnW+pTSG2ISpcUOI4W5//JWBzjcXMUwk1me?=
 =?us-ascii?Q?nmxn+kOKfPY4B+9zOoJbpVEgLsxoZtyu9NscretB+tiAJPZjguhXJLX1Ht9O?=
 =?us-ascii?Q?uIfoy3ueg/Z3qAdfV9DEC/1OWZfE7ucf9JeU2HWXtAMVzawzB8BPeCqQt17C?=
 =?us-ascii?Q?eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	bfmV4Nt4EhiUBX85E8oFRr0Ef2RakThjXcFKu4yJHcdoM6l0Dag7BdQcPmGmCsGVJsseu6PmKJtEMbIhrHZJKs5neBrspAYYCTvBbkgI+QGTIGUidGiN3dVbkOTp5NFQxMbYiVqrYQV9b/U0MQ1l/L30RphBaI5m6ndTXl5JfFYr+LHyGxTJUF8HUAlhuZLQouSaqzbBnek0i34Uz2zJeTbJ7IyAVO+eIqKMmcr9p5bNXx2xufRQOphRsP9nS9YvhmWOglnOb+4TLYuwaIj9PylJvjNvq2nCh+/kjqwweXlNrURm4aaTUiKw4q9t8Ko1SWeoqsJAgLtJBsCTZpgDWFFb4CNxREufq6g3qdyYkf1HqGh80mdOPdbatxvDtomtn/sxCbC8NUdFtY+L7vhUDlWTIiFHwXWW54x4v//oV6Fc8zonbjXY7ObLtf++1E+rhzFV5G1rc/HMCu6BaDCHxb9VLt6mssnu/ayJ1ep9e3CgCXbVGQ7/5U1miI0lKv0LbAgZi9wRr79yLdeFxn7Kfv0YOr8CAfEfQJR8NY2qNE+nB23sCGmS4pi/6gs5e2kfbELE/DIb6XbMAZsOV5DmE0dKBcwUq849v16p1o2HDEE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7071faad-a2b2-42cc-dfe0-08dc70148ea0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2024 10:41:17.5623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FenhwfIXi6J8k6XOCXKTqH+aNbsjM7pp9mwmnpKiqEFhX9cMFXivgKX6Srp/5v980W4MPce7FwgAQxEusPTqew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7337
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-09_06,2024-05-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405090069
X-Proofpoint-ORIG-GUID: DlNvUybmkAOD6SAhyQzbsSgW5cIoN0yI
X-Proofpoint-GUID: DlNvUybmkAOD6SAhyQzbsSgW5cIoN0yI

Currently xfs_flush_unmap_range() does unmap for a full RT extent range,
which we also want to ensure is clean and idle.

This code change is originally from Dave Chinner.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 fs/xfs/xfs_bmap_util.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index ac2e77ebb54c..5d4aac50cbf5 100644
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
+	start = rounddown(offset, rounding);
+	end = roundup(offset + len, rounding) - 1;
 
 	error = filemap_write_and_wait_range(inode->i_mapping, start, end);
 	if (error)
-- 
2.31.1

