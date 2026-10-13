Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092CB472085;
	Tue, 13 Oct 2026 09:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791884313; cv=fail; b=lnWtFqASjGiwZ9KRP0Q7lfb0f8gm4WJw6SbyO7xuadsuRBQSHam9qvLzILeHnqZ0PsVpZ8TzsOfYYcmXxeCIAfVtutBlFbvbITvB0w9m3vaPkYzMUzcRftWwgaeOCGby3Z4gnqWs0PywWOZHnQvIm97Pu1Ipv21NZJUGJQfN+vg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791884313; c=relaxed/simple;
	bh=aNgLsvRCaD1d4TkwBeB31zBaaeHCo9cbNtReMoJBL6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sIUHN/qzx26hezwR/CkpN6sGZzZw06fu4K2p78PIpjpDN2t1/WfVIkjB/RDwIZRBoaAKKWb0UXdcobJp2mq0632MElyt1Ac8l2+Fie1BorzBaiIvu4C58g6lJiygVUhpLgbdGpWgTpQUj5t5U+zH8iovDqxFUNUky6nLM44xSPk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ld84LL5a; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tF0W9wGr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ld84LL5a";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tF0W9wGr"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2C4NO1440146;
	Tue, 13 Oct 2026 09:38:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=tL5sw8oUbLykhy0mWXiC7tQz9pbwnDxV8bDuz8MQZws=; b=
	ld84LL5aMtdjDWdDt/ZfCwal3RkP+uTgFwWyFFQoUWGfR3CFCnQ09hIz1w9/rgEa
	rpBztBYdVIbiJZjUC/ELitljTtniAi8lxY4B5f5mmvpB/xxp7jZaku0iion0faAw
	ZHCBG8l5jhdAikqejnUjYke8ddAM2QgGTavtiHF5P7aRvYkiZX8yZKTi2JI8CFru
	X8O1xyCM+reuWhHsp6EF1lVSmbutMGZnirnaEyAPEy024UrdT1JY9XOl3RFhbOhC
	rt6VSD7F07nBZ8zy5yvF4iLrs2ci9P5Ty+JIeBMdPXQd8/UBZNCeGh4j3Y8mKRDl
	xWvGAtgohUm7BoaMpw3/3g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7df7upkf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 09:38:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D9aScx005333;
	Tue, 13 Oct 2026 09:38:26 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012055.outbound.protection.outlook.com [52.101.48.55])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bta2bk4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 09:38:26 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yq+O2pJ/nOy68ERbzx2ZKndMLHXnDqfrUBHlfCWbtiL5TyxAcn9cHTLzkbs0b6FBHlpNQoBn5Rmcf13fWKnxFOUz/t87NwQFvrOCc8Ugib1T23yFsEjofEypOi8rjKqRY4W+U+B0w6ZrLw4k7//Xf6gnMKg1fk0tTrAhLe0ZokI+zicGeao43ZC4B7lPcoua2/mTYnHJeQU1MqYfxS/fp9yRoUzCVFX+vecm10k0rpVH/5muHLXmDllSNzfO2pg20jcWb/BhD+l6NNAGIWAbaVWjCMDTYyvJ4EuRxDY27VvgfA5tcztzsHTZP4v7wxvZaw7lRlbb8gIhOdiAUHLwPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tL5sw8oUbLykhy0mWXiC7tQz9pbwnDxV8bDuz8MQZws=;
 b=d39E1g4AIKcuhOcbvV5GKt8d/JY1socNjIHT57XW+kc/FgxpPEDY16t0ZAQ0e1BOIbKWiPGY1H+b4zIRbjmGYSACHrqe+7JWM+zuaPCL90ctttaEXMzXqtMKd+K+fC+jKAs3FLKc1EjMZ3ycfFEAx2kzJHiJPUeaRGqMAczSbOLYH8HakKb7gSjQuAW9UrfCGj1hnsMf/FxIDB2HruQOy6PkmWr+bLkJelHLlDFFC0f3SkV7T1demDh3An4KtItFMhP6b+kYVEnXeksUHge9aFlgVglasWD1MxY3wufidV07wcbUAOQ70O8NaAY9ceTV1FbxJ89Nd+QQ7iioYr5r5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tL5sw8oUbLykhy0mWXiC7tQz9pbwnDxV8bDuz8MQZws=;
 b=tF0W9wGrc358/anpR+ie5OrPt2tFQyNucY2LsAVGzuCCiJGuX3j3rp7bzME2EzS3f8c77B2E6dHZMGw1Z0sm0Hr3rRgdVOEoXiG0iAAf45q8vzhWXdJJEA72GbTr6/XnumT7miTzIxnnmkeun9PziqmK9FLycBuRsigJtPQxb/A=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 CH2PR10MB4392.namprd10.prod.outlook.com (2603:10b6:610:79::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 09:38:22 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 09:38:22 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Mark Tinguely <mark.tinguely@oracle.com>
Subject: [PATCH RESEND 6.6 v2 3/5] xfs: rearrange code in xfs_buf_item.c
Date: Tue, 13 Oct 2026 15:08:02 +0530
Message-ID: <35edffeb541fe1a04bfdbfe956fe3e5157ba3ec6.1791883285.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791883285.git.siddh.raman.pant@oracle.com>
References: <cover.1791883285.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0127.apcprd02.prod.outlook.com
 (2603:1096:4:188::7) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|CH2PR10MB4392:EE_
X-MS-Office365-Filtering-Correlation-Id: f6f39fdb-6ec1-4e90-01be-08df290db906
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|23010399003|376014|366016|10067099003|261009223027099003|6133799003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	luikCfIq91sAVp9Z68/EhrLTTUlRWd+D7lMpKZbsWwILSjZ02gokrEn2NNehjsVtebg7ZsM0MNZCrUitZq06K/vFW+wt0whivR33JhrNnPlqoNwOM/3xPhhK/iR5rLXsS/9DOKYM6L1MZtPzwOF8P46JtlBPHlhNWOutJE7sXB9rmtUx+pvGJ+YaHEswex4ZzeCA9Pa/L2wwNg6tbWH0qgpSotrFY1PGENe1APrOMXzEvysb/fGjPSp6bGE+FveTAq0qoNkesYNaO88T4ZFDnC+PQWlj713+H4DdeoLzU2rAaEy3y4zcxHeE8oQ/ihp2k+66oR/vrALllQOwiZ2fUzhIzq8a1plgGy7zArK85KuCAQCIxXmEMC0LsKKzehp4bwqNIR082LmI4d+DVcxb5Ea0HSjE+apejhiKl9DUIoGXtCWmcPtUdO0WHJjZNARJgILcIE9hKg6WaY1njtoRaaB068rC+LVcuUF2gxSEFsExBhpBNsBwL7RoUIYFDixyJWOxSYLYIurBu8QOTwhvkBU5d/WZ53RLWpPuJF4anX8ieCou/m+FFY/ydvm8sTRMYqHyuFIzGD2mV8WWcrr39OL6NVaiWjduZ8wwRUC/4aQjLDJTkaDXXpFa2uLndr69KnwOgxMtvGr/iFSlOGR9QhTsK3C1raM23+SJL2U0x5s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(23010399003)(376014)(366016)(10067099003)(261009223027099003)(6133799003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NhBAV/Y+nEfKQHHZ5hgS9bcZQ63PTZVUdcMhiKe/Qz+c5JH5gKwwxpU9efGG?=
 =?us-ascii?Q?xraj3e9wNFS/bgWtBjFO7yguY0PFnDqzrbLUnYbJbNtwfMOj5I6A6lRPnW96?=
 =?us-ascii?Q?tog+ta9qR+YPc62QBxTFXTnp0HaPLXqVrWxbZvp8At9HHrokNb7ZZbKyiFDT?=
 =?us-ascii?Q?h4aCFJH8CN/5bHMMofXUrPOje8LdU3nb1fCkwj7BLXlgvE56TGoVm6YIdSLd?=
 =?us-ascii?Q?HNsxYJHb8VEi8iIojUu/FY1kqgrxbhF/vCeiX3XHph5Mm94W2fxexbwJgT7G?=
 =?us-ascii?Q?0VMJzJeiKpo4U0iOBH6SQbPHpnCZ2EwiA0uJ8ygY+cNNBPfHud81L7/mgU94?=
 =?us-ascii?Q?0h3Vw13jXzl6QGWu+QlSq9a2MmzcgWasLTWU9kIakqZQinaUSsg2/7UJXtE3?=
 =?us-ascii?Q?eu8w+WkueQwJyeX6mwO+ebeDattbFGOv8DTNnlUZVql13ZDoG00rj21pyE++?=
 =?us-ascii?Q?8G/mNzCIahfWmbKaMJO9uy5LObktQKWMzM8oklHZjb/rwubsla5VEmoFhqn7?=
 =?us-ascii?Q?CHgE0wH1nJhjb+nKZzjgqoX1KR5bsUFekHlRp7fX3qxfuzT6raEOyG/viooz?=
 =?us-ascii?Q?rzmOLCE7O1VWyzVa6FYTRhTfC0FWWpasrKHi1Xz9PUb7tqvBMJBxOy/EUpVD?=
 =?us-ascii?Q?bKJHyvBLoqgos8xeho0j9GgQSADDMiMarH4Vjx4y/tY1qIKjiugfJ5/Ct20M?=
 =?us-ascii?Q?LvYXSpsHtQgYym73Gyn206zkRtxA3Y/kbq6zadzEhrJaOIxvZhi1LJoEnw2d?=
 =?us-ascii?Q?RGRVTAhBUwzROCq/0Lyd/d98hXcUSkYTOYuNI+16UlNTjVrw+nLgOTV3CiCE?=
 =?us-ascii?Q?FdW8ojMyFiSVxj9rapcHWjVF8/AtXcEZHs/xktT727yHUEFXXa4ecfiPP4P8?=
 =?us-ascii?Q?YjfS6C/oF3feTPA5fl+KK+xifGP3HFe5BUVKAv1MmjOe1FKtdbWGM3vKHg+0?=
 =?us-ascii?Q?guRERJwWs7AWYNiW8mF5AbCuMogaMEG0Q3OHj9xmMsSxcxvXG0Jhk7k+H2di?=
 =?us-ascii?Q?dLhWP20ge8SG+i9sC0Jf29OwUV9FUzyHKD1fkgpSo/AR9kuzfG3tMdURQZ3Y?=
 =?us-ascii?Q?EzdyS1p2ft89pnQ2HHnIYjiDwDc1vvCeWEkvhmVPCCiH2PbW8tNY5qRMoFGX?=
 =?us-ascii?Q?5ej7s0oNLFyguRSVqdKEJZEWiUaG6tXFCo1AOMnY41teys+Txyy/Y+QxGf63?=
 =?us-ascii?Q?U0EPu1iOaHZWItO15a3hlvxm/7O2PJYrL2I1U5mTDMsWaa4WWGPdukTBWC2k?=
 =?us-ascii?Q?iR7BaOB8I4TrFb7Klgd5CsbhVeWYEr+R28uh08J1VjjoTpISavfY//+i9iFk?=
 =?us-ascii?Q?Vv8mvxmxNJZSuRz2QuSOeK4kTJsy6ouZ0fX9DshNbXVpLgvE5bItSRgMvreW?=
 =?us-ascii?Q?ROCp/4SRyS7brY7eHiajH7Ou3ok4Q7mC7+DFoPlM9gEVYmt3HQTJsMw1JRAN?=
 =?us-ascii?Q?+fujl6y02aAi9zI8Vkb9sRZ8nWDLd+Kq5YVsUPgOAunp5VAkrwPtvnKpJDfb?=
 =?us-ascii?Q?DofZakHscIpxpd3Io2Kmk2y3Mnk2tUo2jSa0e0F9o4r1ajeUwdYLYYmPilcn?=
 =?us-ascii?Q?zUsP0NasB9op4G5+istG4hUjY+jfA/PF3KVu1Gmy35HPAtQwLExnq70zDPXN?=
 =?us-ascii?Q?bcon+/9EUkYjnhnWnWYXUBMseMCt+2Jg4wF+N9SBIkIesZ4dnZEIDUdeMQg6?=
 =?us-ascii?Q?pbjaGlmckwjs2zQlemImbnBv2Fxbh1DvObiDLtBz5zTfajD7Br9mDvq8nW4O?=
 =?us-ascii?Q?paADQB2DdVlj08D9yRIEbb5Hl2nvDl7llUBKJrFdkAz0LcMhjHBaviHD2j1Y?=
X-MS-Exchange-AntiSpam-MessageData-1: mutjNNGgYjb9It3JwQUvDYR0SYiGU9VeEqI=
X-Exchange-RoutingPolicyChecked:
	jq7Lf36uRSyRtE3+Q2UynlSIraicVhqcxtj8+WE3IjIDdCaDDfv63Dv8/qB1rIx7e/D1r4lg77nwdqApKj5+pPyQYWUph6KWyj8wF48Ii35EUgVgbJVxeWfIdhcn5HTI78hkwL2niRhpowuChnZhx7jN4laP6jHAjA0uLRtsRL3cfArj5wH8PXA6CuVec8MqQ4hAUfWeXX9LFPsKRp/P/Y/35jyIJcSt7c0HoZM6W8FnW15DQQ3UxNqSNiE7Ynoq8nnRrtQWuA+jixKTi6Jwp1w8pVUrqgD+Xgthci8EgUeNOT99jm4KevQV7jlcIDIss9IqGsDO99RV90+U2nSJyA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SyguTvFuwtmPyH8gj+VoyWV2vUjYoiQn+x80cEkL42n9GWZ0Gy32p0Cac//Gdr0JQj+C92+gNMYEoV3iminchTdyCgPon5fT8sChwbNAqIRqxyShR/sWbZGyB5cTaGriQELUr3Pz21yDXCL6zK4uelKKU98nNdtRMfl+3MCgd7LBBSW8a0xcl+98m2UkN3ktR6Ova0P3CbdRQAohCxScer3vHWAnMjbJ4Bv5tXYRuhUSY4cxfqhLJF0EAKXKbwMGHC7o195AtACzlkGO3Adri2fM3IRbShj+p8aEPLqIDinMmlMLBxyrlUFgz9SHf2myq2gPwSWONhzQ4W765GYMtjy7ynOHuYWhiZTnwt/NY5RdGL+AzVoAusiNQ8xXA8jgsgt+JGzoFzyiRmL7eaOwtlFD425JNywBac7ncq4nEUUogl7vOX5DvP8INlseKKTmWTja0RAns7tHKD1XqZbcqtdvE+4QazM5xsWs+QrSsugzFiWhw8g+WAbqI8gx3/+SIImMVbfSka5K+GC871lCHBq9sC9uzcdLcmciRmY/GyNUG7wWIUD14Zc1kjiCbn8+kYaN0oijLY4oOnHcOWl/j2GaIMrDfiX9ZA1a93U7U3I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6f39fdb-6ec1-4e90-01be-08df290db906
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:38:22.6757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6oAYdOE0t04aZyRWB6XUbxmjlFlWNJxpcFHqC6o3pG76uE9kXR8xpU8OTi4KZPfSiaele2x6oLrFm9s/ISraz7XU+wozMeq+46mOn9LGgGs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4392
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2610020000 definitions=main-2610130038
X-Authority-Analysis: v=2.4 cv=N+a8hG9B c=1 sm=1 tr=0 ts=6acdfc13 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=-BFCJ2bJgao7vN__fc8A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX2+dIrvvOiWmQ
 7UHTIegVGPqeMUNBpuFhDRz7iXR0ZPA3DXn33qxou8pm4B/VNfCh4OTTv/678XPGXigdrneKwPy
 70y3IrvIhDQRYIhr2Wl4cNLpnqA0G7vu5lU1yFOGKfK0N/cl939QBlv7EUFQoN92cXZLwSrmAXx
 IwSZCyc5LSTsu4NeZvt+ZhgcSWANsQedlT8w784ht8T+BG06as/7t96mrzncTfcb+SubIP8S1Am
 zUr/leCLdakqt0ShIT1dQEaRpSDr5et53+fpXdjTSMeUksiifLi9e5ExBtcCVOgkOJw3TxxvVPx
 LG87BCz/scyK/iyuEI0Or/QBMwr9QOnsYxLYdc2ScVIiEKlAATKncj3aS5kQPVUPhSuNt64pEmh
 byIj3mPOwjj06l6VH4iIjBKf1EalDeJ9rtFsWxKXibivWx/i0DTumDunxjp4EJfDPvTtw3m3/IM
 4GX15v0fJvadexi3dSg==
X-Proofpoint-ORIG-GUID: oxDwf7mLMyq7_9W3sMsppYBJMLZWzU7I
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX+BSMOmO1/ZPT
 iPF4xslQIFqomYNryLgQ4FQC3iU6CHBj7kVjiYH5iRgZXaeegKEujaoC4pQTjRy/D/+B5xsfJoj
 eRsECLxLbiXG3MqiOdLherkyl0iCveAkjW7AiS1j9ZmP2zOHaI7M
X-Proofpoint-GUID: oxDwf7mLMyq7_9W3sMsppYBJMLZWzU7I

From: Dave Chinner <dchinner@redhat.com>

The code to initialise, release and free items is all the way down
the bottom of the file. Upcoming fixes need to these functions
earlier in the file, so move them to the top.

There is one code change in this move - the parameter to
xfs_buf_item_relse() is changed from the xfs_buf to the
xfs_buf_log_item - the thing that the function is releasing.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
(cherry picked from commit d2fe5c4c8d25999862d615f616aea7befdd62799)

6.6:

Fixed conflict due to the following missing commits:
	[Continuous range: 10634530f7ba^..d4c75a1b40cd]
	d4c75a1b40cd ("xfs: convert remaining kmem_free() to kfree()")
	49292576136f ("xfs: convert kmem_free() for kvmalloc users to kvfree()")
	afdc115559c5 ("xfs: move kmem_to_page()")
	f078d4ea8276 ("xfs: convert kmem_alloc() to kmalloc()")
	10634530f7ba ("xfs: convert kmem_zalloc() to kzalloc()")

Removed ASSERT in favour of existing atomic_read-and-return in
xfs_buf_item_relse() due to the following missing commit:
	3762113b597f ("xfs: don't lose solo superblock counter update transactions")

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 118 +++++++++++++++++++++---------------------
 fs/xfs/xfs_buf_item.h |   1 -
 2 files changed, 60 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 72d6e2dd5ef5..1b323b3c0eb9 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -32,6 +32,63 @@ static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)
 	return container_of(lip, struct xfs_buf_log_item, bli_item);
 }
 
