Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A613E3C73;
	Tue, 13 Oct 2026 08:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879347; cv=fail; b=lE56PLgSE15CcP7Xqm3xzZcrpdGDqe+7Zx3wCczpTkolTs3CLnzhXSGN1UNOe3QHFTfVuEpmzn/BMR3FdOtb2YpeNXx69BohdddH11dzqB0QixtvXUqRMY1SdUjKqnTOg/FMEEFU7Y+4Zq/3p6MotNRN1qRi7E2vBH3F3/bzv1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879347; c=relaxed/simple;
	bh=zXhJWAnX75K/0XuhOWAYhD6mk2mxubLB2IPjoBglScU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DeC0GuccfawVaAU0+9l1lF3kBvwPN2mY6onyK7aeKtAP6bCGNzBvynESXCP4iKj9zPTi5dSJEkcRPDWbzpRTRV/831aRzxRnG8wu/nPpWmRu3mJhn9COIyV8DuadK1ycoIDCI/HtHEDfusovjoTYMkB7SnYh9VgHgfmmxgG6cf8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AlRvcHCX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PzP9m+j8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AlRvcHCX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PzP9m+j8"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2CQgQ3434524;
	Tue, 13 Oct 2026 08:15:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ezaQnKvqm7xcjnDZVC9xHX3XnPUA1xb17uZikLAJ3GA=; b=
	AlRvcHCX2EfKTFJ5jafkj+LdrTeLrQHEaTcNY/u6bvCqUCNC8r4L++IoL11yNP/g
	3GaUXCRiP3zFSkOl9h3+YqTc8hbD6atRJ3A0UqBU8rC7mMdgvq0PZmIPDxtI1ZEs
	Fxh6txt73rNeLOI/+F2V7QHp9f6CE8Ox8PnnSqWqE2smgXACSAYx3lLnDU7AZjLu
	CNV4rD4DfnFNOdDvPWhnqD7jFlWN7eZUTHgEofLhYkt/CwJmZCMhmjWVRkBjeDg/
	Fmv3Tb7GcT2unojzBMPGf4aDFD/TZaVHDPwvhiCAHIcvQLlMtFdactgw0KxzVg/h
	384zr7q7bWltqYM7U39uRg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7de1kjmc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:15:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86mDq034988;
	Tue, 13 Oct 2026 08:15:41 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012000.outbound.protection.outlook.com [40.93.195.0])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btp7dh7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:15:41 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HFrL+cyFZFeCGRzIfWVWj6Ox/jvg3hcOoCbKTuvj8FW51tSdIgqwSIcPbR0uy0CnlRD4XD03jqU7ax8OsXceq0rW/LbJ7aR1MgQjvOyPHo+S2XA4v6UxutDcVTm2d/yl+qBObQ7tNsjBfYJyGrvqXpRSufxCjICJlw5uoyNg9mp+Jj8pn0BY1SCeV22PAIvt45Ch7IhcIeNO+kylb338iOZ5ytdZVNX0hz9xlQwv5Hwlqx9laFRcHGwbmfa6zui270RuqX4U1GGwd3hWcvBDZfcIQoY8XnaznHfX/m4Llz4JLjI9t3Y1Qm2kLJ/igdo6rYOliAzKnuoG4AYMzYuQlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ezaQnKvqm7xcjnDZVC9xHX3XnPUA1xb17uZikLAJ3GA=;
 b=OWe1KKpJDDGoWv5a+hkJR49WEzssk/oQkTL7FuzbLJIXYnjN95wCkcS2kZoiWcs6Kp5mQmRBUbfCeIHTME5VjOKqXyKhT+ZmPbx9LcWe25YHw1H3Yjr1JlyBbVk7nHCKhI3JmPV1EzxLjVpvD3WZ+TS2mEPsvccMgZw8UcLJusmaaOO69s+C8zCQLgsWk6ZkTN8Z//oL0oxLmdin1q06kKZT7WJdzj0cyIEcRKXoxX1wxR543UAR4EIM2mJ/5Pr5uHgvuaKg14j2SEAtvh4j3yOMGaOR3fHfnqYJ8Otf3xGXnBH8xdDnYqI7yNEC0PrJAunt6KDfdvXaB/qP34+XAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ezaQnKvqm7xcjnDZVC9xHX3XnPUA1xb17uZikLAJ3GA=;
 b=PzP9m+j8sdgtZ7u/2FPUeq+nL929XK1v582mep78etBb16fZEC2Qdav5K2fLRJ4RwIAADSbUDIDFoCD0P89zBhJjSb/4BydvvcyI17HNXKnuiZmUCVMwCnFrbPryA+7gjzx4WOGUVynd2k1PJDOriZoD1wD0TByABKEboq1qyVI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 LV8PR10MB7992.namprd10.prod.outlook.com (2603:10b6:408:1fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.7; Tue, 13 Oct
 2026 08:15:37 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:15:37 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 v2 06/19] xfs: improve the code that checks recovered refcount intent items
