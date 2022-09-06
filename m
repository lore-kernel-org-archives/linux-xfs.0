Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2671FC38145
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Sep 2022 06:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbiIFG4W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Sep 2022 02:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbiIFG4V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Sep 2022 02:56:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4FA72B40
        for <linux-xfs@vger.kernel.org>; Mon,  5 Sep 2022 23:56:18 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2865dw3J032732;
        Tue, 6 Sep 2022 06:56:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2022-7-12;
 bh=xxFkoir/XTs2f+WokTY0ezenA9WeVfh0OAPSqKzjLnE=;
 b=2uozx0IwWsXAK+8Q7fByOnxAoV2LhZVvbFTXV+H5OtrWhJXaOLJeMuw8GQS+WTSfxpEw
 W2VtkPjH3tyygqprGL9oXRbZiGGHlVHkMhp30xkhHKMurb6tF20EzzjfLVZX1pHNuUVf
 QwD8LOppiXiBR9lP/4VLqQJVikaV5WYsrlVVqM2EX78euvnsoGvabnR4PqoNcP65HVdj
 vryxzugCT+YDZpy3zfMJU/qwwazv7ZCYuTQEqEzcIAOI7bBx08avuyoVJK27OQyXOcUc
 CF/oWC9bXwpiEJgbR4/Radh+jCLRP/0TUCSArSIELlSGzlNn1Jj0+VjdYwB3co69LN3W Wg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jbxhsmtuk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Sep 2022 06:56:15 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2866KDcM037608;
        Tue, 6 Sep 2022 06:56:13 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jbwc278pc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Sep 2022 06:56:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fiN6rNTLDH5GFacuGIDT3prhfUCaiM0ntt7vo3Z+jIQkubF8o5Jeu7EmIIJGRoaaMn/0QGsxO6hdBkYnwbEHKPls2JToMZSpI8pqCLnCPEv+JlI2fnqrZfz6D4LCiflosMHBYW50FLlmsmXTPMNKWEGeVPOsb5JLyIWMcgrczWcIkO20I3KsHatiL7sLjPzl0PPu7lMpIoRL2nmO8TEQIBSifFCrbudClfkezEqQMsb+zs6Z/Ho3kZXT59W1L0yf7Sez+JsIwS5naZhd4iOan33XqRmCBHBVWIdoCjE4whIfCwyo+p76M8aDM8vYKk4DMm+v7qxRbscd+db1WldErA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xxFkoir/XTs2f+WokTY0ezenA9WeVfh0OAPSqKzjLnE=;
 b=K7pa15LzamsNR4abMQeDWAfFZTUjLIpzk5RUBZCKrH2bgdkPvZTmIb2/SRTsiv0LmUOeSKpTlJSpZ+A9LkG07p2WyDVaB80gabTZuZfKQ9bRxepJCxYqGNm9hlF9Y8a0BAHeztVBobj6zQPS746x1mGni0T6WnUOLagQ1RH42MRnxVzE4w5AuBU21h46JY5Tj3BNwSMxUj8BwTO4pj+9d+LEvEix6a5nH2xRvh1CN3U2oNOoQwGjbOe8ebNGQTwRKFeavRsl9Wb1Ha/E3dBg9suJomejXIStcsnujNzUhp29UUuJjnSMbiEYABzTxNlSUc5u9A4hznj4V/5qPGhN2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xxFkoir/XTs2f+WokTY0ezenA9WeVfh0OAPSqKzjLnE=;
 b=PQFrA0/CNuGX9SQAh4C4x65wqm+AQ5UBD+mFTvzvYbxbJeEYuERD06/ej/0G1EeFzcJyNHMw7iInZix1X24zVdmt6/82rzDzKtJnPQXDNqshdMPqUBGygEC5A7s+pVHJd6QKJGv1ZJ0pZ4RwXtTSRebNfJrti8geRDx+Ivy4Q04=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH7PR10MB6532.namprd10.prod.outlook.com (2603:10b6:510:203::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Tue, 6 Sep
 2022 06:56:11 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::552:17a1:f9b2:eafc]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::552:17a1:f9b2:eafc%9]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 06:56:11 +0000
References: <877d2np6im.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220902215516.GX3600936@dread.disaster.area>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Creating written extents beyond EOF
Date:   Tue, 06 Sep 2022 12:25:00 +0530
In-reply-to: <20220902215516.GX3600936@dread.disaster.area>
Message-ID: <87a67dxa7u.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TY2PR04CA0023.apcprd04.prod.outlook.com
 (2603:1096:404:f6::35) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c90bfe25-dbf9-4bc4-7fdc-08da8fd4e1c7
