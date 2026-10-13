Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E793B0AC6;
	Tue, 13 Oct 2026 08:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879299; cv=fail; b=FUoIjFd6Jq8BSKLxGW7jNvC8QyVnhqph6T3WD3NpaG0dFqyKr9iHA+4E5DQjC/1k8bZgwylL36n77pvRctsKvdAskpjPJgPaR6E8qtHNnGcn/IgDVUt4dgY2XMEVWkjqf+EYsCnur+h0FVeMoSw2pobMVMTwsRcM5oLxo2sP4Z8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879299; c=relaxed/simple;
	bh=bXS4Nlm9NjAOfYO7EPPOme6CYeLp5GKbnPrIiobDUEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OLjvse/bZUYa+YyQ8+8PUpgBNo423iGIMHw6It9nfssxiqdCS1J6JtT0sEJlXf1b28b2fZo2XdV3KaGnR8eeB9XkOS1BRfp9goCuwUshThoKnsJ/X2unzYKY9InbLg09Nt1i9gvi6VGufa0QWBIg8musILZH6CEnW1rsrN4hZI0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MqrPxGPB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DCfFY69v; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MqrPxGPB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DCfFY69v"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2C50M3201017;
	Tue, 13 Oct 2026 08:14:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Sip0nQy0U3JnT5OTbSTSKF7mc/9kh6CySPYgRcfpTwc=; b=
	MqrPxGPBt8C4bgsR6KH41P0/eCsseFTNuU4E9yrGG8OyrhBEzIoS/9JVUtX+wDMh
	ZmYmAizb1DosFfu7yKFkae7eNx9bbhjgTTIE4zRM9uzdB1Dj97/SsrBoi2zZCenm
	HmjqAzBHaDuS6fP4IuepoP/6J+jGibMvoNct9OKZuhwREqlhHcHjZJANVzBWUl1o
	2rTfWYdvc1vs0eu+rljV+DNw3FNyyXZQaw7xVqIsjMfxwFs8CBVjs9wt2rDCcu6W
	c2n8lArwfe9u4jO8IJSNgBWL8zCCEn9KyiZkqq78P+8kLWFskxl3igKXqPS64Of0
	gIhiuMMVDtpUvAI5j7DOSw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7demkkcs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:14:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86ODG024857;
	Tue, 13 Oct 2026 08:14:52 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011036.outbound.protection.outlook.com [40.93.194.36])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9ar9v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:14:52 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cSSBkWqaX1lk/PfKKnhcIrNic937eCLw2QvCVVzhRWWHJq+2k2QEFic7nqjUhdX9SkvaceJGhSkeWTzndGJ3pgksQqzfi22eQLBK1IFV1JvzQb5d8pbmglmR9/TCwZUPenrF/MLySadUSvkIEAyqx1oz0sm0GqMUrYeS5pdauiFEgHmYCGwhMCry0OlxlRcMxh4nyfQ6MIxGKMp+BLmJBpfEovunnVsz1mD37fzXOmpnbQ5hhb4UcykuJ7EiSz3who1UJ7iiyBijucruFDUT9kHVmv2k0vmWkG1MWjW7P02A8TUTk529UD+d/a7qKOmmFDxBNjDgvEFAM0ikbDEwKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sip0nQy0U3JnT5OTbSTSKF7mc/9kh6CySPYgRcfpTwc=;
 b=xgrK2mM3Oc+edV9PlTtLp5mandxW3GqBB9DPUcN7shDetaFpREffC0GxA03vgYHeVznTEuyQ8/bMVseCXDhUPdS0yNxxLlpKSBzM4wOPZx9dErN2Ku1APptdQ0kQno1k0YgXaumQjQDjwZVrkGepfQTmuxwq7bj/In/1TufEglwRVPpMWvL3AKhB+4vNRL8LOjlqzQd2CeHxe+QKGMVHw2yPU+DWgTawTRoQLxE7F9pr+vcg0fIeo6eAbyCvXBqr8hKzm9f0lrsop/ixI9NTWWF3/qqP41suTwzO8M87x3dkDb6nh7JIFUsl7nB7nBJf4e4mjPIHfIL1ynh3UpocbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sip0nQy0U3JnT5OTbSTSKF7mc/9kh6CySPYgRcfpTwc=;
 b=DCfFY69vlztoIawxnzFGYNhNhqjqlSTxa7N3zemTtQw4N07J3Dd65D1KeuWmyozhkONLoa3EDK9ApRdZb7QyNnCTvoFL2cQDeo743/cUfup5hIc3fbNW/IUuA083TR6oqXFdKaV1Qp+q+fICII1cH/BYfuDmGPbGDHXQu3zz2vc=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 PH7PR10MB6507.namprd10.prod.outlook.com (2603:10b6:510:202::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.10; Tue, 13 Oct
 2026 08:14:49 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:14:49 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 v2 6/9] xfs: catch stale AGF/AGF metadata
