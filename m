Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D298C433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Oct 2022 15:41:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiJJPlI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Oct 2022 11:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiJJPlC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2022 11:41:02 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D637392E
        for <linux-xfs@vger.kernel.org>; Mon, 10 Oct 2022 08:40:55 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29AEx2RP031371
        for <linux-xfs@vger.kernel.org>; Mon, 10 Oct 2022 15:40:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=zdMbgRhGyuk48NR/TgvH30YFOEszCYDVLPPV0U1bsn0=;
 b=oxTRZRNdJqMRkZvg8zGt6Et4L1KHn7DbapkdMYwe02Cu48WmzIRr9vOfALDqZOoS/Edw
 BwmCJYEGYPZsejAbFyvTCYD9rlUcodAobdyayW0UbRUsWEmKXlVonz7Z0/32k3lWTrBA
 Cr7S387hNbniuboH9vvfgM49svtD9nyzHS6aMakeWYDZX37FCIsbNLxaZJ+E8jN0JffV
 TaiEWN82wL4jhAX8Rg7vj6Bvjfzy+57gnNHGGpJqIQEMmCl63alXCI5j9y1Wqa79cL6i
 FpPKv2mHAkoKK4UlkS4dCTRqmBgaBywuGFirEu36XhyDQwrK75ypmiWz5d+zQbSSw+i8 NA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k2yt1c3md-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 10 Oct 2022 15:40:54 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29ADlxS1002921
        for <linux-xfs@vger.kernel.org>; Mon, 10 Oct 2022 15:40:53 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k2yn2s7bx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 10 Oct 2022 15:40:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GJgAOXpMmiigqpmrK3q8YOmbch1sawT1K2X2ocI64KbG9mqiovwIlwEwLLXs0qS90IflW8Zilk80/5h+FjGzyemwycZuwFMKeDqd1I2PclSZa+roTEME4a2k5AhtGoNUphD9HS2hqZAgzJGpa+3xWTrbJR6Pr/8PtYYpnuCOrqHlrhSoKTzBOn8eBX5bSXm/4XTOl6p9htBJlbAN8kAusYDqj+D+XHg+I5brQkd3y31YdtLurdjyM95QIMOWekdoaC6mI/E2EpuXXEgFGwPOt5lTVXJ9Zp56V9sdB7fBfFIRaJoxnJKPli6fyLd6XiBHGEdVn0eYEQQXGRSYAc09Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zdMbgRhGyuk48NR/TgvH30YFOEszCYDVLPPV0U1bsn0=;
 b=nxcQjuH/RTCv2zc++0ml/rPYDjQk4ExbDSDysJTcLdzYV8zdb3+aniL9rI42GgpZ9dUtw/eo1MoW28V4Fs8JqFcHaoDQ2d3XFtDn7IQNr9HvcwyLPu9eYOdcZsbNswHlT8Hvc3e3fxWaG/DiJtYtuJ1b4Xeu9ynia7nXzugDbYTTxa7gxB3XaI5sKBpKlQKzx/sf1D3l+7HA4eecfYK6dTr9G35p4AgXbRnNIqlH5avy5RDKy8JsVhx9SQEc2w6iv0UJLp7EAu7kyp0yZPNyirPwdCzY+cHocf7eOntpypjlVM90OIC+1QhGQBv4jTG+POu56LZ8VumTClw9SeswvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zdMbgRhGyuk48NR/TgvH30YFOEszCYDVLPPV0U1bsn0=;
 b=xCCzy+Jv64cUbnMgVFyTStZvRZQE7JhptRM2we7pUTBBu5m9OqwLissral/QK6J9zLqw2pPPCuwksO8ZOhnqFxQv2NrLZUmIkOFTFIJVpX+xGB9i3QUns+xAycrbv5Np0QTByDN34Qm+pONdevzx9lowR7GoWCb/nE+2tHtzLEg=
