Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D19C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jan 2022 22:54:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbiA0WyV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jan 2022 17:54:21 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:8920 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229801AbiA0WyV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jan 2022 17:54:21 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20RL9Kbi012805;
        Thu, 27 Jan 2022 22:54:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=GVWRbG4tN/CXuMVm1KtpcJE3nvvQNKSkqDcklB5iaC4=;
 b=AiF1Ug49h5cQYziRH9TefK8Ya2x4gZxpj2GvbpGFsXsUParInLj6aYP6kVPl+CagySqK
 klUHv565hFv/pUIK5lfd+TxAv27/9Yv18m4sN2ODhYVjHiBX0o6U/w5c3/039HP9P0Cu
 qwdOT3q0nZAxEyGI9zck57Siq3mjIzYXUe8VOh0agGathUmtETZBSLYvIos81oYt1WRM
 9cpk9tFjF2MkaeaZu8SFYNIfg7SA5TpFrr2zyWLuff4QNLw71BsooKG/gy0H81zWCu5D
 cFTyQurBOTCKzs0zwNZuLU05GQJLkIfJhhsyqeKsn9kXwJUdmer9avgh0ANqId+Cm18/ Pw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3duwub1cm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jan 2022 22:54:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20RMV9Bi162024;
        Thu, 27 Jan 2022 22:54:11 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by aserp3020.oracle.com with ESMTP id 3dtaxbcb97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jan 2022 22:54:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PO5/6ttbzD9xaEbj4HM5QLrwCpsos3PIWPMeFnGlU4wTMoPb85Mm/QLQceNzg48TToonMc/3kSkF8akg79uu5MyTl0QDP27M4DIOFVEDXnGWUgHhOfqh9H9n4OumkCnaxHg+j9HndO8+1Rrdplqd0j9uRzW/Dtlq8s+6tXTQWy1j/VREuK6qqQB41oYXZRkTrVkxq38WWo8AFl0s9BEd2nutK4dENnGGqJCDtit/dq2XRvGoKWpCs9Ub4zR1nMrNmFuQ0SVLVM8hSJkScuhfVKUw8SZfi3CjTNfV8dpkBw0WQrKXcQUIY9VPHXwaToZuvI5f/ah0ExRtsVk5ELNhMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GVWRbG4tN/CXuMVm1KtpcJE3nvvQNKSkqDcklB5iaC4=;
 b=hjFwPwE0kX9mnvgi1CS/F8Oo5JFVPh/I/SqO7PVONyhCV9AAc5XWouPabnkpf6VwzI1cLGOb1BWbouVJgHukmr6o1lxtUEZ48u0eXsEbcMRGOlkQCk+aI2k/vig9MFXQ2TcqjP6CBDMw5fF+Jtd1cbUXOyf993ee9F1i4YLUBpiBT0V7HRm+HJrAWwh+ISh4ID4LccgL/hLS6p+hyyoCfkGE+yZ7lzqM7rMJuNgAJPdo+A80ax8Kw7cFYTHKtdwmrs3cr2MLJS1DnQGdlO4En1oT2PvXH0iGaPPYOdBwXUEnBCJYrOW04o3q5fB9JUFEjYpOZ7+xtXxNanRXv90sQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GVWRbG4tN/CXuMVm1KtpcJE3nvvQNKSkqDcklB5iaC4=;
 b=lGIpNtyGmWOy4+kKyVdAa8Ni5i8cu3njeKxrAhTuP08q5wGw896vj4zplMDcMFsjfhvM7yeh/ecpcRJduroX+98g/cZGg0hwuDugpZV+gXSRp1IwG3i3TCYecxNWV7S1ZdpVOxG08TtVGqsKo1MmITuCTIr5FPdVg3CmwZ4FfYM=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MWHPR10MB1471.namprd10.prod.outlook.com (2603:10b6:300:23::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.14; Thu, 27 Jan
 2022 22:54:09 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350%8]) with mapi id 15.20.4930.017; Thu, 27 Jan 2022
 22:54:09 +0000
Message-ID: <99ca946e-3fda-fc42-c83b-37caed0f5162@oracle.com>
Date:   Thu, 27 Jan 2022 15:54:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v26 01/12] xfs: Fix double unlock in defer capture code
Content-Language: en-US
To:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
References: <20220124052708.580016-1-allison.henderson@oracle.com>
 <20220124052708.580016-2-allison.henderson@oracle.com>
 <877dalwxf0.fsf@debian-BULLSEYE-live-builder-AMD64>
