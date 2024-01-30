Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D8F79959
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706658294; cv=fail; b=a3dKs7Kl8dOPMEtJG3q9vgpNsObFdpyMgJlB/XS/kZeEIw/E9EgzFppi/kUVBMOcDuLhPkxBJzbaOCjrPIeyUYQ02WmLUmEHK6cCd7f9BbVbyiMhNJEmdPIz+tOoMThccwar99l2EDjrBS7PpGta8gMSsaF5ZwhqYXxyEMAaWyE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706658294; c=relaxed/simple;
	bh=tM2ISFO5xvWCfC2gB2gXxiLxNsWZ3FOS97s2Egjje54=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H1EiipQhhOlautiAaNu/nW6HcQ6Ou0z/AimYuh4du1h1oesTQbSJjMYXWiue95TowpFNL3oFeFOD5/50TXuzJ0QCn0EXgQP/vFfQEwoTEhx+JY6ZYJ4QBT8o7fjoRcbCeOw6TdDYcaNMqycgTCY/Egkyaj50SYc0kwYEwnBBUJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iuzsJYzR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yRynxYul; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iuzsJYzR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yRynxYul"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKxj0F030554
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=6a/Vx+pcL13GNO3xhPo/HMGejI0TDJBNgPqeA/+05WI=;
 b=iuzsJYzRGtgI4qmzkykKzvHbBMM2261rW3dhAr0JeoDwZ5sm++xqTSzIzIYMP8cuk+vZ
 UFVXGdIngQSC86zzYVojcM8BidNocxurOt2G9Gcg0RyKx/4QgIYm1NiTisW0O7cp21jr
 1/XUs98W0NosY3ewS01GznDKlMV5GPVjwwce59J7I8iAU1W8jcVmhYgWhUcWwiw8Wy0Q
 Ag//V45SuZMSKuYpObuLyvGvi2KsXZs/fV8/8vn16sS8NDrz4bq3C1kWKNjqN5vGWLfJ
 PoCKEabK2/vEK3aHQ29D1yNEEXBBeE6vb8CDt7r8dWT38m7SjpFogoE/jgw4KBtYfP8R QQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvsqb0d1t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:51 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40UMtP9W014473
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:51 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr98011v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BO+19gJF2zllKgQBGrsovpJB7nIgO7zh4K4KY/EH1trARguzVDzzmpCy6Mw7Q+aWYj43+Gn8oby7pBtwuigrEedx1kLuWN1fKTDn9SCxur2naA7by7QY8cZhhEe93iOw5qSeJ3ec1s77GkWpzNtQajnyTb6s4tn+1XYCydcmkmfsAdiBPy0cak117hWYG+y854V6ucPaqOm5AgfFa1eVRpw1lrXfiwyMb9/aA8GAyoEfZGanawPNwT36x0JIcSgbZJDaHNRhMMxD3ZSCk84JWswPcKCO3GijsG08kbt0pVoTMuwxXgyKKHxUv5k0c1bzq/nbNQkix5x29UgIw+cVvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6a/Vx+pcL13GNO3xhPo/HMGejI0TDJBNgPqeA/+05WI=;
 b=UiIof2AR2Y+WOLGH3Xp8ONfbrXPO8rQHTSm97vimbDFXRNbBwSAED7ufMCDAfD8ewnOuTl/eO4jGMrA8ZIWvQkaZ4T3k482m1z2/8/ylvFZDN4iSeY8bqjcYatpMGPo25/hk2sDzUDWbqr4TokhLbFuXqGOiOv04xYY5q2ivCzxaCYRQjIdY5DUAXrZdcOPQeuiKrzAZhcOVIGoihEnCZB/YhTw5VHOGKYc7dkPJk2gl8YJry+e6idt+86umNgqiEt5GrseyFX+3hSjRychNWpv563YztlH/ggNYLvnc9xq1FxuyXP16BzQg+dmoc9ulVd2vsk0/lFep2OCxasxtdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6a/Vx+pcL13GNO3xhPo/HMGejI0TDJBNgPqeA/+05WI=;
 b=yRynxYul6+QSvSibcvpDeFLUQvJTpCYjsi4cocBhEnPrMXy9908R7zKsK5A5vvyQN7b5fC4SR0mZUH88nbPauCZ2D4w9lS+XrEQTnw22puzwn7Uq6VjX9Nx2xe13weOpXfaEmr4vpuXLv8CFoc1Pe/ZZZXNPnP35qJQyXwk1bLg=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BL3PR10MB6092.namprd10.prod.outlook.com (2603:10b6:208:3b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Tue, 30 Jan
 2024 23:44:49 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.017; Tue, 30 Jan 2024
 23:44:48 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v1 13/21] xfs: up(ic_sema) if flushing data device fails
