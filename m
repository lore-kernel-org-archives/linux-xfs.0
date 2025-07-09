Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAEA728851C;
	Wed,  9 Jul 2025 10:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752055398; cv=fail; b=ZSfhNnR8w5zYEQYeSaZ8649THjYobSzaa9fE1FFeKfWciytyw8LPO14QUDXCe+IQMtXIRx10D9GooC3Q0V6592iyFanZM0xjLcjFoyOn6nWPrNmEySr6pfZGuQR3yDlfFAAKdgDjy0RdsLL7exuEa1EnWoea+US6703q9P3UaXE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752055398; c=relaxed/simple;
	bh=PuHgec7ncpNjXiGFwJbs3tEgI09DPudRd273jP96+tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ksJeCnC/FUMHrZbAAfoKFLGwtJReY1RbjNBnb1OQC8ZQpCo9rMM+PYcrWwHl6Xsz+5EcM7D0IsvquWZsU2Op/TQ3M1Tcfi3Jw7Ym+CPzs1CQk1bZQXrr5Imhlqh6d5nTz1ejl+ux9MusSRA0+IIHrCU6LORp5lM/vyTEFkwG9Ns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=g7Zk89lk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=n7ZLWP9a; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g7Zk89lk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="n7ZLWP9a"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 569A1xU6012739;
	Wed, 9 Jul 2025 10:03:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=wfnekfYWYFkA7XI1USgf+pECswqVVjimrCP9cotsix0=; b=
	g7Zk89lkfXG1DqtC7z1Gb7oEP2VKJCcEWcqE7y8/YVimqv5QkUzZOliDQiJSUjRN
	FqdggasM8zDrfgNxkLJWy08xC5AxZOnSMuwcQQ0cg9pUAHx8oo5VLG25A1kZkeml
	IeozPjDE+IWPMmen8lZ1Q5o2MpCPQS3qqInnClVJC4HEYFRQWXgkXMWrx0IZQZOE
	ZRjQtrKYMOOcqm8bOmdDCK8RXLR7QlQBhW9PLMtiNewLfyHm9CSZLYv0LCNpjUo3
	ElJqfeplWO1991/AEaHJfKMSwbeOV4h8X+NQVGlBh3Q/1NZEeIuglvG/fLxAb8gF
	JIipOcISA4OXQ9/6xTLBgQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47spadr01f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 10:03:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5698nC6U024391;
	Wed, 9 Jul 2025 10:02:59 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptgb1804-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Jul 2025 10:02:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z5Ix5zMxEoU2y4rYaFldQs4uXK1/5cas4iL30crp8zrFcVV8fVlArF5LSDIll5HI3JtgWrxOYfpleNF8jL3E3xzoGK9V4dW4xISibQF0mgLDpZKbQTwC0NkviNxlVLw9+ke7MvHW1bAbCZjtPEKThrTcrqmvuRiXwGMpAIB2PXJ+wlH4nnXGllX6RVL0KNZd7ehN219unHjJcihcuuFU7SGuZfmESRgQaDNSJoTSQuTmiUZyTGTwipPlpXDbtidh3ZeZayt0lfirGTF6zgvzeCJgTWbVtK0/8kz9VyKk2q8+XeXRvhyl8Hyco3cfEfO4UZrPEA46QdZZSAkzr86ofg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wfnekfYWYFkA7XI1USgf+pECswqVVjimrCP9cotsix0=;
 b=QU5zhBq4/vLCMSjN3aLsuBrTT3RFi9iebP5DWzip/yL0K4jK2WCGuU8A38mDV61+0SenyKO5SeuR25RqrUpsEy0qjXgEotCYcuOzU4gxersqtnV+uuVKNHXaYjAkfSA77xUiCMFHEi1NhXBshtLx9tBW46k1t2K2nZuCskKF7pbUTjRTAj6imlbe63OBl2BYy2snvKzTdNxvau3Hhep62I0QBy1Mg6bbWlCSrUjQ2uiiEUxpN+nT8x4qk0BRKAFj6IHyJdQKvZ92We6XAkfxQI9V5e7qClGaR90/S6OJWooddEHBKzUzxAZpmqAMiPkHHI1tsOdFprQX+4N41hoH4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wfnekfYWYFkA7XI1USgf+pECswqVVjimrCP9cotsix0=;
 b=n7ZLWP9aIwVmHz0/xayvfbXMYPKLgFOWC7TAPIT/LqzDHGDuMKg63JjZGbOAB8CqOmZmYDFCrw5XqOxTh8BQBTq3MI2Hy7300i8OYAt0iQy4TsQGGqUTPtmNQmMzwHnTU0t3X4pubJQusX87rJKwZQ4T1c3aOsudcY0AFMJ2x0o=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH0PR10MB4744.namprd10.prod.outlook.com (2603:10b6:510:3c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Wed, 9 Jul
 2025 10:02:56 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 10:02:56 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk,
        cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 2/6] block: sanitize chunk_sectors for atomic write limits
