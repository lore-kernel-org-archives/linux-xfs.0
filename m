Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C0E212FBF;
	Wed,  5 Feb 2025 03:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738724920; cv=fail; b=a28InQM6uDsAZaiW8M8yEekiSxfCOzBMShqP/srxC4/5z/gZ5PoNid3U5wUFSqcnE9PV3QUsn5qgAI6GbVo12iO0tmVxXWxMHPECZHI+/ba8ufBE4Lq7GCtma5gEH1guMVnmygEXt+TZ5sgEkMAl24XW2KzpX8swLbu31GDVHuE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738724920; c=relaxed/simple;
	bh=8yfv73G5W2CS1ze5jXpUlssemoKjyoZojsALl2OlIRQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=u/K5ncjgEIoIaVBqXKq6iOwybK5iDv6ADfyDj+ALky/IuyYSaEdxLP/Y55c6RlXnjK/LnA82A+cNpiAJR1nSdBNAbHwFo652/a3DgRYT+DPeFDAxnt6SGLbd+P59KdMnlkxFxx0a7rE1yxGp6QaGqoeJ5Aj1vExvaIw39/LSjfY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cKuXTyfI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MZF0K/Hh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cKuXTyfI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MZF0K/Hh"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 514NBrFP013153;
	Wed, 5 Feb 2025 03:08:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=hddD3XYH1Ni/S8vcR8z9plBikrCuxwJztE8KI/MtgN0=; b=
	cKuXTyfIiIRUoLkE3ez7bO8SZlVxqwU9lIAwrhL5vHjRUBSMpbymeRMQHi1JTeqT
	8dGIYV1TeNmcFRhubIAuYuvHsHF+98PaYbLSZnDO/oiaHrmzEEM07qLYyrpTTKjo
	B7qZ8qNdl/5HoqS23ElypKlF5Ajb7TOeb9brMEynzExd0ZTleDLIgslpDHE1SCjV
	jpK+/DvX2H66CSBvr5EwSukUkuTHvM8jBxKLnOx7DLVgbT/ZEI1b2dSz5xHyIHCn
	yi7xeFLzff9IJuWZuE/9oNqVNZljIdQVHdRfVE88c+h2czzmGIHZTxh41UScFfhm
	vwjz+VvcLiu3fgSg/d80zw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hhbte99b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5150akSf036296;
	Wed, 5 Feb 2025 03:08:36 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8fn1pke-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 03:08:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aWzOZjbmjj4zi/hCEHUy8o2SYkLShqNkiDgIiW3OsZNhqFqJ5RYRlTNJ24oVA3FkStRT9EkTva+RojYeOW+B5KrUDdD0km87ZcUYdTsqZq4C7Rlirjokf6j4JfXfWYMEuVFYeBA2q/l1IoIGVoxaEaxqf8Jzgna5rPWsib3BtKjDfPYHb7MMbEe2aoD1QlcHTBfm+I7bY2p+Fp2BabolJLk+Mf2PF3bQYxM5Bm+UlNfoaQtKMJlR7h+vcInnYA76HjF48xLe/DTlBgRx/UrrxvWSbb2Wu9jAao5xzq3nAUg49jL3X32g5upc2DhbvHFtDjhhLFrsRHC0PHZpbNbHeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hddD3XYH1Ni/S8vcR8z9plBikrCuxwJztE8KI/MtgN0=;
 b=eqbiVcv9Xo/Hgcb7qEdMSr2CVeFIfe3H1BvedOT9Azn6khLm1KU2PBj0jvS7t9rafcxrtrPHgsAIq5MVkWkzeqUgcSAcrWHws/o53BM7LekbUuEanuxW+Q+6bN8GAtdGZ4kPXz/kPl+30vjDswtVGvd1XuT0Es8kx5REkFRn7/0SGhfJtWBHHW7gPy2FrMQia8FskGvijH/4jOyh7p/F433UQdgEZXStaxILQLpG9PKqZxRCOZ1e9Cu8QsOtNxYvwH11WiYEylwh5BhOuf0k1Ce0j0jOtG+gSsWg8heXARWQUgzst5yd5N4O0pYE6t2NBasj8/mvl9/Mh8Fab/8yuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hddD3XYH1Ni/S8vcR8z9plBikrCuxwJztE8KI/MtgN0=;
 b=MZF0K/HhPCUIv48aGzBzG00JIZZPelq2Pm6ejCHSS09ihVTTuUyN6/DlOJ7hngkgaXpSgt4QrpvYt4Md1Kp1XWA0IU1ZzskyX+3CdvPCVu7wVIXB+upuJYBEDAj64CTq6LnRxpGIhODQ5RUGy43r14q4I7v5p0qI0pS6WX5gJcc=
