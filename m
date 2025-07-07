Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D858B29B8D9;
	Mon,  7 Jul 2025 13:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751893941; cv=fail; b=gjRYNoPSlUVBZpgpF0xgueo3PPwTqJqzu8zyej4bl6TtclxeA64nNN8Y+OxGHr2gvpky7hThbHTT3kGLqx02az2cBXcCZllvXQlmEtnllXoLyCfvlStolou/VkDfjqCLZixZ0oguHQ7F9jOGh4/L9Krp0tbEfz9VKwbdRNUZcgQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751893941; c=relaxed/simple;
	bh=o97kUiDC9C/YS3dTG6kJSHugr8Zif2dEG9TatAPN0e8=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=o4F4mFLWPictIkfisYQ+EmJS78rHz8PbV9k92ZmYDWbdyiIjznmqP5zLHB7fo4/h8Y1hthbhLtZpTFpi0C7gWdhO/RyxRgDPCNjh2LcJsNL4sNo0Lh4X9TVuqE5uhNU9gCAE1nd3qFXuvTfChkCZ/4gDbLaBalxsDWjprpqQWOA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rtZ9T2vk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qgjvQPXl; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rtZ9T2vk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qgjvQPXl"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 567D2P7p013227;
	Mon, 7 Jul 2025 13:11:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=t1+L85fC5tSg8mDo
	jiSMxri9U0KeCRbUlW7fQ9XbW98=; b=rtZ9T2vkPHeaD1ukPEhMvRvUph2dCl55
	TC/5ALpMMUbEGFKeFnaptmcEtx3JrDGXErv9SNGUEb9krG4jlfDUXW12Pdu8NhlP
	0+EfL1cjfo4Ji/gfH5u1wGIrHmjmMqOO89K5NWJYeyVk21Z+6duYq7tyJadks6uJ
	iiz4wTvI8Z+P8/0xbMrKzogs7SFZqacDfyViFR0RAB3klTXva4auamJrhY6wSOqN
	9UmAAoDttdxBRa0d1ZA0+dIC+xvsMkoUEHtTaH7YMY5oJeRoe2O2NmkTAS8MfIaX
	Z7t2m145AsFygz4HfgZjRSkNDPygUV7HZSxMCmQD8rLUPOKbnI+CyA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47res000p2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Jul 2025 13:11:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 567DAERb024335;
	Mon, 7 Jul 2025 13:11:53 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptg8g3sn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Jul 2025 13:11:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HbMx/gVrDY47JdZscaJO7skIc1+9bpD5XTnI/L6xMG0ckB5cT7PEGh0djkA8pcswyYQ+3t4+BzcwEGtWQdQpqEWFXBk8RILy57yZ0PUqqkxfQP21e6dyfVvV3wfKQH6uN8eDRtD0QqNGUJWBIz/gOW9CJRtmhEXklkOlzCqAssLg4PzzK1RLOxHomam2TzInPcaW6mkZn0yLlNoyNh9lm0eUXW+PQ/4M9p+bKTfFKgyJ5i0ZnQxE+OmvlBPQnwG3kKbJALsPetbn5Adp4lOcR7PF5/u64a36hZUnxUjKKL54/4LM2ksXQbgkeNFQVi0AysbAz7nPhw1VnJl53wR7jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t1+L85fC5tSg8mDojiSMxri9U0KeCRbUlW7fQ9XbW98=;
 b=iwI2EPgBW7JYfHyneWWK6TvIF7gHZET3+Gyf99v75Q/0sMy6rvwiNOLeqTAdyqp6rqUkvHd6Z4yDqvsejD2fGH/49JmK7ZtBfeoY8RlJmYmez4DfPZZuK7i6YUAh9JV0EqoceAU56AlkZQLPG8UqQW/6q8Di4qde1W1Y/2G9QUuNpQlAyWFiWTuBtDHCvusCw75WCAcUm1Yx3cC577IDv7ZWvkxl6nQwxP2syJKEQOj+qBoL09+NCZ5hHZSVYQXd3+m/qca1egkWxCNxdLnrV0e4ybl8zGKgrKzYMPEU9lKFIY+JEtmmvzPaxt7GE0wzZ5kRety6sGpNcIGyx4d+cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t1+L85fC5tSg8mDojiSMxri9U0KeCRbUlW7fQ9XbW98=;
 b=qgjvQPXlrK6LQ85GuQrou1b8bGadPnoFJpllQzH4nOH/xPRlDkp3FPzSFAjA8eQz5j1rhzWoX6RUa6om7g2ewOkidFW0yOxE2oWDAMMXzdTJrFXAuSv0krcr+oO2HVedXVagQ1tYZhQ9TWnybD8n/ibk0jT3dQDQPzCh8WU9eM0=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by LV8PR10MB7776.namprd10.prod.outlook.com (2603:10b6:408:1e7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Mon, 7 Jul
 2025 13:11:48 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8901.024; Mon, 7 Jul 2025
 13:11:47 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk,
        cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 0/6] block/md/dm: set chunk_sectors from stacked dev stripe size
