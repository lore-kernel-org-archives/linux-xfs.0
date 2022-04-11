Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE2FFC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 19:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343873AbiDKTkc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 15:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244590AbiDKTka (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 15:40:30 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0889D13F0C
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 12:38:15 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23BITvlQ028178;
        Mon, 11 Apr 2022 19:38:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=/DYli4BYKSwtiDFua7CjIgFv+5mHAfNslvK5o224H4s=;
 b=AfhPWILQSn9lIjOWIHoxT3LnTe19fKnM13+WZNMnYIhjvSUDLkUqhB8UfqV4TDqWziP+
 2+oFqcr1ERuqPF+SOG9ip+JDNETe9DfHcuQ1a7a0FQL8KOTR9+MSsZLbIbhfeFzocieX
 noKWClwVCNI2Pm7WwNzmi1MRLTsgmni3l5738s/w4Ene6dRxYNCHdXibimTqPUvczu4E
 fjhll3hp+MKFTQ5O3cN67tMG1rONx0lw5fj0sFs9JW+phjuq86fLf+/Oondi0IMGrAii
 4yYS/Ay0d9+OOU+vbl5ym4bt9T3Cg/71nESHUm5NVXtonf8LjQFTX2Y1jZr1T4TezA/K 2Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb219vmjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 19:38:11 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23BJWMDY028380;
        Mon, 11 Apr 2022 19:38:10 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fck11xqjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 19:38:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EI0GzzNpnJfVIL2VwG9dq2tenm8jLRNWlacsa36GBCZvrmj7YxjS6war7zmVurz7wgtqC9e4EvF5rnkFo2bdVgdlwfsmGG5GFcwwz4+lq5EQq9hND+oomhusw4dpG6eqDLtlVThwO/jKjAt9zgvf6YK+XaTJzdXLooPlCG3u+YvcQx/+k7CWxAOPTFVz7m+4w9mm5XjB0EQ4oZkKfAGGU8A+Mw+z5bMmzMpY/G0Ae4lvfm8/xyC8u5evI2Oev6zmhq18WbDvqB0+NFnQCdLQQSZuKw9bPBVs14c5Qs0vroUlzfy7c2CSJzsIjz70byF07LvH9DzNY90+wXyn/hpegg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/DYli4BYKSwtiDFua7CjIgFv+5mHAfNslvK5o224H4s=;
 b=n6V5IhZAMcgCZ3s1gr75w8+9k3HHSli2+siZAnNXz9vsH2oHJTlCgvu0gFkfLVLZ3tVxqdkbTXxpTqoKqE3PjkP90oOay5PpirXjLLpVEz+xq+4Jg9Ow4QUwaxrh13lSVc/BMz+TzmggmtQ45IowFV1gKV44RIHInyJCJEXkaVSY2VeLWdodSyo1lRRNv9SSXaJJnHgNvQbtqF+cGdsDQGGaiFdwQglWlxUz20qbdDhSPV00Uf5FYx1fHO+VAAop6YqhsxER+fb4kTCE8KZrYLK0Hbul0/ir/f9GRvobyX/Sx424lTnExl35BrH3VI5zUZ4tKbYuMzoYYdUiLTcAWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DYli4BYKSwtiDFua7CjIgFv+5mHAfNslvK5o224H4s=;
 b=esG/fzQwst5hQ4XRTjiPYH4cZbmemlEwZRMDPQOTsrUOM1Dq0EJSYerol76bXUlK6UErtjF1jlEx1xPv2bwz2ktDC4YCplVnE+BLxarr7Svv8XpEtbmROOmLcxHRK1N1IzngyKKqtG32iBLiu3MYZ8bTsyL1JfmH8zMi9Bv4cZw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4162.namprd10.prod.outlook.com (2603:10b6:a03:20c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 19:38:08 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::4cac:3ab1:a828:34ca]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::4cac:3ab1:a828:34ca%4]) with mapi id 15.20.5144.030; Mon, 11 Apr 2022
 19:38:08 +0000
Message-ID: <36ff0be52e2eef856dab403bdc76602e403d74c8.camel@oracle.com>
Subject: Re: [5.19 cycle] Planning and goals
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Date:   Mon, 11 Apr 2022 12:38:05 -0700
In-Reply-To: <20220411035935.GZ1544202@dread.disaster.area>
References: <20220405020312.GU1544202@dread.disaster.area>
         <20220407031106.GB27690@magnolia>
         <20220407054939.GJ1544202@dread.disaster.area>
         <ff1aa185470226b5dac3b8e914277137a88e97e6.camel@oracle.com>
         <20220411015023.GV1544202@dread.disaster.area>
         <20220411035935.GZ1544202@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0P220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::14) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e4bd861-219f-48f9-538e-08da1bf2ce02
