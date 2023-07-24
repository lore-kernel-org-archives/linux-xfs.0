Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00AF1EB64DD
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jul 2023 04:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjGXEgZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 00:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjGXEgY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 00:36:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B941A1
        for <linux-xfs@vger.kernel.org>; Sun, 23 Jul 2023 21:36:23 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36NKlNkA003163;
        Mon, 24 Jul 2023 04:36:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=aVMDePUZsxWVIDV4lQGpgT1tAWXv8MT1BrIeu0+z9XE=;
 b=qMQA5orDlwiY/IKO8rYpfcfNytT/s4my8IQFtGJJNVADaFZ8MwmFV5/5rOYeZHGFBlfh
 tMBd8V8JrzwO3dhu7yF0uPBy33rSov5eD9yI465tmJObs0j3RI24ZTY2LZYC1InKKEkB
 G7B0Prl2ONfMSoQtM0fhyvb8pOp71TrCY0V7RZjJojsUxCPFksozxmFSLzROtF48TAU4
 r5UrJnYtXEMC0Q9YwjLuk4b7Zxt1H/YGRAkHcRtCr+6flzTzufNtGdJo3RGgEiPnlNr7
 60fOTWQ049Xy3x/WlpcBmEeA9ZlkddMZU3VjnAX/VVh2HXIwXnxHL+0XaOSM75ZTgNFc Xg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s070asteu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:36:20 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36O0lISD029039;
        Mon, 24 Jul 2023 04:36:18 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j96hpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 04:36:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZVrsbJiEmDWD9Wpb/3jJF+Swv2yDheWnys617H5ekuVrRsgv+FYsdcEsl+rrkdnX3CNchj8noOsNEhe1rWhnQXT0PDcTxRHxLtc7WkthZfsg0MCFnlXkJJNaxyJ6VK4tqe5NbuEX6ve6oYoDCNswzZ0dqCiqGmRlgoVrOEQcgWu6EIHnc/t9clb35SV7xng7+I8PzovGdJptQ6cNFiwBgjackPXwX0D4QC9N2Np9dm90mgWLi3qwjRZsv5odSCUWGZsakJUDEuuLNPK7rDQRpakw+FPbav97NRyoW+U2cdN+wDK9isa5RW8VKkRwrKPqR+7YMPC8qp3+XRRwq7E63A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aVMDePUZsxWVIDV4lQGpgT1tAWXv8MT1BrIeu0+z9XE=;
 b=W4J94Y9bdpi2JmIHIzgyhKT7FpXm6mDCSSf0ZhnP5uLIDRQbrmO7IdNzp44WAxIyTfZDaeCM1mKZEyxJsb8mvWUgzWDESWwdP5WNarfaYomWZOmb93ixQlMr4e+/6/YdIp0ZEVsU8dKj3mMfaZIg8wrKbAQpi8p33sQuTh9h1g1G2oYBP2S5ygNnn/E1GOLoLlQGg0w2cxYldT1WTNbsWZ7Lm9bmBfJH8gYBBD/EZMTHHL1MhKSTDl5KfDTpcypTUCoJNaQ7j4g8++M5FFd0yYHh23LThY1GygNvxdVS+IfnWoIchWO08+X25YXGga/BGVMdkl4fjMhcPEn0raWDKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aVMDePUZsxWVIDV4lQGpgT1tAWXv8MT1BrIeu0+z9XE=;
 b=qj6sFpEWFvLvJ2LApwvpD21aRLmqWR2rR20HWpJ6TSA+yyUjxu2y8Q8G9NwVJQZX5X7AKHRTNdfiIAPV693VySTHJWG6+eNZzPTjNLw0Eg+ZAD6bA6WzWNYgWP9gryY8aNeUphP4UcIT/MSEa4ANOWhvQaYmXxiBYkkbWPrFozA=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by PH0PR10MB4774.namprd10.prod.outlook.com (2603:10b6:510:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 04:36:16 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6609.031; Mon, 24 Jul 2023
 04:36:16 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V3 00/23] Metadump v2
Date:   Mon, 24 Jul 2023 10:05:04 +0530
Message-Id: <20230724043527.238600-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR03CA0022.apcprd03.prod.outlook.com
 (2603:1096:404:14::34) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4774:EE_
