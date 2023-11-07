Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F8FCC4167B
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 07:07:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbjKGHHi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 02:07:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjKGHHi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 02:07:38 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CF5FC
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 23:07:34 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A72NmhX031937
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:07:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=/zLW2OuXkIu4n2bdJ+F6cthRlUyuBMkvEy7zzlQ0EJE=;
 b=sZaAmAtxVY6LAregRuantg5esJr5wzMxEtBgpoNX/uzyMCtTKGJbA7vjs0L3ujNCMctW
 mA9Bc7X21fNW0SSmqJ+Q1Dn60/3Ibnvgby2eGzR+zwHM1QHeejdpnT8Y2a6kj0wsSF8A
 AvjR+NcT7J4mZ9VG4GYpHEJjzEBi0FGjEon0HZ9eNvq+NKjvVpOfAjfEY0epjn7tvMF4
 WJOsSbNkWKUTBsObkbzYhD78J7CubIoIhlFxL7fUwu7oRWr6c9kkmOdnCjfiAxS8Z1kd
 qUimNPE3yt2C7C3U9yrJVSKnjrcxJAY0wQ3NGpDpnrWAtOR9mzF5CeGlflmzvYKiiIwE Hg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u679tm2hv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:07:33 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7753mn023669
        for <linux-xfs@vger.kernel.org>; Tue, 7 Nov 2023 07:07:32 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd63bc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 07 Nov 2023 07:07:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PD6a1e2oYF/wjTcsb4HSLGN5fw3xBkHPfwqpUKpgsJ0h71LDofQWrrnBux4mIdcVHZ9wtYmKG+1uGKg8pl/zFZ1g2FvjIfSeY//e3TZ7YvARdP0sUnqAvDDzg9jYJG6FhjQjM0q4aC90NfwKGCVoFOsesmfHTBWd3745Ehp8p/Vyfk6d82u5FV7f5I73FEO5uj+6MC6itQ9Gf8NxNRbIXpKMGLWGY89cwdsJ71Zonjfrdz9TTi/4rhBvjEzKy/6th6U7A/9mz6vBPA8AilWlHvCUdNt95fY2N6bfMDWU7vxtjYLuu0cT6ANjSnI2X63iSeiwJjZzEHu7q18ZBuM0lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/zLW2OuXkIu4n2bdJ+F6cthRlUyuBMkvEy7zzlQ0EJE=;
 b=bw7PMwazd5bD8muF4//zP8ZlM0K32bIJOJQCBdoDe2kEVAwHa16ROvg7eqs4bcqWrGrkmtbSw1IVLAyWqua6k3prQmlexdcCmcrK0JxfwStupkVa8eolXnWOBbJ+1wZEVwwBkVbjeNpUBDUrRG5iBNebpdtNtc/bP5IVwrzgZy9x/1cnG/sfc8x0cIkrOFN4EIxSP0dbr9QXa38pbkMa2v43dWS+ZgTbEkN60g2zv15oeJR1h+pa77jqE0zs9io+7yNN+Z8zMyf/9xAXo2C2jrL3I7vdH1H7J1wHP5MB2a4SN2i52NGWxRyko6wQs2WzAtXd++a3FzjRHrNDiYoHPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/zLW2OuXkIu4n2bdJ+F6cthRlUyuBMkvEy7zzlQ0EJE=;
 b=hv9ec4IYlKeCsKaIaV1/L9n75d1v8Y1psE9H1h28O4xyR+svYeAPioUVb06V0s7B83HMZKgjPNP79P+HtVZlXic2HMzEFI3vs2qGw3c9WjcJIDKw1z58Kh2iSS+U1FP4Xv2ve/x0JGwKcVyUe1cTJuzY+l0SXvyqukmzW6hKhBM=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by IA1PR10MB7263.namprd10.prod.outlook.com (2603:10b6:208:3f5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.29; Tue, 7 Nov
 2023 07:07:30 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 07:07:29 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V5 00/21] Metadump v2
Date:   Tue,  7 Nov 2023 12:37:01 +0530
Message-Id: <20231107070722.748636-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0059.apcprd02.prod.outlook.com
 (2603:1096:4:54::23) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|IA1PR10MB7263:EE_