Received: from DS7PR10MB5327.namprd10.prod.outlook.com (2603:10b6:5:3b1::15)
 by MW5PR10MB5689.namprd10.prod.outlook.com (2603:10b6:303:19a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Wed, 5 Feb
 2025 03:08:34 +0000
Received: from DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402]) by DS7PR10MB5327.namprd10.prod.outlook.com
 ([fe80::43e7:5b82:9069:b402%7]) with mapi id 15.20.8398.021; Wed, 5 Feb 2025
 03:08:34 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: xfs-stable@lists.linux.dev
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 22/24] xfs: Reduce unnecessary searches when searching for the best extents
Date: Tue,  4 Feb 2025 19:07:30 -0800
Message-Id: <20250205030732.29546-23-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20250205030732.29546-1-catherine.hoang@oracle.com>
References: <20250205030732.29546-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::19) To DS7PR10MB5327.namprd10.prod.outlook.com
 (2603:10b6:5:3b1::15)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5327:EE_|MW5PR10MB5689:EE_
X-MS-Office365-Filtering-Correlation-Id: f8f34d5a-11ff-472a-59e6-08dd4592606f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wjuWrhPSJ8fGIQDBA1/hC0weWtEhzW5jA+cMK2dS8ar4aVvcdglhJFqBxyRA?=
 =?us-ascii?Q?CCuXQi4LjIqsskgJhxbsI4TBq9HJOphFxeukgBWiQU6G1fCJ21eDsL+aRgYH?=
 =?us-ascii?Q?KG2s31OeavdTdNCINbmAy/GYSSvGr1Jn0uoAJ7Y9aaFBmws4HMEzy0ExoTOm?=
 =?us-ascii?Q?ovz0UZjJhjlsiUt1gmDvL7qbELeZJ4c7l8CF//dugUlF91uxQAYZeW26AOC3?=
 =?us-ascii?Q?amW3M7bFnm1bPvb1mlzm+EvRJC2YKQ6QXoGVQceMDOBeqEjinhLQaaGJwyjn?=
 =?us-ascii?Q?jA3FI6Kz9Qx2z8jBoI07ljEETMDSvsBa1BUNbUBzO/IWNP242hIQno1HZg3t?=
 =?us-ascii?Q?Xd2ouZzfs+B/zt3axAiyJfoa84YAWOdVyUvPQ6Q2NvtEca490BIf0Fv7RE4b?=
 =?us-ascii?Q?4b9Ssg/zbdw7WKUvfdG7iVUrD+svGrndbPeczlHxR2njYYmSHU7mOqtj2EPW?=
 =?us-ascii?Q?Smp+iCQxiU2eUeKjSQ9pHqkqcKy7n20PaJInRHXYELgI1L9g0JGyl5Dbgv3k?=
 =?us-ascii?Q?A28HF7JdDXCsyPeTWT6NUaMYlDSgCoK06PvSyZ4JkZLeud0LOEzSW0rGOEgl?=
 =?us-ascii?Q?L9sqnAN9valYGSiOTrAnpt6f0zjTUe1z1UwNc1Rg28ezR85iQ3bpqUN5XO0F?=
 =?us-ascii?Q?ycfRoQFcAElWvrXi0LGVMdzKyXoGdQU/c1dRIR8uiQ7TgfkQJbxrtEEPb301?=
 =?us-ascii?Q?rGNyesSOJKmg6R7MnIISqlM1XxS6RLB68Tq3tF3gS007L/y+Q8irUKnk4iya?=
 =?us-ascii?Q?lH+DV8+YIxd9Se+sKrSF6S436XvdUTZrppSs83P6CSPkfQai7psfpQ8EDYHN?=
 =?us-ascii?Q?AxlwQIvVwUAMGWG3CaawZ0ncbs5Yn2C0xaJNkcjABhpxr5Kyn3r7uR0G6Nkf?=
 =?us-ascii?Q?cIPKdj43z5XyhTZPzTK/xDoIoJGopMEsfISl+Xl8i4dNN87XdZ7Fvg52oIoA?=
 =?us-ascii?Q?Edsd833jSyTnbRzFMIOK9kwgOwlY47blWdHOz7mezaR2dSlefjAX1rNBC8Uh?=
 =?us-ascii?Q?30/LRAPbigQZtK1SNDrRujtOe1FRQZGl8b5+75zl4U2ecHw9srkJrAw3O3N/?=
 =?us-ascii?Q?GYDTYH9ilauhtCMl2L7WAXfGJAnV8dvyAmKYLbjUAXcYqWerRx+IiH3dueZR?=
 =?us-ascii?Q?9wQg70xw1j8ZEhdWcXPDeRB7yT5rEjRtdAqC7Ywcgqj/S+E0usTH5Ode5v6p?=
 =?us-ascii?Q?T5m3YxWiMpDObArBXelYMrq7Moi5O7SXys4Bb9tnlVHdYqIhvin4rLrbvFQl?=
 =?us-ascii?Q?cBK8tTtVfshEfSBQTl/yPkIXQrOgntBL/oltQ4CFfZOk9f8NN5ad2ZDpl/hj?=
 =?us-ascii?Q?ZBl89A6qD4eBYpBaNr1wc6E+X1nVjpDr0oaFjJcQ7Se2INbzrEFQ8P03Lipr?=
 =?us-ascii?Q?IzmAt4yolarOmkRGQ4b9jaHICEi1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5327.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OfHADGwKCjlwQzds12+QaWv3CgkUP5riD3m4UEQUYrm277xrV4KAEv+7L2WC?=
 =?us-ascii?Q?HRw6Qd9BHS8zWGSPD5Vp4+53yNZk1lMminM5oCCkTT5CoixWnsAQuAm7CtUd?=
 =?us-ascii?Q?HzWdzaMgIOXUB391MycNnk/Sn3fgHhjQsUW+3nyCBkSkCycmFA7wwnIwjQli?=
 =?us-ascii?Q?Cnf/TRaRfE3+g4s6FqcF6ZGgaCVafv7/c5FXXZkr6ahPPZAe+FjxDxTTVeR0?=
 =?us-ascii?Q?vhzmZ0eadr2NRUuH5bBv+e8oTZ0zmX7ZmrH7fBJRfv2Ot15m6Xt5nzNUVUSV?=
 =?us-ascii?Q?L+VoG4zJk0f+xGW1zlPgvZT8PdeHMkZDDraXOwURuF9JN347fTM63Rv6rM6b?=
 =?us-ascii?Q?dBeIws/K7KgZdfVCRYKgtfoTGQ/DvMU+ZWuMxB2/ySqrih/nY0o9s+dt/FOR?=
 =?us-ascii?Q?yCSyd0JkKbsZ4W1FjxGWWIh6HII98PtL9m44dCSBRUDg7C3lHCBFcIQu01ip?=
 =?us-ascii?Q?lfvMqGMmGzbQafKPRxO/MvrMeNGLQK4oJKE5C5z1Mzt8JpD1KHIgD/0EB77d?=
 =?us-ascii?Q?viuI7FROhtljUsS3KDkOTpLawyiggkXni1rmlfZ1nK73++VVJcrt6ICCbiBH?=
 =?us-ascii?Q?Y2m2V/ucJpI4gDntF/fXTBjj2bG5b/Hq/NCZ/EzXmBdv4JgTBLlzYnn2a0+K?=
 =?us-ascii?Q?CTcLoivqcDPhH/1g+brawEQBRma4OWCCkMDySvB+rYIF6u5lcoFZNwpeJ8/L?=
 =?us-ascii?Q?P/YNEJTDbucp7s8HIuvYbrwJKUH3r56xTCyYiDpEGkhDr+D+cxR2rrnBTNWw?=
 =?us-ascii?Q?cIWa93iA1Qq8cO8ZCA3Aqxm9iHCftz03rIbuzNQVVbSPIKmnJ7ch6qfw8BZ6?=
 =?us-ascii?Q?BBID2zeqNByuojui9nkqmIO1evfy8FEUmS6H7IKeapg+84QRNillFHX7sZLF?=
 =?us-ascii?Q?8UbU6gsX0MaeJfUajns0SxxqkhCTgZGFxSRrOjkNgo/O7Ch3KdiAKFKJSjmn?=
 =?us-ascii?Q?SZ3NKkHOyHEGBSnQTBnEf4pNIZtsoL+PCYlXuGdNES0p5RWbiAuPPLmrEYQx?=
 =?us-ascii?Q?QT7K1xZ8UPV5a/lr7qQUWa58icBqgyylkY3nlpc4fLNev5qjHoaLZaj5Fqr9?=
 =?us-ascii?Q?1cREJO3hIefPgsczbyscBScPsBRTTQ7Ad4qxWBXqG2NHHUhdkaAdADEXpTFo?=
 =?us-ascii?Q?3sYdlL+ihFbp9q+mww0gQcCRqQiDBn5XftrFssznA+LVZKF3zPuj0YRENcAx?=
 =?us-ascii?Q?e0nat2+k9f2Azr/NlmZAc7ajNmMH5fxha8G/kG41YCZnaw68y6dILhWS5sjl?=
 =?us-ascii?Q?oq+YB0I6V49AtVPOrqs08WHuonI7Qv3FQl6LyKABd/z5fhjuI3PxwI0VCUXF?=
 =?us-ascii?Q?9jYfEmAzKIFROc1P4TqmZfjiyCcyBVP2d1wQdfo3hfL1JX9V/tIQx4nmSht+?=
 =?us-ascii?Q?to8UUUHqJghhRyOcbJtMkje+7cwAxuFgQpcpMCjeyYu48PXjD8F8dXUliQN9?=
 =?us-ascii?Q?22ycjfxYU77LHyDq2cSETfeGN0vDWKnVe1xpRb3xAkmU75fU/+g4Cnj13wqJ?=
 =?us-ascii?Q?efdjxfem2jC2v+6e4JsrXLjMuouMBehwVS5eLWklDY4CPgYL8eiHfq4IvWvm?=
 =?us-ascii?Q?ir9I9W8KbQ3dsM4ezM3nHbIAnm+V+R2L/TCckEW88sCr09/c9AYkcjGmEHjo?=
 =?us-ascii?Q?Go0vFgBt4VGX0AqlQOH/gfnfBAvADXh53btib64+iKwHwPyQT+r/Rn6TetZT?=
 =?us-ascii?Q?6bZj7g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ja4dR7eSMhilZOvPoTvdpU4UzTLkrTaldzi4BbL9MbW8CDfvTpY0swANvsxrPDLyoeRZaF6Z1dKjYXxq71R55pBfpNkW24HM1XNOV1mzzfNr+osDZL1d7dt3kc72a627MP4LxW56Ffb4Jb68KK840bTCtuwb5p+f7thinNRPHoYRlLrdg3uCjtL+6d7YPa3QZFhjEvDBa7xWRdQlYSBnTlVOCE1HKdiWEljrq9O+AqFNH4rgxR9sKXK0mDqiaYYPkl1QNpkkZkkbtp0G6+ns3/9H7ZiqrXK6WmWxMX3AqZYuzn7/PKd7VDDXGm/3qboQz0yXTi78lp/NTcNzrPThkSPj/teY/oy6S/hmbz4EKGjNYkOHnP4p8Pp21oNHWyR76uK114r5Ucu/QF5I22HbYdSau6G/aPi6h9kvZNx/wlFfNp2fRpUUEHTEOFD2IqIKoHlNL8g/IN9br0XBnYLDNk0ia0xuaxJuFJt26rEh17ZW6jTTgKjfMLqfUhT/z3vWSE5HyKSMA5LFaPM8uurxoBydMZBDeOhx81dA70h7m9bTxIZegOoXUQNzBuygxowEk8rHxShJOq1gFOBjEHbHpxDzea8IBqUrvYh9K2j2X/s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8f34d5a-11ff-472a-59e6-08dd4592606f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5327.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 03:08:34.3229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GrFK4RIGDFLqd8QE6RWeC3jwgm+XG4+Q96fDVww8F4RLY+k2b3qX8OfZ5k/NWi+U29Cwr6DHFhDkNPqhmjsVJYvxiBxMlwKIPYYdZ7mQ9ho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_01,2025-02-04_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502050020