Date: Tue, 13 Oct 2026 13:44:14 +0530
Message-ID: <5901a67481d94cb21874d9bedefe9df881ceb61a.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0009.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::18) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|PH7PR10MB6507:EE_
X-MS-Office365-Filtering-Correlation-Id: 02019712-ba8e-4e5f-7a85-08df29020ce6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|10070799003|1800799024|23010399003|366016|6133799003|18002099003|22082099003|10067099003|4143699003|261009223027099003|5023799004|56012099006;
X-Microsoft-Antispam-Message-Info:
	gJrOnDpoA+ROC7tGDXVz0cGfgfU0mNMxRxmWyd3mAT9gWx9JAUp+B6FG7/HQKtouMdOQx9e9GbvkLUby0oBDEKcAN3mfcE/JNqoLVX3DSrf6ib1GDtoKD5nFy8Zlymef4WCJzTfsiChzRpOrYAOs8gKRHlQVzE2rl26RoVBV4wHvB1vQnmGXyf1Rqw4wXWoiwKladlQVeYXhKg+om1NMeWNgT5vwVvy7S6SCgKgtD5l33aKUCWfg8A7i8aWhEF2c0FiEDJTAQngTfr200W+7a7AIdOQRXv33WtkGBqJqiNCDtVsoxi5CKh97FNifmhAzTnObKpqgMto/gtDaZ/5nvt1sxIHWyXyJl6vTGO8thLgvqDhSya/7/Vs7Qn3rFYoiQWCSKFTX8u0K+SmoWy1X77dCyfKf4JzDPZgaNvFTkRYQftkZfCcrVTOkiiRKm4zuMHrXlAzcLEXeBVduVKVwWlgAYDhPRUMTHmkFsoOpVNep6+SEB5l/Eh+ZlTDi9N3nRNsdDoIGFeS8yzbchCaduGkAK5QhKXJghxLFx+rvvw8ewFjBpNKwxNcepFmhAj1YITl+yQp75IcDFOIbjlEE7DXeb3IQqZDcHx3VN+pf+8LEnNcDl74mZ7F6vJxkjv9Ip0NcBXQmdQ8nBBv39RUhdt3kvhILKSA5myq9mozGTLk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(23010399003)(366016)(6133799003)(18002099003)(22082099003)(10067099003)(4143699003)(261009223027099003)(5023799004)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IPII7DFz0Fb61l/6TPnjXO/geP2aZLdnl+rq8L6W7ycWMGBY2NwiaJRDd89c?=
 =?us-ascii?Q?naZXcvx3W0+9TlXLczJvDFFc+M7XMs3s6tTGhSeijcS+OjO40HnJI+a+iVJN?=
 =?us-ascii?Q?1LalinsfSuMdGx9yr3VrhzFgdHzCyKDvE5bgMFdm8gIJtQKfTiIfTsyCYX2x?=
 =?us-ascii?Q?BhcZFcGu0QMWESN61bM+K7tssuJ/mokABnAti/DokqBSGWJl66wpiJBI4MmO?=
 =?us-ascii?Q?w2q/yXk81hZDDpGa3ua6QCe5A8L7k9Bikt39FnwZNAwEXu9RaxjIkg0mhfHo?=
 =?us-ascii?Q?gqp/MovtyA9WnSPL3c7s8FtRNllhxyRdre60DIgnwE9XwvM+JW6dSpWLfUlh?=
 =?us-ascii?Q?j484aHxjpZFgGn/QL8EuCIVC2xQOBe5OWo+vpEu2sQRkKWF8cLpk5hciXfZ3?=
 =?us-ascii?Q?Qc00lFSWxG9sealL4Qvtd+VGD13KBeMt2eAWnh9sMg6rCZXhMK5M0X2wIQC1?=
 =?us-ascii?Q?SbWU18SdRX1iVYtpG1kwd0F3SRjinrVPXTZH1GD5umsXHc1Yxdz8jTXZLDge?=
 =?us-ascii?Q?vrUB+wu0Bjwmz3scC+j0fveLO3zJD298ZB7kpe+/7EU/nVgRk2M9FiXbDBT+?=
 =?us-ascii?Q?UXdCUGkgs2jlOpThs42N0Esmjy2m2NhVAuILrwXGrne6X/29HW4OIDMMF/wj?=
 =?us-ascii?Q?7F5cmIRENa7orJU2LRtAGvHCjxAo6ASRFMd4mGaru1Jc+Viar4MU6BzJ0Lhb?=
 =?us-ascii?Q?oIjoMDJak91EyLNEEMqIXY0hNLIArUIBIcnh6YY5PxOW7EEdu4ecvh48CTMG?=
 =?us-ascii?Q?DazjTE2XV0oVrDISxRWDE3cNZIIabjaEoNL5N8DgoJ15oys9ZT+3eDfWCnoo?=
 =?us-ascii?Q?TJ/Pexiy+MsDeikxTQu5iXx6EFpjy0Xf+cmEB9xGqtBHMwcMYkuQwxwWBTUV?=
 =?us-ascii?Q?9ul3+go+vjgxjlkYtMXkZhe/X+g4ueMzKbJvrk/D0eji0xXwudKE1BF95tjl?=
 =?us-ascii?Q?m/FixUqP9JVf98B8S6NbOH4tkEQd4M31EgwNVNh2NlHLVxo+LMOvyLKdrRWM?=
 =?us-ascii?Q?cwsJ2Q39TbUXAy5wNVJVe6XXytA2wqU06QihmZVowS4y0IsCGTfUVTITJbNf?=
 =?us-ascii?Q?uTD+OV9HWD8KqHCMLtz2kv7rHBIgm6kps5f8TKMOhUhtRHBVS/sG1Hl1uCeE?=
 =?us-ascii?Q?TBtuDrHNJLJfk6oxkfm6t/PeSMDU5L77icfERiNEgbxM47W+UCHduoFKSVcj?=
 =?us-ascii?Q?Laicni28kATLGRUSFsu/RKoJbqz+uOSjW2qho+QQoRg1SvBrkp0fnAcZhTHm?=
 =?us-ascii?Q?FAJ13e5aZD21XK/x+wFy/bfb6Nq5jpjHA/w2GVO2CkNnxufOSjxAhJdmFysY?=
 =?us-ascii?Q?a/cDAmmrHVSUE3HgDtGOFIWS+OgqKcQfjsmxw4TflEWfdA6NjwRlTHYl0qgB?=
 =?us-ascii?Q?44kF+NMGiHQHCFUTm4ZIiak8/tlZuWLvTbRmcTIqf3wOf91sImgM1xKF5Xe+?=
 =?us-ascii?Q?ziT2UCCA9PZrs7HJ19ZOMl3XNaInZVBSC8faXfTAR4FL9qBCMuM+q0tEW4Er?=
 =?us-ascii?Q?GZoBjhpzDwOHcSDS+pkf8uI7hnx9sNstXbk9t04iO5ZAvD78sw+B6MpEmrAr?=
 =?us-ascii?Q?eBIG3OH18dnAm8aI6sCLeIEUB4znAbRrBkIbq0l5G0i0qImlg7zaOjxIJpY8?=
 =?us-ascii?Q?4Ti7tbiOVNfYsnZM/mITzwSyhHGP9f6/lsE4r6NxT4iCp6pSNGmAxViUBxHm?=
 =?us-ascii?Q?Be8NhpG0jWAj0p7r77Rp8toTQUdIH62llICkRmRH6dv6GcxNhldUmOZrzifM?=
 =?us-ascii?Q?iWSZKJLNO3jU8pArmlpG4nm1uIVKoFqTjmLnZK2umWUw1jBtIGHykw4/DRiy?=
