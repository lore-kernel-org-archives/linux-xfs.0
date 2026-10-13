Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53C64C4F40;
	Tue, 13 Oct 2026 09:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884408; cv=fail; b=nbaXWXX4n6+Gnj8/n3+0ctrX+piURQBLo74Rj/oSTRGOlsH3Y6NRriCYL2CgoH2olz/DfirLTtauxNW0RK0YcpMpL0MF9uWqDXvJ/f2pkOyKbvkpRapBCa2Fojpe6g+2ClRE7+8l9zwlgAvphPbsfXloPiqWWL3qn5I/CzPUe2I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884408; c=relaxed/simple;
	bh=LRko4OWZ8NE4F5QjowLD9QKF7pQifMVCpc+nRbx+7XI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DxRzejYBDJemFepjWlh94fJliTaw8rV+jFTmpi/8aMBiU1AeFMuDdSD9UrxkQv7El1IxwRWaV6f3rCj1fPC1WmTevBFpRqUyfyiyP9bESSpowvWrgYd6WsMl6f+ZFpNF9UjM35DL91SklndrEBdM1x5UPpybE5vPyYlP1sn2fbg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ysn0pcug; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IcretNG5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ysn0pcug";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IcretNG5"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2CbtQ3031881;
	Tue, 13 Oct 2026 09:40:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=FK/UDjPzV2uVYRf7HkvSA+vIcF9eZazdQv6on16HSqU=; b=
	Ysn0pcugqsQzklXYXNKP0v+NCApORiDxrUwvXZoIm2RVJAO6dD74abYJWcB7VKOr
	kebNPCZ5rknAeyY7I4KRDC8UOFJdyKAOepJfgAoT9UW2dwfSGoca4vhhLyr/f5LL
	/2CilaM4wUg0guO2brWarJdJQySd253rgugaQ94tlyuxMuscKOyBedX4ZeJgzD2A
	hZVu5DkDV2pYrwd58Bgxc6QOE2gSR9Mh6GWLyXevKDQsrO2l3eAA4pehdBNmeU6L
	7++bMuMFXhs4dGq3kDoh8ARdvl7jnSsxnqVI5frIvUkWZ14RnVHSXOJAPVVgVU6D
	PDj3/E/6rnzJsi83XptJGg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dwtbpbs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:40:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aKEc026254;
	Tue, 13 Oct 2026 09:40:02 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010021.outbound.protection.outlook.com [40.93.198.21])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt927d1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:40:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LYCCoqLnLPdf0aAUycOMEcHDCaqO7FpilOT0mrIhKRhY9EoPXHetMd8CfbIzufKQMThUEg8pZWo7hHmM9ItBUdkUqX5pX/jrGuEzuV07AbhIYJAupPF+gZ40e6rCIPqT9l61XRJ7TCEBppXjbxY+c6xqmH8bYE1UZc17+6qxFt9L3BzMZVycGHHqjFA3AKaayFoMEOZsO5+T1S9etQgabaXE83AGJppslnSdUlKlNzKBGOHZV0DmqteApT0M+A5lwDWG9oGB4WNlDsUraq8g/EAJs6jRB3aVEPdw+qGt1wT4MwmTUm0XNaDu/bCQXFYAtPgU7la21cEdPHc1Bia0Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FK/UDjPzV2uVYRf7HkvSA+vIcF9eZazdQv6on16HSqU=;
 b=kMfpkQdxQFpXDemWRs1Ng1LGRAYV5WZIXtGo4FdkHuJcnB8qGLUxae6lz6Rn32z/SkQ/RpKuEu7k65YPZm1HaFcpYbXqxzm0gnYQkg0+5GFysHMfNQazr3BzSAlXLVrgjhhNxCKQz5Q3AmAusH+kv7NDoHxlHNXwZAZfUfuSm9zst1wTEtApZ5tx28UzdO8el6T3FpGXZ5daD2Hxz7f9flnUtbdQOqlf4mW8JKSdhwsLVNl6z8VVP5ZVE+DXLTiuZ8yylHYTiV1a0fcPC0swwtuIEFlWFLs7THDX6wyUlz17+8B6IbNLfUvIRR30wO8p56vsUHJpy1emnBD5DUBYsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FK/UDjPzV2uVYRf7HkvSA+vIcF9eZazdQv6on16HSqU=;
 b=IcretNG5aUfaxF9wt0XTCmF9udln5r++v69+4qzDykxAvIkMA/LgEPdNZcB44EP7Qs8hb8+IGPAx3pud4pQ+gnILMTe5McWJXURZWMTiHENppiMEhZ8tdwLCblz/5DIAsUgCMnU/BxNIMAdpmek8Qd5nu12rOIXSbUpSybX1Tm8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 PH0PR10MB5754.namprd10.prod.outlook.com (2603:10b6:510:148::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 09:39:58 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:39:57 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 5.10 v2 01/19] xfs: hoist recovered bmap intent checks out of xfs_bui_item_recover
