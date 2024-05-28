Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9997A17082D
	for <linux-xfs@vger.kernel.org>; Tue, 28 May 2024 17:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716916545; cv=fail; b=nEJKdr7mmoxIg3Id/Vs5UitnD48blBpmH7S1JlZQpUsmTR4JRgrdkL7cZV4yiOwWug5k98iKkPEY4CgYXLcrxBP72GX2KcAkJxQt5lvgUv4v30c+Nvm0MgF+sI2imeyB0Li29i8R4DWu++NhTypaLlqG5mN63PTz66mP5R/d9fA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716916545; c=relaxed/simple;
	bh=77wGsMxhHFiDNGcwZwLh8F9eY12B1kD8wYlY0EJhfFU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VbWGJcJu64xsTfX7TAr7Y7ikrJsfSFY5BeCuFikW7HKQEWoUr05Eh7MpDZPVrIn0z+/QxebDjn8FoZP5w4Mctf204tOUIxcbicYcw/6FRcudOyWWh7g6dCmCzC5wWHRgsbC6yd2ArhouA09jamxB+x+EWEWjmcgUdY5Y99BAvuc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44SBovMt028895;
	Tue, 28 May 2024 17:15:36 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-transfer-encoding:content-type:date:from:in-reply?=
 =?UTF-8?Q?-to:message-id:mime-version:references:subject:to;_s=3Dcorp-202?=
 =?UTF-8?Q?3-11-20;_bh=3DKJ/yR7Iw2tp4FEOAEPUV7h0g9xg7/AlPLwZ1zEuEUtw=3D;_b?=
 =?UTF-8?Q?=3DoMefJRo428GzKg+aZk4dZEZed1Y2qgGDBh1DA0M3Ig9ZhYmX/K8JAb+AipTw?=
 =?UTF-8?Q?FTln30Pq_mAk6HGjS86Grxs82/woG9esF0ttwjaNnMCQSb/+swiBeVxliHCAALl?=
 =?UTF-8?Q?nXgfTXJ0ZEbj5T_ZqYgIHyvSCoWxmYv9oAhSB0HJbkaDV2LkKW9X8Y8cMSfZkpE?=
 =?UTF-8?Q?FDlYCXjlO9R1DNUUhSDz_BOym7KXqhMM4ZixpiCMz0M7/au8lNFEP0UqQRDY6HI?=
 =?UTF-8?Q?rX4DuujC7THcqWUlXCb0EzfKog_f8/EyZ3JFJLRb5Qz6W4rIelQJQ3X0W+dNRk9?=
 =?UTF-8?Q?7+GMNIZhQtShAIhUjkZLOsrRx/RNkL00_WQ=3D=3D_?=
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yb8hg4xhm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 May 2024 17:15:36 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44SGPcsw037637;
	Tue, 28 May 2024 17:15:35 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3yc5065t00-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 May 2024 17:15:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kND/q8JbMDhQU//1HrWTAs27mhTe1AOJs73+QoR2bd1sRLheYsVtknrk2uSh+4pqVXzB0NXR0y5UYl4QjT8qyOaDSg61kZPyDm1yPsiLy6k5brrHVcLCxZAP1SQUPpuNSLt176/5VXuwDwR53XJGGM/qeoOFxa2T+s8jl6nwkEF+hXV5PQbRuqgqNu/A7ni0w9MLDOjdoJ6tKGfHrbkP8JVgaFGTiXfT8LemIsOg+ug3Vl5gKg2bEuX0FFXLEWZxtBOXus/x+l+4VRwZ7Te6wz+qYRcRHv4sxNQeyLxDRoVwuR3c7pSbetRHqQBE5P4xYfgf1ftV2bcDv4HeEddoCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KJ/yR7Iw2tp4FEOAEPUV7h0g9xg7/AlPLwZ1zEuEUtw=;
 b=QM54XFS/cGJ/tFQPEZv2jKuNl4cz6DEa0bif6intfyeNQjWlu6XowusMBR+7oZHomUtDjZNJmy2dclvzBaunPlfzKEsaYjQChlEz0N7D5nFpeJkig27mHdBReCyfw+Fzg3pJpX40CwIpGworsuTFMFLyWztbgLBB8lY24FNz/H2F2eEPZDJ//8SRIeoAQG31Dq66IL4PjHsE/fkP4a3pyYW/Eu63LmiZnogwWd9DPSJLIakKYA+udM341cKfRxGlK6+JiZq4zL6Cf8yQm4eTehm7HPk4WgIGgK/qlCza+Gpydssy29wKZ848n+buslPXbBZ41+0dveL49XNnDum6gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJ/yR7Iw2tp4FEOAEPUV7h0g9xg7/AlPLwZ1zEuEUtw=;
 b=vedTkW+udJ4l1NX+1rVBY/pB6n+jRdwl2atdH1CXNNKF8BIgMpEkaWzoNin36yjyUjtMvRb/sZqo7sebBPJwzbXyH0+rIcJxVZ91UbaLTxD7TXaN3ljDfStwXsAxmly5Gr0fB9+3QHvuuv9hjN9lGzIw2MkENI1QBHLFsPuO5Hc=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MN6PR10MB7999.namprd10.prod.outlook.com (2603:10b6:208:4f4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.31; Tue, 28 May
 2024 17:15:33 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7611.030; Tue, 28 May 2024
 17:15:33 +0000
From: John Garry <john.g.garry@oracle.com>
To: chandan.babu@oracle.com, dchinner@redhat.com, djwong@kernel.org,
        hch@lst.de
Cc: linux-xfs@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2 2/2] xfs: Fix xfs_prepare_shift() range for RT
Date: Tue, 28 May 2024 17:15:10 +0000
Message-Id: <20240528171510.3562654-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240528171510.3562654-1-john.g.garry@oracle.com>
References: <20240528171510.3562654-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0239.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::34) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MN6PR10MB7999:EE_
X-MS-Office365-Filtering-Correlation-Id: 8406fc88-3b76-462a-4603-08dc7f39c870
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?DPuQOMDAJXUdiA4ORT9Zef7PJeDPf/0QMcv3jXFzk7nmwDGJ+F1rf4GLZjSG?=
 =?us-ascii?Q?eDSYMIdBQR3PICpr0coiVljPF4IaZ5NSOqxwlswMLk3XbzG52y7WbDlraqCZ?=
 =?us-ascii?Q?uYymQILoctcJBk0v5lwetHNKs48M1e4k1AEHz66HY3A8XYn3qtb3UOHbF1Fu?=
 =?us-ascii?Q?qq0fmCeFPyfa9vwDJu0iERPYcWUdiaeVBuME3ZOAq3DcAkH+KOkocHMR5rE6?=
 =?us-ascii?Q?BFlC2K0c0d0FIqEPa/n76w0GMa6bbAxks9e5efNioPpXnSK5Mfacp5lfdXRt?=
 =?us-ascii?Q?hmsmxy3Ok2xbl2woXYTIr88GAlgj6PgjCMU0sHJPNRG/GKjlPKMnYIxmwID1?=
 =?us-ascii?Q?/ywtLBFtIkraPKVFxWGZALwJVG/QMXMeuZYTpaXT5O98mmb3LyT2pNLs2duH?=
 =?us-ascii?Q?XP2bi99tiOWBz3rYV/wfnKQqcXA8IlVZ8TBwz2qCts/4tgWmwKbJ59lRmLMQ?=
 =?us-ascii?Q?0OCMc6hs4SnNAhjt/NTRjyCnRJ12R8LO48M0q0T8wsUCsFF9DCfzUPEFYYFJ?=
 =?us-ascii?Q?yFz9uIz2LlcHRkjHcp4Dd2CZ9x5CxzwmkI6+TSfKhqFzUW33bys4VAoqxI6f?=
 =?us-ascii?Q?q+A1ECErhZou2FSE/+su8VWI9aZrfPackhU0oBXKaVa8WDz4PzcL83ige6PX?=
 =?us-ascii?Q?4dw8fX35/lTMSiwC4wFqzM0MRb2Uw5iVGAXGY8xIJBIqnN9IXOXPhMg0ewTs?=
 =?us-ascii?Q?QI0UStfx9IszoVxfJ5J4HjAjomtyQyQujAqr6z0dKgQflLvw4ZtezIhWbU5j?=
 =?us-ascii?Q?KMo1sPQRaMQLWrI0UCoW3FmUJoUROPqePjXA8Qqh+vMdKFkaBt+At6UqkOEN?=
 =?us-ascii?Q?q8qxX0Z8R3Y2MeZr15aKjpFsDz5L4Uq9F8n3dBmHsRsGNv/tC+c9tpskv8Sm?=
 =?us-ascii?Q?eCsajnsZhWwq4g56x4RIklXoWJLrMdTq4WYxPRNy0BD88TfzGa2kSYhbVwrD?=
 =?us-ascii?Q?EamlqJ2jI4V9DUQCHrYGiiwwZTgGj6xwhlQuU7HuxC20JbAXXeP3O2kLQJJT?=
 =?us-ascii?Q?Yzxo7e3OO1QYTLSaDsRKKMph/mfqFGzJLugB+0tgAwD64gk5CLiYVrqvwIS6?=
 =?us-ascii?Q?+rY/XysY3Mk//795LUMUA4jM7LhDUUDDGv5Y/LLK+o3G0lILTbVGLHfTcwzo?=
 =?us-ascii?Q?eIZTjG8OKgqbov2kRJ1xZz1wB1JvrvCMaqYZ11SfxCeQm9kJVTw4TnJxgRy+?=
 =?us-ascii?Q?og9FNAwGKQZKFaCE3POJkoxX+I+5tabwZ8f/rwnuyhguMCwy/HP5ZrDf0f22?=
 =?us-ascii?Q?TPv/v39FVK+HdWZDIrCCClWjxozqYB9MuwdDcsQDHg=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?BwFGcbVGyKMUklulL5CM1dpl4OVlGbeqXAm2Of/XMMFWOwm1LiK4ozgq7sE5?=
 =?us-ascii?Q?2EDmiG37kfnmmxEn8QTjgQWueO06jHm5yN8zdRXlySfU0mgBm0a5Ho51Jp/k?=
 =?us-ascii?Q?ONLHKPUI5RmtG7qX5iy+6XfHtU+X90BAySpbYGX4Kh6I2ERjLF3qzS97oIoX?=
 =?us-ascii?Q?axDdfDR6fDrzKZnTpYvnxWzxF+5s6D83nYzblokyXfthFfBJ8MT4j5vnYZxL?=
 =?us-ascii?Q?B8ZxRFyZma6Lt/GSIlU1GXgvBuFgYvcrwQzrVP4S2j0rITdP15UyvyrYLlSq?=
 =?us-ascii?Q?8XmZDusbo9C88156CNR20ZlARR8yhaHvunvrE00indDngRMMApT5dDPw6BgU?=
 =?us-ascii?Q?ttsnrG6biyyI0za/x4Z4QPGPulz72UrscJW+p6ZWEiJt9MnOQOzn9tZs7YnF?=
 =?us-ascii?Q?cpDBzwXmeKViV2SUyNt/i7P1ckXYIiX3r5N6CArHqMGw0ZgO2diGcmbd3NoG?=
 =?us-ascii?Q?zEqJinwt/yX39Lbo835o3Yf1hbpNdke8dWV2w//Vgk+Z56/TbWyBX9dYCKZC?=
 =?us-ascii?Q?7ub4+XtX7B9Aaoiwi/arPwRM6vgo8toVDlCYy/7LE9blN8D0h5QWj0mVhln4?=
 =?us-ascii?Q?5jeAKR6uEIUQWgvrPF1rs06vUIo1G/wfKvS7LO6x8OCzUQBOmai/46b0IPl9?=
 =?us-ascii?Q?xax/HzrBDaXofO77bir88Gi8bW7z1O/plHIMCqIAWmguPGptDDTnM2WRjtbn?=
 =?us-ascii?Q?Cu8hWatUVuFx2V16t/fj7JJQBtvO4mzZXZI3kvwyVYyBU05GKbZBYGvObYJ9?=
 =?us-ascii?Q?FtqBynnA2kggJCSdfNT33Lyjds8faCFPuXzAZzbY/36UyU2M1lgjWODbMYrL?=
 =?us-ascii?Q?ncacDtnZLIFM2n++pE4cadkwQ8jJTHU0CQJk+x44lgiaVijnxEOD7iBtvQio?=
 =?us-ascii?Q?g4EIvPpJwchWi9k+i48ciZJjDQ0tpbbkopA6jllrU56xOB+1LvpjWxAsGbjm?=
 =?us-ascii?Q?CfOZfxABE0/rT7l8OmDzR23ODTPnIpROMFSMzF9f7VC4TxkGchs+MfVJ/JWj?=
 =?us-ascii?Q?NCkKbEuAEgEGNWzPUyd1xF/Slt8G7sSpzUpWKMK3GtGZsmJP0KgBZIEwM1ov?=
 =?us-ascii?Q?gVo5gv8NP2k/6zTqCqDDi9m6u9VCn2h1YYK7h9WivSQoCnh+PWjHuF5fpKR1?=
 =?us-ascii?Q?AqMBH7W+b1gjEfDzwlic58l/02/7XyGq8+SAAifCdJMRF06Gxb2BugIXziyP?=
 =?us-ascii?Q?DfK6derBndxVCBuxZuxYzdRLOERRufu/UblUWLuqQzA4+xX7G+VdxY+J9bI2?=
 =?us-ascii?Q?8BNlgQiPBdUPZAu61s1tJwvXQrHHz6kGLmvmvp+Iy5T4eBglF6XfipTQQQpF?=
 =?us-ascii?Q?G6o9EmTRWQ6z9yD5G5dJuq90WP09Q+oSPsmgjtxNL1GSX6NLsRVXpSekOHWo?=
 =?us-ascii?Q?2NkOH/lalt7z94oTAMFR3AuX1PwfnALgWm3CzLT1hu5s0fCFPX0lnp2GeuIF?=
 =?us-ascii?Q?Q4gym1mYe5eMz8/Jmdk2w0ghNSKG+SouS099JjGks4ZZQ67dYfa0N/hn0hR1?=
 =?us-ascii?Q?iU6pOQsmMTqrmE2syh/X0A5ZiUBEU7TkDIO1hcszd0lN8amAPVhXzOnXRXXX?=
 =?us-ascii?Q?Cnt7mIj4hC0lVO3Ge5jaIzQFhLMGLHC9k1qDy21pBpKngiMDEZKuZYzv6I0w?=
 =?us-ascii?Q?2A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	bZrdsFElT+pYnWzBxQSZePA8TWyW87LkuC7hm8cfKQXNofThXSQnqR1BZfre0djxYMs5+kJKKFIkleON/rcK+f1Ko63N+q4YnuqxpLVT6a/imwfQDesqsADkBSfe1DHPFt2cJWBZUg3CF8u0uqNS4aGY1TORnV6BNrGkkpJjgL8uISzG5tdnu67N+egReszEO2DcG0+xkK2SjdFY/u2e18i7joureX6pYpYwfADUNGArbF2z1xlEyBWEmq44syPYKIDNJUg1ap6CkPYHvNSdL6jI9EwoyRxt0jK/Gt+UD7K+nLLlICubhc4c6KN/RypFOs/VfU5BJWLxG3w+Lf05OrG/xeKFhkx6TQEmvT57WyPh4pNnjyaBNTIUZFubhAKmVHPxYkovQqpN+Xy2qe/TVyGMqD74MsgvIryW8mp7oqFXpNwzDCpbHtgc/wB1J09yGUiohCmHSpBjIssjxa3QnXpcRXYoo58CgipLOo4RnNiIdoYKUsn7x3/o7gdvMFmFNyFMHlEI+XHbPL2fqE6q6x1USOEXwTdSr5+cTeDAtEqi18qRZbyzk9odlNSRUekpkE45F9rj0tGzr7OePJG+6uEbBBMCjvo9dmR+9TDj1fk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8406fc88-3b76-462a-4603-08dc7f39c870
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2024 17:15:33.3673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SG3FPu6ysWgzi9ZzjJLfqkEjKBikn1JhV03TVTixQq9mnkO8NK+TEx7Cv8n4JuD5dXXSmNXAak7H49030KTUPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7999
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-28_12,2024-05-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405280128
X-Proofpoint-GUID: 9vyKOZhUFEWKH0oMtGT22lcsbw4AZwcm
X-Proofpoint-ORIG-GUID: 9vyKOZhUFEWKH0oMtGT22lcsbw4AZwcm