Date: Tue, 13 Oct 2026 13:44:50 +0530
Message-ID: <04db2d87da8ad8e18498372e680325b3c3fe9aac.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0123.apcprd02.prod.outlook.com
 (2603:1096:4:188::22) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|LV8PR10MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: 0db617cd-26d0-4562-0d76-08df29022944
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|376014|56012099006|4143699003|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Md/Pj9xgpNID2BSSbP6P0cjS82TDvepEq4vXm52arNMQljyPH/G5mj332yUaxvTYpEIZP9jd665IehJeMtpDzJiPLmHjO4SVShELnUwc6eZXyBJ7OKKuX+mbd0F7AzxE+3QM7K6QST7HGflLMmTIgE2qu+/JAJEpZavMYpQypkTCw0C7MqujISomRpCXCzbRl3ZUQCTrFAn89XA5sqau2x3ytuwH6H6o1j1lhY2Bv0FUMxVMw8aHfL/scsXVeXjBHIJ9Le+FaAn3FsPjeUBtUgDinsQ7ZsQxQBrke1bG8ABLj7eSrKle9a+cNIvKT15QuFgCK82az4226U2A4egwMYCaXHcFSdFmd65lvVH6kXAnV0Mr4s8TxTzo3c7/78HaktcJCQVGIU8Lf6xqA6iOtkcRBxw4dYJQ9+v620Mx1E5AOUVPpq/4GnO5zfw7otpDq8/9whc3A4IO2tmeMP6MTwtn/eKoD0wlEvFlvpq0oFGZcvjS7NwNviGVTDZe8qQAayKyWZio0+wNgWC4BGmzCSAq1vimDiDhdXBT7+crG1Zc6ujQStMvulA0cDujSp+YV2Qf36HukNNZ/5M6Aznu3TulaJN5m9UM/8X5cYgqKluE/oQpXwvmPASTsLFo5BBRI4Cy8EYPuvijBOnY1i7VwwTyv/ADml3qdAmKhL0aZhY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(376014)(56012099006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vWoXqyK+OAYJ29Gv6DjA34RE4LlC3Th2sOjVEe/8EAWAIlkml23pqQuiuaAL?=
 =?us-ascii?Q?v0MrkRWW5Xq2vuBJxNzpXpBDA/ins7y4rS4X4gxUpmqjAg7Bnz4qa3xmZb/I?=
 =?us-ascii?Q?OrP3ubyRchmifx6G5yv3IX0VOxsbXGPVhM6d30N5BA8gLhveRriPajf4pmjA?=
 =?us-ascii?Q?GXLRG6YD9J/uSoYrOZAGEYp0u7f83lpq5R0LXlfI2niCCZwMghXXf40lrhVn?=
 =?us-ascii?Q?VG9YlkpFt36GDfQqvGlIKrKMalX/Sb1k+p0jX4tcyJinu+mdS/ILk4b6iSwm?=
 =?us-ascii?Q?zOJDcUA4DCeVTqON6g7oKoiNbP/KZW0FP21T6YMI27IG+RvnowqoB8eF1iio?=
 =?us-ascii?Q?i5BRK40Wm0MvCUWtU9E2B5Dlddh3Q8bId4NxiIWpUWGNZMiAGwJTSLn0P/lA?=
 =?us-ascii?Q?iA61EagsfLnqFtqgtM0PpMr6E8Zoq4fPNgWwG2SLxYFVmEbT1t7FmPM5LcR0?=
 =?us-ascii?Q?D3rPSxLoMyZSuRNZbHkgUiWMNISpnEdYesYQq8etg+D0Pkjtu59ZYPrKQLeD?=
 =?us-ascii?Q?L6+b1JGmsvfnccouPaWLSWzh4O/A2TW5ubxKhOg/lrK15D9NGHfgy1YR3sF7?=
 =?us-ascii?Q?dsuWrvwyefe/CuJYnb18djbQjGAb/VJ1eFW170ZbpD1V45ozgdPeK2yt44GY?=
 =?us-ascii?Q?egrcbKB3diUpgLnEz9qR+/wgEcxXDohZujRYXI3w2O99wjFBcfq37HyUn6zy?=
 =?us-ascii?Q?AJLM10TTcbYKt7EB0OTmZ5eYPKV59LoEMkUgmh2S+CwVfP5U4YMBQ8Axpjft?=
 =?us-ascii?Q?aEbExhU3Tv7vSyvMmpmq7/wGDNrrl3djiwAwe2l6oponAUJpFqjSpyx3BLoi?=
 =?us-ascii?Q?4FYsRdfJBpOxiSM5Ar4oBDYNfbSIhJkKok2pieGvW5D/ZrMNIhg2yCgwhTta?=
 =?us-ascii?Q?7BQCh2jxOUgy6AnBKsj3/SYXgDnfakxLTv60yBSqWq7BvNfjgiG8mbwKDqYz?=
 =?us-ascii?Q?ZAaXVqVReW76qkc10EHtn4jkWPez2vH5gRDRCARuzIvfvcT0UV1x5e8LVJrt?=
 =?us-ascii?Q?DVP0bGz4PdtkgUgnA2fglZJUhaPqpvhPR7uWS7KbXA0jpnznfUY1TzaCyNZs?=
 =?us-ascii?Q?YlusIaiIuVOYgRq/87/UEnBSm9FAYgtVRbEuXg4zsin0i6gdHWxqD/EnEyBn?=
 =?us-ascii?Q?Ebaj3D0T+tyT3kJp4YxRSxoYKmz3uHlUYamSE34b4bYhSU1S2CfsYGQ4LdAO?=
 =?us-ascii?Q?r4crKLDC3WS7Yko8x15jO4oYxUG3B7X/pSNBrtFEp+O/jnWE4dYEOwKKxLVg?=
 =?us-ascii?Q?Gax2/n4u+Ysqhrxv7iraahTdB0XN1Rt/3joAwH6PD860H+KWl3BoYAYT/lqd?=
 =?us-ascii?Q?NW07icdqbT5WhqqIMmLrxj1Czi4F6NLSBrNsnnNkMc2CG8qQVAvn+PTY2jPX?=
 =?us-ascii?Q?bKUNvxGK8Sn+hY2aYEs6xGzQ+K45I3UqLgWxl0HeHX5vGhTMsagStgu9qHg8?=
 =?us-ascii?Q?/uHfeiBE5sYqPC5Otd17bbFmXk2gHMA8RXzOWlZvBSeZqg6VpidcoqHWyFex?=
 =?us-ascii?Q?zgw85pQn5X+sh49n7LFh2P8TxsmokGDdFYGpeMCSC0K1tUjAns5QqRXFwMPL?=
 =?us-ascii?Q?Ig6C6ghWPAjIfQKO5o1JJTJNcN2Q4i0OkiXRPugcUWk0XI4+4vATwZqQPNiZ?=
 =?us-ascii?Q?8fWptBSlp73shVBJ+BpR738hmaRPfb8I1nqCbDuBzP5Da7V3ONRMyQIBUlpU?=
 =?us-ascii?Q?XwRdDEY8ujIoekwqka66EoDr5AbMjyO7trg15uRPlax9/Baaqu54BEuD2hBx?=
 =?us-ascii?Q?xyEWMKKptzWDdPEEmMxIlXvrLtbRnCjb9J9CvxJhDcxTHcMEEyTBh7wmjPW1?=
X-MS-Exchange-AntiSpam-MessageData-1: AUkf8O7iNz2LnjC6NeiZa5VFOhfSZVUNKks=
X-Exchange-RoutingPolicyChecked:
	0+oLR4bagp7shcrPZGMsnHlRtyRKztRzHwbqad0YT8Si2Yp+xis/2u5O6dkMkV5rjhLNHqSrnULp5ci/aKsmdN+64moqRyv4iGie/kPsE+qtDPp7QuxDsvJ32JjsAtbTQVjnovm/97ZuvoNFoNxrs+BRmP3RYbOSHN8fqVrqUFOvp/LyF9zIXO/r+2YJsgVd2FzEzAWvfnWNMpc8b8hmHQiKQp3m6+hXaqx3bxWdqDawUi1zCs1iAZ8h/YVpecQ2rtomBOhUSuKpXSLoVpDPkDQbY46rX1AUYpBmpGDca/fyWPoUvwoddMkrVLVOLcujGp3iLM4p9i7syfMK3RIKWw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lS+LoOLDmaB5ZoScEY180KHffy8rEu99Od14cwkm0k8qBEE+E4uPGN1q6ipiJlFfbw9ZYKMQ7AV/N+637aZZc33MFczb/C0jnXJLg5e88Dyc2/pU5tWkWVvuHLysbZQ9L02dnfb8z6+PQHxDDd3jwtBphavW+OiRJIthKRpSy+mom+o7f2Y4oJwvnOmcQzCUN6P7WlDgPJRahbetlofS53fiU8WSFhtLmph066IxnHOzvCAEx8+AZPlzFDGK8ynPNscTxFZGsHWSnbQaLlQxvT+2grdLOEfApQTC67OoATGowGq04X0bFszqujEZ1bNCWHFfD7dW0HLcgI1wDfdCbOKZxF+X3NrnXLae11NsDQV15h+BSfkBYC4RFoOlPwS9U/KSM3Zs0MEtBkjSLFTWoGC9vNM5FC2IHbi9t8yQ9BXXsAvA3OYcj+h7fS66HO/AzBZxc5GZVx6sTz4+sKeFPGCUrO83DGHntpYXQZ7gZQzzZPVYv1PTN4ir0Id0H9FzxOl/0EC8zconLyC+IFy+f2wc438W/auNAn4uQ/R2x+q0lkBiGGabWmCzT6DI3EB8XK1RVemzxi5SeeNG9nCDNN/LiunLCXBncg749MSZfzQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0db617cd-26d0-4562-0d76-08df29022944
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:15:37.0685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l+ea0Xq19bQocA2Hvr1oKWhdwxwtfyMvCcp0i/BTsGiezYQZiKsbRW3eS3pH7qSN1Jp3Bw8wBZsVcdpcCsJ8G333PJo2rWpmOFDeo5JEVUg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7992
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=O9SsLx9W c=1 sm=1 tr=0 ts=6acde8ae b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
 a=voHxInD6YWdgVH9rCXkA:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12107
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfXzZVN08FHD5RA
 BUDAY90CRsPC6MGsAeIHvRW6ynL9Fzjud5M2oWVBBP5uUYoOn8uo7oNlIPnoXAJ/Z8VJuOxf1Ax
 fl68WDKmLuXMaRO1eEuS4QAGTqsaAu5VMe1a4ExZMjECQS0vMtdo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfXxIQ/bqdVtly4
 ExBBEKeM6fLv36cRW71U5L5g+DbxWP44F5K9QWkI14ee2oRw0XiZUGZ6dT2qG7vST33eOs6Hzom
 gtPL6rUZenuSjDz6uBtNIrc4gp0soXAwMLrvviu/Gj1wLU5sg5Yq0RwMdOwTIiHPT6cMTa8zKrK
 VScsnBG2ZeGnSiMuwFNnuIXaJcDP8VynuDne05BzwIQIryqXP6h8iiKl9m50ZO3yBv4Be5APhuH
 DSiBoep4pFf9Wqz9epkDIFWhnk6ksoD6hLQ8Qhx6BQisaeqqg4/E/LYFDFY3oljVG3zi9q6l4ck
 ezhTdtTYomL865evzo6AEKs6eJkJi8uCk7BEh116cVtParRTDU/GxCu0anhxHRTfgcfmNgKOJb9
 biw6zoFtEYxBU3o1coKMA+0b7d/bbS12MHx3AaZgmm0vN+91nOgZGyLWaKCkVyPvYrC1O9Ex96G
 LaV6qQa9uMs65a2xZ1chjXNVXPWMqlyuOLcvK3Ys=
X-Proofpoint-GUID: phVBxhwJ8J4Vi3ksl4K-yhhY3UKF54zc
X-Proofpoint-ORIG-GUID: phVBxhwJ8J4Vi3ksl4K-yhhY3UKF54zc

From: "Darrick J. Wong" <darrick.wong@oracle.com>

The code that validates recovered refcount intent items is kind of a
mess -- it doesn't use the standard xfs type validators, and it doesn't
check for things that it should.  Fix the validator function to use the
standard validation helpers and look for more types of obvious errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
(cherry picked from commit 0d79781a1aa6a6a567e63294012eee2384f406f2)
Stable-dep-of: 7b5f775be14a ("xfs: fix unmount hang with unflushable inodes stuck in the AIL")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_refcount_item.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 83dddec08f3c..2532a2a1cd59 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -423,27 +423,26 @@ xfs_cui_validate_phys(
 	struct xfs_mount		*mp,
 	struct xfs_phys_extent		*refc)
 {
-	xfs_fsblock_t			startblock_fsb;
-	bool				op_ok;
+	if (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS)
+		return false;
 
-	startblock_fsb = XFS_BB_TO_FSB(mp,
-			   XFS_FSB_TO_DADDR(mp, refc->pe_startblock));
 	switch (refc->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK) {
 	case XFS_REFCOUNT_INCREASE:
 	case XFS_REFCOUNT_DECREASE:
 	case XFS_REFCOUNT_ALLOC_COW:
 	case XFS_REFCOUNT_FREE_COW:
-		op_ok = true;
 		break;
 	default:
-		op_ok = false;
-		break;
+		return false;
 	}
-	if (!op_ok || startblock_fsb == 0 ||
-	    refc->pe_len == 0 ||
-	    startblock_fsb >= mp->m_sb.sb_dblocks ||
-	    refc->pe_len >= mp->m_sb.sb_agblocks ||
-	    (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS))
+
+	if (refc->pe_startblock + refc->pe_len <= refc->pe_startblock)
+		return false;
+
+	if (!xfs_verify_fsbno(mp, refc->pe_startblock))
+		return false;
+
+	if (!xfs_verify_fsbno(mp, refc->pe_startblock + refc->pe_len - 1))
 		return false;
 
 	return true;
-- 
2.53.0