+static void
+xfs_buf_item_get_format(
+	struct xfs_buf_log_item	*bip,
+	int			count)
+{
+	ASSERT(bip->bli_formats == NULL);
+	bip->bli_format_count = count;
+
+	if (count == 1) {
+		bip->bli_formats = &bip->__bli_format;
+		return;
+	}
+
+	bip->bli_formats = kmem_zalloc(count * sizeof(struct xfs_buf_log_format),
+				0);
+}
+
+static void
+xfs_buf_item_free_format(
+	struct xfs_buf_log_item	*bip)
+{
+	if (bip->bli_formats != &bip->__bli_format) {
+		kmem_free(bip->bli_formats);
+		bip->bli_formats = NULL;
+	}
+}
+
+static void
+xfs_buf_item_free(
+	struct xfs_buf_log_item	*bip)
+{
+	xfs_buf_item_free_format(bip);
+	kmem_free(bip->bli_item.li_lv_shadow);
+	kmem_cache_free(xfs_buf_item_cache, bip);
+}
+
+/*
+ * xfs_buf_item_relse() is called when the buf log item is no longer needed.
+ */
+static void
+xfs_buf_item_relse(
+	struct xfs_buf_log_item	*bip)
+{
+	struct xfs_buf		*bp = bip->bli_buf;
+
+	trace_xfs_buf_item_relse(bp, _RET_IP_);
+
+	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
+
+	if (atomic_read(&bip->bli_refcount))
+		return;
+
+	bp->b_log_item = NULL;
+	xfs_buf_rele(bp);
+	xfs_buf_item_free(bip);
+}
+
 /* Is this log iovec plausibly large enough to contain the buffer log format? */
 bool
 xfs_buf_log_check_iovec(
@@ -563,7 +620,7 @@ xfs_buf_item_unpin(
 			ASSERT(list_empty(&bp->b_li_list));
 		} else {
 			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
-			xfs_buf_item_relse(bp);
+			xfs_buf_item_relse(bip);
 			ASSERT(bp->b_log_item == NULL);
 		}
 		xfs_buf_relse(bp);
@@ -673,7 +730,7 @@ xfs_buf_item_put(
 	 */
 	if (aborted)
 		xfs_trans_ail_delete(lip, 0);
-	xfs_buf_item_relse(bip->bli_buf);
+	xfs_buf_item_relse(bip);
 	return true;
 }
 
@@ -824,33 +881,6 @@ static const struct xfs_item_ops xfs_buf_item_ops = {
 	.iop_push	= xfs_buf_item_push,
 };
 
-STATIC void
-xfs_buf_item_get_format(
-	struct xfs_buf_log_item	*bip,
-	int			count)
-{
-	ASSERT(bip->bli_formats == NULL);
-	bip->bli_format_count = count;
-
-	if (count == 1) {
-		bip->bli_formats = &bip->__bli_format;
-		return;
-	}
-
-	bip->bli_formats = kmem_zalloc(count * sizeof(struct xfs_buf_log_format),
-				0);
-}
-
-STATIC void
-xfs_buf_item_free_format(
-	struct xfs_buf_log_item	*bip)
-{
-	if (bip->bli_formats != &bip->__bli_format) {
-		kmem_free(bip->bli_formats);
-		bip->bli_formats = NULL;
-	}
-}
-
 /*
  * Allocate a new buf log item to go with the given buffer.
  * Set the buffer's b_log_item field to point to the new
@@ -1072,34 +1102,6 @@ xfs_buf_item_dirty_format(
 	return false;
 }
 
-STATIC void
-xfs_buf_item_free(
-	struct xfs_buf_log_item	*bip)
-{
-	xfs_buf_item_free_format(bip);
-	kmem_free(bip->bli_item.li_lv_shadow);
-	kmem_cache_free(xfs_buf_item_cache, bip);
-}
-
-/*
- * xfs_buf_item_relse() is called when the buf log item is no longer needed.
- */
-void
-xfs_buf_item_relse(
-	struct xfs_buf	*bp)
-{
-	struct xfs_buf_log_item	*bip = bp->b_log_item;
-
-	trace_xfs_buf_item_relse(bp, _RET_IP_);
-	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
-
-	if (atomic_read(&bip->bli_refcount))
-		return;
-	bp->b_log_item = NULL;
-	xfs_buf_rele(bp);
-	xfs_buf_item_free(bip);
-}
-
 void
 xfs_buf_item_done(
 	struct xfs_buf		*bp)
@@ -1119,5 +1121,5 @@ xfs_buf_item_done(
 	xfs_trans_ail_delete(&bp->b_log_item->bli_item,
 			     (bp->b_flags & _XBF_LOGRECOVERY) ? 0 :
 			     SHUTDOWN_CORRUPT_INCORE);
-	xfs_buf_item_relse(bp);
+	xfs_buf_item_relse(bp->b_log_item);
 }
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 7ddda0aa9dac..8a8a46e698be 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -49,7 +49,6 @@ struct xfs_buf_log_item {
 
 int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void	xfs_buf_item_done(struct xfs_buf *bp);
-void	xfs_buf_item_relse(struct xfs_buf *);
 bool	xfs_buf_item_put(struct xfs_buf_log_item *);
 void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
 bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
-- 
2.53.0

