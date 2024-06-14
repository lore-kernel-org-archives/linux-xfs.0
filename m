Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A7F183071
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718329797; cv=fail; b=jstz5MzVDEeAtB8QH6eIaBoU7JsaWxM+d2qFlogf/CkgXXdyeAQO6l20/Y0s+bUctiac6FvgCclNUAZ4tN81Fn+CitVz2mPBAp+4hGYk7BByuJhxfZqKk56Aplpmsl3bPTMjS7DskfR6v5DxJyVPas2HKRqv/0eHshIHcRyG/Bs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718329797; c=relaxed/simple;
	bh=NiqhRK6HPdixJm9Pe+EwRSGbvSYfutdoQLSb18ckYrk=;
	h=From:To:Subject:Date:Message-Id:Content-Type:MIME-Version; b=VObQSDAGYxA5wq62Rjl+0BFMuMMJKFxpN5SksED+cTXeJXBVBak3ogppItgy02N12oajZZZ9RlSOFrMZ7OAmjl8ILceWsIRqlISRsbsC88aXIDh+85VObNIsi2yiSFVH7BLlQz9B+e21/EmghQ60r7S2zE6V7A6pocPJOVqHVgs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bhCBTIUa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iLdONOyr; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bhCBTIUa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iLdONOyr"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45E1fQEc022828
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:49:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:content-transfer-encoding
	:content-type:mime-version; s=corp-2023-11-20; bh=MkdS3Paw6H++0r
	Y0NyGo2M1t6xdFSI8M9Vs6DwIoExY=; b=bhCBTIUaJm/KomdupezSjSjdRUrxrC
	GNxAHNHVZYX8k8G0pS3JGhREmCfjtpDei+rNdoRXA0B5M4BS/NTm9+3gDlxrI9Np
	v0BojnMz/h/S8nR97uBMLTsDflJoPirqFBQ/1G6jL/0y2Zd7rlP81m3a956wuqpm
	nxjw/2NvCh/NmlrGJ67fQxYbXus93Ft9cu9Afk2q+tUAzjlMRM+CCkBp13ZRd9Gq
	nsNAq9VSIGZyOL+jHC94sseors2CJ1XUaaNf3aUqF4Z0goMKlmVKxtcTLHRlyjYY
	IRq0UexFEwRrtmEZQJU/KP83snx20Q9+Zopp0fBp5DS0DrJSFR7sM+1g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh1mjs72-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:49:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45E05Wxd014231
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:49:53 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3yncexqjps-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 01:49:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QECixdlZBG7px9YDPK2PlZXBAGkNUBphQxn+Dz6NbvQbRwFWLBxxWywyQlCmZ9fe87aWfea3MMZBtIww6gKV+VL5k0EMlAlXsxyUagqfohxTqBofotpUfyOnvF83nptn/hdLDvYzSxZPenYL3VbQ/Sk94N+iFFv7thfpyz6v+Sb+lzczB3gu874uNqP2PP/2CIU5loqGaLeyTrN6Jzkk/PyQYqQNhURBLtrio0dg/9vPDd88wnrwBOHIDI9fX7/Lvz+R2f9TZRdy+k93T4G7rjg6K/tXAQvaMyV5KWbzfdRaHLZiu9gGFUnO4NN84ZxacPlLdjW902WS+76UoDMbTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MkdS3Paw6H++0rY0NyGo2M1t6xdFSI8M9Vs6DwIoExY=;
 b=lsiwZMhGK4fPVRYCFlXqkOHuqPWKilD+ZPDCXHDMnAhULdwn9e85lHdcg6ERJoXSqtp467WN9268eHkTkiBokTSYy+QRG2oIL2z8IsEB1raeDMyxZdBuKckzkupkii+IUREe1E+qnzHmSujqMKetbhMLmOtpROcCaZk9mEHTY/NArE1x6c+tn+8cQw4BVbQUs8PMg7cvx3QvDgu1O17X6bTAuO0jnAgyDtWpnc4o7eTqAGgprdiVKtXQaBXaFdi6jmojQdl6RuyiIdFOKaIbnwGzZD+/+MN4tIQ0exY/GOMhnvNaaCci7UbnvAU9j387dVS1oP3vP4F0ATLDgTLiFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MkdS3Paw6H++0rY0NyGo2M1t6xdFSI8M9Vs6DwIoExY=;
 b=iLdONOyrtbeTF1LEcSXrqY8gHnDL+kPEvI6WsJY6wp+XQY10MxBH7f3u47CJZ/UKq6G2WI4xplq/JrguHCkTDn9WUVL5G7clHqOsU9B67+B00y69T5CFSMZ2JotwEzD0TW3ZgD/yNYRxWEbmMPiiBnDTe4iwLCmbkvooxuUJL8E=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM4PR10MB7475.namprd10.prod.outlook.com (2603:10b6:8:187::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.20; Fri, 14 Jun
 2024 01:49:51 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%5]) with mapi id 15.20.7677.024; Fri, 14 Jun 2024
 01:49:51 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 0/8] xfs backports for 6.6.y (from 6.9)
