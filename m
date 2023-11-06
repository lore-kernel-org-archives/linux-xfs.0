Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A7EC4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 13:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbjKFNW0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 08:22:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232439AbjKFNWZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 08:22:25 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0BAA94
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 05:22:22 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6D1xTX029836;
        Mon, 6 Nov 2023 13:22:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=4Lbpj6Lz8OMrumW7oV5dJsgZXw7TEX6aUlKSs62B9E8=;
 b=2nrAdDZ1loyuW+p/a8ox+FDEuHAhrL5GebDRWg9qwE49/mGEfkNYy1ZANOJakZ9eWErf
 9gzQISp2JUz0KxJzR2+0wFDte4EHKI+iBcaiiQB2vhW2Em6jU7OTelJDaD8oQKzLJDo3
 Psfou9Tl88FxptBtckYLMY9kcEUrLgU3A+JnrtMSMWGPaLtuEXJmIVHPS1sArpOFpUQ6
 gmvB2Qmm9BuBdg5W6R+72xzRhp2Naq3o9rSV150S8d0rDmxKCxOETyqGiFlMESPTKG3h
 1ZizxiCKeO8ufMUdck0ZgmNz/XHUKCjodCfXrCURP2LdmQZacCU0sWf7X5aOIG8JizWY dA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5cx130tb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:22:19 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6CbcXP026802;
        Mon, 6 Nov 2023 13:22:18 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd53aun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:22:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VFk+R2Kxw211WTIr/GsxRShtYlHAgLzG2Ua0eNDMrDmRH37etHdgX7GBF9aD0MmUo3+0qFhxiP3ycoRz53kgw9HY4EqYaPNVxfZXwYWVdeulm3Kg4pogi1i97rbcEOPlySwfH9pZJ9kxeQGqF+eefpy+kdZx9lA4fnLRJw4PCEEHTVFxKUAAIOgpQTjObfZiHWrt4uGMvqjYRDsCOpPw6UkR8UvM4C3yYv8Rp95XwsZ53RGwmP0FLEZMEAet82B77nbVCGWUKjB7lGWthe4C8VVp/e/JZabAT6AFeoXMCO2Xoo/vLPlL+Qta3FkyzZxb3DJiBMLbGhSuYEf5D0dnzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Lbpj6Lz8OMrumW7oV5dJsgZXw7TEX6aUlKSs62B9E8=;
 b=gx7Gx08heC+cXs8A2sPXOYlP8o054xoiRpU9ha9n1Jerrh6bs9NwvYjYNPYmwSz1DGc0sTnOdyT9zB9MvllaQpQoMjA9JCfiasr8rXebgcnKhOLGobgNxz2ZNdUpda+kHpgA9mKwYNwGxxOp31bLF5K2pN3NNPaRoZpk7a0d1/OIGQ42NhrRTSro1uY8CQZps14bwmC8Sf1Q62Ph0GtIvhmczhGkpWbkWQkN6ZXq6U3aTUCLv4lLGqk8DZ0bQpNO0lHOMoHYPZV4SDYtBlxyqNuOvG3ca4Xc3G8W7DpzolDcj5JgF/tbXjfUDQqhB4nkkYscOnNgm1OOLKG1v3ZEWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Lbpj6Lz8OMrumW7oV5dJsgZXw7TEX6aUlKSs62B9E8=;
 b=VtcY+hPYipmGXnq5Icv3FgU110wp5vlooGJa3qdTw7aHV8ldfk3VwvIE5Bm501k5jd+O7G7W9Hc5XW6s1SlxOZxamNvlYenjGoXKh9GFGyA8LZjJCUefDKZadaPIaHP5kWt2PEPu3RFou6NWRy89Z+F4cOlZokbCsePwib73BkY=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by DM4PR10MB6158.namprd10.prod.outlook.com (2603:10b6:8:b8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Mon, 6 Nov
 2023 13:22:15 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 13:22:15 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V1 0/2] xfsdocs: Describe Metadump V2's ondisk format structure
