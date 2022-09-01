Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF92EECAAD1
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Sep 2022 13:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbiIANeS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Sep 2022 09:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbiIANd1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Sep 2022 09:33:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E5255BF
        for <linux-xfs@vger.kernel.org>; Thu,  1 Sep 2022 06:29:50 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 281CDnxv026349;
        Thu, 1 Sep 2022 13:29:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2022-7-12; bh=VnNwLpR3kVtyHoK0OthGaFEMoRxcrt8sWCKjCoQ9zAk=;
 b=t2vMc7EXEyf9FHq/WO2XGRkzL2leJj19q+aa5UCTEmV0ap6YNJS2FPv492cM0TlLAVrJ
 Xec7L7kzdzu4T97X2rS09NpKNWZyNcgiw0CgYThKCunzfAMlSYBuXJWAh9rlFcS3U60f
 hxt+KpckC0DosQRMB3e22UJEjJkrfZDhmrVHYe910lJt+bHeuPbPLXeysBhkpzXbTLKE
 7m9Ab+EoByJg8NUg05Eqyd1BUfVzK1A2cdJJW9Kzb7I5ZDP4hYeFSpzm5JcGrOi4mEwo
 8xjxI4Yk9tGudMcRqvkO3wemXSXN0eIGPsBL/jQE4Z1FW5NN3u3EEWM/i+k+rHlaJZz9 2A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j79pc3xb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 13:29:47 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 281CvsOn031508;
        Thu, 1 Sep 2022 13:29:46 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j79q6f7mr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 13:29:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KHAPMk4U9AJNQIVuwvwaW8l6mQ80BcDh0DGLZTJ00vE6ZeX7wz9OVbV+8XxWmnyYgJU6/S7EBJhzM8ToC+bMwUyww0gp+1S9y1vcaBWYXKYaKGdKhqip7zNmQWoCCuamr4pXReOwOOpYdX9BYKgIKkAu7/k53ghx6pbeeGKsMT6mDEBkyuYe3AMXs9Q6MnPk1oz4u+g6BN2xaX3oBBGOAK0HwmRopYe73j6nJWOONrMXM7m93c1gZ4glrqL4xEzASCVQgHkaHTHMsKSkGlX0eVgRLbxbU583tpf6e0jrC+zGgYt8fXmupyk1VAnqnzjkuLU3n1GV6VJZkqmiAnbfSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VnNwLpR3kVtyHoK0OthGaFEMoRxcrt8sWCKjCoQ9zAk=;
 b=FfjQJr8ZVe9ipPBRPhU68jFMKrjxKJ6fYNjQR0F44tLXJ5iCtqrrWcvKNSOskJow/A3dwBGZ+Ce4mTVC/ERalOLyoxWe1yCzgveMfZhnAQjT2/Qiz7wlUUx/s4Ll5h3kaxdt+h3dcgvqiUucYb0C8Pc1uBnJCXwtoOzJjj5tt4uXkkDDtYbtk0T5LF145IAKavNaaJF2KXLtq0Q5dB1WNYI4BsbqPSwBnFNWOmkzQJaEm0b2H7LF9MPmIzf1DM9o0S9Ko3QsFNdXBaa9UavW9b0zmJIRpTSevRTQ4UCXcC5x0LpOSOzOjg7l3LydeKoj8oDhmanUIm/18+rrSco3UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VnNwLpR3kVtyHoK0OthGaFEMoRxcrt8sWCKjCoQ9zAk=;
 b=V+1XPlh6YP71mKwquOPGTVEl2A4y6Emmm4IN1LBBgZltwhiaRNXWo2+eWDe0bzzNQ0oh6ZPjuesNdxxXWeCVqBQr6BWCSY0Qw3vaxhBcDbks+moKtjiKhBCIND+gco5IM8O60Zxj56hpqH/T6eVrFl4ZzDaOwDE0qhYWkeUuFZo=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH7PR10MB6554.namprd10.prod.outlook.com (2603:10b6:510:205::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 1 Sep
 2022 13:29:44 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::552:17a1:f9b2:eafc]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::552:17a1:f9b2:eafc%9]) with mapi id 15.20.5588.012; Thu, 1 Sep 2022
 13:29:44 +0000