Date: Tue, 30 Jan 2024 15:44:11 -0800
Message-Id: <20240130234419.45896-14-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240130234419.45896-1-catherine.hoang@oracle.com>
References: <20240130234419.45896-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0076.namprd03.prod.outlook.com
 (2603:10b6:a03:331::21) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BL3PR10MB6092:EE_
X-MS-Office365-Filtering-Correlation-Id: 2be8c793-e6f9-434a-6c2b-08dc21ed722c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	KYhRJPE7MjjQYwCnsrrQGWnYpBnhUsq7SgQXbeJd+/vwmp18fXK9b895O1Lu6XAspbby4odOkqLU99+oF7+pGt4AbjT+hgzR2HI6lus/+B8S9U6KlWB0LPDvZQyDNmWj/FDWq12d2knKUr7a/dK6h9wCvflPsCDnHZZRRi4UIaJgnZD1CG5EUfCxIzfg03vTolvyKbOgV4fX/+aA+ttMIgRcVvDCh7tm97zOjOzp1A9rkw+lihyLOaNvTLp06o10n5yv5KFIPyGiBgoriuSSOY9gx9VEvsRHKbeXsW0y2pesGHGGcYd/GKPHvdfTsrXLfvXCwGg8O9OvRxiFxgTLQQYV8lKg6Whg3Rn0X5cubvGwzUtwEFikvpbyFUQUNkvcxtdal5xL5X7bvosLZERV2eW5TcAaNOrbL/FeP1N7fFA2FQHk5qojmLQRfA8bhyh2QlpU73twK/kZ1+TMHwND3R234WOWVLZ4ikaTxTA3aPHjePpZWcB7D4kRPbOcobysibUWbBQAQsJVufDe+X17r/FvZf6hjH0HtPlVsEmQP6lFTj/8gj8X2NN5ab7sXZZ5cUV5912Ww77ui6OSX7Y7dRxppxng/hRxoZl7KFfDfzsvXLIBt6gw1VQhafP7gaXl
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(346002)(136003)(230173577357003)(230273577357003)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(41300700001)(8936002)(36756003)(86362001)(66476007)(38100700002)(478600001)(2616005)(83380400001)(1076003)(6512007)(66556008)(66946007)(6486002)(316002)(6916009)(6666004)(6506007)(8676002)(5660300002)(44832011)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?aucM0DI2TG8EAeUsNP4t56oBkuBx7M6qfyH47tc7QNY0zTRCv5OtqhxWMfgb?=
 =?us-ascii?Q?2a32e7/FYWjlAgEgm5xHfAUM2Iy01pe00ws0rmY4pUucOcn3y86EBtiZyKYr?=
 =?us-ascii?Q?cuH0bvQOY7+RjwZYWmwpYr3XKPzyGcpIOOddA4PMSq7S0ZZHQ+rRzg++20s5?=
 =?us-ascii?Q?oz3Cw8HVf8q2uQLkI4rCQf6+r+TvIvAHxJqnevWRWgr7+GRZzK4/BShgWmxT?=
 =?us-ascii?Q?VqRa/i8jNbcvKGMkLiUaM00HqR70vSPRjUvyYWHRH7t96gpBSDlCriAYPwEH?=
 =?us-ascii?Q?HkYUrx6+x4xmbx8NHlfF6+ivHSBxrNOhc22cZgkfKBCJAnb2/5RFzX3pchap?=
 =?us-ascii?Q?UDADJxaHnLgtzHPpsr0QJK1WVze545Ql7BJkkoPiMzoVXtmUf7bUHNknYckm?=
 =?us-ascii?Q?rbakAVRqVhRffAuDz/VHhORComvSYju9LRJ8tCSEROBbrIMwqmJeKQ63o0gR?=
 =?us-ascii?Q?zJLCQKJ+JDZylnQ3LqSJO/nkUcFAyAhqBp9fyzsPT9OgGzT4uz/Gr3BniNT9?=
 =?us-ascii?Q?5LnLPBGiUBPSF2CVyk97/1fnwv7qqbVLg825lZEZ23GRPQiO2XULsr1kqaq+?=
 =?us-ascii?Q?bre1THwBYKOVrS39n+UenuCJ1FzJy8lM8kPPqKmr/5c+yTcIeApjfxJTYiYU?=
 =?us-ascii?Q?SzPyesHx053UABpsf5VMsCFiy3F2+KQOy1QBgZPmT2fZ5XpSY34VE/DKlq/f?=
 =?us-ascii?Q?m9JKiMArB2WP44vKx5rf8yfzFdTdErxN9gcG1IfRCBaJed7GDOZ6UaEIMxTV?=
 =?us-ascii?Q?EyQadiW/wsVZKK1vnyh+b2SGPFi+WLFO7ZDNOU5o7Fn8vASuNsDpmBtSnYQ5?=
 =?us-ascii?Q?WAWPY1/WvEYRryJ/jiBYOBep3vo4g1fqoBbMijwfHA/vyH5gND3/rjRzUXzN?=
 =?us-ascii?Q?WamRzcTUZMocxlQQf71hvec3VpScXbEoIYo/BH9/1u7AD5DpjKVTEX69of6l?=
 =?us-ascii?Q?c6ACFOwtEGSXx6EdFGY++IOiu4c9CqWlbSOvQ5aJimVAR0o9NF7CHerPiQGV?=
 =?us-ascii?Q?mRBd3F0O25cLQoGTa6RLEJkuoTQfeR1VCD18ce4R1Gv4CDZm1CBFEmOizElK?=
 =?us-ascii?Q?Ut4PCUw99gUgAys0iVm/OFxMzObSWzUf/cWsecTdORFQstLj8OTWOqB7shfN?=
 =?us-ascii?Q?JRs0lvOa219MvcdbWpDJX+ijcZYh6M7eflKEWNXmFhjQxTsm7HT2daxlmy21?=
 =?us-ascii?Q?haTAdJ0kVF7m/IysnSVURr6Gf6yQPSasfZdUFO1VHHSJvkeM85zivsE5jZrM?=
 =?us-ascii?Q?tlE39U3OFVVPkSn+lUxomlFlXGwkX01315MsP37pc0W9Szv+Or2Szz4ek6U4?=
 =?us-ascii?Q?BKjgkeFT5O2mP0YCM3DLfHNp8m7k+QUawiPX6u194XYsu37oE+lUbc5vvtZA?=
 =?us-ascii?Q?usGlJ8mfRxtuNC5k0DtQbzerxzv7rwzmOfCCtP3SLafJejtPf+ypaOWWJqqp?=
 =?us-ascii?Q?I1Ys2ZbHEdow6RdE1gWWJc2x2xJ2rTp5RZITPHhOzLqh0zBUn2kZF1VAd83z?=
 =?us-ascii?Q?RfSKZY+EuDZ1HOcos66jm7PQXbmphEfk/gbPc+J9bUGzQE/PM0+SwMMMe6Jk?=
 =?us-ascii?Q?ShUW7ODDNBOmOi/RHVy3tYtFsWlusqomgBYIxNKUrAYpHit/jGOqFj3SoRAr?=
 =?us-ascii?Q?vIS6MGeK9tClMizT5iNo0VlMwestlv9E4Nb0y1L+E+LLnoDvnBI8XpB6VcVO?=
 =?us-ascii?Q?Ol/S/A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	jwuSMvb6iUqJ2dGoyLVFemaK88vRWo/yHtc4nELSIRAq1VgUfeKNPtwvY+Gy9L85y20wDQvSw6WkpvX7uauyFjL+VV+IIQGlhCbvlWjjz5bq0bR5PiwYUrDhHzZYSz3y9N4LQqnTWstJ4/yg6Bp1VEyH97CG2Zexu3z8Y+tuTvBx0ZMmoUVR5kA0Q9aUvr7H2y6lwizDif1msYK2ECcxYRiwY4eDhzXeDjbcLpfPq9QX4NF01KYbpnfYCHLcYgMPmJS9+/HuUQu20rw6vgZXcDhYhl/nO19nDNl3KYpEloShuegPmIEv/PzjYx24oAgFvYeVUohFDh2ws+ZaGw9UDtYI+p8C/SK+ZjW/W8KTxddIssW/cW0D8yOWTS6dWAvsWV+dsSamKSUlb3hsSZeIFwfkbzs9SAs/mfROBCY8rvHMV+FtY+WtxHc7iyv88i9R/hGKJhB/5vBMR7pTzlkJUWsNIijTWxAGTLzY5DXUfHcb37SZ9Znzj6QGVf9osxWcbEe2xVmtTLtN+dVzoM0iLv+Y1h3BDloClo6Iy+EzCgHGPywobiD+l4v5m9PkFZBlO6zKpTCBItow4O7E9p81P7oCIb5sws4kdqUr2D0JekU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2be8c793-e6f9-434a-6c2b-08dc21ed722c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 23:44:48.7096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aOYbs+deUGUJ+vMZPjSACc/Fhj6r+VMF8/3B4IAFXTx3ahl963OK4MbsUcdkC2oH1uiPLA01/DRJIFG3B3kCp+9UtWir3TUdXhSjiwEZdOI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6092
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_12,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401300179
X-Proofpoint-GUID: 6K_XOrQmLUp-fU7u90KLAd67P03sMunA
X-Proofpoint-ORIG-GUID: 6K_XOrQmLUp-fU7u90KLAd67P03sMunA

