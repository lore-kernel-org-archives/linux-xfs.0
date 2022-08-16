Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC8A5C32772
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Aug 2022 22:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237319AbiHPWvF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 18:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbiHPWvE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Aug 2022 18:51:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B1E8B996
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 15:51:00 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27GL9JIq004844
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 22:51:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=kndsElvO8i0A9/Ef8D2/VmkhzBv6407g2oSKM8uHxBQ=;
 b=CB9WmPPnGlNJe/leKxAHDrLQ10oYtqpfSi/xwK2MY7EUXJ6LD2ogoGAtpY0/J+kVSDr9
 VhZDmrGb8bLIJvhUAdta54yKDBKHEeil5Dx1jvOPhb4WKzr1jgwJCCUXKrmLMD5Lma6D
 MEfFMny2aveNRvw3wqjySPILuyntL8pia2bDCNpNQfZwPYRAGJ6PdslcHysYro3fQvOh
 g/r9BzCQv122uUh02X0HAZpLntbPTOqgx8Z6zd2AAgxAeDpZyBB3NBu+Kf94eap77ESv
 q6VKi4vaXPJxqpmfFlOaB4eaNX+v/O3xEltHQaF4vfQnZerOPCfUiHAGrfshsxslFfwO Uw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hx3ua77f6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 22:51:00 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27GL5Zb7004907
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 22:50:59 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3j0c6cqu1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 22:50:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gy2IYXgkIrwW+J6Fkcw9LQwh5Pf9Epn/EuSN4rijE2cEtv1otoJ+XRXMHl+D9O4wXpHWmnnE50xM85Gj/Xb/R+tNjXgzWF2Tr7QDamFECwoAVkToB7ZzaRbdSIPsfOpR69mZvE9ZzbmtIn7xfkHmc9gJyx4Rgj7OJAlQJGdeEaeFC84jiv+GpC16oMFeGp3gPy7trx+0Si42+cXxnRM4sUitCIvjkmT2gsgiZxhgI/y6lGb46blH64NvOD0CDeN7AAahT9iRR/sHC+tbf4DM0uahU61s6E1xTeyb8uIQ1LF2V80htHtY+r1EPr9997uERtpM4nuhieOkMU+/9TKW2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kndsElvO8i0A9/Ef8D2/VmkhzBv6407g2oSKM8uHxBQ=;
 b=VpOEpt1e23yqaUtHtF6yAfIfjKwfcOxBb+p5epQtlnOS63fcuCK/cGGaPyRNJEj902ONp3sbXCjqLtUGUn/nW7QrTUXEvtGi3p8WfbZPftpH5artx4UcyWsyGIL0KMBNLn26XS64AA/s0AzvVIxggMiXTynVks9aieqWu+jGuL1OMdo0VIPxspeQcZ7BvdmvC2h4VOFpn9P6ywYd0k9vzIxdep1nb8TMYsy3L5luvpLaNOsOIugpVez6boACvOUowPd2TFUuMtPQbvbc10LHvvBKmuDrbczAjH3HjmJoRazGM8RAhky/lt03fDA7Z9nF3+08Inz2QK+ZXa0e1uhNrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kndsElvO8i0A9/Ef8D2/VmkhzBv6407g2oSKM8uHxBQ=;
 b=XVL7VDCcYW9YkkM6G4gjTBseFawE3VBRF3+HEEBhxWwDgFlbDRMyw1fsIEXMn8qab3L0iuSOod/I9a3gyCeyYtsr+nWa1FLxjGhbW1/WZPATVcnj3ZfpTwOSyxP/FRgabVyOQZk1WZ8uL0Ls4nNtTvwcvymlUXWMVU91gj0r3Do=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH7PR10MB5721.namprd10.prod.outlook.com (2603:10b6:510:130::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.21; Tue, 16 Aug
 2022 22:50:56 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::cdcc:bfdc:551c:8632]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::cdcc:bfdc:551c:8632%3]) with mapi id 15.20.5525.010; Tue, 16 Aug 2022
 22:50:56 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 1/1] xfs: add larp state machine diagram
