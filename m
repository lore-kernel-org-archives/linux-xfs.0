Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADE11B85F7
	for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2024 21:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725657114; cv=fail; b=pUi4nUaMaExxwnp9OadPab02wps0pf55DOh+hIWSjll2e21RzO3H8O/CJiFndx4VKqCxArUFR09DwytNQBKvfRUTvOtxLC86eXEobPYIVImIqS7vMfKKt6MC8REQqGHRLGFZokGESIp9J9OFgqSgcdG8CANHpKlG9I5hrSTl+v0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725657114; c=relaxed/simple;
	bh=i6A5B2q7FDKcCbiivNehhmApsAyNwsMSFC7r9o4sIsc=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bznib7bth6cOdnB0qqmdJ10J1Ez+uchE5X/8H/lsWix4Gdv3bg5wqg6zpb0hIOw2gxMOCbBCAl6p4cj7vTVQZZEE2D6ZvIGWTFdKz7FGdPxpfvuRSO5xFWu8TtbuMz0Gl45VWpeVutOF6haj12BJW/Jja0NW+JVDz+eZvqZmMU0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=i7EQT2Jj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bqrZ02X1; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i7EQT2Jj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bqrZ02X1"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 486KXiAA024739
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:11:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=igsJLVh+Hinv+NGDOSYNfaKzQNYzdyLwwGAJbHHPu94=; b=
	i7EQT2JjKMjuMyXikfSBIp0Lo0zwd7sZKajBED7bINAaiv4envJjo2aPSDYvslHf
	PTXzoO6c2AhcmIAuT4FJEkdovjF36dhx3tsSiHe5vlHU7oITyqErOEOp0kOtxLAo
	Axpkq1hFtWiLPdPfIDoKxkVfbWLUDdOJHKgSTwwe4uMQu4MtR9LPmZZEj9D6rxyT
	VwS6jN3g3H3iXhYOW5tWj831FreRksiYqXt4pKjltjfzTewPP3TpJVh7oMdoUUX/
	KIdGVkNkVStjtJsHdD/pXNF7w9PyteeX6baS5hfh9tTV6ooLUD/mL5Gi/jXVpyRh
	smsckklp+Rl+KHEFr7VjpA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41fhwkak2k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:11:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 486KC9Pp006639
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:11:50 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41fhydehu9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:11:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=deNYMwlpR4jb+Q51i1F0fleOjsfjOxjmjY7HxpKPvivwpsCc3wYjMx6m12vK9IG7ZMPVEDKtzTXwE8DAjQVtmIPgdqckz54D/o473H0TAAesYVBDn+j2CAeJmQwiH/oHZRFPsgU4D0m35LOSSSgu4ffgqpvh/fVw6IUU+WyUHNEVhbPFKpTjvKlHcV2+eM7NjNy2+RW2mSJAWStC4yweXMU6/vdgbRhcJfmi6IGR/2Bq7l8iPjfvb1RdOZFsC2AnoC5wSQiMEyLcL9LG5B03PNbcsouUJIy1kWHnGmbIK9pcsznypnyHfxUAoFX8yC3pNyPJCte672+fS2lJXqADpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=igsJLVh+Hinv+NGDOSYNfaKzQNYzdyLwwGAJbHHPu94=;
 b=uwzlAuj3g1iuXYO0wYJqczCn4GJgDy1ZmM48pphis5yfAqXjAYOKoEnC65Is6qTmSIr9Xg9jK6MZNMJApuvlRu8vBqhL9QZiOM7wryeBG6y1vU7l5wQ3IxLhomjaK+x1Y1ksP9aLLPCMHe/2fGEU/IGSNTFTj3WVY9Irbz9W9XkVMzDqnE0BdX7HoWbVKRNVBxZNbdMH9L0FZAi0SCYoNqtJapkECfJ3Op2TfQUsXvnHds6KGawKiAx1Kwqx+zHskLDeQRwEbD4cThNZtVroHwMiimdMQuQkZoo6sjUW0tOky+WyUK1aMkxCh479z951Y3D3LebFnIGLniJ9e9lkWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=igsJLVh+Hinv+NGDOSYNfaKzQNYzdyLwwGAJbHHPu94=;
 b=bqrZ02X1Sa9yIgcvtoQ/vVutYSlCtIvpOBc5eBkfGlZO7Hnu29ioRlFP/8ok3GxlO9aIM+Rc5gttd2FTJ52BWX4bC/mxnjzRQLfNI/tg7z720LRxHo7tIBC9ELSntQKrhRAGlbeXEidwVAfYiCg/6wP6DIlerooNkGMDnbhNYrI=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB6765.namprd10.prod.outlook.com (2603:10b6:8:10f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.9; Fri, 6 Sep
 2024 21:11:47 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.7939.010; Fri, 6 Sep 2024
 21:11:47 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 02/22] xfs: fix xfs_bmap_add_extent_delay_real for partial conversions
