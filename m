Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C7BC4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Oct 2022 17:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiJQRXX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Oct 2022 13:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiJQRXW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2022 13:23:22 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6861B72690
        for <linux-xfs@vger.kernel.org>; Mon, 17 Oct 2022 10:23:21 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29HGoBUg004829
        for <linux-xfs@vger.kernel.org>; Mon, 17 Oct 2022 17:23:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=xCq4l4CLjEuidgWxRgGwRXxNieaenvBYG5BTInFmPPM=;
 b=SOHKM6ye9u10ydLGmaaSh0xyN+wpiulnxpj8kbC2TcjrkeOhW7ta9E0JR3RcD26X9tP3
 8e25ME71v4j2Y/WZ6OfXr9FXw6aXUFw0UZHCPT/YIXkGG5vxfaWKo9j0yXQqBwPpMp5Z
 igPKhex3XKxkPJiG4c0wdoHNwzZVDr1XUXLWsIATzZXF7KZWb7pZEnaBDsE79AM+KIT8
 3IE9YKyXvrIB9TJ0wo/kkdNCNqon3e/9vNkKT2/H2TBAmt899mVfRoiGahk8cPvzXx5Y
 SEuGNIVjQzpKSWR9eFZU5qz7LkjYBBaSBlmeu6fsvGskvnh80H3kUo8eToGxeX0rjP5x wQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k9aww02x0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 17 Oct 2022 17:23:20 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29HF5rmj036355
        for <linux-xfs@vger.kernel.org>; Mon, 17 Oct 2022 17:23:19 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8htey1sn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 17 Oct 2022 17:23:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bcSHeFB/5+EZsThanjnbC94wPrAvPK5ZIy8CLPJtbVe1aov5JhxfhprX6HlzxWbpZy7eUG0a3FB0vKl4rXxQtx2RepEqV5sj4NZNL+frPKRpMQZPecnfI27f77m5n9JFd/9VcXtSX2mn6G1ow7VIx9z7zMwzE44q7ns0IRtQL6J0Js4RfnJIpq8W9owoGQluITSL8VFGpb6Jv4FngdCq8znWY031PQ4dJJTC2Gvq4y23AzGyaKX2CPDvYzrz5TLqCL23wLIp+a44nAgq8gR4va7Pfc2t7iriAcdkBp++l7IBO6EzAtv9e1bISphfIpwP1UtB+RTA3x5AU4ycURx9qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xCq4l4CLjEuidgWxRgGwRXxNieaenvBYG5BTInFmPPM=;
 b=iZFA1DW43fHpb9udZIbznUgHhYtMlkPa472rLxN5yvxdlpLvRi+pK9Lb8HeVo3nn6pH8HHxJXayXE001ODLBASQYmzoX6gq0XnBxgWFON5irMhneLpVBAE593neKDp+IR0Ip43zVdGRbmp5fw0gduVE0QGnZNQnSbYhu8xGXsgB+BEiqxki6Kf8KyYp4DaqT/OQBNOe4hKkjlcHxCr5CzftZ6LE6MfrmiJQ9TTLKBI0AjoAhz15RVIT/hdSr3JZ0fxqDpLqpFNcgb4vdgwP2LOchd1dLclUnOkz9ie71YL0adL2+685JNAm9WQeUXDh1m4raIU6vtauA0VafBj7X1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xCq4l4CLjEuidgWxRgGwRXxNieaenvBYG5BTInFmPPM=;
 b=Dhkk2wa6c2pluO9b0h5LJwkoMaNKXaOfUB4uS4IHj7qtaZ7h/Tro0qX3Wt7bqscbWJzUm4HPeeeZqAGhcpmYJAb8AfjbK7RtggNAiToGyj8pVvR7N5GJcHOaaGCeWLmP2BLf0UB4fhwfUYrIiVtkW9D0vVfOdZQpL/o6Pub90fQ=
