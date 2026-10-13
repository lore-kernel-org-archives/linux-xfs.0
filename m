Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2374B8287;
	Tue, 13 Oct 2026 09:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884480; cv=fail; b=WJj/rdPKsUnblpN3W1lY6qK+pmEAkzUtozfbj8s3fEEpQXMCBxcZT6+K61rS46zV6zFe71sPCQ4nfGbomoDCuddjrfJhrU8wd5SzSs+COO/UW/QuhTnVfMpTQAHbyyIyTJETcUFqSVadzJwbnhjzx3LVhcdi1xaPuLbr949rsI4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884480; c=relaxed/simple;
	bh=99jHL3j2KqJhaOoaT27NbvEhK65eKRAbkLqKKzQeFB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=T7anUUwnxWBncHkWCOJs7aA4wdW9AICu1lmjfPRg+0d5pFNZNz82gpv2tthIQ3OJWhzdcODsE+k6QkhdyWhM68Eo1YCEqpE7FSFOsF+3WQpPLbBsg/UeTjSI+oJHl1PfUKXZQCmelMN89V6V4zTXxwrskqItS7TFkj4/TYR0Nso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nYWSVr6/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xnLcRmdc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nYWSVr6/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xnLcRmdc"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2FEst3439587;
	Tue, 13 Oct 2026 09:41:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1wl6mv/NUzJkaG5icea4YbfxX2BKeLofZ3qrK7gVKT8=; b=
	nYWSVr6/JbCGqC3etSpmBxW3flI/oNcTccgK3b9zxM74bsqwlgzcOeYOE9MGzCWu
	og9VJC5SX5VL6+ZFcYsRJ3NJ7WflbOxm4VsaLCj71ydcqyM7WlSRc0rUn5lxkOFR
	YekEaqoizkKJdbRJBUjyw2g2yiE9JNZhMnMEvQ0wWD3QKGrN1RlwWKLtwEezrl/5
	fKqlWzTI64M7JdzRjnTqYB+OV9E9vyLPT5Ixm8kKr/ZSbtkH9Jb0L3J4263rTh/k
	MxXx+098IWLqVE9/MIRAORJsvBhcami9CyeyLRfXLMSjw/5wjApa0PKHl6WKbKI+
	bgorn/6/MKggnCq+9HWIyg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7de1kp9r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:41:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aUv0010940;
	Tue, 13 Oct 2026 09:41:14 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012021.outbound.protection.outlook.com [52.101.53.21])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt9d7fr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:41:14 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c8FbCNAbP3FarL4hDZl9cdF3/9VZgNXeg/3BrholEmbraes/OoGb9let2nse3LXKQhubOXGMMOd/fh6Gny8tW2KxXkt5vlodx6nXD5MO59PLNly+/cyjFJWVrlfA35G1/i33UBFzpHD1x+VSHjzu94FRAnzs24vHBs5HAwhJ3U7oxzgJ7TCBVUD/YWAr26USm7YQuGDLYSPzzAO/7LesTVTewOmyejpeEhFEI6fOtGyzv5LdsFqLt7G8bjdgS7CF/fdVl6+OGtVubr8U+e0Hk8bGNqOsOwwRNzTnMR4sOZrIIIrJO/Y6UfZxEsTrj0G/oqxbbUVB5lST47dLTMhgsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1wl6mv/NUzJkaG5icea4YbfxX2BKeLofZ3qrK7gVKT8=;
 b=vd22aW8XI09f8hadl0Royapu91ztgoN58q09NAjkLOWBy2FqTNyGRoJpyjIPEjQ9yeImEc+Z+pO9jxHVfDp1hoxEIvoVn3dQE0MTkEi/DRKw5Cj+waXwYkE3tuIBS08hc9D1ZKlOU3u/DiwiWM471Glr36tHWo2o22JKL21VzyS06R90U9TS7tBy7EBbw+WtU5VntVK38eTpXopF7vRJ5hpXzmnLx+f03R1FAlvazq39AerQDn/hJHBJ2hj+Ic+TLrfemLGVr5pc34LmF1NRo0+ym/U2MLe20mBNdeEtJ5BsZkUBtt7xwtAv2K74shKkO/awz/85QwW34Xe7ND8SgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1wl6mv/NUzJkaG5icea4YbfxX2BKeLofZ3qrK7gVKT8=;
 b=xnLcRmdcqiT1m+BLsu76k4cT1nyaUMyi9t4Wpjt98ltgL/07O5tzmY/FJuME60DEyock6FJAsj1agVj+0FKMNQZk0s9Im9ZwBF/R3+1GqB1ztuWiVnlaEhWGjQT5M3J8ak4CwWuIzOSZuAcGilPl1BKZoaZQ33utR0Dqk2iERl4=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DS4PR10MB075839.namprd10.prod.outlook.com (2603:10b6:8:3ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 09:41:12 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:41:12 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 5.10 v2 15/19] xfs: xfs_ifree_cluster vs xfs_iflush_shutdown_abort deadlock
