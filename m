Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE4CEC77B61
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Apr 2023 10:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjDMKeu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Apr 2023 06:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbjDMKen (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2023 06:34:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415272D67
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 03:34:39 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33D6Xube006256;
        Thu, 13 Apr 2023 10:34:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=jz4nAq+t1WaRUqWfQ1a3g/2D4zaYc/B7kxYgkFVOnMA=;
 b=wgKTwpCpXY9VqprNevCMnB/VtL/5F6y8fR/Fba62N3rW/se+NTFXvTM/gOV3hFwTxwJ5
 PH1WyCLSQ3boa7N3ykZVNeWxXrFzw2iDI2hjQdDmkJDyyUDx6h5JnzBEd+X1ZtsACoXK
 IbMvQqf6HdEnhD8vk8IfbjQqGpHK+VO4FjzJSwltkD0H3cwzHJM2jO4dz43bCphwZ/no
 g0yI+J/Cnwqp7GhzqDWnKhiOU3ju3CfGmush8p6neh3fS+Pg32TQUfBswUga8cnM9rxK
 4Eo90Oxp4iu9cvgo6erzqVxcgpose+rDTv8f+9xXeSGa40CsjN7JgwwmuDsXEe0gcBkM KA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0e7jgdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Apr 2023 10:34:29 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33D8LpAq017447;
        Thu, 13 Apr 2023 10:34:28 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2042.outbound.protection.outlook.com [104.47.51.42])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puw8a8w99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Apr 2023 10:34:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HC5tn79uKyBcIB5hZiLEXd8NthtIrVb2LHZhQnSt0SBaSPnSrW5Jn5xiZ8h/+1Eii4cLoq/cFdBDwVhPDUQ7fylF6+hxQ2zKDdMvedcVfBNdMpln6qg3tiW0pYBEpme/tN6DA/HS3zP3qLj9VjrHSXyLgg3s/it0zVmLv1oJlWBinrgKeogr55h5xrE/BxoZPotkzbG6BiExa6TAgvvQIBhZ34bsifgOec6qbdzf9NiBVdOFSHY8nWTP3Qm4240IYNcuIhGUNAm35mOLoTkR9z1Ma+JeSxVS5nT+euKoCtzFRroWuMDqRyY39znUHSOrzr71hHaG8adNZRaza53fZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jz4nAq+t1WaRUqWfQ1a3g/2D4zaYc/B7kxYgkFVOnMA=;
 b=U+8JO1s22bHEhxtqeFhzdbR82TKEuFTrvXlCnBUCjPzGZeIsqU+uvRqgOmAuh0vEfguH8FSrwpi60C7ROShM/AhYtP1IzwUOzFuG6eBieOsy6d2VhxJ4BJ4BvmzAFRV+mv20w8Zda+6W95410UD64af72Q5kZVRKiJ4uMj3PQ/syo+CF7HnzPvaDBnX/V328xTQltaVGqGfY7WGVAQ0UrcYDzD0CjULgKZX9f/9HRSJRCHKbE1W0NC8p2SCymptDIEBOYWDeKt4PnzUmf0gzqmnv5L24TuPSOutZTgBarkKhWqbwhTN6JcPphaoIJiTXR1/S3HuB8fJRw2sDntwiDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jz4nAq+t1WaRUqWfQ1a3g/2D4zaYc/B7kxYgkFVOnMA=;
 b=U7IEQVs222gOAoePNSQ6Rlm/Xt1pn4s80DFh0sUS+eHi8WxrZ23eN7IsBdtocmEVdNMGz4eiiMf7H85YVAtN/uWHNlK7zGLMJsPuN2n7QpPk7rFI+MANkcpGSP7q8yQBVZiKMgsvCk46OSheL9iGK6j/vXY+chlaNxOLqdJWqEs=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO1PR10MB4706.namprd10.prod.outlook.com (2603:10b6:303:9d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 10:34:26 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 10:34:26 +0000
References: <57B035ED-1926-4524-8063-EB0A8DB54AF7@flyingcircus.io>
 <CAOQ4uxg6cTF2YnW6anxMxOH_88+JZW+sC9rG468Pjy=XrNEgrQ@mail.gmail.com>
 <6AB6497D-18E5-41C4-B688-4DED6703534F@flyingcircus.io>
 <CAOQ4uxjj2UqA0h4Y31NbmpHksMhVrXfXjLG4Tnz3zq_UR-3gSA@mail.gmail.com>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christian Theune <ct@flyingcircus.io>, linux-xfs@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: Backport of "xfs: open code ioend needs workqueue helper" to 5.10?
Date:   Thu, 13 Apr 2023 16:01:17 +0530
In-reply-to: <CAOQ4uxjj2UqA0h4Y31NbmpHksMhVrXfXjLG4Tnz3zq_UR-3gSA@mail.gmail.com>
Message-ID: <87o7nsjck6.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SI2PR04CA0004.apcprd04.prod.outlook.com
 (2603:1096:4:197::22) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4706:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bb4ea04-afcd-44c5-6d0c-08db3c0aa745
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kBvKHQD6wQSDcp2QF1BHn/LC3x1owVbWtiExfPc149B8l0WyeaQ4+DgB3u2tAj8HgMYJEARpYBpaIiL1mZOhAgYfmoBJTrUj3TrTHdrQw/cAGQWNsohyTsnSRk04rnbZxAR4VK7HmPjveT0i6F4MsMIj0EMlFaZEwHNxkT2q5dZ8EYugWhoYzmPFsKiSXyYs1ulIgb6ZvSL45eXKquWARISNeObyzfdX4Kh9+CCWj3bT8bMZ+XfXE4EDE5/k4NgM00XLqTrecGkwv2rN0ibCdm7z6pxoo6pf7LjR8/TTpZ5Wmfk3OkHD3il6sucUbEbGx2v53Ld8Iq7ZvU7jNeTORGiLSlPPL1iP6UFTmdF+ZqTuZG1yJ+UFT+F7on5TEJP26dHlC/zrisrjua6OyixOabFU6l8R2sd2nYTMSjkqm12uUcQHDLXyq9EALieJ6T8sSYnZgz3leHZ90BdXg2qgv67M6ljKWPRcqnV60z0EIEGH0gMqSwJDv8ct1SO4RlRUGUrih6e0bas5JI7gxYXB2B/d5hWRVeQxbbVaGifwIz4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(396003)(346002)(376002)(39860400002)(366004)(451199021)(6666004)(6486002)(966005)(6916009)(66476007)(66556008)(66946007)(4326008)(2906002)(33716001)(86362001)(41300700001)(5660300002)(8676002)(8936002)(316002)(38100700002)(478600001)(54906003)(53546011)(9686003)(6512007)(6506007)(26005)(186003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dDljM0l6ZFhSTzgxVzRocmFCNndzQSt6aTBwNVAwUVBpNEFveG9Rbjk5TFhx?=
 =?utf-8?B?TS9FL3VCc3M4ZmJDdlZQN1BYWER1em9sZlZiY2J6bTZWVkRXeS8xZGlqUWhL?=
 =?utf-8?B?cWdCeG1zeFpRbi90L0o3SlpxNkVXQk5NeHJ4Ulc5ZXhrdHRNdXp1UjlsaC9t?=
 =?utf-8?B?eFhjNC9Jd3ViR2lyZmdTMUErVHFHQTA3a2JYZTBzV09VZSt2dURHaG82UXBJ?=
 =?utf-8?B?dzhUNUM2aWxSS3ZxU25HTFJXUHpPZC9ZUE1QZkhUSFZSVjlweXB5QU9IMTIr?=
 =?utf-8?B?N1Y5SDB4UEF5Uk9uNW1kMUkrWEQ1dmVjZXlmTzdaRlhST0o1bUEzSjgvMVVZ?=
 =?utf-8?B?M0YwY0h1K1F2S0dDNkIyMHcxZUlUQjh2RVZPbG9PVm9iYTd3Q3lXZmFlenhk?=
 =?utf-8?B?bVE0Qlk5UWJuZVZEd0pxMHFNR0dQa0hGdHIxb3diL002NWsrTUd3TVVBS2Ru?=
 =?utf-8?B?Szc2c3NlYkQ3WkZEb0k1UW5vM2VoUmo2WTYzS2tzRFdDQkd1THZBVDVRbXlR?=
 =?utf-8?B?ZnNmUkMrWUFVem9xNENlMnZ0a2htTGFza1R2cVdoZ0t3Q29vSXFvTitMQmZJ?=
 =?utf-8?B?emZmNWltMHFCM1loZFpGSzcvYTdqdkp0UHh5SWhDV1JTNkVhTEdqQWx3aGJ1?=
 =?utf-8?B?R0ZRMGRQK1JSTE10SEdkMWVXM0hWdzhZVWl0QnRGaFJCTUgrbWdlYWtoZmdQ?=
 =?utf-8?B?T2Y1RWRDbDdhTk5WWngvRkJKUUg1QmFEcDJmT1BsREdxWUpNUEYzMFd0MDIx?=
 =?utf-8?B?QTF5d0ZkS2c2VllpZmo0TDcxVDkrOXJYRXROUkJGbm01ZUF4L2s5YTd6Mmdy?=
 =?utf-8?B?L1RsazVlUEtzNEVYaTZzMmtLaEgvcFlRc055Ry9ldEhzZlV6YWZ6aDlLRGNH?=
 =?utf-8?B?SHp5clZOTFB6YlZUaGxpaDdrMUdST3dBWW10eDhRTWdEakZMeTFTRnR2UmZa?=
 =?utf-8?B?ZHB4aUxhN1FwOFoxUzFvSDc4TEhYa3V0bXluUHU1aDYwYm5vNFNQd2JzWk9W?=
 =?utf-8?B?eTVnQ2tpTzMzUW9jMGY0Q1U4NFNBdUZEMnhXUmYrOWpEbTNkYnVXMm5xWHJ0?=
 =?utf-8?B?R3E0U1hBWTNZUkdJS3RMODQybEEyM2lWWGxWWmZqSkVsdmtUZ1c1RERMQ1FQ?=
 =?utf-8?B?aUJ2TEVmTVFLc1gzc0puQk8xazJqZ0QzVXpleVZTOXA5VDJMQTJYMkRaV1ln?=
 =?utf-8?B?UmUzaWs3UzI5TWoxOG0waGpjWjBXUE9YekhYS3RMOXNENXFsRG9VMEdvQ1Ni?=
 =?utf-8?B?TGt6a1J1Nk9CUVRPOU1hNWhsZHkyMGVpa3hOQ2drNVFwWFhIT0J6Z0tDQVdq?=
 =?utf-8?B?NTIvRW1KQlRZVGpsVFZLckI0UTBtMXY0UHh2STBPYnJLY1Z3SzFlazVQalNj?=
 =?utf-8?B?QlRNUjNicG1KM1F5M1I0N0ZZblNUQ205VzVCa3lKb3d5VitGWkhBL2F5WHM2?=
 =?utf-8?B?bEJYZ3RkcW1UeUpuemRnQXRtZjl4NG1WVHd0dDI4YjNvQ0lFZTZxN3MrZWJH?=
 =?utf-8?B?cmMyRFJwbUR2Y3dSQnVUemZyckVtOVpEZUNFYlZaSURJZ1pBZnR2UXBFK3Jq?=
 =?utf-8?B?d1ViYVppWFI2Wkg1R2drTmFYY3pycnBuTzhnVVRZRGhHSUhSK1c3Q2xIZGc0?=
 =?utf-8?B?dTBlclJTQ2phZUNOTDZEbk5IRVVOUWp2bnMrOUJHNnY0NlJicGxOTFRsWmpV?=
 =?utf-8?B?UVBGbUo5bEtxY1ZCRW15NDcxS0FsNmYvMFNmQk1iaHdxUHBiRVQ4SVBvYmsx?=
 =?utf-8?B?Y001dDVlVE5DMnQvYnBXdmhlOG95Yk9BL2pCUHM5Y1pNYjJyRWNsUWg5YmRR?=
 =?utf-8?B?d2VzckN3OWI4UTdhN1Vjdk5iZmt1RXFDTWNFVnREQjltTm5HSEorckhRZHNJ?=
 =?utf-8?B?Znk3TVFyK3dDNnEvZjhwcTRVeWQrVjdZbGNqUENSSTUxNVV0VWpNZ1kvZkZm?=
 =?utf-8?B?RkNIZC9XamdXcUwwLzdNWGJGemg5Y0I4TGZ3aGhERExtRWthN1RYVzRhajRP?=
 =?utf-8?B?MGFMVWo0cFBqcWtJNUY3eSt6d1RsMWFoVndkSytZS2RqQVB2WW5jU0lMczJk?=
 =?utf-8?B?dGovL1RIWU1rakJmVWVLZUgvdEUzUnBTU1M5MnZGZnJXaHR3M3YyWVJwaW11?=
 =?utf-8?B?QjM1YS9odTRjUTZSYVFsdVFrbm02WEdneVMwTmhXV1I1V25DNDZWbGZ0R0Q4?=
 =?utf-8?B?cGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: yaZB9XL+Nn3UWaPvtNOLWWbSDoznUg4IIm2aU+QSGJ9tUMumd5ptsdA7bF3TTuhPAzhWM2ddEg2iKgLxOaUYeuWv7OT6xmObf4sQu5xq2YrvvgFswDw0bHzCsX8y3oFQi1rKJ46DSShBun1dTUE+vt/YzgJLOnAuJMno/GtMVyKclDbThEqpVCyuPIhFnt+iluz0liiwv9Kk8uf1hI9kjraGOH3mCvS/463QcP98dQP+ULtws/Ey7m3DIJTvJOxoDFv3wQI5S7IVEtFo7hY2W/5gIkbcmC22TTLPwoRAYnTSLFWPQjKnWa4NcVYQKM6SLB9HtqGjaFEL5bNyKQAy2zVgdA2lkr7wfAmoysRQutA6d7WsPswnTYqOIxsvAIFxb/+6sOjUeskouspF+upIspFaavcNb4nW0JxDFA6orw4Z8Ru/sQYBjsT1IicAwVtD/DcE7bKHYjd9daSlFHb+2YXSz+vk4vDV9Qzf7HlvLhoZcdMMT35pgKXCYFfT95QykgYCFlYHrYTQQm87L7RDbCmbe658mP9qdmFtb30tmw86TW+m6rYK8Q5AtECn1XEH1GEpR3Ykk346DbLPbdZ6+ny0HVkJK0oqfdfY0AMxDPmR0ZoMWincrf9Q5GigvhgwJINZTv3hfZDJNwHCWtvXxwIyUdk8msfHC/Z4KEOzTCqEJ2VI3NMLlisnEL1ZKyMtCSxnF1TZ54mg+lilpwLVAc5idCI3+j9e5AaWVxttBQrQutDkOxPBLGBQBKoTClJLBbDXEgUbHAh5SFTgsc9hadWfKqrLAjYD1tzRldW0ery3794TLg7pI6mYA1if5ESDWlvjDA/KfhF/6D4vkbDnRWrzOJYuygJAQOHNT/DSy1BwEaLWqrSSYPL4bKhS3kOA
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bb4ea04-afcd-44c5-6d0c-08db3c0aa745
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 10:34:25.9851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KwiiVMxMhSErKqAL6VRhnNjFio3q+0v+ie/1LATxjH1rTf+UjsYkJbsY3PFWvtJVqJ3VChWZvZGzp//PHBtuOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4706
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-13_06,2023-04-13_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304130095
X-Proofpoint-ORIG-GUID: 5puRq6TwzSSosyPCYNtRV0zkv80emBu6
X-Proofpoint-GUID: 5puRq6TwzSSosyPCYNtRV0zkv80emBu6
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 13, 2023 at 10:44:43 AM +0300, Amir Goldstein wrote:
> On Wed, Apr 12, 2023 at 6:58=E2=80=AFPM Christian Theune <ct@flyingcircus=
.io> wrote:
>>
>> Hi,
>>
>> ugh. Sorry, looks like I jumped the gun. Mea culpa.
>>
>> We experienced a hang like this:
>>
>> Apr 05 11:51:27 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_sec=
s" disables this message.
>> Apr 05 11:51:27 kernel: task:xfs-conv/vdc1   state:D stack:    0 pid:  6=
06 ppid:     2 flags:0x00004080
>> Apr 05 11:51:27 kernel: Workqueue: xfs-conv/vdc1 xfs_end_io [xfs]
>> Apr 05 11:51:27 kernel: Call Trace:
>> Apr 05 11:51:27 kernel:  __schedule+0x274/0x870
>> Apr 05 11:51:27 kernel:  schedule+0x46/0xb0
>> Apr 05 11:51:27 kernel:  xlog_grant_head_wait+0xc5/0x1d0 [xfs]
>> Apr 05 11:51:27 kernel:  xlog_grant_head_check+0xde/0x100 [xfs]
>> Apr 05 11:51:27 kernel:  xfs_log_reserve+0xbe/0x1b0 [xfs]
>> Apr 05 11:51:27 kernel:  xfs_trans_reserve+0x143/0x180 [xfs]
>> Apr 05 11:51:27 kernel:  xfs_trans_alloc+0xee/0x1a0 [xfs]
>> Apr 05 11:51:27 kernel:  xfs_iomap_write_unwritten+0x120/0x2e0 [xfs]
>> Apr 05 11:51:27 kernel:  ? record_times+0x15/0x90
>> Apr 05 11:51:27 kernel:  xfs_end_ioend+0xd8/0x140 [xfs]
>> Apr 05 11:51:27 kernel:  xfs_end_io+0xb8/0xf0 [xfs]
>> Apr 05 11:51:27 kernel:  process_one_work+0x1b6/0x350
>> Apr 05 11:51:27 kernel:  rescuer_thread+0x1d1/0x3a0
>> Apr 05 11:51:27 kernel:  ? worker_thread+0x3e0/0x3e0
>> Apr 05 11:51:27 kernel:  kthread+0x11b/0x140
>> Apr 05 11:51:27 kernel:  ? kthread_associate_blkcg+0xb0/0xb0
>> Apr 05 11:51:27 kernel:  ret_from_fork+0x22/0x30
>>
>> Which seems to be similar to this:
>> https://bugs.launchpad.net/bugs/1996269
>>
>> I followed their patchset here:
>> https://review.opendev.org/c/starlingx/kernel/+/864257
>>
>> And I was under the impression that I picked the right one to ask
>> for backporting, but it seems that was incorrect. I went through the
>> list again and I think the following patches are the ones missing
>> from 5.10:
>>
>> 8182ec00803085354761bbadf0287cad7eac0e2f -
>> https://review.opendev.org/c/starlingx/kernel/+/864257/5/kernel-std/cent=
os/patches/0035-xfs-drop-submit-side-trans-alloc-for-append-ioends.patch
>> edbf1eb9032b84631031d9b43570e262f3461c24 -
>> https://review.opendev.org/c/starlingx/kernel/+/864257/5/kernel-std/cent=
os/patches/0036-xfs-open-code-ioend-needs-workqueue-helper.patch
>> 170e31793806ce5e5a9647b6340954536244518e -
>> https://review.opendev.org/c/starlingx/kernel/+/864257/5/kernel-std/cent=
os/patches/0037-xfs-drop-unused-ioend-private-merge-and-setfilesize-.patch
>> 2fd609b6c90a88630a50fb317473b210759b3873 -
>> https://review.opendev.org/c/starlingx/kernel/+/864257/5/kernel-std/cent=
os/patches/0038-xfs-drop-unnecessary-setfilesize-helper.patch
>>
>
> The only commit that fixes the bug is:
> 7cd3099f4925 xfs: drop submit side trans alloc for append ioends
>
> The rest are just code cleanups.
>
> That fix was missed in my original backports from v5.13 because of a tool=
 error,
> so thank you for pointing it out.
>
> I have added it to my test branch and will follow up with posting to
> stable later on.
>
> Chandan,
>
> Please make sure you include this fix when you get to considering
> fixes from v5.13 to 5.4.y.
>

Sure, I will do that. However ...

> I will wait with posting this fix to 5.10.y until I get the v5.13
> backports wish list from you.
>

Since I am working on another XFS work item there will be some delay before=
 I
share the list of patches to be backported from v5.13 to 5.4.y.

--=20
chandan