Date: Thu, 13 Jun 2024 18:49:38 -0700
Message-Id: <20240614014946.43237-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0009.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::14) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DM4PR10MB7475:EE_
X-MS-Office365-Filtering-Correlation-Id: fcf0369a-cf48-4041-a055-08dc8c1447b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230035|1800799019|366011|376009;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?RqWMFaVk8sdZryXNTFDxBx7vJhF/Qi+qXwTVD78d2Fp8xXP9k9VCQcVqqtm8?=
 =?us-ascii?Q?SwrS1+YCRkrosNE5T/+NT5P0AlmcTkaK0zEEGVf1eSNwkblb2awDaBebtAb8?=
 =?us-ascii?Q?rhIcvApSHrb374t9AfVkhDPJwipJZ01eWoiUpJUfsWcuRMEsjnn+QpRF+1XP?=
 =?us-ascii?Q?zjOzwKHPef9HMcZ5rQqQb9Z/PBFea8lDJ4Ea35Cu9IFOaN3sDoAF9FILcAFD?=
 =?us-ascii?Q?NxOtX12abVGBDtQ4jQmSQst9i/7kPu2dSnrY7liEPQAPb6SfZz7s4RSV9XbR?=
 =?us-ascii?Q?X/XlyNUwVnBJkwJ9sB+pTb2tIM3JZtfiHDxATK5g7OQjS2hZMh4O0fyWddnc?=
 =?us-ascii?Q?79sgHTXp09/NvotYwmbUvUveQ/E0jDPA03K3Hy9dbF8qY9wOoG9vdXNI/2RD?=
 =?us-ascii?Q?0x1W940SbP71Dgg7BCYqRXksQTIGgSSKFMAdj24LtvEb6Nse8GtHpvKQjzs2?=
 =?us-ascii?Q?fLv7iJ6M0FmGdkT5hRsJixuVXFSyJe0ziWgU1pwAIgoduznC+gQ4MriFuXde?=
 =?us-ascii?Q?vR1XwAxNPTf4EpTrD4p8M+sYNICLwoKbfqz5Ct/Sjlk5iZ+GjbVJbj2fnK++?=
 =?us-ascii?Q?if4xwO2JcT7Cr6TUafB4zPxy2ibGF8xKXNiM6eYoiRh15ZosocvY2Z2NqzW5?=
 =?us-ascii?Q?J9b+6Wztc0OmvDSEJP5bXdprRBqMg4QwlKOhdktJtnGhnugpABnKqdOZqZ33?=
 =?us-ascii?Q?wnpigMShdv/kDUkya4miOlX6isoN8EKrpeDOuWM1Hd1XeAviiyBjLsVRTAFj?=
 =?us-ascii?Q?5e36ogZNgGAGqSqUWUCKAVZqEMvtglROhBZA2FQbKyxxDdBbblPOqFUvOv04?=
 =?us-ascii?Q?Ki2MvvmJLTbdWwfBtqEL5xP01ba01zybcbGl4aifjudDN/sXHIxbXciP9Eft?=
 =?us-ascii?Q?KCIWAKMfGgUWvkOQFAxc20Zp5FUlBeDeOwOrR1IjIKJ3vJ2vFuVAZ6oneV01?=
 =?us-ascii?Q?TWkEDISFVduZE/d3jk/0PqZtd+WjxEII6Enbf/M/nwAfZwFW9s/VmsBF6rXb?=
 =?us-ascii?Q?vU+fQdWdrEOWR+pzYLY9SEn73wdpVQyEnvaE1P0NAW0ReHTmAeSUTlE4hMAN?=
 =?us-ascii?Q?5ezRdmqIp/sldHGSWd9masgx9NChjzaTtBO0xOU2E4vKVhAA+xJli+O6d67v?=
 =?us-ascii?Q?QrB05aMvvjwnAKfmTWtQ/1iOXne/gAjCiV3ex9WJRTeWok+QQrElA8TDqc1V?=
 =?us-ascii?Q?QTOw+TSAoCAAUobdC4DniXm5tS4IuXz86UqDsP+0dy9fxNqMrW4UY1EPRV3D?=
 =?us-ascii?Q?AFHzT536edla1kfi6irdK8q2TBER+KFnU5VdCx3sLErwduOmn6TSuy/4G8sB?=
 =?us-ascii?Q?1tTiqJZkqa4g6Cj2Zwezo+Ku?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230035)(1800799019)(366011)(376009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?ooVsJVsaC47wYn0855WujcFzB/owa3Z2eil65J/ioMl2c4kkEEtC9XnkOxxt?=
 =?us-ascii?Q?famSrLMjtyrdEP9PN1ZJPW/1MM+O11gUXtHRA4heYrk9loPKyiYJ45YWQSK9?=
 =?us-ascii?Q?CWyKLq56OqENKut9cdp1R4uYBzhXm7RQ4ZDj4rv+IH3vugDRmawAjVyu1kFh?=
 =?us-ascii?Q?5I//kIqW1fU7efJ3742N7dfqvK5m6Jck4AlMztQgR7JoMmfUVdWmXNpopXHe?=
 =?us-ascii?Q?i5sNPDPik6h1yvkZEUwitxDNe7Z9yr78bIijZT2fGoS1yrU+uZwBqHpbKjYf?=
 =?us-ascii?Q?tRpSPNhK3PecxCTYQnkmFrrEFp/pnYacKPHhR/KYY7ubtiaHKDRcI/Yr5vAb?=
 =?us-ascii?Q?xpLqLoytfc4D5GnsD8g31JQwEXNciH0FpNkRm1l1XEe+60xFzn5vVAN3sz+q?=
 =?us-ascii?Q?g/9wpWxCkDy7HpunHO+4YRi927D+egR36Rrk/DEemiYS+CLKBnpu+scxtIPk?=
 =?us-ascii?Q?13cHF2Lg7WxkHuzk2NH+r6e7WLpaMefTlJJNKFOWroVaf9tsU7PEJIuMHapm?=
 =?us-ascii?Q?tPSi3jNTnuCV+iUpkh2xcqYvdRMUDr6Zcbw3xNjlg8eQcPbEPpwakL786UV5?=
 =?us-ascii?Q?+GA3vXMB9u4HwZRz8erJ+/J5IIsGSuJvZg+cTUQoWBYnV31QsYNwdJ/G8wbj?=
 =?us-ascii?Q?vmoUT98jCUIghu/4Kws0OkT7JUBIKsYCYGfg4AxbmnrG+w8lRjurImqkp3VF?=
 =?us-ascii?Q?xdG75toS4UolTt6aOd19/ZFMQTIjxJBsmKqrdQSc+k5bK+F85YGDyf7gMRL6?=
 =?us-ascii?Q?YtwGMajQ8k2Bm5yU/QioFrrXowbMUjIyG4MqMwZzf6Ct/bCdkWA1rimxSnVz?=
 =?us-ascii?Q?wiov8BF3RTweR0jNtPYrmI8OGJlOSwGz2HJaEXF18yGtAPjD2FbPIUJtBmF3?=
 =?us-ascii?Q?bpUyuNcUFEQiINSYpc8XuMs6jib4vU1cCYI9Ldkl5O6gWgvuH+jMXCh4K1hf?=
 =?us-ascii?Q?hB7gszyTfSQG69Jume+INW94Do3ATHLHziN8NXodeOmV3aUXNaM73JwfaMcn?=
 =?us-ascii?Q?ht6wmJOzWXO4FfBfnQnBcBIyoIE+lSSKdEnUZGmORzD/dOpUIIPDsT2Z/YmC?=
 =?us-ascii?Q?bQjukutM/zlBa1C1m9Mii5539EsxD03lWNRJRJONsJsO7hAXi4zj1bxME1iV?=
 =?us-ascii?Q?yVbKPStmJaiuTu2HE1z8L1J0+czIXmmcFACErbnBn8EmjTqAwgeCJRr/3mEy?=
 =?us-ascii?Q?zClWiYLgV1elzXiO7CIX/IhWD00f7Yky27giTHhb51+ci22pU2FCi1iWYjnB?=
 =?us-ascii?Q?7xwDny62l8AxAYXU7ITAlgWQEhu7hCFtTli6vAD4TmFE9I7GQmLbjaXGkoEh?=
 =?us-ascii?Q?41OJP2wirfKFYLEJO0le5NNnrEJdNin+uM+DDfTSFeF9OytJh9mZOmru8TMT?=
 =?us-ascii?Q?NYzxqlfJts9E8y461zXJx6uzYdynEGQdKPkpie6DOMD2/GmPdOJ0gsDItSwE?=
 =?us-ascii?Q?reVD8PhSFkcGTA+JuIBeUBUeQos64IoOOvdTsMa1z1Hp+xNwnktasGntLF66?=
 =?us-ascii?Q?vc+3M8tR52zhoKjUtAQpsbV6qTDaRgnpWjv4wFv09NuCprRwsKNKTbGZGNlY?=
 =?us-ascii?Q?OZaWtZZO+0GXX3d1ijaj3l68UUo8fl5OAXcCy++v8JfKL5bxi+G3/zRMsOg2?=
 =?us-ascii?Q?jhw9qAcnFDq/KzLakSPyE8EoA4vWTHRmas/iXI1WS6grI7kM1/O7T6MSF4EZ?=
 =?us-ascii?Q?D9Pn8A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	HLZSL5yID3rQJWQuuc39D4BvpKPYsMpBYOkEq27PmXkszgy0W9q/XxLJrka3jXEu3k4tkhzSxyvYr6P/EKhHyUovQKoIhZ8vSiMvhbQoEzXoLPrOlMeo1KKNyY8Jnf98AWIALlvqsXkJa8F7/GhYpvWH4V8oF1cM5G4Ba7TOsbIMc3fYmmhVppp7ZA7+rCXAIR+zpKN5skJxkLOZsmzV2PZIe6Jlnu/V7IblpWOV+6HOPplxMJk0aQXYdWMxGl11SaRYnx7HEOEeCtaRobv8p/YqpRKJglmmvAEhjbXFdnQEhktpFlHC87kb2OcTmWDWu3vna4i0JejRpW910fqpjJN9keubpPSSyr/lOC6N+dzqCMoZJpyokk9NgCHa8X7B3YGllkY8MJmoy1uhaeaL8zCyxpGAe9rZBXRcXQArpEIIYkG/aEnQ1mgWUQ8Qnv9Xo9tC1+BoRJeLqPxsRQZSTMI9Xov3mz67i7U34j7AC2AjcnWSbjDVP+xosq1r8irjKh99coWZgPJYAopPQ1GcHgOuZwSiMvOul0w9UNFAqo3hPNbnvOa5BIDO0thnpiBbSLyT2zS3z0whqIJZKrx/ytnIwY5+okBkJ18KL8zimHY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcf0369a-cf48-4041-a055-08dc8c1447b5
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 01:49:51.0796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V+yqhhIga1MQGoXBIdYz/Ji6KU5JCY0h6/4lc+1ZbZi388eSKY9KMA8wEqLeiwL1LVcmWEfsZgOf10BJ2rBq0K4iO65tcj6tJ00ft4Vcs/o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7475
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-13_15,2024-06-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406140009
X-Proofpoint-ORIG-GUID: 1k7bnwv0RXGp2QGNdQ8zE_8sfnswK4fX
X-Proofpoint-GUID: 1k7bnwv0RXGp2QGNdQ8zE_8sfnswK4fX

Hi all,

This series contains backports for 6.6 from the 6.9 release. Tested on
30 runs of kdevops with the following configurations:

1. CRC
2. No CRC (512 and 4k block size)
3. Reflink (1K and 4k block size)
4. Reflink without rmapbt
5. External log device

Andrey Albershteyn (1):
  xfs: allow cross-linking special files without project quota

Darrick J. Wong (2):
  xfs: fix imprecise logic in xchk_btree_check_block_owner
  xfs: fix scrub stats file permissions

Dave Chinner (4):
  xfs: fix SEEK_HOLE/DATA for regions with active COW extents
  xfs: shrink failure needs to hold AGI buffer
  xfs: allow sunit mount option to repair bad primary sb stripe values
  xfs: don't use current->journal_info

Long Li (1):
  xfs: ensure submit buffers on LSN boundaries in error handlers

 fs/xfs/libxfs/xfs_ag.c   | 11 ++++++++++-
 fs/xfs/libxfs/xfs_sb.c   | 40 +++++++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_sb.h   |  5 +++--
 fs/xfs/scrub/btree.c     |  7 ++++++-
 fs/xfs/scrub/common.c    |  4 +---
 fs/xfs/scrub/stats.c     |  4 ++--
 fs/xfs/xfs_aops.c        |  7 -------
 fs/xfs/xfs_icache.c      |  8 +++++---
 fs/xfs/xfs_inode.c       | 15 +++++++++++++--
 fs/xfs/xfs_iomap.c       |  4 ++--
 fs/xfs/xfs_log_recover.c | 23 ++++++++++++++++++++---
 fs/xfs/xfs_trans.h       |  9 +--------
 12 files changed, 94 insertions(+), 43 deletions(-)

-- 
2.39.3

