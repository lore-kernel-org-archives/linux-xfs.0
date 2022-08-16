Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B100FC25B0E
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Aug 2022 22:51:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237050AbiHPWvB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 18:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbiHPWu7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Aug 2022 18:50:59 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD3258B996
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 15:50:58 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27GL9Jpm004835
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 22:50:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=fjhah2WQAktj6tP0dCwDd1NT3+ezyz/zH7mGTV4O7Oo=;
 b=JG8yy+xEHfdwiVpCSQ+XVjs1ILK/qzt3XK8NEV/zqZB0Obx5x6it2tFJzmc28mqoAZBJ
 IoUNAItXlizX5DWZ3YKDNxHPRDypJcVKvMjF9OTMo8/noZLFyaywVvdkPb+xsi5GGzQi
 JobvtUSEu/2Rm/HveNgNbiOgXyC4HZcrYwcu2HYAr+IDfAhT53qcYpIQu/Kzi6Uw6zIQ
 /x8NNhQg2iHNrEiB19EloxLRwBRso2VvUBwORhpizBEnv67Oivt8LRHwK1dGhdqoMXuK
 03GYxJetGLnvuXiDljq7Qm3Arrjk41dSoWNWA1Fbo9H+MWy55w6rp4bhxEXsmR8jTnhH uQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hx3ua77f4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 22:50:58 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27GK0TRw021278
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 22:50:57 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hx2d8yd3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 22:50:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hbRa+DOIuhzcng9bptdRGs+Ddgw3rrTstlm2bbhYjQfe7H4YSuIMfdwZJaAqqs807W5VN7cDprCR2M0w4HDq81tnl9th2xQKr2Rhg6PX03LrXLO8ieF4avWhsXAkh+D5cPElXDBNmETy0syDK+PeczDpwEb99jSSKiynA0ncSfql+B+qbucqIg64Sa5aUJAcl/6CXaswy+Ts2vucLxOGJMgrFVEnsECWjZ8SSp2+D8FZYMLjDcafqrqr+/4Sh5MkzzccgAZJv4ya6lU5zro7fxhNVrHytgz9/CrAjz1FSo5mOeY57AcOty6zsv8LG7jy3Y90UrleITUIKua5soV7CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fjhah2WQAktj6tP0dCwDd1NT3+ezyz/zH7mGTV4O7Oo=;
 b=Z+PE4k+nINkq6pS4x3J19AKFEarv4ofR3X9D0KHo8zwRN7NeSuC2FanjUGC66CPow7HKPugVEAW/LHqbou1Lr4PxlRErUVHoVxYcNaegBvG4HXfHLqEq/wyYSFMWczcSbhnZKhUlWuBNNHIRdwy0taKdewe7d4RzxEtCCX0ogS6rZNzbu5ooN4phYOpr3xLeZx6YIh0XOLEJqhwtrmnAaufb4idsr6Hg6jUOVl9D4D+KYqGIoVcFkKDS3xzl6QmGjceJcosb0Cz5RWrgUhJcYAzHgb6BOJ4oSC7owwNZpklugyIZLQZq7HBJG+8HqoWcxeHPSbI4tJ2BfykiBXzyIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fjhah2WQAktj6tP0dCwDd1NT3+ezyz/zH7mGTV4O7Oo=;
 b=bYF7iN6E+GzBGVdqV7StzHYV/gCXFZCcippJKSxarg4ST0Ks/OIpYsadYnklxLn4rqhADQ5ONGO23vX4BaVK0LBQMz3C36Xmif2E5ir0dLjpfzVZ7QyvmWYQeuMFsK0exgefAP3bdekdyh98oagwzjpjibnzMfCz1gWT2PYqOwM=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH7PR10MB5721.namprd10.prod.outlook.com (2603:10b6:510:130::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.21; Tue, 16 Aug
 2022 22:50:55 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::cdcc:bfdc:551c:8632]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::cdcc:bfdc:551c:8632%3]) with mapi id 15.20.5525.010; Tue, 16 Aug 2022
 22:50:54 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 0/1] xfs: add larp diagram
