Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B8B6C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 01:18:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbiEEBWF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 May 2022 21:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbiEEBWE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 May 2022 21:22:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4569B54F8C
        for <linux-xfs@vger.kernel.org>; Wed,  4 May 2022 18:18:27 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 244N2M3E004338
        for <linux-xfs@vger.kernel.org>; Thu, 5 May 2022 01:18:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2021-07-09;
 bh=QvyRdfQZ+MSClB1zV1p+3EHmoXTYtE2eejHLioqnKns=;
 b=NF1wIFlrtsIof6jTdg1/83+6Mp6J9Iy2xFUD0tNBltvj1mKgU2zhxV9ay67dY5tVvLre
 HXxLmwCBpdLggQKn2+D4waplYGEEvFQ26zEBGp1aCnkgWyHQqrju7Ee1XA/vpemY9exr
 TPb/PodFrAvkLWKts09Ug2W23jrvOVN5k4au9f+Bq4vMZexHqVRsvRaBCS+ovx3FI0GC
 uKrVgjPs2TDSopGJP2bRcAvgAGmjybuuCIEeGZu9eQ2GdFLyyrBm8rBeC629ttI0r6Lv
 mZxvpTC098Gqt6q+fo/SYai0BVsjho1xuJ2/Q5wCo/9ekBtRqZ9onLAicwhpkJpO062k bw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruq0j2kr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 May 2022 01:18:26 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2451AgXO006894
        for <linux-xfs@vger.kernel.org>; Thu, 5 May 2022 01:18:25 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fus8xd1t6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 May 2022 01:18:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c5+M9fx8E8DxbpQoxxSIl1HO317NGiERSyqm7zlA4KOyTLRUr2LNR1cVKNTH9FZrTTCyjc6nNrqR3pOnrSrCoph4tH/f3YavXH6+7UBRkXl01v3IgYHHmJIVsxx28sFvfpruLrY5DlyYRxvD8R/t9Z9ySVo2X0Qo392FoT/9UmPVQhFM3zHpQOqbaWgMI86T4eEMQD/ynFluqZInBBs6mdmZzaarT5HP6HMIESXfLjF3wFzsjIE3MoaZlMJrrsfk8gzVCqPjXcNbF6AoYJ9Fx0EJdqRSeBsz9/08nRT5VMZZLpLluNovXlOgECibQfO0r1MnFuwduVx9dnyDfzlUPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QvyRdfQZ+MSClB1zV1p+3EHmoXTYtE2eejHLioqnKns=;
 b=EwopRadJ9vml5C3UJhlJ3jVbB55bUxRhw8nA7iyF1NVjkSWZQcg2mzkcf8PHDby5SvUTn8W3PV1ZTOB1rnUOyAmPUx1XMvEimrlogl5laqYsDuC/a7vUcf2VCaIMjAGVS/TeIoBJ20qGk7vNh9TIhcXExTEoUsHFELxJsLEAFVP4wU13HavGTpMKjp3DzGFpnhJcnRTjmB+vg8XTjPWHap2N8cmrwTnT6akZgco9Nce45w6+beyqtJWLDvtiogN9iGAkhW+lsQC49OkdrTMI4VYZHKh0R/liMrUbW4w4vcR0WWcx4Msvd3Oarfwk78vSNVXrvURmE4deS3Frwn0IIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QvyRdfQZ+MSClB1zV1p+3EHmoXTYtE2eejHLioqnKns=;
 b=SBELNi5lS4xLtJA2pvngWxXOXvmGQUFuDA+kk2q6RFZae1e8s/p7llRGDj+8kpT9a2MnCpkwaW7FVoAB6GrPUSnf5JWnGS5SEQvQoy4Pgh8NpQOWHQ4rBO3nthCMgmyKv5vndpcD22aly57SB8ccSOn9k2pD63/VfKcGESQNKfI=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DM6PR10MB3193.namprd10.prod.outlook.com (2603:10b6:5:1a6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Thu, 5 May
 2022 01:18:23 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0%3]) with mapi id 15.20.5206.025; Thu, 5 May 2022
 01:18:23 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 0/3] xfs: remove quota warnings
