Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC6546C4CD;
	Tue, 13 Oct 2026 08:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879341; cv=fail; b=PKXXOkkg/e3xfmOD0bLIJEadJxKzrtVlvtztusCkUwLfaYushtnK5scVp6ZHytm0yQXXIgjBmSQIocWWtn15cz5xOLNQpKjp8DaQdd7HSom9BO82SnGBEORz57OHTF8b4ZhV3PM9hdyYvo/3ILv0HT4xff2I/ipruVdpLDiao+A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879341; c=relaxed/simple;
	bh=Nnoa0vu70ss3DbiAl71w0JKE9WVMReNq7LowQYH0pbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VBLDWYVuJlcEzEPqLG3l0PIn56bnkv0TqQ2oMpBRsT8NrOk1CbNK3j5SEHfM2GAZ0kgoYwmPHNe2kY+S+h9/rbAeSsDgqJmc1KjsvxzzbjVgX7eBfvENfjZg+b7j4cAgGVV1OHOhPItFjtQm1Qg9uY3e8O8uYIPKVtHC6Gw4/po=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=r7YKoogj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ryXIdPUl; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="r7YKoogj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ryXIdPUl"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2Bss21439853;
	Tue, 13 Oct 2026 08:15:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=xnXFJlowAbH33sUZegxon7NLwItV9gCjeigtC38feQc=; b=
	r7YKoogjDNPsoPlZUIjLTpCcZ2vR7qn3nMr/vEnF6nEQLrUfidHzHvdUSogBP3Ru
	arWGrum27wHf9j8Vn1rk39To8fv9IIstiMvJY+usgLZwsNKUCDAz5i4iMkWAAO7d
	Cxc/TfbqdbHmNMoKQlxRfXp1m3Vix0wi0Yqqh9Dz0qikUq06NLuVF/t+kWNr9PpA
	DTO90fdOTpvP+5emweudOihuKepulqZCNtF4RNwixBjHsyNAmVxoB7SOLwuRylDh
	ejxFchSRo2gVzgSM+toThL7xPFwTAV1RiZK6uoj/P7LsNfS6BEC7bySfP5ejOPqI
	qiz97lZZW38IW0covY4dXw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7df7uk7x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:15:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86ODk024857;
	Tue, 13 Oct 2026 08:15:35 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012045.outbound.protection.outlook.com [40.93.195.45])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9as74-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:15:35 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Htpoywntz3HZSp4YeNrh7evAeTeVQjBUtEVRxMLB8H+G2tYOAoh/Iu0eF3HyQFpgoUpqtcZhmk9Rgs15mhHcU3174ku8/VaLLuBI/1T7Wqu+U1B/OpUKT6RR1IpiONRRGdUrBFn6a/lxPivxVE3pNQJu1JPqTuX6Sv4vShHNZChMwG+q2CxCn8SszRssqcLFGph0Q2SQIwKPZoqxXGCuWQ71AXfkgR5dTXTv/lKoEcXWy+AvxCd3dTIMl7z7EmoHLpki9tvFXlmruS+pjXmlSB5y15jxTz7UuOdSrBPUpHRWYoTuxyQ2eisvH7OeXf82Pt8fJxxG3o1pnObxGy1PgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xnXFJlowAbH33sUZegxon7NLwItV9gCjeigtC38feQc=;
 b=sXTD3JXGwx4jMn/tuRYQsQ+b6VdBKJSS5bRIrLfGAa0E23FSfVKlozz0pugR1phh+B+m8nBp/QxFrsEefdbjNuhjo/YgsKlU596g3T3p0ByGhY0tZP6m4XCTRREN/c6fvfMddoFPUlXbtHi6oogRQxRNEdsdwD6+j9zD2BhYIgICSIf8DlEX/APbk3tHehuPf8MEpYp0J8OLLjaamYjrKs1aB2x5CrLmMWMTVjGzAtdwOZ4TicMmEtbn1lmly2xhZ3s4frTFjq9T5QtqILs8uW/xd+qioe9Xq1X1M3BGzkcwjwTUGQUXrYhCzd2TCtQeXoVnf880pcDv9WSoQhRb6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xnXFJlowAbH33sUZegxon7NLwItV9gCjeigtC38feQc=;
 b=ryXIdPUlrKhqz0Ajb6mgVAA+CsBureT0ZnfwV5us6WdXnHVa5J4vnhp/PuEWyvL0CjiFWatcFFpaowhFvoUV2UoAK1Pl/KGwZ/FE0bWe8Vb/cEddbKWqM+XphoLparqZj7xuRYZalzre/fTOhqpr5stygqT27Z+NmzPDpE1jt4Y=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 LV8PR10MB7992.namprd10.prod.outlook.com (2603:10b6:408:1fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.7; Tue, 13 Oct
 2026 08:15:32 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:15:32 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 v2 05/19] xfs: hoist recovered refcount intent checks out of xfs_cui_item_recover
