Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8153BC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 26 May 2022 16:01:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348107AbiEZQBy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 12:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348081AbiEZQBp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 12:01:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3800BC1
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 09:01:43 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24QEM1X0012463;
        Thu, 26 May 2022 16:01:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=lG4ao3NvWppJ1c9sH8sTeoJ35tOY3LKMQrmrJEyMSvM=;
 b=O9BVjhxKT5gLw3OYwlnaTogPey6/CkPcZVaduTfvUaBSpYkXDJP7rmcS77S08S2lkGiX
 Tf6MHtqymju0+6dWcP5i+YvW86nkGfhLHyB0WSaC1p667P/x6z9ZzMuFYogB9P+xjhXi
 qsfTrPKwvYcgO8CV4qy5AtcgIaBMYbwlFxBEH/eMoqMCV5WPU8EEfxP6fC9fKf64KBtl
 fDW/MwccHyAhnHKsIUMzhUcJhjLAYV4BibQNVnINa1CkygWwUEnkGEhZSc/5b6WnBA2e
 f9trwQEEoqXLqwVGLKSoZ/WuiZKcxb+EUDCjX0pxFC/ZlqC+RjMNpbVpHDpuUKQQ38Io HA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93tbw8p3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 May 2022 16:01:34 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24QFuRWm023709;
        Thu, 26 May 2022 16:01:32 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2047.outbound.protection.outlook.com [104.47.73.47])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g93x1pbpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 May 2022 16:01:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HYnXN2LTMG3z7XirUG7vE5gHrg+4a5lozulFOQBk/iNV4QbkZDDMM6StAG/UdZWBJtZkluI3K4bTtFIxf6+7STo0nx7w4GWYeknSJ84eg2r9b25+Y4brf+IzQn5M1JZLEPOG+9k1bqIH+bHd7HdVPjGqH93dZ69wnMsC/Ykxj9DW9z0LqsZ5xrN5y8C/vrn4/6G23LV7HJjJs/LebKTTnqvTvXjhkqIdtOu1+uYb148wInysSt6otb8SqUdpFEUtFdtHcUGIvZmv9ghtOiScReWJc7apr6JAmca3HjpvDZ5nZzIz66T8jJFGdm31hBBjjnf/ZrwDUFF5sjGqLTC/TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lG4ao3NvWppJ1c9sH8sTeoJ35tOY3LKMQrmrJEyMSvM=;
 b=i+IB9vCUH2zDNSG+aUjOEAr9kkrTv5t/uQPtimjdp96bfhCSxVPFHUH61tlaMMHEqnkgFLi2SpokrxhlAvU7KtFuVY7CNXG4G/gDdJzLqGfAGOOW1Q7iXtxwnU5/yZiAR9nbt0M8t8QSG0tUCj/2HQ2Ut50hc1zi8z+4DVt3RwflgrBn+LE5h79yZnf9fLY3U4hTogbgA6yMgAfjlJTlLGggttIq2ueiphxxkPhr0/jjv7Z4bMPSfeLozdfOt3nB2zyVKd0WVBJO6o3k4qr1JyLb3fOLn8nR16bDhwAUftc6gtMrG8OO68+M5PwGXG7daYDmq95oKNV0mqEApnUx3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lG4ao3NvWppJ1c9sH8sTeoJ35tOY3LKMQrmrJEyMSvM=;
 b=aeqwfRT32PxTrzEVT/WoMICUJQJNGe8Ql4LEF1SY4MUTR7hAY+FGH45EexSdfr0Jmrb9ZeLpH76M1Pdgpz65wq8vGN3PQsqPb/cre1r0QLq/MKf0JlGwYE2OsHyTBkIjuexLpP6YWRNcsr+/LNIhhjaBeLxiIRmT86/T7ufhiS8=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CY4PR10MB1783.namprd10.prod.outlook.com (2603:10b6:910:c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.18; Thu, 26 May
 2022 16:01:30 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::5476:49e9:e3eb:e62%5]) with mapi id 15.20.5273.023; Thu, 26 May 2022
 16:01:30 +0000