X-MS-TrafficTypeDiagnostic: BY5PR10MB4162:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB41624E2887A118C5DF5C885D95EA9@BY5PR10MB4162.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VkDfTi8h2y8XvttlCqeZ+sUsPdcIa7dFr14hD1UDdDD+SJ8FBsXStc+03iuIjPbjsweu2PeUnvRdlAX6WN6LeJKdmTXEOn96P2A1R2ghhEPP6cQjVQa+5D5I+rn00J/aKZ8EcS7vV9ghr8tMjGpIWMMiUo3wUVF+ZbrhqHo2K3wCkPvE2Dz4JxMsJ22AcpohMdbfrJQxfSVhyHSICJVXGliDX2aGwfQVTs1XgzlEPgKqExYbs/8OQDIiKCym9191diDsKpOBXiQtu95rn/hLh72D+wEP/idqBcERmP3dNHrGCl9DXbAk3CzLODRqsIa0r8gTFDuO374N0USQDUnU5IeajuRKIicOkdIwLWuSj7iE70jCC3gnalcrBD60CYIjLxslg53BQ26AIw/FqvX//ATT3OJp7J3X1QXNug6EwsueVeZq6J/xaK7+3YJ4GPMyyJn8qKAxcfiJgYkYmcd4RjvvLL+WnUXlGTPKkm0wSkN20gO3ncA2NfAozMpfC3qBYSHto85WvfYkxz/sjmsY/xbKfjt2lz0IujdgSdJw7i3dBhXft8E9fHr+T8L5Jc8YmcaK5pGWYCgFQpZw4gjPqQ1ZoxBT63LadaNGl9JMd/7KkqZdnwqWxOzTV5VBl4xasnLl5wS2DvOogG4M7El03UFFHPisd4e9PI5UrPXm2TanuzhtdI70ikTkoOj7vCt1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(83380400001)(6486002)(5660300002)(26005)(186003)(2906002)(36756003)(2616005)(4326008)(8676002)(508600001)(316002)(66946007)(86362001)(6916009)(66476007)(66556008)(6506007)(6512007)(6666004)(52116002)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TzF5NGFJYUQrSkFHakQzekJaelB3emZOQUdDeDVyYUt3UE95ckNtYWVyK0lq?=
 =?utf-8?B?bEtWa21EdklqR3RVR0tsWlRtc21LWVhFdWxXNmNrR0NiMmlqaDZ0TEplNzBV?=
 =?utf-8?B?THhaS2FodnRYYS85OFprb3RGUUIxQlRHd1FQZDcrQmZoTVVOdmZBRzNDdTRC?=
 =?utf-8?B?VDBZMlJlTmY2bXFXSTl3WS82MGx6cFhaZk5rL1F5ako4K3hYVzNEYUdIeHR6?=
 =?utf-8?B?U1BGNmthZ2gvREFhdnBlREhCZmVKLzVoZHlTZGs4eE54WGd1aVNjenlXL0Fr?=
 =?utf-8?B?NjlJdzZ1WU93V2tHZkZLWG5pdWJNOHNBYjNSeUpYRWVvTlp0a2RuTkFxcG9T?=
 =?utf-8?B?ZVExcitXSkFPUnczUXFNbnB4Mm1wZSs3M1hmNDZIeTY3SzloanliREJ6QXVJ?=
 =?utf-8?B?aWt6enZnd09rQnNpS092cjRtZi9YMk93S3R3RDBSWWVGWDVHeDRhaWEwWW5Z?=
 =?utf-8?B?MmFHY3FEQXRDTVNpTjB2TGg2K3hpK21iUzZSUVFIUGJubndNN2EzaGZlMUhX?=
 =?utf-8?B?NG9scmRtMjlVZGNLa3V2ekpTdGVNbEM2TUo3WU5pZkh6WW4zUmR1SkUzNU1a?=
 =?utf-8?B?TFBBUmRxTkJ0bEhvRjAwY0FqNHc3L296ekRSdkRwVjlJUUFzc2hCNlVCdTBh?=
 =?utf-8?B?MXhTblFhZGYzdnJabUw4clg4bDVPRjJ1bncvc1U5UHI5dmhYdWlCS2M3Tzg0?=
 =?utf-8?B?UDBnRU1xVHlHTGZHSFF2ditpYVhDTjZsWHg0VFFNRTk5ZitaQ2VUTUdxNUl5?=
 =?utf-8?B?dHh5WHVzL2VZcGFsV1pLM2pwN3IwOW9aU3JhSS9QaU0xNDhsaTZHNTk5SVN3?=
 =?utf-8?B?cWNGbVJNMEwrZUY1OUFKeU5HOXhuZ3ZBTGFaNm8vUEVIeXJWNHhrTm9sYTJQ?=
 =?utf-8?B?QWJNK3lpTjE2WHp6eDVhWWhweExxcWczN1AvTFFPZ0g2VmZPWmE5UFpiRC9Y?=
 =?utf-8?B?bElaRGJBQytWdk9Wbk9WMFVsYkIwWmJmdmdMOHBFUW5Od1c2Um8rRTAzTmRa?=
 =?utf-8?B?OEh2ZGxEcWY0UXY5WlZ4YjU3ZURHdm9heFdCVWhNMzNFODNQWTNiSE5BOCtM?=
 =?utf-8?B?QVQwNFVvL3J4NnFpamZiZXBoNEtGMXpCOEo4R2dpOWhPVzlmUGltVHRxK2dn?=
 =?utf-8?B?NW1la3c0aWYxLzNWT3FJVW1Yb0xVUE5BNHoxQStSMHNkblBPVThjNjFwK2RD?=
 =?utf-8?B?YlNnb1c3V1VwUitnczA3R1ZhVDUxRWJMUW5NNnJvdFc0YjNxT28vZ1ZVMG11?=
 =?utf-8?B?enB2WE5RanYyUXJGZHF6cDNFemYrWU5DWkRCYlJ4WGRTQkNVR0lYV0VPRkQ4?=
 =?utf-8?B?K1JYTjlEKzVXWTRmWkJXMzZ6dzBMN1I2K2xqTlRSUnVFVy8xc2ZTM1BUQThF?=
 =?utf-8?B?MGx6V1E0Ym5aaDB6eUdscXQvcmpwbkRGOXA1QmkrOWdMSTJQL2dhYjMxYnRj?=
 =?utf-8?B?K3JIWm8zWE1pUjdENnVsVzlEVWtkRm1CRmJ6VmhMZDFzbFUzVlZzQ3lZL091?=
 =?utf-8?B?L2tCcE1aYXdsa1BNZVljZHhHcFI2S2g2WXpkemkwRzBqb2k2MmRTMTV5ZU9p?=
 =?utf-8?B?S0ZlekJYSEF3RExrZTBJeko1MFhMMVE4WE1rdDg3ai91SVllRnJoTEk5RFhx?=
 =?utf-8?B?RzI0NFdaN2N1MDV2V05kaVdDV0JvYy83MnZ2QnArbEc1VGYzNVJVQVZzeVlZ?=
 =?utf-8?B?R1Y5Q0RrWFBvL2Nkc2thZ0F6aWIycHVMcFltblZrdjJoNDdGZElTd0tYVWJC?=
 =?utf-8?B?WjFXampvaTV5QlNwaWpWb3JCb25UeS90SCtoWEY4RUtiNHlKbDU4b3FSbWpR?=
 =?utf-8?B?YnFLU2RaL1N4OG96aFRPRWcxYU1WZkdpMzVhL1dNb0JWSnpGR2R1bXB6bXk5?=
 =?utf-8?B?NDBpL04rOU4zWGNHb2JTUVAycjZpaC8zTzJGVGlldWQvMlN3UDVMa2hrYnhu?=
 =?utf-8?B?QWVlN3hMU0xUaHhwZEhEZDd2dkNqSEgycUd4ZzNKcVVETlpreGg2bmZWZE5O?=
 =?utf-8?B?ZVlaMFR2bXNZdGZHWjRHQlprMXBYbTZLT3Z0Vlo3K01Zd05TMTg5TmRuU0VB?=
 =?utf-8?B?a2c2dVpLZ0VRTU5Od2RSL2hDZzNVNml2a2hFYWJuVzhkQVFMR2FpMTk1YkZq?=
 =?utf-8?B?SnBsT3h3bmI3NC9DVmtaZ1hkTG41MXJsdFh1Wm1xMG14M3ZmM1RQaXlkbzlY?=
 =?utf-8?B?a25SU2tHZFBZNFV1cWoxa21zNEJSOWVGQXpmNENCWnFmSTdkbzRzbnlWb2xx?=
 =?utf-8?B?aFVRdVd0ZUlpRWdKc0lXT0hUTVh5bjlGbys2cnN6NjdnRFFnYU9SYjdSMEMy?=
 =?utf-8?B?cWNTOTZnYVpkU2lPc2orVE9xZlFPc3kxT1g3cTM4OXMyU2J0a2tUN0dpQ01N?=
 =?utf-8?Q?FVs0DylzGsLiYXY0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e4bd861-219f-48f9-538e-08da1bf2ce02
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 19:38:08.0360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rsgF6Gr7cDtwMSWEIq3LsOd1tBKH7BQ/z0UzwIcQnvFuWtN69jwQwy0PNb/omEAkyUBaEm2fny6mFyv2HwneYTfoHv+XhAhP7T+EbuMnHWU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4162
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-11_08:2022-04-11,2022-04-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204110108
X-Proofpoint-GUID: f8BeoV00dZ3SYDnkK-MipNAwfpXtdwCI
X-Proofpoint-ORIG-GUID: f8BeoV00dZ3SYDnkK-MipNAwfpXtdwCI
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 2022-04-11 at 13:59 +1000, Dave Chinner wrote:
> On Mon, Apr 11, 2022 at 11:50:23AM +1000, Dave Chinner wrote:
> > On Thu, Apr 07, 2022 at 03:40:08PM -0700, Alli wrote:
> > > On Thu, 2022-04-07 at 15:49 +1000, Dave Chinner wrote:
> > > > On Wed, Apr 06, 2022 at 08:11:06PM -0700, Darrick J. Wong
> > > > wrote:
> > > > > On Tue, Apr 05, 2022 at 12:03:12PM +1000, Dave Chinner wrote:
> > > > > > - Logged attributes V28 (Allison)
> > > > > > 	- I haven't looked at this since V24, so I'm not sure
> > > > > > what
> > > > > > 	  the current status is. I will do that discovery later
> > > > > > in
> > > > > > 	  the week.
> > > > > > 	- Merge criteria and status:
> > > > > > 		- review complete: Not sure
> > > So far each patch in v29 has at least 2 rvbs I think
> > 
> > OK.
> > 
> > > > > > 		- no regressions when not enabled: v24 was OK
> > > > > > 		- no major regressions when enabled: v24 had
> > > > > > issues
> > > > > > 	- Open questions:
> > > > > > 		- not sure what review will uncover
> > > > > > 		- don't know what problems testing will show
> > > > > > 		- what other log fixes does it depend on?
> > > If it goes on top of whiteouts, it will need some modifications
> > > to
> > > follow the new log item changes that the whiteout set makes.
> > > 
> > > Alternately, if the white out set goes in after the larp set,
> > > then it
> > > will need to apply the new log item changes to xfs_attr_item.c as
> > > well
> > 
> > I figured as much, thanks for confirming!
Hi Dave, sorry I just noticed this response after I had sent out the
whiteout reviews last night