User-agent: mu4e 1.6.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Creating written extents beyond EOF
Date:   Thu, 01 Sep 2022 18:55:31 +0530
Message-ID: <877d2np6im.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYAPR03CA0013.apcprd03.prod.outlook.com
 (2603:1096:404:14::25) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9d4fc43-26d1-4314-87ff-08da8c1e0808
X-MS-TrafficTypeDiagnostic: PH7PR10MB6554:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M1n1siva/YR4Zm4eL/AMpFE6UTj7uo/28oNIGvZ69JuVXH5J5dbfMvYXZRKFAbr8erYNTjA5zMP6I3C/+yIA9oglwtTP5ZnMNuIxdytdLV3fhCf18ZZBN1O1o9TEEcK5oElj7EOeSuOQN0mYmlVwP54zpXgdshRqpOAW0HB0LVHYpREFEERNHNrk+5CZ2nSXxILQxbEFNhmKCQIlRXJBYAV5AAFYCkzdyL8PHB/O8eFgfajMW1JuZ2Jw/1CKbmwh92NZPGUElYqEnpJn1kFlw2lreoZ0sTNj9oSbCk/uze01Gt/yKLtBAOdkGq207TXP5IDv45/lf+xbWhjrzxmEfgyfe3cdNOnB9caeKu9AnRbiMWrUk15YTd/0CuR8CZ3hG719Xmo3bxEimOHHcD+7v1LqpMDAXSIgdSAnJ8fcVN8ivdLFriw49b6Ob6e747jGZyunOFhnL4FfOD28sKRHih1HyvKhd8Bq+7wglIIM+wQV+IWyw7lJniOs0a0HUkIxreE/EKGnIob7bkckNt5Da9O0Oz/p18Iq1N5riLpQ92WHsd+3oKabBBPXgqOVyjJhsjPp+ItENf7nyoZ3Iv7ZkYptyCKWhEBrtDWf21CSAPwyBREYcJivR4/y8Q0aHpV7MPsj8vHLYKNnTEdFhpHI7RccSn4Qm9S7miuvMSlmbUFo77Lxi+WvkeglVgXrqYH5JOc67pDN+wYt1jHhYfrrSotCo96mwCOA59aIeor3zyw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(376002)(346002)(39860400002)(366004)(136003)(6506007)(2906002)(38100700002)(4744005)(8936002)(5660300002)(33716001)(83380400001)(66946007)(186003)(6666004)(6486002)(316002)(478600001)(4326008)(6916009)(66476007)(8676002)(86362001)(9686003)(26005)(41300700001)(66556008)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WmX9N0VYMbPLmhktK24HuvsgVSoZW52sd7ffJXrPxUAJ2BDNfN/AWnmDIIHa?=
 =?us-ascii?Q?tKoqwSWwHF+QODfqyer+h3a4VQr7tYh/2u2E+7KJzUrz+lDywoy1DxXFSRpl?=
 =?us-ascii?Q?OwAU4Y9hnfB+uQobsge5W58T1Fj4e04HN1auWVb12zEIMwcy/Levl7sTzSpz?=
 =?us-ascii?Q?bk80WZnmJ3y2meUpFhAUVN5ngo0gA8GhkiByq73+NLcRY81eKFtF4EEiHkp3?=
 =?us-ascii?Q?uxOkiX8fe2hsystH8YXoJzjBQpd76d0KcJbsbfumg/1/hiZelUvcPsLWKaEH?=
 =?us-ascii?Q?1zvSXt4aVKj+K6GOYdJPtLR5neYk/c7tqVsnVlqBYKMRAZwNCBfZiqfsdkj7?=
 =?us-ascii?Q?BCU3g+znJATBOWpJaoiGxxO+e+qwQs1Z4D/62DcaWiF3jwMyC1A+7Bk2jx4l?=
 =?us-ascii?Q?ovtW3ITrwpJaWWIwA+bsYySjgEJelgm4ez9pbirr+/cI/Jy079wGDSec2qW3?=
 =?us-ascii?Q?X3WvbnxhMH2TuHSaHfv9w9DhBrN49Pc4iuuIwmYNt3qOoKWvEDA7iChRJ08S?=
 =?us-ascii?Q?eoy8VvSduHoH31asXj8odYG/vsb6VFF6THUwK5tLTZL/hOcY6Wp7+fvboDnu?=
 =?us-ascii?Q?MXCRUPGDDjKYn48+DqCBe37R+RvjkVroZ0XB3bzZX6dnmTqleG973Buyn6aA?=
 =?us-ascii?Q?3JQvKysOFhW9Wt3remR02FIUSe5koX0pj8EvqmuVpr9vybKTPCZPGrgz3eSj?=
 =?us-ascii?Q?jjB/dBp571rUoVVwC71yvP7SAfilA8FTJq7E0eGeHnB3RkuqQcU24UHUFS20?=
 =?us-ascii?Q?OSoIBoy8qDOcWMwCsnhQuDig+VhUPj8Wra+/QY8AdOqHLGSwdm2kx8QSPOPo?=
 =?us-ascii?Q?7pTR/bmllLlZFTX6ga6P3VKni6mfTpWh+2lb78qqam1xWIgQhhEJLH+NY+ah?=
 =?us-ascii?Q?I7tA0o/S2tJPoBeQ0xD1NYjOjEoBoSlDE8ZechTMclV7FEhc0VLmSzG+9u/Z?=
 =?us-ascii?Q?GT80RV8qKN9JqntKmsSFUJX5Tt8UFxwF8kHOTHr8378W859kSJA4+4m+hCpq?=
 =?us-ascii?Q?Jm6e1OwOhmZNBokyMZ09P/0wr7VmZHWA+K1qXiGAY1cYdMbTpKUL0YiBdBOR?=
 =?us-ascii?Q?+zdRcRX7jQ2cIiGWZ6xKC3VaAqXT7hODyCSvtlmkhfjqbF12nGfyxIQjc/5r?=
 =?us-ascii?Q?3vbNLXvjZVRGVF8ANmzzjEPpAcqKcfGs0Vurc+LOuBUVQryFDYPrjgjGcb7f?=
 =?us-ascii?Q?ullr9gjCyxqFFt5fXl0PClylddo3/QJNP2fh6gqbJ1WISrcWa8hstuK2ARZf?=
 =?us-ascii?Q?eDX//op9imu5b7U2WtTZPrQ2X9qj/XFgBooo2ItwOR7pGMeK93NbweC7nzvC?=
 =?us-ascii?Q?BsqEOvxKktPwqT76wRtFFVJVO8YZc0y52z2HCtgxe2G3D/8UKEjQl1JjIYAi?=
 =?us-ascii?Q?4nowf+H7awrToQ00w2r9xxB9099jzApEv6P1MmA9qywOZiuAIQSv6Q5RHq67?=
 =?us-ascii?Q?wtYZSdwP2cTu8gbwnBmLiXyb1DKNsD1li3VBH3/wgux1jm+Up+XekTBLLdR6?=
 =?us-ascii?Q?Hx9KrlKiOOmMA4wb4aLUVP2HQSt9SOs0vWMk05C0Dy+ni+Fn8PbXGVipK3ty?=
 =?us-ascii?Q?ddpTeC6wmBDPCvBOX2HvKbWd/cHvLKq58ol82+9M?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9d4fc43-26d1-4314-87ff-08da8c1e0808
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 13:29:43.9436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0LrLs4zURWhAAtlqvM38uDcYHhdWWkhs69ugq+GUA+k3g+XBPB0E2ECNmvhhYnhv/7Z1ziU8EObV22JiJ3Ydkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6554
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_10,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=910 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209010061
X-Proofpoint-ORIG-GUID: gzX2ODee1vnxLXNuNk8jcDI2n9eL2bUx
X-Proofpoint-GUID: gzX2ODee1vnxLXNuNk8jcDI2n9eL2bUx
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

7684e2c4384d5d1f884b01ab8bff2369e4db0bff
(https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7684e2c4384d5d1f884b01ab8bff2369e4db0bff)
is one of the commits that needs to be backported to 5.4.y stable kernel.

The commit message mentions that we could have written extents beyond EOF. I
am unable to come up with a sequence of commands that could create such
extents.

Can you please explain how a user could create a file having written extents
beyond EOF?

-- 
chandan
