Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 495C2C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 22:21:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbiKIWVT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Nov 2022 17:21:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiKIWVS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Nov 2022 17:21:18 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B260E12AE0
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 14:21:17 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A9MJase003215;
        Wed, 9 Nov 2022 22:21:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=KQ4z9jlffwq9eQWBI9pUPa2ZR1ouA46UwmGiKEg0vyg=;
 b=JDYwfrHQ/Ns0YX6jDsJDhGlUmG7OxDmbsH4mua9aUUzFEPeGgkfIixMwWPzvpjHph6h9
 /CkXASc3oPS/haVUlhu2Rzx4a7CLsbOWJpcxrk6T7iC1rJbbewzGTMeknbt0cFft5mX2
 505xmIeBAlGEak9N//+Xv5QQk7Pd4Ww9fYgJOnV7DBdrSmo0kHljIbIYS1NZyYRzYFRB
 l/TvhPDLcLYDn5i45WYF9i4sQLeDx+RlwhEXqDARmq5HpDpdSJO2OGdWeJFMTxDX6Cpz
 UX0EuOAX8pzdCiJuEVbSuxdmbXPEtkdtG1nskhBYQ44mltCCovaZrIVcIWwAl0+QINJb BA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3krmqqr18f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Nov 2022 22:21:00 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A9KiH4t004265;
        Wed, 9 Nov 2022 22:20:06 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcq428m1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Nov 2022 22:20:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MH8ixY8p2XJV25E+Ci3KyGEO3gMuvj6Xcpc22KzovJVxWbe0U+S6MsEQ8bIwAezMr+TsdoNp1veak1N1zVQe4ZlNaJEs6RlLV4L4Kcq1Ywz6zbyoeHRjvDy9fFkXEYaXFd1nUxNXvSYkZ6Ik8xk7/BCaohSwlNyL/Vf/ccGLiggJXSGe4YovD9votnbQupzCV1hKNA8IxBGAvaYETCRh6+T5U7D7JutiQJPEo3e9rRcF2Tc3R6iJ9pVP6H8z2gtAq+DanY9uyYggaTPGxxbDOVG2xccnjVkZCup0N/2C28hx0qkXDLiyXfRFl6ZJtMCBWF5WWjyBykgDSKRUtgQCvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KQ4z9jlffwq9eQWBI9pUPa2ZR1ouA46UwmGiKEg0vyg=;
 b=axLM22HOvDuPaTO9G2hZToPqS/Zqq7DrlQzwdMxUH9CgQvHVNnvE2iKgiAF4pdumVn3Sq+ni1VS7NPpGX8QIzxscyBkLxNB9rmUMmHgljJL+WpI7WORplF5eNQ1K+HNcV+RA+z/Fs4q4+K5Y1Elziz9aMtJxMVSb7KODE4aD1MmA8KEqVrGlbf/JZR1dOMOFJszwWK7yiOB2Mi5OfROtHaKtwTgwbutvppf4GBDeB2VHgebxD8WevJYetQjc7/ic/sUf6D5kWL+r3+e9oZuaPWNmP4ciutGqNu++ChBy3SbqcHoFlA+T84pSxL77oGVd++dsWMLvZk28Drl/AhkX5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KQ4z9jlffwq9eQWBI9pUPa2ZR1ouA46UwmGiKEg0vyg=;
 b=GfYvyohVt5J7fVNgmgOPV0fGA6UjSXcvX46gvYWhyZo0lv5hYGt9P0LdI2gZQiTZRv8fZ30x4XpFOHLViPe/YrehxdwGiY9EVlwWOqK54qX7BK6HJ5P52pJvzhoXMAYDnXEgdpJ41pvTMe0a31ZNjIW4dzUzt7RS4gedqTzpeSY=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH8PR10MB6672.namprd10.prod.outlook.com (2603:10b6:510:216::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Wed, 9 Nov
 2022 22:20:04 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::e1d1:c1c7:79d:4137]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::e1d1:c1c7:79d:4137%4]) with mapi id 15.20.5813.012; Wed, 9 Nov 2022
 22:20:04 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     tytso@mit.edu
