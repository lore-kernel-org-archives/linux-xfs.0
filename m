Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9139141D239;
	Tue, 13 Oct 2026 09:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884465; cv=fail; b=eie5yjuMotwum82OmBJmk5NP0YGXiAQzt0SJdS1nSnRraVBxEmib6SUinnbHOUiwWBupujMt8HnZ8qRBn4TMgrsXJfa4xXRuVioDoAKa9mXS1N/S/ZgPU01bxRSPiihK0mka5HhFcqZXfApVfvcMGKwBG3EqtUhH3U5X+NQRt98=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884465; c=relaxed/simple;
	bh=SppN22fDh0kPZgpBHiDaDUp90wDhO9cno1gesPR9zWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ANjDIjmnfSr/AL7RhmsLWQ17o47GIViemXt/1+O4uJwkAaH40BfaD1iIOI1H6CmFf/pehyRp63IrIiZ6n8I/GN7t6CDa8KRasy83vpZNzz/2sYMIV/yD5MPJt4nYRM9JvO0UH5hM38VVIlXbH9j8L7oNATpvO++wFpYH1DNKyRQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Y8zL1GMo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zzB+udCB; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y8zL1GMo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zzB+udCB"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2BxpW3198121;
	Tue, 13 Oct 2026 09:41:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0/tXizU+1Y2jeTo7M87SSS+bAdXFfjUhRoctztKVTks=; b=
	Y8zL1GMoL+H1HAR96LM5wf+nATIZkObhUz1ELJJjL3tkDDHjje8dhuvIwDNi+BYD
	cCkkNkSWXJwbgwpa7rfkiYFcM5VDJdIKu342ME7I5KJ7aqWVOQUlwS688syM4ugI
	ILC7Lgay6GtEzNnLbX/CPCYThq6wT+8fRdjkV6TeCRQF/y1ER0Q3CJHGtdow0SoY
	CPnFscqUganO/9HdW2elfR65Ip78DgWVleKXdqelUlPZB20HdWOUgFLulbroqbsy
	6T2y2RmgUl/tFlFsJyG37bYTEbFJJuiw/6N7tZw0ou93OMN88ZPpP/xUffpYRcLH
	aNowqT0IgBjrW9BXmkVVCA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dcsbqqa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:40:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aiBK018230;
	Tue, 13 Oct 2026 09:40:59 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012058.outbound.protection.outlook.com [40.107.200.58])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btp9wdn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:40:59 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JL5Y35BJjOya+hw7muIaNPJG9glh5pBQKaSfHiOlAuwXS5zMsfWaemf4Cs+C0zSxtt604JyecvZ1rywSrnUiBtdrOkrG3vOk7onw9fU6R3Sh9Zk3XhuRiIJBJ4+40915L67l27akMuFeDZ2ixAMDfFj3gMRNOFNUwyClO0jrW8q7rTxeZYRtxuoCTF2JKjQVqFqvoLeTqE3Bq7h0qxKUpYmL/iKgcuq8mJqEyMpTY5+Y+jA1fsw/+ceXQKgRZ0+HNuT4aF2El6u0IeAzOwvEeMIhW6qdK+AUxi1mpnmG96ecUAjSu6mSpuEHPd41oHAmHstpqNqRX6tdLhh5VR+Veg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0/tXizU+1Y2jeTo7M87SSS+bAdXFfjUhRoctztKVTks=;
 b=Y35aeJJG/MUBwHny7KycXNVYLhmUhYtT4sk5tCccxzNk+6AqaX8S8JV2LO66s8R+KMIJ4ZqyVI15cSbaVhsCLYJIZmjTyU3BIWdk/uqpu6MZ3ZEo13XdtVdCYudV+cZ68rtI300yUnu9BSXfNJdB3vk9i///e9XWpvyDB8huUvypvwcGvEObq81c5xcja3iO5fqRjFkHaYqRo+qe4ognuSmARPTIWTCombvtheNPJz1cCPY8Ru3+NtU08elj2xfmSBadPo+F6HkOwMRygiCCkE6iNMfNDxLz9sB2cXA9FX/wi1QkfvxF1X2ppqH1ThZBx4HlVySrRUKITLFKBSB1Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0/tXizU+1Y2jeTo7M87SSS+bAdXFfjUhRoctztKVTks=;
 b=zzB+udCBzNiPmGGFQnrpBmzjPUHVLxYSCxT3OIjFQHWD7xNZSpc9D4eCwUW9AfHOkCcaZgvsBdst/cO4HtcEbBevIU+KJaY18VEjKllUvb10gg2KVBAXJawwfwLq52jHADDGLdjO/4J2LT/jyt1uY380tW1bxkeLXgBXzOj2ueM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DS4PR10MB075839.namprd10.prod.outlook.com (2603:10b6:8:3ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Tue, 13 Oct
 2026 09:40:56 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:40:56 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 5.10 v2 12/19] xfs: fix super block buf log item UAF during force shutdown
