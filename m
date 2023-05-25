Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C67CC77B7C
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 08:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242840AbjEZIyf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 May 2023 04:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242863AbjEZIyc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 May 2023 04:54:32 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D31799
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:54:28 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q84n6Z008682;
        Fri, 26 May 2023 08:54:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=9imsVANK3T/NvosqLb9eEPXTO/Y1hmkCjKZ8pg3Y63E=;
 b=eNYCkjb1ZhDb9om3jOpuoMM94qKNi2x4M0J6FqcmgZJrzOtbLjHGGALVaS6UiQyA2jet
 xlY/8ojUQzbxdSM/bmpYTPpDFBdu+RSGIqxGVeI7iWpLqKfivXLX7k7xQIUk6DVOAD66
 d38tnjweyH7YqeLUh2zLbm2dzuXc+RU87liES4VxLSHMwDU+QegUqqLyspAx5C0uttNg
 l4Se4nSM52qvTM1YkbScP3c9WDUP9h3SpNa8za9D+VkYYwycX09u09/CN8GsbNSTMeTs
 ZV/ojJIc2WsxNi06mHMLMK+H7knxosY6YurRwAK1dnrnI2R4teltipVjnXx9wPq9I3uq qw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qtrxfg4gs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:54:25 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q8EROK015734;
        Fri, 26 May 2023 08:49:24 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk6p8mqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:49:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QqkNz1Gb11y79FOS0AtVyJPsGt/2saKipAasMaCsbR8VyeQIgjo1CMgvClWIOQJI2X+qrjGFXl+jt4q15juU1qgAPgg17NBK+WGC6Pg+CXZqlO6dv0gbg8w+vatdCQiTUA7/BFQvOpJenYEiPsgStvumgH9EQyujd+Kj2CNmZbkXzP5JrSkZGoVR0QUpHVi2hqP5M7qLSJ5gq072Obbz55w+y/S+80EH/7hSn1Krp4RaMrrEMRjIBbA0wlXIAgPOpQRWSRIm90kzNZOe/a2dtBeRmplGIILi9QEDGZ10j/s3GpxS1cZcfZn4e11US0/EcvPj0221Vg4TpGn3BUzE7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9imsVANK3T/NvosqLb9eEPXTO/Y1hmkCjKZ8pg3Y63E=;
 b=PC6dqfCyy+NCc3lS/GGgK66Laa3GvJGYJFUOJXYK8EfhBk5+gCg+A+UWvKLpEC0ODlkswKWpPvSniXZC9pR7T8f1zpjl8ppr3mblaI282hAxWOekokOUu1CU/DMw0UW5H7R7IqX4PUTAeM/HwA0y3tQB7bG5x/PqrK97MSZIt1BfZVDWOlL7WdB/NjMoTZ6QpLAeGdL3BighzZLXDIQU7FDeuT/TZOzZZD+pZ5UdUeMGPnc9liLxR3TxmAjE5FZ5Dn26xMxsLuM6CVJKXQyX7ZVC0UAA37SzsI9yzMOsdQ0OkU+vgLn/UTwyhA5udkGlUSV5dymDNh5tbFSOxgFTYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9imsVANK3T/NvosqLb9eEPXTO/Y1hmkCjKZ8pg3Y63E=;
 b=uft2XerOhRjKMYF+fIHPgUatu2/XnC/qMHUOaD7BI3JOF4z9AdWBGEiidnYRmRXTN+G07jDwAw6iznn8ICgYYCwO0g+AqkSa/jqVUm5oZeXqhM/GqEulzD1HfPlhfeqCTg9foEqYc3lxFF8dC+eYx/OnEakDkqZyxEo0JT/xiBk=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5182.namprd10.prod.outlook.com (2603:10b6:5:38f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Fri, 26 May
 2023 08:49:23 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%6]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 08:49:22 +0000
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-8-chandan.babu@oracle.com>
 <20230523171342.GN11620@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/24] metadump: Postpone invocation of init_metadump()
Date:   Thu, 25 May 2023 14:15:11 +0530
In-reply-to: <20230523171342.GN11620@frogsfrogsfrogs>
Message-ID: <87ttvzjx4m.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0206.apcprd04.prod.outlook.com
 (2603:1096:4:187::21) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5182:EE_