> 
> Ok, so I've just gone through the process of merging the two
> branches to see where we stand. The modifications to the log code
> that are needed for the larp code - changes to log iovec processing
> and padding - are out of date in the LARP v29 patchset.
> 
> That is, the versions that are in the intent whiteout patchset are
> much more sophisticated and cleanly separated. The version of the
> "avoid extra transactions when no intents" patch in the LARP v29
> series is really only looking at whether the transaction is dirty,
> not whether there are intents in the transactions, which is what we
> really need to know when deciding whether to commit the transaction
> or not.
Ok, so it sounds like patch 2 of the larp set needs to be dropped then

> 
> There are also a bunch of log iovec changes buried in patch 4 of the
> LARP patchset which is labelled as "infrastructure". Those changes
> are cleanly split out as patch 1 in the intent whiteout patchset and
> provide the xlog_calc_vec_len() function that the LARP code needs.
> 
Ok, I will see if I can separate those out then

> As such, the RVBs on the patches in the LARPv29 series don't carry
> over to the patches in the intent whiteout series - they are just
> too different for that to occur.
> 
> The additional changes needed to support intent whiteouts are
> relatively straight forward for the attri/attrd items, so at this
> point I'd much prefer that the two patchsets are ordered "intent
> whiteouts" then "LARP".
Alrighty then, sounds good.

> 
> I've pushed the compose I just processed to get most of the pending
> patchsets as they stand into topic branches and onto test machines
> out to kernel.org. Have a look at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git xfs-
> 5.19-compose
Ok, I will take a look at this, I had not noticed it last night

> 
> to see how I merged everything and maybe give it a run through your
> test cycle to see if there's anything I broke when LARP is
> enabled....

Great, thanks!
Allison

> 
> Cheers,
> 
> Dave.