Date: Tue, 13 Oct 2026 15:09:41 +0530
Message-ID: <ec10ce6303ce6b38d2a1615de600f16bf8e5f8aa.1791883301.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883301.git.siddh.raman.pant@oracle.com>
References: <cover.1791883301.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN4P287CA0078.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:26b::16) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DS4PR10MB075839:EE_
X-MS-Office365-Filtering-Correlation-Id: 88b88a3a-13ca-4411-ea19-08df290e14b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|260925021911599003|260925021311599003|260925022911599003|10067099003|261009223027099003|6133799003|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	t1VCf+InaNcZfR20DI0CMBR7EFZdjwAADLLwkDRzmHXUVyUV7wSeuSg0yYY6K3bv5qqSisdpQuMp+lLH7rKNWPij11R8HTf08CAjodtvfwl3TY6IQniGhwjGq3Dj/al+elO+BLqIFrIM7xwV2VnJQyVcqOzD9LEKxNjeacKMgEkQX6RzOTbD/HnN+EAyrXw++ahIfchg0HCj2NhckbBRuYC84Ipth6ltpYvftZg2BYjyfURcSRFoHCqkj3a/H6K9nslAAkSM0tQJlGMthW8LRHe4gEVzqoK2pHtar/iPuLMIPxCFwh791/e5aHcsHUCFf+mz7gc0Sp2TWm8x03J4cfxbe/iXmAYNeFlBnPr35PGS8kxoW7iauAWZ0yAjMpJ8u29kvKrL76BHyeTBF0Hy3IZliAQ3YH55bs6VPbZ9AmZEM+OSbx+NKwDTy1tvBpJxRC1GFKTHCpQfs3SaelEoLLZ1Dq04VD0VYAnpejxPhJfrQlZs3jKraxONSR9Om1xqi+w3mQD/3YLskVhQFTjUudVvubqyvVlGPdJUBUTWsC83yO23Oo9WiYwd7vhK1WwDtxuIVBx7rqrV1cEFH0OGiO9NnlOCBIZFwzL0hAyGz+wiTaaX9Djs6TrbE3suWZ5s8myHrq+1U95zRKCG6wbolxc3XsIZbmT7b9rYeiuHyI8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(260925021911599003)(260925021311599003)(260925022911599003)(10067099003)(261009223027099003)(6133799003)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MixTZsUtoEuYx7acejEeFr8FmUvpKgtpQZEFuLo7KhDWZNkdnNKGnkvEKZZy?=
 =?us-ascii?Q?bXRkBmK/sJzFn8gK5vIjy5k0DmIw2ZxmLVEfgb/EC3UNgUg+TP0B8ud4/wn7?=
 =?us-ascii?Q?QKaesCfWflpdKSjST5PwTEmXe/kDa+Ys2WCD2UYWDA3uGMxZret2uYJ9Rfqy?=
 =?us-ascii?Q?21WmIbOjpUH+C0il11IFNoDon2o5MR6tghKsUtaBeJ840EQduLyNb9Y03D57?=
 =?us-ascii?Q?Odh/R69L2JtGhTkdSe8IEd5IC02xc1sod2iHio9I2Ghj/jYB337vHEo6Vrpa?=
 =?us-ascii?Q?A0YbKW9qhKIM9Rmph4VmPvc5D8sXosv2ACz5zU6H5XaacN4qMjciyYmuElkE?=
 =?us-ascii?Q?BWoV7dq333FIWOXyIfllZENSZppIIOH8FXEGuTxR1UfTI1j/4qUSrXb6g0C0?=
 =?us-ascii?Q?MCyCWICoGKWH6d80tOTgrgVgu/kjWhgMwO2aP3WFRmrcQXPeQ52E5yLlkEpM?=
 =?us-ascii?Q?1AW8LdLJKq2lsk0PzBhl93SqznSqQyhEOBcNgtodIhOjJWJQ5+UqZqTD4wuv?=
 =?us-ascii?Q?WpZSV4LaWHp3bL7AQ+L50aYUM5GEykhYAN05ev9ZQV+zj1dRzyP7SLXQ/xQb?=
 =?us-ascii?Q?whzPgLLgB4MI0BVYaBKnwlnvTVqp1w4cUZlxq1fLbphuj6yyT9mIcF16eqMS?=
 =?us-ascii?Q?QzZAJUf/kqGs2Hvxh/I1hrIEr7MnPw0audPD1FP+xBMp+ZbUHRBlK3o47vFq?=
 =?us-ascii?Q?+1qPEUMU6Bdcjl5y0StaRpOSfme6AkMunmE3ZekzVjINua/zfBhRX3QND29W?=
 =?us-ascii?Q?dYgsSHJQpO/9SmkOm/5XX5sJHcx/Od60pUSwohIFzEEf1IjR9vM0r0SZbxea?=
 =?us-ascii?Q?M3+5mVanaUXis2uJVVW0qkDAkqxYaGxhglpKEsPYfL2hyFKf60yzh1RKS7Ji?=
 =?us-ascii?Q?jH0PCijHFpQTrfc+U/Zq1gw1ueeziSEK44xIg2VgYFBFU3HwJb4wIRfxOgHx?=
 =?us-ascii?Q?W1QDZC7X1NEv6jKIdZte4iK1ADEoOEJPpfYxXGauOeP11ENQU6BunPcR8ygr?=
 =?us-ascii?Q?Bt4M18NR1kW4PJ+Qs7gy3zSMF7P31ISeUhbKkbiW+axAMrkOPP6UlM46YCTu?=
 =?us-ascii?Q?XB38BkJMMW7XbMEa63uSmxxO9b3N1hKtIgP9h7SyALbnpw/O/6vkHabKtRFm?=
 =?us-ascii?Q?d5/tUZ3/YkGN+T5bsHAMMBxmO88BTo+tgpDnL4Wys6SiHGTGaT2xbVi7O/5L?=
 =?us-ascii?Q?v238REmltPuXtdqoiymBayIIEnamT1CEEoK6LK7mPDiZIu5CB2AMVcltpbMr?=
 =?us-ascii?Q?2Na7ylO6aAd5h5yl0emEMfC7/i1F2HSbGR1gNwkyZhVJ2RcXXO+8UuyrPQlF?=
 =?us-ascii?Q?XdGNp0uWYNaydgr06PmA2W56Q4cDppRye27kMVQa35sOQmvXUPq8qBmOjlEZ?=
 =?us-ascii?Q?LLK1mlcP/wvW9X8uqoR8Vt1dgEUjU2VJQ+4YZzNy1Id5h0ibQDwFZ+OqT1EA?=
 =?us-ascii?Q?WuWweULoDrVsPaoOfQNNwgpNmABwphczlZJ9nQB+xVa1OpsWAS5d5ya5Y2DQ?=
 =?us-ascii?Q?5Lu/SgvGgX/DOyNBfQw+7XIR/H5K7JvvvBv2dnvtTSeUKiUUrTLAC320AYya?=
 =?us-ascii?Q?Jg0y9McHYVc33XgvBaMMUPNoHpH8flJp6xBt1wVE6sUroF2HKbB4D19Qw/gb?=
 =?us-ascii?Q?r88+9VIfODY7CyK/z6D5KX/VPzRPJYeWpYwB3JaA2xzRugFL+mD8sEdGURIa?=
 =?us-ascii?Q?SF5c70nLMMPJNWY+AWDRyBDJR9mlvgbBCFNtDoC/baa6KCIKylHXY1eLPdK0?=
 =?us-ascii?Q?N9LR6m6EmrJwafG9UvLmnwrEg9tfji5r37DdSVe0KVC514BoSgGHNBmx1ewE?=
