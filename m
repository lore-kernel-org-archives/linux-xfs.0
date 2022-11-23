Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CC0BC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Nov 2022 06:31:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236022AbiKWGb4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Nov 2022 01:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234531AbiKWGby (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Nov 2022 01:31:54 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE725CD0A
        for <linux-xfs@vger.kernel.org>; Tue, 22 Nov 2022 22:31:53 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AN64wDJ020554;
        Wed, 23 Nov 2022 06:31:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=d0awOaDZwF1TTs7gFEdjUY1n0IcvC6CB13X81p1XdK0=;
 b=v0Lx2S5yORlTiFptg6G9kSg/4P2gOopKwZ0jV34TimyuDnZVJ74oR6+tpBCrhWS3HQXA
 fgNtRetghpLXu0wB+8QXHbzyndOpdXTcyZYMAHKFj4kOy0xaMeMRviKLwhENVeH2WW48
 3NECJ0bR36jAwUMqJ+DP03eQfJePRHDYfGJBoY1EMnmSoCCBpvRdB17flfm7QCfLwsY7
 92tnCWlh4k3g1V5i/fDNug4Nhg+3oBfTS/02+8nda7omurv/HCw9AHvjuU/+gRI4ogwT
 OU8CPSHhQ/lM0OM/Z7Hh9igQRgVhdL7/Hc7gMUu8ppg12NKiOCnCNfW7TM1KAztEJoSl KQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m1c9405tt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 06:31:50 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AN4JA3C039503;
        Wed, 23 Nov 2022 06:31:48 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2170.outbound.protection.outlook.com [104.47.73.170])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnkcr8tg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 06:31:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lf7QvhG40uk3tl5y+uuJH4it5Lu+FMHXXw0HuJ/nhv9habelLlhVHSOeQ9wThqvd22Aqbrb9Iem3x4smiC63RKgxnBqhX6ZwxDF7xaDAbj7BUmt5XyM6WmDG4gk7fo15YXoGgm874K62GQckXL2dmCWBoar1bAOzHQIA8DHvPDMRc1muAiKkNlMXA0Stqx+qGBIIBmAyxXFxsDPlS4lrbtWS6GiZbr4w/WZNR76DYX41YnHpSHaa7+Csq0tvY/95RthSbDVlD5/iopEuv9s+avylpC6Ju+ZhBF6E4WIrx/5CIrfP9TnM5y9lO9GcQc1hl32yo+jKF5nXIvbs+7sxXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d0awOaDZwF1TTs7gFEdjUY1n0IcvC6CB13X81p1XdK0=;
 b=TqBYE6FRdAnY8M5AUuFD0sDRvpgpl40EVHGDEeV53xTTYg+Z8r9xOQQxOQZ/RrBPK13PPkLlmWCqBlIEMgBg/p+FIbOlEuigz5th11Anl+A1nS8DZV6DoqzDyRyba/wb7OUeAtPIE7Vjf30flSROEDER3JzcqTtwIFAKI6NiZ8fe5jR8M1sdcXLB5o0yTUVikJHVY2eGzJbYpfcYPHAFexG+ZWKqxPVUYp7cBwc3g6OhI+9adzMWSckUwCxtFbeesp2GdRUUSnE82vzs9tXxQVXz70no8UpZiRaYnxLB30Fi5lqqjEdBgZGMt9/0NoBGxEiO9Ep0UlHDsBtAxGKEtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d0awOaDZwF1TTs7gFEdjUY1n0IcvC6CB13X81p1XdK0=;
 b=tzvmjphMf5lSgDo5W+7c1jo5BQbX5EQG44QZe6cnsrngl6k8z5kXg/rTA9YslwuEcSH3vV9ndx8EbMRnp2hYdAGv3ml1/sQQVYWmkV0G5Y33VMNjNbLDVmnhIBwWVUjYHjGt3CgLsOHOVYDshitJlwwBHohGsapinuwbkrcwRXo=