X-MS-Office365-Filtering-Correlation-Id: efb05774-7301-4479-f84b-08db5dc619db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QDXYW/612nYFv2KQHVCiHps7gvLkmXSncDLxa12XM2c4xAhYZ9SDXwb6VJ+UzGESe5HQUAgL+fBm2QbBW+gFMY1I5xHMPUZ8in7hAp7uJ7pUzMBwe1Ox81BUczEmkpxLxfPERQcTqPlDaMLZ8cAU54ccyZftPhT3jk9hIUuxmj0jMov1IYviP6WyVi13Y5FkoWZzprmwiNR1e6QbKVrS2pKE0ke3hW09flJFzA3nDfxRATuqAgNl1gwrb2Ev7Ax4BgHuvOwYuXt3YVCWp5aq98NHnV3tlaMqHTmhJvsQ5Onp8huo0ZeCjg6U4YgX4eYS6eH+MOdQh076Ftxt/aWYw6ygwD+rMimkxXIPn0EO7Xw0rd/xSvrqLJWyL6ttVAvZvHhZzQkP+/VqOPVT+KLAO4xb2gbwODQc7R3mkKjd3HlRx9RVwq3Z9QcjpZmExlnNcWWlk2UpZKMPtj7Ok8KQs1GHOjvDxPaWBe0rWQo1E2O6XIjhPMXlCYpCjabxt7bsVd06YBfUAnirUApboxu0Rm10i2CVXOkSfp1sSTrPe+dgM7o/D/1ZUessbSE8Ig7B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(376002)(39860400002)(396003)(366004)(136003)(451199021)(6666004)(41300700001)(6486002)(66946007)(4326008)(6916009)(66556008)(66476007)(5660300002)(9686003)(6506007)(6512007)(53546011)(478600001)(8936002)(316002)(26005)(8676002)(186003)(2906002)(4744005)(38100700002)(86362001)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WVDfO0kYowaeJHksEGbG0/uoiUiZDpzILUCnjxDsiQSvqeuDJ1wQcg6rKTJP?=
 =?us-ascii?Q?izc6e31csmbIqPrvme+m8VehGMG18Hfwt/P1QKttQwx4CixsgWfYp29LfKiq?=
 =?us-ascii?Q?g0Ew6uDKzmAB7ukgkkOTh6zF07jzyClsXJFdJHDY3wZyElAUDwOa8DNoEX4T?=
 =?us-ascii?Q?f+q5J96ZRBAcZJvKDNaMTnQ1rwcsc0WpAhug29pOFHRKvThr22QuYtEBgvz1?=
 =?us-ascii?Q?SE7nj2fBpNJ1hEeVTQgRLbmDifdZiJvs1Y6eSNoOuLbBuDr2T50WX1+TaM7T?=
 =?us-ascii?Q?aNplUWT3RJNIpfrb3/XZ+xT6l1jaltm3RcwhX0NxaZowrSlIr7XlizaYClKJ?=
 =?us-ascii?Q?diC/7gQbi7R5bjYbudASYcHWjXvDVTnjolz40rKlgvgCxKVnPnn1vv/IWCbP?=
 =?us-ascii?Q?BDlNKLJo/cSV24Gs6l2EjGagZWl49FARWc4v20DoakrehZLQI1DmAxO+FUq2?=
 =?us-ascii?Q?L7eIZ4P+VFw/uwLCp0uvUbA82lWXBKhb1kxtbo0yxOYFj31q1LZeZ3YJ0tMr?=
 =?us-ascii?Q?YngV5HaLJXFQ0yOI2wTHjLaXdq9CB2U8p8o/Z9stP8S1YtoJwVrulN23NGWE?=
 =?us-ascii?Q?GVwL5NE+3f6GAfCF8g80t3o+17k7IasFKuKWiagEFb1kJBojC05tTAd1e9Lp?=
 =?us-ascii?Q?MtiJfOWjd72xoE5brsGf3/sv7haTaLDoGRbVdmc2GbejfIm56dgT1duHqFNq?=
 =?us-ascii?Q?tf8BGwYxTVR2eEZOM/6vgmS7mLdMAYsp2GHOhnHy3H2GYdjiHelrZbz7zvgh?=
 =?us-ascii?Q?4Wrrm9D7kzXCQ3096isbKjXyVsb2nnh+iGh/WqUUMO2iNvqbDS07t7+D9g8+?=
 =?us-ascii?Q?7Nj4aO6wUe1KNPVZykshFoO3dTz+lWm1UnZKcuXxK/ZBPi2jS+jNs8t5TRgZ?=
 =?us-ascii?Q?M9WO6Gr4l5/ESMjzapRLWA49lnWG++x23N1I+0mGZNTya/apkaEE+lcZRrNL?=
 =?us-ascii?Q?07FDOSQ7KxW2KZXH/AYErgwdzlrnbfuHRMC3br+Nkr7WtXfP+YQHILkP3M3u?=
 =?us-ascii?Q?fiNiBqo7p3DTQNN6hSgOZsKAZHibn1FeSEDJHuDlg8+U2nQ+UBm8+Kz5YtFx?=
 =?us-ascii?Q?vu8t9uxsOB0AxjyvG2nNgPbdtweM0/SsSVi9yrHfjtr46WCPXdqk3FnRInLr?=
 =?us-ascii?Q?XsgQO7ZFex7HBqa5vlE1oVsSNtA6y+OLHV0bpVKDqjymIhpQEatrdCfeIlDY?=
 =?us-ascii?Q?PUboQdwIQmLSH7Rv6rJyWqKBR6iIW6Lpf5rVeNRazDgCNiw33/k71iQbU5Mx?=
 =?us-ascii?Q?yNisH/mf33gqIqo6Y4WB8V0c8F1x5zkavhRCt+UTWmvxjZCCuINSrJbO/R6F?=
 =?us-ascii?Q?nBeVBrksEPPkL7R6FUZOhnFqxA2mfBagIaTx4QSMrWu2CwMFRqzswV7fFv6Y?=
 =?us-ascii?Q?e4fLshsUjnJ0RAN8pm9b4qzU/NDI2tMxt4LRwruYHkm3w5APbIz8+GgB8Um9?=
 =?us-ascii?Q?qWlc+Xon6d2V9s4SVaXXjudLH0hMEOtqmCAopeOzfeA8C0MdlRO03mUOEM42?=
 =?us-ascii?Q?RJSL6gBhwcYLHDnQY1HKkfjdzL1/svWIyFqSfQnW+GoP0GqrrHRqmEU6oPUr?=
 =?us-ascii?Q?RaNA8XA7OWuihpiR1hcqtKrsxaW7UysagIz4JMmZ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 27GFUO7IPO0B/0hmooCCaYbGkPJuTqZiSWe6XkoPrtZlHajxJWVfGdiqyLUFMRIOiKxMQj9erOP1NPkxOswXVTJoK18TMIw5OtL3QH5OS3tupNSBKE9QzLsvJ7rW1CRsp7nbfV6rW5ajzSQY7/i76Rcb7EGgaar0Jx6JsYhmxnkmu8XI5uK3OOSoMsXQhOBbg2pZg4TztTuGIdJzqmM5oENN85gFyfHPzQnKK2lhHUv+o36usMixaZXyinjN42IplYX9WM2TiQdUMtz6cFq6jcEl3c+mK/HTzsRw3TR7jF6PU6v+WpW4Hwx+Q+T9fqE7k26Hjo9L/U+oCIQwWsvEuunDhxJGaNHAw/m5t1ZVdZefLX1MF72vKiUtGmZskvPlQjl/W9Z70OE/4K5DuVfYhBP9/bLqPBUJ1Y4hAAQlrZvbrr43UURpSVLmSxS01wO4cFzKJmXFHA+HR845URF3CeZnSjKBmXpSNmcKDzpZt2EeLQJIBp+cO4aqUMerxLIZ15k8PXFJKqdmUY6ZGityfBhJUdEgLw2t8SjX7vFdc7IA/dGq4veFIYopVPngQ3gpQvnr15+7Ts1MKSWx/S9lbsRQ5Ka4kQIzawjFk0VKTxqiKBYAFKUf0PMfnB7bUMeiAi/tfQy1T2Iehw3BWuzg83tMsl0pPQ8Vb3nGYWXo7xwoHAxu3lYSoRgdJYEUM0wYJO6rnUkcYOBrJTuR/YbMZ0mQwiTNM8YCJjRObobOf53M/+VoLvGl3MkxMcbt0vHbvVtkm1BlpHuLZ8gYkfpg0JqYHpEFmb+cFEFJ0KjDRlk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efb05774-7301-4479-f84b-08db5dc619db
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 08:49:22.3999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BbglTFciED6eJfJBe3IJ6aLDVWV+j7Dfg7KNGTqfnMOQNIwT1YxDw4EnmHwRQpGpjUDmCGNLPynN8XzOXfBpVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5182
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_01,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=952 mlxscore=0 adultscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305260075
X-Proofpoint-GUID: w1ODZvjEbBoob8Ttb-OeXfZSj8aQAWi9
X-Proofpoint-ORIG-GUID: w1ODZvjEbBoob8Ttb-OeXfZSj8aQAWi9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 10:13:42 AM -0700, Darrick J. Wong wrote:
> On Tue, May 23, 2023 at 02:30:33PM +0530, Chandan Babu R wrote:
>> A future commit will require that the metadump file be opened before execution
>> of init_metadump().
>
> Why is that?
>

The metadump v2 initialization function (i.e. init_metadump_v2()) writes the
header structure (i.e. struct xfs_metadump_header) into the metadump
file. This will require the program to open the metadump file before
initialization function has been invoked.

I will add the above to the commit description.

-- 
chandan