Date: Wed,  9 Jul 2025 10:02:34 +0000
Message-ID: <20250709100238.2295112-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250709100238.2295112-1-john.g.garry@oracle.com>
References: <20250709100238.2295112-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7P221CA0051.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:33c::21) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH0PR10MB4744:EE_
X-MS-Office365-Filtering-Correlation-Id: 076ac258-facc-414c-b93a-08ddbecfc713
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?s61hejWJTTGbesJGsl2bmlJc4ZFL1IXbEGlS+4Ib3GNalO5hxCQxLUJedfpQ?=
 =?us-ascii?Q?Ge2rycJ8ejWY/cteUZhL1tSQyrTNUeqnSxtjSeY+edluHtUv6lznN7aHSgIk?=
 =?us-ascii?Q?I+8yRxCnZbGfupVBb32J5d9GIryGCEIBnnNV3TUQC4rcApDgBi+lyftlGzVJ?=
 =?us-ascii?Q?3FGK6s3ldCNcMqJXTUBgahiFwzNj4TClcJhwFqzZxqL7IYafNbOahgX+iKgM?=
 =?us-ascii?Q?2x4EyQ8hRE2S871TYrcJrHpcaceca9diZnexkHVnMfkGikX6hk0VthmSTqPN?=
 =?us-ascii?Q?XLb01Auiyur2g/ulRyqq1wIwSUYisNZfWa7wIE3vySHNA/lomDFP2h6Di5d+?=
 =?us-ascii?Q?vI4fzfQwvofizXwT5mmuCJDbCXR+7agc9pBMQ96+rD3bQZZ2pcJg2yHSCz/M?=
 =?us-ascii?Q?RkqndgLO/kSJB8ZAbw768hDPMYvHpnJmSQOzTlNQH8y6BGZPadwqjhGdPgKC?=
 =?us-ascii?Q?dWlKo//djVDif+9tTn2qKwmG5sSMbtvAHtU21ucYvysUDoiDHnn7lWyaWx7N?=
 =?us-ascii?Q?BYNebot4C/CY5VKwDVzvO6Fcs65wvYwWUlbjLHaxY+4dbyjRDJT6pndVatWX?=
 =?us-ascii?Q?yFlbKwuhuIMfJcM1BvqFYVJVr3FV0dBxHO+Cm4zO3MhV+ptBOMSJwh3/GOyH?=
 =?us-ascii?Q?WS+cNrLl6z9pcFZnIg5Y8AkGyVlSQRGU3efbtBevdSLs90p++gsgqwaU9bJ6?=
 =?us-ascii?Q?dE449IQ4Ci15dq+SIhf9MoeFO8sbONqmUbrWoP8qgvLED10BJQpvzMgmmMm4?=
 =?us-ascii?Q?m8S1JDz6yo7xP+lQ71vB4X8DmkHBq3fB4+5OfNlkHJf9wC9lv4UprkqnUXDf?=
 =?us-ascii?Q?YmuFV+NehmIY7L4Mn+Gfd2LAu27+ShxkyA40fFGZcMT2NklzLsTl/PtotncX?=
 =?us-ascii?Q?9B5Y9mNtRytid8mjIIB7OvzOfLFTd46e0OdKi/jDOOtC7qnZ318p1BcoAmrL?=
 =?us-ascii?Q?1a0ZwTJpLcbHyYtCAR6EG3p5CFSd0OrzHQXUFJpeObhn+ijRvKGwNESlDXWm?=
 =?us-ascii?Q?/xXZtnMvFUN9wj8wvcFixBQ0kbqLr59ZjtIH6fzolqEuD3Yzn/8a46b2iqMY?=
 =?us-ascii?Q?wEMQ4srSmYL6wxy+ViXtrPfVvruAR5DKjZVDXB1303osAoacb5b2aHaH31of?=
 =?us-ascii?Q?Cp0Kdq9KVx2B9CvSUnkmMWBTpoiYRaniGkJduYAiHfGRIc4PsZeDSWXnqPXR?=
 =?us-ascii?Q?uzW+LYNk5uawFC4Z5xRfgygr6rnqh5Zaihy4Ob/RvBXsDfJEfJ6EdaVteGDX?=
 =?us-ascii?Q?ik2lHQiyvWMM87SYSVcsmZ54plDnhpVE1+52HmGq3UDNKQUrCfZM+cFtEDWe?=
 =?us-ascii?Q?pqs2vVD6rjRNL5Q3+WVBAv2nzyM0tPQKkhYmnJTsOQD6H5RD2wofzMwJi8RZ?=
 =?us-ascii?Q?SxAoKMbAR5b26wLrNlA0iGWOLpvlGmm6VwpneNUkpbJavLHQC+Hkz/z3SK4f?=
 =?us-ascii?Q?YxDmpMAY+ds=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5KAW9+CH6TOL57ToQxDomdJYnZqgfQs4z2/WSw1i677Qf7JY4ho+zRw6YKps?=
 =?us-ascii?Q?8StFlXG89O6eCn/wvyVfJBMtwxda6n5Wv328eSYniVdhJ1hUxf3HasuCDMaM?=
 =?us-ascii?Q?YTIB94sAu02XIsi/H4Po5Yoqlp27IeGpMefwUGfKXlYpluo4AoaOXZG0Q5D/?=
 =?us-ascii?Q?lomtNBbAI4AQ7MlnuxiI2777xCwWlEsIrJjH0r4Uz3lX9TtjeLjqdWtdkZ4N?=
 =?us-ascii?Q?omkXlz93iIYkP/sW9h7BXTO6U38KeI3+7CFMzsyiczEW8XVUvhSHK7QujH9G?=
 =?us-ascii?Q?/97lcM2FPxSKnjVe8RjzUtOL4OgRRqodjZK+p1jyXDmp4583ulw4bTQXpte4?=
 =?us-ascii?Q?nkBmGLdMvpyPlcqDfk3RN4z9NG1j7L4YoRqhecTAP2iL9pHGDTocKqJbSVLm?=
 =?us-ascii?Q?zxCCZ2aiA1LpiHFUqW/jniXukGOPVabsWkqdQ9Q6hYdz/1blbbKfWlh4h4Zi?=
 =?us-ascii?Q?LTSRRPom78nn+rOVHO8m/gubG19yvns/1EHNMDPS6WuEj85F8dB7T4IACdOH?=
 =?us-ascii?Q?YMCArJKVg7+usQs3MUL6kEbG8fPO2WI9pbdd1Lk9l2QE6Mqrl7t0SsNMKOGK?=
 =?us-ascii?Q?XXTBMs39z6EQw6ndMf2wBER1Sdc5mojxqW0BQSCUACAFy5TqRJxh+K34soca?=
 =?us-ascii?Q?UipjvPM3ehyhqBmkrdhblOe23N8ftOUCrnRxEyvPU5fYLVtLNWsds4IAMs5y?=
 =?us-ascii?Q?iAk0+Z0oCUB+mS8FY+BfV5Dq9sj+gzQer3hR2JrmaMmVwbgZJ/Jazt8BHRL/?=
 =?us-ascii?Q?Xv8TH/R4YcrFnhZG+VptkV3PyptPTsAd/PkGX/GL4nFatMmGYl7oG/rxYv4S?=
 =?us-ascii?Q?LFOUzs4bdxB17PB0ovP9K1xvx0IXPoElwEdVUA12WB/W9EjSYgs6EjTgo8wZ?=
 =?us-ascii?Q?BlxikbWzPvY+F2KWJnoMvAggrUswKD6WLMCkXHRLvL8SV2Nk9LuwWasBpo6Y?=
 =?us-ascii?Q?GFPhA+bLTPWu5UVz7pdKBM6P4E7NgHvuZZNBOz9P2PfvH7ekOItmsxVYJfK4?=
 =?us-ascii?Q?LoOt5BjQZlQBcPEPRTgGDzMSBAYYS1ckN+NU49B1ydZ6tBmV/BdEPl39t4LZ?=
 =?us-ascii?Q?IIjOGuKLCrkFYktCAToBnlRxDMsSrWoOrGvitb/5Fwg6C02WDPgZ6hHHiCa9?=
 =?us-ascii?Q?15z4avnZUa8j/6fkI2/4IIXbCZ9XQTsRfAUAXL2/kbwp1RyjCLiOLnMV3o84?=
 =?us-ascii?Q?S1+J2VNAhf3eaZLYtoL4dMdY2GALINj8Rh2Yn93tThtaFPdvROzomS2xr0FS?=
 =?us-ascii?Q?U5wW2XKjm229XySIj3gaJ1+1JD2n0PJJrJNWeYOmwlAOCdfHZ3gW+WYlhRBv?=
 =?us-ascii?Q?KGJxgmgLqNBUQHOy2U5qHLbm2eDdUlRy2sDFAMSqytkWX29oXQCKo1DM56bn?=
 =?us-ascii?Q?M8nHtprdiYPZFSIMyy33hXu5WcpmYTjKkRVK/mBzpucXtWsHpw6sWcmXXvuh?=
 =?us-ascii?Q?kV9CK3SvPnWcqSLzjTG9wkbHtGlE+mX1RVdbvvBRDvaVcYlfkt38YZwzdhPC?=
 =?us-ascii?Q?EhOSF713aZi+WEOrcUpPX494n3pHdaLbCO7c6bVaz41XOdHXe8GmNp0XZxLu?=
 =?us-ascii?Q?OGLB37h5ogpwCGz2YavsHllxzB59kXYzqg850XLsYI0PmYmmhT5JUCpG3/9S?=
 =?us-ascii?Q?kg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2qv2OQmTU+oAvU3tneFAxOdlFiYmTV9BamMYyTa2oRaOU1thgeb5sfPgAMLQSM5iFEECxhK8V+dqJYjk4O8s17cK9J6k7a6nJgQGlt+YNXEteo9vhpOGV7LLmgMPTwWHqN3CQJHGktCswuhP26TS4YWj8b1fZ6W24UNNDNTu5Gnwwwc1Quz2ghxY4w4gikJ4mCOyhl6KllMHgfYuCqXinqrRXWVOna5wKuU96EXLS6cBwsjWXMkYLuutP1mUbyRQrGfXZBQ6zkBoJsP/asCWRKHZiBQrWfwsRJ44o9PX2xU/VlXLkmeFBoXt7Lkd4UtFLkE8DQM5AOB5m0+HvUSk1FZzYFOBAlCfEHUZsYGBmnLd+08+QZ08rFYo+17eSPYpXI6KWbzosXHkmDobOKnxuwDE+kOH50Jp6BMMZYW2USa2DyTUajbwVn14ZaSluB7mIurr4bbcH36LJxXpktR5kZxK0Q6DlbRb0VVOGvqPrEgaUxfiYTQ9yt4k+RFTd1z53gdw9aIQCAgVOeIy1Ojtb1ckZmzKP0FoeGvXvWhIouH98/BMmELz1i4K191zN776wvnyH6q0mp92sgBPa982eCFrqmtDmC5EpDsNH/+eneo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 076ac258-facc-414c-b93a-08ddbecfc713
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 10:02:56.7750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vSBR/knrk73PpMrhOMbYITCPJthn5RxDjmfyCUmwn6vgDamh8ITy/Ad6ggdUE3sx59ChKyRDwalWMAKDOBsIlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4744
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-09_02,2025-07-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507090089
X-Proofpoint-ORIG-GUID: GuIjVSYklONI1dk0Ik2ecI_emBvNmc5f
X-Authority-Analysis: v=2.4 cv=caXSrmDM c=1 sm=1 tr=0 ts=686e3e54 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VnNF1IyMAAAA:8 a=yPCof4ZbAAAA:8 a=DqzVqx8i_IFAgmWpyL4A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA5MDA5MCBTYWx0ZWRfX+wdaSwFouBxI svOTpgVNlNxLmdVIW4fDrQT5SGxi6gh865d7saoR5knapme3vsLBul6aifuKs5jNimwse+smOoM 9r1IF6gcEzVsE2SLkVge1iB5GOT1S/2LAmAZWeTLFAj0b/zRtNqoSkXlvB2LKMsuwIuQbfjDHLj
 +CrTfXf786tatPGg1zUAsH9lrpNSjw1hUvmUDauHYGLAPLtRci18LFdKLwZt2yU+ntKPxeSbn5U uNMxZqngM5C6WjOrWJKcXKkR1i+SIylOzeX227KF+PSDHU2tmAjqB5q3T/KsdJHEwA+iB2KOJAo DKNJWjJUI/GwwabxFVsIPkBG30AeJK3Wc4djr++374+hS1PmUr1LewISted2JJ2zSTvFNIxGyLd
 Bmk5QDxS26CMP3HN1o+7lHq9XwjeLElkOprR9tY6UOppY4ZH28R3PJUiPF0KYK/cb+ZZszbx