From: Leah Rumancik <leah.rumancik@gmail.com>

commit 471de20303dda0b67981e06d59cc6c4a83fd2a3c upstream.

We flush the data device cache before we issue external log IO. If
the flush fails, we shut down the log immediately and return. However,
the iclog->ic_sema is left in a decremented state so let's add an up().
Prior to this patch, xfs/438 would fail consistently when running with
an external log device:

sync
  -> xfs_log_force
  -> xlog_write_iclog
      -> down(&iclog->ic_sema)
      -> blkdev_issue_flush (fail causes us to intiate shutdown)
          -> xlog_force_shutdown
          -> return

unmount
  -> xfs_log_umount
      -> xlog_wait_iclog_completion
          -> down(&iclog->ic_sema) --------> HANG

There is a second early return / shutdown. Make sure the up() happens
for it as well. Also make sure we cleanup the iclog state,
xlog_state_done_syncing, before dropping the iclog lock.

Fixes: b5d721eaae47 ("xfs: external logs need to flush data device")
Fixes: 842a42d126b4 ("xfs: shutdown on failure to add page to log bio")
Fixes: 7d839e325af2 ("xfs: check return codes when flushing block devices")
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_log.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 51c100c86177..ee206facf0dc 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1893,9 +1893,7 @@ xlog_write_iclog(
 		 * the buffer manually, the code needs to be kept in sync
 		 * with the I/O completion path.
 		 */
-		xlog_state_done_syncing(iclog);
-		up(&iclog->ic_sema);
-		return;
+		goto sync;
 	}
 
 	/*
@@ -1925,20 +1923,17 @@ xlog_write_iclog(
 		 * avoid shutdown re-entering this path and erroring out again.
 		 */
 		if (log->l_targ != log->l_mp->m_ddev_targp &&
-		    blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev)) {
-			xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
-			return;
-		}
+		    blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev))
+			goto shutdown;
 	}
 	if (iclog->ic_flags & XLOG_ICL_NEED_FUA)
 		iclog->ic_bio.bi_opf |= REQ_FUA;
 
 	iclog->ic_flags &= ~(XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
 
-	if (xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count)) {
-		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
-		return;
-	}
+	if (xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count))
+		goto shutdown;
+
 	if (is_vmalloc_addr(iclog->ic_data))
 		flush_kernel_vmap_range(iclog->ic_data, count);
 
@@ -1959,6 +1954,12 @@ xlog_write_iclog(
 	}
 
 	submit_bio(&iclog->ic_bio);
+	return;
+shutdown:
+	xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
+sync:
+	xlog_state_done_syncing(iclog);
+	up(&iclog->ic_sema);
 }
 
 /*
-- 
2.39.3