Date:   Tue, 16 Aug 2022 15:50:46 -0700
Message-Id: <20220816225047.97828-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0048.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::23) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b981fe0-bfc7-4172-28b5-08da7fd9c6b8
X-MS-TrafficTypeDiagnostic: PH7PR10MB5721:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JfnlYqYchlWXLvW+B59EQSVbjq9EewL/EMDdV6iTgehd1CxglCd9rkX9RlVyqI1Vmfjsc7rOYYjGbCOlEiZSXqj/6x25CJga21kn2FMRfRYH5sx6GSc4ff4Yx//utfRlm9+q+DkNFdA6dOt9Ie0Nk1a1L54UANMJN4wQ0Dv9riaVqHPYsKrX3fEEIGr7ls8yOazMuj05GiQRDCjTnYQxo2rJcTGyrTEtGPYug6kOmccF+BLX9eg1EBLoUu2OhXgk0V+YEgUwqQ7vK59/ZJdh0v8hES2kZjiP4DrZ7ofvRZLAh5UTQaGVOv8mSR5ixhNOk2NBdDfT32HOme2M3aTGsvFdr34ugrgpbECEcHqGbEXMWRL4JTmvTzYxmbkDmGJ/pUuJR9DuL/pbcmf4wLdEPzSgFxhZtWMAON7IaQKo6aiQi5CdZeM7gAn+czu4yVFC92JA4wgSWdvEDma0/2K/sBwDB5XLcOKpEzb5tOg2qgL1KW/AUAtdOvG83HKbpZF0YtDJonwE4QSyYqEtcM7h4Us7Yf6XAXaIrtCvtI1mi7D9IKwKacx1JLOwO2qjNrsVh3QdZp5jJ/DKUEGeHf31d43HgxwmP7QY59E7HZzL2usrnTQ6jRyjnu6R4Dw5RO8LOnIWpYCbQXQr/MWveVmINDD+0+wGgTxixCLuBWliqdKSJjkhExrOxZ1U6J1kblj/fAdWRp8GqZXlq8/Z+UagQx6sr2cbLQul2tm3PQ5PZUIPLi37enD+5bPdig6LtYzWjw0kU0mzTmosMZ+z7JtwKKHK8oD6PUSFH318p1aE3C56Bos7wlz8Tu/xvuf0vfkm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(136003)(39860400002)(396003)(366004)(52116002)(2906002)(66556008)(5660300002)(36756003)(66946007)(8676002)(1076003)(966005)(186003)(478600001)(66476007)(2616005)(44832011)(86362001)(6486002)(26005)(38100700002)(6506007)(8936002)(4744005)(6916009)(6666004)(316002)(41300700001)(38350700002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gy6uhS7apRlGahtpJKrubhVo+l/t21o+3m6hn9cA+k+ryVclFre/UPTsOTy3?=
 =?us-ascii?Q?UoB2i29pYx7ZBDAOnBvjLHZ6D+H3XFLN5gHfy2u/O8PEWiy/4J3TwQ/7gkxS?=
 =?us-ascii?Q?UgOmSnmYHZ22Jb49HK7R30o5wbhz8m+d/CSR8o9/xzjiLEua/8UJszhYAOlj?=
 =?us-ascii?Q?WSiD/CDraaNcN4KjqOWLClFHk4rZF3yxRqOEFsO7FXHHgfnbbd0oLngr6NJ8?=
 =?us-ascii?Q?flgiDNgCjeGAk6LMSA6qjaw6ON4mXRanufIg2UBBu9TskJNhjhMEQPsl/iiu?=
 =?us-ascii?Q?eqvHP5BKOdsxBDJqNnEsJ27kc4Ytd5qNyE30PvukHqZGV9SG2buRHztnSibh?=
 =?us-ascii?Q?IEzRzt/U2dKMI5Y2qGOADCAExcK5Pf60xEwzwN7yp7XRdDvMbm1LXFyXrVUE?=
 =?us-ascii?Q?MjrnE0e5VW4KmcxP91EGdceD4CufwitmUtdwaQGN2naVz+qULztOaWBNZWb4?=
 =?us-ascii?Q?aIkx/vhnlbKNnmRqt9QvQRnLCQBsHcbuYubcIwF3leanETYxJre/dfYsQvLO?=
 =?us-ascii?Q?bhlkMFYg3JuIDcDqcLgh7ybihaWGGRk+qWHvfivwVfaslK/3Q+yBooEYtU/m?=
 =?us-ascii?Q?YnCqEmNoY29GD5V8RTNO469Fpmmxw/P8mSOl1mNWoOqDAzFzMmkd1H+rbTXc?=
 =?us-ascii?Q?7oQYvUCaelQ55AfslgZp+uKOihN26vPj/qKO3tQVBphLkhsKqu3mj7NeleUa?=
 =?us-ascii?Q?AlTz6DJ1kN13ocnimq5hLbTf8cBSwerJh1bkCs/fUJXvtvdYLG0iEQEsFnTa?=
 =?us-ascii?Q?0rPeiG5AWV0j4pJqHQLT+RfkYM2IF2O7iar2b6AsQ5MKD+31kGc1Oca+EncJ?=
 =?us-ascii?Q?4RoEOHRnSyeuN2ca+TsdwoahVk6F7kQcd+GY/vr2Qs4VqMi9fqyTawXmIvT8?=
 =?us-ascii?Q?tJpnPIMorWFRcUMxxuZ328iz2YZ2z4UO+PRjsga4Lx9zMm7PJCBJGCMidOl9?=
 =?us-ascii?Q?z2YypC6dmS9Pjd45Td1YKlSNDR+GCyj4F8PjOTHvvIqgCUKi66ZBKWaDazf+?=
 =?us-ascii?Q?4rSoLow1RSUEpErPbdTGPCsycIcUrWDdyoIGE547Kiqh4oQm8dwkjvIB0Gys?=
 =?us-ascii?Q?NVgOt2MIwAK8g2Vf/V58+gVPJH5pg8SWFM8XeHFB5Ado2BvFiC4+dnHLR0nT?=
 =?us-ascii?Q?C0mSehFMycY4w932QOGVV2ZoqqrGx5mWnYWZvEkZLD63b+vGj9MTfxy5uWI7?=
 =?us-ascii?Q?C6Uy0ku8tj/NFCtuMyBZ7dvbLLDWod8qYb8iv84ex3GEwLYRF/y7SWqTXGp6?=
 =?us-ascii?Q?665jzXMRqYfMpMt4kLfKRI3mibYuuuPj0SELXMJhaYytlbG2F+0lSgqQJyng?=
 =?us-ascii?Q?+HEfUbbGRcKmoVCoyV4770jfZSC5xuMPFJH5M+/5D83fvmOiFQLHAwD22j2W?=
 =?us-ascii?Q?P58k5d9fBJv74Ms/TreBortiOClas0+BWHD6a9wOrH9rc0RSXGmMn112oCkP?=
 =?us-ascii?Q?sU7GoNtWWExH7Ba9sePKM+T+fijIDQvwU8Tugb/7pYiuLbf/gCr0G3dV54z+?=
 =?us-ascii?Q?0hNqyWlBv0pJfkdxB/LV0avl7aJDoDDH/T/gdjoQ+pYpwwoxRXXjJkh7E+KI?=
 =?us-ascii?Q?3LpKB10Z68uFis1aqEWCwE6qBLiWpkPz9S9uu5Rk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b981fe0-bfc7-4172-28b5-08da7fd9c6b8
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 22:50:54.6653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nqC13e92SGNXckl7MrYfgdYFMz6yPRuyBwL7pdSVZGISB0ay2eGcZhaz6PXDfBYKgWJT6eotHEYoT6JLCqp4G+ITP3/E2X3ii0viMUG1jKk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5721
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_08,2022-08-16_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 mlxlogscore=838
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208160082
X-Proofpoint-ORIG-GUID: OE4riAHBt-_UvgoUbNiYt89nTyF2V4b9
X-Proofpoint-GUID: OE4riAHBt-_UvgoUbNiYt89nTyF2V4b9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I've been working on adding a diagram to document the various logged
attribute states and their transitions. This is largely based on Dave's
diagram, with a couple of changes and added details.

The diagram can also be viewed here:
https://pasteboard.co/xyGPkCADuH4c.png

Feedback and comments are appreciated!

Catherine

Catherine Hoang (1):
  xfs: add larp state machine diagram

 Documentation/filesystems/xfs-larp-diagram.svg | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 Documentation/filesystems/xfs-larp-diagram.svg

-- 
2.25.1

