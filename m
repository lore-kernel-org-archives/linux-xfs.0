Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503421AF0B4
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 23:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734044492; cv=fail; b=k2CIpQdacZzAy9enlTDJhEdH8t0OpF+TpWMAzf3fMT0F5rMub/6vaESjpDqPIOJOIaWvicOqyqUb+QsWS4uN0MXAZYZ4xJ1yyM5xq4S6FsSzT6keFg1J7Fhqgk16O5SCDRYPfeolP13d/2YNolFTaA4kQi2ipVthEKRNivgQYYo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734044492; c=relaxed/simple;
	bh=xeOc1DHwxMShHhZOLbDTZ12cEe4UTocYyJsAyMVJhAw=;
	h=From:To:Subject:Date:Message-Id:Content-Type:MIME-Version; b=BJbCC2Mn+nO+2TTtDW23nLiy8fC90cDEubPrwa5jkt98R9BvtvGTdWqQxrndj+0PobqOSW94na9Tu32nF8pJkcqeeG48ipXEq+mo1cQh7eWyNhe/C0CLSoaX9tIeSkrL4ptvbmysbREdwe6dGfL/JBf0FTTSTt+HYo85LD1p06s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZO4Ng+nI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vij41PMJ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZO4Ng+nI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vij41PMJ"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BCMuWmi023401
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 23:01:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=WMR2oKM1CxCMCoNI
	5H0yMbyWsWLjrZAGDj9tb+2JHnM=; b=ZO4Ng+nICbXa1QGajpE2j+8HzqrIh36l
	H9PanXMBB2ShKTDmUIGasGW82pEeXrpF0DVTjq5ODzdBK7EJrd+6rk7sWZCyr73q
	/w+NVW0bbEtrLdCzG51rPeBFdKW0sp5ZdlbhewlkfOGXhERvgCc7t+rjLsHSJgms
	5O/qDrLpVeEgCtn1NO1hEv7r+y06q5WHRRBbtMQ9jd8ki2czc/iVdwPVy+dYWvZQ
	+okZbcQ02AKwO+g+qd7JYQsViA1HPRAIKxHU9m+Y5UxBSUlnip9oaicYy1eeF1yB
	g8jgeN1Kb93QNdCfARiGafSm4mgAHO9NnZ6ZmI2QEZDajj8cRogtGg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43cedcccfa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 23:01:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BCMijRf036255
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 23:01:28 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43cctc2wy4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 23:01:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d4n7IE5DTcUMzysryTS9PshBGd+4vgtY/v0BzCkbFMIers2FSK6MjW8r7kJrKc0lIj0EAP/SHKy4YNnDPsvkYqPFJPGAUdEkz5Gswoff0Kjw4uttur2XpdNFTaHinWAEbnpiQT1tNfyD6kqwg/vLAzV8QXHN/zk4OJRZqtdG66aDvD+m+40rA8EYY05Hxd1TY649ml2d8g91s9fo2xVeaLwXgV1eFVXS/SCuob7Pul2glAKuBLmk89eTGVF4NtpW/FXP95qTH+zpJl+4NGcKaHIsHyg47052tLpqZntB1RnM3i1is1xnmz1P5K/C2gTVZKd6VaV35LXV0Aq0Rj8cwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WMR2oKM1CxCMCoNI5H0yMbyWsWLjrZAGDj9tb+2JHnM=;
 b=OcFoXiYr9xUzKgKyvjRX6H3jneU/3Izi+zhpVopApu/ANhVY8PrVNUYzTcCQQhBhkVPaviB+tNxo3vDgh6VEm5F3QSgnqTvWwZzPC+pyw/z0OaqlXHM1GdQdxfWNf/VqLzWSIdz/NjUWNIQJNmT2o2a8hhKSFNguoxpjY9DTgt6ad8pH/hKCE2yoijf5Y0KWGJeeeftJOTg3GY367zucTJk+tY7smbpabAWFhhgusqppYy2SQcrMB3/zfFg50p4jhQK+SDbVHfsEgb+HKvSqjaDJ0XQFbgnMtpQjL9eLGuRqTWAWmZ+naIS2+yXOKG5kcmhkh0XT3NVB1YnAxkQxdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WMR2oKM1CxCMCoNI5H0yMbyWsWLjrZAGDj9tb+2JHnM=;
 b=vij41PMJt4gi1YnR0vrpUW7bAT2Noaz+elaGKUC1QrblQysK3aj8/xWr49RujALXrf/w0Y7kVzSQjLUfjUwk0ftciLaZJ0XXGgKL8Gbf4aP0QR7vuFrJG3SO5hgTrhmjK4YcbAqK8/pUOHRtEX2iVOmFcD+gu+wvME3CzMcO3cI=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by MW4PR10MB6582.namprd10.prod.outlook.com (2603:10b6:303:229::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.13; Thu, 12 Dec
 2024 23:01:24 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%6]) with mapi id 15.20.8251.015; Thu, 12 Dec 2024
 23:01:24 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH v1] xfs: add a test for atomic writes