Date:   Tue, 16 Aug 2022 15:50:47 -0700
Message-Id: <20220816225047.97828-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220816225047.97828-1-catherine.hoang@oracle.com>
References: <20220816225047.97828-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0048.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::23) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0b8840b-201f-40bd-069a-08da7fd9c707
X-MS-TrafficTypeDiagnostic: PH7PR10MB5721:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0XGTyz5dg2WhIZmcz8F1+jNN3upSq3FUbdRTiGoDdY0PqS5j1aYVl7F2z9El2p9tXRQYRXI+kJoptHJSkHCjYfqMTvzKd8S0cVaiZ0hLcN+Oayft8hUU5y8tEMnQol5IkSswQxXnGrMz+WoRbY0cgi1k+iYaOx4Sy9B6g3GwHHpAGGlCsjl6RlMB0JElWdMmSDrdRxP03Qp0/repxHSt7+xEp792XSSlwMEOgiiWdg0Tis7t4KO7Lh4ZCTOdGeWNrJ3xuYT0/gVk5ZynE+K8JxJ1aHSTtfLaE7Tfsse9kbF+3d/t0MV/vxRgNdrbqzNHjxHnQ8Lr473VM0S2ikT94ZMMim9uY58BoWkdtXBZZ1f5L+mq53Fl/pQRykIWSfxHEOxticW3vo20nSxCObtOb4P8DPIHtax8XmI2rKYO611NpjiTmTGq0wA10CbBLKBVJYNtGOyPjuNJUU8WBt3ru3WZj5HjtMlJRwquxNPRhpy3YfQazxvee7dTCsEp1mDu4byLpGwL18FnQyeb7aP00VUD7Xfma4BxC6Delc9Z5fjJc94xy8iZ7gEZuG3KtWY0LVdJEJp2t9YH2yrwY2A3C4pda5XD2XH8DjoFlIJB4fUBhhG6JdGCvwx5miIjDukjd3sAJiTl84jUIFBh0S0lYJnrtfejAmPA69WRQx1Gq7Abc+ACrbgFcKvDNVUVk0gNl7cMwfT+nm3ds7A6bs5tJGhTkXljyd2O8uKWxFmREaBmgkJsllYkk7JA311DGACm2ePffs+KfPzuMcpzZEkv1PHJ4C9VIaDWJyO0zzI56jT1KlX9mNO289AcafSWMMh5wyhIjhQXoMr6jSEIsns3PwTLQFcQbCuC0ZMhQWyNe1M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(136003)(39860400002)(396003)(366004)(52116002)(2906002)(66556008)(5660300002)(36756003)(66946007)(8676002)(1076003)(186003)(478600001)(66476007)(2616005)(44832011)(86362001)(6486002)(30864003)(26005)(38100700002)(6506007)(8936002)(6916009)(6666004)(316002)(41300700001)(83380400001)(38350700002)(6512007)(579004)(559001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tvDrxdU851fnWODw5n96mtSGHLukfFR48ZEYC7D1V5v0cwzyaweAwUqdVr6J?=
 =?us-ascii?Q?VWY7WrFi1nBleo/GrItwMZ8uYATbr0OTZL8ME30M3q/F907lT2stc7moO3uG?=
 =?us-ascii?Q?JkMsrBf3Wpnm0GkfZQxunF5UMOe81iQNkle7BpO8UVsPq9SPqezN+OngZTd1?=
 =?us-ascii?Q?a+7Y0STK74HIkCtPr79xKNQcdJ4WKkIu72MaOgyKXWcjYxanEEpQL6ojcjgT?=
 =?us-ascii?Q?0fz0ybsXKM7itA8g24kKaVBxnCTxuy0bZhL55BYCv7LaWSrSkX75aTA21x7a?=
 =?us-ascii?Q?5u214zDIY5ZCten8UpLahm88hDJLH6k/6/2+Vv4DBTOnqjN5pnDBMD501IW7?=
 =?us-ascii?Q?FJniLorsqJlVQHKvnSgPcDO77L3MseK2Rujwx1ufJas1MQuFSQZLV9pSftte?=
 =?us-ascii?Q?mXGSv/3osbTP10gM0WIw/rjtJ1R0Q4sISaDBfRSAckilIOfq/9vuoiTf4c5K?=
 =?us-ascii?Q?adhAYpegNzhfF22aF5ozPU2bNR2KHXmRQt3NB0jUVczEzOGbCTOHm7af92ls?=
 =?us-ascii?Q?WNOXrtLC3gxyTL/9ikC2Q97nf6Y/KdnWI67JJomWsZDOAjjIg0CyGRYsp6BV?=
 =?us-ascii?Q?0GgDFJ0NxAhotR5GWKjiwKhqL/SaWKDZUk5bJORp3VLbccmkuvufgRQM+fCB?=
 =?us-ascii?Q?bAANu0PqiMCuC9AEo+Ya5tD+I7Hf1R5WnSyOviIuReuyDvSlmq90COnwQlX1?=
 =?us-ascii?Q?nBt22pU4l9qlhRUxQGeTrOE1Nn6cyOYMq6pfsWvulmvQdbZj4d4CE29UYtKX?=
 =?us-ascii?Q?Ikfj5J+KoKVKon+w/27PfkgOabBssu5cYTVMZIroU8iV0+fHkzT2wPDTBL3x?=
 =?us-ascii?Q?XNO+s7b0vL0LbsEZcjMO4k6qBuZK+kkKpigoF2uV4wbcpA7rgSyVaiJDNgBv?=
 =?us-ascii?Q?4W+xnz2uZrBD+svYyPbN/GGmWUn6Dc5E8T6gHu8lW96y1YUKPz2wg2PR1UYx?=
 =?us-ascii?Q?UEqPLNnJINO94JYRrqyxzKULYx9uQfOy6QanvcyHEvOY50nN4/ULE0lccsQT?=
 =?us-ascii?Q?/yQZxKO2DACHRKTY3nq9KTOz1Cu2bSod6jxnis0VhNp1gl9bXWZBjZyz/oNz?=
 =?us-ascii?Q?sw5BCFTucgMn7XhkoV+/I6bBMP4UgzfeEO9ZBnWngA47JtNgQrzOrWWNUbtw?=
 =?us-ascii?Q?ckJCGHKeT/17zFQf8ZkXRZcvVfTUezkDrJVSmkcIuEqBEjuJ8j/1QxMs5zmC?=
 =?us-ascii?Q?LVD5VHbzJnk5h6i+zkFfz1wDioT6gSR4TLnLj1Vo/Cfz9+DfaUtwozPAa+FX?=
 =?us-ascii?Q?xS4V3xCWHoHdElafd12IZ6u40oCbDPOIZr6IfQp8x1zs6eMKxJbAYAtG/CS4?=
 =?us-ascii?Q?BnK62HI4N4GykaFK00NewfZe6onn8qqvF2B96LNSywjkKQg0IUZje5A5f5f2?=
 =?us-ascii?Q?kVuydULPeX1cEFzHPyTThf5WhhWKa4KllzF6/9m7i55yvrZ2PcH2AFREIgDJ?=
 =?us-ascii?Q?SXha4CqqBMAVRHIJLikknllkULPLm4s5nnATTbJYJ8QIAFv1Q+TzedE7vrvf?=
 =?us-ascii?Q?twAkJA+t/dQUbb8F4PvQZpXN6rOZ/VcwBwKQV2TqWJOJDHYWbEO56aE04SHE?=
 =?us-ascii?Q?sG1Nze3IuBuWaoecPN8+eWeUhy4Jp9ltNL82aj/x?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0b8840b-201f-40bd-069a-08da7fd9c707
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 22:50:55.2447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OtldUv5WLO59PKsKLvJ3FN2twk7VN4CflxFZQr44I+RU/muz5AVG+LdpBh1BqbrpMtl4K5+9SnX6qJ1vcReI6rUnK8Ba4rQ7/SSZdZOfUig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5721
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_08,2022-08-16_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208160082
X-Proofpoint-ORIG-GUID: oKyuCZWVtLgYyNV7ZVP3ZSjxDwiVjemP
X-Proofpoint-GUID: oKyuCZWVtLgYyNV7ZVP3ZSjxDwiVjemP
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add a state transition diagram documenting each logged attribute state
and their transition conditions.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 Documentation/filesystems/xfs-larp-diagram.svg | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 Documentation/filesystems/xfs-larp-diagram.svg

diff --git a/Documentation/filesystems/xfs-larp-diagram.svg b/Documentation=
/filesystems/xfs-larp-diagram.svg
new file mode 100644
index 000000000000..1a30b4856e2c
--- /dev/null
+++ b/Documentation/filesystems/xfs-larp-diagram.svg
@@ -0,0 +1 @@
+<?xml version=3D"1.0" encoding=3D"UTF-8"?><!DOCTYPE svg PUBLIC "-//W3C//DT=
D SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"><svg xmln=
s=3D"http://www.w3.org/2000/svg" xmlns:xlink=3D"http://www.w3.org/1999/xlin=
k" width=3D"1478px" height=3D"1820px" viewBox=3D"-0.5 -0.5 1478 1820"><defs=
/><g><path d=3D"M 720 8 L 720 99.76" fill=3D"none" stroke=3D"#ff8000" strok=
e-width=3D"2" stroke-miterlimit=3D"10" pointer-events=3D"stroke"/><path d=
=3D"M 720 105.76 L 716 97.76 L 720 99.76 L 724 97.76 Z" fill=3D"#ff8000" st=
roke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D"10" pointer-events=
=3D"all"/><ellipse cx=3D"720" cy=3D"28" rx=3D"20" ry=3D"20" fill=3D"#ff8000=
" stroke=3D"#0000cc" pointer-events=3D"all"/><path d=3D"M 700 128 L 244.8 1=
28 Q 234.8 128 234.79 138 L 234.67 357.22" fill=3D"none" stroke=3D"#ff8000"=
 stroke-width=3D"2" stroke-miterlimit=3D"10" pointer-events=3D"stroke"/><pa=
th d=3D"M 234.67 363.22 L 230.67 355.22 L 234.67 357.22 L 238.67 355.22 Z" =
fill=3D"#ff8000" stroke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D=
"10" pointer-events=3D"all"/><g transform=3D"translate(-0.5 -0.5)"><switch>=
<foreignObject pointer-events=3D"none" width=3D"100%" height=3D"100%" requi=
redFeatures=3D"http://www.w3.org/TR/SVG11/feature#Extensibility" style=3D"o=
verflow:visible;text-align:left"><div xmlns=3D"http://www.w3.org/1999/xhtml=
" style=3D"display:flex;align-items:unsafe center;justify-content:unsafe ce=
nter;width:1px;height:1px;padding-top:112px;margin-left:562px"><div data-co=
lors=3D"color: rgb(0, 0, 0); " style=3D"box-sizing:border-box;font-size:0px=
;text-align:center"><div style=3D"display:inline-block;font-size:18px;font-=
family:Helvetica;color:rgb(0, 0, 0);line-height:1.2;pointer-events:all;whit=
e-space:nowrap"><font style=3D"font-size:18px">add new attr</font></div></d=
iv></div></foreignObject><text x=3D"562" y=3D"117" fill=3D"rgb(0, 0, 0)" fo=
nt-family=3D"Helvetica" font-size=3D"18px" text-anchor=3D"middle">add new a=
ttr</text></switch></g><path d=3D"M 720 118 L 720 199.76" fill=3D"none" str=
oke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D"10" pointer-events=
=3D"stroke"/><path d=3D"M 720 205.76 L 716 197.76 L 720 199.76 L 724 197.76=
 Z" fill=3D"#ff8000" stroke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimi=
t=3D"10" pointer-events=3D"all"/><g transform=3D"translate(-0.5 -0.5)"><swi=
tch><foreignObject pointer-events=3D"none" width=3D"100%" height=3D"100%" r=
equiredFeatures=3D"http://www.w3.org/TR/SVG11/feature#Extensibility" style=
=3D"overflow:visible;text-align:left"><div xmlns=3D"http://www.w3.org/1999/=
xhtml" style=3D"display:flex;align-items:unsafe center;justify-content:unsa=
fe center;width:1px;height:1px;padding-top:172px;margin-left:736px"><div da=
ta-colors=3D"color: rgb(0, 0, 0); " style=3D"box-sizing:border-box;font-siz=
e:0px;text-align:center"><div style=3D"display:inline-block;font-size:18px;=
font-family:Helvetica;color:rgb(0, 0, 0);line-height:1.2;pointer-events:all=
;white-space:nowrap"><font style=3D"font-size:18px">replace existing attr</=
font></div></div></div></foreignObject><text x=3D"736" y=3D"177" fill=3D"rg=
b(0, 0, 0)" font-family=3D"Helvetica" font-size=3D"18px" text-anchor=3D"mid=
dle">replace existing attr</text></switch></g><path d=3D"M 705 128 L 1182.6=
 128 Q 1192.6 128 1192.6 138 L 1192.5 357.76" fill=3D"none" stroke=3D"#ff80=
00" stroke-width=3D"2" stroke-miterlimit=3D"10" pointer-events=3D"stroke"/>=
<path d=3D"M 1192.5 363.76 L 1188.5 355.76 L 1192.5 357.76 L 1196.5 355.77 =
Z" fill=3D"#ff8000" stroke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=
=3D"10" pointer-events=3D"all"/><g transform=3D"translate(-0.5 -0.5)"><swit=
ch><foreignObject pointer-events=3D"none" width=3D"100%" height=3D"100%" re=
quiredFeatures=3D"http://www.w3.org/TR/SVG11/feature#Extensibility" style=
=3D"overflow:visible;text-align:left"><div xmlns=3D"http://www.w3.org/1999/=
xhtml" style=3D"display:flex;align-items:unsafe center;justify-content:unsa=
fe center;width:1px;height:1px;padding-top:112px;margin-left:921px"><div da=
ta-colors=3D"color: rgb(0, 0, 0); " style=3D"box-sizing:border-box;font-siz=
e:0px;text-align:center"><div style=3D"display:inline-block;font-size:18px;=
font-family:Helvetica;color:rgb(0, 0, 0);line-height:1.2;pointer-events:all=
;white-space:nowrap"><font style=3D"font-size:18px">remove existing attr</f=
ont></div></div></div></foreignObject><text x=3D"921" y=3D"117" fill=3D"rgb=
(0, 0, 0)" font-family=3D"Helvetica" font-size=3D"18px" text-anchor=3D"midd=
le">remove existing attr</text></switch></g><path d=3D"M 720 108 L 740 128 =
L 720 148 L 700 128 Z" fill=3D"#ff8000" stroke=3D"#0000cc" stroke-miterlimi=
t=3D"10" pointer-events=3D"all"/><rect y=3D"366" width=3D"437" height=3D"49=
2" rx=3D"10" ry=3D"10" fill=3D"#ffffff" stroke=3D"#0000cc" pointer-events=
=3D"all"/><rect x=3D"15" y=3D"346" width=3D"110" height=3D"20" fill=3D"#fff=
fff" stroke=3D"#0000cc" pointer-events=3D"all"/><g fill=3D"#000000" font-fa=
mily=3D"Helvetica" font-weight=3D"bold" font-size=3D"13px"><text x=3D"19.5"=
 y=3D"361.5">ADD</text></g><rect x=3D"645" y=3D"227" width=3D"162" height=
=3D"80" rx=3D"10" ry=3D"10" fill=3D"#ffffff" stroke=3D"#0000cc" pointer-eve=
nts=3D"all"/><rect x=3D"660" y=3D"207" width=3D"110" height=3D"20" fill=3D"=
#ffffff" stroke=3D"#0000cc" pointer-events=3D"all"/><g fill=3D"#000000" fon=
t-family=3D"Helvetica" font-weight=3D"bold" font-size=3D"13px"><text x=3D"6=
64.5" y=3D"222.5">REPLACE</text></g><rect x=3D"949" y=3D"366" width=3D"487"=
 height=3D"438" rx=3D"10" ry=3D"10" fill=3D"#ffffff" stroke=3D"#0000cc" poi=
nter-events=3D"all"/><rect x=3D"964" y=3D"346" width=3D"110" height=3D"20" =
fill=3D"#ffffff" stroke=3D"#0000cc" pointer-events=3D"all"/><g fill=3D"#000=
000" font-family=3D"Helvetica" font-weight=3D"bold" font-size=3D"13px"><tex=
t x=3D"968.5" y=3D"361.5">REMOVE</text></g><path d=3D"M 706 269 L 337.8 268=
.03 Q 327.8 268 327.79 278 L 327.75 357.76" fill=3D"none" stroke=3D"#ff8000=
" stroke-width=3D"2" stroke-miterlimit=3D"10" pointer-events=3D"stroke"/><p=
ath d=3D"M 327.75 363.76 L 323.76 355.76 L 327.75 357.76 L 331.76 355.77 Z"=
 fill=3D"#ff8000" stroke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=
=3D"10" pointer-events=3D"all"/><g transform=3D"translate(-0.5 -0.5)"><swit=
ch><foreignObject pointer-events=3D"none" width=3D"100%" height=3D"100%" re=
quiredFeatures=3D"http://www.w3.org/TR/SVG11/feature#Extensibility" style=
=3D"overflow:visible;text-align:left"><div xmlns=3D"http://www.w3.org/1999/=
xhtml" style=3D"display:flex;align-items:unsafe center;justify-content:unsa=
fe center;width:1px;height:1px;padding-top:252px;margin-left:560px"><div da=
ta-colors=3D"color: rgb(0, 0, 0); " style=3D"box-sizing:border-box;font-siz=
e:0px;text-align:center"><div style=3D"display:inline-block;font-size:18px;=
font-family:Helvetica;color:rgb(0, 0, 0);line-height:1.2;pointer-events:all=
;white-space:nowrap"><font style=3D"font-size:18px">larp disabled</font></d=
iv></div></div></foreignObject><text x=3D"560" y=3D"257" fill=3D"rgb(0, 0, =
0)" font-family=3D"Helvetica" font-size=3D"18px" text-anchor=3D"middle">lar=
p disabled</text></switch></g><path d=3D"M 53 608 L 82.76 608" fill=3D"none=
" stroke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D"10" pointer-ev=
ents=3D"stroke"/><path d=3D"M 88.76 608 L 80.76 612 L 82.76 608 L 80.76 604=
 Z" fill=3D"#ff8000" stroke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimi=
