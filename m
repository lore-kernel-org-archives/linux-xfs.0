Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7436AC6FA8B
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Sep 2022 04:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiISEuM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Sep 2022 00:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiISEuJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Sep 2022 00:50:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB196DF7E
        for <linux-xfs@vger.kernel.org>; Sun, 18 Sep 2022 21:50:08 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28J0xRno017397;
        Mon, 19 Sep 2022 04:49:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2022-7-12;
 bh=l9iVWYOuu0K54+R6LraRLjX5LONn0rtFg48z9GiEdEU=;
 b=u2Lon7q0eZ+xYbaXOqtuIP4Lhio+lCZZABSQHBbIlMLohkSIaGjIfuUuxMDPEDODojtA
 FR78pQRaB8oEwfgn9CHGC2yr0bBFrZD0OtqHylNXpKcEJDhD4z0kyxn+WyL3mlAP01MY
 SkoCugivvdLIRul5KqslLOIHMqUutXpLiPCETJ++mHyCV1Pf8cVzS3c37PGzZcq8zc8G
 COVltBfwbgZhv3ibWejaG3OR3yHJXAJesft1ii/5GV9JIStnBfxA7VHCX6eCM9n84dE8
 MnUSFqmoHgmATzyqR337OYfismyDviJxmVybLY0l6sDzmmV6PzIBWq/jTq4chxUSRSQV 9w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6f0am08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Sep 2022 04:49:57 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28J4gv7h036256;
        Mon, 19 Sep 2022 04:49:56 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39bvurn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Sep 2022 04:49:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtAj4weNEJx2gEpRS4Cpnur9Kb0rSmEslvqbWRgwegmFR+cLqEoZN+zh9AeiOOn/vFcll8MVs6pUd0qNCNhmPojodH4hyly1OEcmLzW1BC2agiYjvAZUSlZBf9GPA0C6mC73hycKjYvG6sEkpRjjISQ3qTduHi6V4I8kD4kD+4VsQJGVM96CRxK1n7RWSw/mYkKHypEmCNWuqymcG/s6sj6zJdMIQ8uv6jbXnSkgDvp1SvQnqHu5OBWjkT4JhlkdiipFUKXXKyDysXtSTTMpDJyENzf8xN/ccS05Ovfwgu0fyDZPPBx33PLvGGOOfNkzS/Rw1mxtbb+MmNYGiV5CxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l9iVWYOuu0K54+R6LraRLjX5LONn0rtFg48z9GiEdEU=;
 b=VcuESbYaFtEPtLV+2GJ4HFQMQb6c282fssyY00TbmYaNweVp7/nH/lSS44zHPOlrbIbWKxuuLyzPxoYtl3O0kDI8+uMZUKFDjQFxK4Jv3ZGb203gCJ8R7JZ9RfiCv3L0XFiuMi8lok99Giu7fskNU8a8YiZt8QNKgh59a+f5TuMEclYeQO3Qd9UfPunOD7xk/OajNcfy1aAQHmN1L/lX4w/vNTHDrIVXFt7/v8DaGPgZzU7pasSeLWQt/wH2g/53mwog4+D4SUAZ9NifM34S/nZSExd7K0jMtWVctui/WPrvw21nfx6xlX4wTL+T4fTChe7CKvIO26/g8tlKeS5nIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l9iVWYOuu0K54+R6LraRLjX5LONn0rtFg48z9GiEdEU=;
 b=ln4CBR6csOQIS2zJvtLh49bEs3NHL6EvWHlY2L4SoQtT65CrwOc6s6wCIWFIv68oSbaEdNgGna4/JFtSLSlfbmDUG+AwBZDyCBiulHbfH4X6tZPFQ3EsDvBpMTTIfedrEVg0hO/On08JangvJVVDadtaid6HWzjO66HEYmAKJGY=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BL3PR10MB6162.namprd10.prod.outlook.com (2603:10b6:208:3bd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.16; Mon, 19 Sep
 2022 04:49:54 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::48de:f59e:c3e2:44f3]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::48de:f59e:c3e2:44f3%3]) with mapi id 15.20.5632.016; Mon, 19 Sep 2022
 04:49:54 +0000
References: <20220912132742.1793276-1-chandan.babu@oracle.com>
 <YyIi7NvA1xHylhoS@magnolia>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 CANDIDATE 00/18] xfs stable candidate patches for
 5.4.y (from v5.5)