Subject: [PATCH v1 0/2] porting the GETFSUUID ioctl to xfs
Date:   Wed,  9 Nov 2022 14:19:57 -0800
Message-Id: <20221109221959.84748-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0116.namprd05.prod.outlook.com
 (2603:10b6:a03:334::31) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH8PR10MB6672:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a88fcab-8964-4a17-98cd-08dac2a08d40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h0y4zakoYiM7jTEoB1pYOxVnikfByylu90odW6LwuwDRS2oNpsIxwq9XYlfWl0Z6tw0KssU/B9xz12m5scUQ1fhe9lC2eC4Ogi9V4pYpVKgTFQz/5tS1Q3T/TeBEAiBqtoy5C+nMcnC9qeKk6ArYw/0a5s1lYT9T4dEciTmrbb9Olaq4thnGABfm0VQ0R9b1ncLMxh66RtlVGrZ4uKlc27XBYy/YEMGTkKlTLooWEsU5XVi0N5UnhYDZjgVNUbrDHvd+bl90c+W12x/n7Q8PoUonKEEiVk+73BCpNBdy4Qy6CIqWIPAjMTrfyDXzLQm//rhhSOJVBHsUNevH0NvkKs/emChye3+7zC7EsGYBIwRcOc0K3H0VmEo7qUnwobV2B6/n10ywiLq7TQX4yxIDD9jkRSmALSHSdqHgVCTDxwRW9DXwCZW/D8wNkrwuwAv8wgljcUhUP2LAd8b9CZ2jvjD87/NbvGLLmpAQ91OWuSiJ0XtwxB6m37T6zT/h8eaAFaawu3etRvDRpkCtVYVojZKSDGSZ7fkTC06lDxp1x069o2yTlBWjcAZiwXqlBvQ9iyk8VUwFBGBQc9i994K+76YX8Kmkgjg99bLN2t4mDqWnKGA2skCkkqTLZlBU8B7A1XO+mAzavCVPZVJDjUnGQ2ikD60E39Nwi/UX7UgbRW/Eik5dmO4fQKI6DTJlUj6gM5b4I7LmDfydCPRXb32DrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(376002)(136003)(346002)(366004)(451199015)(36756003)(66476007)(38100700002)(4326008)(66556008)(41300700001)(86362001)(8676002)(83380400001)(6916009)(186003)(2616005)(6666004)(4744005)(6486002)(478600001)(316002)(8936002)(2906002)(44832011)(1076003)(66946007)(6512007)(6506007)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9k8hxG3+IQ0X0urjP/MZT4XNOD+vmwpNpFv/DVIYRPMJ5Oq5PP6P/A8D0rSv?=
 =?us-ascii?Q?WAcxw7oaHaCE7VFJDFZV1WBdPd0byhxRZ9lpnPLkx/hwFuGPqGy9rFnT1Voj?=
 =?us-ascii?Q?rn3mUIxJrKCy2X+fHUuHKo3pnjJ3wniINSsD3l7Heg/38vcR5QWNNmV56ZjH?=
 =?us-ascii?Q?VD8C/1va/IoZJ5NymdgAFBjyXgMcT8q/Xk02fgbm4kxNVgzwwcLti1ysU5U3?=
 =?us-ascii?Q?OBnrcFz7ql9BIpD9cozKY/bsJ1yewBayjjlr448xq9YKFc9QhDIG8FM4mQGY?=
 =?us-ascii?Q?Ic7+qST4X54geHMUlk4bGg2CAUzFlaaa+iO/guQwbID98BaxNb0pYc/6CBA9?=
 =?us-ascii?Q?lefHNIHGBbv+hpBinHd2k5nW7wlT0qbh6tiRye1ErIHn5SF57TJ0qckhsO7J?=
 =?us-ascii?Q?h8xZnArE09NciNdHRiq7o5bJxjo6YWpyh+tPkSMAZV3g3UAngq276WlhBiHJ?=
 =?us-ascii?Q?nieAJ+Qxr3aMxlXNlmMIO4YEAT5s9xaI/GBrKZuenrk0otbKQtTo8ZXTEef4?=
 =?us-ascii?Q?KoCt1FQanwhbWJjIYb6CbnjUnasz24E3rPSGGP1Vl5ngL+5t1eJ1sS+8CFqR?=
 =?us-ascii?Q?Xpim5qREQ8f1W9rG7OyIaj6+GyUjgUusn1153dvB7I5CSElHEAOXpI9mCC1/?=
 =?us-ascii?Q?hViiN5sOqnVPMAdTFAvDIei0RNdwWPU+t7GoDxwWTiQjERCwEJiVz5RTXuA5?=
 =?us-ascii?Q?Ti2IqjlYN+mwoc1PFzBNWRPAebAV08RXPAaoSwXVFXRVEJXl0sJRT7OXnyO0?=
 =?us-ascii?Q?UshbtUPrQt3iiqF+GclEXGeW7a3/GdgtCop0hVB16sMrZ7B8lqKVkljsdrBh?=
 =?us-ascii?Q?OLoyjCiLZEo1ZW7DJ0PNCQTJQj2B+oQ9P70LQs2STwD7felOk6Ds3laTEGww?=
 =?us-ascii?Q?+zoKsAY/4vHLM1mIKVNqfuuwQYys3CDQIKOn0odGISIpHaB/1d4LOeofdg9A?=
 =?us-ascii?Q?4UNAb44Oq8TQS8VsUIliLhybOaaCmOHCCSnqU2YYjTE7U8LZC/d+1vZUnNwU?=
 =?us-ascii?Q?4vfYnhD/CpLPFsKExekvQ3GmXFoqPe3I+sphxhcdY+wT74p6oytBNqWJ+xXa?=
 =?us-ascii?Q?eFZBhuCgNdWpKo/03uNSj/t1z/Ao1WvsA008lGqiKvhX2jwLXvPjInk5yhsZ?=
 =?us-ascii?Q?wBC4CrPldqBwuNYGoPv7VtvI0rVHy7gbCsm+eT9DLEOpr3oH+pXz2JiDWAII?=
 =?us-ascii?Q?gIQkUMffvfqlju52zCxBnhRqpjdV1xScUMMo7MOCdM/Gzk7wCryrfk6ZLmUB?=
 =?us-ascii?Q?1FeyOV7Aex2V304SkAcjmiO4W9jvndUGxk7i8BnIiuL8KbNx3IseGk8HuHrJ?=
 =?us-ascii?Q?1+r2eXYzF4VPai/IAgSWQ94XIVNXwIxDgCfAgcuUCCWs38OONW+mGH4bETrR?=
 =?us-ascii?Q?eBoaoVpG1e4W02yNIamYjALwW9KQCMbxzwnejy/DcR2vzTBYBCEkm1G/o1xo?=
 =?us-ascii?Q?VZ56Ry/GWQkIOzaBTikVCsg4AgYZG/oBGBfHXwFEpeBn/J22eo8+/joLRkHE?=
 =?us-ascii?Q?uh7U2taWccnezCd09/lAfWg1MSFeb8+04c4874fz4m038X/q9K5zpxJP2taY?=
 =?us-ascii?Q?xM3RzF1iqRiKvRFaa17xlrBIRDx6PvJcSxo1QruQVkzNMYn+d3wzGtkL0kXd?=
 =?us-ascii?Q?vE9jSC1r5u1ZKsReaaxxPhI1YnlSf3QhRh8kI9NXTfy5cgWNRTJpO7X91iw8?=
 =?us-ascii?Q?52CgdQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a88fcab-8964-4a17-98cd-08dac2a08d40
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2022 22:20:04.7973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KirvCGGHcstRfR+Yqs3H8/Q8DAyqMM424yTLzjn3gLOxVHm9hO/JFSB62AqxVjTGZV4yBlkdKv9QHu4rtboyPnkfIUE9W34/vlMG1CE710k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6672
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_06,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxlogscore=880 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211090168
X-Proofpoint-GUID: aVvvzs-NaoJYhlPgdcCBLhelYglFQHbs
X-Proofpoint-ORIG-GUID: aVvvzs-NaoJYhlPgdcCBLhelYglFQHbs
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patch aims to hoist the ext4 get/set ioctls to the VFS so we have a
common interface for tools such as coreutils. The second patch adds support
for FS_IOC_GETFSUUID in xfs (with FS_IOC_SETFSUUID planned for future patches).
In addition, the new xfs_spaceman fsuuid command uses this ioctl to retrieve
the UUID of a mounted filesystem. 

Comments and feedback appreciated!

Catherine

Catherine Hoang (2):
  fs: hoist get/set UUID ioctls
  xfs: add FS_IOC_GETFSUUID ioctl

 fs/ext4/ext4.h          | 13 ++-----------
 fs/xfs/xfs_ioctl.c      | 32 ++++++++++++++++++++++++++++++++
 include/uapi/linux/fs.h | 11 +++++++++++
 3 files changed, 45 insertions(+), 11 deletions(-)

-- 
2.25.1

