Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E60B3BED35;
	Tue, 13 Oct 2026 08:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879374; cv=fail; b=Dd3hyF46Kqi7DJRIPy7Sh/29CSqePL6BKZz6PHYOxuwi3iJQstssnbCTQPfuKC94P/5qYfb8TdGN4xSsAd8UiON57GVMEqvvltntpoJCQ6GAIzJXmiSRsO3MXjF/1VMsE/Jbmls7DDKwJhc5ZbRBgNiMOKBQ7AX3kmodrvznx6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879374; c=relaxed/simple;
	bh=SppN22fDh0kPZgpBHiDaDUp90wDhO9cno1gesPR9zWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JJU03maeZrgz+6dqNYPApBE9O5gLyp0u3rn5QRNJeiAPU7yppwK90kS705zUjcJ2MSLUNOSGjzH6WAMDs3b9MDfSoIWh4WrG2iiRo5Ci7XSB4xpsmgLXz7lpgyrCkOOZDkWq1t2rYZUxGKE43Bcdz9Bf1C2lqQ/LJz2Yh1LUAYQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MdN+aKKf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cq8XhaDj; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MdN+aKKf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cq8XhaDj"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2BtvB1439901;
	Tue, 13 Oct 2026 08:16:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0/tXizU+1Y2jeTo7M87SSS+bAdXFfjUhRoctztKVTks=; b=
	MdN+aKKfF4iLsOU8dv8SZ6FkhTbyJbHeN/c1fCguGOQ70xGLUTOXmVrZnAbm2FYo
	0JvujBg6BXjnKlnI5adx+c7C/pNiyGMS72XICA3b/b0OdQKqYF1weNjFj0IJXFLd
	feCyD3+QDDdt7epQveyYVq0JuL6uyE+fqzDZVLooGT7D2/aDIq+1R9rqQXTegV7L
	ALr/yQtGQ/ozOXwTzZBKXC/Ewc2eLdEirsZbuQDh/uYGRhJT8KR47hZRIhkvHlCx
	Jey2PgMDLXc1VVCTk4+2GQb1MH54Lptl1hFBHinH1zjm5d0vqLT5SyPKr+jvd+Ib
	q+LZb6sGxOh+1aghdoHEWQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7df7uk9b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:16:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86mnY035078;
	Tue, 13 Oct 2026 08:16:07 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012052.outbound.protection.outlook.com [40.93.195.52])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btp7e40-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:16:07 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dF67nkfTRb1hsHe/9Kerdhtwvt6tmPEL1h8OYHH7lczEZ0QUMLkuuw8rsllcKuxnLxBYRjU/HQ3ch5KtYkMFh4Dpn+kNdUZmMVH60eqoMVYBAKOHAQvdwUyLvOOhDTxNwyUylcJsJcesIV14nhYBHVrVFXf9V17vNOtWh469+yHpW+2PU7De0n1EZZO2xIbuXyzYowatQ90LjY4YvXcjpD9DGxXm8s3pUcjPtFkjjoj5rvYK/HuRZRODdV+NfnA3bPnJYhL7scjT6cIi3VTspy/UGNBKhOTJX8maBRAVGjFXQANIsCgFjIO9HXWlSTi0ugNEYTCUQ1VTUUSAuv+4PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0/tXizU+1Y2jeTo7M87SSS+bAdXFfjUhRoctztKVTks=;
 b=jbcjzCd8OKbmnk+/TrY17BQMCfO9FyB3KFzVQsRcgTEpylfvcH/cwPukxD82HRh55zJt4dzP/gAZNp6f/4s7HjbRhbdlwoZqiSPnfbXWWHXlh/W9LJnljbJe3Zhlkhf+9g4xyqBXLxmhLsf6sys5bIahPaEdvMPz8MiFzpyUijwVOIZmKUpfHp/ZchLQ7Fso6iryUZWn2Mz/pKBgdLPStIggQBveJaod2qKzGkOdEE8VeVf5DXr56DiYAKxhLI0tsEk+3Y3M/cpS/hMbQ86tsbzoGAFtkBBdn2MRzihCp9mN/0IpuIk7TcNKaYLqaNmoEPvL+3rYaPLr2SDYP4G/FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0/tXizU+1Y2jeTo7M87SSS+bAdXFfjUhRoctztKVTks=;
 b=cq8XhaDj4xqmHSzkFdE63QYXTz3UFQZyxOtvCiwn3Exc06dXYyFcVEU8xN/+2cl2T/wB+ep/prA8u4xxEZLWszVbNvt0M3rGuNBh1+41Vd5GrEuhYyHZ2FQ7Z2lE/7g3ebTcvG4IQxpF/n8dFV8kbikT0lF6C4su8PhWl58ubEw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 LV8PR10MB7992.namprd10.prod.outlook.com (2603:10b6:408:1fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.7; Tue, 13 Oct
 2026 08:16:05 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:16:05 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 v2 12/19] xfs: fix super block buf log item UAF during force shutdown