From:   Allison Henderson <allison.henderson@oracle.com>
In-Reply-To: <877dalwxf0.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0384.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::29) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96d6273a-861f-4289-ca30-08d9e1e7ed96
X-MS-TrafficTypeDiagnostic: MWHPR10MB1471:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB14717B6210D3F28463D5F96F95219@MWHPR10MB1471.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:883;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LJMaM3SE0u1z0TJlkiKbG4Bj5HwV1fiOk0+qdCSdfgx/z380qfEdZxcZ6lAyQbx0N1fAA9sJ5fCyLwyfklzcMUN8Mtp8G0uKjY/5RsySe/h0l0opKvct2ViBfd1vNgjno4JBPxfH++CrOj2ye2R3b2Ped5OmV2pW3WmZ7QY7tpxkvQDavdYdKB+juVqPWTz4STZOyRD1j5h8bCN1r8+qYE0WOTHNpZKRH0q/sL0FELFCogx2V4/LCqEE3HY0FeDJUkEaHhi2jGLMvdcuImHSfFcXoDaRw119lCsUEgD4aZjQsuAXUScuRHjoK3/wnvmi4VPuUOOoTJrlkz/srEMl6UrTsxiYZsCmGGmgJR3eR0iEQ25RyZpSwwplVjf3PYNB7ubVrnXA+O9JXr5mQ999doiTiNEtMscjJz+iz1nGmhaKwxL4kXEalINv/SoaKf1qxrXbckUgKvDmyEmVPIJpMsgE1a7wT4YhDBT60sz8pqTDgHsV/ttE7y2Y0OfQrrKoOgatJqdxBJWXkb7eJhq6iiPZQ2c82dw2X5YqZacOOB0bkVBNZYFpld4jJlg/mmB2nCGRz71p6kRtQFF7aIEUhSC2qUQErRnHSF4+nEMc8OJVd5CHS0cXLMerzJx22XE28Wkq8bM+5+1nP5/rgoyXyo4n9CMovh5g+LaIo8PVpFW05nTOOVzT8RSFHoxcsADHYHLZxWs9rXGSeN/A5XG7OI6EFB3katWL+00gKmk+kFU+ivux3nT6kan/caxXwNHFSQCQtG+4D5N1JIHfqTK4f1efLxgtdW2ulxzSSYv0+lHGsJbVeMxVuP/+ZODUCXK8QZ8H6Dp4g461HgEUv5wCWHuVAd+CrKJV0GJlhnPeX8uRxeD9IEM7IlLiYbK7kyZg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(86362001)(966005)(31696002)(8676002)(4326008)(6506007)(5660300002)(31686004)(6666004)(53546011)(6486002)(2616005)(44832011)(52116002)(2906002)(36756003)(508600001)(6512007)(66556008)(66946007)(38100700002)(38350700002)(8936002)(26005)(186003)(83380400001)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXRaaHdxNjN3QUNWNDFpUU5nU1ZrZDQ0NWVXYTN4dW9OT0h5MWplM0NoK2Jp?=
 =?utf-8?B?WE8veGlRTCtpZDlrK0xYTDcwMVZNdW16aHBSYjNWaW1JNy9JTHBLYVp5L0tN?=
 =?utf-8?B?ZzhIOGFvRnRWcFZXdWNKcHdzeXJPbVI0VEpnbG5CUlB3dy9YUDRKQjk0OERS?=
 =?utf-8?B?ZXdCMGtmb2xDU1BmR2hkaUpyRnFuWnJVdHRXWXc1Y0RBL0w4OGJKUmU4cml1?=
 =?utf-8?B?aTlFUlJjMGlDRXlxbER5c1hvY1kzMjFHNmZ1SjBsYVpQZy9qR3JyZ242SHA1?=
 =?utf-8?B?LzRVQXRtejFXV25OMFBKSXB2RjhsKzRmL1V2UmhnNFFEQVN4N2FGL0ptUjJl?=
 =?utf-8?B?M1JxZ3hwU0cwWW5hamcxREVBM0VneFB6ck9KYzd0RU9oNGFsLzlnZzRsanpp?=
 =?utf-8?B?WnhXTjhqNDZKL1hEeDJWNDVNaDdHSXlqNkY1RG94RzFKZXpINHkyY2FzMkRM?=
 =?utf-8?B?bVVtSlpQYzd3aStPSVY4UUgrNUMvZ080RDNKMTVaM0ZkcGl2Y21YUEh4Sy9X?=
 =?utf-8?B?aU8wVkR6WTZFeWw3SnJBNEQwRU5sM21Lc0VIMnAzQ3ZHMmMwREhhYzA3M0h4?=
 =?utf-8?B?alVFRGg3S0R3VDJFRGU2RERYTEFGSjdPUEJkQTBpNnI0UTlyK1B6elY0QkRx?=
 =?utf-8?B?a3FHUXh4ZzdYeGR3d0VPZmFHR2dLbFEweEpXTkdFcjlXTEk2Yzg0bGZZR00y?=
 =?utf-8?B?Yjh0djVpYkJ4TTZRdVhGNzZEL3VTd0hFOW00Und2RURPVUpQZjh0aFZxN2c0?=
 =?utf-8?B?QW82THRxa0krNVhFaHg5NWZzUXpGbFNpbS8xcnJnOWRDL3VvaWs3cUxvd1BG?=
 =?utf-8?B?QVlybFgrVTRZcDBZSldZNlEvWlp2dlhwN0VjblIwd1JxT250dlRvaEpOQVho?=
 =?utf-8?B?NGNEc0t2ZXRWOCtOb3E4Y1VaWUljbXJoeks0ZXNYQ3BjeGpYRlIvdTg0Z01V?=
 =?utf-8?B?ZnpKeTQveXdVMHpvekZRUFpQL3dZcEc2NjQvcEN1OVJzSU0wRnQwQUNlUm5E?=
 =?utf-8?B?Y1hiNUxEVEVaemdCYmMrSHpNNmt3bHJ5SGVUK1NMc3NRVHdUZHJtRmU2ZlZC?=
 =?utf-8?B?WFp1SnR5WWt5L3RISEdBbzFxNkQ4VDVscEJiNCtlc3pUS2FwMHFrZHQzNkxD?=
 =?utf-8?B?OEZ4ZUxUaEFyN1hNUDJ5alozSlR1bzJhZmc4M1FrQ25FK01PR0ZERVY5djIw?=
 =?utf-8?B?cXBtcGFhZ0RJYXVaejRkZ0JGZXpIaW5zblpidTBlYzRyVkJTdDl3U0R6S2Ir?=
 =?utf-8?B?c0hJUkMwd2NNMzkva0NabFVvaTNnMTRxUlRWMzRDcGVqZ0Y2amJOTk5tTEs4?=
 =?utf-8?B?b01yc0N2RjVlUG1pT1k2OXJrOE8zNnF0L3hFNURqZExjS1lpemt1Si9iU2RD?=
 =?utf-8?B?Zm04US9vZ3hpeWdRdW9SL3pTdjE1UkVlZjJOYmlSbmVwK1lFZ2Njb0tlcldJ?=
 =?utf-8?B?cWowSnpwOTZkUHQ5cTBON252ZDcvU0dNdUJlMHBtaTlZN2dXSEZhN2dNNzI1?=
 =?utf-8?B?aC9GWnRibjd0S1BmdzFpakR6d2QvcmpTQURMUlVmSU1hUFl6TFd4TEpmT05E?=
 =?utf-8?B?YWxBM1Z1dFNNRmR3dlcrL2EybGxLdmtaYVFtUUVrSG9iR1FIRkRlMnVyNUYv?=
 =?utf-8?B?TE1uVkJ0ams1NzcxYWpJNTlOdExCS3VpOE9xWS90L044VEVlOXRWcHh5Tm9F?=
 =?utf-8?B?NnYrUDV3T2lKR3pSb3V3R3lkMjVTdGxGc3FvZThDVVYxT0R1b1pUaUY0WVBH?=
 =?utf-8?B?WFN2R1B4WEw0N2pFYWVRNnE5c1g1M3ZPOHIvL0tRWnVkTU5tSFBHbDdBeXpK?=
 =?utf-8?B?djl2bUNSVWd3aTRPK0RkZWFxVE9lT1VzN0M0MHJPREpmWW44Mm9memRrSTdG?=
 =?utf-8?B?RzRTVXFuQ0M3U2xONm9lelNDWGcyYXBlTEMrSlRiNTlZcGM5d1k2NXd3Nkt3?=
 =?utf-8?B?THhzWk5CM3lrYWNkUUZZUHJ0MGxnL2FvK0dmVnFvc2pUM3NCZUltcFBVK3Ev?=
 =?utf-8?B?cVVucUdqT0lCRy9tRG9ORXpJZk1XeWsra3pwQXZaVWQvOHJtMFRmZWdEMDdv?=
 =?utf-8?B?UXIwTTVkVmdyWDZnTTcvajNPcWVBN0dsZElNRGVrU29ieWdLTStzbkJjQ2NB?=
 =?utf-8?B?YklCNGhocUM1blQ3R0N6R2pvcWtWSVlMNmVzQlpSV1RubHo0NHVneWZLdmFw?=
 =?utf-8?B?R3B1RTNRNFpGaXhpNTMvS1ZTTm4zU1VCc09BT01NcDBqUGpia0VNYVVCekQz?=
 =?utf-8?B?TlpNMEE2Q3VEUkNVMU1aMEJJVlpnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96d6273a-861f-4289-ca30-08d9e1e7ed96
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 22:54:09.2537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zzoPgin0KYRl001r9WcMEZgmvGDImMKqi2MrBAFD1TBLorTEYZRw4tfgvy4e95mJUojcgigam2o5xIpmSVooq/tpIpAVGE7kflW1UT0wjU4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1471
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10240 signatures=669575
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201270128
X-Proofpoint-GUID: BpiBGnziXdR94tDdIZ9mLi80I1fhXkNN
X-Proofpoint-ORIG-GUID: BpiBGnziXdR94tDdIZ9mLi80I1fhXkNN
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/26/22 10:38 PM, Chandan Babu R wrote:
> On 24 Jan 2022 at 10:56, Allison Henderson wrote:
>> The new deferred attr patch set uncovered a double unlock in the
>> recent port of the defer ops capture and continue code.  During log
>> recovery, we're allowed to hold buffers to a transaction that's being
>> used to replay an intent item.  When we capture the resources as part
>> of scheduling a continuation of an intent chain, we call xfs_buf_hold
>> to retain our reference to the buffer beyond the transaction commit,
>> but we do /not/ call xfs_trans_bhold to maintain the buffer lock.
> 
> As part of recovering an intent item, xfs_defer_ops_capture_and_commit()
> invokes xfs_defer_save_resources(). Here we save/capture those xfs_bufs which
> have XFS_BLI_HOLD flag set. AFAICT, these xfs_bufs are already locked. When
> the transaction is committed to the CIL, iop_committing()
> (i.e. xfs_buf_item_committing()) routine is invoked. Here we refrain from
> unlocking an xfs_buf if XFS_BLI_HOLD flag is set. Hence the xfs_buf continues
> to be in locked state.
> 
> Later, When processing the captured list (via xlog_finish_defer_ops()),
> wouldn't locking the same xfs_buf by xfs_defer_ops_continue() cause a
> deadlock?