Date:   Mon,  6 Nov 2023 18:51:56 +0530
Message-Id: <20231106132158.183376-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0018.jpnprd01.prod.outlook.com (2603:1096:404::30)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DM4PR10MB6158:EE_
X-MS-Office365-Filtering-Correlation-Id: 81b762b6-c1d0-4f2d-293e-08dbdecb64e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rUxTYkDKQ9Sa6XSqQLr/XBj9BKJIDJxqiLQy4sPL2/dX1IXMgQzaFjKigYEBeIdo6t/gXmt9Btx9PKpt8yn2Ni7FaCcbPEie1C+21NVHLHweDz1iO04dMZd2SgwzBjsvCENXExiv7DQegUuNihub1/dT98hb03rw53PmSISzOc39/cUvIV1mzqAzb07jXsZWDxlkBfD+ib+S8wes0MVZx9yxsIP7weSkOWX0dUsUSi69yybyW8HuQexLMRgtQkKPnUUZjDJ+4GjWDSATAj/sVj9P0Y8l4Vb7pyBGAZcW8pEpmwsSEYtqdCg+J8CtY7XcjYeBvlX40jL2JrF5MWnoOGXvcIi2GytHGy0BeiXAgwc+zwkoc4Z38W9mo+QBYVNOU3QkrkKn17zAXd6LekI5i2bYvfjC++eoRcevs1QOB7/xquFGhoVcU+bexJm8vaelYOZqo20FrhFNXFSLLikHw+P1+E/PbX3SneSZS0yTlGg6TQc7K5M2YF36FviabPP2AFKtA+9DCexWKnRovQnDwe5jCa+nSQewD7HE5slGEqea3BK5jMLK2yvhQx5c2Ssp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(376002)(366004)(346002)(39860400002)(230922051799003)(1800799009)(64100799003)(186009)(451199024)(38100700002)(5660300002)(41300700001)(4744005)(2906002)(86362001)(36756003)(478600001)(83380400001)(6512007)(66946007)(26005)(2616005)(1076003)(316002)(6916009)(66476007)(66556008)(6486002)(6666004)(6506007)(8936002)(4326008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UscgHNewik7UvRCY/Gwv4fkLqQ2K/qHFkezoy6Wp6rAyv7uED92Zewyk+W74?=
 =?us-ascii?Q?vJ1dCvSNW3RhcuRmL9wTNx7eIFaEWyFwr0aSvvVzL8ROQrbJBUmhbeMMJWnE?=
 =?us-ascii?Q?/arGU4EUW+UlKFDrzs/P0pIulwTwhKn7+DZAROTvyHv/St7yDPc0XAts53TK?=
 =?us-ascii?Q?9LmrAm+/vY40NaJWrHM/s83mgpQ1v0YE2pXbEdbZUGA60vOU5Gr2A5UhwKJ7?=
 =?us-ascii?Q?Eh21qg+Q4/biIAoPtPwzqyGpe2oW6lZSX674bq64pfRkkF6J9Rc+ucE8MMl8?=
 =?us-ascii?Q?C1p2FZQ+tM3TqA6jYa6PVZv3smfg0ouZYhIs0I/wnbFUl8xZ91hqR1BZFWLx?=
 =?us-ascii?Q?T2Vo8LDOjJhwVZvqNg2ycup+LttBuTG0uqlLYKO8mu6qLCqIWk0VCsR0cZJe?=
 =?us-ascii?Q?FmnYekF2xrzMZbwM+OA8iKaEvVJmS9Ygk8uJpeQgydEufc6zfqrYw6dyUTFS?=
 =?us-ascii?Q?Drg5VtMf3i5D4qbi+FqLVF/toG6hYhBM4ni0ITVLZFTW1pnHrpjEnz3eGdp8?=
 =?us-ascii?Q?wRf/iDPX6jskSlqDfkhkjzzXPye1jXT0O0OnvS5jRJedQIOkQB2DPSi80Ex0?=
 =?us-ascii?Q?ufqgC/+HLbR3QxCiJGptGzBGYFJydJIqA20Pg0phH/w78Cm3CdKLrf3JJ2xk?=
 =?us-ascii?Q?Q28ELfMqY6FJHwdiX+eI6jryGk61usHgCWvBTODUet0rKCav2xR4qP+S3aFF?=
 =?us-ascii?Q?4ztQP51ZdNWAR7rpDFPF4T326+IAD8JsyFnDV90Q8KAOvSshk0Hr/twHGPW7?=
 =?us-ascii?Q?Dr6tGpwGGDok+LzZmMzwfaPuwkY9I48e3SZVavoFeTx5YOnwsn17PhNdMQFY?=
 =?us-ascii?Q?w7zVcYOdB8vuGoFfmVOfyGKHgsd3UuEOeTPSH3AHzcALlM0lgf3k0lLzSpFs?=
 =?us-ascii?Q?b8sasO23IxK9lYNtt6QdXCCSuTN5PTSyqLLTuNua981aZwE30KezxTpMj1wQ?=
 =?us-ascii?Q?q3I0ywBQ5t/ZTuLIBUYfUH0lDZAWPH6EroJFVtsXlAMPQzJomsudAc56+0tv?=
 =?us-ascii?Q?X6EKURToHUdxs28TC/WxikEItX80ytc14kPl4n3iyipFMy1HXVPgsH8/NYgn?=
 =?us-ascii?Q?Cu+ZU/aE4k+U2+P+AtInOZNj9uMfm9Lix6FaVN/vX20wfaIcVDSwdykxd7hu?=
 =?us-ascii?Q?9bWWOiDImtq6r4/mVK/iOP6C12355jSY8VOETIw7bZzerWDgQKStca67NC8U?=
 =?us-ascii?Q?q5YbggVkk0l2ckeFYuOk9xZH+wmWvLn0g4HL//fpdyCwo7QqpStZhAuGBqME?=
 =?us-ascii?Q?D8oP863c3x9WSk3xqpgx+nmYcZzRhDNwG5ONa8mIqnZtP7Ysnej7B0R6p0pi?=
 =?us-ascii?Q?N1Z9qul1zmLBRU3OvV6OZBbYeyD1h5PjFJsq2RYF5rGQT9N9WC65A4scxHYW?=
 =?us-ascii?Q?gqOqYhqIzz44olJJDEr6U5XkutOFvG29KiT+AnLbz51T7Clls88gtXBwiKb6?=
 =?us-ascii?Q?pNF3HKy/5/t4zWyoyc5LTRb2Xd8Gz82NGbjW8fQ0bBRQoi1gkmOQSohOeLZc?=
 =?us-ascii?Q?vPW9T80KJk4YjGoVUWvFPfQFV4kCPWRE/0JR6W2CCkmOWCjHGSrZJ/T9OjzP?=
 =?us-ascii?Q?eBReEQ/ZhCuXENc49OBBzZu2xgGXwF7gG8q7L5aKot7oLXkRFGNxx/arupY4?=
 =?us-ascii?Q?uA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: GqKvnw4oJl6CRBq8PxHKrHOPFczBtsR43Q+Okb2hWfCYrRVxToxDsyvN+36D2PDk7H/Rm7uKsHcukKThd4JUkpyxtvlJWqTuw5dQrdGqsc9LivvnwGo4pOr3YQyev4/a85i4fAT+kx8VBehmpT2Czi2ag/o1uXMGzSqrx3fvPK0a89zyKeh/0dje9JrCy13yIWFkQjaQ9nWbHGbtbk/dkeWz5pe0NX/z6gJWDQxzdmy65+9OUDYFzFUdKedSQOqIeGeUYtBPqbCovnPJ7LOHyahDB9H/u088wuCtPQo5YwKJdJfOLQ2WIye+rixwL+HsXIpb8Lb2qsDPTgFYJpg7XA7nxFk5DG+/kIn11CG0lASPaNqAop3norZrxP5EhzYkzynzTBwC6WqWCkSlLIyKyg3t33oDlM5q8C1E3z+D1I5RHHp0n0rcgOOndkoqF/qdqpVjRtZuuokD7yXcnJSgkQIVpUTMKNcG/TlSvJTmrn8XK+dYZwyyZP8+SwIUTa/IwOZE2rncD+BAxUAJeIWaEygADxeD2TT/MOcE3k0S+fBErALP/MsdIDwhyLrt09CiXWS2t2lC0cPi26XxovyxuHIBImYNZq6ohcI8bZxD281loW7/gX0F6/zrUz3BmLbOEm7aRfV6abWsb6F1ykMr4Qjzq+NsQZ+IPK+RlERx8a0Ms681DR/o5XUYrm6b9wW7pyvjtdqMU/DM3ES2pgNREpshmN1a/wE2+l85FAtlGY9qhnoe3/gNekpct58gPQD+yIcQ8/vHoFWewhKzbQyHYFkmCyTPOY6lgz4f9uYr8+0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81b762b6-c1d0-4f2d-293e-08dbdecb64e1
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 13:22:15.6275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7qswknZ7U6VUw2cueA1Iqmh/0VKzaNCMt/TpRcKAqB+8o979ofMTm6FZjIRZA2Ar0HnKvGohSklz2kBuPMyf9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6158
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=870 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311060108
X-Proofpoint-GUID: z1pr5yyrRgIX_Xk4khAq34BiQuT9XghA
X-Proofpoint-ORIG-GUID: z1pr5yyrRgIX_Xk4khAq34BiQuT9XghA
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset adds description for the newly introduced Metadump V2's
ondisk format structure. It also describes each of the flags stored in
Metadump V1's mb_info field.

Chandan Babu R (2):
  metadump.asciidoc: Add description for version v1's mb_info field
  metadump.asciidoc: Add description for metadump v2 ondisk format

 .../metadump.asciidoc                         | 98 ++++++++++++++++++-
 1 file changed, 94 insertions(+), 4 deletions(-)

-- 
2.39.1