X-MS-Office365-Filtering-Correlation-Id: eca81699-751e-44bf-4f30-08dbdf60349a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dVOnxH0TTgbfgFrbQslbq0l/SVz7a+7M1ofMQfVYgaS/R9BC+9J0g5wtXKMHkNrRsCwDO93UliJE8jTF1MLimpyfThap7T6cNeFt1Rw7ncNiQJUvbkLrBSkKNgFkpPYCikv0Ujdj0VPF4z7evAVYGXtS+SPPqMzvUajk9CUSebObqkSsbYZFvtP4Zw8gjuNMPm1xBVP9n+W7bYvtbeg1mHodHz6L08jDfDtaZdRMWJni4d1ey2/qzoTph9hd8vnIqCq1yUcka9r0DpUCcJlnHKP1i3svIRUdSUAMGzjF7uoNJ6XHC3/9gMceO1NVxeKjVqLSV/2+sbvEgpKlSoskclDWxmrlqWuBfXo0HacdV0qItiovqZ6cnlZ1VbL6LWc4aobIe4WTfCvwYooqJ8qIg4856Wfhx8AHO1SZnUZVyTrwI4JI71AYQ9y1lsQ6ZmlJuJW2JeZpU3ksVPG9Xni4O5iedba0pNHQuOzOld3peDmmLWzErf8ee5YfEsmesz4gfk0rvUaijX8fdPFY+9+0QdAKuMh4gU71tTpPgGV4U2/zvz4WQ6qNCoHuUuHjbWjS+Wl/zIZuO+1lqLsU95cc5yC/XZ4xd37RKhq4OKSLw7NQSuoilip4mO/IdUz5M1NDID9Hokb35BCKNQWKseA4Una7WWpuq3pWePSL2dy0X5w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(346002)(396003)(366004)(136003)(230273577357003)(230173577357003)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(26005)(1076003)(38100700002)(83380400001)(5660300002)(2616005)(966005)(6486002)(6506007)(6666004)(478600001)(6512007)(36756003)(316002)(6916009)(66946007)(66476007)(66556008)(8936002)(8676002)(86362001)(41300700001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sw7IB3eBdWJp1zh6tOiMpaQW7Osq1aF5cd9Ix/ARxQSuR3ebB7zbLzgjc7Ky?=
 =?us-ascii?Q?eksJkNdYZnytVwvjM8yM/fej5xiShMHrAjJ8BDdQEasZ51TWtIdcKbHIOol1?=
 =?us-ascii?Q?czUQnC4Y36qTAMkHEdqG5n0diz4uCtxZdyT9Tu6VK2PpAnxFfaWtZYpiSAg0?=
 =?us-ascii?Q?14ob3QdhtnIPxTv7W1Vzib9e12AbY5LeQe1npi/esucbsTNrvzP2Ygxjw8bz?=
 =?us-ascii?Q?4HlBZaTLzEi/eBmcg3Zm/8LyyrxLZOZPwYTmTKBXsb3Loh+0/hRrC65nPcBn?=
 =?us-ascii?Q?tnaevRm7K4WOIBuB4qDGmRYbAG1jhH/y+IWn7LcpQBh/JswtpKGJYdlKLZm9?=
 =?us-ascii?Q?Jmg2hLGcHfVaHs4TFG1mGPItTLL1Yy4Zx2Jea8XPsjqX2zeu0rT8kUO8zv9p?=
 =?us-ascii?Q?JtiIAoctLCDhvWf2oIXnFc4v3r6M9Yw9bCmj0jSg0N1GWGaufo9p52WDjbEk?=
 =?us-ascii?Q?//GDJrrtVllFhwCDjS4aaxR0r4mPPpUKp/7ZiHsBbZUGrIcNeuUQJTK9Nbuy?=
 =?us-ascii?Q?1jimtac/fhBFiITl7aqNU5ywld8t18A2YG9Bd/hgF3OddtYip4IJJb8lSbkN?=
 =?us-ascii?Q?8ReZ6wMhvPI49rmxcyxeS6XGoNTHcEwLfdW/wucBvOTEKmD1XE9xBi22+j2N?=
 =?us-ascii?Q?xGlyMDIB3xvIhg0O/CdpklHg/XUuz5MXWCTFAZUtLGZjNc/FxmT9f137i0re?=
 =?us-ascii?Q?eqaH9oGSJyXYvTk35uxVybmwOhVB+CGFzrwtHIrHAinuhTkuOkwI39mjuzE5?=
 =?us-ascii?Q?BIZ8ZY5w0dy18iYamuZMnXa4ArVDHd3IDEWKEyT/5UWZ6LRVIJ6qkXVAnRvH?=
 =?us-ascii?Q?1H99s28uKxgGDoQ6zIvx1q0rgmrr+1jK6KX7kTIakWY9NTSS2pGWSGmkRtGt?=
 =?us-ascii?Q?h3JBwlKJAi1lD9WWZP7l0VIXuUSw4vDxXRuHxPXdtrR2ZuyhelmbtpF3LO+q?=
 =?us-ascii?Q?t1hGTxDEpEC4Jy5kXPCGgw8ERHdcCV62p4Js6LLOBVYWA1UE48Tyb7YfqxR1?=
 =?us-ascii?Q?N3ZTSDESPPT3fI97WrLz4Da010YamRO/HMQPqkBc0OpEhIIOlj7BeBKsNt5F?=
 =?us-ascii?Q?Fkl6R6KmaUiuiKAYm8xdZAJMogyw2UZ+6K+Vemzx0mOtZmtKh+tibybawuno?=
 =?us-ascii?Q?U1X7bUvMWUV8maOYzRoJGRzEVNdKaVsTaJn+kUaB8qE+p7mVM9WbCUmoLa2j?=
 =?us-ascii?Q?p01qI9KPrnPgWspZpUcIWO7ByGZzTJLO0dCv8uhx0ZQ/nano8xObtLbHV4Uz?=
 =?us-ascii?Q?0r1hdTaBDi9UoXPmT4bMSk4aysZSYNs3RcXP2z3wl3SbXntUSqFL398Dp4cX?=
 =?us-ascii?Q?uqS1hr84xZgcTq2ros4XR179V1evxtCL8PQI5Vn+x3zE62cIn9VrBIVoOiqh?=
 =?us-ascii?Q?lKgzZOhRpx9XncP2W455ZOvfjs3iZMrdknIIdHG90F8PYXUkIBLv0OmGa7g0?=
 =?us-ascii?Q?iY4211hILTyC6mpi2KCd2+Giyi754ASZVD4MeZJLP1zTCN4oGdFGHNfFCOw2?=
 =?us-ascii?Q?3G60rS/yyMtkRo66Caw0Bf2iEPc7jn634oocLuNmWQvvFVHRZv7L74BWI3sS?=
 =?us-ascii?Q?RaP4r7UgjmFw1gpBzCfatrla0nKEmm0b0BEAu2I4ZebDEljQtsJMZpdqd1RH?=
 =?us-ascii?Q?Lw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ZZ3y5lkd3IM8Xq6H8y0Rysb7jNVsSt71tDcLcF0/Y5aplDyLk7S0DnAbw6Ms+6E6vAsk9jhdfcZ7iWfp0JHufymDZFMzNd+2yGY12938jUu9FI5pL1wH8MR+SbGoJlBDJuS/vCi0Ij65yrRw6qurDzSg8Up6lrV/LE/dUJFWAbMPu9lEFHupdDL4rvc/5txaWKL7GP0V7Zu0twOZoD7uo1F+M199xhgBpZRUThFjkeT+7+zYpWXzfH2/o5vMtjypNVipOabGp3WcmK4HmXnwSxGRccqTXBY6fvEb0r1RNO63uvsmfRTZP+Yep+kV6n7CqNvyoDBJet3IZEGFs1Pg1CH19sjZPHGTRbsiEZB91x5I0FTgOsAJ7G3h4U5hMeYYETulBeNuks1tmD3GeCfFiFUEa5NVBMAiSabJTjdKFMiuU5naVMRUpV60+A2oCPvRmza0Ig+HT3b+FhzV1fQqPTmO7DoR3eyIa4xBAEptBGDVS8/WentGBIWE/aZE6Y1ToO7nR5XNoKIHeJ8FDu7ezlAZTqIjDYAep0gg31mTzkaMZ9yynlVsVWhHBkFDWeNBhzLHqtpJWC63KPIIk/6tM/+WQSYrqGkqvff9OVpCl3FUUvV4Tetdlwv4BFzDcbY9g4DNaUJr3Q5T6IPRDpbydOCJtxRRN5WVzrARhhVF8SMwoVxghS3Yh7ccrr40fnmfzswLgyEcAQNBli5dGDn5bjtwvC4+v8peKk5OJG0GFxNoXwPxcDEIKW6wz7Jqn7OL3jw952TTqHFpnGe+NodQBg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eca81699-751e-44bf-4f30-08dbdf60349a
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 07:07:29.8409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b4EqxP1hhdCHoDl2QbD2r+zXyTPIfkc7LXeDdVNphk1mvlKCR2bmXtDjIVMR5y1MsSpLsshfpL92g0NztP8KzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7263
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_15,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311070057
X-Proofpoint-ORIG-GUID: lc_Gjv4KVrc5hx9HsvyjGAvKwI-b1TXC
X-Proofpoint-GUID: lc_Gjv4KVrc5hx9HsvyjGAvKwI-b1TXC
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patch series extends metadump/mdrestore tools to be able to dump
and restore contents of an external log device. It also adds the
ability to copy larger blocks (e.g. 4096 bytes instead of 512 bytes)
into the metadump file. These objectives are accomplished by
introducing a new metadump file format.

I have tested the patchset by extending metadump/mdrestore tests in
fstests to cover the newly introduced metadump v2 format. The tests
can be found at
https://github.com/chandanr/xfstests/commits/metadump-v2.

The patch series can also be obtained from
https://github.com/chandanr/xfsprogs-dev/commits/metadump-v2.

Changelog:
V4 -> V5:
  1. Fix mismatch of my name/email in Author and Signed-off-by fields
     in the following patches,
     - mdrestore: Replace metadump header pointer argument with a union pointer
     - mdrestore: Introduce mdrestore v1 operations
  2. Include all RVBs.

V3 -> V4:
  1. Rename XFS_MD2_INCOMPAT_* flags to XFS_MD2_COMPAT_*.
  2. Verify xmh_incompat_flags and xmh_reserved fields after reading
     the metadump header from disk.
  3. Fix coding style problems.
  
V2 -> V3:
  1. Document the meanings of metadump v2's ondisk flags.
  2. Rename metadump_ops->end_write() to metadump_ops->finish_dump().
  3. Pass a pointer to the newly introduced "union mdrestore_headers"
     to callbacks in "struct mdrestore_ops" instead of a pointer to
     "void".
  4. Use set_log_cur() only when metadump has to be read from an
     external log device.
  5. Verify that primary superblock read from metadump file was indeed
     read from the data device.
  6. Fix indentation issues.

V1 -> V2:
  1. Introduce the new incompat flag XFS_MD2_INCOMPAT_EXTERNALLOG to
     indicate that the metadump file contains data obtained from an
     external log.
  2. Interpret bits 54 and 55 of xfs_meta_extent.xme_addr as a counter
     such that 00 maps to the data device and 01 maps to the log
     device.
  3. Define the new function set_log_cur() to read from
     internal/external log device. This allows us to continue using
     TYP_LOG to read from both internal and external log.
  4. In order to support reading metadump from a pipe, mdrestore now
     reads the first four bytes of the header to determine the
     metadump version rather than reading the entire header in a
     single call to fread().
  5. Add an ASCII diagram to describe metadump v2's ondisk layout in
     xfs_metadump.h.
  6. Update metadump's man page to indicate that metadump in v2 format
     is generated by default if the filesystem has an external log and
     the metadump version to use is not explicitly mentioned on the
     command line.
  7. Remove '_metadump' suffix from function pointer names in "struct
     metadump_ops".
  8. Use xfs_daddr_t type for declaring variables containing disk
     offset value.
  9. Use bool type rather than int for variables holding a boolean
     value.
  11. Remove unnecessary whitespace.

Chandan Babu R (21):
  metadump: Use boolean values true/false instead of 1/0
  mdrestore: Fix logic used to check if target device is large enough
  metadump: Declare boolean variables with bool type
  metadump: Define and use struct metadump
  metadump: Add initialization and release functions
  metadump: Postpone invocation of init_metadump()
  metadump: Introduce struct metadump_ops
  metadump: Introduce metadump v1 operations
  metadump: Rename XFS_MD_MAGIC to XFS_MD_MAGIC_V1
  metadump: Define metadump v2 ondisk format structures and macros
  metadump: Define metadump ops for v2 format
  xfs_db: Add support to read from external log device
  mdrestore: Declare boolean variables with bool type
  mdrestore: Define and use struct mdrestore
  mdrestore: Detect metadump v1 magic before reading the header
  mdrestore: Add open_device(), read_header() and show_info() functions
  mdrestore: Replace metadump header pointer argument with a union
    pointer
  mdrestore: Introduce mdrestore v1 operations
  mdrestore: Extract target device size verification into a function
  mdrestore: Define mdrestore ops for v2 format
  mdrestore: Add support for passing log device as an argument

 db/io.c                   |  56 ++-
 db/io.h                   |   2 +
 db/metadump.c             | 777 ++++++++++++++++++++++++--------------
 db/xfs_metadump.sh        |   3 +-
 include/xfs_metadump.h    |  70 +++-
 man/man8/xfs_mdrestore.8  |   8 +
 man/man8/xfs_metadump.8   |  14 +
 mdrestore/xfs_mdrestore.c | 503 ++++++++++++++++++------
 8 files changed, 1020 insertions(+), 413 deletions(-)

-- 
2.39.1