Date: Tue, 13 Oct 2026 15:09:44 +0530
Message-ID: <a235b4cd31d8a6980bc8c536ee57589fe23e87fe.1791883301.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883301.git.siddh.raman.pant@oracle.com>
References: <cover.1791883301.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN4P287CA0084.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:26b::17) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DS4PR10MB075839:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e747f9b-5562-460a-147e-08df290e1de5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|10067099003|261009223027099003|3023799007|6133799003|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	5yi/ko2zi1ah42dIGk3BsY+Tal1LpqmmFqNnV2/IViPGqWe/wMgup9iLLd0S1CMI1LLyxrdvyiWuusylkjlDLOuaHqMcW9JF6y9ns84mi4lhhKq+EICD4ykdz7OOPoSEjkWDjliX3GD6xzhFf1w557DmxpYwGQjRRWX5ZaDUdnOzltBgTOWyYYRxR4u6aagqtXgbjgKBgxQZQw7j+dU33vRpG9nNVPqKT7fcKl/CJUr1sD7qHvFamIeI+M9KlWCS2wk/OQAGjV4zkjITizTL5eCiYJ7LJeqNHuDAEAMC2IXhwmzCnky9rUg2/B7IxPHUbYwQ9nCGqGGVLX4xcpKk7pmyv5IUl7/vgP7EgQonQHMw+8mpaAFaCx77gbTp2/Lu72XjEnD56rmSmXv1n1tRccYB7s7CqNFRcr35c7MSqkt8y0l6E/Vrxk85CT2Sqvw3h44UUOJcpno2nU+kVMB9IDmO1RuT7g5L3lGUr42tEyhlSlheb4YbbLvuGeQKYwoFkGbK/7R7n9wg9KpflW2edlX66+P/W8U8i0rkjI0ehbOYg/7aq1NSS7t0e7eZWaRivH/GGmsrlD3Ff/iqMNtKeyh6IVCB0XyP3FF1RP3mZ0lZJLAAC4VSWcD3ysXzZh3EqLocDfBfMOQArQc+rXwHBI8iWjF7Tauvl0eSBO8lyW4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(10067099003)(261009223027099003)(3023799007)(6133799003)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ra5bN3/cvPDQC2S+O9DbQqk2omS8NOyEF52+/NWR1U8siX+9AUjgPWwN4C/y?=
 =?us-ascii?Q?rEPg3o0BcgiWdJSrPK4EZf4gBbl5eivmM/cqRSODa4iOHn1iwOrIN+sOfQch?=
 =?us-ascii?Q?41xqTmdwPp4S2FmLHM3dj/Fmp8WK2U08NAYQrAt+/wsb2IR3JUzhB1zZMPNi?=
 =?us-ascii?Q?TXdnYVN2LvGnN3VUm7QkYC6FTx4xVLbkUmctKI1+64TUwWBROL33gnOkwM3R?=
 =?us-ascii?Q?wxEkYou5IxTguwBESWHfrc/9fq71IExPr0n0c8Urc+RjP9g8FSPOhAiyOL2o?=
 =?us-ascii?Q?hfCk6AiFm8+xJAPBcB7IEAU/NtYGwLdxrQ0uX93EhZMJwt+GKnCABknh1Rbf?=
 =?us-ascii?Q?uUsJrN6i/bBV7U141cfT3SFVEfgdrkQyWB6SnXaxyXnJyF4qhEsmWZpolTYX?=
 =?us-ascii?Q?4En/o7vx++7nkzULWYBwcQI2nX//LQZoPBCEEnvb5Iy9vuou3DZ7VGa9MfCl?=
 =?us-ascii?Q?ln84e+2mcC64C2UfOnKLhRhVPRKXpqzamBZwLjn5eGJIgw2XpQTj1/KfZ0KW?=
 =?us-ascii?Q?6gd1o/7DwzNqRCqGT3BARL2e6eINBdNF4hcNEJP95uUrvva2yky338hOKN4w?=
 =?us-ascii?Q?ss1BAgRBaGu5kMl/FjNQUZn2i1gEQtuv67zYXeXWvAiRe6zq7XSDtkzUpsLu?=
 =?us-ascii?Q?t7K/vbFUEY+WCM1CVGtF2i0oTWq5WfHGiWY+XNe4W7mF21tKm+wIYtf1vMXC?=
 =?us-ascii?Q?XZ6VpDem6MYiPUHx0XHJfHEmCIFbfuqKDBTlLdH+T/ZOX1ncFdsMvmKtSPfq?=
 =?us-ascii?Q?5hxkVX8XHoQrsnDy1mPDpiMnA2YY0e7QmL0n5CtCr1tpd9KfAJBKFuOqJ1RJ?=
 =?us-ascii?Q?iqlMeeIQmFd9NbxuzxTIdbgX9ObpTyqUgoTPwXifpzBLX38F9QCtfRAaEQKs?=
 =?us-ascii?Q?YKt10fkj0ILoQajc0qXU59pAwIKXdNDqDeGYDBbs0vIpCVtItxP/oWMn/R/F?=
 =?us-ascii?Q?4kIc+2UgmB55rIPysRyRerbFv7qidJVnSwziY6GhUTU5RoYY9BoKwXsJfnEh?=
 =?us-ascii?Q?r2oxaouRCxWtepLZGhIiHqRobGZOVca9uNEnRMemOhbWT2PN1Si9te6zQbhJ?=
 =?us-ascii?Q?pT8aCmI54BlMdHvFLKPuzgR1FNj+Uu4Udgcini4wJVvujg0ARieVDX8qqORg?=
 =?us-ascii?Q?HOI26QLz+03PSo6cmX9ZzNhr/CV1ZAq/cSm2MLyaBJXiZcRa90u19Bd5Zic5?=
 =?us-ascii?Q?M6qHM3N+CMX3WczlZcIXeQ+08f0I2Vh63eUJcZy1iXGRySUFlVwNyNRsNaN6?=
 =?us-ascii?Q?VoDb35d15GewBGXH/TCd34XP+QcrpwXndBRcp0vW/DCoLAWcgf8+padopGl+?=
 =?us-ascii?Q?3TPJan8Ne7/gT4dAiFFREc9Jm2XRwrj5yhgbI8N0AAS8JYqwpd13gzh4yrcr?=
 =?us-ascii?Q?rzNeBwSLmIyRkHZND0kMOL+80KlvJViyUdvvfzpymdPKL/qgCVLoLFus7xU/?=
 =?us-ascii?Q?McZ2CrKqhPhv1h+pscpAI9mk5Nb16NG6t9QAKO1rgqby/Y1PVF+YrE3CQmhY?=
 =?us-ascii?Q?oJTWwqgjuicsGrcWqn4PmGorYws5EscDVav6xWeOR3uwwHCbDv+9+kJWfWyR?=
 =?us-ascii?Q?ibhcUOh7RTnaJu1L+uoArTOoWFGbwKgXcbSJYumw6Jsa6KjqdTIl3L+cehyX?=
 =?us-ascii?Q?iCxzR9O4PkuhaxvFBjfPj1ceFgwtNJq0FVITpkrfISKLkIrHq1FNQPtVQ92c?=
 =?us-ascii?Q?V5HRy+wjAmSJj9AFBWqiB8OXkv/Yl+xNDMMwse0Sog+9TYW90v1MsxwRMCS1?=
 =?us-ascii?Q?Bo1U4I6UfHyGKXMgPgc0HFMHW45P5w6GVe5AJs0ymY+QzK2oMMCDRKTneJ6H?=