X-MS-Exchange-AntiSpam-MessageData-1: 1DRGFGrhx4CRSHTuqLWy8gznGHJWs5nb8X0=
X-Exchange-RoutingPolicyChecked:
	bTQGn9iLVrw1aRr9grCRxZjXJlCZPDW/oT2lEZ3HS9Cgyo3V9OnsJMglucFyWoHBrROyvzZUmX9ll+cC+A4EjqRVnIKutOjrEDzkTQ0jSSEqJ3IMY+QdLyYx2WXRxssargf2sCh/zpM+yHqEjOG2DudgMzJyXlj0elu0PAI4f1VW0Z7LGDseSpNtpFrXqSxzzsyL6I4bYVDauF3Iehj2cXJjTh11XYuOLNzAbNbNkpRUE7CikeqSVH0V5ZLbu2fcaMOmQ13w9fmC8AnxwmhZwsekE7sGBkmGGB339NWdcOFNCjz8KR6tCyTwnpkIAPAWnQSQdaPoBbgoUCAJBiEQ/w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gUTR2KKB80jHYC7SHC9kNAChvIldbr/iSDfjfkC8B3dsRgTjFLsiLh/L4Hn0SNDyAyKA2NfNMfUbto2niQR8TtMiS6SnZpfPoA0T8dvA7L17w4vLk0TrxpfgDG1aUb3ks6IiRp6bIMlnbk8s6j32/j3/Se4bCN4UgAKSbbuo06D12m7m6olEeNdusorCoFqzsQJX3xtaM+M57P/IhJgDiAVmoYgzZxHepahX7B/P7mAufOjg+NVXo8ZVQnE4wMjgY9LtWhmBcOFJ/qi2IQ2QpMyYxrcOOadJqCkjG5CRdmIMTR2Un3QOXTfDEnm2o/T3p1a7ze1qmSK4+RFbXuvfSUVBz5c+Z3geEt3nOjOwNODLpYkaT9VkQoGBrjYL5Q4eMHqPSaRvvTLeaeTxli2cIQHSA5Fh3ShJP7l6pVQ7oFWYS23xK+zHpnQD+JhB9e8rsRu1f5BMSjKBNutiRCj+y6BFi8fZ2EQLVPVtJ4Ar4DmkXI7Aaw0A3IzQT6OCTcrSFOEZ8Mmgwh8T9ZmRGge6tCDqXxSeF8EdyDpqwNpKCKmj5LcbMWuSvvZixN8sf8H6pmGvNTtbX3qe1vTND7BoWEj0DqfKwAQ1+NGtD43P8r8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02019712-ba8e-4e5f-7a85-08df29020ce6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:14:49.4837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4expJwugDp8MSIPZrONl09XLpmLZ9KSr/ddyNa9fz/FVJW8ucyHpuYUQICWyvhd6k6p9JbaPqMzW3E17K+0aFZrW15ZGOFE5QFMvYrGcWTY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6507
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=CoEq4X4D c=1 sm=1 tr=0 ts=6acde87d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=pCazNFhamJdtUKLgDfYA:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-GUID: 3WV6pfKc0wLkPylUMLKZA2rXWN-iiFbg
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfXzSfDGoFIq4+i
 bD3LP7eIvfw4W0kSKt/SU3F2f1mLuMUbGCF9RoiN7YzKZsRnk44HPlsr8YwPVlacoG8BjZgLzZ1
 WQAm7dX/vHRepUcUS/uFuTYxHAe+WOVsH/b71+E4IXL5Kqvw5GBl