Received: from CO1PR10MB4499.namprd10.prod.outlook.com (2603:10b6:303:6d::12)
 by BY5PR10MB4369.namprd10.prod.outlook.com (2603:10b6:a03:204::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Mon, 17 Oct
 2022 17:23:17 +0000
Received: from CO1PR10MB4499.namprd10.prod.outlook.com
 ([fe80::e109:c486:179d:cc9f]) by CO1PR10MB4499.namprd10.prod.outlook.com
 ([fe80::e109:c486:179d:cc9f%5]) with mapi id 15.20.5723.033; Mon, 17 Oct 2022
 17:23:17 +0000
From:   Darrick Wong <darrick.wong@oracle.com>
To:     Srikanth C S <srikanth.c.s@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
CC:     Rajesh Sivaramasubramaniom 
        <rajesh.sivaramasubramaniom@oracle.com>,
        Junxiao Bi <junxiao.bi@oracle.com>
Subject: Re: [PATCH V2] fsck.xfs: mount/umount xfs fs to replay log before
 running xfs_repair
Thread-Topic: [PATCH V2] fsck.xfs: mount/umount xfs fs to replay log before
 running xfs_repair
Thread-Index: AQHY4iKToX51erk3a0irQL+RH8Bz564S0Pbs
Date:   Mon, 17 Oct 2022 17:23:17 +0000
Message-ID: <CO1PR10MB4499FE19B71550868E6F25E8F8299@CO1PR10MB4499.namprd10.prod.outlook.com>
References: <MWHPR10MB1486F72607AE8681E25BA0D0A3299@MWHPR10MB1486.namprd10.prod.outlook.com>
In-Reply-To: <MWHPR10MB1486F72607AE8681E25BA0D0A3299@MWHPR10MB1486.namprd10.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR10MB4499:EE_|BY5PR10MB4369:EE_
x-ms-office365-filtering-correlation-id: 0e4e357f-46c5-41c7-e9a7-08dab064479a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xpxi5CyU4ftbs7WtRhSoi7yRDCYEtxaHvddd6P6wYZIQHJVFo09n++En3GGckyktLvw/sGoC+3DDxZPGVpt4Fk1BYumtoW4mm8XroJDfkSBrVOqVExLJt8SdD3EyWP9vDyFbqUykyHUEh9a9jxjfAZcK+bhGXAhvLzkrqXMLBasUVj2+iBZheIcR/4XQ7T0ysoObZJfkcZv57/TcMGTYBMoSVRXdjco0vikbDrQqfKyAKhZhLnS92P5yWZuK6snTDhKx1imAjtGWG4dvf/8fuRq7VnE6Hoimo13tPlqqvftuSGad5atxm1D4jdWcxCoFCewOtuNAAedWiDlQeY85dNX/KtMIB0X0SsO9yxPr28+8xDnVwBVjCiavgJ/qWbazwNTPMUNEBX/bpvaFmE39mntcmrNLNybyUk9nc2n9DWBTDAIQYzeTlGHLzSCJql0a2Pa40h/QV2z/JmO9Ds3zARDF1Go76c3yuc//We53yHSCDJAx+esvEFH0w/AoHooXks91HzRwB/K9Sn+oasrTmDO0KwGSN2pA7f3/yOvHs3EAL3zlt4seg3D70rU2rxV2/pJDPfOtaujf9TEqTYnkCzmaSWw1DVJ3Ra0+KeSKUbZxbWcnx9wstrLC+MdnJlZxs9RJln1mlTo+Pxp3NmjtvcLTvvpmqnhUjVp3mVoF4QfLEOuJ9aun9u892FgVMpTLrwN/ABveQtpYTdNPS0AFiQMCUzntd2a8vX8+y6XpvqUggz5ePBYQ2V675JVfGM6Rv11JNRzbnGhmj2nNYg65nQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4499.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(376002)(366004)(346002)(396003)(451199015)(33656002)(86362001)(122000001)(5660300002)(44832011)(2906002)(38100700002)(186003)(71200400001)(54906003)(83380400001)(38070700005)(26005)(7696005)(6506007)(53546011)(316002)(478600001)(9686003)(66946007)(66556008)(66476007)(66446008)(110136005)(76116006)(45080400002)(91956017)(55016003)(52536014)(41300700001)(4326008)(64756008)(8936002)(107886003)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?oPFF1b3wyzjcbAGKAcd2iw9PbanDS5DCzLLcNhDaha0dkZEPoN3NCfQu2R?=
 =?iso-8859-1?Q?h7SY6nibsZemDdLCwM4YCMOvG4Bl9x39S3WgmcwKp3Jpwn2ovXjYGlJSfy?=
 =?iso-8859-1?Q?uXgvtniqEfkIQI+r7ZnCoiiuLkH5p/EYp0kv8lvaBWFaB503LZTiVDg7Xm?=
 =?iso-8859-1?Q?ZQVBfueM07wt8glVY9ys3NwvKPhof45TGiZzIJOehBzq+pWIzgzEmJqMLm?=
 =?iso-8859-1?Q?sdfQGqQ7aWNO60dnUpVwiNbH45glWZ38B+DlfU/HKOm3U3fKMpKj0gyhuo?=
 =?iso-8859-1?Q?iEWu8HViz/5LB8dIcE5GeO9YhGnGKRLO+Q72w6x60hdKL8sc8S0E2wXUcJ?=
 =?iso-8859-1?Q?KFxhoh9d69HiGXwM8MEqVw5PYyAuQ/P6l+zmtLVZROob2FdsB2wBLD58Oj?=
 =?iso-8859-1?Q?6bCg9oyZefnawYBwbicIl8BR7gbQEjzSH06OF6arY/v4HJP/xZHinIUhFc?=
 =?iso-8859-1?Q?3B3VOGvnYc1eVYOs9s9as40HXWsgaY3D0kMT4JWTpF4scixjyH5u09kqrC?=
 =?iso-8859-1?Q?atHoyXKWyinsiETF3UQbCJ87SULKkqrqdy2wLGq1COJMAaE0XGtbLTtzEl?=
 =?iso-8859-1?Q?yPq/YBAxtDLsUxC3AKt/76/c1azvFVARBWMH1fcxhhLMxjPWAPEqVLV2HC?=
 =?iso-8859-1?Q?BvFLUEuFwkyJt7lax64G7BOCFc16/DoG07NNq/aoB2PveG3TrhrYW9g/ob?=
 =?iso-8859-1?Q?YEP3fuGVeLflEIVdMf8Mc6ixjQUYbXDL5Gce4NEw1HW4eq7UwXVHpj9KYe?=
 =?iso-8859-1?Q?Afg2qjfYsN0sXPbW3NTM+EikpfWe3JrLGXhCfuNBj66FSMolwTnR7es0fw?=
 =?iso-8859-1?Q?WphpGnHOKlRicuuXHG2Z7bzw/l35ESX+g6GGj94JSJSbpMp/A5Kjsaqwox?=
 =?iso-8859-1?Q?LS4HdlyjQ1Fwb9AzwI4PkHH4sgNuFyHYuYdgdlw+6aHrQ9cYyoxEfh37NO?=
 =?iso-8859-1?Q?nsR0N+PVzsF5Qfa32Qb7+F6IVpyVGd3L7aMO6FuTRZirn9ul/m/1xhez5G?=
 =?iso-8859-1?Q?gIGgxZZ1gbNeSX6xo1KOdIT2zzw9HqJCys97OloC6d7dLm5A28fgIPxGcx?=
 =?iso-8859-1?Q?JI1tc0PBuVc3vpfun1M9uf+noKjeWkyEWMGbkItHPvCjN64pkU5XW8P1vl?=
 =?iso-8859-1?Q?ejqVstxOpfK0nZoK1sARVJKG2lbMhchpDn7or/WE2T1tkrzagq8TF4yaL1?=
 =?iso-8859-1?Q?llHjU5BG7Kg2+5CpY5GSV1PAwHSgDdVoTDaVwtlAjyvvsSLXwjVg16iy6g?=
 =?iso-8859-1?Q?2g/IKnegAXTL0ykehNGSoIaA85TpQHCiBto46YMAQaACKxQ8xCdF6UoSFW?=
 =?iso-8859-1?Q?F6oEkNS0A36XPWlu0j/ZF+km2MMh0GMu70RrYWH/O6iFaZbPA3eOztsnUu?=
 =?iso-8859-1?Q?Ok8oLI0qVnCq05grD3CUPttZdX2rphoH3vtBKAX6RRifoIa2WwBNZUYnFk?=
 =?iso-8859-1?Q?e4JOgeaW2fEkIhPjtnLQZ0oph1fMxkTls0Ftnq3gGrPrguXF27Diy9uBSX?=
 =?iso-8859-1?Q?NbUB/+TBjY5XSgKQolr4OXjB/K7OnDYySkUuIcnt7rlu6vwK8a9O3RUyFS?=
 =?iso-8859-1?Q?OmhftfOcV0MMacGFaYbYA1qFJJucEZt+K0AMuNMBqwU4N5rAlzil25DDyj?=
 =?iso-8859-1?Q?pdZZrSgN6OKAElGiySo2E470kulc27Tpos?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4499.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e4e357f-46c5-41c7-e9a7-08dab064479a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2022 17:23:17.0743
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x5BUj+sMZZX9dE6Re44IKZa8vHdBa7f7+LM/PC3EAF2LlXlF4pmdHXB0aAVKAzVxdcPzw+n9/S3qITe6cb+Kqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4369
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-17_13,2022-10-17_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210170100
X-Proofpoint-GUID: db3Ob3KASadmkVusplhoihlIdi1oo3HT
X-Proofpoint-ORIG-GUID: db3Ob3KASadmkVusplhoihlIdi1oo3HT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This looks ready for public (re)posting.=0A=
=0A=
Oh, you already did cc linux-xfs, and ... somewhere the message got lost ag=
ain because $OUTLOOK.=0A=
=0A=
--D=0A=
=0A=
________________________________________=0A=
From: Srikanth C S <srikanth.c.s@oracle.com>=0A=
Sent: Monday, October 17, 2022 05:23=0A=
To: linux-xfs@vger.kernel.org=0A=
Cc: Darrick Wong; Rajesh Sivaramasubramaniom; Junxiao Bi=0A=
Subject: [PATCH V2] fsck.xfs: mount/umount xfs fs to replay log before runn=
ing xfs_repair=0A=
=0A=
After a recent data center crash, we had to recover root filesystems=0A=
on several thousands of VMs via a boot time fsck. Since these=0A=
machines are remotely manageable, support can inject the kernel=0A=
command line with 'fsck.mode=3Dforce fsck.repair=3Dyes' to kick off=0A=
xfs_repair if the machine won't come up or if they suspect there=0A=
might be deeper issues with latent errors in the fs metadata, which=0A=
is what they did to try to get everyone running ASAP while=0A=
anticipating any future problems. But, fsck.xfs does not address the=0A=
journal replay in case of a crash.=0A=
=0A=
fsck.xfs does xfs_repair -e if fsck.mode=3Dforce is set. It is=0A=
possible that when the machine crashes, the fs is in inconsistent=0A=
state with the journal log not yet replayed. This can put the=0A=
machine into rescue shell. To address this problem, mount and=0A=
umount the fs before running xfs_repair.=0A=
=0A=
Run xfs_repair -e when fsck.mode=3Dforce and repair=3Dauto or yes.=0A=
Replay the logs only if fsck.mode=3Dforce and fsck.repair=3Dyes. For=0A=
other option -fa and -f drop to the rescue shell if repair detects=0A=
any corruptions=0A=
=0A=
Signed-off-by: Srikanth C S <srikanth.c.s@oracle.com>=0A=
---=0A=
 fsck/xfs_fsck.sh | 23 +++++++++++++++++++++--=0A=
 1 file changed, 21 insertions(+), 2 deletions(-)=0A=
=0A=
diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh=0A=
index 6af0f22..4ef61db 100755=0A=
--- a/fsck/xfs_fsck.sh=0A=
+++ b/fsck/xfs_fsck.sh=0A=
@@ -31,10 +31,12 @@ repair2fsck_code() {=0A=
=0A=
 AUTO=3Dfalse=0A=
 FORCE=3Dfalse=0A=
+REPAIR=3Dfalse=0A=
 while getopts ":aApyf" c=0A=
 do=0A=
         case $c in=0A=
-       a|A|p|y)        AUTO=3Dtrue;;=0A=
+       a|A|p)          AUTO=3Dtrue;;=0A=
+       y)              REPAIR=3Dtrue;;=0A=
         f)       FORCE=3Dtrue;;=0A=
         esac=0A=
 done=0A=
@@ -64,7 +66,24 @@ fi=0A=
=0A=
 if $FORCE; then=0A=
         xfs_repair -e $DEV=0A=
-       repair2fsck_code $?=0A=
+       error=3D$?=0A=
+       if [ $error -eq 2 ] && [ -n "$REPAIR" ]; then=0A=
+               echo "Replaying log for $DEV"=0A=
+               mkdir -p /tmp/repair_mnt || exit 1=0A=
+               for x in $(cat /proc/cmdline); do=0A=
+                       case $x in=0A=
+                               rootflags=3D*)=0A=
+                                       ROOTFLAGS=3D"-o ${x#rootflags=3D}"=
=0A=
+                               ;;=0A=
+                       esac=0A=
+               done=0A=
+               mount $DEV /tmp/repair_mnt $ROOTFLAGS || exit 1=0A=
+               umount /tmp/repair_mnt=0A=
+               xfs_repair -e $DEV=0A=
+               error=3D$?=0A=
+               rm -d /tmp/repair_mnt=0A=
+       fi=0A=
+       repair2fsck_code $error=0A=
         exit $?=0A=
 fi=0A=
=0A=
--=0A=
1.8.3.1=0A=
