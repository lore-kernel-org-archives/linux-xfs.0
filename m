Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2ED1D1743
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 17:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727890900; cv=fail; b=aLQvfd6ftuGzZKFQxUb8otGG7ddWZ7HCPdbwfIUfg0In47sxxJPP+/XooRRoOVVANguXr2k7ChN5/zfthPclv/lKT2Tewn+xOMlbEMYPg6IOHGTCexXZb/bCp/Ikn2UN7J+tH1k9XNEcAsYbA/mPPd/ITDmhKkhwwyWsD6rv0UY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727890900; c=relaxed/simple;
	bh=h+A3XjLW5V2in+XRiAX+Z6/TmV0YYYrjgg6tM43WXRY=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kNmGQcTOsENh8UtPRjL37UFB8YIbTfufdkR4UvmDfPVa+nQ2FTpSwlp04scmKFrbXymSMSoWiGw2CPdzDXRkK7OfUEaZa1Bh3busNmIUkUOIT43diCG+QQClyTbBexIccG5S+vthwxTC/XqnvFRDdFicUZMP5fxl3rbQPV+Y2dw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nzfPg3xE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=S4KN+qQE; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nzfPg3xE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="S4KN+qQE"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492HfbMo025722
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=ReTU5xy/PZ2n++XKBRUdtbNySBIwD/r8vX1vpCP53uo=; b=
	nzfPg3xEEJQ601Z3+z5AbEv7N7JmBv3Yq+dR1Wf3Bz0Sr35ZFy1gb8vTbG1+gkyc
	wT1dqtrwwKAW+CJoD3A42Uc4n0HUdnTB9kIsK6fzfC0mJCDaBP9R9nWwdWOc7Q7W
	TeERx0dC0SDSHiPralbvkYegcaaoqQ+FwLuA8uj2AJHeRwLam+ShVGQwdnNmdWbY
	3GyBcfrYM2c0DOOZwHHVLeKJY0xqYAlKANgxPDv+nfe09/+aeTP5A7XMhyHN9h9g
	jTibJJtjJNBQVtUkcwwunfGEs7EzJvs9swnxOA+Oox3TstkPIzU6ckiOGT2sLWH1
	UMcri3JlDxnQ3/jDe98dvQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41x8qba840-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 492GLoe6039128
	for <linux-xfs@vger.kernel.org>; Wed, 2 Oct 2024 17:41:23 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41x88977yh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 17:41:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l/c9tWfSBm5Q74szz2QfyVbTZJrj6wmmlJ9pMxgARZMGtUspljPM5FXh67+YftSa1nY6lIAOC+YU+JcxRvxaRhc6iH2QjGQzlP4n7SLq0DGU8/cx3gsckcAXa/KUv+Pr+GKca8Q+t6mMr/FrfbERQvEDIwf245tB9nt4Ke6GcSyhIK6wkOagPc9xDSYN3rN27yvhuC7DO/+BfT+KcVwnTqnE2rVAn7TCHvgjypTPw4PSguPmgTh9iJcBGCnRsz2J/72XUQEkMaBsNrJ3ZNj0/vXR5g+U4POmmJBR3bWkW6MS7JQPJ0JJzsEV8lBAP5cOZvwggQUOT5M/KlQppolZyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ReTU5xy/PZ2n++XKBRUdtbNySBIwD/r8vX1vpCP53uo=;
 b=Ks4xgj57ZSz1bcl0F5z5bLjWZPpsytYza0q2e1dS0hdRehhelZ2kf+hEuKhK8aAFEhm1fdbA5RD5QVwKMo//I0YyMl6boHaKlmfNbh2S3K1vX6li6QakV76amNKBf/kWZqgPXKW3qIccQaLK96CA4i35G06+I5K0247Ndt6gmpisTvYkBVIVlikjL5a89NmLmc97Kif7WlUdErKRKCpOUEVRFscw4p2oymbZ9u8b8yWlmI7FVL8QIKqLCOBw0UIzNjhM29Lp91yMdtQfJk2ObcQ+okP696Fgg8Qz94v2IclSvReOkqS5YXbLoRVKIei7KhMRZ3JDWGfcxFN0VswB+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ReTU5xy/PZ2n++XKBRUdtbNySBIwD/r8vX1vpCP53uo=;
 b=S4KN+qQELVPRbPp3vGiQrenh3H/Pw7pnquWhBh9/lyuWS+72+BVHo74Ao2Q8PUkxGvCrIuTcVJ/8SYesKRSF/we/eyLUTDPgPt7vjpnfV7Hmb340Z/aQKZnP3GGVTbJNYFBtSp3IKSYoXDOFPoaoaqwp4GYST616G3althBucfY=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CY5PR10MB6047.namprd10.prod.outlook.com (2603:10b6:930:3c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.15; Wed, 2 Oct
 2024 17:41:20 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.8026.016; Wed, 2 Oct 2024
 17:41:20 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 04/21] xfs: require XFS_SB_FEAT_INCOMPAT_LOG_XATTRS for attr log intent item recovery