Well, currently the attr code may take the lock at some point during the 
operation and then lets it go later when it no longer needs it.  So that 
is where the corresponding unlock comes from.  Ideally, the delay replay 
and the log replay should behave the same so that the underlying 
operation doesn't need to know about it, or do anything different.  I 
think the attr operation is the first to use this lock hold over during 
a journal replay though, so I suspect there just wasn't very much 
testing to exercise it when the defer capture port went in.  It comes up 
pretty quickly with the new log attribute replay test though.

If it helps to see it, it's easy to reproduce:
Build/install both kernel and user space branches, as well as the test cases
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_v26_extended
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_xfsprogs_v26_extended
https://github.com/allisonhenderson/xfs_work/tree/pptr_xfstestsv5

Turn on the log attr replay feature:
echo 1 > /sys/fs/xfs/debug/larp

Run new journal replay test
./check xfs/542

Test should pass as it is.  Reverse apply this patch to see the bug.

Hope this helps!
Allison

> 
>> This means that xfs_defer_ops_continue needs to relock the buffers
>> before xfs_defer_restore_resources joins then tothe new transaction.
>>
>> Additionally, the buffers should not be passed back via the dres
>> structure since they need to remain locked unlike the inodes.  So
>> simply set dr_bufs to zero after populating the dres structure.
>>
>> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_defer.c | 11 ++++++++++-
>>   1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
>> index 0805ade2d300..6dac8d6b8c21 100644
>> --- a/fs/xfs/libxfs/xfs_defer.c
>> +++ b/fs/xfs/libxfs/xfs_defer.c
>> @@ -22,6 +22,7 @@
>>   #include "xfs_refcount.h"
>>   #include "xfs_bmap.h"
>>   #include "xfs_alloc.h"
>> +#include "xfs_buf.h"
>>   
>>   static struct kmem_cache	*xfs_defer_pending_cache;
>>   
>> @@ -774,17 +775,25 @@ xfs_defer_ops_continue(
>>   	struct xfs_trans		*tp,
>>   	struct xfs_defer_resources	*dres)
>>   {
>> +	unsigned int			i;
>> +
>>   	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
>>   	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
>>   
>> -	/* Lock and join the captured inode to the new transaction. */
>> +	/* Lock the captured resources to the new transaction. */
>>   	if (dfc->dfc_held.dr_inos == 2)
>>   		xfs_lock_two_inodes(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL,
>>   				    dfc->dfc_held.dr_ip[1], XFS_ILOCK_EXCL);
>>   	else if (dfc->dfc_held.dr_inos == 1)
>>   		xfs_ilock(dfc->dfc_held.dr_ip[0], XFS_ILOCK_EXCL);
>> +
>> +	for (i = 0; i < dfc->dfc_held.dr_bufs; i++)
>> +		xfs_buf_lock(dfc->dfc_held.dr_bp[i]);
>> +
>> +	/* Join the captured resources to the new transaction. */
>>   	xfs_defer_restore_resources(tp, &dfc->dfc_held);
>>   	memcpy(dres, &dfc->dfc_held, sizeof(struct xfs_defer_resources));
>> +	dres->dr_bufs = 0;
>>   
>>   	/* Move captured dfops chain and state to the transaction. */
>>   	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);
> 
> 