X-MS-Exchange-AntiSpam-MessageData-1: 6FDeFwi+Q3x1h6+2n6JhY+HFDUe5rGmz29U=
X-Exchange-RoutingPolicyChecked:
	oTtD+fPcGSYXQw0Qa1ncwxHxEPU3MvSgqnqIAHTj8Kzq9mWv+g/VmhInZ0S10nOhYsNB6ENWzMM3bo2mG58bRdatfsp2hbYtmXr1L++JAorY7XU3BDvCban02q9aE6jcBmtB50hSVkJ9Vlo8HBpDVwfrK0OIxPP8LupUprzCkMGno5laFLN8dh19CKKh3+Bp2Upuh4REerncLAepRsJ2pEaqZGeVB51sARYSpGpN7IemSf2VIPhVk6eb/YapvKDnO1avfHXOYgFaUCnA6D6r9pEG+wHbd9xtKi+ARBDeNnx32pCIlr3dOR2a6wJmDHxKYC7YEVUniOcp9dVWL6zj4A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	C3X9GbNWaxAdl17mnbxwx2HQfwQOQ6MPTl3CplnsUrsx1707aooAbXB0iA/jUj3skUjvNUZcU6HfIvbQc4AmxNWl5p1y4Xzy9qbeiFABjiXsrBn76z72NbN0++u7Cb1+IYAWo+d4YafgITGFnpmObYIJdAE8hya+4Z5WgvQg5BKx240SAPxDTt6POL3FV9D0wIeYvdD+iSKPruZu62O5dYKgLZPl7lQYmx+m0FOMZ68Ii9LA5yJY+bYf3BhDl1GqaUcmLSB9DSrCU/zjgUhWyOHfwYpeTan3FCyOmwNOfPEsSvRDuxJYxl3oKOroVQupy+OQrYocRZnTR+IIfdsqETpAGp+5QLAxrbS0dAWek+1G+PTH/OnTWzw0DzzdmWCb7hkPliAeQ88/GfjqgctF9xz6LST6ESMMWiQGyWucU+yFZISWqoHsZjwbWNaejk8pKMp/uW/Uez03fMoDGxEIBCL4uB6Qbei+sTEAPgZq8ONM0+OAQE/rKZYuvTMuWwb+Y3cZbeSwJ6h+HnjNbDie/SJl/vAERfJ5rqUbUS4GKU0lY4eH90/4Y0CgkyA/n6DoA/olbZMWphP4d4oDlpjVEaXWdf2P4hB+Yj/k0aodjXA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e747f9b-5562-460a-147e-08df290e1de5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:41:12.1494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: twj3qwlQvQMSfZA6LeDBnxmoNX5smzeAgR//bEGS0Wl6Qaaky2CA/xftps3A8I9yStefaB7Wcy8+pN6NLVgDU7fcnuXbisi+Z9HL1ePUyQk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB075839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Authority-Analysis: v=2.4 cv=O9SsLx9W c=1 sm=1 tr=0 ts=6acdfcbb b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=-BFCJ2bJgao7vN__fc8A:9 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX0nBkpX4acLhA
 +/tJbRZ6ubZWXQxRAHBCKQoSMofCvJxDrSvSZ/7U6+vQUYaZ7Pz05EkWEMpNgfrao31HQ3Ea6lf
 o6yzmZfko/Jzsd13UmYhdbgy95jMHNlVkA62rZNaWONyg4Lyp4XV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfXyr2TyH3umVHa
 VLHhbwXF3/JXCEdn4F5pItiX1ksPKZP+eDPshG/aD19ZCaMnAptq6W+WWoPbBA2lD2EElZD0jjE
 nx9kAUqHFIWnFgjyY8dFTptITWJBUAWKZVH27VgUnPJFgbPXbwE6ueQ1RSvdtkXRIqwjFawB7a7
 cl9y2h29hg6F0p6ZWHJscCJO2lLZW1SIqtNRn8ZyavRYVRNZunMVIekBWLb4koUIOW5v79/5431
 EQ79UNXohoCNux+3Lm9W4mmQi5xD4KaLrXJ/Lva5xLXkkth2sP85ZtjDblXc4M9of/ueO7Evfx/
 G/5/sEBgFd6xi6jvCZc/pGoaAUo1ths5jWfDrXGLk+Fzju4kU3DEf5C4hR1vUJyNppG0eiwTots
 IzoKxNG+8vAQ9gA/+7z6iVMeX2e2x/D/h/qcfhBd2tS0GpoALn31nJhlOH541dCa8PcVaRQxSEV
 iClnqtQPtZEKOSHZurA==