t=3D"10" pointer-events=3D"all"/><ellipse cx=3D"43" cy=3D"608" rx=3D"10" ry=
=3D"10" fill=3D"#ff8000" stroke=3D"#0000cc" pointer-events=3D"all"/><path d=
=3D"M 131 608 L 194.76 608" fill=3D"none" stroke=3D"#ff8000" stroke-width=
=3D"2" stroke-miterlimit=3D"10" pointer-events=3D"stroke"/><path d=3D"M 200=
.76 608 L 192.76 612 L 194.76 608 L 192.76 604 Z" fill=3D"#ff8000" stroke=
=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D"10" pointer-events=3D"=
all"/><g transform=3D"translate(-0.5 -0.5)"><switch><foreignObject pointer-=
events=3D"none" width=3D"100%" height=3D"100%" requiredFeatures=3D"http://w=
ww.w3.org/TR/SVG11/feature#Extensibility" style=3D"overflow:visible;text-al=
ign:left"><div xmlns=3D"http://www.w3.org/1999/xhtml" style=3D"display:flex=
;align-items:unsafe center;justify-content:unsafe center;width:1px;height:1=
px;padding-top:598px;margin-left:163px"><div data-colors=3D"color: rgb(0, 0=
, 0); " style=3D"box-sizing:border-box;font-size:0px;text-align:center"><di=
v style=3D"display:inline-block;font-size:18px;font-family:Helvetica;color:=
rgb(0, 0, 0);line-height:1.2;pointer-events:all;white-space:nowrap">leaf</d=
iv></div></div></foreignObject><text x=3D"163" y=3D"603" fill=3D"rgb(0, 0, =
0)" font-family=3D"Helvetica" font-size=3D"18px" text-anchor=3D"middle">lea=
f</text></switch></g><path d=3D"M 111 628 L 111 776 Q 111 786 121 786 L 194=
.76 786" fill=3D"none" stroke=3D"#ff8000" stroke-width=3D"2" stroke-miterli=
mit=3D"10" pointer-events=3D"stroke"/><path d=3D"M 200.76 786 L 192.76 790 =
L 194.76 786 L 192.76 782 Z" fill=3D"#ff8000" stroke=3D"#ff8000" stroke-wid=
th=3D"2" stroke-miterlimit=3D"10" pointer-events=3D"all"/><g transform=3D"t=
ranslate(-0.5 -0.5)"><switch><foreignObject pointer-events=3D"none" width=
=3D"100%" height=3D"100%" requiredFeatures=3D"http://www.w3.org/TR/SVG11/fe=
ature#Extensibility" style=3D"overflow:visible;text-align:left"><div xmlns=
=3D"http://www.w3.org/1999/xhtml" style=3D"display:flex;align-items:unsafe =
center;justify-content:unsafe center;width:1px;height:1px;padding-top:774px=
;margin-left:163px"><div data-colors=3D"color: rgb(0, 0, 0); " style=3D"box=
-sizing:border-box;font-size:0px;text-align:center"><div style=3D"display:i=
nline-block;font-size:18px;font-family:Helvetica;color:rgb(0, 0, 0);line-he=
ight:1.2;pointer-events:all;white-space:nowrap">node</div></div></div></for=
eignObject><text x=3D"163" y=3D"779" fill=3D"rgb(0, 0, 0)" font-family=3D"H=
elvetica" font-size=3D"18px" text-anchor=3D"middle">node</text></switch></g=
><path d=3D"M 111 588 L 111 448 Q 111 438 121 438 L 194.76 438" fill=3D"non=
e" stroke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D"10" pointer-e=
vents=3D"stroke"/><path d=3D"M 200.76 438 L 192.76 442 L 194.76 438 L 192.7=
6 434 Z" fill=3D"#ff8000" stroke=3D"#ff8000" stroke-width=3D"2" stroke-mite=
rlimit=3D"10" pointer-events=3D"all"/><g transform=3D"translate(-0.5 -0.5)"=
><switch><foreignObject pointer-events=3D"none" width=3D"100%" height=3D"10=
0%" requiredFeatures=3D"http://www.w3.org/TR/SVG11/feature#Extensibility" s=
tyle=3D"overflow:visible;text-align:left"><div xmlns=3D"http://www.w3.org/1=
999/xhtml" style=3D"display:flex;align-items:unsafe center;justify-content:=
unsafe center;width:1px;height:1px;padding-top:422px;margin-left:153px"><di=
v data-colors=3D"color: rgb(0, 0, 0); " style=3D"box-sizing:border-box;font=
-size:0px;text-align:center"><div style=3D"display:inline-block;font-size:1=
8px;font-family:Helvetica;color:rgb(0, 0, 0);line-height:1.2;pointer-events=
:all;white-space:nowrap"><font style=3D"font-size:18px">shortform</font></d=
iv></div></div></foreignObject><text x=3D"153" y=3D"427" fill=3D"rgb(0, 0, =
0)" font-family=3D"Helvetica" font-size=3D"18px" text-anchor=3D"middle">sho=
rtform</text></switch></g><path d=3D"M 111 588 L 131 608 L 111 628 L 91 608=
 Z" fill=3D"#ff8000" stroke=3D"#0000cc" stroke-miterlimit=3D"10" pointer-ev=
ents=3D"all"/><path d=3D"M 303 488 L 303 549.76" fill=3D"none" stroke=3D"#f=
f8000" stroke-width=3D"2" stroke-miterlimit=3D"10" pointer-events=3D"stroke=
"/><path d=3D"M 303 555.76 L 299 547.76 L 303 549.76 L 307 547.76 Z" fill=
=3D"#ff8000" stroke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D"10"=
 pointer-events=3D"all"/><g transform=3D"translate(-0.5 -0.5)"><switch><for=
eignObject pointer-events=3D"none" width=3D"100%" height=3D"100%" requiredF=
eatures=3D"http://www.w3.org/TR/SVG11/feature#Extensibility" style=3D"overf=
low:visible;text-align:left"><div xmlns=3D"http://www.w3.org/1999/xhtml" st=
yle=3D"display:flex;align-items:unsafe center;justify-content:unsafe center=
;width:1px;height:1px;padding-top:518px;margin-left:282px"><div data-colors=
=3D"color: rgb(0, 0, 0); " style=3D"box-sizing:border-box;font-size:0px;tex=
t-align:center"><div style=3D"display:inline-block;font-size:18px;font-fami=
ly:Helvetica;color:rgb(0, 0, 0);line-height:1.2;pointer-events:all;white-sp=
ace:nowrap">not enough space</div></div></div></foreignObject><text x=3D"28=
2" y=3D"523" fill=3D"rgb(0, 0, 0)" font-family=3D"Helvetica" font-size=3D"1=
8px" text-anchor=3D"middle">not enough space</text></switch></g><path d=3D"=
M 403 463 L 591 463 Q 601 463 601 473 L 601 1447.76" fill=3D"none" stroke=
=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D"10" pointer-events=3D"=
stroke"/><path d=3D"M 601 1453.76 L 597 1445.76 L 601 1447.76 L 605 1445.76=
 Z" fill=3D"#ff8000" stroke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimi=
t=3D"10" pointer-events=3D"all"/><g transform=3D"translate(-0.5 -0.5)"><swi=
tch><foreignObject pointer-events=3D"none" width=3D"100%" height=3D"100%" r=
equiredFeatures=3D"http://www.w3.org/TR/SVG11/feature#Extensibility" style=
=3D"overflow:visible;text-align:left"><div xmlns=3D"http://www.w3.org/1999/=
xhtml" style=3D"display:flex;align-items:unsafe center;justify-content:unsa=
fe center;width:1px;height:1px;padding-top:452px;margin-left:541px"><div da=
ta-colors=3D"color: rgb(0, 0, 0); " style=3D"box-sizing:border-box;font-siz=
e:0px;text-align:center"><div style=3D"display:inline-block;font-size:18px;=
font-family:Helvetica;color:rgb(0, 0, 0);line-height:1.2;pointer-events:all=
;white-space:nowrap">success</div></div></div></foreignObject><text x=3D"54=
1" y=3D"457" fill=3D"rgb(0, 0, 0)" font-family=3D"Helvetica" font-size=3D"1=
8px" text-anchor=3D"middle">success</text></switch></g><rect x=3D"203" y=3D=
"388" width=3D"200" height=3D"100" rx=3D"10" ry=3D"10" fill=3D"#f0f7ff" str=
oke=3D"#0000cc" pointer-events=3D"all"/><g transform=3D"translate(-0.5 -0.5=
)"><switch><foreignObject pointer-events=3D"none" width=3D"100%" height=3D"=
100%" requiredFeatures=3D"http://www.w3.org/TR/SVG11/feature#Extensibility"=
 style=3D"overflow:visible;text-align:left"><div xmlns=3D"http://www.w3.org=
/1999/xhtml" style=3D"display:flex;align-items:unsafe center;justify-conten=
t:unsafe center;width:202px;height:100px;padding-top:388px;margin-left:202p=
x"><div data-colors=3D"color: #000000; " style=3D"box-sizing:border-box;fon=
t-size:0px;text-align:center;width:200px;height:100px;overflow:hidden"><div=
 style=3D"display:inline-block;font-size:18px;font-family:Helvetica;color:r=
