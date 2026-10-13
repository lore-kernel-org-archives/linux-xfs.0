Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED21413B58C;
	Tue, 13 Oct 2026 08:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791879227; cv=fail; b=FHU79ig3oE7+3IerbHAZHBj2W3DeGuKDNGWZFXp3CxXpx3tL/8L4EmESK9or1K4pX8Po3fX0+2pmiYu6F/uOjLWaxMhHbLcqTEEEmwoLxPogjR673/47yrgWNI3ogQAaRKJ++1JThbi3kEVFGCVy1+X9Rmx/atpQR2Cf3QUjeL4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791879227; c=relaxed/simple;
	bh=aNgLsvRCaD1d4TkwBeB31zBaaeHCo9cbNtReMoJBL6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZZY0Hn6hsd1MhyodUXG9hiWNrL1J1p4js8IpuEx2N4pKPXzVrVrCBcHG3Jy3IwDbm0wQN+opI+OdroJGMI7T1TU6jApiXyVU3pmtDFZFwxAKYYtZn/Y5WWURAk5993UEU7/1h70kMrKseQc0q1dPVHH+5t+xXD1g72efAB+EyH0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=O9bkrv81; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=0Avo1JGe; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O9bkrv81";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0Avo1JGe"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D2Bsru1439853;
	Tue, 13 Oct 2026 08:13:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=tL5sw8oUbLykhy0mWXiC7tQz9pbwnDxV8bDuz8MQZws=; b=
	O9bkrv81J7xJ1rFlkXeSSctQm1DaQizqOhjw67kl8YAJSgAFsIpN0QNgK7QqtY79
	vgjc/7TBkJmeOvOr2wYcN288wGAJJIaF4Lqr7KLEwdyehY87Fd8B/zhhkvlt9AFH
	Orw1C9vgiR9OOOMXHV2ffVQQIc7KM8QgYvmGQs1WvRYBYvuuxFWLvqpkPjQCBhsj
	OOL73B/u+3qXVqFIabOvJzn3AlbHIc+qh/GmRkXbp/jxTDp2cQr9C/b5BUIL7ax4
	sIhGOdJuymAFpIX44Mc1OnKi5kyyQynb/CSmtl+HpfbPiVMeKE3uO6aZvyJTZuBp
	4oNPx5ueFrXwk9atj5HYOw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7df7uk63-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Oct 2026 08:13:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69D86SA1002176;
	Tue, 13 Oct 2026 08:13:42 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010062.outbound.protection.outlook.com [52.101.201.62])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7bt8ypns-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 13 Oct 2026 08:13:42 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gMyfWJV3Hy3YFAvfPzAuJedGBt8wA8KeT8QaJKDlZCvSma2pdNM4mzCCV5B3kQWhD+ag6tUpxVcf0qYgL78PeXHw+Ahl/1cEXMqytmAgQGu7y9dIBsKqbrv8BY0g9dbD2abnVn0pVJjvCA44x6/e+e1vggDNpLtsmuGmUVD/xgJ/inBEFpn2+W7vp6tpv9hVdJRm7z9GJ35phQCq1kgXtB01/ThouP5oFow/JuXV4ArfuKZwpknLp94Y1r9BMAP+w312kPO/OlFXa3hZip1AUqNIltTfNVRiYeEN7f+dYeYhcuAY0UM4JO4FeT4ZTQo3eWf8N2JgQ5Gj+X1lU9Z/cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tL5sw8oUbLykhy0mWXiC7tQz9pbwnDxV8bDuz8MQZws=;
 b=fdGsB5NAWF//MbTfLjznw425aI7KvetbKzWLTbkNHWtNVM17+ZvrLTqg3n0CjTjG9Pu5bqDwBokuyHyZ+ikgYxNQDb7N6gVeiPiJt24fHpWu+2zGnvND+EGlfDtYIKWFcuD1y+q5cIGMtaZqDAKFbJhPIkjMjxwrbJv77JuaPu5UZNpjiyZIObG4zcrZMBzuWevDTEqvXnzP9/CoN7k2du+fytlvOx+mRXTdx397O2n5KFmzNIFjQ44YtyssgYpHoKwSY6i+303OSEO0XTe4UilCUzLeh6TDObhqTg0UKR0DMEH/PRH5rtfucgOBHAgo3/bHPouX9yTc7oAYjNnDEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tL5sw8oUbLykhy0mWXiC7tQz9pbwnDxV8bDuz8MQZws=;
 b=0Avo1JGeOLn44nYFC8f5tKjGYz27kitAA7EshZ6Ddp8vISlRNUVzvBsjqt/tfZ1oJCUQyYFDxUtFzmu4O+5Ny51USBgsT7dqqzlhV25VLSbRkkXnN4cE6nypwUbv7ev/EMVuPm7wj7cT4tFhe3vnupHQPUHYk54+ajJ/ZB4NAWk=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) by
 DM6PR10MB4138.namprd10.prod.outlook.com (2603:10b6:5:218::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 08:13:39 +0000
Received: from DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c]) by DM4PR10MB7505.namprd10.prod.outlook.com
 ([fe80::f14:5389:d117:967c%4]) with mapi id 15.21.0522.011; Tue, 13 Oct 2026
 08:13:39 +0000