X-Proofpoint-GUID: hLj9yzI6lHIc0Ey7VNfE55UYvjnh7EPA
X-Proofpoint-ORIG-GUID: hLj9yzI6lHIc0Ey7VNfE55UYvjnh7EPA

From: Dave Chinner <dchinner@redhat.com>

Lock order of xfs_ifree_cluster() is cluster buffer -> try ILOCK
-> IFLUSHING, except for the last inode in the cluster that is
triggering the free. In that case, the lock order is ILOCK ->
cluster buffer -> IFLUSHING.

xfs_iflush_cluster() uses cluster buffer -> try ILOCK -> IFLUSHING,
so this can safely run concurrently with xfs_ifree_cluster().

xfs_inode_item_precommit() uses ILOCK -> cluster buffer, but this
cannot race with xfs_ifree_cluster() so being in a different order
will not trigger a deadlock.

xfs_reclaim_inode() during a filesystem shutdown uses ILOCK ->
IFLUSHING -> cluster buffer via xfs_iflush_shutdown_abort(), and
this deadlocks against xfs_ifree_cluster() like so:

 sysrq: Show Blocked State
 task:kworker/10:37   state:D stack:12560 pid:276182 tgid:276182 ppid:2      flags:0x00004000
 Workqueue: xfs-inodegc/dm-3 xfs_inodegc_worker
 Call Trace:
  <TASK>
  __schedule+0x650/0xb10
  schedule+0x6d/0xf0
  schedule_timeout+0x8b/0x180
  schedule_timeout_uninterruptible+0x1e/0x30
  xfs_ifree+0x326/0x730
  xfs_inactive_ifree+0xcb/0x230
  xfs_inactive+0x2c8/0x380
  xfs_inodegc_worker+0xaa/0x180
  process_scheduled_works+0x1d4/0x400
  worker_thread+0x234/0x2e0
  kthread+0x147/0x170
  ret_from_fork+0x3e/0x50
  ret_from_fork_asm+0x1a/0x30
  </TASK>
 task:fsync-tester    state:D stack:12160 pid:2255943 tgid:2255943 ppid:3988702 flags:0x00004006
 Call Trace:
  <TASK>
  __schedule+0x650/0xb10
  schedule+0x6d/0xf0
  schedule_timeout+0x31/0x180
  __down_common+0xbe/0x1f0
  __down+0x1d/0x30
  down+0x48/0x50
  xfs_buf_lock+0x3d/0xe0
  xfs_iflush_shutdown_abort+0x51/0x1e0
  xfs_icwalk_ag+0x386/0x690
  xfs_reclaim_inodes_nr+0x114/0x160
  xfs_fs_free_cached_objects+0x19/0x20
  super_cache_scan+0x17b/0x1a0
  do_shrink_slab+0x180/0x350
  shrink_slab+0xf8/0x430
  drop_slab+0x97/0xf0
  drop_caches_sysctl_handler+0x59/0xc0
  proc_sys_call_handler+0x189/0x280
  proc_sys_write+0x13/0x20
  vfs_write+0x33d/0x3f0
  ksys_write+0x7c/0xf0
  __x64_sys_write+0x1b/0x30
  x64_sys_call+0x271d/0x2ee0
  do_syscall_64+0x68/0x130
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