gb(0, 0, 0);line-height:1.2;pointer-events:all;width:100%;height:100%;white=
-space:normal;overflow-wrap:normal"><p style=3D"margin:4px 0px 0px;text-ali=
gn:center;font-size:18px"><font style=3D"font-size:18px">XFS_DAS_SF_ADD</fo=
nt></p><hr style=3D"font-size:18px"/><p style=3D"font-size:18px"/><p style=
=3D"margin:0px 0px 0px 8px;text-align:left;font-size:18px"><font style=3D"f=
ont-size:18px">add attribute to shortform fork</font></p></div></div></div>=
</foreignObject></switch></g><path d=3D"M 303 658 L 303 727.76" fill=3D"non=
e" stroke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D"10" pointer-e=
vents=3D"stroke"/><path d=3D"M 303 733.76 L 299 725.76 L 303 727.76 L 307 7=
25.76 Z" fill=3D"#ff8000" stroke=3D"#ff8000" stroke-width=3D"2" stroke-mite=
rlimit=3D"10" pointer-events=3D"all"/><g transform=3D"translate(-0.5 -0.5)"=
><switch><foreignObject pointer-events=3D"none" width=3D"100%" height=3D"10=
0%" requiredFeatures=3D"http://www.w3.org/TR/SVG11/feature#Extensibility" s=
tyle=3D"overflow:visible;text-align:left"><div xmlns=3D"http://www.w3.org/1=
999/xhtml" style=3D"display:flex;align-items:unsafe center;justify-content:=
unsafe center;width:1px;height:1px;padding-top:692px;margin-left:282px"><di=
v data-colors=3D"color: rgb(0, 0, 0); " style=3D"box-sizing:border-box;font=
-size:0px;text-align:center"><div style=3D"display:inline-block;font-size:1=
8px;font-family:Helvetica;color:rgb(0, 0, 0);line-height:1.2;pointer-events=
:all;white-space:nowrap">not enough space</div></div></div></foreignObject>=
<text x=3D"282" y=3D"697" fill=3D"rgb(0, 0, 0)" font-family=3D"Helvetica" f=
ont-size=3D"18px" text-anchor=3D"middle">not enough space</text></switch></=
g><path d=3D"M 403 608 L 591 608 Q 601 608 601 618 L 601 1447.76" fill=3D"n=
one" stroke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D"10" pointer=
-events=3D"stroke"/><path d=3D"M 601 1453.76 L 597 1445.76 L 601 1447.76 L =
605 1445.76 Z" fill=3D"#ff8000" stroke=3D"#ff8000" stroke-width=3D"2" strok=
e-miterlimit=3D"10" pointer-events=3D"all"/><g transform=3D"translate(-0.5 =
-0.5)"><switch><foreignObject pointer-events=3D"none" width=3D"100%" height=
=3D"100%" requiredFeatures=3D"http://www.w3.org/TR/SVG11/feature#Extensibil=
ity" style=3D"overflow:visible;text-align:left"><div xmlns=3D"http://www.w3=
.org/1999/xhtml" style=3D"display:flex;align-items:unsafe center;justify-co=
ntent:unsafe center;width:1px;height:1px;padding-top:595px;margin-left:547p=
x"><div data-colors=3D"color: rgb(0, 0, 0); " style=3D"box-sizing:border-bo=
x;font-size:0px;text-align:center"><div style=3D"display:inline-block;font-=
size:18px;font-family:Helvetica;color:rgb(0, 0, 0);line-height:1.2;pointer-=
events:all;white-space:nowrap">success</div></div></div></foreignObject><te=
xt x=3D"547" y=3D"600" fill=3D"rgb(0, 0, 0)" font-family=3D"Helvetica" font=
-size=3D"18px" text-anchor=3D"middle">success</text></switch></g><rect x=3D=
"203" y=3D"558" width=3D"200" height=3D"100" rx=3D"10" ry=3D"10" fill=3D"#f=
0f7ff" stroke=3D"#0000cc" pointer-events=3D"all"/><g transform=3D"translate=
(-0.5 -0.5)"><switch><foreignObject pointer-events=3D"none" width=3D"100%" =
height=3D"100%" requiredFeatures=3D"http://www.w3.org/TR/SVG11/feature#Exte=
nsibility" style=3D"overflow:visible;text-align:left"><div xmlns=3D"http://=
www.w3.org/1999/xhtml" style=3D"display:flex;align-items:unsafe center;just=
ify-content:unsafe center;width:202px;height:100px;padding-top:558px;margin=
-left:202px"><div data-colors=3D"color: #000000; " style=3D"box-sizing:bord=
er-box;font-size:0px;text-align:center;width:200px;height:100px;overflow:hi=
dden"><div style=3D"display:inline-block;font-size:18px;font-family:Helveti=
ca;color:rgb(0, 0, 0);line-height:1.2;pointer-events:all;width:100%;height:=
100%;white-space:normal;overflow-wrap:normal"><p style=3D"margin:4px 0px 0p=
x;text-align:center;font-size:18px">XFS_DAS_LEAF_ADD</p><hr style=3D"font-s=
ize:18px"/><p style=3D"font-size:18px"/><p style=3D"margin:0px 0px 0px 8px;=
text-align:left;font-size:18px">add attribute to an inode in leaf form</p><=
/div></div></div></foreignObject></switch></g><path d=3D"M 403 786 L 591 78=
6 Q 601 786 601 796 L 601 1447.76" fill=3D"none" stroke=3D"#ff8000" stroke-=
width=3D"2" stroke-miterlimit=3D"10" pointer-events=3D"stroke"/><path d=3D"=
M 601 1453.76 L 597 1445.76 L 601 1447.76 L 605 1445.76 Z" fill=3D"#ff8000"=
 stroke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D"10" pointer-eve=
nts=3D"all"/><g transform=3D"translate(-0.5 -0.5)"><switch><foreignObject p=
ointer-events=3D"none" width=3D"100%" height=3D"100%" requiredFeatures=3D"h=
ttp://www.w3.org/TR/SVG11/feature#Extensibility" style=3D"overflow:visible;=
text-align:left"><div xmlns=3D"http://www.w3.org/1999/xhtml" style=3D"displ=
ay:flex;align-items:unsafe center;justify-content:unsafe center;width:1px;h=
eight:1px;padding-top:772px;margin-left:545px"><div data-colors=3D"color: r=
gb(0, 0, 0); " style=3D"box-sizing:border-box;font-size:0px;text-align:cent=
er"><div style=3D"display:inline-block;font-size:18px;font-family:Helvetica=
;color:rgb(0, 0, 0);line-height:1.2;pointer-events:all;white-space:nowrap">=
success</div></div></div></foreignObject><text x=3D"545" y=3D"777" fill=3D"=
rgb(0, 0, 0)" font-family=3D"Helvetica" font-size=3D"18px" text-anchor=3D"m=
iddle">success</text></switch></g><rect x=3D"203" y=3D"736" width=3D"200" h=
eight=3D"100" rx=3D"10" ry=3D"10" fill=3D"#f0f7ff" stroke=3D"#0000cc" point=
er-events=3D"all"/><g transform=3D"translate(-0.5 -0.5)"><switch><foreignOb=
ject pointer-events=3D"none" width=3D"100%" height=3D"100%" requiredFeature=
s=3D"http://www.w3.org/TR/SVG11/feature#Extensibility" style=3D"overflow:vi=
sible;text-align:left"><div xmlns=3D"http://www.w3.org/1999/xhtml" style=3D=
"display:flex;align-items:unsafe center;justify-content:unsafe center;width=
:202px;height:100px;padding-top:736px;margin-left:202px"><div data-colors=
=3D"color: #000000; " style=3D"box-sizing:border-box;font-size:0px;text-ali=
gn:center;width:200px;height:100px;overflow:hidden"><div style=3D"display:i=
nline-block;font-size:18px;font-family:Helvetica;color:rgb(0, 0, 0);line-he=
ight:1.2;pointer-events:all;width:100%;height:100%;white-space:normal;overf=
low-wrap:normal"><p style=3D"margin:4px 0px 0px;text-align:center;font-size=
:18px">XFS_DAS_NODE_ADD</p><hr style=3D"font-size:18px"/><p style=3D"font-s=
ize:18px"/><p style=3D"margin:0px 0px 0px 8px;text-align:left;font-size:18p=
x">add attribute to a node format attribute tree</p></div></div></div></for=
eignObject></switch></g><path d=3D"M 707.5 1728 L 707.5 1772.63" fill=3D"no=
ne" stroke=3D"rgb(0, 0, 0)" stroke-miterlimit=3D"10" pointer-events=3D"stro=
ke"/><path d=3D"M 707.5 1777.88 L 704 1770.88 L 707.5 1772.63 L 711 1770.88=
 Z" fill=3D"rgb(0, 0, 0)" stroke=3D"rgb(0, 0, 0)" stroke-miterlimit=3D"10" =
pointer-events=3D"all"/><path d=3D"M 707.5 1728 L 707.5 1770.76" fill=3D"no=
ne" stroke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D"10" pointer-=
events=3D"stroke"/><path d=3D"M 707.5 1776.76 L 703.5 1768.76 L 707.5 1770.=
76 L 711.5 1768.76 Z" fill=3D"#ff8000" stroke=3D"#ff8000" stroke-width=3D"2=
" stroke-miterlimit=3D"10" pointer-events=3D"all"/><rect x=3D"557" y=3D"164=
7" width=3D"301" height=3D"81" rx=3D"10" ry=3D"10" fill=3D"#f0f7ff" stroke=
=3D"#0000cc" pointer-events=3D"all"/><g transform=3D"translate(-0.5 -0.5)">=
<switch><foreignObject pointer-events=3D"none" width=3D"100%" height=3D"100=
%" requiredFeatures=3D"http://www.w3.org/TR/SVG11/feature#Extensibility" st=
yle=3D"overflow:visible;text-align:left"><div xmlns=3D"http://www.w3.org/19=
99/xhtml" style=3D"display:flex;align-items:unsafe center;justify-content:u=
nsafe center;width:303px;height:81px;padding-top:1647px;margin-left:556px">=
<div data-colors=3D"color: #000000; " style=3D"box-sizing:border-box;font-s=
ize:0px;text-align:center;width:301px;height:81px;overflow:hidden"><div sty=
le=3D"display:inline-block;font-size:18px;font-family:Helvetica;color:rgb(0=
, 0, 0);line-height:1.2;pointer-events:all;width:100%;height:100%;white-spa=
ce:normal;overflow-wrap:normal"><p style=3D"margin:4px 0px 0px;text-align:c=
enter;font-size:18px">XFS_DAS_DONE</p><hr style=3D"font-size:18px"/><p styl=
e=3D"font-size:18px"/><p style=3D"margin:0px 0px 0px 8px;text-align:left;fo=
nt-size:18px">finished operation</p></div></div></div></foreignObject></swi=
tch></g><path d=3D"M 601 1496 L 600.95 1638.6" fill=3D"none" stroke=3D"#ff8=
000" stroke-width=3D"2" stroke-miterlimit=3D"10" pointer-events=3D"stroke"/=
><path d=3D"M 600.95 1644.6 L 596.95 1636.6 L 600.95 1638.6 L 604.95 1636.6=
 Z" fill=3D"#ff8000" stroke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimi=
t=3D"10" pointer-events=3D"all"/><g transform=3D"translate(-0.5 -0.5)"><swi=
tch><foreignObject pointer-events=3D"none" width=3D"100%" height=3D"100%" r=
equiredFeatures=3D"http://www.w3.org/TR/SVG11/feature#Extensibility" style=
=3D"overflow:visible;text-align:left"><div xmlns=3D"http://www.w3.org/1999/=
xhtml" style=3D"display:flex;align-items:unsafe center;justify-content:unsa=
fe center;width:1px;height:1px;padding-top:1562px;margin-left:600px"><div d=
ata-colors=3D"color: rgb(0, 0, 0); " style=3D"box-sizing:border-box;font-si=
ze:0px;text-align:center"><div style=3D"display:inline-block;font-size:18px=
;font-family:Helvetica;color:rgb(0, 0, 0);line-height:1.2;pointer-events:al=
l;white-space:nowrap">operation complete</div></div></div></foreignObject><=
text x=3D"600" y=3D"1567" fill=3D"rgb(0, 0, 0)" font-family=3D"Helvetica" f=
ont-size=3D"18px" text-anchor=3D"middle">operation complete</text></switch>=
</g><path d=3D"M 601 1456 L 621 1476 L 601 1496 L 581 1476 Z" fill=3D"#ff80=
00" stroke=3D"#0000cc" stroke-miterlimit=3D"10" pointer-events=3D"all"/><pa=
th d=3D"M 989 463 L 816 463 Q 806 463 806 473 L 806 1077.26" fill=3D"none" =
stroke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D"10" pointer-even=
ts=3D"stroke"/><path d=3D"M 806 1083.26 L 802 1075.26 L 806 1077.26 L 810 1=
075.26 Z" fill=3D"#ff8000" stroke=3D"#ff8000" stroke-width=3D"2" stroke-mit=
erlimit=3D"10" pointer-events=3D"all"/><g transform=3D"translate(-0.5 -0.5)=
"><switch><foreignObject pointer-events=3D"none" width=3D"100%" height=3D"1=
00%" requiredFeatures=3D"http://www.w3.org/TR/SVG11/feature#Extensibility" =
style=3D"overflow:visible;text-align:left"><div xmlns=3D"http://www.w3.org/=
1999/xhtml" style=3D"display:flex;align-items:unsafe center;justify-content=
:unsafe center;width:1px;height:1px;padding-top:451px;margin-left:889px"><d=
iv data-colors=3D"color: rgb(0, 0, 0); " style=3D"box-sizing:border-box;fon=
t-size:0px;text-align:center"><div style=3D"display:inline-block;font-size:=
18px;font-family:Helvetica;color:rgb(0, 0, 0);line-height:1.2;pointer-event=
s:all;white-space:nowrap">success</div></div></div></foreignObject><text x=
=3D"889" y=3D"456" fill=3D"rgb(0, 0, 0)" font-family=3D"Helvetica" font-siz=
e=3D"18px" text-anchor=3D"middle">success</text></switch></g><rect x=3D"989=
" y=3D"388" width=3D"240" height=3D"100" rx=3D"10" ry=3D"10" fill=3D"#f0f7f=
f" stroke=3D"#0000cc" pointer-events=3D"all"/><g transform=3D"translate(-0.=
5 -0.5)"><switch><foreignObject pointer-events=3D"none" width=3D"100%" heig=
ht=3D"100%" requiredFeatures=3D"http://www.w3.org/TR/SVG11/feature#Extensib=
ility" style=3D"overflow:visible;text-align:left"><div xmlns=3D"http://www.=
w3.org/1999/xhtml" style=3D"display:flex;align-items:unsafe center;justify-=
content:unsafe center;width:242px;height:100px;padding-top:388px;margin-lef=
t:988px"><div data-colors=3D"color: #000000; " style=3D"box-sizing:border-b=
ox;font-size:0px;text-align:center;width:240px;height:100px;overflow:hidden=
"><div style=3D"display:inline-block;font-size:18px;font-family:Helvetica;c=
olor:rgb(0, 0, 0);line-height:1.2;pointer-events:all;width:100%;height:100%=
;white-space:normal;overflow-wrap:normal"><p style=3D"margin:4px 0px 0px;te=
xt-align:center;font-size:18px">XFS_DAS_SF_REMOVE</p><hr style=3D"font-size=
:18px"/><p style=3D"font-size:18px"/><p style=3D"margin:0px 0px 0px 8px;tex=
t-align:left;font-size:18px">remove attribute from shortform fork</p></div>=
</div></div></foreignObject></switch></g><path d=3D"M 989 578 L 816 578 Q 8=
06 578 806 588 L 806 1077.26" fill=3D"none" stroke=3D"#ff8000" stroke-width=
=3D"2" stroke-miterlimit=3D"10" pointer-events=3D"stroke"/><path d=3D"M 806=
 1083.26 L 802 1075.26 L 806 1077.26 L 810 1075.26 Z" fill=3D"#ff8000" stro=