Date: Tue, 13 Oct 2026 15:09:30 +0530
Message-ID: <21ad47f85c51f0d204d764cd6ecdf3477a03c55b.1791883301.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883301.git.siddh.raman.pant@oracle.com>
References: <cover.1791883301.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN4P287CA0120.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:2b0::6) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|PH0PR10MB5754:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b2727c1-1be2-4216-f7fa-08df290df1c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|10070799003|1800799024|23010399003|56012099006|22082099003|18002099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	jv5oXGx0/VArkAFVmn7IifJIaSeJbrQDyzUqAkEOGEAB2/t7bf6Lj96uI7QvqZtkhO1AdxfWyzxhPDHqbhEIX2MKO/axWhQKDGlhsky4KvyZPk+z55ZHoGfbyFo4nSmNNjI+5lUKOd4MD/vo0Es66/YeMGRKv4K6NqsgpaYWjkpwXavXB1X7qpMvRn2cafNlDMduk3CVrOefogJj2N5zvqYFEBDyveXj9LXBJK3rgDZHR6Y4OiDiCuPGxrYP6o8zemFuC0R9qMvwGu/SCWhDzNBgYse8MJ4VY6BkZqMhn2TH+6eLb9f/QrnzdpjYUcitefrcdMsBDlkL/ypxovOeTL3b6Rl7BRuq8o7k7gY/ZM5oZk3Ett9c9TVjFe7HK694f/UKh2ySi0/+27W8Uo8M5XIDC14CZrQRovw6Zu7QZwzxY2+jSjTXOVBlOXD/p7YXjZg4HMdzTTeKYrbwLttXDvNJKsx1eCp07esYYXbNxS7jNFWlVb6lglDe1UTaz81WS3DvsyTJPa+4iglAbqdUDilBqixk4IP4HmZWa63+EDyRYE+QYrl6X3oldDqJ0FkiZyBu/2bIfUSMmIWhjnUq1SpkdDB2uGX3q1X/NNEi30AT1hHfFo/I/m4YdvLDIAEF06IgbCFDbvAbV84bHUsANruNOjTdskOaIwjy9Qw18sk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(10070799003)(1800799024)(23010399003)(56012099006)(22082099003)(18002099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AJqoTkPSilItilTg8UXZZPu/BRgtWgiSBIv31mkyfqzQwZcY3IPyrDt520Pd?=
 =?us-ascii?Q?hl/QaJtSDXypkC6LwotxGho8+X7dlZqGQcGyuBGc9v3fKt0P/HMVvUdkoaau?=
 =?us-ascii?Q?r1ucMMwZynsdyK4frLb6LsMXtFDe3OCA1uwZjjEr6AOHQvNV4NIghOUf/Ruk?=
 =?us-ascii?Q?rN3/sBJCnwlFfeQPyiOdS3UgGJvVybdTHVlUjHxuQjeAap+RDrikK9NQin8n?=
 =?us-ascii?Q?ywXR7KGKs0VkZIwSSDM4ZaN9IJCTClcH+rtz/F4kKuQpdr10UavqIg/w+xeL?=
 =?us-ascii?Q?AcvHnfM1C0BOVJyFhfPTIJ/5nwdVGwIeX6y6AAa1P2QiH5HnUp35Vuy1KxGG?=
 =?us-ascii?Q?et/cIr9fctTQR/EIs0Co1AMwUxB/QCC3YQl6jOLEFBNVE35PnsVVBKx2d1YS?=
 =?us-ascii?Q?13ky6RGsHK26CMZir1+38P9KVu96XQpjGk+QiMOzOtwoNsFb+EtB9JYMkcF2?=
 =?us-ascii?Q?8Njx4ITj0BkozmMrhmJfUX39NSQDCf8tlF+8mlwR2TssA1pMgaDYhjq2izHh?=
 =?us-ascii?Q?aIjWPXgnJ1MC28d3hcCoi4Nh9k0j/+pWkzLtvZlTkl1CMp/fRYvLlmHVQrVK?=
 =?us-ascii?Q?SxKuCNFnLk4eIA7IFkfu38EUgePm5aOY/fZVzGYG+DuR0qOzEXQHb+XVMeu3?=
 =?us-ascii?Q?xIG4OH/e34ACR4JPfxNS/eBrsOxmQAVJBHduVILsstj1TfZmBeNoWyRWvi8v?=
 =?us-ascii?Q?jE0PpcLvxvm8uLsunxihpDO/Q4rQOwTEZOekm8SAGVKsRHketB95tfOp1iXA?=
 =?us-ascii?Q?Q7LcT2Uc2HZH11mduJjbZV5+qiTtPKgdW3PNS1FE5IeOStsireIynkVxqvlu?=
 =?us-ascii?Q?ZxwGwvErXQl1rIydP2GnHLLPKjmL5xZJVgWvIuP2aeR2AgKhzVbdbsMqjtGq?=
 =?us-ascii?Q?uGXVjLySeOhvmrwPVRlksJHPm11FBFy2GLUcovagfsf5sGfsVHD3fAve8Eyx?=
 =?us-ascii?Q?qQFN6f+UPh1NV+sSDRAr+54kEeTyGmoVbeM6NjJmnXCHx1/dpPBAj8RLGOQ0?=
 =?us-ascii?Q?QhnhVSheL70RgpGWqGcVxyOE1VE76OV+I/3DbSHtohrbN7dUTLOkAf/Y4TRH?=
 =?us-ascii?Q?KIuVhTclZjSHqn2ygBNPqeyeGaNkZsIsJ7BqJ1T7ntBAj41ldNVuITkgZrX/?=
 =?us-ascii?Q?CHhigGIPfIIy6rmJT1SdDFSXQh1uG/WTvhb02j1Tkum+cxFUxWSP2MlzEolm?=
 =?us-ascii?Q?NpzttNBXBc2rEi72Cuu9HD5WpRq8cqpY1KG3tB8oK64FdiwOoEf3Sk++gWWe?=
 =?us-ascii?Q?OI1+S1f+Q8/laEiNLYYJ45qlnWBzh0ctxKY4TbhxLPKOe6bVJYUm4eTAmweL?=
 =?us-ascii?Q?rtZ6RZ03FnQRc+DeOtprijhY7Bzxgbs8lWnpvoPFEsXxAjp6U8Hcs6FGWZrx?=
 =?us-ascii?Q?/LIjYBqHQgv3w1SzTdLtqLczHstJffXLllvH/4cgI/zF6rsH6iKM4QoFTkwv?=
 =?us-ascii?Q?Xh4X1csZKjTlPb0mGmUxVytfKCoOThTB6iiFifKXYx2jfil21LC9Z0bRZurm?=
 =?us-ascii?Q?724GJeoHrwduQJqQOXMNbn/fERxKGhphUUfnDFd3yyKU/M7LcxUjOy3y2W1h?=
 =?us-ascii?Q?ke+TqUTpVyQ+BuPJVZLcZ0NKwfAgr6g9PlgF+T6SWyqanzBCy6tDVTi+r6Gx?=
 =?us-ascii?Q?wGWGSMLzU1DhqNhaXPyMPJq6oX0KhVJnpef4l4UFusaWO5CLQrCpNYbNJuI8?=
 =?us-ascii?Q?suA5/26rFiEY1dnpfxrwyAK7kCul+b11//akdPaEjkPqXU0LGcVNodRHq5C4?=
 =?us-ascii?Q?b5IrEmKYXHb9e6YooOVvAW/CJgPjIIOzpTRx7/s99MUOzVPXq4ky0FFAIygx?=
X-MS-Exchange-AntiSpam-MessageData-1: 7nrbcJIUe3PUqEjMjXQn6sBTz/2QJXYDMmI=
X-Exchange-RoutingPolicyChecked:
	l1aAMYMcsJfoV20iLbwkUMgcExqN9/dimrEbydeO3EIq+WRgw0ZnxfV6H8UFYtMdhhEAtb9Dd/EVoYlVYEbT/PqAJucoZUQPZKNUHtRjis4ObSQedFWbwGyG2lQ5O24mJMvfatq6fhz3nLKEMQSNwIqErScxcq0jh5neyeDzK61QCH6OxjzWMna9Yz1V2EiiFgxclqC37/OoqYcpHwH8ziJFm6coUR9zFjdTpgiNeA/A19ui2Dyw1KBTxIJ/NUZfjj9RmhpbDRxSEMIuhdu7v9SgftcnF5L9k6SGcsewY68A5SvMpPvesolySaUyY3avDrsETKMzRmE4vDxUS8IVbw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3RuOQnhyZPEgypdFPrtEy0CpBSbYI9wNbNnKNU85ILU4xGP1qy2he3OOkOjsOHohgq8CydksI6MesWJR/whP7mlir9cZhasRNBv9tyjzu6Kfi4x846lVh0V/3dbTi5plNnEfpOyH6y7nd+aGe0cQ3HWi4x8HaG6dHT4CKipXet0bxgum4uAZJ7owNWsA4hXxZ9TU0koTIM3du0Ld7H8lZJjvKs6kUVh63A3KOOodeRyoHexRRQ9RFyd/0sW5+zCGhVpd3LnydPZOtr/gaBfwtjgLmrJyoFdrU/+kq0HQTMcgfcuqjlfoDuxZZp1t5Zi8JSwmTUkMooKF0cS43OXD/Rhp9sGXNXZ8tcm4GciIkulE23wGy8N/7Y2cx1cDbRmFwJGLAjpyenIfRRbAifs939k8rOj5qbpyPAP39Een3Zjv9jfnN/kkjz6qvU3mf2Isc1JgimvlX851QTCy2XK+O01r6a7P6LyzNyUtA16WfMHCsQ/yNFaSb++jpNZaYwhhd/OjeWLvQqFbf5W6cXTK8UZupwAJAjGfzFd28vGnRJqBsA9obY9QPLYQJhCn7lmHd+IY+gU8BR0IO1GJqCd9Z2GoxCRcUXtaEHAAHk7oE2Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b2727c1-1be2-4216-f7fa-08df290df1c6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:39:57.9159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OVLBtm7Eno+G7suET15iSwl5z56snUmAZcZnQGOKKa8elU3HCynzFsZIJoZYvthv1ORv80fb+jzgQLTCY2q+og+mLDWdQLWOzCR6arVPzhA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5754
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX0gvzXhFLY28w
 I+koj3nBqcXBty+E+UNfAflWe6RSF3FqRvBXI5jOhIabVlJ9cDhmQhVOpmyJgG6wLrWLyrzXXq6
 I2QNstD2WerEFmwgdJjzOu/+tM9BP89OOYM8XZLl2zdjBJ1sip7YJYkaW/edKXR+5IyAP/EBzav
 m3m86DNmHnwMysV0qVebWKE9ULytr70j0Yhc/gS5KgXSmX2uTCyAhQ37srAFb/Ohj3aQF+Xe05k
 x/Ae/NmbmZWpZzlsA5q7d+NnEvS84zPVy00jRybES1Djpdb81I1FMB9W7m013nXhm3rUtN4X8p7
 +S1WTcn6hIrxrmKHEtmHiZgjMgCIODJGDkV6E6EddnKjbF8mg1ntIQEgyi03GHmtp3+hf6ZNL5Q
 0sEeyVGy1ODn6slyJWGaW86uq1qJg9T+vWVNYL39c41YATEVTRjWDfI01ViOpEjDONoqc0AnuUB
 qWvRtvwhRcjFv47DZ0Q==
X-Authority-Analysis: v=2.4 cv=Kp7YSmWN c=1 sm=1 tr=0 ts=6acdfc73 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
 a=enrBDRFgs7ZS5x2qv6kA:9
X-Proofpoint-ORIG-GUID: Y0mQ6lmPJsmV5SYfnrN5YzLsU23cUmxv
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfXwNFgISvaxmi0
 M97TFyzX87BYDuFA1gwyN8shOTRzdv/lONbvB6FYWqjp0XubD/0kDyctRbl+UxaojA3HMAPePHi
 KnnSNTdAt1RrTM2oheB/lFohatqKO4vk8ftXzYhMv/Ba7KoxhE+H
X-Proofpoint-GUID: Y0mQ6lmPJsmV5SYfnrN5YzLsU23cUmxv

From: "Darrick J. Wong" <darrick.wong@oracle.com>

When we recover a bmap intent from the log, we need to validate its
contents before we try to replay them.  Hoist the checking code into a
separate function in preparation to refactor this code to use validation
helpers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
(cherry picked from commit bc525cf455dac810d28f9edd379805dc249bc5a9)
Stable-dep-of: 7b5f775be14a ("xfs: fix unmount hang with unflushable inodes stuck in the AIL")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_bmap_item.c | 74 +++++++++++++++++++++++++++---------------
 1 file changed, 47 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index a3b350437db2..88d28a862f52 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -418,6 +418,49 @@ const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
 	.cancel_item	= xfs_bmap_update_cancel_item,
 };
 