References: <Yo6ePjvpC7nhgek+@magnolia> <Yo+WQl3OFsPMUAbl@google.com>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>,
        Shirley Ma <shirley.ma@oracle.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Konrad Wilk <konrad.wilk@oracle.com>
Subject: Re: XFS LTS backport cabal
Date:   Thu, 26 May 2022 21:25:32 +0530
In-reply-to: <Yo+WQl3OFsPMUAbl@google.com>
Message-ID: <878rqos2pd.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SG2PR02CA0010.apcprd02.prod.outlook.com
 (2603:1096:3:17::22) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b38b347e-4379-4663-f8e5-08da3f30ff62
X-MS-TrafficTypeDiagnostic: CY4PR10MB1783:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1783E191C342078EA47CD1F7F6D99@CY4PR10MB1783.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S3bNJSU5DLcqrsQtfQvUIf8bf8+JjD1Sm+qKjK7GXi8Lxc0zoUoirxbYtH0yz4As+SCB1x0l2tH6IjZuOzh5usV3Wqn5UV2asFOuQXGajHu5UAHJCcXOROsG7rc35/c3kz7sitVsEeF1uTAQaXmC8LOFPg6HBgib/V8uIh8UE+aYvVXJ86xbkuQNcYWzTnsRfWNi7paYH+j62bEjxieXnaRphnhcjGYDYa62YjKH2ZfBgLS7E0vsLNK/9zsR4HDowvSJpKnjprdazuR48A+HkF8evRauKk0wTMvoak7rz1DNwNcFvmhTkOjjR7RZfGAAouIcgspLfbppfEYkEJrnj7Y3TUonfzOUvyq2+uDgoYaYD6skN8/0WfyxW4A0Co1ets44OM1EXeK42ViW3JsfIFnINXfFGUsStVoq27/eN5u7F8BnmUmhkw2IzWvqA8tVxL4mhYJtGzUuCHzu/z7JdR6yOzk196Sd6I4bAHH/1TFFpGS0Ur4oSrwHjLuLfUj5SczNPvdK4cs8gnko0fBqyv6auMTaHj39whFoobOSKDZiMHZM4ihh1bXtlc6cc8c7UlTctfecj6Yj/+nUt6oBANfx9sdhx3jazUp8h0R2fRFecu9CtvkVRdjrxNqCjaFutmYJlnbPiCXX3J0kfWdPx8PRQCA5sAr0fPChBE6dTIyraZQUWzpFyqLjWK26a/OQ9wdTqMGUwkilLWqQe4DKFqHFqMzPiIxycXU5DLzTnlexjiDIM/uA1j8cnZHjMU455HGN5Uby+CgemEWENhkDxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(38100700002)(6512007)(38350700002)(107886003)(316002)(26005)(8676002)(186003)(66556008)(66946007)(66476007)(6916009)(54906003)(6486002)(52116002)(83380400001)(6506007)(33716001)(86362001)(4326008)(3480700007)(8936002)(508600001)(2906002)(53546011)(966005)(5660300002)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dUc5REdvazFPZnc3bFF1dTY0bG9aSjR6ZXQxRFZ1dEczWlEvZ0llSlM5Z05h?=
 =?utf-8?B?MVFIT3Mva3laem5JNEF0TnQ5cW1nb3VwRkZCZ1VsYVpsL3JKTEgxZk14bUhM?=
 =?utf-8?B?emEyTkE2cXZKWXFtem5NWDdsVjEvdXQzd1AwTEI4RW1OZHNNTlVSUDVsaWly?=
 =?utf-8?B?cnAzWWxXVEhwd1ZJUjg3NC92eGcxampIYTRsVmlHNWdMUnEzL1JRNENIQlg5?=
 =?utf-8?B?QkpNT3dmeFpoTGxOWTlvVVdzMTVZc1NoOWRSWVBQSlhNRHNjNG40dGFJbWhS?=
 =?utf-8?B?VHdtN0hyQkg2MUJ0dkJsMG5xbmdneGFPczhzVWRWZ0d6ZGVJMW5sMkdIWlZn?=
 =?utf-8?B?dGNDNDVWdDFYN2JYUkFPdCtjK1J2MHExcUUxYk5SRHhMbDBQZTdaQitHWHY1?=
 =?utf-8?B?SG54SlpJTDdkZGpiY2FPYTF0ZHZHMWU3aWpUZG4ySVUyMUpyM2JybGNpeEJj?=
 =?utf-8?B?YTUyOC90ZmRHMjRmdjl0RnJRMEpFOVNYampHRllURHRtNmJXeVpiNHphanNX?=
 =?utf-8?B?bk9oOGlnMjhkNDByTVFpN1JXcTU1clpBZGM4T0QrblJSYVRsa1dhdm9tcHlv?=
 =?utf-8?B?RXVWRGV5VGJiSFkzOHNRUnVFVmlsNDVsc05Kc0tDcXh3VUpHOUtFaVh1SlBi?=
 =?utf-8?B?c2R1OUZQT1dqUjB2SWVBenhUV1EyRmZYSmc3RkFPR1prN2lnNVlhUzd5eUFJ?=
 =?utf-8?B?a1BIVjNKMGp2RFh2NWR1Ti9seDIzd0hJNm1Dd1RvOW9NSWVudm53VjFWVWJq?=
 =?utf-8?B?c1hEL1cvRWpZajIrSUE0RlhKQkFNK0tDU2V2MTc0c092cVgwcDB4SklGakhn?=
 =?utf-8?B?QmhvUGdXWEFZZnNwNVdPNXZDaVJ5L3dLTFkzSlduL2w0ME92SXZBSFEyRWoy?=
 =?utf-8?B?WEhzMGRyMzNpTU4vVGJDSkRnZ1h3MGxjd0RqaEFwL3ZabTRqdGtPdW90WVRG?=
 =?utf-8?B?RE4ydXdrWlZGZ3BNc0pmRFltTWtqNjZoMmtibllNYWo1Sk9yMTFpbzRrRkNp?=
 =?utf-8?B?d0NYYVl4K2kwNVFuU0NlVHlSM1I5VDFQVkx2ZFFuZmdGK1lSZUlkNUF6amhN?=
 =?utf-8?B?anZLZ0I1YktzRmEwWGdxS2paRTVBK0pyZW5oSHhOYmlRWDhQSzRHWlVPWllB?=
 =?utf-8?B?bi9XN3JXUEt0aUVkaEpBODlVc2c2SmUrV2FuNDBwZmtSWXlvOXh6Z3loeHMw?=
 =?utf-8?B?c3JvU0tSVEh3M3NOQjJqQlJsNVVaOWhVbk9aelArbFU3eEdGTWhyMXpORW1r?=
 =?utf-8?B?ZWczK25BVTlEK3NOdzN4ajEzUVg4Rlo4eUVuVkk4ZHhGZHo5VWZ2dmtmbWE3?=
 =?utf-8?B?dHpCczRkb1I2ZWVPelR1K0JpMi9uN0Q2S2ZNWGIxc2NZb0U3M3BLc1VJdHcz?=
 =?utf-8?B?Nk9Pc2dUQWtoWTZFWUUxTTRYN1VUTGdmeHNWN3pjT3dSdUFYQWFxQWx0MHhY?=
 =?utf-8?B?dS9aY2N6RDVaM3ZQQ1lMaWxadVJFVXFnS2VldVg2d3YxQnZIQlZYeVpXQkNF?=
 =?utf-8?B?dEczNFF0OEpMRy9mV0dDVEhBa2ljdUo1cktxT3EzazcrWkdMWmM1cGVqV01w?=
 =?utf-8?B?Vml1bXhDTE1qOUIwY3R1dmw1RmlPT1ZvcnNYY1l4c1E4cHduSG1wMVd1Ui9I?=
 =?utf-8?B?b3pwMHNrQndpZW5NTFdrY2dRRWVQbnZjMCtjcmZMYjRmeXpsZ2pnbzNCUVZQ?=
 =?utf-8?B?U0xKZllTcmxRNUpDR1lLc2dzTDFKNG41QW51enNrN2dKK1pyUzc4alBoVlZF?=
 =?utf-8?B?YWEyNFE3bnhNVmNRZGtrRzh1M01SMHFES3BrOVR0R3ZVOTlvVFc3ZzArdEtP?=
 =?utf-8?B?bi82d1lLVU5WU3VKS295dWNWU1lyNVV2RVR3WHp3UkwvZnF5bGkzWVNLcGND?=
 =?utf-8?B?QkRHSDdkMldWeXlyQ283QlNuei9LWUVydElVUjNRTVh1eTg0MXpncDVZeGdh?=
 =?utf-8?B?Mml6bC9GeFIxZVI0YU8rZmduNVlCU2I3T2xsYnRINElibmVPN0szVG9jYWlX?=
 =?utf-8?B?YmFkTjNmbncxT1o5UDJVNklHMG80NUgyd3VMMnk1YlRlV1llcHBvVHNBNUMv?=
 =?utf-8?B?V3Y4ZXNFN1lmenpTTlpqaGxXMmJ3VjF2OU9qLzZYNEk5WHRWRjFGTmFJbG1v?=
 =?utf-8?B?RWZTQnFrZlU2YlZRNHZHN3o1L0tRNlYwVnBsUGt4bUF3d3dLc1h3R2dvZ0xI?=
 =?utf-8?B?SGF6a3R5MEZTNzlWbzhIMFRnejhPMlZvQ0RuL2VaOUhnYXE4RU02V2FwUDcx?=
 =?utf-8?B?Vm9SRjYxdU0zU0E4WlhUenZoRGhaNWhOaWVSZCtjYk5UamJuNUVQTEFhNHBZ?=
 =?utf-8?B?RWp6UEFLbkxwTE9GRUNNOGU1eFJZbFdSbW90WW9sL1lMYjMyaHU5SkIrYlNO?=
 =?utf-8?Q?R0VoR/rT+YY8yOf4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b38b347e-4379-4663-f8e5-08da3f30ff62
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2022 16:01:30.5439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ox2aTtP7fL/WPyI93fZ0V6qykbnOi5fv+GKMg3rjv/WBU7nIi7tvlJfRKMS8OP4NUlK6cOYJ3G30LiS1yskSNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1783
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-26_06:2022-05-25,2022-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2205260076
X-Proofpoint-GUID: 2VSvcikmmXy3J8eUwQGgfwCCyhWJU4pf
X-Proofpoint-ORIG-GUID: 2VSvcikmmXy3J8eUwQGgfwCCyhWJU4pf
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 26, 2022 at 08:01:22 AM -0700, Leah Rumancik wrote:
> On Wed, May 25, 2022 at 02:23:10PM -0700, Darrick J. Wong wrote:
>> Hi everyone,
>>=20
>> 3. fstesting -- new patches proposed for stable branches shouldn't
>> introduce new regressions, and ideally there would also be a regression
>> test that would now pass.  As Dave and I have stated in the past,
>> fstests is a big umbrella of a test suite, which implies that A/B
>> testing is the way to go.  I think at least Zorro and I would like to
>> improve the tagging in fstests to make it more obvious which tests
>> contain enough randomness that they cannot be expected to behave 100%
>> reliably.
> It would be nice to find an agreement on testing requirements. I have
> attached some ideas on configs/number of tests/etc as well as the status
> of my work on 5.15 below.
>
>
>> a> I've been following the recent fstests threads, and it seems to me
>> that there are really two classes of users -- sustaining people who want
>> fstests to run reliably so they can tell if their backports have broken
>> anything; and developers, who want the randomness to try to poke into
>> dusty corners of the filesystem.  Can we make it easier to associate
>> random bits of data (reliability rates, etc.) with a given fstests
>> configuration?  And create a test group^Wtag for the tests that rely on
>> RNGs to shake things up?
> This would be great!
>
>>=20
>>=20
>> Thoughts? Flames?
>>=20
>> --D
> This thread had good timing :) I have been working on setting up=20
> some automated testing. Currently, 5.15.y is our priority so I have=20
> started working on this branch.
>
> Patches are being selected by simply searching for the =E2=80=9CFixes=E2=
=80=9D=20
> tag and applying if the commit-to-be-fixed is in the stable branch,=20
> but AUTOSEL would be nice, so I=E2=80=99ll start playing around with that=
.=20
> Amir, it would be nice to sync up the patch selection process. I can=20
> help share the load, especially for 5.15.
>
> Selecting just the tagged =E2=80=9CFixes=E2=80=9D for 5.15.y for patches =
through=20
> 5.17.2, 15 patches were found and applied - if there are no=20
> complaints about the testing setup, I can go ahead and send out this=20
> batch:
>
> c30a0cbd07ec xfs: use kmem_cache_free() for kmem_cache objects
> 5ca5916b6bc9 xfs: punch out data fork delalloc blocks on COW writeback fa=
ilure
> a1de97fe296c xfs: Fix the free logic of state in xfs_attr_node_hasname
> 1090427bf18f xfs: remove xfs_inew_wait
> 089558bc7ba7 xfs: remove all COW fork extents when remounting readonly
> 7993f1a431bc xfs: only run COW extent recovery when there are no live ext=
ents
> 09654ed8a18c xfs: check sb_meta_uuid for dabuf buffer recovery
> f8d92a66e810 xfs: prevent UAF in xfs_log_item_in_current_chkpt
> b97cca3ba909 xfs: only bother with sync_filesystem during readonly remoun=
t
> eba0549bc7d1 xfs: don't generate selinux audit messages for capability te=
sting
> e014f37db1a2 xfs: use setattr_copy to set vfs inode attributes
> 70447e0ad978 xfs: async CIL flushes need pending pushes to be made stable
> c8c568259772 xfs: don't include bnobt blocks when reserving free block po=
ol
> cd6f79d1fb32 xfs: run callbacks before waking waiters in xlog_state_shutd=
own_callbacks
> 919edbadebe1 xfs: drop async cache flushes from CIL commits.
>