X-Proofpoint-GUID: GuIjVSYklONI1dk0Ik2ecI_emBvNmc5f

Currently we just ensure that a non-zero value in chunk_sectors aligns
with any atomic write boundary, as the blk boundary functionality uses
both these values.

However it is also improper to have atomic write unit max > chunk_sectors
(for non-zero chunk_sectors), as this would lead to splitting of atomic
write bios (which is disallowed).

Sanitize atomic write unit max against chunk_sectors to avoid any
potential problems.

Fixes: d00eea91deaf3 ("block: Add extra checks in blk_validate_atomic_write_limits()")
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-settings.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index a000daafbfb4..725035376f51 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -180,6 +180,7 @@ static void blk_atomic_writes_update_limits(struct queue_limits *lim)
 
 static void blk_validate_atomic_write_limits(struct queue_limits *lim)
 {
+	unsigned long long chunk_bytes;
 	unsigned int boundary_sectors;
 
 	if (!(lim->features & BLK_FEAT_ATOMIC_WRITES))
@@ -202,6 +203,13 @@ static void blk_validate_atomic_write_limits(struct queue_limits *lim)
 			 lim->atomic_write_hw_max))
 		goto unsupported;
 
+	chunk_bytes = lim->chunk_sectors << SECTOR_SHIFT;
+	if (chunk_bytes) {
+		if (WARN_ON_ONCE(lim->atomic_write_hw_unit_max >
+			chunk_bytes))
+			goto unsupported;
+	}
+
 	boundary_sectors = lim->atomic_write_hw_boundary >> SECTOR_SHIFT;
 
 	if (boundary_sectors) {
-- 
2.43.5

