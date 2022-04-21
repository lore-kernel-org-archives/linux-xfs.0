Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1F30C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Apr 2022 16:58:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348340AbiDURBT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Apr 2022 13:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbiDURBR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Apr 2022 13:01:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7905349CAE
        for <linux-xfs@vger.kernel.org>; Thu, 21 Apr 2022 09:58:27 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23LFYutN014729
        for <linux-xfs@vger.kernel.org>; Thu, 21 Apr 2022 16:58:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2021-07-09;
 bh=ZLVE4ctUKrka3q9MBpkoCPscAhZcPqtLoSwdX3+yTZI=;
 b=U9lOPfTLSg6RReDXtEuJvSiq0txCLZd1jpqldQA4V7FyBc0cggQ8LPU5fSIMOjMtKEHw
 LKUWwSh3HbuTPaPEveHcUts2p5DrIZqTABK423qyn8WgOP2NqwfNIeLqzTKdKPQZLJUg
 R77OhniTlrrW5guIOkW3+LGzYhRUL414SkmDpSizmBBnKy9KGkweA7C5CBF7XXYcLib7
 uTSgv2TO0lHAmH0FzBFx+Qh6Dv5yf/B/hWo274kbJBsY1g0Hx3LmIqYliLdIApUgBbSm
 QkV0pqNz1M0H9lgYVrEx750gZqjgM3cz0U1+rrC/WqW7oXte+I4We2D1KE2Eiigc1gp/ Qw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffndtmnnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Apr 2022 16:58:26 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23LGqDqn018189
        for <linux-xfs@vger.kernel.org>; Thu, 21 Apr 2022 16:58:25 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm8c86yj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Apr 2022 16:58:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RSp/nsBpflfrcLw+68gFoBrQnWhbeVOAk3mmInbw4T9NI/dFUBE1BICI3a5P6Gj+0aFkIOMyn9S4y+zxNfBDAzlCbRc2yz7B3Js1/O/GlWYtZ8JJesBXSZUAHFOHU2rYW5kh6H8aAuHQDOCQti4Y7xQYt4aA2H9nOz93He588+y5KGYVScYo6ghlTC9UTafU48q1Q+UWp73KJB1hMUvjyo3b6jPlI/bJtQob7LJKekYRNLTajIzc2+SC2DnLrr4nF00rFfi2CrcbiA0JTN2y8nmeDhVmaq+tatNbVl5vjEYhP6kMqFjPSJt4T1yQfY6NlwR22SMKKhvPBi3+aPtLfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZLVE4ctUKrka3q9MBpkoCPscAhZcPqtLoSwdX3+yTZI=;
 b=VZRBiD+VBkimVrhT4eeUCEN8KQtpvC5EReqjOnXThvEGyIfXyoYDpF7iw/mV+4a1oeR7O+JlfeFaTNNzTZZ+fIjm+Rdbh4chuysACypA3BvbESICB8A2e3+6o55SfJlbKcTY/sMxZLMV287sj++06rdiv7vMOzyxS3gDSLp5vHrgrt0B7VznfgIZRy0z/eYxomVEuI9n951IUZTdj2pYbkAs/o0I1Bvedp9t1+oLMGUdhhuK55RrhGKNzFcRlGfZY1eQSiCjLC0B63L5KKenR1+0dpxdt6dkFD/HVG5Zx75ZGCxt3RM6KcoI6Zwxxroc7BlehP+/CIZitV77LPNeqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZLVE4ctUKrka3q9MBpkoCPscAhZcPqtLoSwdX3+yTZI=;
 b=xon+TLfyCzI3Q12IXWxyuYiiplF26wbKJzNPcoX52NrMNpJR/pQxKkL669JoGNPoHFxeJOuCvdj7SHBhXnUX/nFLO/s8wad1B5Yj+VHo1dF+7MHQWWpkNwafPu+HdJRTmZy87gS7JzJamZq1EUV39JBFFCEpikF3qeQ5SK9vTUw=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM6PR10MB2537.namprd10.prod.outlook.com (2603:10b6:5:b1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.26; Thu, 21 Apr
 2022 16:58:23 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0%3]) with mapi id 15.20.5164.025; Thu, 21 Apr 2022
 16:58:23 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 0/2] xfs: remove quota warning limits