Date: Tue, 13 Oct 2026 13:44:49 +0530
Message-ID: <c2d57f03837daca139818ad131134ba9e41eb354.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0048.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::17)
 To DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|LV8PR10MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: f7793c15-0b4d-400f-ff71-08df29022664
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|376014|56012099006|4143699003|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	oG+KQYg7Cl0xeAfbV5QFDdLoIS8A2T9oCvMnNH837CIZG0g/OGoO7sFx8YrK0FWcj7mIah+LZTsUAuGgPCjQv71SFw8OKUErxGyJcj9yc1FKI9DJhuMLvMZnjKtH9MtjBSed+2KnE+zJxYxdTm8uj+TW8jN0pK0t1JgMpzwZ9o0RVIHs6ckjKTSZSU+WnJ0ZZwrQSm/VPOoT2BkwIrEv7SB+LsmYEmXcqVYa9dJFV7o1vLuFWURZXZaAxRJzKkUecERcAb7YOb5hAZx2T35kY4mJCl1GUeSAeLLWQCxBNDwEF4lN+8pPYwQ/tABhzoq1Y/WsDRnyM4PujhOlPkWOyMLrHnT8Sj8V9Xn/zuvP/uA39BQidvLSJs/pn9A1KhCxuGmf1h2JV1bR7svhylu3bnTDkgKwKc4dwOYxXpij8ghv2hiuCzzX9kiIK4Pbc2MCA1F8MGzyz0ljM7wkoZuO1w3X9dzk4u3FrhsG7Tqy7y8cGZq7VTngTFBgmVqwLSg5I/DAllDiRf1X85c8VyEdWCxpJeP3v5ME+hfeSzv13nWwLeFh2KOGi2+VHSTY9MQARxEXxDLqxypmlvw1lZG6jYu4k4G65lpO6siLTsLX2OWJvGBdhA422j7j0KuP0kkv3XKq4pgg8HHLdZyem7hQpc3qlrWEbE2Sed/PWGovVC8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(376014)(56012099006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XYTXhMVKQXFMLEZJSz6Eq/VOC+n9ICid1dC01FAaYXQ1MqH1iAY5WLx5i+8t?=
 =?us-ascii?Q?mQzTxcHJ8P7iQ1PHYo3lXS8s01tPKhTJ0tsHyNV8TTekSfhnjI/c1v9PlWDV?=
 =?us-ascii?Q?whmMq2jaHqUpaUEgHZru1sh4WMqFAaNA58caklYhCWifo7+a0ZG8PcDax1e6?=
 =?us-ascii?Q?mwa+cbfbuaxkxbGwu8duZwq2X1cbzI9b+YUe7d4vFYKSV3ExsL0yOFK59o8t?=
 =?us-ascii?Q?1yCJrqrtyB5YgB91yDqQE3xA4TcZMWGwEU1gGsGIuMYI6LS3yVCctDlHmAkZ?=
 =?us-ascii?Q?7Z5TYz2KmcA0u3gaPmrZggCDpOtZlshC5zm50ANKSBaUkE3+KIP+0l/Iv38l?=
 =?us-ascii?Q?UHyhLPmlZ5RykiP5ONpds4WICgkiFkud7fJeYk7s5op+M0T+Bk8n+PxYU/KR?=
 =?us-ascii?Q?90RaY9afF4CZ75jZxPCEve5ZXpisoa0GnLnnV4QzVgL++AR5d1Q8MZ7bvtFD?=
 =?us-ascii?Q?v8A0B+i5HZCH5j5b3rzIwwqgezNJ+iKf9yXhBpY07HZfFYgaXoJhQuugQyW9?=
 =?us-ascii?Q?ohmS1ygfg96XyToGpZzYueFWaQFuHyxELBffV/tDjKYW8ThLbXxM0p7ugukt?=
 =?us-ascii?Q?DkaCnd7i88egeD9VhP66C7yciL/yj3tipHUOymC0wnkkQVpaIgKngEd0aOMU?=
 =?us-ascii?Q?Ae1bBKmCH2+0K+TxRzvYdLCEvGMcmIG5u2+LAcsYwbJw0FjUeyGTqsu2GvNF?=
 =?us-ascii?Q?xmXoI+GNnB3Yfq3p1utmuyIJMEq+yJ9bQ+7kYJE+dujANlBOEPUyxxBHOZ+U?=
 =?us-ascii?Q?HjOdDDSv7TijMfbuwML43nxQbQjF1xmS48jMMQTfu6cEwxF9frVWvioczfIo?=
 =?us-ascii?Q?Ok/rYUbbAgl0vFw1KquXnox6ooN8Xip9Gela4JD2CYwtALGgIidIZ//1j2bu?=
 =?us-ascii?Q?BY/TOr9gXtkj2D8Q3dOuLkHAdHQj0o1Cf2WdQ+GaTq6dujihVUojXJGJXE+A?=
 =?us-ascii?Q?YrQyz33JNMa3zwtdftV4yaK9A9mmpCqkpxsco3gpj+WkD6bKoaVnVHd2stuX?=
 =?us-ascii?Q?9DGAh4BmTrTtIYQb6Y2VEDWp3WWKdz7cQo8zr+U82AdSWlc5lKL3Coy1iRDQ?=
 =?us-ascii?Q?RlnwuoARH0olbiQn99f/yQNNABwdOxwkJxvvCqF1sGSUqQg7VI+Pn5EFx8Pj?=
 =?us-ascii?Q?RNcoDc76MNXxo7zi+9eJdtOH3v1wgfatGLD4we+C4tdRplMrfn+ej9Zkz8ZF?=
 =?us-ascii?Q?aLWb+OHQ3parOHeYK1MHdz7l/bttjxHdVfxaQn7HgomBx8fDk+MAhezjwBie?=
 =?us-ascii?Q?6G+bIU32esIMJ8JnPWBSjDYjnMLjWVm6ONwNFDCacFGDdNUJNm29zGwhs2t1?=
 =?us-ascii?Q?J+3lvicDC6fXZFn544+QONH8dEyZu81LPwCsp8K0QZqm6334Q5oL4MNJxzUQ?=
 =?us-ascii?Q?3HXlTySpKr27vZ9+jg618FXiO1raaPNz0V+Cz87F+ZVwf6Qf5U7iQfIVfQ51?=
 =?us-ascii?Q?3CmfIIpx6OVwPVgyL7LvWMN2Wdc0hQmQ3ev15FkkrAYXbvNl1BMxJQk5mJfw?=
 =?us-ascii?Q?d1b79X/yU4is2dUhS18HCbkJsXXUNhsBx/lrWlIL1INSgEj6z+yi4apObYE+?=
 =?us-ascii?Q?Sgzhd5CkObB0fes4fgpKEUw6Ki57i0UBD7J78oJCXX1PE2iTT6/EamlVZjhi?=
 =?us-ascii?Q?E7DTYb2YC27bzKdRKyDeis3zUoyN56ldu+B1TvF3pCUVOn3CS8VZ1WhRDWqf?=
 =?us-ascii?Q?5kGcYoKHSnhe5tifh4/Mf7yJ4SCIRwOpKcO8vRj1YrdIpxZ1HXhX22Oq/wly?=
 =?us-ascii?Q?vc8Ka1F2t2uip7V6VlsJnM1x2aIo+j5EDz4pboWXvkZuynPiS+SAGbWSXLwN?=
X-MS-Exchange-AntiSpam-MessageData-1: YIf8cegKD1fwRimDwNfFBG+POxGmffy/n/0=
X-Exchange-RoutingPolicyChecked:
	lq1ETUCuQ5VQPf8qqdlywFKhFCYIxDJ46EuNjH9z+KHPS1LY2H85GNyZA8quYReOBUgzrz751MLa8qeGS39+DEUlz5857MUGIMNLe8QtkOx3yYArbGKgutMP4X2DRTNmHAcfldBujN2OilDeSro9wZfLvVOfGGHWLOPESrA8wUsMYupfoT+fiVV+a/oGFNxGVySs4QVRa5cPnRdDDaePK/GThSypkJgDMyzg3KhQSyfh3Fjyu94YEm33LwiMrfcfQztc6sqxT8+4pDdixaLPS+JPPNKxE82d6m60o9TK+TM0gd8skBwMnI46DgDs05VOKJJ58z1b4gFKX25MSg6fgQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gqd+Oz5yaHMw09vbTxooJUoqH0LwxN+K0lnZjIAqswB0uNZ5MGJa3L820yLFJbBUF9fiaAfSF3xro3dXMPAnhH+KcIzBC7cS2KPOGK3+0qtnR8vbzBXu377V971kGzSFzcy2iZbmAackDU2C8/inMzrfy8hbexyfoaFHKAxmoeqfYSI63i0rPBZDM/cm8yYzZDqJhAFcWw42l+UFpToOdBOb+5uuog1qGxVtyLtUWKQ+IgIw7Tdl4JE7ywkuBbEMFsCyZpFAhIqLCA6cBh0dew/TpJIgVSluWpwPAdlWFS+LJa+yaY/rDd3xo6ukcx0oL6Y8G3o1i13PpMwc5JmbOlTccGsZ97TtLCMwc3ehNbr4B+RDVVi9dCTyG33KIbA7FIc9GnFd65bkuJRmuy28Xlc6FPNHjI16t4jeUBCLyzx5aJUNVCXrYNMiLYwgPWkfIGqQpnzA0DYVO/dZD/t4q6Y91npUVp4Vf9bMymKFTbN3oL2c1RXOMfhM+3dDbaK3Ne/No9FEXoxScbvdt5qyogjItBzJW7m5vfxhLGH1CWAI7VSa3GrZ2DzlU3516ryzzE+xkhCnKN5lp5iDibsf8YnfdUntRZZUEoP4/rYsbYA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7793c15-0b4d-400f-ff71-08df29022664
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:15:32.3722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gr7r4eAopmjwvet862z4tnZI2D1ZuEnTob8HgsBq/gpcLVAhccgkmxTw4qGmtwQNmkP+0xSNZYkHt0UsVd8/c263YYwTzsJ8S0aNU3CCzOM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7992
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=N+a8hG9B c=1 sm=1 tr=0 ts=6acde8a7 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
 a=XUHDQfcMxKEf4e_NL1gA:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX2C9XqQ4bPZf7
 BIQvqgaZJvdlCNmpVjBnS4NhuS2M6WatL49N5JzHEzH0tY2NjGQpnu9I2HTLCA1WbxtV0IT8tz0
 7is19e4IMC+nhMP7rc/exOlgFJKh+NiJM6m43V6Zh4LNjUz1A9T50eauz1RrG1CFW5n7VKWgdpD
 KMlncEZeWevPAYzEtPO14clZPVzTKkR+tML32MD3DecyT58tqAC0QwjUKav1fFg/fDFLtkbiCyt
 IPg9LnwKPN4/fTaG63hf6Be5RBNR7G0p7qIo8ez3hw3RPAhXL8Fcz89lyp/+Et+TQb7yFqflJB2
 6rdVaRZvwZazfd/YDJMep2DrxJZvaDgBPUOQSnw3uk5+KTJWj+A7oENVjpQmGJOFNSLGwAuw+v5
 xxJY7q5DmqikqLOUAxn0ujtw4QVHOvRHacXoL3mDmP6U9LNpglmssEGccpEtG9yxJim/yWvV33H
 cQ6c6kudPqGvXGgheZw==
X-Proofpoint-ORIG-GUID: GfnXdO4n6YPBgFyhGv9MMiJWf7M5BF3E
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX2gZ6yXhad5Mq
 cANeh4C/gmHl8WV7FMNQNkOfL4Iro22CTx3ffnOxWnUTGiXTUH1miNS7C1UnDD2ijE7ErRVEWck
 pKtYpUhy3gLiVwSlobeXaP0IN5OHhbiZ00bHdIPORiBgOi6LsckQ
X-Proofpoint-GUID: GfnXdO4n6YPBgFyhGv9MMiJWf7M5BF3E

From: "Darrick J. Wong" <darrick.wong@oracle.com>

When we recover a refcount intent from the log, we need to validate its
contents before we try to replay them.  Hoist the checking code into a
separate function in preparation to refactor this code to use validation
helpers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
(cherry picked from commit ed64f8343aafa62e762c74dfb400f640b6fa6c15)
Stable-dep-of: 7b5f775be14a ("xfs: fix unmount hang with unflushable inodes stuck in the AIL")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_refcount_item.c | 59 ++++++++++++++++++++++++--------------
 1 file changed, 38 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 0dee316283a9..83dddec08f3c 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -417,6 +417,38 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 	.cancel_item	= xfs_refcount_update_cancel_item,
 };
 