Received: from CO1PR10MB4499.namprd10.prod.outlook.com (2603:10b6:303:6d::12)
 by MW5PR10MB5874.namprd10.prod.outlook.com (2603:10b6:303:19c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.40; Mon, 10 Oct
 2022 15:40:52 +0000
Received: from CO1PR10MB4499.namprd10.prod.outlook.com
 ([fe80::e109:c486:179d:cc9f]) by CO1PR10MB4499.namprd10.prod.outlook.com
 ([fe80::e109:c486:179d:cc9f%5]) with mapi id 15.20.5676.040; Mon, 10 Oct 2022
 15:40:52 +0000
From:   Darrick Wong <darrick.wong@oracle.com>
To:     Srikanth C S <srikanth.c.s@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
CC:     Rajesh Sivaramasubramaniom 
        <rajesh.sivaramasubramaniom@oracle.com>,
        Junxiao Bi <junxiao.bi@oracle.com>
Subject: Re: [PATCH] fsck.xfs: mount/umount xfs fs to replay log before
 running xfs_repair
Thread-Topic: [PATCH] fsck.xfs: mount/umount xfs fs to replay log before
 running xfs_repair
Thread-Index: AQHY3LwVwhxafQuHdU6pDhNMIQMxlK4Hw7NF
Date:   Mon, 10 Oct 2022 15:40:51 +0000
Message-ID: <CO1PR10MB44992848A2000EFE3A930871F8209@CO1PR10MB4499.namprd10.prod.outlook.com>
References: <MWHPR10MB1486754F03696347F4E7FEE5A3209@MWHPR10MB1486.namprd10.prod.outlook.com>
In-Reply-To: <MWHPR10MB1486754F03696347F4E7FEE5A3209@MWHPR10MB1486.namprd10.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR10MB4499:EE_|MW5PR10MB5874:EE_
x-ms-office365-filtering-correlation-id: 260a550d-bcea-47ad-0640-08daaad5cff9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5X9ExTbQQqcldYCKLv7PkNI1T6Q72gFmwj8DV77BpjQFLB4OraJ9iPsiABbxNke8EU/Jw/7j7npkUB0jdVXd/iCzcfNbC3mB+kyxxRHqLNyCd8HtNabdOta03+KTYQQ/FKGe1JbZNuN4Jg5VKMYE9MRLR45GHjsM9x9OD4//kiquMjw/XPtrySewEQCwpiVZrG89Z8fxrIMhADHRR0bvo6zwk/65C9NwX4poCNpR92lynWiZ3sB4qcxX/t8N/7CgRs5Imc0ZcXE1vo7+Oh5JWa1AyCdFyQmZIhEr+17mCk5AWG/RtobSatUwXUUhn9BB0EkbWLu8hUIgUzogbaaEFE0mb4ik7PG3KeQbFe3hvbsG+Pjx/sq4mEwjnHYjhZ3UeAM8Xd+7i7kxsPDmJWF9cTvUU5PkqneVhtrhcesUF977cMm92Bql8qYYuI8t9TEa8lsOvQyEpg1dH+CJSPLdDijdqxgw+6rh7b5wgPSv1XtXzoDbBuAEPfalXktwavKFI0IpNWYYedcK8LzF75dOZ6eUDd8+72ET/F7I7vm2MrdGngtvu29joBRZBNUctVpWNc3RAJ0Gup6xmd8xlHLO+SdLXYL37lWtDReh1lJOdUtB6G2ubyxig5rVRdXKMEpBxQC0669M3QxOipO+tqeBZxrH9oPatPHXcTXMKLwMUPseokkXZEocUmL8ye5gFvCr1SAWpJaOBVj/02NM3chKYw5nXXpILXxczdxrQVrYbcE7EC/vZneNC0+lpeBdxAIY115Nqnfrb9yOMD9PA9VbDQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4499.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(136003)(376002)(346002)(396003)(451199015)(38070700005)(38100700002)(86362001)(122000001)(33656002)(44832011)(2906002)(186003)(5660300002)(52536014)(107886003)(26005)(7696005)(8936002)(9686003)(83380400001)(53546011)(55016003)(66556008)(8676002)(66476007)(66446008)(76116006)(66946007)(91956017)(64756008)(4326008)(316002)(6506007)(54906003)(110136005)(478600001)(41300700001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VjMUIj2P0EbaslO0LqDqQ6Nvi8q+R+yC6bYy3vYipY7xrUWyz73n4cIjEwQv?=
 =?us-ascii?Q?GiKfKJOciYwR1VKwJQDtJBZzxlV7k1WRxcMJbuLMX95asWumoQqDuAQlmTnL?=
 =?us-ascii?Q?XwFm1c5JJckJLojgS2q0HPyArNVAxh90WqdkRDdYF5m8QJSxXtN4wlFxETsh?=
 =?us-ascii?Q?NpLmJfpPsl1shKut5IRQms8XX9vVFuOGPcWCeYoXjub17NJ/0v10Pz8X1kuc?=
 =?us-ascii?Q?Fssh8DV9W2Qjjpd/bmhS6qJOzJZZ4AwHYHXSlOM+/dSApNbjnCtSLDrDJxIs?=
 =?us-ascii?Q?cuCgqThnpkvOq0weGRWuWlrh8UCSczwr6pJHDbTKqI/uEuEU8M2viqpZtisd?=
 =?us-ascii?Q?Xpww/kAbwMPxO6WOJUBSrNXSQHAr0V4KFW8Nnv6876UAJqvcXsdIFmd7Tz21?=
 =?us-ascii?Q?kOT7mr1B5jw9lWbTCh+odNfof/Xo0fgOdqg6wVozOB3OEDmY3rtOj/YdKOUl?=
 =?us-ascii?Q?DwSi+XfVltmAeEs83Eqew/ROsg82FmMQELbR/LAS+bx4Ps3sUxpYy3RjLLp2?=
 =?us-ascii?Q?E1syjQM7y7H+GatIXYwmwwJ2nKrwCPxBtVO/wDUN8o5M6Cz/8b4rKC+EjIwz?=
 =?us-ascii?Q?+uOmpTouQz+QY0w5f3MWDrqmNrvzCI12RDJ7FJWyH4n8fRYg9QOcGhqRx+vA?=
 =?us-ascii?Q?RaYVMhiGrA1PwIRPT3Rz9TcH6+EPzt26pCCCiOj++N7GpDrWjN/gdyAYBj9D?=
 =?us-ascii?Q?rSrhoNc47cRAbjxcsuPldHW5SlnqH3ZpR2Fzz+Ek+IhGTiXh51qLDSfNr9IA?=
 =?us-ascii?Q?B0YsfMBD5xn+A4i5X3lkj96srglSvJgX+D4eLuh6IO+M68LFAyx3MkG2Mnbz?=
 =?us-ascii?Q?kfWXiz5M/JML7wxa6TepfQIrrNM3Cu6xnKfvWpGPRWMZAS7MHEmmi1XqD/G3?=
 =?us-ascii?Q?BhSUkMUMF8LoTQy6CQ2mcHjrsIBvK72D+Ma3WbCR9oXqqarlsXjgUmOsBoay?=
 =?us-ascii?Q?1TsrED2WF3+9+p2mpAEZs0LHbMQGW8rP26hRpXNPqVSlzmLTkkC78eoszzMN?=
 =?us-ascii?Q?08fC7TjOJeaZNq/s9Q5+XW3A8WFu4Tu2W7VKVbJLX1espPywxDJY0XqWsIki?=
 =?us-ascii?Q?K+GOypZ/QQSmuh6xSzCOX1fEkJ0/pjNhz92q8oNP3GRaA6qx1gRHhz6Yh5g0?=
 =?us-ascii?Q?qdqHskaVXmM+sieczBEp8+QxFK2tt3VfzmFhcXlDkYwVhk+zY8mHjBH/h9SC?=
 =?us-ascii?Q?B2LqlHGYhx6sgFQ868lmfWeensd/V9inuYSv+1cOVagNVgI/36l8ipxx0f1t?=
 =?us-ascii?Q?oGP26Xtu5avfn7Krpg2dZKtfgNHNvmR8uZkcPuFbiVZWkHW/jhqFuROGULF6?=
 =?us-ascii?Q?8dqdp4ggmzVXjatuKJyvMQloAJ26T76+rpmLQCJBniYB7qQZrZiZzNe+N1UK?=
 =?us-ascii?Q?VWRdJ0o7pnoCPX+GFBw9MWV/tVbpxkQ2ZPvW9KyfUoyM4JSQCnRdL3EO8FC9?=
 =?us-ascii?Q?lNJ/cIMZVHqEkG59tFgPbwYrQK+g6Fsitx2vxF0r/maht+I30uC0n6SotiWN?=
 =?us-ascii?Q?Y171olIHoV+cniqW4RkNLA8g5k1hciX5pjwYkLPY+L7+a0UbrOJ6u2LTFZpn?=
 =?us-ascii?Q?ehKIAaGAwZQ7Xiw9DS2L14TManewzlQALB6jiOdz?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4499.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 260a550d-bcea-47ad-0640-08daaad5cff9
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2022 15:40:51.9837
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u2Sq8gAZDrZAUOBbbqUpovN+BhgL5t1lnksm8uxlMBoN9LmbuSAK9VYEFFAVD1w93dlWYB9bFTaJilNLS+pHEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5874
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-10_10,2022-10-10_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 malwarescore=0 phishscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210100092
X-Proofpoint-GUID: WUda8-7rNVdPC19AtGTzFgCc5RKdHtUz
X-Proofpoint-ORIG-GUID: WUda8-7rNVdPC19AtGTzFgCc5RKdHtUz
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

LGTM, want to send this to the upstream list to start that discussion?

--D

________________________________________
From: Srikanth C S <srikanth.c.s@oracle.com>
Sent: Monday, October 10, 2022 08:24
To: linux-xfs@vger.kernel.org; Darrick Wong
Cc: Rajesh Sivaramasubramaniom; Junxiao Bi
Subject: [PATCH] fsck.xfs: mount/umount xfs fs to replay log before running=
 xfs_repair

fsck.xfs does xfs_repair -e if fsck.mode=3Dforce is set. It is
possible that when the machine crashes, the fs is in inconsistent
state with the journal log not yet replayed. This can put the
machine into rescue shell. To address this problem, mount and
umount the fs before running xfs_repair.

Run xfs_repair -e when fsck.mode=3Dforce and repair=3Dauto or yes.
If fsck.mode=3Dforce and fsck.repair=3Dno, run xfs_repair -n without
replaying the logs.

Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>
---
 fsck/xfs_fsck.sh | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
index 6af0f22..21a8c19 100755
--- a/fsck/xfs_fsck.sh
+++ b/fsck/xfs_fsck.sh
@@ -63,8 +63,24 @@ if [ -n "$PS1" -o -t 0 ]; then
 fi

 if $FORCE; then
-       xfs_repair -e $DEV
-       repair2fsck_code $?
+       if $AUTO; then
+               xfs_repair -e $DEV
+                error=3D$?
+                if [ $error -eq 2 ]; then
+                        echo "Replaying log for $DEV"
+                        mkdir -p /tmp/tmp_mnt
+                        mount $DEV /tmp/tmp_mnt
+                        umount /tmp/tmp_mnt
+                        xfs_repair -e $DEV
+                        error=3D$?
+                        rmdir /tmp/tmp_mnt
+                fi
+        else
+                #fsck.mode=3Dforce is set but fsck.repair=3Dno
+                xfs_repair -n $DEV
+                error=3D$?
+        fi
+       repair2fsck_code $error
         exit $?
 fi

--
1.8.3.1