Date: Wed,  2 Oct 2024 10:40:51 -0700
Message-Id: <20241002174108.64615-5-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20241002174108.64615-1-catherine.hoang@oracle.com>
References: <20241002174108.64615-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0005.namprd08.prod.outlook.com
 (2603:10b6:a03:100::18) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CY5PR10MB6047:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c95f3de-606b-489b-adb6-08dce3096d0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lOOQkElLyiizxTvCNTz+wmNSRuicpvC1z2xDrKxPU+rBmtnLwHwSYBfbdLre?=
 =?us-ascii?Q?4BkcB3EgIx8DxcD8adkw7ainMLQlQJpqGlXq/3NnpRHpmNNqLciaG4pyYW6G?=
 =?us-ascii?Q?Qx74uBQnaMeBVNOmQ9Fx3AS4gjz8ZuD9d60vgGxiNHtOlMDX4xhXgbtDMQWW?=
 =?us-ascii?Q?GIbgmLLnPige33xT9UgwGMz+s0ngtBL+dBrngjKGm1pi3TFEY73Vp1IMKTke?=
 =?us-ascii?Q?sIoRnabckAabvExwsdXu4l31/12gCB3VmSxeAUzKfUYTcmUq5PzrDMfsoLco?=
 =?us-ascii?Q?yRd9hHu/6zW+iMFoHOuII4obkJQpqO7FM7nCT0fABm5992SvJdzm9huk0P5h?=
 =?us-ascii?Q?cVfXXzmQ6QvU7iispnAquDCcWNCn8UDwDU8OC6mI+ILpFzzsAdoc+TYHztY1?=
 =?us-ascii?Q?CArEWK7nIPQONVse2uRCvXOcmmyKqhEXWSkCv+h5bDQMfDADtLHBuqNdA3eR?=
 =?us-ascii?Q?WvT7niClMoOrJ4qPYx1oSi6wVydWe2B0MJf1cqwOizNhfc3vYskCg9D3jUar?=
 =?us-ascii?Q?9qdKI4NTEEiqntaW3AGc0+pfcNij0RDcFDkdBDhTP4/Vl8po34nwFtJxRaeS?=
 =?us-ascii?Q?SeaZMij4OvVH8C/lWBljN9mTRtp9hwiRxAqmA0cCyIca3MO/a9UUeIfFDCgR?=
 =?us-ascii?Q?FcePby3diNdQ4kchqejqpPco2msTwDXLmQu68eG/khAjSWJGiaajO7cVyzQg?=
 =?us-ascii?Q?iVM12R4GKXfN00Ebj2i3g+bErbLa/5BJmJ9ZSuHJWKbSYKVG5YmrVysYqlkz?=
 =?us-ascii?Q?lvjUziCvuvoJfBSKkqgt4ekrFBQ4WV/z5kwTpjkxbEVu/DGdJ8fMq0hUsXCo?=
 =?us-ascii?Q?59LocdoASzysJhhHQ7kpvsoXG9RJemyUncMGhtXOJY+4EICsZjogiLpjNwZ7?=
 =?us-ascii?Q?R1Mxn3adYmnYBQhH76QOCGF6tHskoF3nyMBd9spbB+NhMiLBSDTMhUgMTalq?=
 =?us-ascii?Q?euY1kVWB1viixYhclzPW6d2hWG+eK+h9gLlIBqF9U9/bvS/4wweaW1MFH+vD?=
 =?us-ascii?Q?d3JkLQpq0jR7soogyUxhDjTJKGhsPs1qA1/uk9e8ejqm1LyjdB8yfKZcG4Ro?=
 =?us-ascii?Q?/gFJ+cGbeFxxxexAOlaeZICctjYvXf1Zq9kenp/P/Tk4mf7J+WQBjw68wNoV?=
 =?us-ascii?Q?QFJrXzQaIBo5CRHG6nKpmlQCS2i/bS79kMXNxK2VGi4jVxUlBF/toIqrYuhD?=
 =?us-ascii?Q?kkeNSLPY7SNp3NdSd6zsS/XtgaJUpP3SuTkw1YmJkKcKSRRE8r1MpopjtkGM?=
 =?us-ascii?Q?gm8s8QtCCE5Wsbjvw/swKcmU2BvxHOZmV3hfs7jRxg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kWNic+t4SMbtYNjeyDz26lI+nvQFvtiek5QDgXYX6onGLjCi98BjzNh5lSl7?=
 =?us-ascii?Q?8I0otBiZdaqZjIPwQVlsGDeVllpf+2GJO6ECIURrjSYGQYH+wbFhspIqCclr?=
 =?us-ascii?Q?SpMI36LTZ15IcNec07pqDbiqj57BUoogu7v3mge3/+DmBHdHrv3zEcGvSo2q?=
 =?us-ascii?Q?bmC3IO+zYLXCK120om7fPlkzA5yzuyPcG2Gv1lgejuuv72yF01EOGNlyKG0N?=
 =?us-ascii?Q?NvcHHRskoTCbEfkZp6uxfBB5f+feRz12EVI41lRlKntvEo9XaZkRU42nbL2C?=
 =?us-ascii?Q?jHGbQ/DEGsp2lzFUKqnlMhOTgnV4+Ox5jQ3NPwlfzQ2HYbwdGiUTXA8h6T+j?=
 =?us-ascii?Q?jxVj0BYdaLeyhcGtK72hXPOmq8WXZ+ux1rW2+3zpvgBQkt1TVkDofGXI4IWl?=
 =?us-ascii?Q?VwqnZ8zZ9Uv2JKKkhoy08uoj1yKxVOGVwefPTf3RY5zteZFlWCEgnqes5EUv?=
 =?us-ascii?Q?M0VSOWHWgdkZcAKFuJJJeAgttQoBLcSp6AzhBdt4TtpSjXGKCUhO/CoT2x2i?=
 =?us-ascii?Q?ly7p4p/K12OndKRdUi+0DzCjCjIp50A1/gSJSPWiDWm+AyMpCAEYDr7TgMGE?=
 =?us-ascii?Q?pUfS8LdwV8Cy4NaLM3qu/aZwh/F8FsdEtytuq0/2FQpl4q5lQWEGJ9A3XyzY?=
 =?us-ascii?Q?n8Bt8+iIcIr1u4NyjRntQwsCI9PAellfYomdc0SEi17QLA3tcy14QnjPByHS?=
 =?us-ascii?Q?FuNnoLzhviM7JdBMF1t3M1YGAh1hJGkn5B3Sb1PYOoQQVB8P/n/Cucr81yZo?=
 =?us-ascii?Q?nqyfQm1GFoxdyjARMhXZtKELNiJMnxYbbjb6ZQXXZsmqUwiXeg4MHqDShAK2?=
 =?us-ascii?Q?7LHiQhnFY/TmWROmaciu6GVUQo6ckY5TQEc7hT2u0TdLeZsFmvvGb7v+e1Ls?=
 =?us-ascii?Q?YYLt/kIXRi7YGE5+33YeaFHpN6z5WWsszCZ80w9af4iAqcdrlsM+iiWHYqOa?=
 =?us-ascii?Q?Wtk3gDB3EDeHzjvftPQ6LBf+Ds4AFMPIrBiHnLTEoIhxaPI5fWucHxDqcq3+?=
 =?us-ascii?Q?lh0Xbgz5FG/ZJJ1+W00pSQ/xZxC64Y4cKXTKzQiwjDf5TgzRy9VP+XfkWeaE?=
 =?us-ascii?Q?yhYf2e9gb9f+orBqaxA9dQenpx0Xv9oNPyECgxMSU07QFy5ur4hSU7o3B4un?=
 =?us-ascii?Q?71mkN2yc18n8SEZpTgy5wAzvZQiYSRBr6eACRNyjc3yeauZkThDl6tdWRjpU?=
 =?us-ascii?Q?Ld2WhAB4PMP6KDEjlxM0EJ06PpZ8Z9Lvrow65EdoBh9e21wrk0z5YNyzAbMe?=
 =?us-ascii?Q?0H9h/oa557yww+/jBczCzIgMW1NjyztGqiTUkXtUKAo5fM9QLvbEb/ytCPkc?=
 =?us-ascii?Q?vhqzaUZ1D2DeP2OCDK4khmSBnfO8gXdx68FxuNsolVSbJ9USJePtIYJhiRgo?=
 =?us-ascii?Q?zQH7ylUsF91clNFdR7SzcNssU15LuyxsGRTroYWhsPOp+onGjboGUSiN7+QC?=
 =?us-ascii?Q?QDuq4j6IGkcihyzfG0yHDI3D1XpD0/jvpyGVakuqULzjooW9GbW997weYVF/?=
 =?us-ascii?Q?3CmGExMybXIrgzUyGH7Lhs8ME41e1zXHaVIbB2f4tjOQUYtKQEnFhYlsf/5L?=
 =?us-ascii?Q?1id3KmyyB4GzQXyG05EHKAytQ6e+0bWA8QrUHJnxGRWBJv1fgv+ma6qFmBYx?=
 =?us-ascii?Q?1SQx8fM5GwKIC+v9MxZmpeYoDqTkt9YW2b0u5VsAl9J1xPOPF1um8fU1DNOr?=
 =?us-ascii?Q?Bu6ALg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mRKEGHP3bOoBILcMrLmASU4BW+0cT23fEGoO4ev0JKekOQeRBF1l8JKPU6ZEuDUJLeqjv1HCcE9dsrKUVquPK/19VhIPTzIXIcki4WgARwwv+ovABR2A95j9Zyyxowv9cLqUP+P0NX+ueHO/2sfkQ04G9/Jb4OzHyTtOCC8vavys0Oc0rHr9sY3Nu92MCxzeIxyPw0AOD1zcCFGrQ26KkXcx3fkixKBBl0E1waft1VA0W06gHPfx+JsNCEF3bS53iTnTot+apNK3Rq4jZY4/4mx2WquCnJQOaQVA/T/yJX/vb73acZ8TT65cduEtNK8sNwVs3tf0gCGyBFkgPyFnRPfttcyBmdxASQ6c/whCBbELrif/Cqbr/i55yEAfoe44RG4Mpb05FKjJ1KL5lYqVWfB5Cxcr5j0l/PJtuWifiaYvwf+K6qs9qn31tXc6vi1e0lkfS8J36R51mXz0ShE3B28xtMKoe61UY1H54tMYU4LG6wTSdUyn931i01AFBYBQPwWI+yDHHvXbJ6dHsXc3rVvlsAv+99MflMvdzVLptMhVM14s5aZ5ZBkRi8LWWUGyx4E88tdYqBEXg+qZ1tu9+Uaw6s38/4EC0OXpoIUqHto=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c95f3de-606b-489b-adb6-08dce3096d0b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 17:41:20.5086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mWIj6qIsKRnmB/4s8sPvHLqwI8j2gwXL73qT/CM77T/8DY2cjP3A/X8jHm2ttBHvTRV8KuLSiNyjE1M/KC9vXjmTLkVxevNyhKB4J/345xk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6047
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_18,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2410020127
X-Proofpoint-GUID: gHI1QMOoxbPGfsGAbu2551vdDhl2bg8I
X-Proofpoint-ORIG-GUID: gHI1QMOoxbPGfsGAbu2551vdDhl2bg8I

From: "Darrick J. Wong" <djwong@kernel.org>

commit 8ef1d96a985e4dc07ffbd71bd7fc5604a80cc644 upstream.

The XFS_SB_FEAT_INCOMPAT_LOG_XATTRS feature bit protects a filesystem
from old kernels that do not know how to recover extended attribute log
intent items.  Make this check mandatory instead of a debugging assert.

Fixes: fd920008784ea ("xfs: Set up infrastructure for log attribute replay")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_attr_item.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 82775e9537df..ebf656aaf301 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -510,6 +510,9 @@ xfs_attri_validate(
 	unsigned int			op = attrp->alfi_op_flags &
 					     XFS_ATTRI_OP_FLAGS_TYPE_MASK;
 
+	if (!xfs_sb_version_haslogxattrs(&mp->m_sb))
+		return false;
+
 	if (attrp->__pad != 0)
 		return false;
 
@@ -602,8 +605,6 @@ xfs_attri_item_recover(
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
 			 XFS_DA_OP_LOGGED;
 
-	ASSERT(xfs_sb_version_haslogxattrs(&mp->m_sb));
-
 	switch (attr->xattri_op_flags) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
-- 
2.39.3