X-MS-Exchange-AntiSpam-MessageData-1: fLHu7XRj9Yndtes3bt7N4I5+xrxXUFPfdho=
X-Exchange-RoutingPolicyChecked:
	nKMPjcOK/rfNtYSLjthRjHR2v6DZ1uh5OHLxONhWPEPf4qkBilnwN9FAizHUZ6e0f/2QYxr3hRjM44WoyV2RBb7FDj7By4oHJdYPPuT53LnkWSZ6r+CajuE0phqvUONUKRut0Ov0kOpZqmFRn0A0mrUOExDKqMhB1IWNbHfqEJAOi66cjAod6s1CDOL3M2sCF13kn1+w+c13uKSiW5kbJ7pbnNX6rnja27qPdWmqE04RC3O0mF51Py+9v/zet9H9eXyEDWDaxMclToOPfyXqF5CDg+gjrDESKVtirJPFbXfv7rrN06botBtTcnbY294+HVSiHtWadxev2UgmxoTN+g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jvciFlpKOegC6DG7HJHbG2qbEU1XK+1G3Mef0SW/0IyQTPdwGYcRD6rLHTpK1U2rOPKenJ2ko/N4QOpnQKkNReEcPT3ow+V+NNfOCocEM80doIgUfqoLUDb03Q9dm6GBtjhybAnAXOLnRoZUtvpkrxGVQwPWMtIU/D1pl59UpI+UQJ3PwVQuxT9Ns5cAlmHZ63Z7l5mwRnh1ZeWWDGAbk/rry6rDF0yX18VrgZN1fHU0SEOqg7HzKYad2GnF82LLW4WiTAmfM1FtvCWwydz6b8AQLxXuDjPwL0Pfb6y6gx8w1nLEg/iDtfS+GsyPpk2UQ979b4aeccKkPZ4NFfyBy8OjmBSa9vtE1H5ClFkad1+23mpSgp5f0xQu6X7IbVx9D/CyTE6xmURe7fhNyTgor+RLkHzK4M6zcx320JwKGXAg5WivOhv7dgXOGqSWJv9kNyAy8J0ELTBIaTNmmx/cjrVrTJuCxFwu+wDdEkm5zqhNkTilhbH9DF57Q6tG2HUbhiqEIBu37WFlq6ntio81LqVzBTbWiitIxU+EnB1arMvROOvcsXHLeJ3NUBnhI2iCR9IH6jnDUhJWs88O32sxODZe3YVtznAm+OWkjx+MWx8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88b88a3a-13ca-4411-ea19-08df290e14b6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:40:56.5603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7wajgWwar7dmad/BF48FZt9Q0qVhUZCikCR+ZkZpUkWgSwd0/5/sZDeZPXYfsCKCPNLdAUbjQUeN1wmssyZEQ1xCwaQ+qcounlzUUPrc6nw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB075839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX1DKd/buvuiYL
 Dmi4BzN77Kvaqk79CmjC931sx1HlY8f6z75ka9UDNoaeN0mEBPKeHCrrFOz513p5gUNK7X87/T/
 ylMZESm4F8hOxhYi6AvWCInLfvXcZpagv/zK5JVP5wsTy+ZOeB4M