Received: from MWHPR10MB1486.namprd10.prod.outlook.com (2603:10b6:300:24::13)
 by IA1PR10MB6241.namprd10.prod.outlook.com (2603:10b6:208:3a3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 06:31:46 +0000
Received: from MWHPR10MB1486.namprd10.prod.outlook.com
 ([fe80::6151:c4f7:914b:6036]) by MWHPR10MB1486.namprd10.prod.outlook.com
 ([fe80::6151:c4f7:914b:6036%8]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 06:31:45 +0000
From:   Srikanth C S <srikanth.c.s@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     srikanth.c.s@oracle.com, darrick.wong@oracle.com,
        rajesh.sivaramasubramaniom@oracle.com, junxiao.bi@oracle.com,
        david@fromorbit.com, cem@kernel.org
Subject: [PATCH v3] fsck.xfs: mount/umount xfs fs to replay log before running xfs_repair
Date:   Wed, 23 Nov 2022 12:00:50 +0530
Message-Id: <20221123063050.208-1-srikanth.c.s@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA0PR01CA0045.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:81::20) To MWHPR10MB1486.namprd10.prod.outlook.com
 (2603:10b6:300:24::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR10MB1486:EE_|IA1PR10MB6241:EE_
X-MS-Office365-Filtering-Correlation-Id: a6e2d433-fdea-47b3-eaca-08dacd1c6413
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jZSt+VvQ0AJytGCdiPl854ErDeLW0KWWAzr+hmWXF2kR16ug0Lb/ppxDpgrllXuMpmU+WnR+vqs6aMilJ0V9kXKv7Y/QJJEkDfbZOdHA/YxQfJukxiOPhUHbpE4ollKxhmPgeNy2g2CNbHiJ8lro05xBrq96+gsMuJLqxugYKz+egs0H8uqMJl/4uBrf9absfvQ97kUiw+fpHciv0Do2U9wckVk6VGodT2QgIUxki5NFxeIua8X04pW+XbW7vo09p0yk+ZACP2RQ03xfh1kkEtQuBMIJ6V6CHJc3Ymqsl1OIbZcbYsCV5a6CNpSA/N3MZHbhgkW9dHNwBfBjIP2AHFTGvQqLD4AjBiVhk7/odMPqlMBNfBBOi0VOxD3D0p+iYNjI8oDGEWJZcM/WpTFnP17BA0l0VG5RrQ3tF2RJlLb8k1V62a2g7yPLTPp72O3amOspiO0ZyjGdNdddIYzuLJeCHn2neNiiK02DAxpGH5f/aAAl0JnAEL47fcBk4L92mBSJWbAe5KRKinNcCawljQYHs2wxd9g5IMKiK86AAkFTrgyXkP/n5GWvc/mKgRbfd/2H577HcAyln/KfOhILqtXhSKOg6b0TpV4WDL+1IpF7JcbAB4DAMPJX3NhY0aOVVUw/0pAj5NYKOaRR4YI3Pw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1486.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(366004)(396003)(346002)(376002)(451199015)(478600001)(6666004)(6486002)(186003)(6506007)(26005)(6512007)(6916009)(1076003)(2616005)(36756003)(66946007)(66556008)(66476007)(8676002)(4326008)(83380400001)(316002)(41300700001)(5660300002)(2906002)(86362001)(103116003)(8936002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xny4nyg4Tbpf6hBY15Dn+6gCYc84kyzD7CHoryuTf6BjRvnIoDN0DXodxLGK?=
 =?us-ascii?Q?+xndDGyfJN+WF3Hm9pHb90AluIskZ7WbOIxOPOqemjt2li7889dZmoB20UiW?=
 =?us-ascii?Q?N8dRWfTxUcVM56AAl8+EoMRH4lsiheqRdTVoVUupvBni+aynZqo+PwiMEtYO?=
 =?us-ascii?Q?QwCjVJEMxSwRf+DqsOnrKAVEMM/uhv8p9onu5BBDizxxUb6SkY+TnafUm/YF?=
 =?us-ascii?Q?b8l5zc104sqSEYXU4Oj7ZHnwf2bJCYQA2rE51DbpCLEwhNxdy+Uprhj4k2rY?=
 =?us-ascii?Q?I64VRJoXpom07iXZ+viM65y9gFwfbo0iXZ5zCtqlsO0jp5yA7yaqY0Q9xrQY?=
 =?us-ascii?Q?IZmcJGGO31pVUmnKpNS6x2qruDei08q5sw0Vk0iUCI3GgZp9vrj1aX4+UeLN?=
 =?us-ascii?Q?O0ZhfLRFfL+XwngPk8g/T66CRs3ajUo2dPNhRh/g/yjsRye504SogZlYkj/9?=
 =?us-ascii?Q?lg7lL7D9Ed6BTK8aJxBit81stY2a3HK3CQLxBffvDKNOKGot0IXr2hMvKXsr?=
 =?us-ascii?Q?0Yop28zpkcruBY+DcXHX7o+5lP39lAzSoPCqR2qtYPu+VJHqyQ6RJ9t5T0v/?=
 =?us-ascii?Q?MvdFio80whLCDAQCop8/ul5ISyyRPHdNba3aoROlWyIO5MSIskTf3Rh9Tgzw?=
 =?us-ascii?Q?odJG7oWt+MMGFFtNNkI+AR9NKA/TjZi0qUClfEvEGedSnMqHP/bMq5Sp318s?=
 =?us-ascii?Q?fGYeVlVA3MpxqMOTRPhMIugute8lvdy1T+OjDHMEmnvbrBjHSdWxdzpPbf8S?=
 =?us-ascii?Q?JCtjo+TG2EsveoIiWWFmA62GdtzTuYYF+CLx6E2M+Ts38dQBhkXji1HK/cHi?=
 =?us-ascii?Q?V8WUz2O3VCt9NtpcalhsbotDXWM5HS1kr4SpqcJ4w1e9Hhm11yb+8Gm7jkIN?=
 =?us-ascii?Q?5An+IMmiil3c1h1wLyQ3y1/MTecfl+vi6oOZXetJ8kRSWTvJVjnQwOsgaipC?=
 =?us-ascii?Q?cNV770KqwLNoiyVPsnvQmEcfNJpz7qkXqoN8cvux7Gge2PY0XxPNzO9b2Vf2?=
 =?us-ascii?Q?sjDExDMXxaN9yssIEbAgL2Hn6Kyn0172qTUHy9wtCsq+hnF9eLXjMVm96KfK?=
 =?us-ascii?Q?nrL/UtF+a90g37551gacyjdfurcWmVUYOSr/ZjPQFtumh1vJA3fC+BkMKPls?=
 =?us-ascii?Q?MQiLqTbHZtaq6H9U83QYDtDh6TkJbaRqpUNaMNadxl7XWm8oEe30QU6+TUQq?=
 =?us-ascii?Q?WnfiVuKHdsg6OrtmMy6P3E4oZ0QBOnQN5AXOrSfPw1wErC1SKqXKW6qTKVER?=
 =?us-ascii?Q?4yZCvQ+E2absKO5JulwqoBliCXKz1ZcCUG1pOZWPNdC5mkEUkYmdaEHPWuod?=
 =?us-ascii?Q?E4unBA6OaeYW82jC+lwZBuUGGVqHSOih/36tQfktGtpUTq5MUKaz45eVdbbS?=
 =?us-ascii?Q?HXA5fkVR+7qqK/7JYmCpL6Aw0GFkRjFuHNE/+bLsG4avh3cHuPl71sAr4422?=
 =?us-ascii?Q?Q4LYTSBuGOFxsFt+7ZKniwTIJuBHiYA748PV3e7Ms4FJiBv/Hxwz6GL9NPNc?=
 =?us-ascii?Q?M9QRZHCItICTcnofWJ48YLVQYVXuMZF56p3ymFcrIqr98uqEpsYvZ3m6MeXa?=
 =?us-ascii?Q?76OxCic/IJIc9D1olbTnN6jBRM2pv/IACi0io7Ok1DeZ6+Vs4X7YNdXL58WM?=
 =?us-ascii?Q?kg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: yCBvjEykojQjxu8IUd8al0Oyu0vIOmvzZUV8ju3BucK/BocZ1MBdi4iltWMQ8G5EIMFyqWU4ZMT6opYyUHagVHFHG+kiLS48Q1qdj1P5tlD99wLWdrt3wI68LcXUXoV7HORIvLIrhkf/xKBgqNpGWUdh6G8xGqzQCxa0j5AUGq09q3Ma2aEpqCfk2WuBP8D6VDbskqQWsz/8lIzpp5KURYAK8zs0LXxmZOFg/nAu48jQ7NY7US9/447nyCun9JuSFxEaQzKBL3Lg98Gt9V4yXAt7J1I4F1nzluOi/TldNnkZKjiArreyhuYHZk+pRYqEYYMQjHvWZ84tYuhgd3JLgTUKGM/J3v1QoWg5s3CC+y0vWq4Pguh71q9veR3kmzN6D9jIQtNN7VnF/qAAhmb2S4Vq3FvlTwEzwJ/4Pk8VcsNW66aAnLVELx3zAcFoKwrHMbdQCwGugJfknwu1IdTFiYuAmWIfj+wzGt1wNCS/CcciCXV+dF5XwodNU4xrJ/MzLI1hDk5ESqWybiTJLQn7i7PEmdiP0eNw8s9J8WV+aYOH5M0JQIQCZ+SsZ+sE9feA2lsS/hQnZdeKGmSH3Dilqal6XkQ30XiH7c3a+3vg7keFjBwqUHb3KDhzi6ZqO8tkFTS85FBScAZ+Ldl3wMo3Mjcgc6hkd8r2PMLYX28aCh8HldGfcEMB9tTx5QRKCaDtlFjSqQArJrg8j0n3PPkWYyiaIhPBfKjERDyeffNFTQRLKHOqwEXTWx4Uc8CoTD6KeAyRMhHROmigD7JpOuqHU3DfZ2FQqMWBj7mtuRnPtQUqPx9iN5ad2vxjLOzW3oypzr54yyy7Bc4U17hxC8J01Q==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6e2d433-fdea-47b3-eaca-08dacd1c6413
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1486.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 06:31:45.1432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PQ9zocIQHZsIKv+ybe/CZsGKah2lXs8iofvDckQFm679z6rPAKuJXp+219IsNPFm5kujpCweDMD1Q5w9x55PTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6241
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_02,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211230047
X-Proofpoint-ORIG-GUID: M9Apq0Fi_Id0pT-fxPYq1XLOMJYQ3fLh
X-Proofpoint-GUID: M9Apq0Fi_Id0pT-fxPYq1XLOMJYQ3fLh
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

After a recent data center crash, we had to recover root filesystems
on several thousands of VMs via a boot time fsck. Since these
machines are remotely manageable, support can inject the kernel
command line with 'fsck.mode=force fsck.repair=yes' to kick off
xfs_repair if the machine won't come up or if they suspect there
might be deeper issues with latent errors in the fs metadata, which
is what they did to try to get everyone running ASAP while
anticipating any future problems. But, fsck.xfs does not address the
journal replay in case of a crash.

fsck.xfs does xfs_repair -e if fsck.mode=force is set. It is
possible that when the machine crashes, the fs is in inconsistent
state with the journal log not yet replayed. This can drop the machine
into the rescue shell because xfs_fsck.sh does not know how to clean the
log. Since the administrator told us to force repairs, address the
deficiency by cleaning the log and rerunning xfs_repair.

Run xfs_repair -e when fsck.mode=force and repair=auto or yes.
Replay the logs only if fsck.mode=force and fsck.repair=yes. For
other option -fa and -f drop to the rescue shell if repair detects
any corruptions.

Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>
---
 fsck/xfs_fsck.sh | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
index 6af0f22..62a1e0b 100755
--- a/fsck/xfs_fsck.sh
+++ b/fsck/xfs_fsck.sh
@@ -31,10 +31,12 @@ repair2fsck_code() {
 
 AUTO=false
 FORCE=false
+REPAIR=false
 while getopts ":aApyf" c
 do
        case $c in
-       a|A|p|y)        AUTO=true;;
+       a|A|p)          AUTO=true;;
+       y)              REPAIR=true;;
        f)              FORCE=true;;
        esac
 done
@@ -64,7 +66,32 @@ fi
 
 if $FORCE; then
        xfs_repair -e $DEV
-       repair2fsck_code $?
+       error=$?
+       if [ $error -eq 2 ] && [ $REPAIR = true ]; then
+               echo "Replaying log for $DEV"
+               mkdir -p /tmp/repair_mnt || exit 1
+               for x in $(cat /proc/cmdline); do
+                       case $x in
+                               root=*)
+                                       ROOT="${x#root=}"
+                               ;;
+                               rootflags=*)
+                                       ROOTFLAGS="-o ${x#rootflags=}"
+                               ;;
+                       esac
+               done
+               test -b "$ROOT" || ROOT=$(blkid -t "$ROOT" -o device)
+               if [ $(basename $DEV) = $(basename $ROOT) ]; then
+                       mount $DEV /tmp/repair_mnt $ROOTFLAGS || exit 1
+               else
+                       mount $DEV /tmp/repair_mnt || exit 1
+               fi
+               umount /tmp/repair_mnt
+               xfs_repair -e $DEV
+               error=$?
+               rm -d /tmp/repair_mnt
+       fi
+       repair2fsck_code $error
        exit $?
 fi
 
-- 
1.8.3.1