X-Proofpoint-ORIG-GUID: 3WV6pfKc0wLkPylUMLKZA2rXWN-iiFbg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX11Ead4JFLqbP
 CfF9fWRESmspoEGXRafkgjvKoVpE+x9aghbz3t+YFiTEbUnydA4ut0KafF/kVZ7zFxILPEDdzE8
 QMDa9h+9G7VWkXxOwbbL0gHKwlwexrrqT79AiNZpXvEHv8D7alXx3ax4naHku7UcClaT3632sUx
 5mWn8h1loYwyO4X5YD8zk2b7yDM28T+tBkwz37CLpJDimFg/bYXEpe6zslz4UftgUUoyQZihbsC
 ARetw1TOzkHdT0ZCbiC+n+RCXcvBgK3EjaISCGLOu/awzxVpbEVO8pCN17V7PjtaNwY/Z/Jfn54
 kpn4LAW80g4uj7Lb3IZnom8jWGuXNdlfMCuQt5GGGi4Blrbm1sqJ3nq46p9axGkgLRZqIqgjxxy
 Xb3r/vp0dTGmvFYb3Bul6CsfhVXSsUPF5jI13KI+hyy28Ty4Gpd+QZfmnclpvhc5TpIMMfhAJNv
 Yz0IFHuUTQrDFKLP2TQ==