We can't change the lock order of xfs_ifree_cluster() - XFS_ISTALE
and XFS_IFLUSHING are serialised through to journal IO completion
by the cluster buffer lock being held.

There's quite a few asserts in the code that check that XFS_ISTALE
does not occur out of sync with buffer locking (e.g. in
xfs_iflush_cluster). There's also a dependency on the inode log item
being removed from the buffer before XFS_IFLUSHING is cleared, also
with asserts that trigger on this.

Further, we don't have a requirement for the inode to be locked when
completing or aborting inode flushing because all the inode state
updates are serialised by holding the cluster buffer lock across the
IO to completion.

We can't check for XFS_IRECLAIM in xfs_ifree_mark_inode_stale() and
skip the inode, because there is no guarantee that the inode will be
reclaimed. Hence it *must* be marked XFS_ISTALE regardless of
whether reclaim is preparing to free that inode. Similarly, we can't
check for IFLUSHING before locking the inode because that would
result in dirty inodes not being marked with ISTALE in the event of
racing with XFS_IRECLAIM.

Hence we have to address this issue from the xfs_reclaim_inode()
side. It is clear that we cannot hold the inode locked here when
calling xfs_iflush_shutdown_abort() because it is the inode->buffer
lock order that causes the deadlock against xfs_ifree_cluster().