X-Proofpoint-GUID: qTornIav8S9UldrcDGHsDWwKgaOzPG7Z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX5NPumord0i46
 L6MUHvRHh8Qrp60d9FxN8BR+UUp73ZmM2mRhhaeZToUkxJFeZde46xmbf11bUt8ClJJPkCAoZty
 H2opxDzA0uosjoZpQmFKa2R9EXmH88+/2+E83abZ3w+KMTe3xB0QvJVhWi0yZkOe3YRx4rLeCvH
 qRP1diFmRkHHT+OvpL4I0J8mzqejU4aRcjpmd2DeW2R4zFf+xy8g17Mg03NZl652MGkyEqURJpP
 dhV24y5KjqGLyrkTPzeK3zhjnsYiWUk37YjdUg/PMzlg3/g6HjvKMOE8UBj9XizOTAR5DNfSPVo
 UFUJB5NDNaxtZyUuo4ZnXaflg+vevmCm8BDvQm5IY0cEup3wiyAUZJ4wPQkN3qwuKUVTNzrgfMT
 y80aPUah6frumfmr1s86V+6GMYkbQaet6WDiK81EPlOo2xQcM4decJX49g+HJP2GBepgJ0Z0V29
 +k95iuoj1IdZXGsSvRkV2sOyZTvi1m+CulO4/tqE=
X-Proofpoint-ORIG-GUID: qTornIav8S9UldrcDGHsDWwKgaOzPG7Z
X-Authority-Analysis: v=2.4 cv=EdZd0/mC c=1 sm=1 tr=0 ts=6acdfcab b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=ag1SF4gXAAAA:8 a=yPCof4ZbAAAA:8 a=X1hi7w48wxXEZvHpCekA:9
 a=Yupwre4RP9_Eg_Bd0iYG:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12107

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