From: Dave Chinner <dchinner@redhat.com>

There is a race condition that can trigger in dmflakey fstests that
can result in asserts in xfs_ialloc_read_agi() and
xfs_alloc_read_agf() firing. The asserts look like this:

 XFS: Assertion failed: pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks), file: fs/xfs/libxfs/xfs_alloc.c, line: 3440
.....
 Call Trace:
  <TASK>
  xfs_alloc_read_agf+0x2ad/0x3a0
  xfs_alloc_fix_freelist+0x280/0x720
  xfs_alloc_vextent_prepare_ag+0x42/0x120
  xfs_alloc_vextent_iterate_ags+0x67/0x260
  xfs_alloc_vextent_start_ag+0xe4/0x1c0
  xfs_bmapi_allocate+0x6fe/0xc90
  xfs_bmapi_convert_delalloc+0x338/0x560
  xfs_map_blocks+0x354/0x580
  iomap_writepages+0x52b/0xa70
  xfs_vm_writepages+0xd7/0x100
  do_writepages+0xe1/0x2c0
  __writeback_single_inode+0x44/0x340
  writeback_sb_inodes+0x2d0/0x570
  __writeback_inodes_wb+0x9c/0xf0
  wb_writeback+0x139/0x2d0
  wb_workfn+0x23e/0x4c0
  process_scheduled_works+0x1d4/0x400
  worker_thread+0x234/0x2e0
  kthread+0x147/0x170
  ret_from_fork+0x3e/0x50
  ret_from_fork_asm+0x1a/0x30

I've seen the AGI variant from scrub running on the filesysetm
after unmount failed due to systemd interference:

 XFS: Assertion failed: pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) || xfs_is_shutdown(pag->pag_mount), file: fs/xfs/libxfs/xfs_ialloc.c, line: 2804