X-MS-TrafficTypeDiagnostic: PH7PR10MB6532:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9HHTN+/yiucw0gp05YP4pYIbXSB3Q2Q8NscmYS9nnxsjz+OZnMynq2s4ymKrzCUFAVQCR7qZXPK6fjA3ulXaK78QQhFFHyJkPttp/vo1MCrtkoC/Fj0NjQXhg7rrylSudEUwfXtXnIqByRykKJWEFUSIZ5asR8318J1UN5e/Yxlpes28iN3Irjho//u0UGeltNf7DmmWz5pw+5XaGe9UpjFkFwBh9NPIu/w+SLvfE4wicGcxm98e0QgPw3StjcSo/AzyXfDLjKdRsydPYPEfT8Aza/Ik5awgH3gTgsAMeMbA4G1g2wCY126SAxDahYBwhrXeMVLO11U5Y2dClxtWfDW3jTCq10gxLrrOQb2yNBritVy2eNJFTcHJGRJzpnh1slBUuR23wTumfjyuTFlNVc0iBhChRdOUHojY2HLTZ/2cJneoWe+n6hhAUC0S6thCdadP7/L/42boQP1E9ua3nWNTlFpA1/Dz8/wpfv+ENhiVQUWWX3hicebpo5/u4EqYIHkXqx+2zPjHQLFBOSxNS86WJ1/98nExiylVZ0HLm8PbCgDZuoQnEXNs8KKlAhfQcCxU0OAnuWnj/WDu+ZpjsM2sRBedMW2X5m9iu0bt1FlhcCLffs3zlk5rrMGvdjmk1AX68E2ZOQkVli3w/+yg8YIXOLpAQVdRpWRfiaviRUTNuxAdB2grO3neNGyuJd7CCPGmPjavOrcu7xGI42S37wKCbMiXG/s+POatD1qHLL0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(39860400002)(396003)(376002)(136003)(346002)(5660300002)(8936002)(6666004)(6512007)(6506007)(66946007)(4744005)(4326008)(66476007)(26005)(53546011)(66556008)(6486002)(8676002)(478600001)(2906002)(9686003)(86362001)(83380400001)(41300700001)(33716001)(186003)(6916009)(38100700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tKffHju+26S0t2pilmxjOWSX6frMZteWYWRasbD4mSs7Igc0t7cUI0hwWZ7E?=
 =?us-ascii?Q?IiaxWbE/XcwSb1mgANL49u9r8vTaD1K3JGAvvnp+f/4iBZWWxrvzVrBpz4UK?=
 =?us-ascii?Q?cl/o7puDyrVtQAibcRL02U/pr5dZqHI2TtLAM5fM2IQVQQ09S4FVsVjg488p?=
 =?us-ascii?Q?E4EM/A1mDN6ObaL78wF3wYltAirTMed0DGOR0zc983wpDDG8hMSZO/iIuA8c?=
 =?us-ascii?Q?tE/+auvhDHiC/36GV2FeAAjx2/unJGVC+OjEp5T4bBd+D6zf71Oxwg7qKE8E?=
 =?us-ascii?Q?eDqASHVxLrdufQ8a/BwMi2XdpblTkafw4eP+6+8TcP16/kuX0yc6heMEWlvr?=
 =?us-ascii?Q?oc3eKhIw72Jp/dtc/JDfa0U7NpCxW34eO1ZzucBxlrfIC+Upxwpz7mTdwJhF?=
 =?us-ascii?Q?Pu6QVQER4NE4vfxSc245Jkxrvaq6PreKGYD8W3k0Q0ya451HGeITdJcke3lC?=
 =?us-ascii?Q?YbGUfOmSyoumA4tMxzyxmEqY28318o6W0e1nVgi8vV3K7HjUju015tpE8w9G?=
 =?us-ascii?Q?Nf9uMpiWZj4geybZ/cHPawaexuf3ZERDOkb6kGxbmupqmIyrXP/7EiNbEM6R?=
 =?us-ascii?Q?371z2FGgtPuPbQPGGL5HcvXCJXDTkFh3TPDlzAcJxpBosJfhs6cAlHHOMQKn?=
 =?us-ascii?Q?XXxLBVcG/2PaPECaUta+N0xRXrDvs889+8RMG3OCCuTT5MTEJgUq/24iNDzP?=
 =?us-ascii?Q?rj34UoQQE3cRQz21cefcnZagUjw9S1sus4TyuiwaE0vQU7nYZrMz0fx9Wt6R?=
 =?us-ascii?Q?QtHzwdS7+aH34HTU4TiAm+mQ/jp1kgpEOiu+3eMz2oOIhXqWcZ6gqq6KNqMj?=
 =?us-ascii?Q?9OuEs4zHBJCIB8v9Qfsq+0BwZ4a/1PrNuVQKmRMbTdGJHOEn2ms7nqL4umIi?=
 =?us-ascii?Q?G2SqyT+3+6RrwSBdDdM0WwbsT2idPJ4pB3aWnXddZSzbbh3ocpuWNA2/7KLP?=
 =?us-ascii?Q?R+XZWqN1jYOfHcSZVZ6v3srgD5fW4oY3afTN+FpEl7Fy4zRKLPVhyKnlLQVE?=
 =?us-ascii?Q?E5gHYCXqb0metgo3pdVwCxXBePXW3KhurTE11Odo3smTt0VSfq5TQkydw670?=
 =?us-ascii?Q?XXXvG7V/NbQc3Znzm8l3PVqoFlgcWJTMz1oZA4pQKOntnnUR7Jasg2hhCGy6?=
 =?us-ascii?Q?TT5orm1l9M6iOwxsdg8V7D15ZHSSe6yJRTNc//roym/3FkK5ciIKZwpBydnt?=
 =?us-ascii?Q?PrsWUR9s5hAuaXMJFT4yPxrQBeUVmOBr23LgHqUOoJLY0ALd5KxownopWEfn?=
 =?us-ascii?Q?ZxCuzuIYxS3ju1r95nDSHeara94Q9ZfJu6AG5VxRfvHSTYmnZtHcw5c+KRHv?=
 =?us-ascii?Q?bdD1Hsx0YRJlawaoWSQQ4+NJvsWmKmVOjxzSVEkltVKltSCctqIMcOKSnLXh?=
 =?us-ascii?Q?L3BHXw5SBZPogClYXc7CsWGhzwWZasjg/AtB78lFD3bsCteN3pXcezC9Sg9e?=
 =?us-ascii?Q?wlNH4LCfX2JDG1BkvZbHl5sWtoeu+4qV4zr896Hi6Q8gQ12BosqM8+/XxG4P?=
 =?us-ascii?Q?/Qg2vHcu2QiqDAPoBX1KWSJPut43tHkvvpfiahZ1Vx8XMyTRxUabTbO15Rkk?=
 =?us-ascii?Q?Gtswsdb1IFnHmefztrC295eOD5n4b1b4ykKZZyrz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c90bfe25-dbf9-4bc4-7fdc-08da8fd4e1c7
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 06:56:11.1539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N9VWOk5jL7UNZBAp2aphFBAgLGCaaRvND8lEViZ1NtQE/cgIgjkw6o7q3UekwkyKB+4ojvgML/0dE8yH9q9ioQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6532
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-06_03,2022-09-05_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxlogscore=985 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209060032
X-Proofpoint-GUID: XiyEyGsYUZCo9xawJuNGXqqmAmOosOH8
X-Proofpoint-ORIG-GUID: XiyEyGsYUZCo9xawJuNGXqqmAmOosOH8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Sep 03, 2022 at 07:55:16 AM +1000, Dave Chinner wrote:
> On Thu, Sep 01, 2022 at 06:55:31PM +0530, Chandan Babu R wrote:
>> Hi Dave,
>> 
>> 7684e2c4384d5d1f884b01ab8bff2369e4db0bff
>> (https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7684e2c4384d5d1f884b01ab8bff2369e4db0bff)
>> is one of the commits that needs to be backported to 5.4.y stable kernel.
>> 
>> The commit message mentions that we could have written extents beyond EOF. I
>> am unable to come up with a sequence of commands that could create such
>> extents.
>> 
>> Can you please explain how a user could create a file having written extents
>> beyond EOF?
>
> That bug fix was committed in v5.5. We didn't convert delalloc to
> use unwritten extents until v5.8 via commit a5949d3faedf.
>

Ok. Thanks for clarifying my doubt. I can now recreate the bug on my test
machine when running v5.4 LTS kernel.

-- 
chandan
