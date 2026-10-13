Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D3340245F;
	Tue, 13 Oct 2026 09:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884321; cv=fail; b=DAyvmrdkPejl3b4OiHLtlFkeg9ObqXIo73y5AilPdOzX9g5k+kM+tqCC0S6mp4wcPJFEQRphab+OsLg+PZFyVMh12ahwTcsLzqSTfBxAp876VeLGkGtLNYW3k+5Nq7GrnOfWViCqRunW44T9AE3PLFKJP+X4BATINf5eERPFBX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884321; c=relaxed/simple;
	bh=G8LYIQwIf35zcCyXfy8Jkwp9L4phUuIpyvkzwx495bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KwuigI464FYtq1FiNslapKOo/QSx/mTCdvdxkfl14iT15/vmB63sOlbOU1QCMlgBVOJM0f9JGIibB/bRBXwMLEFE8pMmNs2arwtBAP9Gid796FYsLNfllWLIi0tBx77KGD2cpQacFTEpF1lo6TRZC/uY/SwYhSt2MTUYPXa2jB4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Gb8UjyYm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zry1GWie; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gb8UjyYm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zry1GWie"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2D3JR3436329;
	Tue, 13 Oct 2026 09:38:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=q45FVh/H/qUI6Fc0J0+qVJhr/t3mIu3FWueF+8gwJB8=; b=
	Gb8UjyYm8thv4xcd0v4blgoOhF7dqAZZej21tdx28MwjWTc2C+2P/WpSnLpcN023
	cv5FfS7r1GsjW2s24ecCDRPj0G9K6UWmVOWtv/TV0kUCMhNpCGlzuZYpr25ydiXB
	4TimBQw1q1H7A0sG5A9XOXhl4paiqKr6RtViKT52REjmwjvLe0IXv5wkQk+fke5X
	1D4Dbc+DvpcuzfKBH4joVS6Cov2etMRUqlFDzeIwB5T3qPRXyTaIcixZcMoJHzNY
	TTVrjBE2hwYl93h/eGACd/9gnuzu3iOxPD4EDfbXJGqYW45+zvq2TkJutPw9ycD6
	OmtWViTyEy25zzv0dqqJiA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7de1kp3s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:38:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9afdx002197;
	Tue, 13 Oct 2026 09:38:34 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012000.outbound.protection.outlook.com [52.101.48.0])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btjusrc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:38:34 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=faEos//6QBegdaH0O5GafBMU/8v3A31JJLFBouSFytDY4r+lzgKMwE90eu2zl9kyZ4PE5EPA4/fK6dMhay/dRngHjd1VUC8MyxsoqNL5NvekBMs7u7ZD+5//gxkl3Ze8hRdrPd/glVughgKrTRYVJ+g/DTSsNt3Jw1PtPi2DpPdIol+Wwoi9zWvMYtrF0dK3J1UkfwOns/GFOhi5V7JvNXzQQHlx17B/DfVsK8Ps3HQhFWFlxZx8Dd0lPifPM4FtPpjlbzecRTE/MRVKcPfLk6ieGixdAtGVpu5q0uBf5GzxXgcCio9cknhnyz6nNcfqOMQQx0BBEurSN6pUlYRfCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q45FVh/H/qUI6Fc0J0+qVJhr/t3mIu3FWueF+8gwJB8=;
 b=XdiNho5+YbJq4WT6z5SMT4TSrL4ZhGXu7+fRmE+rYRfjkxFg3MmUvLJNfV5m1IpbwYVTZbBfAL1qx15RP5THC6trDfCHhtCBBEd64mzRDnJLIcg6vwKB00lyl7+/kJoJqPDPG/UsBRW1MjV/ge/5HU8fDnmv8SIG+65LSCPwZswLJI/+ugqh/rkUDpFSg3+SwG+gz8p46MruUAillUrmRose0NzMr4TrhQkWfX/sYtt5ITsDyWFxaVlhoqhVh2Fvb8411XNHf953tfVvHMfqgE1g1tsp3syknV2s6Zx+qZuoIy7Wh/9hVJbbuNjqy59f/Ur9kTfIn+OagW+KEvHkPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q45FVh/H/qUI6Fc0J0+qVJhr/t3mIu3FWueF+8gwJB8=;
 b=zry1GWieGg3qH+Gehgc/gybGbqJpKwgiTW14oGdgEcHB1Rh3vql/hKDtIOrsTGjS0Wed0uSTNKCAdI1/nGgPFEeG1j7x937yVrPPitLnW+tY2ILjxInG7/zHWOng1op1XZ+DhNQqYBKuQmYcnFEL3Np5LLMRcJ0fwCJCKzDq2E8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DS4PR10MB075839.namprd10.prod.outlook.com (2603:10b6:8:3ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 09:38:32 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:38:32 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 6.6 v2 5/5] xfs: fix unmount hang with unflushable inodes stuck in the AIL