.....
 Call Trace:
  <TASK>
  xfs_ialloc_read_agi+0xee/0x150
  xchk_perag_drain_and_lock+0x7d/0x240
  xchk_ag_init+0x34/0x90
  xchk_inode_xref+0x7b/0x220
  xchk_inode+0x14d/0x180
  xfs_scrub_metadata+0x2e2/0x510
  xfs_ioc_scrub_metadata+0x62/0xb0
  xfs_file_ioctl+0x446/0xbf0
  __se_sys_ioctl+0x6f/0xc0
  __x64_sys_ioctl+0x1d/0x30
  x64_sys_call+0x1879/0x2ee0
  do_syscall_64+0x68/0x130
  ? exc_page_fault+0x62/0xc0
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Essentially, it is the same problem. When _flakey_drop_and_remount()
loads the drop-writes table, it makes all writes silently fail. Writes
are reported to the fs as completed successfully, but they are not
issued to the backing store. The filesystem sees the successful
write completion and marks the metadata buffer clean and removes it
from the AIL.

If this happens at the same time as memory pressure is occuring,
the now-clean AGF and/or AGI buffers can be reclaimed from memory.

Shortly afterwards, but before _flakey_drop_and_remount() runs
unmount, background writeback is kicked and it tries to allocate
blocks for the dirty pages in memory. This then tries to access the
AGF buffer we just turfed out of memory. It's not found, so it gets
read in from disk.

This is all fine, except for the fact that the last writeback of the
AGF did not actually reach disk. The AGF on disk is stale compared
to the in-memory state held by the perag, and so they don't match
and the assert fires.

Then other operations on that inode hang because the task was killed
whilst holding inode locks. e.g:

 Workqueue: xfs-conv/dm-12 xfs_end_io
 Call Trace:
  <TASK>
  __schedule+0x650/0xb10
  schedule+0x6d/0xf0
  schedule_preempt_disabled+0x15/0x30
  rwsem_down_write_slowpath+0x31a/0x5f0
  down_write+0x43/0x60
  xfs_ilock+0x1a8/0x210
  xfs_trans_alloc_inode+0x9c/0x240
  xfs_iomap_write_unwritten+0xe3/0x300
  xfs_end_ioend+0x90/0x130
  xfs_end_io+0xce/0x100
  process_scheduled_works+0x1d4/0x400
  worker_thread+0x234/0x2e0
  kthread+0x147/0x170
  ret_from_fork+0x3e/0x50
  ret_from_fork_asm+0x1a/0x30
  </TASK>

and it's all down hill from there.

Memory pressure is one way to trigger this, another is to run "echo
3 > /proc/sys/vm/drop_caches" randomly while tests are running.

Regardless of how it is triggered, this effectively takes down the
system once umount hangs because it's holding a sb->s_umount lock
exclusive and now every sync(1) call gets stuck on it.

Fix this by replacing the asserts with a corruption detection check
and a shutdown.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit db6a2274162de615ff74b927d38942fe3134d298)

6.12:

Fixed conflict due to the following missing commit:
	e9c4d8bfb26c ("xfs: factor out a generic xfs_group structure")

6.6:

Fixed conflict due to the following missing commit:
	e45ea3645178 ("xfs: split the agf_roots and agf_levels arrays")

5.15:

Fixed conflict due to the following missing commits:
	6f643c57d57c ("xfs: implement ->notify_failure() for XFS")
	[Continuous range: a95fee40e3d4^..08d3e84feeb8]
	08d3e84feeb8 ("xfs: pass perag to xfs_alloc_read_agf()")
	76b47e528e3a ("xfs: kill xfs_alloc_pagf_init()")
	99b13c7f0bd3 ("xfs: pass perag to xfs_ialloc_read_agi()")
	a95fee40e3d4 ("xfs: kill xfs_ialloc_pagi_init()")

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c  | 45 +++++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_ialloc.c | 32 +++++++++++++++++++++++----
 2 files changed, 63 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 95157f5a5a6c..c4d1c7d436ef 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -26,6 +26,7 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
+#include "xfs_health.h"
 
 extern kmem_zone_t	*xfs_bmap_free_item_zone;
 
