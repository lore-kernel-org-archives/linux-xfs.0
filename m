Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43BD1C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Apr 2022 02:58:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353835AbiDVDBs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Apr 2022 23:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiDVDBr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Apr 2022 23:01:47 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACF83982A
        for <linux-xfs@vger.kernel.org>; Thu, 21 Apr 2022 19:58:55 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23LLUPiq025975;
        Fri, 22 Apr 2022 02:58:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=O0dvsZYx2GUmAnHzKTkkcZSeCkgMUBRijPqxsQwucz4=;
 b=AZa47qgyBF/MldITLO6u9uB42m34ucpnml1hnz3erBMOEBPAHsmGfQ36xGPm20EG/krF
 Y+fV3mvo/I05F2UgBFj+oTx0Wlcp6HwotGu4eSEq6+jc0IOtkUmWtRr57PTg0DqowEkP
 exQ8gPrWiRPt+BlKcdRvybzbmLB1kMPSJ2JqD++/dkXD9zmKT8MnzsiaWQrMHgXRPWrT
 2BNhDjhfHq+Qz/fCOwrBh+35/a8GuKt+P6qRSEmU518cY783RBW980mxFsmhnPgdruyw
 zxVZbP0sZ5m+/sHWiP4e9O9itvNz+m7rk2bDtQ34dpnvWY78dCTXCJWGP1Ua+GJy5C3v Xg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffm7cw9g4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Apr 2022 02:58:51 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23M2prZm038324;
        Fri, 22 Apr 2022 02:58:50 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3ffm8a428a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Apr 2022 02:58:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LYvylHKce0yOpVhqacYwlMkaSUIQWAjtX8ni/aQhehogOR6wSvv2Vn7eokSy9jKHIi7wlhkd+AWjj7VmQio3d4T3WHEcIuoG/BXbhu5/hhr71SH58YPYskKDrEC/8cc4pO99viuV4BIJPQg8DXziZWEwTxcxXlfc1z8B/tPMwgfA7vYDp8zuRD5B9fTTmRaO8Xi/EvV/Led4wZ5EERhcfV+WsPy0pjRBzZ2gB+IwFj8ubXlFnFHvfZyQ6IYd/JI760haVJ589rtvRMT0dAH8MtWwjNkkGJ+1PUky7rPc0rvuSrWiwXL2l+EypNj/oGfVbDtfVHFza+xNxZYLOqzyxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O0dvsZYx2GUmAnHzKTkkcZSeCkgMUBRijPqxsQwucz4=;
 b=MiV5y9MU+onqV/4CpVcOCaHTRuS0hq2BIr5wqh8u2wrxINscDfQ9wcjCG+ik3JRW/vyuhk0iolAE2oSAT9VvBdnwCxLekhuu6eCaXp5M5yNoFGzjd4U7T6/WK8jD2+zIn7OFTF/kprLiNGbseAHz9XrWuuuM6f7TwCRftwE3Ua00SmQm/uqXuqWhQ6R1xuEaVuhfVNNL0pPp0N8rAIh+CgF8VMgFSBrduhXw03WGER3uH9a8lifYdrewzUjXIKvZp5BgU4+5StNUlioteEOyM6noAX6SOwIhcVazOsp7C2O690sU+ULYz2boUf7ud2ZNJxNP//0aNgq+Ko5FWQZh3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O0dvsZYx2GUmAnHzKTkkcZSeCkgMUBRijPqxsQwucz4=;
 b=Iz/DBSPgUxYsGn4P5rQ0yxfTsdKmF7nOKPQc1uxqu+X1c6IBJZdqCx9QUVli8PGZPO+L0tImN+D4xLmA7EtCd160SEDtj47QuyYd9X/1zJBCqNAd6vbMHbusFaRS3AICQJDTx3nlt2smPnSWcF6jL2UkPCJbKADbivExWQQRaS0=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by CO1PR10MB4627.namprd10.prod.outlook.com (2603:10b6:303:9d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 22 Apr
 2022 02:58:48 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::9874:fcc8:51fa:8fb5]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::9874:fcc8:51fa:8fb5%5]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 02:58:48 +0000
References: <87r15vouta.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220421225838.GU1544202@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [GIT PULL] xfs: Large extent counters
In-reply-to: <20220421225838.GU1544202@dread.disaster.area>
Message-ID: <87o80tj02q.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Fri, 22 Apr 2022 08:28:37 +0530
Content-Type: text/plain
X-ClientProxiedBy: TY2PR04CA0011.apcprd04.prod.outlook.com
 (2603:1096:404:f6::23) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09919d0a-24fe-4337-3ab6-08da240c056b