X-MS-Office365-Filtering-Correlation-Id: d767d427-c64c-4629-822f-08db8bff84c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 40vIKRB9zNQXQIA0tzUhtpOXcfrjG3hokf4/V2AM8pz49CpebDne0mDinydgosfKmhA/iw+PwRnxIbsy3jYa6H04oqjCL4yESWs5sixIWUUcIqNSFjuPqUXB0BZPh3FEMYup5wQ8hptCenyHDcPdwHrNIrBeaGvHp64rvuQuRX1+IJpfKUCNSIrIZB4qe2jnAYAufID6AL2uTm4TSf+n89F5A+g5GXOMhwlqCrKOVE7R7ufxHEsn2Xbu4pVVhUmlh7njJR62SSYiybMuhy+PAo8ZEJC11i1hJUSLZ3r8Vi1VM/5mQACQCdLKEk3YBmCSJyMWF6EL881cKGspKzqmn0AAcGhJ88DJ7AzV7Gv7nrg590tvCojXIpqP1pDAp5k2iks1s1Qw8oBa5a63grx7ozdTL7efnvFEin4hdtaRTDbGL71tP5BezdIYeSA+Ed0V0XFM0MmF29zq/V5bdtgFSQUokdVda9u4ENH1SKTODxxo/WpHL9XtQ9m/kuIz59arv8Ed6V7/6gCZ5B7x/KgQYu3lyCpl+rUlbq1H0n9yS7U825JwpQT1vbpa8NgBI6TOPkY4+tGRED0GfIeJL13EJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199021)(2906002)(66946007)(66556008)(66476007)(4326008)(6916009)(6486002)(6666004)(478600001)(86362001)(6512007)(966005)(83380400001)(36756003)(186003)(2616005)(26005)(1076003)(6506007)(38100700002)(41300700001)(8936002)(8676002)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f1EJgF78VSs3nVgfAuX09mkD79Fs34D/FjwExaUHAaoYKz3k6zX9vo2h9U/V?=
 =?us-ascii?Q?/7TVNa1nG6rlaYH6CmKPPS9s/5vpRtC66JExCnDqsOhEh9WlLNGkd/ockJ3y?=
 =?us-ascii?Q?X9/z4Q4om5lDRgqlBGkSPerWJTxObO9EMjCkdHrpi6OEU3X3K2PRGJceaPWB?=
 =?us-ascii?Q?/hhFk6vmccoUoV3tO+GA0DvlZqGltwIiWviQnkTAmqBPVdf2Lgu3PIZc365Z?=
 =?us-ascii?Q?v+ZRjMubD6OGm3KsxTjOXPrCritQU4M9li6oW+upWkTkebLSnfZW+u2f3fFG?=
 =?us-ascii?Q?uzK6/3WcQcUHmn7VgPfprXhdRLbX5fF4KjJaELKvZxTHzNTkwyYesJ0mbESH?=
 =?us-ascii?Q?TFvZyyQImqCf5y6C/StuMkYsujLr7oMV05vGrp/5xEJhMV0yEprKGTWcD0Hk?=
 =?us-ascii?Q?mahiSjzN172ayqQk8fGaHrb57HCsdZMz2ihchVbKzT870qQqOCsvppeOZedE?=
 =?us-ascii?Q?ZtVPbIU6x8fU5TmlQ562fZXDWJ8nSgP20CLLaSzTF2NyHcU9vI+elYBI0I74?=
 =?us-ascii?Q?ef6swuZxMoa/1gMyiI2TGMPIi3Qw9efecFSSm3TfLhjFDGXBaPvcayJqLxJu?=
 =?us-ascii?Q?dxhjZVRjmHtD4CyE9PGJvsZfFpIC/om0D3LNIdL/uMHee9SABN3ycdf9Ev44?=
 =?us-ascii?Q?Vdy/uAQ2Pe8tMW4IBGaTz+0WIThFVXAmbEEp0EJPAgaIwolRxXFzLNdh0YhU?=
 =?us-ascii?Q?/RFI7ZIPfZ7J0X7ydhHZhjL2PGl1Zr9H6PI6gozcvDvFJyBq1jQiaeRPIAdh?=
 =?us-ascii?Q?SKPU2RoIeTu9m6DXD0T2ziuV17Usahn2WMK/vW23k6mTeMR/2/L9WbgZFfwY?=
 =?us-ascii?Q?Ez22D3dlecVORkVxm1JSes9DQfEWRlynaSJ6zl/5BAx/y4d1SBAR9dJ1Cbs+?=
 =?us-ascii?Q?KM8rlA+E7qrLl6iTx70ENlsubbYih8f9Hkokqc156I3KutV9ZbZ1UbURcMZJ?=
 =?us-ascii?Q?bHOYAqxQAh8xlRu0CoB/uLroK7xt0lHPMZoxgmi3QDxiQe77kertWT00WeVe?=
 =?us-ascii?Q?wmymQaGk2jaS3wgkTkfggynyY9HsaTwuuGPp8V2gBaW5MxX8OCN77Vc5yn7y?=
 =?us-ascii?Q?U2hyLtKHtm86YaolZq/tSoofhc/hGhMBtAeHVWt3mR0QDqG4NQ81HIGQX1RV?=
 =?us-ascii?Q?h0H9OeMp6e95AaYLAsykpnPc85Ufb+GT5YQJkSN7XRjHUHi4yl+RIs1aUQod?=
 =?us-ascii?Q?V1Hyq7ZtqykkCa8yRKtKF0eFMiIUpcJrfyNHecWWaQxUYf0DJ+foMEinLz5g?=
 =?us-ascii?Q?wa8stc8/3Oxl/HOVtDu+yu4eDX5R1cb7XCjZYJqeqcRAk8IryqudLfDmh6MZ?=
 =?us-ascii?Q?5FDp2KRoAd7GzZx6CsvovKEPHjoi1NdgNu001ROuIAZSDxrxHASiN6YOMZkr?=
 =?us-ascii?Q?thT6fjj6rxF3JaMdDpy9/COrz/ZLWQpzrIvf79fKWaUadFZNCHq9h9y8diBj?=
 =?us-ascii?Q?5lxqRFmOzhhq6tv/FoI5jXgdVggL/m/8RfooGtilxHE9HdQuz7+G7jp0suA7?=
 =?us-ascii?Q?u+sqAF8m1W+C9mV9iV8cXzAo/v9ZmBQUw6DXgGzDLgEJs0ZDPpi8V+nf2GOo?=
 =?us-ascii?Q?eqRGiOUZ/xk/5ijS1yLY9c/hb5mmNpf9n1D9ehXd?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: PYZg/ZUnp2SUMxbKb94YYk36va/AYwOaPwe+9fV+6ZoiTYetHeFZJadRnHnFuZ5DQtiZZGjUntQaiJzeVpcRvcKljnfjP3+MkFZV206GrySyykofolxv0J9Y1IRjOor5UZgfN+7+wgWUNLA6qCKkUAaaM+je4gPIRqKjiS2+quFQj/hgyPKju6FEEvqBcSPdBNX6AkxjjoUqETgB+FVsCjOo/QxOTHvUOaUc9VdtCDejjf6ivjLpf/nuL5WDAjuMq4b39I/tGT1WwmblJxh/pqpJX02qixpQztniebOEUUFU4ojBdx3y+JLxEzmz9202IgfxrKnjw4Rrl6QixR1ln5fg6C+AwSI+VdBYfTMP2M3ZRwEmMdiqoBMtGVRx+H0AiIlyWV9sAc7vmx53lZNcQ8jNBj4HG6GRRH00/RULDYEMeN20KYcgOr9WSAEE15zhQo7yTw25fzkeQRILY5XDvKzlTs9mS+4Rj0fsy7VVxkSh77i9ezePAQ4zk2dZduG59u+qdPNviMz0fv0gwHZl5m8uaevoePyAZ5VJe54EytxIN5shX2GffBnZvsH+dZg+79+s4UwYkgoyuleLlflu1rg6EMmQl4UMxH4s4TUxiqfP+IY/IkMlvdVCrKGdSqMEen16S1qC+dvDNtSuk1pMqGOXbg6UxKM23mFiat8yYWTJgqBMhRkW2PhIljnkINQCt35VoieH8/i/925wXescFlbj57NldjdWfsxMJe+eYL0IfJt9cFHzACK9ImmWwbxMUFujvufiPg53+8OrKENgHpFCDmA9WeeWVU4521gl1bU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d767d427-c64c-4629-822f-08db8bff84c9
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 04:36:16.6159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iE6FoHb3LZwErdk3DsggcEwdM5BKseghQDxFcinVn0GSRRVMefCmIHSzx67k7Yoe/Do1Ne8F3N3AUpqFbFHf+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4774
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_03,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307240041
X-Proofpoint-GUID: OA706Ysqin5HUMOH5F8_5vF_LWAaNdUD
X-Proofpoint-ORIG-GUID: OA706Ysqin5HUMOH5F8_5vF_LWAaNdUD
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

Darrick, Please note that I have removed your RVB from "metadump: Add
support for passing version option" patch. copy_log() and metadump_f()
were invoking set_log_cur() for both "internal log" and "external
log". In the V3 patchset, I have modified the copy_log() function to,
1. Invoke set_log_cur() when the filesystem has an external log.
2. Invoke set_cur() when the filesystem has an internal log.

Changelog:
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


Chandan Babu R (23):
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
  metadump: Add support for passing version option
  mdrestore: Declare boolean variables with bool type
  mdrestore: Define and use struct mdrestore
  mdrestore: Detect metadump v1 magic before reading the header
  mdrestore: Add open_device(), read_header() and show_info() functions
  mdrestore: Introduce struct mdrestore_ops
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
 mdrestore/xfs_mdrestore.c | 497 ++++++++++++++++++------
 8 files changed, 1014 insertions(+), 413 deletions(-)

-- 
2.39.1