Date: Tue, 13 Oct 2026 15:08:04 +0530
Message-ID: <28bba5cac186ebcda7922107ea63b0c8cce9101b.1791883285.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883285.git.siddh.raman.pant@oracle.com>
References: <cover.1791883285.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0134.apcprd02.prod.outlook.com
 (2603:1096:4:188::14) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DS4PR10MB075839:EE_
X-MS-Office365-Filtering-Correlation-Id: 805212a5-3fde-4ea7-a458-08df290dbe4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|10067099003|261009223027099003|5023799004|6133799003|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	rVLtAVRJYlh45P1ZzWyZBOjeytmWSG6ja0jJaWj2xP+kIyTE8Qu5+xG14BFL92b5iU8zFj/OvQmlgfP6LBEhhl+P/0hxDH+3yiaSUC0hnhg88dT+7kvCsG8j+/UMDAZ+FALGYtkMeA6MuQttKL3eBXgMJ67PgNpD7FgggWIOcasKWrPnapK4z7gj+z+gQWXtRC8eNVLKnmzbz+x/nah35uMUK7Q43gd7haJX9L1it9VRxahkzMccBk10HGkwfhg0EfubMd2oJmS3swYbwU8FGJSjbZLJwdH9kzZxhqD8x8PfxazB/A/v+gcZ60BnYWMGaKpCMPDa12VSyKK9GrycbKuvyOk1wfuHsi/1MUEmQNSxfdyMyuSV1f9ynjjkTR9VzHWrPaBZaF3aJaEMIbtG3VKzkmhHI2AoIAORT3uuI64TqYy9qJI/Rc/Na2VD7uuQxYCKD/1L5mxfgJ4kLEOmm6kj9nEeq/RXoeuTF7rNg6mUZCDRVymuOClvrkdnG+MC2Tk744zRqRrkcSvWB5/rXGL3b9XVNa/7FzxXsuVFmhm9ka694t8E/D+wWMkrxng6PWRaYvc/iBDWCBS8QMS5lc7r3sF9IYpodLfGq+LvhuTKHxX4UKvKrZ6hHVAJo7ziMggbVQw6y9dSATwUZeL+duPiAukX/VjRT3BdPQ8qh/k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(10067099003)(261009223027099003)(5023799004)(6133799003)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jg9VZICcZIa0hrdctVQLzZTDg/Ph8tuUgt5yhy7aZfEr3/W+DTN0nydsoneQ?=
 =?us-ascii?Q?AvPGX9WiIq0GCfn8VXCFc/wT7tSvPxaRxzbhOQrrhTjZ1WdIQWel21hTjzsQ?=
 =?us-ascii?Q?OaOLBGYcPhcbhKG/Cik/L7UCWqYpRo+iye1RJam0ZBNVzRaycOEaLRyQI4dI?=
 =?us-ascii?Q?BeN2ezoGtFoJWB0xsZEIYKWnUoCapaP+aVLtTB9KbBoAcjK2XvSMSoGZVXQB?=
 =?us-ascii?Q?Zj7BqP+BfOqWGSCdzQMqFiUMyaKuzZU+pnyQkM+WRDpGH4mUwxrf5lXNKR+V?=
 =?us-ascii?Q?/4iRvqcs0PTnCl+czvmflNqBFkAz8P/J53RUOOWk7ARz9js2tfj8mx9bn3o/?=
 =?us-ascii?Q?UCYP+E83yD451Jn1XqXLPbG435Oh6rszfBjClqWt6zpntITl+W3MyYdighAc?=
 =?us-ascii?Q?ULFl0QLgp3Ve1aRuf+nBOp6fWKD4xKXmpayrpZ7yH9BZPYU/uRnAshRKOVQR?=
 =?us-ascii?Q?pVPzfQep0i1X8ltEaFB0CmnXhZPtWHkxhnfaGuR5pSTKcBdLqow/gsITaAyO?=
 =?us-ascii?Q?dUhYWGUZPuuNIG9rG2P16+zp3Gg+Hh74Z1sZ31sp4hbI+A+1lIMNBY9wcV4B?=
 =?us-ascii?Q?rMzw7Llpy8l/P2+18QPuUPRv1UN/b17YdHKI4Fb+wqhX8Exw9nL3XJ0JWsrp?=
 =?us-ascii?Q?/iK7GCS/DM2a2A0WxNNtRz/QEGWp5u3mtBZcPesdANu0O1lmLpHRidpCjACj?=
 =?us-ascii?Q?fedwshFs5CYARockuSWk0DzzU0uGKPehv+aqzgGjmsOsbWxdBGPX5Q5uVuEV?=
 =?us-ascii?Q?4p8Mgd4aRpnEejMLwG7aUSY6M9Tys8dzsCDDDkivoUXh3Eg9pTVQiQNjKwau?=
 =?us-ascii?Q?qs5nLjeFzH8cYZn0Oi+6pt0YpwFjkCq5BDR+EgLmV1igdusWPtZ5ei0lFlz9?=
 =?us-ascii?Q?yv/qa1PC2uoCuEmIzAUinBxQzUB51KkKca938zvILD7tu+t4lPd5hR2dQFOx?=
 =?us-ascii?Q?WlAaSEsWSYvG6vHFKXgSGnjgisLHiUpiscNgDhsF7HtWfYm+9cHUQvCpAe1a?=
 =?us-ascii?Q?SosWhQRnqAicJoNCw/W7pGokcCgtuXoyDiSnPlZXIca9XMHYjk2joKWZn0o6?=
 =?us-ascii?Q?k3+/FvkZ0oG+H/0GJN8o9N9rkI/WCNbx5gsHip4Ofpbj41jXbG0TgoHNCe0Q?=
 =?us-ascii?Q?Xv7JqIGJzE+CQpKBdeA4ec/bExBC83dVn9Wosdmr2rTQK/cU3LV1EJAmpzqb?=
 =?us-ascii?Q?DaouwfKH0tQgDElLCxzdFpxKwE4tGPf2GCFxcad37NCXQNrVwIC0h+Fl9RA+?=
 =?us-ascii?Q?++cBnK/R7d6dI0pWcvVi1bqZkrhQpVg+5Oz8of0wqSTBlGpFjMhZoUEf4e2H?=
 =?us-ascii?Q?sCXshwGskdmE+BLo28v7fW9dhSi2UPhoEULM6t3gvhGfd32o6u5H+y0v9lsa?=
 =?us-ascii?Q?xvgs9aNCAdxcXOebpeoxK9Ng4kHAWEiNYNv361+P8cqosscRXnS5S+peVqaV?=
 =?us-ascii?Q?+RpKH7rFDWbNO5mA+9JrpOsLsM3hr7Xce4lLRXVh/ykMCBIKESTnKhlPNhwo?=
 =?us-ascii?Q?0ufpD/qGvl0p4quPN5IFalvBDmG5XK+VthuheYeT9/CYuiCdnrepjMIGcj8A?=
 =?us-ascii?Q?DZU12bNG6E1Qr6vwIdE8YcFfqY67C4WNlaMwP6q1q/NeT2fGaanDV0hBArWM?=
 =?us-ascii?Q?c08tdjarnWO6qxKd4k4JutUVTK675dAhQzm1usFyXlMJPp25wTlQGqyD+xK2?=
 =?us-ascii?Q?iGOV2tY2JLzt6mEmrMfmZStmOlXv0aNPYF4yu4Fe9hOY4h6MBrNr6AgmjsG3?=
 =?us-ascii?Q?GZSfNQOpBQa1TlYJsoXiLOa05mANBoD5drsPWSR8jxPlkJQIwzYzQxxibC5E?=