In our experience, we found that some of the patches which fix bugs would n=
ot
have the associated "Fixes" tag. Hence I am currently using the script
https://gist.github.com/chandanr/c1e3affdb06eb2e025f955e7a77b2338 to identi=
fy
such commits along with the commits which have the "Fixes" tag.

The following command line obtains the list of commits from v5.18,

# list-xfs-fix-commits.sh v5.17 v5.18
--- Actual fixes ---
1:  eba0549bc7d10
2:  e014f37db1a2d
3:  70447e0ad9781
4:  c8c5682597727
5:  cd6f79d1fb324
6:  919edbadebe17
7:  9a5280b312e2e

---- Possible fixes; Along with matching regex  ----
1:  871b9316e7a77: bug
2:  41667260bc84d: bug
3:  83a44a4f47ad2: fix
4:  a9a4bc8c76d74: rac.+
5:  dbd0f5299302f: rac.+
6:  941fbdfd6dd0f: rac.+
7:  01728b44ef1b7: bug
8:  b9b1335e64030: fix
9:  82be38bcf8a2e: fix
10:  d2d7c0473586d: fix
11:  ab9c81ef321f9: assert
12:  b5f17bec1213a: rac.+
13:  41e6362183589: fix
14:  3c4cb76bce438: rac.+
15:  5652ef31705f2: fail

I go through each commit in the "Possible fixes" section and determine if a=
ny
of those need to be backported.

--=20
chandan