Date: Thu, 12 Dec 2024 15:01:23 -0800
Message-Id: <20241212230123.36325-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0036.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::49) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|MW4PR10MB6582:EE_
X-MS-Office365-Filtering-Correlation-Id: 65c3e1a3-4c31-45a4-8de8-08dd1b00e708
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|10070799003|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Yj5JuwqSkD1/rkhJvZp66aAaD+YsiZD/8hNPe97IbezSfeu76KEcgzG4TFRW?=
 =?us-ascii?Q?swhHia/Z1SJ9aC8aGjuXt70LvLBPfkjRC3tADCBQPPm9mTZcBWIHRmfV8JF7?=
 =?us-ascii?Q?7FuLe/4GuCrUK+AqkcE4zJ5k6qjBPfgdw4RHzBE25wMfgRk/sXV+pMOEeZY4?=
 =?us-ascii?Q?mkikz6CFgQVWcUTQCnUV6Lt7+54CcSZbu1dlRNnGDzJlYplYUyOblnPTJtQ0?=
 =?us-ascii?Q?80+kGWGQC4UxBz4CwmKsOh9E9/wAV6Z1UwNmhUzF44WZ8g+9EaqsDoQylGqN?=
 =?us-ascii?Q?fTZBvUMUekBhpQMuttQpBOGMkOea2yUGkYLSFCeXr6ms3Z0LDc1W/+zGuLSb?=
 =?us-ascii?Q?0T7XBRZgxAHk1/7NQfhp6OmaIIT4MxBAgj9R/kJQInt2mxr+iHmokfbof3n4?=
 =?us-ascii?Q?JQiIwIpm5HNGDQwZI/5STOYD0CuFFHB2TemFOlMyOecjsC4Lq12AkasrdvWS?=
 =?us-ascii?Q?U2MyrxM3dRotkj/m8QyYb4HGeP0TPoTrFs5AdORQVYrBP2CQBXUsXIJrLLCy?=
 =?us-ascii?Q?5kwb/7mqj/SsbnolJOofF3Mt7sNsGllqQYpZS6dWPIrBV4CmNLN604ZWPPPw?=
 =?us-ascii?Q?DB9CjG+y8/dGiSWN1gn53XpzboX1O4HU5tx1hN91kPMOaZnL3hkW87b8DU9H?=
 =?us-ascii?Q?DsvR9wW0Wet0w2xVG5fPEuVxk4Nx8+7FuA4Zvy9XV06F/DMBLy4x2dEJNNe+?=
 =?us-ascii?Q?pMGjvwPv5/aeCv7pTgr9TOuz8gMCKNj5s2MxHmTgx3xakCCEJ9qIgGts7J9e?=
 =?us-ascii?Q?c5S0hkyhTySciOc+fUmIqJHNcCycciikT+/DR7PbAI7nwnx9Dzs7f0uBgkzQ?=
 =?us-ascii?Q?b854pi3VPgMmdvJsL+pgBEOTZI2CXnVrc5k4wMBowQsvjqgqufORZT09kyp0?=
 =?us-ascii?Q?rgQR0YatkE1mQ10FP3Qb1eZitzEVGghVt6xX79EyAD3WWJ51Wa7FYrzK/1FT?=
 =?us-ascii?Q?bBylAjWwbCH2xFFJYr1Po7/FvWCn6fUOOmYfVx1FWaBrSBJVK0BtGMUwNmXW?=
 =?us-ascii?Q?FOdX/YoLFsCG0/9iPjVLePp5hp+sO3j29+oV5gGF31OxYyjTmrh0+agSazng?=
 =?us-ascii?Q?fSXlAEqc/ikWEktqRrm24Zgz7e9bbCtk3vZv64o8tUrg7WwKasFO0J+wWNEF?=
 =?us-ascii?Q?oCNnX9bFXJ/RiUWgxrsuOPoB9trD1emZ7LeOVrn4l5+7xbYqJMXCGy1Qf4TQ?=
 =?us-ascii?Q?QoiAPLGnD0A1TvCsspgWTWhH1xVg9FRRJF7ld5OLkMhJXNc0G1KU72AvS57z?=
 =?us-ascii?Q?OGIE96nhmsgvWtPGb/hbRXNZmVnSKfZs/M4gz0ZfpUPuTsHnAzWn1TgtEiPu?=
 =?us-ascii?Q?jfxgY8IBQQL9HLR2YCKDmTwh4dZl1/nwuAQoKXKr4NT/QQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FFAKkuMfNmiKT8R/6TR+sNVodIGyE/8g0LyAXIVdBWjKhhgl5frtLt+5pYy2?=
 =?us-ascii?Q?azZ4EQvT7Ki8BP8K8iXWAa+TpHY5utZJiUD3pe6q7EhpFwBi8dj5zQuLGnY0?=
 =?us-ascii?Q?DyfoHRB5aO2Mn59jt3zd4e8R+riMhu4F6d4HZa9Og9a5324eUw/YpIYB29Iz?=
 =?us-ascii?Q?9Th0xWucWx/4CHHS/GiBkvK97pJXvXNCDidXwKCBxPlww2u1dHW8E8Zc2N1I?=
 =?us-ascii?Q?K6S5hNv+GK3mnap+s8Ya+My6L9Id/cSgawu/Sj2+NeqBkcWrrolxatqKtGOd?=
 =?us-ascii?Q?+VVtXOUGEhBpK3bGsNc6SrMRIrktvZz8lmxlqiX9YZrrf52STXATGavuhpoH?=
 =?us-ascii?Q?5AmBk3g2gmu6AXMA/S67rULYHoaUjGJIFqHtc4yzP6AA0tN+iyvq0GnE+2c1?=
 =?us-ascii?Q?Cn7kLM6jeYglKRjB2c5Az4o33YT9bCxVBllJJPSKVQax2m6DA49zgG7eUFxd?=
 =?us-ascii?Q?n0wT2/zrXwJsPEK08RTG7iriBruTVD/v2rTHYZRfgRBBSjbo3ofFbU5YADus?=
 =?us-ascii?Q?cm0CZNBjqhViXyjCJArlrNbcE4J6OaPrRdX6KIhlRTkEoFsSO7kAsdCpwATo?=
 =?us-ascii?Q?kvQwzwY/m2BGnrZRmqsWoIsdY5ihSjZaMxDtGTan3gq+VMEPL4WBH+NUO2v7?=
 =?us-ascii?Q?KiZsM89FpkRlcjMrBayMBA9gDWO+ZTRb8y1BJjilB83WgIHNjybdWudYZZhN?=
 =?us-ascii?Q?UGIsoDpo6o7/85eqOCX+60U3dLK1xLxR6Zk57t2OWYZ0+TF7FIZZd/l7FYbZ?=
 =?us-ascii?Q?6fH2xOMCvhzAxwVOpQ6u5qS4SlfHtR1/+jj63r5O1Oy1o15BLEOezlfFIvSJ?=
 =?us-ascii?Q?ddTGwKD0Fs6sNdpMTSHSVzjmfpNpiJNYemJ+gpIc/dQkgCqsvADom9zGctAg?=
 =?us-ascii?Q?/qhOqa4kPbzTXAxcouKvVFXh5PRTvWB3bn1ZENbu48mF8woA4tHbdQAW3/KF?=
 =?us-ascii?Q?b0OOSZGAL7hn8BW92YL4u3hdTXUCQqMz4RYWlL+frdyulHRuF6tVGYiadShQ?=
 =?us-ascii?Q?atFSdFNjABNqbq+k/TWNgfb8Bpn+1+yPScBaxDNatA64tY7enFRuZK+gDstE?=
 =?us-ascii?Q?A2tfljm5A+W81cK4lhlytM9xeyHJJwOG3pt7bqpp7gWlnUXFoyPuA248d/I/?=
 =?us-ascii?Q?UdfV6JqSs/lFxCZXyStBbfIiLARH5YavWRDOvaUSb/XaG9o444Ndjakxtf/G?=
 =?us-ascii?Q?WexqLefw4ZOjb1gFQfVoGyM7nZ/hZWhTYEmV9IwuFZpy1r/QpqTrWoKb5nDY?=
 =?us-ascii?Q?xXoEdd6VHhjoCsfooM4QcBJ4oRdztC5oKDouf5uOyIGlaLbW4fl+fIxMJwux?=
 =?us-ascii?Q?bPxSgJGKEIhkBMfWovFxTIoAXFSWhUOvpTZ4j597kHI/epsUwr+MhdMSiqH9?=
 =?us-ascii?Q?Kff+FCKZUZ3SU+QhfKRRFuatc/fo2lXRByahzBteU6ONVlyIYk82bVmB/aR8?=
 =?us-ascii?Q?U/z35gT+nVXm9roEWlmZ7AMSxEMpK3Q3U6EeiLS7XZLKCI1EuNZ5u9NOiZBz?=
 =?us-ascii?Q?3ItHmnYtuTp1w6FC3gDCB5mkMMyA/rcVRai/DnhEVaxzG2gwD4V5lxoB7axl?=
 =?us-ascii?Q?xPjShVt37OUAEviqmU//iRYaAgi8AbDzejOzUh7pO7sOnIgh/iSXBKp9xpcf?=
 =?us-ascii?Q?GaeAACLz3WqiFi3cFb0J5SfSuFI44KDlHFwH/xmKiVzpBSagL/tIKsVzBqs9?=
 =?us-ascii?Q?z8ydrA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LBUPTbiVV0gMfT3rtMW8o+Qoa9Rj2ygQyAfkkFTXQyKiI9/mX+USLdraqjODdqOOwDAOoIHLq2rsZgbzdVtzjoHxHwj5X1CRbs80Pc76R8Vd8ioFtZCWdIkT7jRLBd5FdtfvvxKmP3gOezz7+isU/b7jsBEUzI3NkcMB82hYvWtKaSjHdzkJG4fq8SMv7W+fdfs/h12QgoBamOPq0EvUasmv5NiE/1bp5WIsBHU1Nby5nNDa6obFKpJCVioBBEiOfQhIM6WiMvFkF6bdR1Jisg18g6OecIM+Uco7Htg4PvzBYb4F1W7TSElLCUE3ldkQ2fPUNqGLblMjMuCImsZBQWtf2txlCnGygW6DScPwBr9TCPHXHS22DiGeOIKP2JIzDNcDwBnezJKEYyCczmkkGda7fCZy9UZdNexbXp2+lLIYvtfVSLLfbME1u3oRsxbIFkwbdvl8r+LpEtmRm6onU384FXsbvMqxZNX0mdz6b7YgFeB1Gugv1dF66AXsywyk0s6kBUSbBV596UAmKmMwQbnktQ3euTK0f7CfPVNkgcgNUgmHJUGdXDZNeaGvkJeDW6vb0vaistS4oCJaOT1KOVcM6JpPpemsrFp6FKErne0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65c3e1a3-4c31-45a4-8de8-08dd1b00e708
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2024 23:01:24.8088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HgWl9TRpv8fQs7dHCmQmwFP3G+EeLlTqLJPSUyQRpaxOAFVaOqNYL1HUO9tJiJrRHx5hgAcP1DvcZFhi3IUdMj5o78KWOf3IAsz/0Xj4IhY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6582
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-12_10,2024-12-12_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412120166
X-Proofpoint-ORIG-GUID: M5e4DbbbxA5ILMvq-M5O6-nGQoQLJR3N
X-Proofpoint-GUID: M5e4DbbbxA5ILMvq-M5O6-nGQoQLJR3N

