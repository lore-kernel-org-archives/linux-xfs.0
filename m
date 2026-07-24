Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC370417D64;
	Fri, 24 Jul 2026 13:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784900941; cv=fail; b=ZenVEsS3Vso4ASrgHwk+Yr4ZZDnjqd3FjyfkKND+P+J4rt0jNh4IBVszU7moAJJbdLNBQ0fV+DIPqa+GQgHT9iyyWb0RCzV0LdcHCWyhgiklQ4/A7pgK+XxZS05Om/Nke4hNyZ12aS06qP1O1XI8QbrHQFGU31gz3tflZ8gam8E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784900941; c=relaxed/simple;
	bh=o+4SjmQCZXr7jX3/ywiHiHAnX53CIPL7CCe/5UgC6PA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=U+kv9JRBf5DnzICHxqwQGxBJS5O3b9QujtGZqeTPAVS0czlhkbqs5g4nTRFm0Wt76eWKltr3tJ1g9edNEn6xhKPy3hoZfS2IodX1UdYMt9NmBtVBITO7J/RsMVp/ehc6nglGQpdrRSktEdijmXRhmUNuDWGl6HiSUZ8J5M4hKNw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FuGROH65; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ei/NNcUH; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FuGROH65";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ei/NNcUH"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66OCu0KE3393464;
	Fri, 24 Jul 2026 13:48:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=V49tfHkllca/6trNDF
	Ho6U/Dnij+wqFBejZkWlrX54Q=; b=FuGROH65QzWkm/ehQ5NaJV/RiM4l7qB47b
	GUz0fIBu9REObtI6V7iTu1sgv0S6PEJfHxz+LHBhtS1yFIYvFe6j/NjA2TKamoeT
	WyjkPoteO8NWSl4dzaco/clgsAgKUnTd4WCrdg3nzEzoV+LwMeVOv62OfcyZHqn3
	CJw+ezfFWB7NBaEyZafjCCacnFLg9WkUSll4kFwt7vLokLxgjmSLpfdp/Jthdq4E
	/mfqzkb3jUI/qv9RYwk2h9tAaIu/BQay0QCRuZDie+b+dRMaDDNrKiXpg365F2rs
	iy77BtjarGjxersJwD2+uhUIUFCDutmcGrI0ipfF23DmGHSnZI3A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fg1n3rhuk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Jul 2026 13:48:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66ODmcWu003321;
	Fri, 24 Jul 2026 13:48:50 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012047.outbound.protection.outlook.com [52.101.43.47])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ffyxt8mc4-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 24 Jul 2026 13:48:50 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WvrfnImgXRSFj85F5sVCP5CJAeuf5knKIgebtLlWL15Ej+j72Z/sU/iMcQp7+rnV90vONzNiCtVxxegbIzbr6KMZr4+8XcHyZGYNPTwOaD9l4zNFRq89tclj3DbxbX52CKrn/UuU9SWUzV0cf7VCV44yGTUY6/RsQRka8iOuedgCLwNjiRKpVeUuqcHF382ezhPSM84OD1AC/8u0XXpPB3ais8Y0eBuoCv47GcxymBOus7CiiOZ+DqhADmBc9uAfIOB5oiuwbugrzH83ao6/5oAV5C38rfgagvH5lF4OCjg8LlHkqNmQEX1Z61dSwHKelxHVRv3rUMCQ+RDc1lUeTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V49tfHkllca/6trNDFHo6U/Dnij+wqFBejZkWlrX54Q=;
 b=YMNK7exOodjOB2CwnJsF3w75cBKiJMxeLPBldGWgOqLvbq3u0h0oeLhCWuEsKbSbe/F3dw1oAOATbq0F4FkCgBDK2SBhiNX6IQMX4S2vrmz8Lr1fUkAzTry8GDxqhaeiWQy2QG5OnB0EJXr9C6hIcT7kXrBSY3VTQceVQIlKZEImklFSbDjI+g4kCMHyyIgKxAu9JBXjmdehfB0cIbfDET4Czqcjtl3IxcKrpCZuGTHw8gD9wf7H/BPJzZMIixv9i5FfXhOgC7YJRehN/lebkJ9r2Ljkqpblc76UGtCgzZgbnCD9PwI+GPRBg5ctS9XZQs7Lm8F03yc6SG35Pe9p5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V49tfHkllca/6trNDFHo6U/Dnij+wqFBejZkWlrX54Q=;
 b=ei/NNcUHWRKZLtAI1sk0MX7j75IE+h1yRIqLSE7UuuHGyAEombXMGdNddvBMMAkyrt5UWCaNwoXZEIKSyN8hV3lZWfyRDCUR1KN12XLupB6EZ5OGtsUi9Ot6auek6AN/6HEkHokRQjKiOA65oi4/pHYTvDbRSwY7TcAD9pUyAz4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MN6PR10MB7421.namprd10.prod.outlook.com (2603:10b6:208:46e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 13:48:26 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0245.010; Fri, 24 Jul 2026
 13:48:26 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Anuj
 Gupta <anuj20.g@samsung.com>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-block@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4/4] iomap: don't free integrity payload that doesn't exist
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260724051001.202741-5-hch@lst.de> (Christoph Hellwig's message
	of "Fri, 24 Jul 2026 07:09:44 +0200")