Date: Fri,  6 Sep 2024 14:11:16 -0700
Message-Id: <20240906211136.70391-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240906211136.70391-1-catherine.hoang@oracle.com>
References: <20240906211136.70391-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0143.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::28) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB6765:EE_
X-MS-Office365-Filtering-Correlation-Id: a92107da-5f38-4608-54d9-08dcceb884a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eR3C744YdRF0J60Iour2gtqkQTdFd6g2Yjc5AYF93Z++7Dnv5Of35/+uDyvf?=
 =?us-ascii?Q?wHckvzM7sMN1VAvKMEnJ/gkT0vQbrmXCIvI7Q/i3QLNNTdtjCBXFWOvjogoe?=
 =?us-ascii?Q?nf6XmU7apeQ1mOc5VsX7afvDfVEBLTXZqzfOpuGkf3N6Q/Da7ssFTwGWHZCd?=
 =?us-ascii?Q?piwIACpdtMakD26bc+1kc4rPlxtJT58XCUVY3FVArZidBacpRX2ssfM3aa3n?=
 =?us-ascii?Q?g8MhOjRSMZBBqoxgTxC6Mrrw5EkFZv0hLqwrqbhXvDduEbCh+KCSysQFTxI1?=
 =?us-ascii?Q?QVug/5hyxIfQh9ukBjTTqKt64qrUfUmASbT18nl8vu4MzgxEo25Fwzltdltj?=
 =?us-ascii?Q?vmCYYb+Qiw/HF2vPAOkmMXl4hVcGtNltDYr7BRZs+DJ7cnWqzcdujgr0OjKO?=
 =?us-ascii?Q?4JFC3F9mccz/Z1A0JXbG27lIGNfKvGDzB4ZZUo5StFD89Arqu4rWkg6NeOy1?=
 =?us-ascii?Q?233uNf56OWrax+HNErktdmEjCMMalLRKRZgb34kz069mI2dZcty5i3hNYrAe?=
 =?us-ascii?Q?stc5Mv2Hz4w0sVxIHKDx9/lNquk7YdoTCyuNlh40p63gmVZM0QThW29vWEd9?=
 =?us-ascii?Q?OHpoCz/lRq6zVqgGk/HwKx1FOyKe4uX7a0RLLwPObEQjWtLjaCH0/PZtj9PH?=
 =?us-ascii?Q?VM6QACZmCavw7GvAx3Xn393Gf3kEUzm7Mgla6TUakTsUOLhDBpEemXpqQ6yz?=
 =?us-ascii?Q?zut0JTtN6zkUdCViWhThw/PLl/f6P5dMKBAMB2k8DzvS65hNgGbOtYMgynit?=
 =?us-ascii?Q?pbC2tTdqKN6Yg9orbpg1/VPcT35ZRLmoVxlCXfllRUkzI8JowMp0FGFwpEAf?=
 =?us-ascii?Q?rUmgzF3tE3ukvuxgsfcPs79OUwwvgASMsMRcWzzJ7fcMsg4zc0y5+nF0v6yG?=
 =?us-ascii?Q?fhTeYsJj4nYJWMT+h8NOnplGJysvp7YkD1q3DnL1tFfSqdocACOlQFqcYz5o?=
 =?us-ascii?Q?5F/Ob03A3FRpoQCetFi8VkMKtnCEep+sCIEHgzm2XQAhfghuxDw5X6D3Mq0f?=
 =?us-ascii?Q?EbsT8y3XLLHiByRAPs9cUSB9CpXXnQI9/hzO4WDv1jtty1Z2uI1z5vE3WC6b?=
 =?us-ascii?Q?w3NXr/N7jmt7rvToW0AQ87VMnDL1oxDnmJVSzvia1HUhoqd/ztFvEfwc5rRs?=
 =?us-ascii?Q?P+MtED1dbPA0MwZQrMJOglE6aj2lNKk7g65QuIs6CM+Q/Dvn0dJ6YkrE23Ow?=
 =?us-ascii?Q?n+wDCda+i3cM22Of3HiavNR6x45nX2ljjYYnWSZVgM/LUSysEXPahRz/Dbhh?=
 =?us-ascii?Q?GYqJNtvjI7W0EynxBgqaIEA9s5S5XbOcJ9KJr5YBsnlrxgTJwu9FmSKi63Ke?=
 =?us-ascii?Q?wT7HMV/VsleFWqVAZl/1qbVJ/QY+ZoOdrDpbL4xcvp6f7g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D0xWYkqtqWElZoGwCjApoVb3qyvGv81m5nd1GcJFHk/VMF7bVN8XjoNPZX1V?=
 =?us-ascii?Q?nFCOiwJjKx7u7MKuLLQVUeVkLnzSymisfn6urfX6nT2QKO1Ttr57FjOKRg71?=
 =?us-ascii?Q?wI7ySoHVGsud1cHFoqfChn/bmjr45dlAJSjGmd20cT7JgreMsMv/jN6xfj18?=
 =?us-ascii?Q?bJg77JgZ1YyRe0x+r6XNhxWjEJifIfKJQrKHi9GQUVenXIlRVK1/JLZGI9Of?=
 =?us-ascii?Q?MeLzQWbgpx9rPfIOsdZqBetS2w/zyxQSiEjsmry7UwojAhr6YXeAQSwu75w2?=
 =?us-ascii?Q?XGeKZjJnZPN0b1toeH4F96qP75ab5QH5Kbi8hAG4SJRrwz4mTAkLs61BJW4o?=
 =?us-ascii?Q?QwcuouY43w5tLV40u7BOI3tE79HwPcSWWvz4Y1pjCQrme2M95+J+CsH6ZHjA?=
 =?us-ascii?Q?HEfqvpkDkYWyY3d2UkDqr0o4nhZVsGmR7u3FYLbg1ygBPNYsXqiosX7TyLu9?=
 =?us-ascii?Q?00UvhpWsrJTaRupg1Ods5eUXgi8fEIdA/Rrqg5n3e7xry5f5fcPidCdh/USn?=
 =?us-ascii?Q?Eae69zG1KhtqFP09LsXWoreGW83xIBLoDuelG52O5MvLGXNpnQCWU63ujMp2?=
 =?us-ascii?Q?Bec/QfDG+MyO4XhT1VZQlkiqDX5X4x7kw68KBA291Fgv7BmjWtKEak5JIHG0?=
 =?us-ascii?Q?5SEYJOG3pM6eaid0Pb7YUjK8w+e3DFoH8sNA169B5HgHFCE7YyN1RbtYYFyh?=
 =?us-ascii?Q?Q5r7zDDddtA+uN3DhZLSCGIUOZFce2BCydiP06fcO0IdYMVeve5Ca97ciaJv?=
 =?us-ascii?Q?dZfvzgknV4lAxfW1CFnPjth0xBU1klUMNbrJGvmoCWUcUa3B91IoWLNWPWb1?=
 =?us-ascii?Q?Q3mOHLyH6atQeYYFytLpCjIqhLy36c52UBLpkitHEb8KQYbIsGYgux4zp86r?=
 =?us-ascii?Q?NEYjcdGEW1V6XZqjcNQyg6pl4Ur2pFV7LoUqWmyPp5uhiq4Tcr4SAJNEhzqB?=
 =?us-ascii?Q?lwF8+iXwME9FbQYP3+MdmQOPECk6I0FgvS+8lSp8Gt11chXOM7VSD8R9JULV?=
 =?us-ascii?Q?V/2c7JObC/N9KDJI1ne1oZShS7cXO1FOkWj6kDj8VVIVVM9jPy+jfq8zoewv?=
 =?us-ascii?Q?jEYE7Kw0llrS8uyZYuj2Utfn7QiM054Z+Yi8N2ZH2VNvisq6WeS6qBvsKKMv?=
 =?us-ascii?Q?jpKhuIqsbm7gUKCK3NING7tAEV8wtzd74G58/9rHd1dcpvSP7fnjZcV2SZcC?=
 =?us-ascii?Q?fM83G9GboIXvhW/becKBe7eWWwE/fbDJ3wu06AZf3bEYe1rHkmIyca36Z2yp?=
 =?us-ascii?Q?rklnCMq/trNshTdq67QXYlbBRJdbc5Yzrn751P8ufEDOOuajYX9lFCP7hC46?=
 =?us-ascii?Q?+SdK2HL6D60s2fuXfeKMlTx6BD9jTc0FRwPzYwtc05pzN8i/S8wasvOoOv9Z?=
 =?us-ascii?Q?AKvaXF7Eb7RAcLjco5yx6GAH0SeGN+BioySUt+1rKw7V8z3PWU14Wcfj5vk7?=
 =?us-ascii?Q?cJYdTfiU8l/dqngTzVFoT6nkzf16Qs50Qt0Q3up4ZhQ9XjJ0hthEt01kT/bB?=
 =?us-ascii?Q?H6o6vIFTnwLEhAqoh/92gdoxFHs5hS2kkQ8QJ4eQpQyeHxmHNWzZk2eKfRWj?=
 =?us-ascii?Q?vMIQOuIMhSX79ECoLLBqeQIEx5lX0opXEzYegzPQ9A6+QmieXT2QB5vsgjQX?=
 =?us-ascii?Q?Jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qu2/kpXelAGlaefLaj9N/lokvSCssb2hifIq5ldCabssDAfATNcCPImDr5P9GEunA8sMFE6eUsTHlruoxs0HErvg1gSaAGbj6pQHVNPJn7Q9Pqd1WqqwwRfqo6gHSyElaJETFHKLnB/zQmRFFBn8UtlHIE25jejcu3SCZxHiTQQX+uSiFVdGv0ybxJc1tZVGBONH26VZdZLRobR1EbTPIT2jikccBf70N6fe/45wh+2WaxwYNWzMlK0768U/jrbYM3B3VyzWYGrZgF2zzDkcRVxrJhxUG9/reMS+M0yrWstwj8iptDgJlzrCgaStIhGWuc9JHM5FMOUhzUfslS/Bqw85nTLoutE63KnetxKylAvH3uFHbeR1JFQ92t7JEqLb76j15whjeMHwr+RVO142pNFJik1iqJxjDsjpyrIjZneIfpwo/LuKpiOjfQA1U2CThshyGMdDye0phkYjvel5xCHlfy7mXkwAzJXCpTjdnvRwiqiXxnPx1P+YdNMSjC5dxGO9+31oufL5d2ZkCwjW6CB8QvdFvsm2gq+aZK/e4xTOL5ek7AH5g8kUToN4rqkT7NMLlRi6fffxiAqNOjBrw04J6heqLjBIVIJ2/nc0ots=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a92107da-5f38-4608-54d9-08dcceb884a0
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 21:11:47.5604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q+33uW/sRaMI048voUH/ZgNxtL6x7Hxo7HAXQQUkwG8SHd5f/OP0eM9kSq6ccY6MbgOicNViV/dM3t+Tp1f5a1vGrP+b456R9/RLwiaN23k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6765
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_06,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409060157
X-Proofpoint-GUID: USZSOy-HQ9l1g97vchfPxN5sHyTry4Iv
X-Proofpoint-ORIG-GUID: USZSOy-HQ9l1g97vchfPxN5sHyTry4Iv