Date:   Wed,  4 May 2022 18:18:12 -0700
Message-Id: <20220505011815.20075-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0118.namprd03.prod.outlook.com
 (2603:10b6:a03:333::33) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1645d04-62b9-4969-7967-08da2e3525c4
X-MS-TrafficTypeDiagnostic: DM6PR10MB3193:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB31930CBFBA3B0F0E8E1CE16889C29@DM6PR10MB3193.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UuziAzSAbUpfsmV60WzlDrNYDoyQFsm4j8O4g7W0UK8E+RwlIL+U4xJAxb74nGptLgJxxNd+SC5O4edpJVYouZPR9iZEJ+XpkjMMQ9A2uI4VBeZdXm4eHQZTqlP2md9jdg7FK8gz0mplBofbT8GvYRkaxXR+5TL6oS79txijWpiy0Rwc0gbDY+HifGgyhoS9mmQBfs21/q1QMko8xIa7od9MSVa76Mjc8pr6pNJdTIRXScgFqgOa/KpZNv8OSp5oBrolOW7MrnU2ugp9k+6qO5HjL0GwpOQGvrre3N7lYauOLU5ot1E+GQSzTmHq0BlxzMTrOglDfWfYWaERaucs9WusUm8hScoS08GWtu7cIbYHCslrpk2e0kmrzinPX3p8/KczrRAUxNc5Gb9U4kxN7uAr4IuQP36m/HkLuXvbOneDOsXvjf3mDMRcwYiVFt8jphyIuZpYEB3/cn3GmsRHQ9vr0eQnDBi8GtKiVObrAxg6aBii4TAYsGOf/rVR6nYesIKYWTemeHEgzOUaGkr56JLCIE7MNlRxS8waAjatNaouHa9HViw/eoX2GOyGY5DTZ64v/ULGIDAXX7NWy5dgRlyf3CtzFjE/3bkVxwWo5LZeQ1PDDE91NJN9rppLGr1ZTspuevjM716ySnky68mq3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(6512007)(6666004)(44832011)(2906002)(38100700002)(86362001)(52116002)(6506007)(508600001)(316002)(5660300002)(83380400001)(1076003)(15650500001)(6486002)(2616005)(36756003)(66946007)(66556008)(66476007)(8936002)(8676002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UGlHNnNSREJuQURzOXI0bzdGbUx6MFhqTGtURWNwNk9VazEwNnBEbW1vZTNp?=
 =?utf-8?B?TzdrZUdWRjlUUE4yaUtlZHBBSjJNRnQ1enJ4ZUdtenN6TkNzRzk3Q0N3dTVQ?=
 =?utf-8?B?aHVDa0trbUxsWXRWN1Q1eS9tZVdtaHBlU3Bvd203R3ZsMFRPS3Z6Lzh1amUx?=
 =?utf-8?B?UmwzSUQ2UlRMNy9uNnlNbU40WEdpRlVQSVBxM2lxbkZxc0JINk0ycWNPQ0hF?=
 =?utf-8?B?b3NBc1lrZmpudFowSXRITGtjeGNpOUNMNlphSlk0WWlDenE4a2xxTUVyWEha?=
 =?utf-8?B?dDlJZUZJd3pjU3lyYUsvaDl5enZaODNJbzNJYVZjWVNhczcwZVV1VkZxdGVR?=
 =?utf-8?B?WUZNSi85OU9CaThJU1RwTDcrUVZzL3JCRzM3WHY0WWMvNUxtaUltVndDT3Jt?=
 =?utf-8?B?NEFUdmR6WVp1K2xCYnJjTE1sOGNUTWdkSldpSFdoQWNqTk5SemZXaXQ5UTFX?=
 =?utf-8?B?d0R0eVg5L096TG5mczZpK3ZyS2g4THhVQmhkUEhDOHFDUFh0Y3JGSHFldFo1?=
 =?utf-8?B?MElaNTJLaWk5c2c4c2kvRVgyRlJzaUxwUHdicXJjOGprN3JxdHhOeTlyOU9Y?=
 =?utf-8?B?aHAvWTBXSGxnUVVrSWl2b1p1TWdCWlo4Zm5UWEcrK20raGlUVjBncm9UKzRh?=
 =?utf-8?B?VUdCaFpsWjB6c1dMMlJmSjNsL1huMHFXZElkVnNFM1paWHJ5UHVoZFpySWRH?=
 =?utf-8?B?S1FqWFIvN0ttMEhIMFRCSDREa3hzNWxGNnNSMTlFZTFPZUJMWHVYeEFMUlVV?=
 =?utf-8?B?TXdNYVVLaGcxMGRDT3dzZENxNU53dHhxSEh6UHFIZFEva3NYNXRTZUZhSVBw?=
 =?utf-8?B?WTVHMXllVnc5S1g1M1RjQ3pialY2WmV2ZCtpdURwdUJIamU0djBtMGg0Q21S?=
 =?utf-8?B?cUV2bVpqZWJvQkpIRkFHcFo2SWlpbEt0WmFPa0owc1M3c05LdlIySHRNWE1X?=
 =?utf-8?B?dUk1UVFYWTdXeG1hd1NNRWQ5dUs1ZDV4V21QM2h2TElUSGR1KzVYZEFRb3Zl?=
 =?utf-8?B?NVVlTUVqTVdCaGFpYXl2a1g4aEsxNjJVcWthVmNuMkJXMmNCNGhZTXNDOUNn?=
 =?utf-8?B?M2srZjJsUU05a3lEcGdZWnFEN2EwMU5kTk9KZHpwemVaeVNDNVJ5TnJHSnBm?=
 =?utf-8?B?WWFCZ2VXa1MwSjJ1MVlxc3ZNcUVWdWl2NlFqbjFYeHRxeTFDcURtd0dCNFA2?=
 =?utf-8?B?ek9YeTdnNEY0Und2TUhjeDVGUHppVHcyUjBzRjhLNyszV0t3VVFENCtRdGRt?=
 =?utf-8?B?TVhBQk9WYWNqMG10Sm5WbzFWei9Bemc2OWJqT25ydVpQRGl0bFBqeEVWZXJD?=
 =?utf-8?B?ZkZHN2V5cXIvUlcyRGY5SGsvUWg0RUIzRkt5MGxya1UvN0JIVi9MQ0J2OXc0?=
 =?utf-8?B?MUpwT3MxbktoTGZDdTRleU5XU2c5QmlyMWMvVE5kSVFCNHcvUk1yL2pOQ040?=
 =?utf-8?B?VnVGNWplY3ZPZGFyM0lTQm5ubzVTd292b3E3TWlnZ2tsVTd5Y3FVOXZvcHlB?=
 =?utf-8?B?bGR1THRyS25KV2JyK2s1TjR1eUsvRkJDZ29vaThwZ29NS1k3TVNvdlV6Nncz?=
 =?utf-8?B?TGhvMEMvVUdRRkxESHowdTJaMjk1U0dYdzU1TktFNFpyTFdqRkV4dU45ckhB?=
 =?utf-8?B?bk9Wcm5ieGVXdTZ6eDBNVGdpa2VhMzdKcFpFaGtCWStSWm1iRzFnSEYrdDRo?=
 =?utf-8?B?N09jRjRTcVhUTjBnTHA1NnFZSUpXUHBSdjBTQVhDZ0RyMVBFREhUQTJGMVNE?=
 =?utf-8?B?ZVdmcTh1bG5SVWo4OTBFSDJ3MW5rME05R0YyeEF5Z21Cd0V6SmNqa3Y0ZGpC?=
 =?utf-8?B?aDZwSHE5SDk2QTgrKzF3TmpDSlFRNjZqanpJM3IvamI4Z242ZklOR1dSL2No?=
 =?utf-8?B?YjNpZzU0dHQxQVh6ZzRsd2xBTVAyTkNvLzJ6YXFhbE92QWNHaVB2STYzNHl4?=
 =?utf-8?B?TWFlNFJNdnQ1Zk42bWlkQ010eHZvUVpKOGZRNUluQjQ4TjRlc0tWMHU0c0ZO?=
 =?utf-8?B?QzZnbGowOFdxOGhnV21FSEg3K3FJVlBlczZ5N25DWDhwMjkxMUpCaHRKanZX?=
 =?utf-8?B?MHBOb3lVVkJjb2NBbFBTNm5Ed2tFRGYzNjBzNG1YOVVHSUR4VXBDR01Cd0NI?=
 =?utf-8?B?SmxXOThtMVp0ZWp1cVZkZlRJUkxLcHhVdC9kU0srei9YSUgyMjB4ZldGaFpB?=
 =?utf-8?B?M2VBUmFsR3hxbWxyRHBqbXkwdHhlcVlLb25oNG1EMUhSRVdYcFp5d0t1aUVk?=
 =?utf-8?B?NWhtQ1dzL3UrMlIyU1hhS1U3emZmY1dqSjZ3bjZxNzkxYnRaRGdjYlRrVFBn?=
 =?utf-8?B?eFpFOW1ZV1ZZSzBVOUlyNW52YTAwTDZhcWV1SVJaeTJFMGkrZ0l5WnZFa0ND?=
 =?utf-8?Q?Yq/pc2HH/nEE2WQF98RZhkJG/PZMHeZRuKQphuaAIysr2?=
X-MS-Exchange-AntiSpam-MessageData-1: SWgVWSrrLEJR2g==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1645d04-62b9-4969-7967-08da2e3525c4
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 01:18:23.0311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9apF5k9/M+TeWBdKDJNPNnthVVVNwF+X2qOBcxd2AMSnwbM9doDAFOOmp717vMCpanopCqfmFxv79LZM5PgvCg2NHR7+AIIa1PGAeMEq688=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3193
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-04_06:2022-05-04,2022-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205050007
X-Proofpoint-ORIG-GUID: 1VlIiavMi2pqXKdL3yN3075Yc6kDnIQK
X-Proofpoint-GUID: 1VlIiavMi2pqXKdL3yN3075Yc6kDnIQK
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Based on recent discussion, it seems like there is a consensus that quota
warnings should be removed from xfs.

Warnings in xfs quota is an unused feature that is currently documented as
unimplemented. These patches remove the quota warnings and cleans up any
related code.

v1->v2:
- Added patch 2 to remove warning counters
- Prevent warning fields from being set on all dquots

Future patches will also remove warnings from the VFS code, since that
seems like the logical next step.

Comments and feedback are appreciated!

Catherine

Catherine Hoang (3):
  xfs: remove quota warning limit from struct xfs_quota_limits
  xfs: remove warning counters from struct xfs_dquot_res
  xfs: don't set warns on dquots

 fs/xfs/libxfs/xfs_quota_defs.h |  1 -
 fs/xfs/xfs_dquot.c             | 15 ++++-----------
 fs/xfs/xfs_dquot.h             |  8 --------
 fs/xfs/xfs_qm.c                |  9 ---------
 fs/xfs/xfs_qm.h                |  5 -----
 fs/xfs/xfs_qm_syscalls.c       | 25 +++++--------------------
 fs/xfs/xfs_quotaops.c          |  6 +++---
 fs/xfs/xfs_trans_dquot.c       |  3 +--
 8 files changed, 13 insertions(+), 59 deletions(-)

-- 
2.27.0