X-MS-Exchange-AntiSpam-MessageData-1: qxmZy3nsKutIfrYyuS1YdYzgeukZA8i5Exg=
X-Exchange-RoutingPolicyChecked:
	AWO01pTy8THc3wspCMYEGYowsR/9mwUu0dzM00qaKs637PgHL4UgZMK61QAFAC2pVEJJv7axUlVTUNKRQB+9eWAXKxPrplqbamrvUbtsZrWEouQZMoadLr51WwiGheQ6d7AbkD5jqI3tMNZBQLm2O6YHuzcR9NF2m6FwKBiVp6PD/ggQDjqHc3ZZvpuCDAgnsr/tZikuZ23CgsVjsHBGTht7pmJOvOWhym2TyfHUR3fHntPQrAqmGb9NlOCOWk9VlGi5TMRVK/xBAFp032mvz1EJpX//85K1sphz9NISIhKEe6rCHtLdf6Ll2W3g8CRIFh0tRGA801tEuZSlZm+Hkw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	g4mEqTzUwvhPO0rhfgxLlevU2UcQkbHoO0cnwGLIYQnGkeZgcecAbXKyKfUtkIyGI9teJapBCIp7oa0fhmckeSbwWkQDGiUTo1fIVzoT5uccNKA4ROes8rLdKbsRKQVSFyVyHxRGOlTef0AERZMQT96eBNZsSchZ+dQaxRzvfFxxF7FlmrHpwiOgWUjZC4nxbvZy1G+sZr+PAWf/SzcBtM6ypgPvGntw6FseL8BRP7Y3urM0tWtC5Bw+Y0YfD/AWWmm/EYcZ1ecAzB5naExPQSfV7xsNkHdVWoBbJgUcovqLelzgMGXzADCkNUEb+UQLngl0JNaLFvmytrB3SWJnlV54koWk/iJcq2JQnf+s4uj3u1vRrX8UDU6NlIQ/TXNfJTAwibxLnKJHAUP/0MZJgDgdRrcUfLpYEhluWQSCAQzm1AD8S/k/okNMckV6eYQ6EhT2XRFs4ciCaCYAzZJLP2Ut7XwPOfYcsvlrW/86l+Vvdox/K29rlB08SXply31fCD+dOO8hShZn3HnauNJ/qwQX2jf3gBIsO5L1FFZCFzpqixJAppVc3AH+imKTT06b65xtv9S3/IxH+0ppqdYvMZeoIlv5545Iqi54W1H3yZE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 805212a5-3fde-4ea7-a458-08df290dbe4e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:38:31.6091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4UUmxGFdLyhjJMtBdOQQGFXtnk4K6riDhudf9YFiZRe6fwkqaOnLDoFnk9WIjloGhTj9OT1wPzbOcOLUxIm6NyNcOveg2KBHHSXFSaRV5j4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB075839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Authority-Analysis: v=2.4 cv=O9SsLx9W c=1 sm=1 tr=0 ts=6acdfc1c b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=kGPDooFuvBrjL3bSUbYA:9 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12108
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX08gysaQFy57M
 SHu86GQh1ICQvGeGxLJhv5aD9YiZc9HpsQ06WEzXVY3N9KQXuI+u8TDc9EYxlQX16QyPSH6Hwo4
 jzJ06mIfShslMbNvAfNvyrSa41kbeOPbkEtXg4P4QmBY0U16zEOe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX4+XYwqkYB+h+
 Nl+2rQHyHGzDVJOETFlurr4xdsIXpR+m1DYr6AaGzhMpwxPYahl0AYDbmeYKtn18TAnCvtcH5+U
 sA5zJlIxvJshVPNrWPl+8j7SxcCvgON9MiIf0tWG/r/1Xa6dIb0J46oDfpI++DN+h6ldgBDPOfw
 dd+OXB6XlSAWvdGJhpeclVSQ0iaNQJXpAl685x6GvMUpm8E+1C/I7v7la1h6fXswEHItjg5tI2g
 gEB4EJeUHuu1YSDwTCA0UAnI/oq3CgCLEsbxOGutzT3QPIl65eQZtO6RRtJdGAlQ97kC6eW21NP
 dNuMB7lgeflsQURxOyiKxvylJ2gwLW7Pr+k3EZSELNWyT8NQD9kDizypck/sUO8OjdgAkV3uV6t
 IyhSPINY4VlZIrztM9THJKslVgEHoBjwYitAADuTOWYMra567/Qc8qhcs+3VthCOK3gtJLKOmxc
 JBTpCRY/cOtWn7rYmsylSMjeam96B74hrATGmFDk=