ke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D"10" pointer-events=
=3D"all"/><g transform=3D"translate(-0.5 -0.5)"><switch><foreignObject poin=
ter-events=3D"none" width=3D"100%" height=3D"100%" requiredFeatures=3D"http=
://www.w3.org/TR/SVG11/feature#Extensibility" style=3D"overflow:visible;tex=
t-align:left"><div xmlns=3D"http://www.w3.org/1999/xhtml" style=3D"display:=
flex;align-items:unsafe center;justify-content:unsafe center;width:1px;heig=
ht:1px;padding-top:565px;margin-left:893px"><div data-colors=3D"color: rgb(=
0, 0, 0); " style=3D"box-sizing:border-box;font-size:0px;text-align:center"=
><div style=3D"display:inline-block;font-size:18px;font-family:Helvetica;co=
lor:rgb(0, 0, 0);line-height:1.2;pointer-events:all;white-space:nowrap">suc=
cess</div></div></div></foreignObject><text x=3D"893" y=3D"570" fill=3D"rgb=
(0, 0, 0)" font-family=3D"Helvetica" font-size=3D"18px" text-anchor=3D"midd=
le">success</text></switch></g><rect x=3D"989" y=3D"528" width=3D"240" heig=
ht=3D"100" rx=3D"10" ry=3D"10" fill=3D"#f0f7ff" stroke=3D"#0000cc" pointer-=
events=3D"all"/><g transform=3D"translate(-0.5 -0.5)"><switch><foreignObjec=
t pointer-events=3D"none" width=3D"100%" height=3D"100%" requiredFeatures=
=3D"http://www.w3.org/TR/SVG11/feature#Extensibility" style=3D"overflow:vis=
ible;text-align:left"><div xmlns=3D"http://www.w3.org/1999/xhtml" style=3D"=
display:flex;align-items:unsafe center;justify-content:unsafe center;width:=
242px;height:100px;padding-top:528px;margin-left:988px"><div data-colors=3D=
"color: #000000; " style=3D"box-sizing:border-box;font-size:0px;text-align:=
center;width:240px;height:100px;overflow:hidden"><div style=3D"display:inli=
ne-block;font-size:18px;font-family:Helvetica;color:rgb(0, 0, 0);line-heigh=
t:1.2;pointer-events:all;width:100%;height:100%;white-space:normal;overflow=
-wrap:normal"><p style=3D"margin:4px 0px 0px;text-align:center;font-size:18=
px">XFS_DAS_LEAF_REMOVE</p><hr style=3D"font-size:18px"/><p style=3D"font-s=
ize:18px"/><p style=3D"margin:0px 0px 0px 8px;text-align:left;font-size:18p=
x">remove attribute from an inode in leaf form</p></div></div></div></forei=
gnObject></switch></g><path d=3D"M 989 718 L 816 718 Q 806 718 806 728 L 80=
6 1077.26" fill=3D"none" stroke=3D"#ff8000" stroke-width=3D"2" stroke-miter=
limit=3D"10" pointer-events=3D"stroke"/><path d=3D"M 806 1083.26 L 802 1075=
.26 L 806 1077.26 L 810 1075.26 Z" fill=3D"#ff8000" stroke=3D"#ff8000" stro=
ke-width=3D"2" stroke-miterlimit=3D"10" pointer-events=3D"all"/><g transfor=
m=3D"translate(-0.5 -0.5)"><switch><foreignObject pointer-events=3D"none" w=
idth=3D"100%" height=3D"100%" requiredFeatures=3D"http://www.w3.org/TR/SVG1=
1/feature#Extensibility" style=3D"overflow:visible;text-align:left"><div xm=
lns=3D"http://www.w3.org/1999/xhtml" style=3D"display:flex;align-items:unsa=
fe center;justify-content:unsafe center;width:1px;height:1px;padding-top:70=
3px;margin-left:897px"><div data-colors=3D"color: rgb(0, 0, 0); " style=3D"=
box-sizing:border-box;font-size:0px;text-align:center"><div style=3D"displa=
y:inline-block;font-size:18px;font-family:Helvetica;color:rgb(0, 0, 0);line=
-height:1.2;pointer-events:all;white-space:nowrap">success</div></div></div=
></foreignObject><text x=3D"897" y=3D"708" fill=3D"rgb(0, 0, 0)" font-famil=
y=3D"Helvetica" font-size=3D"18px" text-anchor=3D"middle">success</text></s=
witch></g><rect x=3D"989" y=3D"668" width=3D"240" height=3D"100" rx=3D"10" =
ry=3D"10" fill=3D"#f0f7ff" stroke=3D"#0000cc" pointer-events=3D"all"/><g tr=
ansform=3D"translate(-0.5 -0.5)"><switch><foreignObject pointer-events=3D"n=
one" width=3D"100%" height=3D"100%" requiredFeatures=3D"http://www.w3.org/T=
R/SVG11/feature#Extensibility" style=3D"overflow:visible;text-align:left"><=
div xmlns=3D"http://www.w3.org/1999/xhtml" style=3D"display:flex;align-item=
s:unsafe center;justify-content:unsafe center;width:242px;height:100px;padd=
ing-top:668px;margin-left:988px"><div data-colors=3D"color: #000000; " styl=
e=3D"box-sizing:border-box;font-size:0px;text-align:center;width:240px;heig=
ht:100px;overflow:hidden"><div style=3D"display:inline-block;font-size:18px=
;font-family:Helvetica;color:rgb(0, 0, 0);line-height:1.2;pointer-events:al=
l;width:100%;height:100%;white-space:normal;overflow-wrap:normal"><p style=
=3D"margin:4px 0px 0px;text-align:center;font-size:18px">XFS_DAS_NODE_REMOV=
E</p><hr style=3D"font-size:18px"/><p style=3D"font-size:18px"/><p style=3D=
"margin:0px 0px 0px 8px;text-align:left;font-size:18px">setup for removal (=
attribute exists and blocks are valid)</p></div></div></div></foreignObject=
></switch></g><path d=3D"M 746 269 L 1097.4 269 Q 1107.4 269 1107.39 279 L =
1107.29 357.92" fill=3D"none" stroke=3D"#ff8000" stroke-width=3D"2" stroke-=
miterlimit=3D"10" pointer-events=3D"stroke"/><path d=3D"M 1107.28 363.92 L =
1103.29 355.91 L 1107.29 357.92 L 1111.29 355.92 Z" fill=3D"#ff8000" stroke=
=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D"10" pointer-events=3D"=
all"/><g transform=3D"translate(-0.5 -0.5)"><switch><foreignObject pointer-=
events=3D"none" width=3D"100%" height=3D"100%" requiredFeatures=3D"http://w=
ww.w3.org/TR/SVG11/feature#Extensibility" style=3D"overflow:visible;text-al=
ign:left"><div xmlns=3D"http://www.w3.org/1999/xhtml" style=3D"display:flex=
;align-items:unsafe center;justify-content:unsafe center;width:1px;height:1=
px;padding-top:253px;margin-left:888px"><div data-colors=3D"color: rgb(0, 0=
, 0); " style=3D"box-sizing:border-box;font-size:0px;text-align:center"><di=
v style=3D"display:inline-block;font-size:18px;font-family:Helvetica;color:=
rgb(0, 0, 0);line-height:1.2;pointer-events:all;white-space:nowrap"><font s=
tyle=3D"font-size:18px">larp enabled</font></div></div></div></foreignObjec=
t><text x=3D"888" y=3D"258" fill=3D"rgb(0, 0, 0)" font-family=3D"Helvetica"=
 font-size=3D"18px" text-anchor=3D"middle">larp enabled</text></switch></g>=
<path d=3D"M 1382 578 L 1372 578 Q 1362 578 1367 578 L 1369.5 578 Q 1372 57=
8 1366.12 578 L 1360.24 578" fill=3D"none" stroke=3D"#ff8000" stroke-width=
=3D"2" stroke-miterlimit=3D"10" pointer-events=3D"stroke"/><path d=3D"M 135=
4.24 578 L 1362.24 574 L 1360.24 578 L 1362.24 582 Z" fill=3D"#ff8000" stro=
ke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D"10" pointer-events=
=3D"all"/><ellipse cx=3D"1392" cy=3D"578" rx=3D"10" ry=3D"10" fill=3D"#ff80=
00" stroke=3D"#0000cc" pointer-events=3D"all"/><path d=3D"M 1332 558 L 1332=
 448 Q 1332 438 1322 438 L 1237.24 438" fill=3D"none" stroke=3D"#ff8000" st=
roke-width=3D"2" stroke-miterlimit=3D"10" pointer-events=3D"stroke"/><path =
d=3D"M 1231.24 438 L 1239.24 434 L 1237.24 438 L 1239.24 442 Z" fill=3D"#ff=
8000" stroke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D"10" pointe=
r-events=3D"all"/><g transform=3D"translate(-0.5 -0.5)"><switch><foreignObj=
ect pointer-events=3D"none" width=3D"100%" height=3D"100%" requiredFeatures=
=3D"http://www.w3.org/TR/SVG11/feature#Extensibility" style=3D"overflow:vis=
ible;text-align:left"><div xmlns=3D"http://www.w3.org/1999/xhtml" style=3D"=
display:flex;align-items:unsafe center;justify-content:unsafe center;width:=
1px;height:1px;padding-top:424px;margin-left:1282px"><div data-colors=3D"co=
lor: rgb(0, 0, 0); " style=3D"box-sizing:border-box;font-size:0px;text-alig=
n:center"><div style=3D"display:inline-block;font-size:18px;font-family:Hel=
vetica;color:rgb(0, 0, 0);line-height:1.2;pointer-events:all;white-space:no=
wrap">shortform</div></div></div></foreignObject><text x=3D"1282" y=3D"429"=
 fill=3D"rgb(0, 0, 0)" font-family=3D"Helvetica" font-size=3D"18px" text-an=