Date:   Thu, 21 Apr 2022 09:58:13 -0700
Message-Id: <20220421165815.87837-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0193.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::18) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76b2b8ea-d365-44b0-d934-08da23b8252c
X-MS-TrafficTypeDiagnostic: DM6PR10MB2537:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB2537834254F16AB2CC221DD689F49@DM6PR10MB2537.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T1lHYxA8qO5Sr6MHamvDV5FIdai9sNSAloDxQ0te05rFEisa1UzcGqCXC+xNUBZJ9/VU6JFpdBdZtFF7MhzGXw+nzVaddLeaIgygm4DLepqvvH4l5AdZUik3x7fvHrTKxQiA+wDjKvTFdmrlqPg/bgdVe+6RqGzByWcYxogSi/cgiebzko+KFxFWJkcbZIrUKcVej0buffwIkLv5VoZctGQOICpakarrySTm3XaKpIBK09B5we7smcGSbnUphNmiHCmS2cMX6kywicg75iDgijWKi/iMIpl6eQYGAHmX77Ixas7ZDlY367+6cx63ty83CDKQijcs5W/j1dFaQD8ALgJgRfbn4UK5oGFcsKyKh8OawEOfPQA3wVq9waMYTOJBuqTzH+s3wZJ8pq/3X9cEwFwJvLPl3Om0WPWNK35stCTDCoY9r2uA8QqTmfhXgen+7nWZmLktjsZuXUrJlVPoxZykM4JnHkMZwsdMtly75nnAUYlTUPoI7cNZY+e2njOx47wFtybwb3Srkq1IY/fXopBcgIHEzIuulfn6MSAACk2giDNcUIAIKxbcRK7z8JsNpN+UPerGbEh/diCFWTuPWeIHpSZ47DWwpVH1Vy1sTPTkDrPTkkRwQq2m4bIRzgvX17Eym/9/8+rJ2BRkVGKEKhpaONBCNycpdp+QD44/cri+rklt7X1rNPL8eh7w5rSNN6P2Di7tUCAPqpew/b2M0X5A5PVLaLDSawxT3SIFNOM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66946007)(6512007)(316002)(4744005)(38100700002)(66556008)(8676002)(6916009)(83380400001)(52116002)(508600001)(86362001)(1076003)(36756003)(6666004)(6506007)(44832011)(966005)(6486002)(186003)(8936002)(5660300002)(15650500001)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U1AzeGJWQjRXT1dobXo1bkZqM0ZYTllyb1Jhblk1dkhqNmozWkE5VG95a3N5?=
 =?utf-8?B?YlgxWnEvaGxlSHNsUDgzcHJvTHZLNE9vek12SXI4TkVsRTFkWGNnTDcwL01N?=
 =?utf-8?B?N1JtMlpuZUhsbGFaMXp3VGpZb3pHL0dhMnBuekhpaXAyNnIrWUdPbzNKVjdy?=
 =?utf-8?B?TmlBQ2Njb3I1ZUp0SmhPcjRKWEd4L05kYmxSQWlyaGlMWXZZVENIYjZxcW9Q?=
 =?utf-8?B?a0NPLzNOMVRoK0E0RXVJVDZTYkJhY2hZT0tUMVhmOFRLclBPZUlJNUN6d1g1?=
 =?utf-8?B?V0hRUFB1Zmx3Z1RLdkNTRFQ0NE4yVEpTb0xwWXJ0YU05OFIvSEt0enpzcTRm?=
 =?utf-8?B?UkhjbDlISUxweDg0OW1ZNjlzcVRhbVhLRWtHY0ZpZHlJSm5UemZaNWs3aXR6?=
 =?utf-8?B?SWhMV3BXQzkzYUwzZzc4VGRXa3d3SG5UTEJXYnpUK3BWcFJ5cUFIbGRzTS9v?=
 =?utf-8?B?dWR4M2xLT2pYcE5wSFVyTjJLeFN2SEhkWTh5cXlrVVBhUW1Va2pVUUQrNDJu?=
 =?utf-8?B?NnZGdllRMVVaVDhZY2VBUmhGZGhkM1RPbGt0UjlUY2czNnVNaVh0UENVVzU1?=
 =?utf-8?B?bjdaditIOVd1WlYzaGFJcXRuM0VoQXdqaXBqQlNrR01jSmhXeThCMnRuQVZJ?=
 =?utf-8?B?M2o5dUs3WWw5RS84Nlk5Q1BPMDFrZGRDSTJJYS9GSjgyZkMvcHlMNFIwY1JI?=
 =?utf-8?B?NmpOYmNPQk04cWNyM3ZSdzliNTArWHZRTlV4cVgzdWhhaWFyVE55VS8rT0RL?=
 =?utf-8?B?L3JBR1g1U1JLTTNIdkpiQU9BRjcvRXV5SnhHNi9PcWt6SVQrQzNRTzZJN0w0?=
 =?utf-8?B?Snh2WEIxS2hRcHVWbWRyVkZBZU1zdmtsYzBtVUJlcnU5L0cwS3cyTDc5UHBy?=
 =?utf-8?B?MkVTWXp3TXdLdFlrUFpXRHZ3bTBoZU1JMElxQlNqdkJOWUwzLzc3ZE1TcElr?=
 =?utf-8?B?cVE0ZXFxRitUUVN5UmtOQ3UwU2VMYVl3UW9YYjhQc0FLUXBjN2NJM1pMTkRp?=
 =?utf-8?B?T2tjUUs1eXI1aE1SYW56S1FDeXpBWE13MmhrQWJ0eHUxVVVDOFdEVjdubHZC?=
 =?utf-8?B?bnhCVERJUGVDNkNzdi9panJsM1I3R0dLOWZ4Y0p5VzVKTzdxeSt1eVdKd1dO?=
 =?utf-8?B?ajhXblp5QVc3ckNZNE9ZOW1HSHVvZXhWYXdiLytoYTdXYTM4Nit4c0hOTmVF?=
 =?utf-8?B?Mjl3UE9ZWFI1QW5ZalVxUmlMeTVHN2pYQ0Vpa0RhMThFN0UxOXlWL2c5MWp1?=
 =?utf-8?B?M1p6djJPL2wzQ0VueVlwNUQrZW9iZWVKUG82OVJ4T1gyODRTbFQvcGsxeWpX?=
 =?utf-8?B?YVY1Rnp3VlBpem1Wa2FEWHErblVpczgzb29PdklidHF1eDMveDhPSGdaQi9P?=
 =?utf-8?B?YzU5a05VNnV2dEFQRG1qTDc4c3NqUE9yOVJwL040RCtYN3lXcDZWMVJ3ZnIv?=
 =?utf-8?B?U3h5YXFQK1FSL2lqaHlDekFqWFpvQmxvRTFMYThGWmltL0YxY2I0c3lYMVlj?=
 =?utf-8?B?WFIrV2JxUkRYSlNuUVRaVlMrUHdqb1d1MStZU3BHNG56U1RyNlpab3BJQjQv?=
 =?utf-8?B?VEdHaWxvTWlJUWhQK04vVnh6VVJHSFBGTFBxTEU3eWx3QkNjUHNPeXZvRkEx?=
 =?utf-8?B?MjU1ZDZwMzZrM3RQSGI3dUt1OTJjNml0ZkxiTEZYUWs4RHl5WVJpWVc2WlRP?=
 =?utf-8?B?emJVeUV5eEZrVWFRMFBCc3VIdmJ0SVh3RmZhT0tnT0pIT0c4MWlVVGF1Y2sr?=
 =?utf-8?B?Q1lPaGduekRUR2pYa3VDRTBwUmNhS05aWGU3cXlyQWZLZ3lnaTlKWkV1dGRI?=
 =?utf-8?B?R0JoN2VMMHNGYWhiM2hGYjYxclJWRzdXT3d5TDh1RFhqczJGdkcvN0NnYy9J?=
 =?utf-8?B?TUhiY2xCdU9uTHY0a3pUeEFOUHhpa2VEdkNVNzU5KzQ3TElSZXRNT1ZSYWdw?=
 =?utf-8?B?T3ZMS3J2ZHF4Y3RYVHFLdy94cTZ1NFpxTVZBeEVYQmk2ZW4vc1g0dTByTzZl?=
 =?utf-8?B?RHFIbUE1a2luRXhudFVrdXI0VmQwTEU4dEZaZEhOd2hqRnNIRFJlbFNDaTQ1?=
 =?utf-8?B?K1g5VjRjVUxnbzJpaUlneU9QS1l0d2pXQmNrcW5lZWY3RWk3NlRuelU4SzA1?=
 =?utf-8?B?eHlTRVZrbTNZTExzN3lPRGRNMys0ZnE0dmM5SW1LQmh4ZUVhK2c1MVkyTDY0?=
 =?utf-8?B?UmZNVXo4R1g2WEJKYVdlU1dQajFyQTFqVTl1SHA5VjFVS05idDRNZ3g4b1JN?=
 =?utf-8?B?RWhpRWhDOW5VQ29yVUU0dXZZS3FkYjJCWGlKYlBMWCt0Z1lQS3pteHRhL25x?=
 =?utf-8?B?S1VMQWlTb2RmbkJaOVNXQ2lLSER5MlVqSUhTRGdiVk9BTDdUKzFCWURCalc5?=
 =?utf-8?Q?u1SLV8SLydLm9ULCSvbZuSGHqkoupZ87whadLGXhqkuMk?=