Date: Tue, 13 Oct 2026 13:44:56 +0530
Message-ID: <ec10ce6303ce6b38d2a1615de600f16bf8e5f8aa.1791877866.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877866.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877866.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0029.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::16)
 To DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|LV8PR10MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: 34d5f051-19e7-4b79-4a66-08df29023a09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|10070799003|366016|376014|56012099006|4143699003|261009223027099003|260925021311599003|260925022911599003|260925021911599003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	FgtD8fb76tMt1ViC4fxtpyfr/dd8wO7lKzk5sgJLXomJ1mpHm99OEt8L3/EqLeaVTlWNRNGFE1TJ8Dy0Ru0rsBIVNTBkcmgRq0akXH3BlaMLKwsP/Y1VdSSXG6QEUPnVt5yK77uuLvv/wX0hFjuKZMdegixP11PMSIQ9fSYNzNdb9s0p3fddjktQ9l2TVlbhtNC5KHLt8aYlqwWUyoqjiLAr3fg/44jy0NJt0PiT3Uh5yxK7cjnHcudOB4J8tdr9d7fzKfTQSXKin0ETFQSH3GOV77C1DomCuBgCth8/Nr8nY5wgfsBXuWdKde0/cru857NlbvLJ35dBpfbWlVacSDURtFbGGfm5R5CIJ33/guK8WuWdnBd8o3YC2EI3wgsUAm0qC4Rd0Vkm40A8tYx356n/DyhjWCoIxAGQu8Im9h0MERWa9HueGpEONZW44Dn9ga4s5GlQ35GkUu43cu+bUjilQcPD2nc+AeUrd3H47DrLd1Mgi9U5bzwDCRH/oSIUv/7BC7qm+TVhiZFdoGh8LeVRfjhEVozFxj1IiIT5XBNaLsNqmy2RYia/x9meWgutOlUAWgBg3CbZ3A9eCwLR3fgGiv6ByFQfasCOyS+UEcL/hAssjzcbVIl2si90rpEkVyY6xXvrkHBKfoHHcx08wnMe+xMuXfmZ/7aD6szJxwQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(10070799003)(366016)(376014)(56012099006)(4143699003)(261009223027099003)(260925021311599003)(260925022911599003)(260925021911599003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Vj0MLdejUsEZOJceFSQGxbYxq/9NZfwC7AZMAXDRvUQCjiv/Ts6e1R8SD+yf?=
 =?us-ascii?Q?F0cfBamBrMzu6+1OiB9JpTMX42EpCURLjzs7iqbbQTw4TwxIn/QTPOtPFmYq?=
 =?us-ascii?Q?NmtUdO7e2/x2AJ9owSoYtIIdUHjnjN/rdAv8DbbH9HQcMhk+xTTZ2wb3Vr9h?=
 =?us-ascii?Q?FNJ+Z5Z9aNaLrNNhXzOSjl1iY+aXITMr755NBylGpJpWfroyTZOJZlMSwwfQ?=
 =?us-ascii?Q?RTwZDd82dx8I/T0cwsBzAIX+bqy4VOW71hqYzwzyS+rUoznYBKcxWmoiqnl7?=
 =?us-ascii?Q?JbNSzG/VToTc7+34hCsychsQ2KIBw0bL7+SHVFiyUJ64PS7uJeF9mfDOiVat?=
 =?us-ascii?Q?6MS6QP/N/LAcmFAFg+3Ip1omt43S6hQ0+dCIAE6yopzerOoIV0NGUiweAYhb?=
 =?us-ascii?Q?Cdkl3H6spdD72IItlGRCH9vILbAIyEjPYtZQq6k6RN8HVubseKP8Jn+hGalH?=
 =?us-ascii?Q?D3E70hEN7UfvIFKJJCtZEIen6z3j+4/Dhnh06I0ebCUSWjJl8px55XZGF6HQ?=
 =?us-ascii?Q?E5bw/6358ilvQeFPbSqnqWHTwWipdtbgvDyH7XAVBhFruxTKbWc0GbuNRdzI?=
 =?us-ascii?Q?cBrXdRoVbyejLkVfE+uCvv9M8p13dCvKLUEw3D1zgV9PJW15bIsWxgYnBRQJ?=
 =?us-ascii?Q?R1y5kcDjv7xAGj7y5ewAyIWsMA/OJBfamtHIsY6r1hhbwLH9slCO/k95cBaC?=
 =?us-ascii?Q?Ehav0L+Mq85GemZhcH5o8me5Q9myeYSQ3OBPCZdWQLJJ79hthOHmxFIqWMGf?=
 =?us-ascii?Q?B/zt3pQTK/QNWTJxLpSiNNAmPWZClCPi5MRqhSIJ2nCzBx/sL4V1vvfVIDXB?=
 =?us-ascii?Q?pR3FVGdvMgYnEkjm65iH0FiUsEjEuJhr8RMFoGXEuQqQC1jQVJz/17BC/JR8?=
 =?us-ascii?Q?P6tumokCUkKi7oePak6YYRkkfcF8+o5qXxoY+hRvOup0TjHy+uf6dOxMVk2x?=
 =?us-ascii?Q?RXVOMreqgB+BEuGo5M3nF+c6p2+q/tlm1xWXrSBzfeZppNw3ctvSx5OiaKIN?=
 =?us-ascii?Q?0qNcGtNq+y97xujJVXMpSyet9Ue6wYmy0xi7GcBjVz45tqyNburIe2IA2IFc?=
 =?us-ascii?Q?o8nWzbUo2RrHI8ZS0WaKVX+r7Fgc5w2CKnLI7MOtY11m5/jaPjFNqtR2ZYSv?=
 =?us-ascii?Q?ZqdrfXeyTC7YvsFtENjBsP20H800PV0K1OxmVR2j4CplkACfcOlB2asHqMyR?=
 =?us-ascii?Q?CeUOWhRwogxXYPUXpFfI7zXWOT/HJjNcEyFaIRNodRTqvjzS68EweR4Ygxa9?=
 =?us-ascii?Q?MtlLhNIoNHGmSJvR1n1mKQevylJjHk6NkbiuzppXLZfi0O00MArsWlti26Mb?=
 =?us-ascii?Q?wmvV474rdKATNmKq+lGbzHjbt7E4O9zK954shpWoN70x5rnJcOTLUT9aCTpe?=
 =?us-ascii?Q?hpKUVhpLD/nbNYyMw3OEKwCo9R3lL0HD4pU6lqPTG6Mc1pl8G9jzfUVghqBE?=
 =?us-ascii?Q?cT/Lzatn3UuKIBQ4TAJ9vCzW/PJG41OOfyaoyt3vjFqX6BjGQbeF49n4/HXT?=
 =?us-ascii?Q?PA5U/dybQjI3wuw3rLYrAKc6G90oos9YMHiq/t6V9LAJPsaAZ9AO+2ukmRyi?=
 =?us-ascii?Q?eEnYxkbyGKppgUX+qhRtIdP/AIzlPcn5DjrnjHix/xRefBd/MhF+vhqEp9so?=
 =?us-ascii?Q?n3hj+zd4h3yNxTKPH+bG5fzuXG67YaCWuHKSp6e73FzhdK1FQJ/DWLD0DQqX?=
 =?us-ascii?Q?Mij8YRtmq7rNJOD34xniVA6hnpvMqisKIsxv1hRCbQg2pr2VlX599VUrIpWe?=
 =?us-ascii?Q?DrPQCOBqdScJv0+hSu9m7WHTariZs/W+TbrrqX3x2/Xion2X3sgaWl7BqCkB?=
X-MS-Exchange-AntiSpam-MessageData-1: YW2a5uNTHmVp4OoTlC/bGYhbjFicyUfxsFU=
X-Exchange-RoutingPolicyChecked:
	rPR9NKJhC7MAPaIJBBVKpSOWo31ptwPVWrHp4RUHa4ZAq9S1DfW+ZzRdf1sIcGYyrhFe+xI60Mzq+ybh4sMv33DGVNDhjm/PNVfj2ClXpK68PbLLUwteC/zNRr/L2/9BFQWp/DOSR57jKvvKYowN63QZ/RdWPxanSFG/lrf8ZFPrVp8GcKIAY7qisbKuAfGXEQ33hjXt6U5dGe3TRtFElG1nWgQjjbKVbbMgA6awx5z6l3CB3Xo5gpo3Ba/hpZOASQwYFU9ePXWSzrSCobkPyb/mz1ul6gT04Oa3HAywCkbgAvowMx1l+fRw9qtoWZ0e69iwH5DlIZ8zXABO8xq8WQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4b7+A1CTAEJ6OyKwbGatPzFoOykYWGBohkmXH+DI03CTZRc9WPu0sE/Rj2vM99+FiU/NJlOYee5IQ6Je0EwxntxsR3xjawNfciWP4PCeF2P9eQPioHJO67DoyuQakI6HCJ5/L0xmwpmqor7ZGSxaNUWROY0Q9F4NNIU51VwwlLz+yUx0irBZxy6h+j7hHYways0QBlqMME5UGfzv5goUeJCkTzgm+loMaKTzTPf3j0k3/d0p5PkQcxjvkF6SI2tfoy2Ydio2dO9kvQGjzrgFehtzRSvVYryfWKEn71tMVVBhm98Y4DlGSC1jzN7JCPAWNK17hhJSvWX1Tg1ZvdZuFQ3bwjmU0yXbiSG5yrUzieFYuC3Ku09GYhUC4njmy9Pru0vJv4DbP8H9U9ZQa6wmgg4c0jEuetUswot7KXqvR1iokCh7+Fqkocjuf1mWovNedYJiaDPUUifTGEUM5lUxGp8mxO1PlbiWX1UDbPzGQnFSedJ+1KJU2Vi4oMdVzslEjmxvEBTAyzSQvt9FvetW/9IutUQw3GjKgyHHSQkOP2CtF7aEfC4novpnh6G/E4tz72fa29LWrPYBp62Tt1zAghQ1TDLkgWJvqLxrYkpRJW0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34d5f051-19e7-4b79-4a66-08df29023a09
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:16:05.1345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZWSepQkQ9u3m/H1mlfgiXu+jIr05I7Fei1ElI/KK1sA4ZcuQu5xChYA/KgVEkyLedNG3W4iapWZF6VTqZz9/p8qvaU8jORWyBQ+IS6re1cA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7992
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=N+a8hG9B c=1 sm=1 tr=0 ts=6acde8c8 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=ag1SF4gXAAAA:8 a=yPCof4ZbAAAA:8 a=X1hi7w48wxXEZvHpCekA:9
 a=Yupwre4RP9_Eg_Bd0iYG:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12107
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX71RIg/8dHx7c
 NNQX4W2ewZJQ2oCXon5//YUNN/ry47C8t8h4B8crk0r/9vja5vmzAkch6AlwY7LH0oJmJOvLm4i
 /7uKOykApVDPu1iapYtBotSTOfl6YVx1+5HQuNwogB+l9GcJxlw7Fd7NIsIb8/Ll1BgbOyrAnW2
 h7FW17kGpB9rtNwnh1lcRZN5Qkpb+zmqRcrhVAv7qVt/ZcEd1zkU8eSBK4gfawJW5c4QvsAi42P
 39Z+fDHXHhOtr9PiHdfDXvLOTS9GjsWyvmu1Wi5iTV1Nfs3ssb9pQACilZn3X7xjtNcTWhJKMh+
 yTijlOcTTmAz7eBgHvgJPRApSnZXSoSm+06+vIvBOmP96ENz9vV4w6Nj40C6tk9rpkfN+z6CA6P
 Tz2vhW0ru8B2KgtTr6uqxb0Z07KC0BHYoa96DM6APYoY7rJfadrP5nE4zozuJS/hysfmbLqpTqI
 B0VoetHkF3BPC4Xox7L+UWnijIk5jjneHrRMffI8=
X-Proofpoint-ORIG-GUID: R-pJVsvl3QgppZ2I4Dfx0PGdXqjDjMf9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX/bzlt36C/Rdw
 KyZn91Il/e4K4v3sbbB3ZJnYp5EySlsr/5qEk0ZE4R+W2+qfuBQ3gSgFZgLQMhN+zakSc/o3OGj
 zyYJFMfP+p5UBHkgwD0bHEdzV8QpYvhbkzgqlF62hYNKE5D9zaJ7
X-Proofpoint-GUID: R-pJVsvl3QgppZ2I4Dfx0PGdXqjDjMf9

From: Guo Xuenan <guoxuenan@huawei.com>

[ Upstream commit 575689fc0ffa6c4bb4e72fd18e31a6525a6124e0 ]

xfs log io error will trigger xlog shut down, and end_io worker call
xlog_state_shutdown_callbacks to unpin and release the buf log item.
The race condition is that when there are some thread doing transaction
commit and happened not to be intercepted by xlog_is_shutdown, then,
these log item will be insert into CIL, when unpin and release these
buf log item, UAF will occur. BTW, add delay before `xlog_cil_commit`
can increase recurrence probability.

The following call graph actually encountered this bad situation.
fsstress                    io end worker kworker/0:1H-216
                            xlog_ioend_work
                              ->xlog_force_shutdown
                                ->xlog_state_shutdown_callbacks
                                  ->xlog_cil_process_committed
                                    ->xlog_cil_committed
                                      ->xfs_trans_committed_bulk
->xfs_trans_apply_sb_deltas             ->li_ops->iop_unpin(lip, 1);
  ->xfs_trans_getsb
    ->_xfs_trans_bjoin
      ->xfs_buf_item_init
        ->if (bip) { return 0;} //relog
->xlog_cil_commit
  ->xlog_cil_insert_items //insert into CIL
                                           ->xfs_buf_ioend_fail(bp);
                                             ->xfs_buf_ioend
                                               ->xfs_buf_item_done
                                                 ->xfs_buf_item_relse
                                                   ->xfs_buf_item_free

when cil push worker gather percpu cil and insert super block buf log item
into ctx->log_items then uaf occurs.

==================================================================
BUG: KASAN: use-after-free in xlog_cil_push_work+0x1c8f/0x22f0
Write of size 8 at addr ffff88801800f3f0 by task kworker/u4:4/105

CPU: 0 PID: 105 Comm: kworker/u4:4 Tainted: G W
6.1.0-rc1-00001-g274115149b42 #136
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Workqueue: xfs-cil/sda xlog_cil_push_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x4d/0x66
 print_report+0x171/0x4a6
 kasan_report+0xb3/0x130
 xlog_cil_push_work+0x1c8f/0x22f0
 process_one_work+0x6f9/0xf70
 worker_thread+0x578/0xf30
 kthread+0x28c/0x330
 ret_from_fork+0x1f/0x30
 </TASK>

Allocated by task 2145:
 kasan_save_stack+0x1e/0x40
 kasan_set_track+0x21/0x30
 __kasan_slab_alloc+0x54/0x60
 kmem_cache_alloc+0x14a/0x510
 xfs_buf_item_init+0x160/0x6d0
 _xfs_trans_bjoin+0x7f/0x2e0
 xfs_trans_getsb+0xb6/0x3f0
 xfs_trans_apply_sb_deltas+0x1f/0x8c0
 __xfs_trans_commit+0xa25/0xe10
 xfs_symlink+0xe23/0x1660
 xfs_vn_symlink+0x157/0x280
 vfs_symlink+0x491/0x790
 do_symlinkat+0x128/0x220
 __x64_sys_symlink+0x7a/0x90
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 216:
 kasan_save_stack+0x1e/0x40
 kasan_set_track+0x21/0x30
 kasan_save_free_info+0x2a/0x40
 __kasan_slab_free+0x105/0x1a0
 kmem_cache_free+0xb6/0x460
 xfs_buf_ioend+0x1e9/0x11f0
 xfs_buf_item_unpin+0x3d6/0x840
 xfs_trans_committed_bulk+0x4c2/0x7c0
 xlog_cil_committed+0xab6/0xfb0
 xlog_cil_process_committed+0x117/0x1e0
 xlog_state_shutdown_callbacks+0x208/0x440
 xlog_force_shutdown+0x1b3/0x3a0
 xlog_ioend_work+0xef/0x1d0
 process_one_work+0x6f9/0xf70
 worker_thread+0x578/0xf30
 kthread+0x28c/0x330
 ret_from_fork+0x1f/0x30

The buggy address belongs to the object at ffff88801800f388
 which belongs to the cache xfs_buf_item of size 272
The buggy address is located 104 bytes inside of
 272-byte region [ffff88801800f388, ffff88801800f498)

The buggy address belongs to the physical page:
page:ffffea0000600380 refcount:1 mapcount:0 mapping:0000000000000000
index:0xffff88801800f208 pfn:0x1800e
head:ffffea0000600380 order:1 compound_mapcount:0 compound_pincount:0
flags: 0x1fffff80010200(slab|head|node=0|zone=1|lastcpupid=0x1fffff)
raw: 001fffff80010200 ffffea0000699788 ffff88801319db50 ffff88800fb50640
raw: ffff88801800f208 000000000015000a 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88801800f280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801800f300: fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88801800f380: fc fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                             ^
 ffff88801800f400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801800f480: fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================
Disabling lock debugging due to kernel taint

Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
(cherry picked from commit 0d889ae85fcf0cf9bc6e998fca2ec760e08e0b46)
Stable-dep-of: d2fe5c4c8d25 ("xfs: rearrange code in xfs_buf_item.c")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 7794bd956861..73c548d5b593 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -938,6 +938,8 @@ xfs_buf_item_relse(
 	trace_xfs_buf_item_relse(bp, _RET_IP_);
 	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
 
+	if (atomic_read(&bip->bli_refcount))
+		return;
 	bp->b_log_item = NULL;
 	xfs_buf_rele(bp);
 	xfs_buf_item_free(bip);
-- 
2.53.0