The RT extent range must be considered in the xfs_flush_unmap_range() call
to stabilize the boundary.

This code change is originally from Dave Chinner.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 fs/xfs/xfs_bmap_util.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 8a8a2102c6ac..e5d893f93522 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -888,7 +888,7 @@ xfs_prepare_shift(
 	struct xfs_inode	*ip,
 	loff_t			offset)
 {
-	struct xfs_mount	*mp = ip->i_mount;
+	unsigned int		rounding;
 	int			error;
 
 	/*
@@ -906,11 +906,13 @@ xfs_prepare_shift(
 	 * with the full range of the operation. If we don't, a COW writeback
 	 * completion could race with an insert, front merge with the start
 	 * extent (after split) during the shift and corrupt the file. Start
-	 * with the block just prior to the start to stabilize the boundary.
+	 * with the allocation unit just prior to the start to stabilize the
+	 * boundary.
 	 */
-	offset = round_down(offset, mp->m_sb.sb_blocksize);
+	rounding = xfs_inode_alloc_unitsize(ip);
+	offset = rounddown_64(offset, rounding);
 	if (offset)
-		offset -= mp->m_sb.sb_blocksize;
+		offset -= rounding;
 
 	/*
 	 * Writeback and invalidate cache for the remainder of the file as we're
-- 
2.31.1