chor=3D"middle">shortform</text></switch></g><path d=3D"M 1312 578 L 1237.2=
4 578" fill=3D"none" stroke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimi=
t=3D"10" pointer-events=3D"stroke"/><path d=3D"M 1231.24 578 L 1239.24 574 =
L 1237.24 578 L 1239.24 582 Z" fill=3D"#ff8000" stroke=3D"#ff8000" stroke-w=
idth=3D"2" stroke-miterlimit=3D"10" pointer-events=3D"all"/><g transform=3D=
"translate(-0.5 -0.5)"><switch><foreignObject pointer-events=3D"none" width=
=3D"100%" height=3D"100%" requiredFeatures=3D"http://www.w3.org/TR/SVG11/fe=
ature#Extensibility" style=3D"overflow:visible;text-align:left"><div xmlns=
=3D"http://www.w3.org/1999/xhtml" style=3D"display:flex;align-items:unsafe =
center;justify-content:unsafe center;width:1px;height:1px;padding-top:566px=
;margin-left:1270px"><div data-colors=3D"color: rgb(0, 0, 0); " style=3D"bo=
x-sizing:border-box;font-size:0px;text-align:center"><div style=3D"display:=
inline-block;font-size:18px;font-family:Helvetica;color:rgb(0, 0, 0);line-h=
eight:1.2;pointer-events:all;white-space:nowrap">leaf</div></div></div></fo=
reignObject><text x=3D"1270" y=3D"571" fill=3D"rgb(0, 0, 0)" font-family=3D=
"Helvetica" font-size=3D"18px" text-anchor=3D"middle">leaf</text></switch><=
/g><path d=3D"M 1332 598 L 1332 708 Q 1332 718 1322 718 L 1237.24 718" fill=
=3D"none" stroke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D"10" po=
inter-events=3D"stroke"/><path d=3D"M 1231.24 718 L 1239.24 714 L 1237.24 7=
18 L 1239.24 722 Z" fill=3D"#ff8000" stroke=3D"#ff8000" stroke-width=3D"2" =
stroke-miterlimit=3D"10" pointer-events=3D"all"/><g transform=3D"translate(=
-0.5 -0.5)"><switch><foreignObject pointer-events=3D"none" width=3D"100%" h=
eight=3D"100%" requiredFeatures=3D"http://www.w3.org/TR/SVG11/feature#Exten=
sibility" style=3D"overflow:visible;text-align:left"><div xmlns=3D"http://w=
ww.w3.org/1999/xhtml" style=3D"display:flex;align-items:unsafe center;justi=
fy-content:unsafe center;width:1px;height:1px;padding-top:703px;margin-left=
:1268px"><div data-colors=3D"color: rgb(0, 0, 0); " style=3D"box-sizing:bor=
der-box;font-size:0px;text-align:center"><div style=3D"display:inline-block=
;font-size:18px;font-family:Helvetica;color:rgb(0, 0, 0);line-height:1.2;po=
inter-events:all;white-space:nowrap">node</div></div></div></foreignObject>=
<text x=3D"1268" y=3D"708" fill=3D"rgb(0, 0, 0)" font-family=3D"Helvetica" =
font-size=3D"18px" text-anchor=3D"middle">node</text></switch></g><path d=
=3D"M 1332 558 L 1352 578 L 1332 598 L 1312 578 Z" fill=3D"#ff8000" stroke=
=3D"#0000cc" stroke-miterlimit=3D"10" pointer-events=3D"all"/><rect x=3D"94=
9" y=3D"880" width=3D"528" height=3D"316" rx=3D"10" ry=3D"10" fill=3D"#ffff=
ff" stroke=3D"#0000cc" pointer-events=3D"all"/><rect x=3D"964" y=3D"860" wi=
dth=3D"110" height=3D"20" fill=3D"#ffffff" stroke=3D"#0000cc" pointer-event=
s=3D"all"/><g fill=3D"#000000" font-family=3D"Helvetica" font-weight=3D"bol=
d" font-size=3D"13px"><text x=3D"968.5" y=3D"875.5">REMOVE XATTR</text></g>=
<rect x=3D"989" y=3D"911" width=3D"290" height=3D"100" rx=3D"10" ry=3D"10" =
fill=3D"#f0f7ff" stroke=3D"#0000cc" pointer-events=3D"all"/><g transform=3D=
"translate(-0.5 -0.5)"><switch><foreignObject pointer-events=3D"none" width=
=3D"100%" height=3D"100%" requiredFeatures=3D"http://www.w3.org/TR/SVG11/fe=
ature#Extensibility" style=3D"overflow:visible;text-align:left"><div xmlns=
=3D"http://www.w3.org/1999/xhtml" style=3D"display:flex;align-items:unsafe =
center;justify-content:unsafe center;width:292px;height:100px;padding-top:9=
11px;margin-left:988px"><div data-colors=3D"color: #000000; " style=3D"box-=
sizing:border-box;font-size:0px;text-align:center;width:290px;height:100px;=
overflow:hidden"><div style=3D"display:inline-block;font-size:18px;font-fam=
ily:Helvetica;color:rgb(0, 0, 0);line-height:1.2;pointer-events:all;width:1=
00%;height:100%;white-space:normal;overflow-wrap:normal"><p style=3D"margin=
:4px 0px 0px;text-align:center;font-size:18px">XFS_DAS_LEAF_REMOVE_RMT</p><=
p style=3D"margin:4px 0px 0px;text-align:center;font-size:18px">XFS_DAS_NOD=
E_REMOVE_RMT</p><hr style=3D"font-size:18px"/><p style=3D"font-size:18px"/>=
<p style=3D"margin:0px 0px 0px 8px;text-align:left;font-size:18px">remove r=
emote attribute blocks</p></div></div></div></foreignObject></switch></g><p=
ath d=3D"M 989 1105.5 L 834.24 1105.5" fill=3D"none" stroke=3D"#ff8000" str=
oke-width=3D"2" stroke-miterlimit=3D"10" pointer-events=3D"stroke"/><path d=
=3D"M 828.24 1105.5 L 836.24 1101.5 L 834.24 1105.5 L 836.24 1109.5 Z" fill=
=3D"#ff8000" stroke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D"10"=
 pointer-events=3D"all"/><g transform=3D"translate(-0.5 -0.5)"><switch><for=
eignObject pointer-events=3D"none" width=3D"100%" height=3D"100%" requiredF=
eatures=3D"http://www.w3.org/TR/SVG11/feature#Extensibility" style=3D"overf=
low:visible;text-align:left"><div xmlns=3D"http://www.w3.org/1999/xhtml" st=
yle=3D"display:flex;align-items:unsafe center;justify-content:unsafe center=
;width:1px;height:1px;padding-top:1091px;margin-left:895px"><div data-color=
s=3D"color: rgb(0, 0, 0); " style=3D"box-sizing:border-box;font-size:0px;te=
xt-align:center"><div style=3D"display:inline-block;font-size:18px;font-fam=
ily:Helvetica;color:rgb(0, 0, 0);line-height:1.2;pointer-events:all;white-s=
pace:nowrap">success</div></div></div></foreignObject><text x=3D"895" y=3D"=
1096" fill=3D"rgb(0, 0, 0)" font-family=3D"Helvetica" font-size=3D"18px" te=
xt-anchor=3D"middle">success</text></switch></g><rect x=3D"989" y=3D"1042" =
width=3D"290" height=3D"127" rx=3D"10" ry=3D"10" fill=3D"#f0f7ff" stroke=3D=
"#0000cc" pointer-events=3D"all"/><g transform=3D"translate(-0.5 -0.5)"><sw=
itch><foreignObject pointer-events=3D"none" width=3D"100%" height=3D"100%" =
requiredFeatures=3D"http://www.w3.org/TR/SVG11/feature#Extensibility" style=
=3D"overflow:visible;text-align:left"><div xmlns=3D"http://www.w3.org/1999/=
xhtml" style=3D"display:flex;align-items:unsafe center;justify-content:unsa=
fe center;width:292px;height:127px;padding-top:1042px;margin-left:988px"><d=
iv data-colors=3D"color: #000000; " style=3D"box-sizing:border-box;font-siz=
e:0px;text-align:center;width:290px;height:127px;overflow:hidden"><div styl=
e=3D"display:inline-block;font-size:18px;font-family:Helvetica;color:rgb(0,=
 0, 0);line-height:1.2;pointer-events:all;width:100%;height:100%;white-spac=
e:normal;overflow-wrap:normal"><p style=3D"margin:4px 0px 0px;text-align:ce=
nter;font-size:18px">XFS_DAS_LEAF_REMOVE_ATTR</p><p style=3D"margin:4px 0px=
 0px;text-align:center;font-size:18px">XFS_DAS_NODE_REMOVE_ATTR</p><hr styl=
e=3D"font-size:18px"/><p style=3D"font-size:18px"/><p style=3D"margin:0px 0=
px 0px 8px;text-align:left;font-size:18px">remove attribute name from leaf/=
node block</p></div></div></div></foreignObject></switch></g><path d=3D"M 1=
134 1011 L 1134 1031 L 1134 1022 L 1134 1033.76" fill=3D"none" stroke=3D"#f=
f8000" stroke-width=3D"2" stroke-miterlimit=3D"10" pointer-events=3D"stroke=
"/><path d=3D"M 1134 1039.76 L 1130 1031.76 L 1134 1033.76 L 1138 1031.76 Z=
" fill=3D"#ff8000" stroke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=
=3D"10" pointer-events=3D"all"/><path d=3D"M 1369 1009 L 1369 971 Q 1369 96=
1 1359 961 L 1287.24 961" fill=3D"none" stroke=3D"#ff8000" stroke-width=3D"=
2" stroke-miterlimit=3D"10" pointer-events=3D"stroke"/><path d=3D"M 1281.24=
 961 L 1289.24 957 L 1287.24 961 L 1289.24 965 Z" fill=3D"#ff8000" stroke=
=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D"10" pointer-events=3D"=
all"/><g transform=3D"translate(-0.5 -0.5)"><switch><foreignObject pointer-=
events=3D"none" width=3D"100%" height=3D"100%" requiredFeatures=3D"http://w=
ww.w3.org/TR/SVG11/feature#Extensibility" style=3D"overflow:visible;text-al=
ign:left"><div xmlns=3D"http://www.w3.org/1999/xhtml" style=3D"display:flex=
;align-items:unsafe center;justify-content:unsafe center;width:1px;height:1=
px;padding-top:949px;margin-left:1325px"><div data-colors=3D"color: rgb(0, =
0, 0); " style=3D"box-sizing:border-box;font-size:0px;text-align:center"><d=
iv style=3D"display:inline-block;font-size:18px;font-family:Helvetica;color=
:rgb(0, 0, 0);line-height:1.2;pointer-events:all;white-space:nowrap">remote=
</div></div></div></foreignObject><text x=3D"1325" y=3D"954" fill=3D"rgb(0,=
 0, 0)" font-family=3D"Helvetica" font-size=3D"18px" text-anchor=3D"middle"=