Hence we need to drop the ILOCK before aborting the inode in the
shutdown case. Once we've aborted the inode, we can grab the ILOCK
again and then immediately reclaim it as it is now guaranteed to be
clean.

Note that dropping the ILOCK in xfs_reclaim_inode() means that it
can now be locked by xfs_ifree_mark_inode_stale() and seen whilst in
this state. This is safe because we have left the XFS_IFLUSHING flag
on the inode and so xfs_ifree_mark_inode_stale() will simply set
XFS_ISTALE and move to the next inode. An ASSERT check in this path
needs to be tweaked to take into account this new shutdown
interaction.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit 09234a632be42573d9743ac5ff6773622d233ad0)

5.10: Add header.

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_icache.c | 8 ++++++++
 fs/xfs/xfs_inode.c  | 3 ++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index d973eca1a881..f52737051b49 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1040,7 +1040,15 @@ xfs_reclaim_inode(
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
 		xfs_iunpin_wait(ip);
+		/*
+		 * Avoid a ABBA deadlock on the inode cluster buffer vs
+		 * concurrent xfs_ifree_cluster() trying to mark the inode
+		 * stale. We don't need the inode locked to run the flush abort
+		 * code, but the flush abort needs to lock the cluster buffer.
+		 */
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		xfs_iflush_shutdown_abort(ip);
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		goto reclaim;
 	}
 	if (xfs_ipincount(ip))
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5c04c61964ce..a36843bfb6ef 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -33,6 +33,7 @@
 #include "xfs_symlink.h"
 #include "xfs_trans_priv.h"
 #include "xfs_log.h"
+#include "xfs_log_priv.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_reflink.h"
 
@@ -2553,7 +2554,7 @@ xfs_ifree_mark_inode_stale(
 	iip = ip->i_itemp;
 	if (__xfs_iflags_test(ip, XFS_IFLUSHING)) {
 		ASSERT(!list_empty(&iip->ili_item.li_bio_list));
-		ASSERT(iip->ili_last_fields);
+		ASSERT(iip->ili_last_fields || xlog_is_shutdown(mp->m_log));
 		goto out_iunlock;
 	}
 
-- 
2.53.0