X-Proofpoint-GUID: NLbGRg7iUuqLhAA1p-efBfBhD0aSkgNV
X-Proofpoint-ORIG-GUID: NLbGRg7iUuqLhAA1p-efBfBhD0aSkgNV

From: Dave Chinner <dchinner@redhat.com>

Unmount of a shutdown filesystem can hang with stale inode cluster
buffers in the AIL like so:

[95964.140623] Call Trace:
[95964.144641]  __schedule+0x699/0xb70
[95964.154003]  schedule+0x64/0xd0
[95964.156851]  xfs_ail_push_all_sync+0x9b/0xf0
[95964.164816]  xfs_unmount_flush_inodes+0x41/0x70
[95964.168698]  xfs_unmountfs+0x7f/0x170
[95964.171846]  xfs_fs_put_super+0x3b/0x90
[95964.175216]  generic_shutdown_super+0x77/0x160
[95964.178060]  kill_block_super+0x1b/0x40
[95964.180553]  xfs_kill_sb+0x12/0x30
[95964.182796]  deactivate_locked_super+0x38/0x100
[95964.185735]  deactivate_super+0x41/0x50
[95964.188245]  cleanup_mnt+0x9f/0x160
[95964.190519]  __cleanup_mnt+0x12/0x20
[95964.192899]  task_work_run+0x89/0xb0
[95964.195221]  resume_user_mode_work+0x4f/0x60
[95964.197931]  syscall_exit_to_user_mode+0x76/0xb0
[95964.201003]  do_syscall_64+0x74/0x130