X-MS-TrafficTypeDiagnostic: CO1PR10MB4627:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB4627E41A4B7D88E0ADA0BB0EF6F79@CO1PR10MB4627.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 82af6S2yZ2ONfhNww86GvcjlnefNao19a59d4voEhTtg2xX403EuGmvkGJ4IV2ezITQY5+zOaadU/HnYRQb1Vtk10I0mKaaOszHTe0EtdQPPZCpLkl0Rf2zmkb9Gl+KzvWUr8WMLJcTs4jZzo/Y5qIX1q770UdOZh5zUxq2qJVqf9TiulTmNW3JLfw5HRE3vSMbv44UT6clI3MaKSpwrDFgrUgOGKGMIoSVhNg1SWsaptcC9kWKMTZCrNpCfLF0JxoUhlDJw4pNgEuavQe5zJ6p5ODv4a0giTfBaiCxcO04nvNb/VNo1u3OIPW6UrR5SuXW7ZThsZCPGlruFEv5LjIwjTETjShEAm23F1IhEVcAQnpE8N63BkZTVyXBZrKHNrJQ8jaz0M0hptf1rXahMrHMnIukLOPOXry7YlDefwVUpVFriK/RNe7++NwwbBbNTd2QpjHoT7Pz1etF655UdIZ80Po7W94GEjiIwR5JNf7RQ1xLvLpLwKQpSVEkTPJ/JiIEcAU69IuW7HbGdd2XP2435UCuWzwjBXLy7BHXgVzNjdetmn6MsPeMT09d7QmwOGwtI7gzfkjvGDXh4CqeA/1fBf1AtJdXT0hCBb1BnEv/+3fMpC/kHCv/P+5TtdA8H6rUmu32qGtiE4Ya8nn/FQckFXUrZzLZiZEwJUsPbfa8EJrfs8MVwJDOxysNeacsWAZTEQhi8DW/EdIVFuBvBq3L5UTFbUcL3BQEfM68aDs9VBKX14C3mNOiOmmx317gqj+abjt5Sd+hbyuIvy/lGpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(26005)(316002)(66946007)(6512007)(9686003)(186003)(6486002)(53546011)(6506007)(508600001)(6666004)(83380400001)(6916009)(52116002)(86362001)(2906002)(5660300002)(33716001)(966005)(66476007)(38100700002)(38350700002)(8936002)(66556008)(4326008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nFXw4alW8j5WDCRXpQYh9xeO8ha3xaDTGSlhi84gJ/Q2EUY8R8QTTHv8UkCr?=
 =?us-ascii?Q?1SZbkzJ/O7x7LyHb+ovyUG0p2U/S4lahbKx28M3fP6raDX+BRbW00/QEqS6O?=
 =?us-ascii?Q?FQcqEqrkSlj+9Ajl3CjjLYE3PbhwvrE2RidwVc2Xpsm6QZHyjhdXKFFBRfU9?=
 =?us-ascii?Q?aRs2vtFH1mh3h29fDVt6n+jWVi41ZDAJLm+PxeroPenTYjorA5UJ6OLl8rkm?=
 =?us-ascii?Q?j5FP+vGKuyHEQYVBmPAnV0xROKbyEfi981TJdI0jT6D55RM6plMOOYDoMM5p?=
 =?us-ascii?Q?a0u2yUXzUxC8LH23NCNmdwFfFi8MUjkYkcZCEMiktmDqYp9skIytOLCyS6V8?=
 =?us-ascii?Q?mMJHQCpTentmZ/8204dExNKix1O71J54usu6A4z+xCrrM8ECAGEgWyNjL9sT?=
 =?us-ascii?Q?sI4CJ48OybaWQqIb9Q0gunIOx0mhD5XXUkVSs8PuO/r9r+aOiJ9d8Abu1R+p?=
 =?us-ascii?Q?fmnfnEPDy7P2jyRMOZUcnanLHuxMzTtgLIc8dYUDrUtLyi6C8qPbNs0VCTm8?=
 =?us-ascii?Q?cpcPhuPgGOcPn4SOQy5dF+zqt351Ak0BBwu9kSCm5Mfkwn9qkgwlGszVZrzs?=
 =?us-ascii?Q?GMs0ZI76apZWbk1q4WCk2kpaS0C57HGIYyB6MgL3jP3cWbIVhLh26cAVMLWm?=
 =?us-ascii?Q?MBPGjOlitxgClA5d5SdlnkBVqAGssYD/Xkv1i2QqUV2vzDdkm4973tVunMbw?=
 =?us-ascii?Q?m8LeapkHViZrwVdvYgAp4NIAKB9Hv8X3bQNY+IMJfX6PIcBhrFX3DVkrRSPf?=
 =?us-ascii?Q?mwX3OeR4iCGJacKj1tspPTz5jwA5ZYH7A2ipfFbHE93PQXLnYabWqS34E21s?=
 =?us-ascii?Q?7BA0AbL9p7ZSwfc9uCHQs/WV5fKIKZeCZuKRTmRH9BLG2CNHAFQfJfkLnBWN?=
 =?us-ascii?Q?XCteNHK8Pbd9YIiUfVLUq5zi17vnQObXAn0+nsYuhf2A8RUXEofN7VlR5WW0?=
 =?us-ascii?Q?53s0dagQ1JKkdFLmgu3HOxqTCha3gYTOb5zFutkgaUu5jWZJzIp+c48/FweZ?=
 =?us-ascii?Q?TjVs8xxuKmtDLXas6vkISibXyVVCIPDBNaYyqDaGAMdZ7eM7MqquhrZIL569?=
 =?us-ascii?Q?2KbXvCkJX8hNxkEjdVwWd70kwli6qzWijgkcD5vFoVfM/jOp9ZyQvGJSRVMJ?=
 =?us-ascii?Q?7kOlAoD45j5KGt/QoDdf15ZJAlGpWaNYvEepmEmhSBE869Ydl6vE7oDBf5Z/?=
 =?us-ascii?Q?uWRtRRo7T2s6FL5uJBNh4l5inxbnWjUgriJOY5siPe+YhAMIjKicCOihUUC7?=
 =?us-ascii?Q?6XgUhYQsdsRpehitxeYF9Qb+mHEz9czPPmFAJj7AV5xNUj5hp4zMifeL04Yz?=
 =?us-ascii?Q?vLFeLUP9OArrWcpufdQXfotxlVnsAdjWYCy0x1BBnxH1TdmRRXU/dHoqe79c?=
 =?us-ascii?Q?ExahQojX20V0aK4inES/GmGq5B/yI3hR6G4666KigE4guE5AGSbA5tSRG5Lf?=
 =?us-ascii?Q?fqQ8XRzX7kijwed4DlczrkcRp8MXvZK6EFxKoRiZ6iKL/eQwsIz7kLbdhwz2?=
 =?us-ascii?Q?4zPAWojApGFn4A64TxZytlPuEkJxIyOQEv+pYybbxAydSSGF9PhVlh5D4HCh?=
 =?us-ascii?Q?M6LNPmjbARlJFeaz1ZnsUGfGdMdLS+GUlP7b/rv4937N+bpku4hvV0Lng7nF?=
 =?us-ascii?Q?IaHmLSJzO89NGQF7LpXLF1TNV/6Inba+A9LitQzDi4WNnYNxBPMYHefHYTWt?=
 =?us-ascii?Q?87dptpi1Tkh7E08Z0GOauPa+45otMLQcdgIh/boxxEY5cEv8otOhJ5n+5ZGK?=
 =?us-ascii?Q?E9q19hYbeQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09919d0a-24fe-4337-3ab6-08da240c056b
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 02:58:48.0322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 58WKvtQeRdfgFnHW1F166wCJxTMc7GvaI4FMV9ZOcw98cHy/hB3+cNvrDHXlHMWWJML+/u4Ztl2EoRIML9Ah5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4627
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-21_06:2022-04-21,2022-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204220009
X-Proofpoint-GUID: kUkNy68Na_ZUAiC26Lt4zdLQi3RE0a2f
X-Proofpoint-ORIG-GUID: kUkNy68Na_ZUAiC26Lt4zdLQi3RE0a2f
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 22 Apr 2022 at 04:28, Dave Chinner wrote:
> Hi Chandan,
>
> On Mon, Apr 18, 2022 at 10:24:25AM +0530, Chandan Babu R wrote:
>> Hi Dave,
>> 
>> The following changes since commit ce522ba9ef7e2d9fb22a39eb3371c0c64e2a433e:
>> 
>>   Linux 5.18-rc2 (2022-04-10 14:21:36 -1000)
>> 
>> are available in the Git repository at:
>> 
>>   https://github.com/chandanr/linux.git tags/large-extent-counters-v9
>
> I've pulled this down and it seems fine, but there's problem I can't
> solve directly: the tag isn't signed so I can't tell if the tree
> I've pulled is unmolested.
>
> If you were asking me to pull from git.kernel.org, that wouldn't be
> a problem. But I don't trust github to be safe - forget about
> hackers, github's owners have demonstrated they will modify
> repositories directly if it is convenient for them to do so. i.e.
> they have overwritten hosted trees without the author's and/or
> copyright owner's consent and locked out the owner(s) of the code
> from ever being able to update their tree again.
>
> As such, I don't consider github to be a trustworthy source, and so
> if you are going to use it for pull requests I need the tag to be
> signed with you gpg key so that I can verify the commits I'm pulling
> match the ones you pushed to the hosting site.
>
> Can you post on #xfs or DM on oftc the last five commits (--one-line
> format is fine) from your local branch that you pushed to github so
> that I have an OOB confirmation that the commit IDs I've pulled
> match your original commits?

Hi Dave,

I have sent the details of the last five commits via DM on OFTC. Please let me
know if you haven't received it.

-- 
chandan
