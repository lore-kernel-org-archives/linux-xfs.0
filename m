Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7AB3B892D;
	Tue, 13 Oct 2026 08:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879336; cv=fail; b=ILDqYAhaBuWmoqFZ8e8oGSdyeOk85YksPyLN2VL5YBiAyAYmmJ+QvmyBLHqpuJnhWEAg/r+wrATtu/wROPmk7Sgy839rmHN8wyj6W3x+FXO83EhkzWtGH9C9yEPlBkdpQdB05h4luKNzXnF3n7V8G9x7VqWG2KOjhZsSYT52hyw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879336; c=relaxed/simple;
	bh=GfkLJvfi+TKr/BxVPd0m413Btu4HSQO1BLpkeuBr2kU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Mfp+x38gYVzDjqlxOO1trBoKhMazrT4Iyv/7JI7E0EILbHag/DQ1nbsJ+W/yCO8gKxIPe9uUarEOutqhimpiZX04lFnYVFzI5d6EW2RD1yaYUbKVj+C3UbMi2c1HvyCAHb6y/umvRNSBKN+XvUfj8htaSqKioieCfiEd27FLs6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=laes0ViC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XgPxvpBH; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="laes0ViC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XgPxvpBH"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2BsHH3030638;
	Tue, 13 Oct 2026 08:15:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=aF9MFOI+diNExF1Xy4CKPzklCCLFnhJLtJtZ2EXKSOI=; b=
	laes0ViCmcsC2lmQzimTxbohOC//mZ3Jh/cLW83SxSupdH1uq3ANyQIsbsi9lFsp
	9Uno2RAhEZ8KaBferDWY1OO1f/kVLcs9rnZ6N0sK5buAIN/F/FOTDUOr0rEOx2RQ
	SvwddFONhqYN6kYHoLOi8H4ipb1d0NAou4ED769YZrdXnIxsUMvcHn+3iQ8rqjHg
	gDFczfZhsHaVjmXRygOPKq1LE8MkrGtjM3fFD3HXXESUSljKjb7ku1GCN0F36cXF
	zW5q/LKSXAaJhEis0HmhzifHCk/VS00mnAM0FYWvkDC109bMD/MaYA0ULxqrs/hn
	x61LcU0t+9Q2S4ZBgTCHAA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dwtbjxe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:15:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86hld020820;
	Tue, 13 Oct 2026 08:15:30 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012015.outbound.protection.outlook.com [40.93.195.15])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btjsgfb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:15:30 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tKnFWJvnP1UOKAdrq9JDZ6Fg56KeAiGEVpDCwBhJkXunKyb4An+8Iw+3bK0ar16ls/+5FWHGJQMJkKD619pICBFiUlcj0omuMWH3QzBjRH4bUv+gcDK2WJT1911NRkMAebesT4enVk0O9oqFGBk6BVuEyamHBVxcfcUPho3rwaH+ue4Qq04w9hElDH1xD+iQGW7dfgWAm/Xe6PVDfytSXEmTqDl5YkEXIkZaS5D8tuRwf4GSyQXQttTk2qY1iKOxMqL4UmGZDvZ2FpMd5M4x3IEoCeFUELnC58fbcglnEFTj+CjrTzSnLKySc+6Rv8Y0jB8ZV1iEwYzBgvQqWnpRmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aF9MFOI+diNExF1Xy4CKPzklCCLFnhJLtJtZ2EXKSOI=;
 b=KkmCAf3oZqeF0n0WYd78hV8qPQfLsVdgy5PMqM+0x52P5tqfiKEkuah39zD/on/jy6jOKW3L8yxrnoX5EdwZpL/CiDjz9xawO1feRyxcj/PgvfL5TIS9cOmm0GqhzDagGsMEKAF1H70qKofyyCGSMznqQJ+ZoG8NdA1tIZ/6lxOpZitjIwfV9+xgfsFKxsFhAPC3V8N1hJ6sxEK2A8Eu+qL9DrThAMkTXzfr6mgFedqyKFDSMMPZcpeOt/JSFmUvDFOyySVfwzQ7/OBXfixLEZD7cG7O2hhOaKvqYhs3U8V95vrBgDgidKmkakYQpVnFGa+3anf6rM2Qrolj8x9MeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aF9MFOI+diNExF1Xy4CKPzklCCLFnhJLtJtZ2EXKSOI=;
 b=XgPxvpBHiCaXeX+xM3PkvnY/JLEMxTqSenqgyve2A3BoHAFoHaDYcjm4qn7MO+FT1ImbNxCdmzqPA2cCsxINz9lWnk173IisAzkq9V1a9AimbEQmcldACCBoqCDf9cEYxk0s4FSkBF4cgoR573Wj1zSSnocHARkAdiOeB+hztLw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 LV8PR10MB7992.namprd10.prod.outlook.com (2603:10b6:408:1fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.7; Tue, 13 Oct
 2026 08:15:27 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:15:27 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 v2 04/19] xfs: improve the code that checks recovered rmap intent items