$ pstree -N mnt |grep umount
	     |-check-parallel---nsexec---run_test.sh---753---umount

It always seems to be generic/753 that triggers this, and repeating
a quick group test run triggers it every 10-15 iterations. Hence it
generally triggers once up every 30-40 minutes of test time. just
running generic/753 by itself or concurrently with a limited group
of tests doesn't reproduce this issue at all.

Tracing on a hung system shows the AIL repeating every 50ms a log
force followed by an attempt to push pinned, aborted inodes from the
AIL (trimmed for brevity):

 xfs_log_force:   lsn 0x1c caller xfsaild+0x18e
 xfs_log_force:   lsn 0x0 caller xlog_cil_flush+0xbd
 xfs_log_force:   lsn 0x1c caller xfs_log_force+0x77
 xfs_ail_pinned:  lip 0xffff88826014afa0 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88814000a708 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88810b850c80 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88810b850af0 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff888165cf0a28 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 xfs_ail_pinned:  lip 0xffff88810b850bb8 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
 ....

The inode log items are marked as aborted, which means that either:

a) a transaction commit has occurred, seen an error or shutdown, and
called xfs_trans_free_items() to abort the items. This should happen
before any pinning of log items occurs.

or

b) a dirty transaction has been cancelled. This should also happen
before any pinning of log items occurs.

or

c) AIL insertion at journal IO completion is marked as aborted. In
this case, the log item is pinned by the CIL until journal IO
completes and hence needs to be unpinned. This is then done after
the ->iop_committed() callback is run, so the pin count should be
balanced correctly.

Yet none of these seemed to be occurring. Further tracing indicated
this:

d) Shutdown during CIL pushing resulting in log item completion
being called from checkpoint abort processing. Items are unpinned
and released without serialisation against each other, journal IO
completion or transaction commit completion.

In this case, we may still have a transaction commit in flight that
holds a reference to a xfs_buf_log_item (BLI) after CIL insertion.
e.g. a synchronous transaction will flush the CIL before the
transaction is torn down.  The concurrent CIL push then aborts
insertion it and drops the commit/AIL reference to the BLI. This can
leave the transaction commit context with the last reference to the
BLI which is dropped here:

xfs_trans_free_items()
  ->iop_release
    xfs_buf_item_release
      xfs_buf_item_put
        if (XFS_LI_ABORTED)
	  xfs_trans_ail_delete
	xfs_buf_item_relse()

Unlike the journal completion ->iop_unpin path, this path does not
run stale buffer completion process when it drops the last
reference, hence leaving the stale inodes attached to the buffer
sitting the AIL. There are no other references to those inodes, so
there is no other mechanism to remove them from the AIL. Hence
unmount hangs.

The buffer lock context for stale buffers is passed to the last BLI
reference. This is normally the last BLI unpin on journal IO
completion. The unpin then processes the stale buffer completion and
releases the buffer lock.  However, if the final unpin from journal
IO completion (or CIL push abort) does not hold the last reference
to the BLI, there -must- still be a transaction context that
references the BLI, and so that context must perform the stale
buffer completion processing before the buffer is unlocked and the
BLI torn down.