X-Proofpoint-GUID: CGq2OsW6IffEuF9_XFeprqnIWAFBz9Nc
X-Proofpoint-ORIG-GUID: CGq2OsW6IffEuF9_XFeprqnIWAFBz9Nc

From: Chi Zhiling <chizhiling@kylinos.cn>

commit 3ef22684038aa577c10972ee9c6a2455f5fac941 upstream.

Recently, we found that the CPU spent a lot of time in
xfs_alloc_ag_vextent_size when the filesystem has millions of fragmented
spaces.

The reason is that we conducted much extra searching for extents that
could not yield a better result, and these searches would cost a lot of
time when there were millions of extents to search through. Even if we
get the same result length, we don't switch our choice to the new one,
so we can definitely terminate the search early.

Since the result length cannot exceed the found length, when the found
length equals the best result length we already have, we can conclude
the search.

We did a test in that filesystem:
[root@localhost ~]# xfs_db -c freesp /dev/vdb
   from      to extents  blocks    pct
      1       1     215     215   0.01
      2       3  994476 1988952  99.99

Before this patch:
 0)               |  xfs_alloc_ag_vextent_size [xfs]() {
 0) * 15597.94 us |  }

After this patch:
 0)               |  xfs_alloc_ag_vextent_size [xfs]() {
 0)   19.176 us    |  }

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index d8081095557c..ad2fa3c26f8a 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1783,7 +1783,7 @@ xfs_alloc_ag_vextent_size(
 				error = -EFSCORRUPTED;
 				goto error0;
 			}
-			if (flen < bestrlen)
+			if (flen <= bestrlen)
 				break;
 			busy = xfs_alloc_compute_aligned(args, fbno, flen,
 					&rbno, &rlen, &busy_gen);
-- 
2.39.3

