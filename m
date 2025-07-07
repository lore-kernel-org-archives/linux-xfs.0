Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D89278E47;
	Mon,  7 Jul 2025 13:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751894065; cv=fail; b=X9dbO/fYYrzugwdwrrEXZbosdKsqJMc1HYi/y8Vg+mGQiFCAewmKSs+Kwcfi+qePJTuqeWJiTMNipqOHTreUI+FRaj3/HdOwzgub0k3luFCe07Oatim7koEjoBl7YrjRWCBnI5Ew9IHbc0a31/Xx/zOheAL84DpMjZHcslgXQY0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751894065; c=relaxed/simple;
	bh=m4YeEdn7+8b6MdHtL/nmhSUUo7YO7MQcAUsMsxA5Iws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bHs3/E/eqD+BxVPWm5TWuTLfa8JIldks1o3EqCzkzfQh8010NclMbCsfwZUlv2ew+Vg4/pspt9Uf7oQqNx+038cJO+VTz8OnMtj4b20UFgaofhAz9mRHAfg9jkJUbhQISCTPpQIH0+Jlrnvr/tj763DYvi2NxWx+GompNZZJ8mA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=e6BUKaz7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xbVVIcCO; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e6BUKaz7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xbVVIcCO"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 567DBwYC006198;
	Mon, 7 Jul 2025 13:11:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=96p1ofvArMiY03oK2BLwzXF7Gd3KVj40jlw8Kese+ok=; b=
	e6BUKaz77BnhGJ9gCTiF4hSZaGP4HqQKALA7fEEvmWN7FlKd3Gft7y85ygzG6uhw
	TNh0+teORKvD3p+TQh3jNMH4kpuFHenxEMmW66CQfpatBZ6PHZhFJraXa+Un0OOQ
	YG/xlxYeb9EKoTiH7YFMQTx8cWNP+1ED30JcSFdToqlEvNNi6qcun0X4xQa+I0i5
	zrTBiHrt3OZsD5d+opupHnqbPtUUctTCnSk+kJB/MZ3qtagHaNu7G7cDiW0SziO8
	qbJ1vNzqYB3ljx/5yaaW5ofSsCN21LJLTD64/pNCahfNOOp53FGVgwF3RI12bxuO
	A3sH2jr5TvjEiZ5bwE3WcA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47rewhg006-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Jul 2025 13:11:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 567DAERf024335;
	Mon, 7 Jul 2025 13:11:57 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ptg8g3sn-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 07 Jul 2025 13:11:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fr8WqOsRJzKSp3uFUC0oICyf20ecb34FD+zjwIUUvjY/NpHslJ1bv118Vh2KEHMsTwKflaGFvwN9xbxkLLvdHxU41Ec9ygLpoe7aiwX9HmiqUH5MZJI1N7rbnW9YHZnBHjeFjMUxYmX+EK6ppsRdHcFEu/hmGXvMvEY2N2qhWMXWScQgnPMoNtQc4paIWYBFFPw+O1uaFJZveYsLHHTHoKmS1/huoLIvY1mAcpr9iR1Qx+xgW0P54Fygnq4/2TCK/tfoMEVPm3+01dqMH0GSdQ6bijj/lgQxrrcXhTGXtD7sUWFTazCecgjQNj9CMokgQxSVt6zeSnradMhQRyVQQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=96p1ofvArMiY03oK2BLwzXF7Gd3KVj40jlw8Kese+ok=;
 b=wTWPRP5mYrNWcczi1TVyW1XJX42p68tQtV78wRbULrJs8GvBsVS54hwtzwpfBcqAG45TzXI6LjBGsfhqhN3P0ypBNVNjIyBbd/kAeZgE4pkc5gW5Vhp6VupR8WKQQUN7wAS/I2Yb3si7m30jfO0GBCfhtd4tyh4QAoQEmT1JH2R/KA0iVydECmQdtVy0YH8rX7YSrmUEkr0SnxnH2+DxdOy2oW3WKnbpsiyDvxdOnb2UX8R7a1DcXO3qmcV9twkcYvDkE2TyermrHE/lvOmrb56fVzMFWhOzUHPcT7mrtVuUAbbuewwR8mj0ieghAtPKq+iyt00OMwBfGBZde/2nPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=96p1ofvArMiY03oK2BLwzXF7Gd3KVj40jlw8Kese+ok=;
 b=xbVVIcCOo8A07OkRwQP3lvRNbZS4Q7yP7mzGLZW1h+7l4SyF1b0lZa7Szkfn8EokUxmC9sHfZHJ41i2CcF4SM2HT1+KUKx/jEEFhEKqp7inuY+gubPgeFlvHKxldMzfkphJ2r6gGkBJ0g8e8/fH2B7nhxtTn9w/AR8zpV/ByUMM=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by LV8PR10MB7776.namprd10.prod.outlook.com (2603:10b6:408:1e7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Mon, 7 Jul
 2025 13:11:52 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8901.024; Mon, 7 Jul 2025
 13:11:52 +0000
From: John Garry <john.g.garry@oracle.com>
To: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
        yukuai3@huawei.com, hch@lst.de, nilay@linux.ibm.com, axboe@kernel.dk,
        cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        ojaswin@linux.ibm.com, martin.petersen@oracle.com,
        akpm@linux-foundation.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 2/6] block: sanitize chunk_sectors for atomic write limits