+/* Is this recovered BUI ok? */
+static inline bool
+xfs_bui_validate(
+	struct xfs_mount		*mp,
+	struct xfs_bui_log_item		*buip)
+{
+	struct xfs_map_extent		*bmap;
+	xfs_fsblock_t			startblock_fsb;
+	xfs_fsblock_t			inode_fsb;
+
+	/* Only one mapping operation per BUI... */
+	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
+		return false;
+
+	bmap = &buip->bui_format.bui_extents[0];
+	startblock_fsb = XFS_BB_TO_FSB(mp,
+			XFS_FSB_TO_DADDR(mp, bmap->me_startblock));
+	inode_fsb = XFS_BB_TO_FSB(mp, XFS_FSB_TO_DADDR(mp,
+			XFS_INO_TO_FSB(mp, bmap->me_owner)));
+
+	if (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS)
+		return false;
+
+	switch (bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK) {
+	case XFS_BMAP_MAP:
+	case XFS_BMAP_UNMAP:
+		break;
+	default:
+		return false;
+	}
+
+	if (startblock_fsb == 0 ||
+	    bmap->me_len == 0 ||
+	    inode_fsb == 0 ||
+	    startblock_fsb >= mp->m_sb.sb_dblocks ||
+	    bmap->me_len >= mp->m_sb.sb_agblocks ||
+	    inode_fsb >= mp->m_sb.sb_dblocks ||
+	    (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS))
+		return false;
+
+	return true;
+}
+
 /*
  * Process a bmap update intent item that was recovered from the log.
  * We need to update some inode's bmbt.
@@ -434,47 +477,24 @@ xfs_bui_item_recover(
 	struct xfs_mount		*mp = lip->li_mountp;
 	struct xfs_map_extent		*bmap;
 	struct xfs_bud_log_item		*budp;
-	xfs_fsblock_t			startblock_fsb;
-	xfs_fsblock_t			inode_fsb;
 	xfs_filblks_t			count;
 	xfs_exntst_t			state;
 	unsigned int			bui_type;
 	int				whichfork;
 	int				error = 0;
 
-	/* Only one mapping operation per BUI... */
-	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
+	if (!xfs_bui_validate(mp, buip)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				&buip->bui_format, sizeof(buip->bui_format));
 		return -EFSCORRUPTED;