@@ -3078,18 +3079,42 @@ xfs_alloc_read_agf(
 		if (allocbt_blks > 0)
 			atomic64_add(allocbt_blks, &mp->m_allocbt_blks);
 	}
+
 #ifdef DEBUG
-	else if (!xfs_is_shutdown(mp)) {
-		ASSERT(pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks));
-		ASSERT(pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks));
-		ASSERT(pag->pagf_flcount == be32_to_cpu(agf->agf_flcount));
-		ASSERT(pag->pagf_longest == be32_to_cpu(agf->agf_longest));
-		ASSERT(pag->pagf_levels[XFS_BTNUM_BNOi] ==
-		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]));
-		ASSERT(pag->pagf_levels[XFS_BTNUM_CNTi] ==
-		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]));
+	/*
+	 * It's possible for the AGF to be out of sync if the block device is
+	 * silently dropping writes. This can happen in fstests with dmflakey
+	 * enabled, which allows the buffer to be cleaned and reclaimed by
+	 * memory pressure and then re-read from disk here. We will get a
+	 * stale version of the AGF from disk, and nothing good can happen from
+	 * here. Hence if we detect this situation, immediately shut down the
+	 * filesystem.
+	 *
+	 * This can also happen if we are already in the middle of a forced
+	 * shutdown, so don't bother checking if we are already shut down.
+	 */
+	if (!xfs_is_shutdown(mp)) {
+		bool	ok = true;
+
+		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
+		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
+		ok &= pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks);
+		ok &= pag->pagf_flcount == be32_to_cpu(agf->agf_flcount);
+		ok &= pag->pagf_longest == be32_to_cpu(agf->agf_longest);
+		ok &= pag->pagf_levels[XFS_BTNUM_BNOi] ==
+		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]);
+		ok &= pag->pagf_levels[XFS_BTNUM_CNTi] ==
+		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
+
+		if (XFS_IS_CORRUPT(mp, !ok)) {
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGF);
+			xfs_trans_brelse(tp, *bpp);
+			*bpp = NULL;
+			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+			return -EFSCORRUPTED;
+		}
 	}
-#endif
+#endif /* DEBUG */
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 31dc8e5d8725..9b14a6e4e48c 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -27,6 +27,7 @@
 #include "xfs_log.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
+#include "xfs_health.h"
 
 /*
  * Lookup a record by ino in the btree given by cur.
@@ -2619,12 +2620,35 @@ xfs_ialloc_read_agi(
 		pag->pagi_init = 1;
 	}
 
+#ifdef DEBUG
 	/*
-	 * It's possible for these to be out of sync if
-	 * we are in the middle of a forced shutdown.
+	 * It's possible for the AGF to be out of sync if the block device is
+	 * silently dropping writes. This can happen in fstests with dmflakey
+	 * enabled, which allows the buffer to be cleaned and reclaimed by
+	 * memory pressure and then re-read from disk here. We will get a
+	 * stale version of the AGF from disk, and nothing good can happen from
+	 * here. Hence if we detect this situation, immediately shut down the
+	 * filesystem.
+	 *
+	 * This can also happen if we are already in the middle of a forced
+	 * shutdown, so don't bother checking if we are already shut down.
 	 */
-	ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
-		xfs_is_shutdown(mp));
+	if (!xfs_is_shutdown(mp)) {
+		bool	ok = true;
+
+		ok &= pag->pagi_freecount == be32_to_cpu(agi->agi_freecount);
+		ok &= pag->pagi_count == be32_to_cpu(agi->agi_count);
+
+		if (XFS_IS_CORRUPT(mp, !ok)) {
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
+			xfs_trans_brelse(tp, *bpp);
+			*bpp = NULL;
+			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+			return -EFSCORRUPTED;
+		}
+	}
+#endif /* DEBUG */
+
 	return 0;
 }
 
-- 
2.53.0