Add a test to validate the new atomic writes feature.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 common/rc         | 14 ++++++++++++++
 tests/xfs/611     | 48 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/611.out | 17 +++++++++++++++++
 3 files changed, 79 insertions(+)
 create mode 100755 tests/xfs/611
 create mode 100644 tests/xfs/611.out

diff --git a/common/rc b/common/rc
index 2ee46e51..b9da749e 100644
--- a/common/rc
+++ b/common/rc
@@ -5148,6 +5148,20 @@ _require_scratch_btime()
 	_scratch_unmount
 }
 
+_require_scratch_write_atomic()
+{
+	_require_scratch
+	_scratch_mkfs > /dev/null 2>&1
+	_scratch_mount
+
+	export STATX_WRITE_ATOMIC=0x10000
+	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_MNT \
+		| grep atomic >>$seqres.full 2>&1 || \
+		_notrun "write atomic not supported by this filesystem"
+
+	_scratch_unmount
+}
+
 _require_inode_limits()
 {
 	if [ $(_get_free_inode $TEST_DIR) -eq 0 ]; then
diff --git a/tests/xfs/611 b/tests/xfs/611
new file mode 100755
index 00000000..d193de86
--- /dev/null
+++ b/tests/xfs/611
@@ -0,0 +1,48 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024 Oracle.  All Rights Reserved.
+#
+# FS QA Test 611
+#
+# Validate atomic write support
+#
+. ./common/preamble
+_begin_fstest auto quick rw
+
+_supported_fs xfs
+_require_scratch
+_require_scratch_write_atomic
+
+test_atomic_writes()
+{
+    bsize=$1
+
+    echo ""
+    echo "Block size: $bsize"
+
+    _scratch_mkfs_xfs -b size=$bsize >> $seqres.full
+    _scratch_mount
+
+    testfile=$SCRATCH_MNT/testfile
+    touch $testfile
+
+    # Check that atomic min/max = FS block size
+    $XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile \
+        | grep atomic
+
+    # Check that we can perform an atomic write of len = FS block size
+    $XFS_IO_PROG -dc "pwrite -A -D 0 $bsize" $testfile | grep wrote
+
+    # Reject atomic write if len is out of bounds
+    $XFS_IO_PROG -dc "pwrite -A -D 0 $((bsize - 1))" $testfile
+    $XFS_IO_PROG -dc "pwrite -A -D 0 $((bsize + 1))" $testfile
+
+    _scratch_unmount
+}
+
+test_atomic_writes 4096
+test_atomic_writes 16384
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/611.out b/tests/xfs/611.out
new file mode 100644
index 00000000..ea28b971
--- /dev/null
+++ b/tests/xfs/611.out
@@ -0,0 +1,17 @@
+QA output created by 611
+
+Block size: 4096
+stat.atomic_write_unit_min = 4096
+stat.atomic_write_unit_max = 4096
+stat.atomic_write_segments_max = 1
+wrote 4096/4096 bytes at offset 0
+pwrite: Invalid argument
+pwrite: Invalid argument
+
+Block size: 16384
+stat.atomic_write_unit_min = 16384
+stat.atomic_write_unit_max = 16384
+stat.atomic_write_segments_max = 1
+wrote 16384/16384 bytes at offset 0
+pwrite: Invalid argument
+pwrite: Invalid argument
-- 
2.34.1