+	}
 
-	/*
-	 * First check the validity of the extent described by the
-	 * BUI.  If anything is bad, then toss the BUI.
-	 */
 	bmap = &buip->bui_format.bui_extents[0];
-	startblock_fsb = XFS_BB_TO_FSB(mp,
-			   XFS_FSB_TO_DADDR(mp, bmap->me_startblock));
-	inode_fsb = XFS_BB_TO_FSB(mp, XFS_FSB_TO_DADDR(mp,
-			XFS_INO_TO_FSB(mp, bmap->me_owner)));
 	state = (bmap->me_flags & XFS_BMAP_EXTENT_UNWRITTEN) ?
 			XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
 	whichfork = (bmap->me_flags & XFS_BMAP_EXTENT_ATTR_FORK) ?
 			XFS_ATTR_FORK : XFS_DATA_FORK;
 	bui_type = bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK;
-	switch (bui_type) {
-	case XFS_BMAP_MAP:
-	case XFS_BMAP_UNMAP:
-		break;
-	default:
-		return -EFSCORRUPTED;
-	}
-	if (startblock_fsb == 0 ||
-	    bmap->me_len == 0 ||
-	    inode_fsb == 0 ||
-	    startblock_fsb >= mp->m_sb.sb_dblocks ||
-	    bmap->me_len >= mp->m_sb.sb_agblocks ||
-	    inode_fsb >= mp->m_sb.sb_dblocks ||
-	    (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS))
-		return -EFSCORRUPTED;
 
 	/* Grab the inode. */
 	error = xfs_iget(mp, NULL, bmap->me_owner, 0, 0, &ip);
-- 
2.53.0