Date: Mon,  7 Jul 2025 13:11:29 +0000
Message-ID: <20250707131135.1572830-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::29) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|LV8PR10MB7776:EE_
X-MS-Office365-Filtering-Correlation-Id: 961b2e81-10c1-471f-858c-08ddbd57d3d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4OrH2/f8weLoidD5OG7F9vVUnrewvaz23jPfbEnPS93YzMovD8a2FVDMBZl0?=
 =?us-ascii?Q?WVKe5jhvVqsX3yoNtSt/qJimjLt4/V7jNAp+uLGa1LqcoemgDWzafsGA5YTQ?=
 =?us-ascii?Q?AdTSErq05ka+OSapaCFGJAtl/TR0CsOcKmBsN1W2tEL4fgRGsW6RhBWJfVkS?=
 =?us-ascii?Q?QpNEmd/ScKJDOMamYAfCN+fdt2U3q1gDO7LGRnlJlk1UBEmB7rjSLURL3CXg?=
 =?us-ascii?Q?lVL2ljJrx1LV/w8Gz7a13D9C9LaW/9xDMIfwpAhNIFLn7HU0jr/fGftcT8aa?=
 =?us-ascii?Q?8/QKslti6TyAqaQT4DKSAadxz7nnh3WBzKOdtbA7/8MqJs+w2SSZiM7/WuYv?=
 =?us-ascii?Q?AWeS7zqqB2T+/C1ACcy+k8depzim3dqG+JSPvae6ea0MAT70xQhlrAzgOqXH?=
 =?us-ascii?Q?gjXT/NVy1aF+zaRuoVdNbg7aEIGhC68yKpfpOV0hDNCwD3Itu8oQStxMH+94?=
 =?us-ascii?Q?kC/i7pFpzRNwBqPqqwvTbosZMZGDgtdP/mmGY+ewQ9Rwx07mO/boDCaRFEjm?=
 =?us-ascii?Q?80dk/M6aUHTz4uJLx27itRNYChtj2TR0SCtD/zxPjNaw0l9ZWoI71rgmGHCo?=
 =?us-ascii?Q?rPuOICA+d8cuZaw3fpy3k703167y+cQPODQSrykCW5c27dFsutoLNfG/2jHZ?=
 =?us-ascii?Q?mtlQyOwNUCw6dEqeFT15jrXR+N1fxJYFhJpv5fV0lk1AnV+ut/7fOBBDHgQ4?=
 =?us-ascii?Q?bQzrlhTbA+VwQ9HaQVUCPRCJ4jvxWzf08sLkNRBU380BvpDJfkV+X50L/aQo?=
 =?us-ascii?Q?gYa7bZ7RRMgPLuT67UzO6Z8oiggshtuP0jcPtAsA09WWz219dE/EK/FCjTLL?=
 =?us-ascii?Q?V6lhwBdGYhLijLnQZvspjOdk848MZws2EyAL8uDvVaKLTAQnd6Yz3CQ+Tzwx?=
 =?us-ascii?Q?XtmFQ2NWz8qF1c/RCoXOcxbSuGB4B1hg84UxDyfEtvye68FY+E4n1dQMqEds?=
 =?us-ascii?Q?Kq0vptatpSXhGX/MY2z9WrmkWGj6GRIrpgqczlkR4gM/wBmmLfNZfvjWvWuE?=
 =?us-ascii?Q?qUdHQ2q44H7Uafm9usTaLsXlWTQP96LhSO5/wpkbIfF9retjGk50SkEUNkCy?=
 =?us-ascii?Q?tEuiLqpN9qv6zUQoyNGCpWLMUj68tPBzSstCKCWFp+8Rla4OaAKdsik7MOIc?=
 =?us-ascii?Q?Z63w3DFUJgP7vHZCmpPq/jK2VJH7WLxeH/klKCkIkrQvINvUnzqkqCtiAlXy?=
 =?us-ascii?Q?+tqgtmsqivSfun8TBSdCtv5rcxZtW20WCvdwQNDIhd8hEEoGRydbitaJkVZZ?=
 =?us-ascii?Q?n4U2oUdHgFKNTSrFYnFaIy+J9J7QL8jBHmVovsii3pmu8YcY/PE24q28V5Ds?=
 =?us-ascii?Q?pVE4dhHj3ohK0Mv9rjUXNsrs0//KLDcpiAkSpn9qev3MQSX0qfRcsxQC6nTA?=
 =?us-ascii?Q?nu7AalOIIFfbAivUSiVci0ALWAbn?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tfCq4lcB9Zwj3prDUuCQCsoATihL9HskfYUaLrYVeXKe9Ro9WXYqgEiAx0xn?=
 =?us-ascii?Q?1QhJZFKrfa7txNjxqtWa42Tk11vhf81Dt++Ohb2BMFhUr4T6xwJMO11EiVEC?=
 =?us-ascii?Q?qYkJD4yg+0jI7HrQ9QOzkNJn0V3+HxicoSt5g3qZ40XtdMa9py3Pfe98OvXB?=
 =?us-ascii?Q?FogthHm95tYr5GVeg8XDYlmpW2J1HesQpLRyrluvNusKfglZIqMmCcJCi+c7?=
 =?us-ascii?Q?ESz47LG+tIjRkA5mzdKEuS6m5htQA3lT549PmMtX0YjePElyu8yXjqdo3dtQ?=
 =?us-ascii?Q?djVNd+kVRqN1aIBv7aaFsIm1ixDnpJpE10LZy5qz907s8ORm/gva3YD5OQen?=
 =?us-ascii?Q?d77Fyk85eL0GyseTw7HDlKUeLCAUvUVtLin7jlqyN/5B/BoPePOVMBhdh0k5?=
 =?us-ascii?Q?JFepaLb1TUtyXexr+8Hz7xWrklX+nbphJ36ayRH9fi6OSuh40qzNXnlRUqzP?=
 =?us-ascii?Q?1M1C+/ZvMLE1xIjumcW5ejr3qbbAk6oWaUyfOzh52cadp0URh6T3UopUoaOl?=
 =?us-ascii?Q?qX6FaZiyMErm86s/p+V0UZmx3vLRnUMcZaKqzGAAO4TrvuH4EAeDE+mfDsGP?=
 =?us-ascii?Q?z6C3a67z3SjwG4csbcruAsJRgNBet4A26uuvmKBVPLo3ZMCui9gOKpZmnU0n?=
 =?us-ascii?Q?cT7k6lWEuGzFm7K5Bkvz44Sx3NGsuApmBglK6wnbdUk4YCv5hpDaF6dOhsN+?=
 =?us-ascii?Q?oSgPrj9foEbN9q+NO8qQ7GHsc7QPyAqF4ubv+Y38QFCUiK3SmU3ailoAfDCg?=
 =?us-ascii?Q?0ZIOkPnG/M2ClwAX2Ndhjkd+a5RlvG4/0EevCFvsi9mSeGu0nU8ddbmhA/Z+?=
 =?us-ascii?Q?adIz+aphNRaKwpXhgfhnH+Io6O6AdsZsUrn11heJE4sAnwnXzWv4eFJiDyv7?=
 =?us-ascii?Q?bbCIXIzt4laalNkayWge38LBjhI/g8xuIp9bSHL0QFbQcnyUc+GqNN3lC46w?=
 =?us-ascii?Q?RyEorl9x3yQtyqwvayEhorgk4v2mPEzez1fumy4n7bfcXD8+yM8WlBQac18E?=
 =?us-ascii?Q?bH+84iW+UHDVzPqD7PfVmGrkZHL35KUEX193nDCJehLm0tk/z0akOGDsy6oo?=
 =?us-ascii?Q?OM/ENLYN9bYP4FicOPqLGrt1I5XmmqyDyFzv5hrPmwkGRcgoRPrNwAMSkC3z?=
 =?us-ascii?Q?Uzp9G2JvpdTujPjmBT9iMJaVSc0rre0T6PIeHeGNj2mawcGUeNOgQF31hm6s?=
 =?us-ascii?Q?qrK2MzXfN0XYAEbYHbt586ikhzG1TWVfepojvubU9UIzDa4KYp03NVV9TiE0?=
 =?us-ascii?Q?3N5SMBlk8JemMZLlGb4Orbf76oRsy+2Md5ULPmVfD9y5e9aAj6MkMw9/qgFL?=
 =?us-ascii?Q?UtHIyPgd+2uIbhgAGBdegXYM0ZVW2cIQbyFRAwhufaN1KS2AwGjQgGd2jhxh?=
 =?us-ascii?Q?5pw4K1mhwca0fjC24roa2PN+omMgBZfiNs506Fklzq+MflJBrudvyBNN0PWP?=
 =?us-ascii?Q?dYBaVsVNFDFgMg+g+ccHnx61u/CJGGDyp1nTcIgFAkGYYJxOTt3Ab4DI6CLQ?=
 =?us-ascii?Q?/CDksw+N0bJ+X96WknffR0PKXgJUEdZU3I5SbpCfhq9Uen+q/A7CpyLkJFy0?=
 =?us-ascii?Q?icU9O8CBAs5r9q1pgLjmS1fA6lrKx5j8S94g8raBJFoZmS4gcRZNvJ3xf7q1?=
 =?us-ascii?Q?0g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wyhtkb/kr0udN8kBAF+9EErHcX94Q7+l/VGkDeuJATP1inORDrstKMNwLTPhdw9RtLiroORYxC207XBZyD1mXr2S3D6DZvahRV402pPpbBbKwcxiqwEuB+vDzn4gIpVC8w3vXysB+eOsyQFqPIy7bvlZdc5SlxCB6zMfh8tgCX8iaZAPcyBrWUC+qb75lIiBT5P6f7JVak9ng+wH/q4nBTgNdy2fDK/FOqANktF75BRDm5I/kIRLapwk/1mIKikji8HHKsxmMQU3FsgFvyfc1dkIHJ6v4u7YvqCXI+HM3v7XQMXXLMIlqfrRcL8KWSr+I+bjSLwRF2VgU3inqMMf642Ok1p/5GJ5RNCA6ICoMhra8r5Qmz5gyZsTLI8C8Fg1IfhE9ahea5oQTv6mcrC+WmP59AqdC6bqRmnSaqUhDbDM5+iAZgFgTYTz3pDVfo5IoHtuaQ7p81q8IebCZwrC8aelQ+vhbfaS+Bh4FVUwHoUF41QR/PvS/yIrH4dBuHD55XNAeP8L4ooUPlCH+DxeTKKpR25y9byakY5c/10sppIfQ3bhqf7dowaUSp4gFXddVypUAU6j+jtJZqNMCdMBGTDRJdY8d+Z9M+1FiwkCbfI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 961b2e81-10c1-471f-858c-08ddbd57d3d6
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2025 13:11:47.2014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bC5fZlbLkyBFB/USezKZlUjzaKeSsxE5akQiaRNnJnoNkDdyviToHXmKcVoeVxOjG10Juup7IzveFq6LcbyfRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7776
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-07_03,2025-07-07_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507070077
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA3MDA3NyBTYWx0ZWRfXyUFmFga3o3MG ZEiKWSTJwWJjev9ZO89SQBF9KV9OCAOxLs+Qt6uIAku3ixgPT67JppmBbqOm9OjCViHAVo0mnH9 s3s7vQArTP4FjYgsoOXmTefmEVEb9Yyn1EAZqQNjQAXKgZuoE7x589WGT9EP6Nrt8jNrWJz3de5
 TacVrF3UU9ZWeS+3DKxGFZ9aOGH/lpO1xa2nuf8TanJ5FhzE6Me4sYngQcfInSbSehVQda4+Ezy 1iqUdG90BF9Jnef6sa3buNxwbRhzdWGWN7iiS7jzllwoLrJ0LZme4uz6glETHyvGi2BXO4sIEU2 Omu6/s3uh0v2XkJp2wKvufa2n3ae/mguwwQvVZfxsswu2OGGvjBjd3xNAuAHsIWcMaS867hrGb7
 cSC6vn85RHpHevi7Kj/0jh8sjDnm6K5jQFWjaQzuOgFcnUO2DoOqca6Oo4P+1eUGlcP4OYRO