From: Siddh Raman Pant <siddh.raman.pant@oracle.com>
To: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 v2 3/5] xfs: rearrange code in xfs_buf_item.c
Date: Tue, 13 Oct 2026 13:43:18 +0530
Message-ID: <35edffeb541fe1a04bfdbfe956fe3e5157ba3ec6.1791877865.git.siddh.raman.pant@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1791877865.git.siddh.raman.pant@oracle.com>
References: <2026-10-01-1-daily-reply-0012-re-xfs-umount-hang-backports@kernel.org> <cover.1791877865.git.siddh.raman.pant@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0122.apcprd02.prod.outlook.com
 (2603:1096:4:188::10) To DM4PR10MB7505.namprd10.prod.outlook.com
 (2603:10b6:8:18a::7)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7505:EE_|DM6PR10MB4138:EE_
X-MS-Office365-Filtering-Correlation-Id: bfa5ccbf-9936-44ad-0b7d-08df2901e350
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|10070799003|1800799024|366016|56012099006|4143699003|261009223027099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	njzZ+CVRcSNecvAVRiCirOBuT1CxMaKnt7/Y+pC7JMaLtZcrUjtLKdM8gtH+Z4knpime8Rlzf831ni4up5hVSEULI+n96f6nIi6gdF/HsOb2xS8YPOGVO8Q18YOpbYeAX/hOycijlqEUi/o7HTEIMJf26ffYEdGQUTE+fhwmluLTNRMABwgbm7VoiKsQUO8AigkqQ4c8kA0rUv0o2aNF+HEBJ/DBsa0LFZmI3NKbE9o6KQBdq1sWzXrqHUkb3qB49jTBG2zBeCbh6+4JglO396i8cm/mGML8Jh26m30lxpJ/ivJr4/mdCbwAIIQl5eGCLXp3eqc11r9Q7fkiMblfs/mXFNqI3S1m6U7BGVUEuIZxv0QufNwbj6ALe/0RHIADlAd7203tdej4UcYNY70uByYMUJF7BdMkB5ZSnPLY0YdKdkJo5PBrrrVdwcuWMa/2oThP4LEXv09874Opchig9kzc8a6W+M+IsZ+FJqmqCwj7om4eAPOhT4XRzlL73/1iaMNlEf4ksaAYYzXZkyVCkU5chb4+DlRbEU4PsfzDs7m8+OzzPMIyAwp1As3vnJwMkaNhNugM3WVVx6/vaTwzgcJ/YqqWOlgapalbWaOX8yzq7K/R1v8s+Rr5D+cs3pGDwJId2UnsajwELBEcqoohbZxuLQNe8vKOdMcC7n1NigM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7505.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(10070799003)(1800799024)(366016)(56012099006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1ItT9c2XXMXyel7gcduqP3dKRPHEdikwie+65sA1P3Mfwn5bAr0ICVdNondE?=
 =?us-ascii?Q?U7yORABMo4vdKJkbqBtB3qkdMbA8kQkwi/5YbW8GzJBqffNgdm+3GFlvTKFs?=
 =?us-ascii?Q?70nudphs1uv35AI704RM4jHf+Pa0k2X44DdTkeBeUtGho+Sj8Q6Ra38WK3r9?=
 =?us-ascii?Q?aGmzCurRe9WSmhLG8MupLD6pFE575bo2HyjPfsH8uz8z0HLw/wujkYVSC/Rg?=
 =?us-ascii?Q?MhAHCLwGrtluXdA/jfRRRQEWv8M5TAGQMxAir3fGsb7kGmZTaRPCHB2KKoML?=
 =?us-ascii?Q?EiONmMufl7gZFBoQ4RACr5asq9+406PsoMpNaHnAsYQMqVVOvbNsPvKh4grV?=
 =?us-ascii?Q?VIrF+UlXrIlVuQ0g60xNrs2M/lztzJ6OGP58sRHsoOVaRg3ELzDBqQ+K9C5L?=
 =?us-ascii?Q?R+ITAEatuDQQ+/wNA32KnC86grlAxzPe4CteTheIBtvW7YL2nk/kUwdf0YuF?=
 =?us-ascii?Q?9kVkOBydCo4rl63Zh2FRFKYAMWcv7l/ZBxlZRlx5nmtFalxh+tQmNOjQhI4X?=
 =?us-ascii?Q?3c6dGxecxfCRZA5hGCRTo0cie1nloXEM71wO0SjAprxL3vl5hRl71WxXWGam?=
 =?us-ascii?Q?/P62p+tkLgxQzgRcupWSnTogMXbpvu6RlEB3uivGnz7UUTRnyRiLEcokr8IH?=
 =?us-ascii?Q?W1SlfAbpkeF/2bljRfRg1PDflwqa6aXaNFE604+aQ8ZM7j5PqPRffrI3pIEV?=
 =?us-ascii?Q?mc7seGmwPVSVZ++9SLQB1ShQ8x7Ii+zP0XJ9qJEbTuwzVuIrr46iFdowpnQc?=
 =?us-ascii?Q?RXsWGJQfEyZiTjvDkMPvh1liThUgcz4A6pU1DTmzoakXsM+SCkr/St2e5ZMo?=
 =?us-ascii?Q?PflxgfpQyGuSH3sdKRAWRiggOet4PkY07W/F/pCrHnj0G1rdeB7ev702Hczm?=
 =?us-ascii?Q?heyKx56naXX3Z+PSiYT8IoHPdGaSngOA+uUEL0j2G3tql4lHIkHvsqLr7MQi?=
 =?us-ascii?Q?TtCaAzgSmH15O7UtLCl7ehOZFt9iJCFWnS5U1i44m5Ghb5/ciYpBR4PoU0ZW?=
 =?us-ascii?Q?QM4Ii4foC9hHkFvImO3l/eHuuawopI/iZpQTV/W5lC95VZL6uD6raj/HjWsi?=
 =?us-ascii?Q?TnPMLpl5Q100Ll+RbNaOPOxlNhrn646cBzssCivKXq07zxECs9sF1ejvhxeq?=
 =?us-ascii?Q?NkWAfSHp/ErTZupSsDdKZ+Hj7XFUx2ESvrvTk9grgEHUaCsrTJBzQj5P5U2d?=
 =?us-ascii?Q?XSOEkj5M3LXlIJgVw6GduYwiMnMOSRO2L3P90fqqArRn/e6eZeNmKJwGy2DR?=
 =?us-ascii?Q?7oQ/Q6WDvjFBeVrA802GU18V58HOq3/WTjMOG2u4z3fwC55RPycBEg7AEopZ?=
 =?us-ascii?Q?632+nVRSC3sDTT2/SQxH4pTPhom/2nIukYnatNsyvPk2CVJfBrk45bbwq9A5?=
 =?us-ascii?Q?hkCAX5v6/DvgsjDMoFmqo/iDqeGnrMe2T3dxqoGuGJZSVPTccrg0YQdIvnwp?=
 =?us-ascii?Q?IDTzYNdHfRhKckEke2GDfIuVlh1YCLtLiI+Wy0cQUEr3QMk5tPDxzLGDo/fG?=
 =?us-ascii?Q?LAeDCFPNldT9vE0V24hmRskg5Ufh+brHZ7qpit4t1C9kys5SIo4/hQeh2+8P?=
 =?us-ascii?Q?VbfP0DttmPsxvptN3bwHbc2C7W38T/IaEofaXUCj5I+MT7r4P6wUmSWwXJSF?=
 =?us-ascii?Q?CQvhGNgVhFajEewf5GpruhS3byq/Lut0kiPJnF3o8jbG+eEbQQ78GnYSm/HS?=
 =?us-ascii?Q?RNUbnjVl2wpytkazNkdZEms2chPwTOKU/7LXqbAAnK9gL9FZwGqMR4KOpXhV?=
 =?us-ascii?Q?lHNOEKwWVcJ1uRADnlyYKQ4fju0tPWbgVdNP3wAhr0yllTyYPGYbZn1LiLN2?=
X-MS-Exchange-AntiSpam-MessageData-1: GkaLGVVZ8qGfvGXiZPiHGpsn4Yxn4KTVyn4=
X-Exchange-RoutingPolicyChecked:
	HNKaLG0xwoJu2bbFpCcvoru15DCQsi1NdMvJABmXIC5lF9NaNen0b59NZu3w2rsN399beegqcvhgajeuCc4jZZ6qt2sCRRGIKS3G7axYtNAnW6t0I8ATkggJJoZpia/VnWHhCUgSRRQv8blBfYAarCAHkVK7TS8wx6J0EvfatdeDw300pcYJ8KcIpPKZ+fw/GcnGv6qQMopSZqE8KU0OTMYNmdXUjeGTOw1g9LpB2Yl2K8lLKexEkmgIVS2jpTX/o4wVrt6QMcYMeMxNP57KtVo+j0cAi7ba376gOYQYO3Q239wboFwG8Q9mtdKes19XEUeGefRgBVP1HI2brzuNzw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4dklkAPXGjCdWj4Ih8Ld9M3xtuGu6gr3BDSE76hpt/TLuW2ZVHSFsGmnFq+KatDvk36TRRav+OiwJT4yBdu2Gr6ZvPyWN6xjOdoUa1UnKb4JOH/lHCQW/wxmEuw85UOi836d5BTq6v4CWqXK4Ks0vxGEyQBicj3pIR1MnrYE6TtMEkimiP2h9zNqQVyqZeXlXR/8xVwPYIScHehUGgPROM7bko1JXll7kystLZOE0qk8XJVAIaN3EeT8/MII6I1W0vENsmR5CyURN5mQ9I/I8ajBnT2plBcikpizcibhKk+keAIYwF8gljO1Z2PY0CrkswsCRqHV7AoRxZg7EbEJ2hcgA86OffpMUuO9bxkKyClUjGPS3MzcjRIzAeSFb/R0p9F9+aOxtw9tR0nvxsF9OjJ87tLiH2isMAgV8bia4toQ7NYrJQ5M08ZdHgOHITjJY+OPiU+DMOQV+DGWuzgHqZ6zRoB7XHxSQpDGQSH+Hgt+v48o+Ue177tIso6IiGSB356LeeOTteS9dt2pIGTckc7wQdHJzdMfas9Yn/RD+5X4ONndwU6AmJ2X73zeZM0kEeLi38yVK0/5TQI1ET33Dwp3pqv7+pOn8PbdvqPGB7E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfa5ccbf-9936-44ad-0b7d-08df2901e350
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7505.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 08:13:39.8296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jXSbgIaqpo/WiSh7c/xQHJ2fHtyfxokcTc7YHkABvRGXdXPZnWqUoecGftNp/4NWHu83wL8jNhGt5hPBmtfCfB6y7evwardBE5b+D7oNQrA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4138
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610130032
X-Authority-Analysis: v=2.4 cv=N+a8hG9B c=1 sm=1 tr=0 ts=6acde836 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=660iZSQnnn4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=-BFCJ2bJgao7vN__fc8A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX+eTUxuR/QhY1
 sak/yFTU8KCK1TB/uDWJ4m8nFmrUljdd/OJ0+OBq6jDyj8i9cuaeuOQfT7+jcXOJs5mEC25yd+g
 FjW96CJSBb3uM1yLTdvEfpZOVNh2s/hE1sxzl62rOio2Ymsg+Ow5GrE4qtlEYwMaVSCBFb+UNjr
 4YOdl7Ws+aK7IxMkx7iIB9FRVIe38jnyDy9PHBwjRTIZCPs4mffUFpEE+Lf9iqf5Arj6CXpfhoh
 vtGDaZ82lbGqppHyXSi7Jjr/V7lE9OSIexMLH0x44SNvz+W5gxa5FLMeaXA7Y3VfbE7m7DtSZJp
 iIHGBEPnqimNnX13TIJ7D5vU6KhOdmqiXsWRNdwn+dWBiaRXWzxDrmljmnH/bc69YO9c7ozoWJf
 4Qwh7G8JNJmZ+KKi6ru7O8lgUWSUbS0QyERuGpiZBI+4Us1tsQv02jXwaFVkuYkT8qpNFFBEThk
 40dqhWuoNZ/KSDfb1Ag==
X-Proofpoint-ORIG-GUID: bVvhUBT_sp9QQ46GKj263PaW0XswnK8V
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzMiBTYWx0ZWRfX3IQmr7KT5uU+
 2bZMMRIrqqNmIxaCJEEC03Cm+lp4h5Dlm6mQzDe9BjRxPfHaZfB2jNcHN0SSztOoPcFdg5prm/7
 vAzbU9YtgGqjFfouS7F7Y+dhi/Pvx6rB0MesMj3U6gC3BZv5gaIn
X-Proofpoint-GUID: bVvhUBT_sp9QQ46GKj263PaW0XswnK8V

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