Organization: Oracle Corporation
Message-ID: <yq1a4rg33eu.fsf@ca-mkp.ca.oracle.com>
References: <20260724051001.202741-1-hch@lst.de>
	<20260724051001.202741-5-hch@lst.de>
Date: Fri, 24 Jul 2026 09:48:24 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0185.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:f::28) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MN6PR10MB7421:EE_
X-MS-Office365-Filtering-Correlation-Id: 86f91660-210e-4a37-f118-08dee98a3c85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|56012099006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	lsTaGrP9Jx1EY7qRBGly/RaTyVEgy+D/VPYUQg8q9hivO8+8H1bY3U75PV1AVoubGiTg5llxGUQELEBXccY4am3ytuSEI7862NI+x/mKILl3/P+seupmk4t1o8jeS6pJtksP017JIXyn1b0mNZfVly/NHEMAKggko2BKjg4Ui+CeqKHUjcqoqFfmp9KKHYZhJ9U5xDic20GK/SIFcF3xAmjU5kn818MKDtdzvR5+M4Y25RzRen1yuPJcaQHNqctFAuC5wzG+pgyTJAQ3PDzFNy75cnB0Qq/ZpH2B9mYYMFoQfs1EtWsORi1AGUfP3p6GvLVJ2+MsBNNa1CoFrotltvS5ibpFLabX6Obddz6PIsSpkNrplB7O1Tm9vhRzLT649VZ7bpDZs1tkr2pNphkRCyQUcBDAOAFz2f7IP5wVrRGUt0xRs5H1ZJxQk9CeOk/iuKEZ9Pa0B64BMNTSFlbGNGYDF6agyHO/deFqLcFLMQsC/WwoDCHCBZhwqejt7dMCurFehnhW4jTOHVG072aKy39d4UOQhi5Owf8IsCvtxL07LLd+R75RFaB5O2XKAv/Y9Ahe6+xZm/pu7t0KH5Rtljw8s1dH0v13+00eVGL1Ik/eXmrVKbbJxtZPaZLNNeCeg33AXbE4uzkK9JA2gBHHAJq4UMfWrB1W7iBJKoglTBQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(56012099006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?92AWOMVKnMNS3Y8VRipejvrE0dhDP47hCReqX48DliBvMGRUI7lkAMUg8i3N?=
 =?us-ascii?Q?vO8gup/QvN2JNv3U36AJuNyU0wJNwON+Bl9alcr6UjInIhaXwxXFFD+0NPU7?=
 =?us-ascii?Q?/ydp7mGkS0LZ5yiFZprHrFpI1/llFglkQWAdbQ3YSK75PI4xFQzD+YEnbmE8?=
 =?us-ascii?Q?undryPDaEDmU2VpRO6QbGIhb5p89JLreRNbHeL2/r/337aZtgi6g2KZ38TUa?=
 =?us-ascii?Q?iyGQWDPjYxBiA2iRWnAEI6i/+YwgpX73Qb/62dSwAa7yrRo8gbyjeEhO3WwP?=
 =?us-ascii?Q?9kgk51pTwjaskAUpHC79kZ1IIYhk7LY+gZcjL1uDeVJRU24Xc8Z2qTHN6cP/?=
 =?us-ascii?Q?+pQwGugEWY7Z0c8kSpfl1rNA0q+jIulzEMnfTXgd2bsrB8vA0PdASSq4Ht1D?=
 =?us-ascii?Q?/fXxRDMo87sDwzg8vBfiCqkGa6djif7fvhQS74ebDeAnjyIaXBZlncKNfeYl?=
 =?us-ascii?Q?ewRSxHyHUT7Umf9msMjCCC/seUTyxM2DwCcutgmVoL9g3Pe8lkyBDHgZTlOt?=
 =?us-ascii?Q?Kaj8C/WLCDIxqnQw2yM5HqsSuNHJ8e9drr6qJOqKZt4B9JFyLBASrwnxI+VR?=
 =?us-ascii?Q?7Ri3STJkc4C8yFsqYVW2e1ylqwVtZusB2Lk5CQig7shk6UUutc/tPsYrEHt8?=
 =?us-ascii?Q?VJXCshIUYzTmpu9+CLXWw+TmNFSnA10sbINSbIZ+55Q8vIzVYRjkK9c4ia5E?=
 =?us-ascii?Q?TQC3pzUg3p9NcbgPt37oc/TON6ogqGPivovH115Z0YpLsSyeTEXrr+kjvn81?=
 =?us-ascii?Q?zC3bRlC6U/nWJVyy1Y8uNaN4O7HubSOF0CCgnqFsRpEQ7wddtj4bb+rO6mef?=
 =?us-ascii?Q?V0hgt+O5QFI0fvhAOGkEu1oUNTIlq91Yt2IXrsUmSGF8+rFILhrL0nL3k7UB?=
 =?us-ascii?Q?4upgeje4nqUSfAJO4ZJrxs3JWc7Nfl7r5hWzuNCk4p4V/Z2n1Hke8NEvTP+N?=
 =?us-ascii?Q?7685yTRV1y+ZZU2CyvuRjiAbWhwKVA/k2rRp6I/IerCGGHAyvMuO6o4HWCkq?=
 =?us-ascii?Q?/1C2elrsaxtxMW56/kfHfV4YadfW8GtQFlv1cwOXu4n3WuwMvIcEOYCAulRA?=
 =?us-ascii?Q?01ND9qHU2t6ZVSBYo+1H1aRTIFl3DnkYHH06GUR7qYlIUJ8lA3QIFbZMAeQ5?=
 =?us-ascii?Q?nlvdYxxP9VR5xViVbzKD71mvBs4HMxgxnev2b5q6QKxTxFdWnbS4XkAvcm+G?=
 =?us-ascii?Q?v5pwLy3X9NLqZKx+2IgtJcngBErLvsJjst1z3NVRnYKcpxssaGsbLDrz76vf?=
 =?us-ascii?Q?QEDlTSV0V842ZvsVnk29hH2JxZt7UkOPx7t5l0YE5BjLxE09mVXSTlshgtJ+?=
 =?us-ascii?Q?IMFRpB2MQu3KQr5W+2YzUsCjj0Of/g7oLrmQCFYxUEAhxBFzmUzwrbIE8yHV?=
 =?us-ascii?Q?hBpITYeOudaa6OUtsm65WuKXT2zGkruy4DrwpdeA0l7XlsGPXlMgrhyBU9JV?=
 =?us-ascii?Q?UoZNeYhFc769OqFXIR7mwboFCoRezk5nH68HR5w6hNQKn1hF6uPRwP4VdFHV?=
 =?us-ascii?Q?3bF6EyOK6naSuZK0Tp0D8QoME7nQCCRpHWVvHRSn520hH1JPRpmvx6hDfOQD?=
 =?us-ascii?Q?vufWgpcrok8UsCQ9qFbaEqJuBQmRutuyTbGFdp2IYMFYfuo7vLSBXHilQHO0?=
 =?us-ascii?Q?8F16wFa3JQVu0v2A1B8AmKZkxix/XK0cdn+qeHRI5bQ27ii2OaRhJo/YbuGy?=
 =?us-ascii?Q?ecZWALu0CpXhXt0Y8jwG9pGFxZpwe3jJYph0o2N1tA2yWC6le6SkX4KiIHgA?=
 =?us-ascii?Q?iyHqzDxto/r3MAkfgdy0iEA3SenL25o=3D?=
X-Exchange-RoutingPolicyChecked:
	aOHVFsvy4Zxqo8UpiHgvpKxfpxjZncN6KztfYBAEMgwNs7mHJofGnCxM/72BE/AE5DuUidrZjYKovaEbfAWk9ycnn1iTPNbvL04T0p3jMdYZlPGx2/MqoLrHTcUen01fyd0HxQT5Xb058IB6zMvVQe/n+VLJO6xP5iK37CuyM14gHtUfufTXuburtdBPa/uP11ijTnbU/femzu6KvRrm25167/ZfGz/0ZJvj9/81cy6v3pcnOGYuoMccZobtQKHVxAJh6QcccKr4f1DhlHRBbx/vMW94yREGxp9EiPtZLIjiCt+SUFBsjr3u/D3OIi6vifcwKBTifHwC3Ld5uEy6RQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	69nrLPZqhELC6lj+I/YMcsj7vUA/rYva35aBJkrlNSxo2a1J8ueuOpM2Eugl8PqXn7X1hCz+0Qsf5PQ63iLzqLvBOVxEEZNO+hHdUiTPOz6m9xDV1GYnxxZW4RHxXy/jDIaEu9mCnBKbB7CrXh2aLDr2Hhi/Eog30HYVLOL/ZRd1PDScqYTp4Ao46sTaIfna/vXuJLaN395bwOCVh6BMQ18IXAQ6hnrDPIkeVTp22TRcyecie1MfC61LlgylMrK+yjnv8oYwbG2z04azDI4++HLqFQ7/672xAA9DdtnaXffl2Kgn1UIRQ+uTdWVxubrCYUfJuK0Z037Sij/G+lH1sGtOTxb0+dZkSD1TpYEVfZP3KRVyClj4AYqXfs+2zTDRubryAYWqLkcCMVla0ymGrVI0tjURtcrrsUywobz9QI9err4jGyLJuXj6QhBQnYsnQ8NkYriIfANQWektc2+KysoFvrDsoiEXg827FcaVngT7pJhxffSttxsNeU/6sjvInhUcULuYfdpNC+qSROAZR6lBuzXgYtncEEGxrrkmSFn/HlTqpB5yHDzNXbIsfY18N10b4+MiFuQ5i5a+5uTZs1BrDDguTFsi8dNeE9H9vS0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86f91660-210e-4a37-f118-08dee98a3c85
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 13:48:26.4406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o0gNE8HYj92CmsYNRZVLTJlTy4DATA3MnsENT9xt1V1xxq0udiwhX8RurKSW6udEvaFfntp1o1MGQMW8tfubUz9DYeUuAtlK2OM0LQYofCY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7421
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_03,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxlogscore=587 phishscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2606160000
 definitions=main-2607240125
X-Proofpoint-GUID: QWE1uJYAg4wyHVAkE0WaSnaqq7W5X0sl
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDEyNSBTYWx0ZWRfX0NcYi1wlX+HV
 S1GMsiPaNg3lNwwHedpNbKtDxZ4hE3ckgR6MPzIE2MznxCzl3o4QzhgPiL+8tOxPQ9xzpODUzew
 QT3uETil9wwcewGK5WPxHTjUs7DDvjkGRMlsk/I50RsrWlbjEl/x
X-Proofpoint-ORIG-GUID: QWE1uJYAg4wyHVAkE0WaSnaqq7W5X0sl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDEyNSBTYWx0ZWRfX8U6z6W5gBenl
 ORjxxo0nmldC5cuVy3Isth5BAWbEt17vQF9gODQnVh3CvzWWOA+FKcuByvAb1nNPZIg2orMqsb6
 Va6RTFZUSnOM93vU79Ie1CHIxYrrnWmOzTRIZBszgL1I7PtQW3jqGrdlWeNbJ8n1xB5bk35ZHqY
 euzRK7MWMOA5B4DbudYu6GxdxtDA51K5kwiFOPyD3CZnhhDKd/4QfqVK84+PZu+xglOomwo8YQy
 RTJOCcl6lT5CBzpqS/Oi8vhw5IEF5UyT5QVFdvIPAR768q2YNltjvGmHaZ7n/EekVZIc6cLRB7b
 dAwPobn5ebw6h5MCqdRc9apt/Fx5ebguambD56FtT7DvoFOkoevHm8ZsxMire1e6VKL2xtgt7U9
 KuRI6XLnrxuHaXsVxDazD5eVx9Luy6mV9a171Nw0DF8j98K0wJN8bP6rmWi/aKrDidDnKx6n38P
 Qek4PpQb41iKFkpHWOFJVDFGZDLLkOXYfn7GnALI=
X-Authority-Analysis: v=2.4 cv=PryjqQM3 c=1 sm=1 tr=0 ts=6a636d43 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=DZ7bR52ir9F2bcCfmk4A:9 a=zZCYzV9kfG8A:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12114


Christoph,

> fs_bio_integrity_alloc might not allocate a bio integrity payload if PI
> verification is disabled on the block device.  Check for that case before
> calling fs_bio_integirty_free in iomap_bio_read_folio_range_sync to
                 ^^^^^^^^^
Nit: Typo.

-- 
Martin K. Petersen