+/* Is this recovered CUI ok? */
+static inline bool
+xfs_cui_validate_phys(
+	struct xfs_mount		*mp,
+	struct xfs_phys_extent		*refc)
+{
+	xfs_fsblock_t			startblock_fsb;
+	bool				op_ok;
+
+	startblock_fsb = XFS_BB_TO_FSB(mp,
+			   XFS_FSB_TO_DADDR(mp, refc->pe_startblock));
+	switch (refc->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK) {
+	case XFS_REFCOUNT_INCREASE:
+	case XFS_REFCOUNT_DECREASE:
+	case XFS_REFCOUNT_ALLOC_COW:
+	case XFS_REFCOUNT_FREE_COW:
+		op_ok = true;
+		break;
+	default:
+		op_ok = false;
+		break;
+	}
+	if (!op_ok || startblock_fsb == 0 ||
+	    refc->pe_len == 0 ||
+	    startblock_fsb >= mp->m_sb.sb_dblocks ||
+	    refc->pe_len >= mp->m_sb.sb_agblocks ||
+	    (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS))
+		return false;
+
+	return true;
+}
+
 /*
  * Process a refcount update intent item that was recovered from the log.
  * We need to update the refcountbt.
@@ -433,11 +465,9 @@ xfs_cui_item_recover(
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
 	struct xfs_mount		*mp = lip->li_mountp;
-	xfs_fsblock_t			startblock_fsb;
 	xfs_fsblock_t			new_fsb;
 	xfs_extlen_t			new_len;
 	unsigned int			refc_type;
-	bool				op_ok;
 	bool				requeue_only = false;
 	enum xfs_refcount_intent_type	type;
 	int				i;
@@ -449,26 +479,13 @@ xfs_cui_item_recover(
 	 * just toss the CUI.
 	 */
 	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
-		refc = &cuip->cui_format.cui_extents[i];
-		startblock_fsb = XFS_BB_TO_FSB(mp,
-				   XFS_FSB_TO_DADDR(mp, refc->pe_startblock));
-		switch (refc->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK) {
-		case XFS_REFCOUNT_INCREASE:
-		case XFS_REFCOUNT_DECREASE:
-		case XFS_REFCOUNT_ALLOC_COW:
-		case XFS_REFCOUNT_FREE_COW:
-			op_ok = true;
-			break;
-		default:
-			op_ok = false;
-			break;
-		}
-		if (!op_ok || startblock_fsb == 0 ||
-		    refc->pe_len == 0 ||
-		    startblock_fsb >= mp->m_sb.sb_dblocks ||
-		    refc->pe_len >= mp->m_sb.sb_agblocks ||
-		    (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS))
+		if (!xfs_cui_validate_phys(mp,
+					&cuip->cui_format.cui_extents[i])) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					&cuip->cui_format,
+					sizeof(cuip->cui_format));
 			return -EFSCORRUPTED;
+		}
 	}
 
 	/*
-- 
2.53.0