Date: Mon,  7 Jul 2025 13:11:31 +0000
Message-ID: <20250707131135.1572830-3-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250707131135.1572830-1-john.g.garry@oracle.com>
References: <20250707131135.1572830-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0027.namprd21.prod.outlook.com
 (2603:10b6:a03:114::37) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|LV8PR10MB7776:EE_
X-MS-Office365-Filtering-Correlation-Id: fc4b4e4b-d3c5-428e-0b02-08ddbd57d709
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HrC0Ew9fQqgvVaqpoo9ZPvSSNAI+r5Evq5QdlnhVlDUS731m9w2LIds/V6r/?=
 =?us-ascii?Q?MxOh1TPaUU/bcDhEYRGjQN7U5ZjG3+D7m/Wqf09elZEeWXSTnI12c8heQp6H?=
 =?us-ascii?Q?DhDXkE3LKyMjqQcJOJ7rhlovjtbpqm5VWjLeqSdixJu3vv2zqmxqMMKCrqhW?=
 =?us-ascii?Q?pUCvRFqBeQ112psTZ2Bm7WdmFS1QsA4SR6ysVqVLcesqyHyFpuLiP+svIyux?=
 =?us-ascii?Q?uR0Tk/jUm/tjsoWP3wzdsgGBQ1GTB8L0rgoSx7iiKUrVs3E7JSEFnPjTZiWC?=
 =?us-ascii?Q?BnVi7Ui/hnvqV2zogujPFfddNGlhdDFu4WLFi2luEWsHiOV6p1U+ty6O34r1?=
 =?us-ascii?Q?PIkL1Rv2JVJDr4RyPn7WwqloZZYgwEJUoTP9/R3OknQ6+fisCXsNUtEOlu1e?=
 =?us-ascii?Q?ANPG+H8fi5pUQZDx6AbwaPf6jZj8RhWJJf99GVi+G+zGW81huJH4w1a4zjnc?=
 =?us-ascii?Q?WFDCCyn1JJV9CE/dO6SpSAkeqE0kBa+NEg2JMTsuOZ8z3NBTG2s/+AhGwzUo?=
 =?us-ascii?Q?JxOahon3vsxSzcc/Al5DYu886cAGXt0rM/mqbSnxAbDL33RsXXBPQYhIEJrV?=
 =?us-ascii?Q?ohSuUmMvsDf7KrmN29lvRYIVPk+1D68Vw62/DX6ESi+tTPKj7jCoRwxDcb54?=
 =?us-ascii?Q?GWHM6brhrhKNPgvFAJ97NVZUAyemUBOwNgAeZYZc9HZ7bpFqq0FDet/u9GrB?=
 =?us-ascii?Q?oP3ljygYoB/gzAKqpyCgPWPGTJ4QWoVHxs/Fr8Sedrqn/n6Oc//UixEWXJMF?=
 =?us-ascii?Q?mDpic+YXj1/1PdSEOXq9fdBcXnVtRnnkyxV4KefvtCIdhPVghHEvjj3kBtjy?=
 =?us-ascii?Q?SlK7Hpv3OD1lkhL7oCTY08wKgB4lCyqwBeTgYSOG6RvlI1yAz6xyE7zUYpKv?=
 =?us-ascii?Q?ybmXlgS7myPZk0SISC4P3d7VDdJmSMZnty//2xCehrHt59jptUK96b04c7iX?=
 =?us-ascii?Q?xqRYWs8gqbaizw9QV9X4kejoXxSTmaDGdl07FX3KPsPD5LVLEmADZhIxM9rE?=
 =?us-ascii?Q?a7HXJofZX6wwvvSMjhibVlQ85ntvAJQFiqcx3H0iVxkWNuRAeW2Q0HV7tQYA?=
 =?us-ascii?Q?utmJSBOe8xBrWGhdM96H6glKFqj3UEaS2RBa++GvHXnmYAJpA1/7aX1Ui+d1?=
 =?us-ascii?Q?N0eZBBT1LhCiqY0IDMiRJza/nbTkP4Ueeq/QQuSojLwU0T7DPj+00T/DBKKd?=
 =?us-ascii?Q?bfVpMjvHPoP8yOxxp/PIeSn4tkq2fy/U3cjoIyOuO9eWDrXtS3VDdXkaM9iz?=
 =?us-ascii?Q?MdhcTn5h8vT7xkw0r7pnnLZJXEBRhcp41FDLsi2zlF1Ybb7BWg5MkhszjTg8?=
 =?us-ascii?Q?XAsOBB/6vb1GlFgqBkNq8lEsuJNCYMRWxdRcaOL1jn1oUSFxkbhZADLD30Cf?=
 =?us-ascii?Q?OgksaX6rS0tHI4LIT5fjOwjFlvbRItCivfC3ErqmHOMWWvgt0IHe2b2Zgcup?=
 =?us-ascii?Q?DgULpmqrVi8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Mb7muvMPMt7QnXnqwQDj0C8mgAY45iJvl7XRhedUyWvPcSczr+E2AX2Z6cg/?=
 =?us-ascii?Q?WG1/P29mRBm2kqwcrqX3eG9DwE0FZkrPSDSK8b81ouAZMnrJFRCsWxX4ZoyC?=
 =?us-ascii?Q?P9KgVDmz0qxx5td8zXWGv6WV8PpAEVlzOmDrqNjKH1njAuicH0Ekb5N+ujaF?=
 =?us-ascii?Q?2gB9ZTtd2EzrkdV12gTEbEkGzD9JcWi2BCa9+oG0mrVhooRfTB/seHNXZcfa?=
 =?us-ascii?Q?D2cEAHhh6pS14kKRM76j4RT4TLssmgxl8dbLRrHG9iIVijKkMHdtTlRmLL3I?=
 =?us-ascii?Q?m0ALHHGGPR9PqAfYylMTA3knc4ifcujssfiN1kbhGRsOVX3QPS1ZWAi0EQAh?=
 =?us-ascii?Q?BUxebIbsN4oBWfyTUjn1YPF6+tmt+GPynTNfkB2D8drBXtoHwIs+b0H7lGKg?=
 =?us-ascii?Q?4jaTTpwrIrsVZ5HBkLyf50LlMxrk9rgsNvF/brx7G5fZR/9ECjJkmhj1rGYv?=
 =?us-ascii?Q?KRf4OlL0nHDj5R0KPSndjswSRJng8Vxt4LMAQYWCduKtITC1rYY/9vsAeCss?=
 =?us-ascii?Q?4Hd6dVNfrFUBeG2QkuuEJ+d5BKGJKrbwGEstkq2hljDfxOpaAjDi+awEXMFc?=
 =?us-ascii?Q?SxQE6qfNUpvK8R+SK+CckFlrT9FkjfOpRsVpCznvunQYQApvaK9UEMIpyH8W?=
 =?us-ascii?Q?Z82vvItAZi1YJHVCDf1aZcCj9b2h5GLiwQNGd8NFohWgVOxzd97vP2w5evvs?=
 =?us-ascii?Q?bbdzKbsZfYB+nfZYgBC0jfYARFrz1exqgEPHTXKNFzaO41IScHpWe9o2PXla?=
 =?us-ascii?Q?5f9aB2XEDMhAxg0H0mUrEsHSFtCtGz/tisEyGQAmkOscTPZmfttvb9szNJoA?=
 =?us-ascii?Q?FNHxHciy/l1cUr56zAgM4Clgc+t3vnq2xAi7yr6JV4zpnUb782cXXVQVrmib?=
 =?us-ascii?Q?zgeV/EuKqhV3dLxzCiChDw6/IgbJWfkzuLZyDTJTxAi/s4CkypFH0cOmqlKh?=
 =?us-ascii?Q?v+Rtk4z03D6h5wRhzpnbrCAob45HHYW258f+UgbjoNhQQAakpQC2caUdVnlR?=
 =?us-ascii?Q?J3lIxX6bGbB6cO4fZbz2oF6K3AAKuf4fly3Rr603eePKv9cFA5ok48zJfGyh?=
 =?us-ascii?Q?9kc+xHcD3wvBJOMjBumBexPyAK2uemRXpUECy6MUBx5iCF2d4OsmeR9bkEVh?=
 =?us-ascii?Q?UCUjza3UkshYKc6JmK+RlHbm0M1LC54VDNwAcGFiuHHjaWDYbXG0XIX1ck0x?=
 =?us-ascii?Q?JWhEnggN8xgdGgTzNOPiavGyW58SSTsqhvn4Uwme2kqscqQta1xA1XzoHMKr?=
 =?us-ascii?Q?5BEtEryaGzThBor0Grf5St/QD0025yYWhbXfbJGX/6Kvt73wuHcyDayi+C3Q?=
 =?us-ascii?Q?ea1Hzl6A/o+fZPpDeqWxl8LL4V3Fz0L0jKYovWrbUJYpjw/F/3OCc94W3sZ3?=
 =?us-ascii?Q?k6swul6zVdsN4OxDlAzcOPLWi+4ILiI5BAYArJ1+XTHig9xLKsOXKpbvKG/t?=
 =?us-ascii?Q?UcKP1LhAlumoI6xNXbUWy2EjaPmUHGPDR71cpM3bM+/yUW6PhQeW/9UNLD63?=
 =?us-ascii?Q?dvuNcoc0IHoi1bpFSWZG4dZCOCMvcVj2lMegvsPM4iZA61wyS3mG5AfftiOK?=
 =?us-ascii?Q?IOKzNbg8CmgRKTxSD84WpkC22j5DKVOy/6J73Fd0RxKH/vdQiMvfyegwywZx?=
 =?us-ascii?Q?Ow=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	h3QOZeA7hg+Dm5DurqhLTgQzmkbSlmx7GQcDLPOo7ZEvUhIJEUp0Aj1MiHxiLk9ra5iFSATqzqi1+9SXsUV5k6sGlQDPYq8GwDqYAIFdbYLoMuHfMBIllyshxwa5weZtRbq0Xy/faBUGNODocQb/Eo+OlFRjb9p6ZvH3g+gOBIW5P7UXne3ufpILOxAJ9alX/cNZAVnc2mkEjoMRr6U5O/KY9IA/OyPjdD1spU4Hf5fQYw1/Rg5HGHWiW5993AB/gsLiNNGe3QKEBCMrFwSZEoZ0O4a05M3rTbfV82iSLte79ESCF0S9Dc87JNUixYIIsfD6pWoIQ388eZItupcYfd0wTBtYCuYl6NQkBI0dWnL9nCw2aMIyPnq0gMNn7aOfId6EZ8dxHY/sOlWxyev0SVXHP55xW/a0AfoxyI5q/yCg1cSLCj5VM+YZ+vNX85ixFIbPl/WwUNyKzGGsgOsr6QXT8GAK9Km4dXc3Dx9HnM7oN4/H+baOD9KEPAC8JWmx+KEqdI2MrXq5c7BX9pygekMqAxI20tTDe/2uhjxDw5RsAQGImTIS0F4w0HRzobm4kBFf3HG6aovow/09lmTOkBgMVkL6GE+q61pbWqnWfgk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc4b4e4b-d3c5-428e-0b02-08ddbd57d709
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2025 13:11:52.6159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vm6+mSj8quQ9Q9YzVmWe1n8gHhYK/vysTQHR/Z6R3kcTbpzg4XPB0dMaNLT6hdXRBm9dC8ad3PvOKdOLTvZz7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7776
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-07_03,2025-07-07_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507070077
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA3MDA3NyBTYWx0ZWRfX4Rifc92NGjZ0 Hz+WA7+FYl7szdcl6SaH8s13QLzYLarXFNPNx7wSWvEfcpAxdaXQ6zCSJPL5/9tIPVkQTH8pzP1 maQ5tVw7X7x15DGe+I8MF4Sgsk/GOXB8twPYCDsaPEPVmptWKffafRhyuEuCiKuNrjUzdMAHVSX
 iie+lnEpEP5KNRPpwT+xH4jA3HQ+E4GZkgdP6+gVpe+RzvATLhhnIb0FfedABAeET9P2lQO1yEz 4mdpOoTxRiTLHKQpKh3CxvjjK9hiMv9lSIEjjimMhRyn+vawGZNYMigrCoeWq73ozdVAeVDeb64 IodiVKPL7fGXyA9ZCEgFtooF541PxDOIvC/Hv8FHp4oPa7aDYtZZJRs8Vas1gX+MC0AEHleg4Rs
 DTD3yOwLNEnxUyYGlt7tE7dU9bGISN5hCedSvD73TQjJFtWIBgQ/2+rx59wbC4SQOH5lobMQ
X-Authority-Analysis: v=2.4 cv=Fs4F/3rq c=1 sm=1 tr=0 ts=686bc79e b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VnNF1IyMAAAA:8 a=yPCof4ZbAAAA:8 a=DqzVqx8i_IFAgmWpyL4A:9
X-Proofpoint-GUID: mZltMzyGipIe3xkjpvzYpxU1UbO187ov
X-Proofpoint-ORIG-GUID: mZltMzyGipIe3xkjpvzYpxU1UbO187ov

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
index a000daafbfb4..761c6ccf5af7 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -181,6 +181,7 @@ static void blk_atomic_writes_update_limits(struct queue_limits *lim)
 static void blk_validate_atomic_write_limits(struct queue_limits *lim)
 {
 	unsigned int boundary_sectors;
+	unsigned long chunk_bytes;
 
 	if (!(lim->features & BLK_FEAT_ATOMIC_WRITES))
 		goto unsupported;
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