The fix for this is to rework the xfs_buf_item_relse() path to run
stale buffer completion processing if it drops the last reference to
the BLI. We still hold the buffer locked, so the buffer owner and
lock context is the same as if we passed the BLI and buffer to the
->iop_unpin() context to finish stale process on journal commit.

However, we have to be careful here. In a shutdown state, we can be
freeing dirty BLIs from xfs_buf_item_put() via xfs_trans_brelse()
and xfs_trans_bdetach().  The existing code handles this case by
considering shutdown state as "aborted", but in doing so
largely masks the failure to clean up stale BLI state from the
xfs_buf_item_relse() path. i.e  regardless of the shutdown state and
whether the item is in the AIL, we must finish the stale buffer
cleanup if we are are dropping the last BLI reference from the
->iop_relse path in transaction commit context.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit 7b5f775be14ac1532c049022feadcfe44769566d)
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 123 +++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_buf_item.h |   2 +-
 2 files changed, 87 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index ade89a233e68..a5f3408e213d 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -709,43 +709,42 @@ xfs_buf_item_push(
  * Drop the buffer log item refcount and take appropriate action. This helper
  * determines whether the bli must be freed or not, since a decrement to zero
  * does not necessarily mean the bli is unused.
- *
- * Return true if the bli is freed, false otherwise.
  */
-bool
+void
 xfs_buf_item_put(
 	struct xfs_buf_log_item	*bip)
 {
-	struct xfs_log_item	*lip = &bip->bli_item;
-	bool			aborted;
-	bool			dirty;
+
+	ASSERT(xfs_buf_islocked(bip->bli_buf));
 
 	/* drop the bli ref and return if it wasn't the last one */
 	if (!atomic_dec_and_test(&bip->bli_refcount))
-		return false;
+		return;
+
+	/* If the BLI is in the AIL, then it is still dirty and in use */
+	if (test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags)) {
+		ASSERT(bip->bli_flags & XFS_BLI_DIRTY);
+		return;
+	}
 
 	/*
-	 * We dropped the last ref and must free the item if clean or aborted.
-	 * If the bli is dirty and non-aborted, the buffer was clean in the
-	 * transaction but still awaiting writeback from previous changes. In
-	 * that case, the bli is freed on buffer writeback completion.
+	 * In shutdown conditions, we can be asked to free a dirty BLI that
+	 * isn't in the AIL. This can occur due to a checkpoint aborting a BLI
+	 * instead of inserting it into the AIL at checkpoint IO completion. If
+	 * there's another bli reference (e.g. a btree cursor holds a clean
+	 * reference) and it is released via xfs_trans_brelse(), we can get here
+	 * with that aborted, dirty BLI. In this case, it is safe to free the
+	 * dirty BLI immediately, as it is not in the AIL and there are no
+	 * other references to it.
+	 *
+	 * We should never get here with a stale BLI via that path as
+	 * xfs_trans_brelse() specifically holds onto stale buffers rather than
+	 * releasing them.
 	 */
-	aborted = test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
-			xlog_is_shutdown(lip->li_log);
-	dirty = bip->bli_flags & XFS_BLI_DIRTY;
-	if (dirty && !aborted)
-		return false;
-
-	/*
-	 * The bli is aborted or clean. An aborted item may be in the AIL
-	 * regardless of dirty state.  For example, consider an aborted
-	 * transaction that invalidated a dirty bli and cleared the dirty
-	 * state.
-	 */
-	if (aborted)
-		xfs_trans_ail_delete(lip, 0);
+	ASSERT(!(bip->bli_flags & XFS_BLI_DIRTY) ||
+			test_bit(XFS_LI_ABORTED, &bip->bli_item.li_flags));
+	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
 	xfs_buf_item_relse(bip);
-	return true;
 }
 
 /*
@@ -766,6 +765,15 @@ xfs_buf_item_put(
  * if necessary but do not unlock the buffer.  This is for support of
  * xfs_trans_bhold(). Make sure the XFS_BLI_HOLD field is cleared if we don't
  * free the item.
+ *
+ * If the XFS_BLI_STALE flag is set, the last reference to the BLI *must*
+ * perform a completion abort of any objects attached to the buffer for IO
+ * tracking purposes. This generally only happens in shutdown situations,
+ * normally xfs_buf_item_unpin() will drop the last BLI reference and perform
+ * completion processing. However, because transaction completion can race with
+ * checkpoint completion during a shutdown, this release context may end up
+ * being the last active reference to the BLI and so needs to perform this
+ * cleanup.
  */
 STATIC void
 xfs_buf_item_release(
@@ -773,18 +781,19 @@ xfs_buf_item_release(
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 	struct xfs_buf		*bp = bip->bli_buf;
-	bool			released;
 	bool			hold = bip->bli_flags & XFS_BLI_HOLD;
 	bool			stale = bip->bli_flags & XFS_BLI_STALE;
-#if defined(DEBUG) || defined(XFS_WARN)
-	bool			ordered = bip->bli_flags & XFS_BLI_ORDERED;
-	bool			dirty = bip->bli_flags & XFS_BLI_DIRTY;
 	bool			aborted = test_bit(XFS_LI_ABORTED,
 						   &lip->li_flags);
+	bool			dirty = bip->bli_flags & XFS_BLI_DIRTY;
+#if defined(DEBUG) || defined(XFS_WARN)
+	bool			ordered = bip->bli_flags & XFS_BLI_ORDERED;
 #endif
 
 	trace_xfs_buf_item_release(bip);
 
+	ASSERT(xfs_buf_islocked(bp));
+
 	/*
 	 * The bli dirty state should match whether the blf has logged segments
 	 * except for ordered buffers, where only the bli should be dirty.
@@ -800,16 +809,56 @@ xfs_buf_item_release(
 	bp->b_transp = NULL;
 	bip->bli_flags &= ~(XFS_BLI_LOGGED | XFS_BLI_HOLD | XFS_BLI_ORDERED);
 
+	/* If there are other references, then we have nothing to do. */
+	if (!atomic_dec_and_test(&bip->bli_refcount))
+		goto out_release;
+
 	/*
-	 * Unref the item and unlock the buffer unless held or stale. Stale
-	 * buffers remain locked until final unpin unless the bli is freed by
-	 * the unref call. The latter implies shutdown because buffer
-	 * invalidation dirties the bli and transaction.
+	 * Stale buffer completion frees the BLI, unlocks and releases the
+	 * buffer. Neither the BLI or buffer are safe to reference after this
+	 * call, so there's nothing more we need to do here.
+	 *
+	 * If we get here with a stale buffer and references to the BLI remain,
+	 * we must not unlock the buffer as the last BLI reference owns lock
+	 * context, not us.
 	 */
-	released = xfs_buf_item_put(bip);
-	if (hold || (stale && !released))
+	if (stale) {
+		xfs_buf_item_finish_stale(bip);
+		xfs_buf_relse(bp);
+		ASSERT(!hold);
+		return;
+	}
+
+	/*
+	 * Dirty or clean, aborted items are done and need to be removed from
+	 * the AIL and released. This frees the BLI, but leaves the buffer
+	 * locked and referenced.
+	 */
+	if (aborted || xlog_is_shutdown(lip->li_log)) {
+		ASSERT(list_empty(&bip->bli_buf->b_li_list));
+		xfs_buf_item_done(bp);
+		goto out_release;
+	}
+
+	/*
+	 * Clean, unreferenced BLIs can be immediately freed, leaving the buffer
+	 * locked and referenced.
+	 *
+	 * Dirty, unreferenced BLIs *must* be in the AIL awaiting writeback.
+	 */
+	if (!dirty)
+		xfs_buf_item_relse(bip);
+	else
+		ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags));
+
+	/* Not safe to reference the BLI from here */
+out_release:
+	/*
+	 * If we get here with a stale buffer, we must not unlock the
+	 * buffer as the last BLI reference owns lock context, not us.
+	 */
+	if (stale || hold)
 		return;
-	ASSERT(!stale || aborted);
 	xfs_buf_relse(bp);
 }
 
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 8a8a46e698be..141c3780a36b 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -49,7 +49,7 @@ struct xfs_buf_log_item {
 
 int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void	xfs_buf_item_done(struct xfs_buf *bp);
-bool	xfs_buf_item_put(struct xfs_buf_log_item *);
+void	xfs_buf_item_put(struct xfs_buf_log_item *bip);
 void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
 bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
 void	xfs_buf_inode_iodone(struct xfs_buf *);
-- 
2.53.0