>remote</text></switch></g><path d=3D"M 1369 1049 L 1369 1095.6 Q 1369 1105=
.6 1359 1105.59 L 1287.24 1105.51" fill=3D"none" stroke=3D"#ff8000" stroke-=
width=3D"2" stroke-miterlimit=3D"10" pointer-events=3D"stroke"/><path d=3D"=
M 1281.24 1105.5 L 1289.24 1101.51 L 1287.24 1105.51 L 1289.23 1109.51 Z" f=
ill=3D"#ff8000" stroke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D"=
10" pointer-events=3D"all"/><g transform=3D"translate(-0.5 -0.5)"><switch><=
foreignObject pointer-events=3D"none" width=3D"100%" height=3D"100%" requir=
edFeatures=3D"http://www.w3.org/TR/SVG11/feature#Extensibility" style=3D"ov=
erflow:visible;text-align:left"><div xmlns=3D"http://www.w3.org/1999/xhtml"=
 style=3D"display:flex;align-items:unsafe center;justify-content:unsafe cen=
ter;width:1px;height:1px;padding-top:1093px;margin-left:1320px"><div data-c=
olors=3D"color: rgb(0, 0, 0); " style=3D"box-sizing:border-box;font-size:0p=
x;text-align:center"><div style=3D"display:inline-block;font-size:18px;font=
-family:Helvetica;color:rgb(0, 0, 0);line-height:1.2;pointer-events:all;whi=
te-space:nowrap">local</div></div></div></foreignObject><text x=3D"1320" y=
=3D"1098" fill=3D"rgb(0, 0, 0)" font-family=3D"Helvetica" font-size=3D"18px=
" text-anchor=3D"middle">local</text></switch></g><path d=3D"M 1369 1009 L =
1389 1029 L 1369 1049 L 1349 1029 Z" fill=3D"#ff8000" stroke=3D"#0000cc" st=
roke-miterlimit=3D"10" pointer-events=3D"all"/><path d=3D"M 1439 1028 L 139=
7.23 1028.67" fill=3D"none" stroke=3D"#ff8000" stroke-width=3D"2" stroke-mi=
terlimit=3D"10" pointer-events=3D"stroke"/><path d=3D"M 1391.23 1028.91 L 1=
399.07 1024.59 L 1397.23 1028.67 L 1399.39 1032.59 Z" fill=3D"#ff8000" stro=
ke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D"10" pointer-events=
=3D"all"/><ellipse cx=3D"1449" cy=3D"1028" rx=3D"10" ry=3D"10" fill=3D"#ff8=
000" stroke=3D"#0000cc" pointer-events=3D"all"/><path d=3D"M 786 1105.5 L 7=
55 1105.58 Q 745 1105.6 745 1095.6 L 745 411.8 Q 745 401.8 735 401.8 L 445.=
24 401.81" fill=3D"none" stroke=3D"#ff8000" stroke-width=3D"2" stroke-miter=
limit=3D"10" pointer-events=3D"stroke"/><path d=3D"M 439.24 401.81 L 447.24=
 397.81 L 445.24 401.81 L 447.24 405.81 Z" fill=3D"#ff8000" stroke=3D"#ff80=
00" stroke-width=3D"2" stroke-miterlimit=3D"10" pointer-events=3D"all"/><g =
transform=3D"translate(-0.5 -0.5)"><switch><foreignObject pointer-events=3D=
"none" width=3D"100%" height=3D"100%" requiredFeatures=3D"http://www.w3.org=
/TR/SVG11/feature#Extensibility" style=3D"overflow:visible;text-align:left"=
><div xmlns=3D"http://www.w3.org/1999/xhtml" style=3D"display:flex;align-it=
ems:unsafe center;justify-content:unsafe center;width:1px;height:1px;paddin=
g-top:388px;margin-left:552px"><div data-colors=3D"color: rgb(0, 0, 0); " s=
tyle=3D"box-sizing:border-box;font-size:0px;text-align:center"><div style=
=3D"display:inline-block;font-size:18px;font-family:Helvetica;color:rgb(0, =
0, 0);line-height:1.2;pointer-events:all;white-space:nowrap">larp enabled r=
eplace</div></div></div></foreignObject><text x=3D"552" y=3D"393" fill=3D"r=
gb(0, 0, 0)" font-family=3D"Helvetica" font-size=3D"18px" text-anchor=3D"mi=
ddle">larp enabled replace</text></switch></g><path d=3D"M 806 1125.5 L 805=
.35 1638.68" fill=3D"none" stroke=3D"#ff8000" stroke-width=3D"2" stroke-mit=
erlimit=3D"10" pointer-events=3D"stroke"/><path d=3D"M 805.33 1644.68 L 801=
.35 1636.67 L 805.35 1638.68 L 809.35 1636.69 Z" fill=3D"#ff8000" stroke=3D=
"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D"10" pointer-events=3D"all=
"/><g transform=3D"translate(-0.5 -0.5)"><switch><foreignObject pointer-eve=
nts=3D"none" width=3D"100%" height=3D"100%" requiredFeatures=3D"http://www.=
w3.org/TR/SVG11/feature#Extensibility" style=3D"overflow:visible;text-align=
:left"><div xmlns=3D"http://www.w3.org/1999/xhtml" style=3D"display:flex;al=
ign-items:unsafe center;justify-content:unsafe center;width:1px;height:1px;=
padding-top:1196px;margin-left:805px"><div data-colors=3D"color: rgb(0, 0, =
0); " style=3D"box-sizing:border-box;font-size:0px;text-align:center"><div =
style=3D"display:inline-block;font-size:18px;font-family:Helvetica;color:rg=
b(0, 0, 0);line-height:1.2;pointer-events:all;white-space:nowrap">operation=
 complete</div></div></div></foreignObject><text x=3D"805" y=3D"1201" fill=
=3D"rgb(0, 0, 0)" font-family=3D"Helvetica" font-size=3D"18px" text-anchor=
=3D"middle">operation complete</text></switch></g><path d=3D"M 806 1085.5 L=
 826 1105.5 L 806 1125.5 L 786 1105.5 Z" fill=3D"#ff8000" stroke=3D"#0000cc=
" stroke-miterlimit=3D"10" pointer-events=3D"all"/><rect x=3D"951" y=3D"126=
8" width=3D"360" height=3D"310" rx=3D"10" ry=3D"10" fill=3D"#ffffff" stroke=
=3D"#0000cc" pointer-events=3D"all"/><rect x=3D"966" y=3D"1248" width=3D"11=
0" height=3D"20" fill=3D"#ffffff" stroke=3D"#0000cc" pointer-events=3D"all"=
/><g fill=3D"#000000" font-family=3D"Helvetica" font-weight=3D"bold" font-s=
ize=3D"13px"><text x=3D"970.5" y=3D"1263.5">OLD REPLACE</text></g><path d=
=3D"M 1131 1451 L 1131 1431 L 1131 1438 L 1131 1426.24" fill=3D"none" strok=
e=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D"10" pointer-events=3D=
"stroke"/><path d=3D"M 1131 1420.24 L 1135 1428.24 L 1131 1426.24 L 1127 14=
28.24 Z" fill=3D"#ff8000" stroke=3D"#ff8000" stroke-width=3D"2" stroke-mite=
rlimit=3D"10" pointer-events=3D"all"/><rect x=3D"986" y=3D"1451" width=3D"2=
90" height=3D"100" rx=3D"10" ry=3D"10" fill=3D"#f0f7ff" stroke=3D"#0000cc" =
pointer-events=3D"all"/><g transform=3D"translate(-0.5 -0.5)"><switch><fore=
ignObject pointer-events=3D"none" width=3D"100%" height=3D"100%" requiredFe=
atures=3D"http://www.w3.org/TR/SVG11/feature#Extensibility" style=3D"overfl=
ow:visible;text-align:left"><div xmlns=3D"http://www.w3.org/1999/xhtml" sty=
le=3D"display:flex;align-items:unsafe center;justify-content:unsafe center;=
width:292px;height:100px;padding-top:1451px;margin-left:985px"><div data-co=
lors=3D"color: #000000; " style=3D"box-sizing:border-box;font-size:0px;text=
-align:center;width:290px;height:100px;overflow:hidden"><div style=3D"displ=
ay:inline-block;font-size:18px;font-family:Helvetica;color:rgb(0, 0, 0);lin=
e-height:1.2;pointer-events:all;width:100%;height:100%;white-space:normal;o=
verflow-wrap:normal"><p style=3D"margin:4px 0px 0px;text-align:center;font-=
size:18px">XFS_DAS_LEAF_REPLACE</p><p style=3D"margin:4px 0px 0px;text-alig=
n:center;font-size:18px">XFS_DAS_NODE_REPLACE</p><hr style=3D"font-size:18p=
x"/><p style=3D"font-size:18px"/><p style=3D"margin:0px 0px 0px 8px;text-al=
ign:left;font-size:18px">atomic incomplete flag flip</p></div></div></div><=
/foreignObject></switch></g><rect x=3D"986" y=3D"1290" width=3D"290" height=
=3D"128" rx=3D"10" ry=3D"10" fill=3D"#f0f7ff" stroke=3D"#0000cc" pointer-ev=
ents=3D"all"/><g transform=3D"translate(-0.5 -0.5)"><switch><foreignObject =
pointer-events=3D"none" width=3D"100%" height=3D"100%" requiredFeatures=3D"=
http://www.w3.org/TR/SVG11/feature#Extensibility" style=3D"overflow:visible=
;text-align:left"><div xmlns=3D"http://www.w3.org/1999/xhtml" style=3D"disp=
lay:flex;align-items:unsafe center;justify-content:unsafe center;width:292p=
x;height:128px;padding-top:1290px;margin-left:985px"><div data-colors=3D"co=
lor: #000000; " style=3D"box-sizing:border-box;font-size:0px;text-align:cen=
ter;width:290px;height:128px;overflow:hidden"><div style=3D"display:inline-=
block;font-size:18px;font-family:Helvetica;color:rgb(0, 0, 0);line-height:1=
.2;pointer-events:all;width:100%;height:100%;white-space:normal;overflow-wr=
ap:normal"><p style=3D"margin:4px 0px 0px;text-align:center;font-size:18px"=
>XFS_DAS_LEAF_REMOVE_OLD</p><p style=3D"margin:4px 0px 0px;text-align:cente=
r;font-size:18px">XFS_DAS_NODE_REMOVE_OLD</p><hr style=3D"font-size:18px"/>=
<p style=3D"font-size:18px"/><p style=3D"margin:0px 0px 0px 8px;text-align:=
left;font-size:18px">restore original xattr state for remove, invalidate ol=
d xattr<br style=3D"font-size:18px"/></p></div></div></div></foreignObject>=
</switch></g><ellipse cx=3D"707.5" cy=3D"1799" rx=3D"16" ry=3D"16" fill=3D"=
#ff8000" stroke=3D"#0000cc" pointer-events=3D"all"/><ellipse cx=3D"707.5" c=
y=3D"1799" rx=3D"20" ry=3D"20" fill=3D"none" stroke=3D"#0000cc" pointer-eve=
nts=3D"all"/><path d=3D"M 621 1476 L 707 1477 L 799.55 1476.67 C 799.52 146=
8.87 811.52 1468.83 811.55 1476.63 L 811.55 1476.63 L 977.76 1476.03" fill=
=3D"none" stroke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D"10" po=
inter-events=3D"stroke"/><path d=3D"M 983.76 1476.01 L 975.78 1480.04 L 977=
.76 1476.03 L 975.75 1472.04 Z" fill=3D"#ff8000" stroke=3D"#ff8000" stroke-=
width=3D"2" stroke-miterlimit=3D"10" pointer-events=3D"all"/><g transform=
=3D"translate(-0.5 -0.5)"><switch><foreignObject pointer-events=3D"none" wi=
dth=3D"100%" height=3D"100%" requiredFeatures=3D"http://www.w3.org/TR/SVG11=
/feature#Extensibility" style=3D"overflow:visible;text-align:left"><div xml=
ns=3D"http://www.w3.org/1999/xhtml" style=3D"display:flex;align-items:unsaf=
e center;justify-content:unsafe center;width:1px;height:1px;padding-top:147=
4px;margin-left:697px"><div data-colors=3D"color: rgb(0, 0, 0); " style=3D"=
box-sizing:border-box;font-size:0px;text-align:center"><div style=3D"displa=
y:inline-block;font-size:18px;font-family:Helvetica;color:rgb(0, 0, 0);line=
-height:1.2;pointer-events:all;white-space:nowrap">larp disabled<br/>replac=
e</div></div></div></foreignObject></switch></g><rect x=3D"145" y=3D"951" w=
idth=3D"330" height=3D"310" rx=3D"10" ry=3D"10" fill=3D"#ffffff" stroke=3D"=
#0000cc" pointer-events=3D"all"/><rect x=3D"160" y=3D"931" width=3D"110" he=
ight=3D"20" fill=3D"#ffffff" stroke=3D"#0000cc" pointer-events=3D"all"/><g =
fill=3D"#000000" font-family=3D"Helvetica" font-weight=3D"bold" font-size=
=3D"13px"><text x=3D"164.5" y=3D"946.5">ADD REMOTE</text></g><rect x=3D"173=
" y=3D"976" width=3D"272" height=3D"107" rx=3D"10" ry=3D"10" fill=3D"#f0f7f=
f" stroke=3D"#0000cc" pointer-events=3D"all"/><g transform=3D"translate(-0.=
5 -0.5)"><switch><foreignObject pointer-events=3D"none" width=3D"100%" heig=
ht=3D"100%" requiredFeatures=3D"http://www.w3.org/TR/SVG11/feature#Extensib=
ility" style=3D"overflow:visible;text-align:left"><div xmlns=3D"http://www.=
w3.org/1999/xhtml" style=3D"display:flex;align-items:unsafe center;justify-=
content:unsafe center;width:274px;height:107px;padding-top:976px;margin-lef=
t:172px"><div data-colors=3D"color: #000000; " style=3D"box-sizing:border-b=
ox;font-size:0px;text-align:center;width:272px;height:107px;overflow:hidden=
"><div style=3D"display:inline-block;font-size:18px;font-family:Helvetica;c=
olor:rgb(0, 0, 0);line-height:1.2;pointer-events:all;width:100%;height:100%=
;white-space:normal;overflow-wrap:normal"><p style=3D"margin:4px 0px 0px;te=
xt-align:center;font-size:18px">XFS_DAS_LEAF_SET_RMT</p><p style=3D"margin:=
4px 0px 0px;text-align:center;font-size:18px">XFS_DAS_NODE_SET_RMT</p><hr s=
tyle=3D"font-size:18px"/><p style=3D"font-size:18px"/><p style=3D"margin:0p=
x 0px 0px 8px;text-align:left;font-size:18px">find space for remote blocks<=
/p></div></div></div></foreignObject></switch></g><rect x=3D"173" y=3D"1113=
" width=3D"272" height=3D"126" rx=3D"10" ry=3D"10" fill=3D"#f0f7ff" stroke=
=3D"#0000cc" pointer-events=3D"all"/><g transform=3D"translate(-0.5 -0.5)">=
<switch><foreignObject pointer-events=3D"none" width=3D"100%" height=3D"100=
%" requiredFeatures=3D"http://www.w3.org/TR/SVG11/feature#Extensibility" st=
yle=3D"overflow:visible;text-align:left"><div xmlns=3D"http://www.w3.org/19=
99/xhtml" style=3D"display:flex;align-items:unsafe center;justify-content:u=
nsafe center;width:274px;height:126px;padding-top:1113px;margin-left:172px"=
><div data-colors=3D"color: #000000; " style=3D"box-sizing:border-box;font-=
size:0px;text-align:center;width:272px;height:126px;overflow:hidden"><div s=
tyle=3D"display:inline-block;font-size:18px;font-family:Helvetica;color:rgb=
(0, 0, 0);line-height:1.2;pointer-events:all;width:100%;height:100%;white-s=
pace:normal;overflow-wrap:normal"><p style=3D"margin:4px 0px 0px;text-align=
:center;font-size:18px">XFS_DAS_LEAF_ALLOC_RMT</p><p style=3D"margin:4px 0p=
x 0px;text-align:center;font-size:18px">XFS_DAS_NODE_ALLOC_RMT</p><hr style=
=3D"font-size:18px"/><p style=3D"font-size:18px"/><p style=3D"margin:0px 0p=
x 0px 8px;text-align:left;font-size:18px">allocate blocks and set remote va=
lue</p></div></div></div></foreignObject></switch></g><path d=3D"M 309 1083=
 L 309 1103 L 309 1093 L 309 1104.76" fill=3D"none" stroke=3D"#ff8000" stro=