From: Christoph Hellwig <hch@lst.de>

commit d69bee6a35d3c5e4873b9e164dd1a9711351a97c upstream.

[backport: resolve conflict due to xfs_mod_freecounter refactor]

xfs_bmap_add_extent_delay_real takes parts or all of a delalloc extent
and converts them to a real extent.  It is written to deal with any
potential overlap of the to be converted range with the delalloc extent,
but it turns out that currently only converting the entire extents, or a
part starting at the beginning is actually exercised, as the only caller
always tries to convert the entire delalloc extent, and either succeeds
or at least progresses partially from the start.

If it only converts a tiny part of a delalloc extent, the indirect block
calculation for the new delalloc extent (da_new) might be equivalent to that
of the existing delalloc extent (da_old).  If this extent conversion now
requires allocating an indirect block that gets accounted into da_new,
leading to the assert that da_new must be smaller or equal to da_new
unless we split the extent to trigger.

Except for the assert that case is actually handled by just trying to
allocate more space, as that already handled for the split case (which
currently can't be reached at all), so just reusing it should be fine.
Except that without dipping into the reserved block pool that would make
it a bit too easy to trigger a fs shutdown due to ENOSPC.  So in addition
to adjusting the assert, also dip into the reserved block pool.

Note that I could only reproduce the assert with a change to only convert
the actually asked range instead of the full delalloc extent from
xfs_bmapi_write.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 97f575e21f86..0ac533a18065 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1549,6 +1549,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG:
@@ -1578,6 +1579,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
@@ -1611,6 +1613,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
@@ -1643,6 +1646,7 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			}
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG:
@@ -1680,6 +1684,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING:
@@ -1767,6 +1772,7 @@ xfs_bmap_add_extent_delay_real(
 		xfs_iext_update_extent(bma->ip, state, &bma->icur, &PREV);
 		xfs_iext_next(ifp, &bma->icur);
 		xfs_iext_update_extent(bma->ip, state, &bma->icur, &RIGHT);
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_RIGHT_FILLING:
@@ -1814,6 +1820,7 @@ xfs_bmap_add_extent_delay_real(
 		PREV.br_blockcount = temp;
 		xfs_iext_insert(bma->ip, &bma->icur, &PREV, state);
 		xfs_iext_next(ifp, &bma->icur);
+		ASSERT(da_new <= da_old);
 		break;
 
 	case 0:
@@ -1934,11 +1941,9 @@ xfs_bmap_add_extent_delay_real(
 	}
 
 	/* adjust for changes in reserved delayed indirect blocks */
-	if (da_new != da_old) {
-		ASSERT(state == 0 || da_new < da_old);
+	if (da_new != da_old)
 		error = xfs_mod_fdblocks(mp, (int64_t)(da_old - da_new),
 				false);
-	}
 
 	xfs_bmap_check_leaf_extents(bma->cur, bma->ip, whichfork);
 done:
-- 
2.39.3