X-Proofpoint-GUID: HDAsolfmIlEPN81aHB2N18mY0fSCy_Pt
X-Proofpoint-ORIG-GUID: HDAsolfmIlEPN81aHB2N18mY0fSCy_Pt
X-Authority-Analysis: v=2.4 cv=caXSrmDM c=1 sm=1 tr=0 ts=686bc79a b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=tU8JB17zQ7Q4qiDxM58A:9

This value in io_min is used to configure any atomic write limit for the
stacked device. The idea is that the atomic write unit max is a
power-of-2 factor of the stripe size, and the stripe size is available
in io_min.

Using io_min causes issues, as:
a. it may be mutated
b. the check for io_min being set for determining if we are dealing with
a striped device is hard to get right, as reported in [0].

This series now sets chunk_sectors limit to share stripe size.

[0] https://lore.kernel.org/linux-block/888f3b1d-7817-4007-b3b3-1a2ea04df771@linux.ibm.com/T/#mecca17129f72811137d3c2f1e477634e77f06781

Based on 73d9cb37478f (block/for-6.17/block) block: remove pktcdvd driver

This series fixes issues for v6.16, but it's prob better to have this in
v6.17 at this stage.

Differences to v3:
- relocate max_pow_of_two_factor() to common header and rework (Mikulas)
- cater for overflow from chunk sectors (Mikulas)

Differences to v2:
- Add RB tags (thanks!)

Differences to RFC:
- sanitize chunk_sectors for atomic write limits
- set chunk_sectors in stripe_io_hints()

John Garry (6):
  ilog2: add max_pow_of_two_factor()
  block: sanitize chunk_sectors for atomic write limits
  md/raid0: set chunk_sectors limit
  md/raid10: set chunk_sectors limit
  dm-stripe: limit chunk_sectors to the stripe size
  block: use chunk_sectors when evaluating stacked atomic write limits

 block/blk-settings.c   | 66 +++++++++++++++++++++++++++---------------
 drivers/md/dm-stripe.c |  1 +
 drivers/md/raid0.c     |  1 +
 drivers/md/raid10.c    |  1 +
 fs/xfs/xfs_mount.c     |  5 ----
 include/linux/log2.h   | 14 +++++++++
 6 files changed, 60 insertions(+), 28 deletions(-)

-- 
2.43.5