Date:   Mon, 19 Sep 2022 10:02:00 +0530
In-reply-to: <YyIi7NvA1xHylhoS@magnolia>
Message-ID: <87leqgnf2r.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TY2PR04CA0017.apcprd04.prod.outlook.com
 (2603:1096:404:f6::29) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BL3PR10MB6162:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f03500b-c9e3-425f-352d-08da99fa64f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YkM4Bu6ojiXxoOvheWh6HhVc3oD+r0xAHqdWQ3gE3sZN2fnMZ1fLsc3BTZaDu9R+/wC7Po/pj2kRNiS6b8beEgLzsAxChaQuANbjg5UnitlFPTPZTRxWb0LCbPeinM8j8Gw3js8oLScZwDyVvnE2Z3iB5Bwn1AUSRBcyQpH6mE7/if7QgmAXlysOd4136d6sCVRFucu903ebog/T+5iuDIpPgCnyPtUBBIzx1XOTp8870rLDrAppzM55slHFH56CtlUT9iiAKw5KGkEFVlrAH/tUqlfNRxOXkxfig1M0S0MPF/lUrFuDRunr7F7Rlxu9O6fm14zf+X+gXxoyKwqSldZDhjQprJgtC20mDU706InhBdR/zwwdcRD5n1OX2VmHWUXEtX8zOmY+dnfTVLdYOuhBprjJY0rdzBlZKIbfrLu0h5rWXL0p4VUiej3kS3x6NS3fxE3vpaDmnWbQenWhGVzaOf5g4VXMcqyvfNquQnXx2AO6n8F7xYHHBWLY175HJuvVT6DLOHUgpwtE5WF3UCJQqJ/x16nRom462IrY24kRYcGotZAWR/+2UWRk0sxXcIvALmD7UeE2g6V3ffxs/6emZFlOgXVBUn1ugNKccdNK8pIs5E36aepZqD6b5N5h4jplS35EjhvdqKEaHonFUx4XVKIkm+1y1c5wV3qyiJuuJ7dBbq7Wy1bGXqZ6aOu9WExtgu7iCwgjXYkyvLzS1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(366004)(39860400002)(346002)(136003)(376002)(451199015)(186003)(66946007)(6506007)(66556008)(53546011)(4326008)(41300700001)(8936002)(8676002)(66476007)(6666004)(26005)(9686003)(5660300002)(33716001)(6512007)(86362001)(83380400001)(38100700002)(316002)(6916009)(6486002)(2906002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cKyRZHi7bWSPCzBLToKcXzEL19ttAmFcxMIvmio1R8hZSbVZ+RzDga4E5e2G?=
 =?us-ascii?Q?GZUdCFX9C0ieAaOoJB05AHnMiJydJtZE+KDP5ZeHR/xWV70HZZ2vPfjqmTjS?=
 =?us-ascii?Q?a08zCj+UMm2r3SXBA99L2Qg7+4WGa49pirmXPhjZLnW/STkEqlXRE31GCazD?=
 =?us-ascii?Q?Y3cdVKfh2QfQr85/XFbdhaCjiwzXYeq8mlM07I+nVmTVm8gAB+Gldzwx7K+L?=
 =?us-ascii?Q?ZlUsXTOGUGQLEOcHgVORvWb204Mm8/DLrcjtY6umbDD1fwe6LLcrQX4A4HFZ?=
 =?us-ascii?Q?K6TKMj0Ym2GG0fDEsRiu8L/YLOWL+N7mnhtv3y1yARd+Wtfvhkctxr0m3h13?=
 =?us-ascii?Q?DmBpM9WPve3YucWBxQSqyDootP6+c12MVyWXhqb5VDcCL4rIIhpQYTYji8ss?=
 =?us-ascii?Q?Z9gI4Ny1VZPE0zVEL47dVFFWOLuStSgagHgUWfEIPfaXvbw2vEed526s5wmb?=
 =?us-ascii?Q?y8rW7ZQsvCYH/ElZFGeNC17byB43Y6Oms+3FCErPZ4OOHQb3qgFJISUwO4Lh?=
 =?us-ascii?Q?ixkXBL6/ev7uOEr5Cfz6omyscR/ZwSBn9DLJ4oi5c2SY17NpTNnFasr6xHqB?=
 =?us-ascii?Q?FmAizoyDL65l+x3K3SSh+aG9Bp8eP9trbtFvbQmwM4AHtBCbagir7nydBhwT?=
 =?us-ascii?Q?I6myff4oYFdnl21DnWP59U1moDopPmOM+gqXHA81Z96+xxHdgtvJHNiYRcM6?=
 =?us-ascii?Q?mFs/PDCkHsqP8bFzouoSR+BQ836HMRK/gv2gPzmjPDL8J57cM88B8f+twms9?=
 =?us-ascii?Q?l3FrRkyKH7S3Jqlvsh9G9F8QAP//UYRGfF1jBguScYlJXgW4G0yl+kfY4sh9?=
 =?us-ascii?Q?2iZQeBI4YduDTg4NykcVMyr1LkjpU1EN3tv5jxoI/fogs/KJbKUP8CbmD5gY?=
 =?us-ascii?Q?4jiG59eSO37y3bjqn2QnEx3DSHrsd4q9KWgfKclMEK8VE/5BOb+UzzDMhvkv?=
 =?us-ascii?Q?JpIEzMruhAtzawB+UXVv72R9NKF1KGG0BUFqqk/NejcZHMmjvKF/maIuVoyz?=
 =?us-ascii?Q?xH5ENUbVJO+vDgqxfDt3SUK3KwCgtxofCwhNtT6LNII0UPk0RTVaHNwzEErd?=
 =?us-ascii?Q?XnvQEJ8KhMb7nQZqdAnyHBIZmY9pBI710u5DyoSM+yOGNuW5+PijB1pG1gbe?=
 =?us-ascii?Q?S43FXwTsdXHUTaK/jLXlFCi0+W7bs9clAEbFnD2+Rxx6D6wBs3mz0ipcbHxB?=
 =?us-ascii?Q?YRaP4tTrcIqaTe8ynTk0MNdOqJUKK93dqM6coXnfKVhTupxf1IPq8t14N7Wj?=
 =?us-ascii?Q?2lQ5tPy5mmjfVD+ZnZmGZPMI9DfXHDRZMZh2JNpgifx8LFLcn8T+CLv8F3tG?=
 =?us-ascii?Q?XfhyEKqJ3ltMlX3Cd8BEBTfxgT93Xn9hFIhl0F6eb5UEVXWf0dD5SgkugbG6?=
 =?us-ascii?Q?jtdYR/lA21e5v7Y4VKIdGans1sRyjgQjXxHqXk3LD+IqnuwYS4hYYfIOyg5H?=
 =?us-ascii?Q?cx3hAaErITIFOb+3IdcwIe4hvOpDhG0IsJ+XR8+LTANCYgLqNUEfA21QF5C7?=
 =?us-ascii?Q?81CLrrpH1RASsXuhxenB9CmrFuvEYIincTh9MhwrDVobAihDHJyKWzPY/Xy+?=
 =?us-ascii?Q?fZou+woHn3Y99vvKSK1Zsh7ty9WsxSUuK1UL3GPK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f03500b-c9e3-425f-352d-08da99fa64f1
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2022 04:49:54.3873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ai/Nk3v9857hsrq9RoiSG7vRTvgMis9ThfS9dZ22mLMJScWMZ985kz9yV3uKufGsbLdll/Mm1MaIqM/NNrwfWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6162
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-19_03,2022-09-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209190031
X-Proofpoint-GUID: fHz-ipy6uNjE_uNMQYLy3aN008Gu9ZDn
X-Proofpoint-ORIG-GUID: fHz-ipy6uNjE_uNMQYLy3aN008Gu9ZDn
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 14, 2022 at 11:52:28 AM -0700, Darrick J. Wong wrote:
> On Mon, Sep 12, 2022 at 06:57:24PM +0530, Chandan Babu R wrote:
>> Hi Darrick,
>> 
>> This 5.4.y backport series contains fixes from v5.5 release.
>> 
>> This patchset has been tested by executing fstests (via kdevops) using
>> the following XFS configurations,
>> 
>> 1. No CRC (with 512 and 4k block size).
>> 2. Reflink/Rmapbt (1k and 4k block size).
>> 3. Reflink without Rmapbt.
>> 4. External log device.
>> 
>> The following lists patches which required other dependency patches to
>> be included,
>> 
>> 1. 050552cbe06a3a9c3f977dcf11ff998ae1d5c2d5
>>    xfs: fix some memory leaks in log recovery
>>    - 895e196fb6f84402dcd0c1d3c3feb8a58049564e
>>      xfs: convert EIO to EFSCORRUPTED when log contents are invalid
>>    - 895e196fb6f84402dcd0c1d3c3feb8a58049564e
>>      xfs: constify the buffer pointer arguments to error functions
>>    - a5155b870d687de1a5f07e774b49b1e8ef0f6f50
>>      xfs: always log corruption errors
>> 2. 13eaec4b2adf2657b8167b67e27c97cc7314d923
>>    xfs: don't commit sunit/swidth updates to disk if that would cause
>>    repair failures
>>    - 1cac233cfe71f21e069705a4930c18e48d897be6
>>      xfs: refactor agfl length computation function
>>    - 4f5b1b3a8fa07dc8ecedfaf539b3deed8931a73e
>>      xfs: split the sunit parameter update into two parts
>
> For patches 1-2, 4, 7-14, 16-18,
> Acked-by: Darrick J. Wong <djwong@kernel.org>
>
> I don't know why patches 3, 5-6, or 15 are necessary -- I don't think
> they're fixing any user-visible issues; is that so that you can run QA
> with CONFIG_XFS_DEBUG=y and avoid false failures due to bad asserts?
>

Similar to testing upstream kernel, I thought I had configured the 5.4 LTS
kernel with CONFIG_XFS_DEBUG=y. But it turned out that I had not enabled the
option. I had to re-test both the unpatched and patched kernel once again to
make sure that there were no new regressions. Sorry about the delay in
responding. 

I think I will drop patch 3. As stated by you, the remaining patches are
required to prevent false failures.

-- 
chandan