X-MS-Exchange-AntiSpam-MessageData-1: KCmuVt0Wwq4RKPS/rlIMYGGwKaj3avWyPA0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76b2b8ea-d365-44b0-d934-08da23b8252c
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 16:58:23.3965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M4XtTRueK+Wcx48Hi/+pD1sASOH3Ict5yJdL0IHbkcjUk0tSDlWRYj8LitZROPTsddE/vgZovLNyjTpirxADR2jNR/ncwYet40fw/s6vP14=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2537
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-21_03:2022-04-21,2022-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210089
X-Proofpoint-ORIG-GUID: NiZULmiiDvKtrY4AF5vW_doFefgxMOhy
X-Proofpoint-GUID: NiZULmiiDvKtrY4AF5vW_doFefgxMOhy
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Based on recent discussion, it seems like there is a consensus that quota
warning limits should be removed from xfs quota.
https://lore.kernel.org/linux-xfs/94893219-b969-c7d4-4b4e-0952ef54d575@sandeen.net/

Warning limits in xfs quota is an unused feature that is currently
documented as unimplemented. These patches remove the quota warning limits
and cleans up any related code. 

Comments and feedback are appreciated!

Catherine

Catherine Hoang (2):
  xfs: remove quota warning limit from struct xfs_quota_limits
  xfs: don't set warns on the id==0 dquot

 fs/xfs/xfs_qm.c          |  9 ---------
 fs/xfs/xfs_qm.h          |  5 -----
 fs/xfs/xfs_qm_syscalls.c | 19 +++++--------------
 fs/xfs/xfs_quotaops.c    |  3 ---
 fs/xfs/xfs_trans_dquot.c |  3 +--
 5 files changed, 6 insertions(+), 33 deletions(-)

-- 
2.27.0