Date: Tue, 13 Oct 2026 13:44:48 +0530
Message-ID: <0d89d11eb45b336bdb681994090a27e79a61633e.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0190.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::11) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|LV8PR10MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: 829bea20-b902-4890-88ff-08df290223bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|376014|56012099006|4143699003|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	GfTRTLoNdiPo3cQWCRCgJH0LWnknCX8Ngj6E2JftZoTUn3kzBa11oKtSYzZG+I2qMxHIfHD+msBECj3a53uCjC6qVMILEcV7r/3baq4hB2AQZPcAblc61gNkq9NOk55qnyiVqPWzpHTRzwftGAYCkVtVah9j/tNcY3qRsEyTv+EStGfYSz5fH1SNJ8x8WRg5K62eo0JSDIAXkqartp9yD3t2Jskwza5oNJd4VU35mPkuh7dK53vOAARXsqjVA/UMb6Kf/lKdFEaWTb2Vog1f0RCkgyspGF/UJ3GfC4FEUVKp8r7Z6AV+Vk0I02b1Domo5runMBjs4tn2sUmZ5gnhyzvoFcUPTRe8Qgp4J6XzYyfXTPzq3v44pfB0D+vG8xL8bZHk7ZxSq1m8QCbiPekZ78bUn6ti2xAXxplQCuBwDdYaCpATaITWjWRo4bJKJsNuji3IcpqhVkbqeRcLqFCT7uHkLUQsuduEcx1Aqz7Prxh1anuBCtLXf5DfdB2D8o8c+Q6pSr6osvaI3nHYKPnt5eXvqiNfc+Ph4dPJL1wvmXVXINWCdPis4xZsuY+V8BZVb4O9xhhQH2bfcgPJtcwdWRqeEJ48PGVTPhs4C7UosrlaYjQrEit2VKpeS6zYNkBMzS/AFf9WL+bMNsfxdlmqRxvtQ9EIG2+D/fuZEh6/mOE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(376014)(56012099006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SmiVW3PxJ/M9BERNIRcA3IhaO5A8OiXUjrxhlf5lyBnS2tjXrtbQQA/Zr0su?=
 =?us-ascii?Q?sWJerYM5vFNR2ALvKd6PHYjlthSmm0ZVsXCBg8YoaDFN/bSWDda4AFnGna75?=
 =?us-ascii?Q?i1giloAIEVl1c9ixT2iD+doRO/0eCvqKujND/2hXv/gXhVhBRF8a2iY6kM1i?=
 =?us-ascii?Q?bkqg21xTzc1UOEy8jMkN16z7FBzIqAwXruGPo2QmGhDljUm3DBoURArVgjGW?=
 =?us-ascii?Q?0tCjz14GgDshCElShqb1zQIyR4D/hTwt/nqQcGmvfkMdNcgxSjXfXnTPItDd?=
 =?us-ascii?Q?3M97r+G6p8+FavNJ8w6wA75qp/IMKWO0m+7rtpsWd8C1x58K4V73Oxtoi91S?=
 =?us-ascii?Q?mK74LzaO80dXYdIWf1aSaMK7PpUXSl2Ny9EJU+8moPSq+QNThKSOY6Um2JBI?=
 =?us-ascii?Q?BQS6S3OFyLB57AY+9IFqUVH6LKx3r6rKc8n77fHQwta0EKrBr6JKoqVMdx0e?=
 =?us-ascii?Q?0zQDrHFpAzn2ORvkdMVrJDnp3hk5IBm74n/9gltjIg/p3BgPoLXVuSQfoG8D?=
 =?us-ascii?Q?QnN3a4zhvdvb83uAXL7ex/7+nzY2exZjWGiFsh9uY692+gRGv633dlLOYCzc?=
 =?us-ascii?Q?8z41euzT6rvFDdLKI46+1xxlFQ7ES5XSpzo10pbMkdfHZA9/dzngdHlRvBbO?=
 =?us-ascii?Q?jkpPeH9FIT50SJVnsGg9ty0BUCcSgD3e0rEkgLcxsYNc9hKSpLhc4HuDZqh9?=
 =?us-ascii?Q?XFT2Ea0zj2GmZckRioHjw52ThHNbJODmm8JWuR6KpNsYsU0BtqgIluNoMcBQ?=
 =?us-ascii?Q?gfSk0m5G6c5A5Zh7wfO0cXkALfUi/voBWGmdL2duRxfE4QKDOj/TlPZXozWB?=
 =?us-ascii?Q?33WcrBfu+eeccrYJrXN2rUveuAjpyFvW/M5cu0FhCwHd6GK5IDWvUcR76GDt?=
 =?us-ascii?Q?G24fqShTXAy8JAjxwn+cEwXhLPfgGMwuyttkqHTh7tz7xvRwUQA/XJ17w9gf?=
 =?us-ascii?Q?F8RnmlmvBqwGzjSzu9RCvVfcwzqCDBmDF16+3wtUmWLcBHcAviXaXzD20Ymm?=
 =?us-ascii?Q?VbL4EuaePyChiFFuCwp9STexiyF72UZWd/2BducWGKDJLoYHpnKVdICuQL0u?=
 =?us-ascii?Q?/QLEW3rSdusmFqRNFLWeTEZkmVdx2ZpXlWqA1vHAPp/6uHQvSVhnnUPl2Wer?=
 =?us-ascii?Q?PEQCy4tNwAXhheaj1qo7DAAR7UdYNaTafKB2mbuTwDtZls4YIUJxPumFptDT?=
 =?us-ascii?Q?7MT+xT8G/knAQyLdeMHTIE8T/gFQiKu/xwnLMIc9Zh4ckuk9jckxgK03Zpqc?=
 =?us-ascii?Q?lHm0lCEhQIWORl7xV1UN0mUij0DUliQTG6A9aGPH0bjp2AvOX2v6Gzk64RHI?=
 =?us-ascii?Q?tjlDzraRXG+++SB16krbAnkWgGyWr1ANoUzo6wL+ENJDR6vAGf79kOfrBzx1?=
 =?us-ascii?Q?CP5nNLhAdwOngT8lLnVzbZOodax9khky2YnxGT/ZGuP0eTJEVPlqpUKS/Jb3?=
 =?us-ascii?Q?7kqkHN++psOe4tg//iVtxiPJpP2Tj6W11S889iy4tQUyGGeZRTkxAILkrEgx?=
 =?us-ascii?Q?46Z1DejF772TMYqR/X8jHz9mDkFSQ5Ql0KO8qUbc42eI5dbERBFOfMLtXewX?=
 =?us-ascii?Q?i7iCg0i8gq/T4eeIcnpv/VRVtJuYVW3GA50XquGfULVxGOJdqLR/IYXyjrDr?=
 =?us-ascii?Q?pEVzI43+GNL/13UzqRnqt5gQ89MYWEAtjJu/bSXBo17Z26VEfq7lK1msTMq1?=
 =?us-ascii?Q?jq8iChpYD3+Ie0ngg8pxG0zErp9SzBbQBBeij4Rtvd5DTILxZigds7vQKi06?=
 =?us-ascii?Q?JxOUJTJaMuBzdrN4S1j2s0cRDLULva1Dx+joCgVlaSlzoLCkUNmUxHhFkQ5A?=
X-MS-Exchange-AntiSpam-MessageData-1: xs7JX+c1kyx6NHgbNTRKsmx2MLj4FAzz7Eo=
X-Exchange-RoutingPolicyChecked:
	z9n1XVvC+DffZXll23hPXEnq7lP8ixPAdzCk5BQoevf3gnQkQ33q6PlcpdidA/gVZvipogELaQT+RPGZT3nlj54cNO6MoQXIu43WQrX5ihZODaqjiq4kDHXfKxEkSVnYe4bBHYkdrrlmYRxcAMRaVnX6LLVW0kh3+ucDJ+u3ypQrx9hoWCJ25pekQGgMAo3Xw/Wo0/HXEB1BFLrXRTjqx7rcO/hqghwXsJcBIHtxt1pe4S5W/+k62PXbDaJO7CtM4HKTcj/ap9cx6fY1KrYuNq+KbwU+ETtkKdRIrnTezfC4qP1agK2/MH8RW93mcZW9yRdNUtW8KBqKQ43eQDeYmA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3XpLeV0oWBOxAegJT3mXtTg5iKtzfmyByNWC114JL1BGzXQ9fWNZfk5w59YAxhW/3QkvJiglI5e80qPbPXkKmkOPFFeX7F01H49XxpgegnWwlGjKy8MrJANAec6q3yzkUw1yJcBgolAXywzE5Klp64b3jG4RmBAueI0PDDfIkfyl8MBNpOc8GxX9QoHmHJ3A1E5vOZy7SMfCj9c1fUR0VOW+q6SlgwdLUvjBY9epZwG2bW+IhV+urPBAUdm89bO/e//3ee1O6t0FKmg7hgqQFpB+6/9QsSSmfloEVBL7aVFyCvAhJlLzrUESiH5mSyMqdjh0RnwQGrDSN7aV0NiCab778/bpL8u4bSppPNyrRfX2Cb5kPweFUK0xsijReBxHWqwz+HkAqLG0R72eEzi1UxXJMzdDpg0rj1UWJRf+0CoTb84HZ/wVxLv2yFSHoZ99eZySg/i3p7+XP4KR/9h0RDJ/hT4qd908DGkHBbrPfbRGNlCFyVKEOnmz3tx0azbaHo81tzlqIOP0+OKYrQAkKe9AbjM4JZ6sXJMwi9g6q4tjnGkOu9paIB/myxzGrCKPNzxGLGrla2TXi5xpZEbuQ//IEtIHAfHhK2Pc6CH0dqo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 829bea20-b902-4890-88ff-08df290223bf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:15:27.7652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kTBKOw2hdTc9HIFoeQoxkSuMeYWOGq3xo7/022ms0F7LNYPEbgcJI8232Xw4BAQFgT1GLy5YGqck+4uwlzD/Z37EThFMQcZiVLDV3vvJQQE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7992
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX76VQHTfR40w7
 4QH4iUYn+vQckMcIY7YvJyxlUk30XmQHbWcfqZXTBKsIV+IbekYriO3cKYU+4nEyfXGrXhQmxFG
 +TI9bv9izj+mHh+XI6MvUVap/t3OI5tDjv8bCi2MUWSrH5gor3r7jzZ00NJdzsNoaDdWGnRhhSL
 nkpU1rvt6oUvx91x5WNcmI+UkFa+GxEVtSftC3jrveZjXCT2qtbz+cW+GzS5WdbbxKmLTW7x67S
 csAJCStfsT4EUcfm8mG+eVQeYXZiKYmzPcszK+jpg9DybngmLqc3885mp4bLKm74FweCAYDPnOy
 Hv7IWmpslD6t1QEikEC5p99MnaUYgv8Owms0AfM9Wb9hfuqpLIs4g8fayXxqLDaRZxvzOIEQQiP
 nknm3nrQI9ib2fTlYSCmxIWkicnTGPYV2VpaaVXCfCHPnf4aFRIrXr0gNkVw8LMbmwlTk0OpCGo
 Gkf8wz+b6jfCMyP5DOoi/PyHtIWBaeAyGSP+hjmU=
X-Authority-Analysis: v=2.4 cv=Kp7YSmWN c=1 sm=1 tr=0 ts=6acde8a3 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
 a=vvjUwkIsEb8c9uUV7N8A:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12108
X-Proofpoint-ORIG-GUID: Clh442Fhd0G5-QLMVA_TQRFwyhboaWkf
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX5omKFQWMiFa9
 iF6mF+lcrzqSLTNO1pakZvKfrE1Db3I+HTdw8X2UriwC2POSVVnyySQNW4oBZOAZk/p2d4PTWBx
 5JOXsnt25jV9/H3+iMVE4r8hJp8DvJoiDb0YeZfEhJ2/bboecnBI
X-Proofpoint-GUID: Clh442Fhd0G5-QLMVA_TQRFwyhboaWkf

From: "Darrick J. Wong" <darrick.wong@oracle.com>

The code that validates recovered rmap intent items is kind of a mess --
it doesn't use the standard xfs type validators, and it doesn't check
for things that it should.  Fix the validator function to use the
standard validation helpers and look for more types of obvious errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
(cherry picked from commit c447ad62dc906f4b5f788e8ff20c1768ab2eab2c)
Stable-dep-of: 7b5f775be14a ("xfs: fix unmount hang with unflushable inodes stuck in the AIL")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_rmap_item.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 31cfd734962f..f248e2b0ab5d 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -466,11 +466,9 @@ xfs_rui_validate_map(
 	struct xfs_mount		*mp,
 	struct xfs_map_extent		*rmap)
 {
-	xfs_fsblock_t			startblock_fsb;
-	bool				op_ok;
+	if (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS)
+		return false;
 
-	startblock_fsb = XFS_BB_TO_FSB(mp,
-			   XFS_FSB_TO_DADDR(mp, rmap->me_startblock));
 	switch (rmap->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
 	case XFS_RMAP_EXTENT_MAP:
 	case XFS_RMAP_EXTENT_MAP_SHARED:
@@ -480,17 +478,25 @@ xfs_rui_validate_map(
 	case XFS_RMAP_EXTENT_CONVERT_SHARED:
 	case XFS_RMAP_EXTENT_ALLOC:
 	case XFS_RMAP_EXTENT_FREE:
-		op_ok = true;
 		break;
 	default:
-		op_ok = false;
-		break;
+		return false;
 	}
-	if (!op_ok || startblock_fsb == 0 ||
-	    rmap->me_len == 0 ||
-	    startblock_fsb >= mp->m_sb.sb_dblocks ||
-	    rmap->me_len >= mp->m_sb.sb_agblocks ||
-	    (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS))
+
+	if (!XFS_RMAP_NON_INODE_OWNER(rmap->me_owner) &&
+	    !xfs_verify_ino(mp, rmap->me_owner))
+		return false;
+
+	if (rmap->me_startoff + rmap->me_len <= rmap->me_startoff)
+		return false;
+
+	if (rmap->me_startblock + rmap->me_len <= rmap->me_startblock)
+		return false;
+
+	if (!xfs_verify_fsbno(mp, rmap->me_startblock))
+		return false;
+
+	if (!xfs_verify_fsbno(mp, rmap->me_startblock + rmap->me_len - 1))
 		return false;
 
 	return true;
-- 
2.53.0