ke-width=3D"2" stroke-miterlimit=3D"10" pointer-events=3D"stroke"/><path d=
=3D"M 309 1110.76 L 305 1102.76 L 309 1104.76 L 313 1102.76 Z" fill=3D"#ff8=
000" stroke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D"10" pointer=
-events=3D"all"/><path d=3D"M 726 249 L 746 269 L 726 289 L 706 269 Z" fill=
=3D"#ff8000" stroke=3D"#000000" stroke-miterlimit=3D"10" pointer-events=3D"=
all"/><path d=3D"M 403 633 L 410.5 633 Q 418 633 418 643 L 418 780 C 425.8 =
780 425.8 792 418 792 L 418 792 L 418 967.76" fill=3D"none" stroke=3D"#ff80=
00" stroke-width=3D"2" stroke-miterlimit=3D"10" pointer-events=3D"stroke"/>=
<path d=3D"M 418 973.76 L 414 965.76 L 418 967.76 L 422 965.76 Z" fill=3D"#=
ff8000" stroke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D"10" poin=
ter-events=3D"all"/><g transform=3D"translate(-0.5 -0.5)"><switch><foreignO=
bject pointer-events=3D"none" width=3D"100%" height=3D"100%" requiredFeatur=
es=3D"http://www.w3.org/TR/SVG11/feature#Extensibility" style=3D"overflow:v=
isible;text-align:left"><div xmlns=3D"http://www.w3.org/1999/xhtml" style=
=3D"display:flex;align-items:unsafe center;justify-content:unsafe center;wi=
dth:1px;height:1px;padding-top:878px;margin-left:408px"><div data-colors=3D=
"color: rgb(0, 0, 0); " style=3D"box-sizing:border-box;font-size:0px;text-a=
lign:center"><div style=3D"display:inline-block;font-size:18px;font-family:=
Helvetica;color:rgb(0, 0, 0);line-height:1.2;pointer-events:all;white-space=
:nowrap">remote xattr</div></div></div></foreignObject><text x=3D"408" y=3D=
"883" fill=3D"rgb(0, 0, 0)" font-family=3D"Helvetica" font-size=3D"18px" te=
xt-anchor=3D"middle">remote xattr</text></switch></g><path d=3D"M 313 836 L=
 311 836 L 311 967.76" fill=3D"none" stroke=3D"#ff8000" stroke-width=3D"2" =
stroke-miterlimit=3D"10" pointer-events=3D"stroke"/><path d=3D"M 311 973.76=
 L 307 965.76 L 311 967.76 L 315 965.76 Z" fill=3D"#ff8000" stroke=3D"#ff80=
00" stroke-width=3D"2" stroke-miterlimit=3D"10" pointer-events=3D"all"/><g =
transform=3D"translate(-0.5 -0.5)"><switch><foreignObject pointer-events=3D=
"none" width=3D"100%" height=3D"100%" requiredFeatures=3D"http://www.w3.org=
/TR/SVG11/feature#Extensibility" style=3D"overflow:visible;text-align:left"=
><div xmlns=3D"http://www.w3.org/1999/xhtml" style=3D"display:flex;align-it=
ems:unsafe center;justify-content:unsafe center;width:1px;height:1px;paddin=
g-top:906px;margin-left:300px"><div data-colors=3D"color: rgb(0, 0, 0); " s=
tyle=3D"box-sizing:border-box;font-size:0px;text-align:center"><div style=
=3D"display:inline-block;font-size:18px;font-family:Helvetica;color:rgb(0, =
0, 0);line-height:1.2;pointer-events:all;white-space:nowrap">remote xattr</=
div></div></div></foreignObject><text x=3D"300" y=3D"911" fill=3D"rgb(0, 0,=
 0)" font-family=3D"Helvetica" font-size=3D"18px" text-anchor=3D"middle">re=
mote xattr</text></switch></g><path d=3D"M 1133.55 768 L 1133.97 872.76" fi=
ll=3D"none" stroke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D"10" =
pointer-events=3D"stroke"/><path d=3D"M 1133.99 878.76 L 1129.96 870.78 L 1=
133.97 872.76 L 1137.96 870.75 Z" fill=3D"#ff8000" stroke=3D"#ff8000" strok=
e-width=3D"2" stroke-miterlimit=3D"10" pointer-events=3D"all"/><path d=3D"M=
 445 1144.5 L 591 1144.59 Q 601 1144.6 601 1154.6 L 601 1447.76" fill=3D"no=
ne" stroke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D"10" pointer-=
events=3D"stroke"/><path d=3D"M 601 1453.76 L 597 1445.76 L 601 1447.76 L 6=
05 1445.76 Z" fill=3D"#ff8000" stroke=3D"#ff8000" stroke-width=3D"2" stroke=
-miterlimit=3D"10" pointer-events=3D"all"/><g transform=3D"translate(-0.5 -=
0.5)"><switch><foreignObject pointer-events=3D"none" width=3D"100%" height=
=3D"100%" requiredFeatures=3D"http://www.w3.org/TR/SVG11/feature#Extensibil=
ity" style=3D"overflow:visible;text-align:left"><div xmlns=3D"http://www.w3=
.org/1999/xhtml" style=3D"display:flex;align-items:unsafe center;justify-co=
ntent:unsafe center;width:1px;height:1px;padding-top:1130px;margin-left:543=
px"><div data-colors=3D"color: rgb(0, 0, 0); " style=3D"box-sizing:border-b=
ox;font-size:0px;text-align:center"><div style=3D"display:inline-block;font=
-size:18px;font-family:Helvetica;color:rgb(0, 0, 0);line-height:1.2;pointer=
-events:all;white-space:nowrap">success</div></div></div></foreignObject><t=
ext x=3D"543" y=3D"1135" fill=3D"rgb(0, 0, 0)" font-family=3D"Helvetica" fo=
nt-size=3D"18px" text-anchor=3D"middle">success</text></switch></g><path d=
=3D"M 1131 1290 L 1131 1205.24" fill=3D"none" stroke=3D"#ff8000" stroke-wid=
th=3D"2" stroke-miterlimit=3D"10" pointer-events=3D"stroke"/><path d=3D"M 1=
131 1199.24 L 1135 1207.24 L 1131 1205.24 L 1127 1207.24 Z" fill=3D"#ff8000=
" stroke=3D"#ff8000" stroke-width=3D"2" stroke-miterlimit=3D"10" pointer-ev=
ents=3D"all"/></g></svg>
\ No newline at end of file
--=20
2.25.1

