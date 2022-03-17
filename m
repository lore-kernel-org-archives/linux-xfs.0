Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F22BC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 06:50:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiCQGvV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Mar 2022 02:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiCQGvT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Mar 2022 02:51:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA58BE2F
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 23:50:02 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22H3Dwbx030863;
        Thu, 17 Mar 2022 06:50:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=oYEVFSEgmua9sePos9LJ3oeDSg2NnRJTKiZRzenorh4=;
 b=UqICSp6MAlTv/rigoTnhSXN4GtBUU5Od7Ab4pPollxaDm7M6Qtol1vi5zFqL4hhCa5Z4
 SD+/DgeJiGofww5caxAsjDSVZyGaChUhUTjqHkhYV4sEqm+j/e5LH/BeVwWTRrsu0Dhy
 CCP+BEGvVhw2SqlzKqhL5sTnntROR2oLWd5CRlAEJJHkZDL6zjOL5I4kPceYJaf23Gz1
 ca66M2j5nZbiPMsV9pGVkPS2UJF9paH+QZlB2g60CHAqspCNeuxwIgVRFMAq8/1oAFZg
 8oI6nxOOxq3wWZaX8uWYhDJXVPx1AhlSkfO9fcpGucaENe+2NHaY5gwUjS7oBdLIM7qR eA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et5s6rcty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Mar 2022 06:50:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22H6e24W089247;
        Thu, 17 Mar 2022 06:50:00 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by userp3020.oracle.com with ESMTP id 3et659a6ha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Mar 2022 06:50:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZCXhtow15qI3++CDSOXy33MBAFdevAmMmAk5+twVB4fT+y/1cOjLY69da9HJSpzuP26ffImRqo+GXGvtw22P4WMKL09EUMtWD1EQXfF5ic9/slTOBz/BzXeMjcQJDI3W/XcU/u0AuaeEqibWdx4nbduCnb9MBgrLVOvyOt6cS0giMYaGL9DcsUN8JSzZQQ3mOjy3lyx2+TVq7ORvQYYOZT+cKqUWCLkPwJtOZSLA5S2c6FPW2ScU3i1as5UoWA/OvYoWMaNjezrf7iigygJa6dFPzmYXnAOvD4sxT7433feYeqEICwoiGxl+z8Wp3P4dvQcsA2domECcMWcnl0tyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oYEVFSEgmua9sePos9LJ3oeDSg2NnRJTKiZRzenorh4=;
 b=WT20drTSUqfl/lTDSjLUKzWSj6vOj852nZ4sraKNkuxw0J6rXlEvpzYgRjOYTtPHaEyYImw3oXIepJ9rDRmZGpunhV4Z3EzTKhQ400Jm8Gq2iH6izlOowmVSsrb3/dZ25+CE7q2F5VCCa/N2akbWe3KE4oyJB333mKhMl9gzOLrW23ipjSDMxKSzMJKNm/TVzarsLIpETFwDkbnjQvToPgyxC1arASXx+wi/wbhKa4KFxn7XAxXCgYg/aYjtoQoaTgsnHBfqZ8Hf5iqNIe1IaQNu19JUm0mbgQ0gJjb8xnQ1GJ/bPDm9cXxdOOoy9XLk0Xxg3Ii7FyWMGE38oBTw+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oYEVFSEgmua9sePos9LJ3oeDSg2NnRJTKiZRzenorh4=;
 b=muszAsium5nVPEB4MDRO8L3o/DZQtVff7U+Q/nQjcprIGf0ewVmFLhWZv36dsmBPlxq1QEAe4H/1zR7zL6hfGYICDl7tHJVVOvQZTy41B3bTKl92J8ADATDkeeFlOCFY8ljyJl57xbOb/W3YkdsmR7xQZxRD1nzPA1CL8UQEx8U=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by PH0PR10MB4552.namprd10.prod.outlook.com (2603:10b6:510:42::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Thu, 17 Mar
 2022 06:49:45 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::b0b4:e94f:82df:234f%9]) with mapi id 15.20.5081.017; Thu, 17 Mar 2022
 06:49:45 +0000
References: <20220315064241.3133751-1-david@fromorbit.com>
 <20220315064241.3133751-5-david@fromorbit.com>
 <871qz2dw34.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220316232438.GS3927073@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: async CIL flushes need pending pushes to be
 made stable
In-reply-to: <20220316232438.GS3927073@dread.disaster.area>
Message-ID: <874k3xdqf3.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Thu, 17 Mar 2022 12:19:36 +0530
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0051.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::20)
 To SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 449ea7bf-3422-4e38-b563-08da07e2524d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4552:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4552FE506323A6828186A43DF6129@PH0PR10MB4552.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t9+/6FqdP7ZfzYHRtw30vzjVatCmVTpheLa6w1QScj5YqKD78W/dDlyT+T8wxPSSbMcL9qVhm+RPCWo6w3P8eUxot3Qp4eRgatBYblnmw5NzHjEZ/PyO/u4+cnb2EbR9X94jOn9Grtpa5Bp9pGZU7IWn/Be0oNHX3JOJtWryrlFPGIsJNTxN3nPH5JFGafzjSmBJkqh8DfXQMBDLqJWp4OzfIfKjrJc7Ek25YCwscgyQw9mJRxIrp1YibyDRP9eRKATI0rmsvNj/6vA9lBzcswCkIfzWXT98hTuhyQW7DL6ZdcX+i5Gzw0IpyTPT845mXTjzujFqDYAe+d3FSYoWqc/8MLqEc8QRCMXwJ9UjZf/dturjJN0oOjcWehkZ1gI3JQ3qtdvD4Msv4oc2gGSpSwMIv8SdHEGboRM3ZAdXexANv0h0HGQfDw4W0SaeCRkquykCjd7JtBYpRz4otxEPXJScDTDKv2KKUjlhBYGEVzYuzRs20ZFYpnDl/HUrxWwvFRh9TTa+8f9eOqRNkmohRc62afLnzBj/svr3wQKhJe0wcE+lAjnNwn0+mtHpjq6tWdIP89cY5ZL8G+X1nJYJoZCHJF4/tel0T8twCmIIXY3AN9/pIJnkm33WzizERoY52OFHJU75C/2taN5q4+E8eVgA2eA+uuynHMk4rLqkB4EXAbvN4P7wwlNlhcPXOzYKaRPc0wv69l0mMJgaKtBgiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6666004)(508600001)(4326008)(8676002)(66556008)(66946007)(66476007)(26005)(86362001)(5660300002)(38100700002)(186003)(53546011)(6486002)(6506007)(52116002)(8936002)(6512007)(6916009)(9686003)(2906002)(33716001)(316002)(38350700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mw8W40t7yt/Jd6ogSsTcEJCLzC1oaZJ/uFjoKZQBXXQFyW3fV4ridSejoyuU?=
 =?us-ascii?Q?wQAvHDnGFqHIkb8nXcl88xwFLzNbaj3x/iEfVe/nhu8IEPzMVq7l5SuALOtS?=
 =?us-ascii?Q?tMry2y1VkN8Cr0BrxurofqruIBgx+dR6NL8WcrXzkHd18pjaLgMevyXsCeYX?=
 =?us-ascii?Q?V3GGa9miRM/uJEd2Nr7PQ53Zd/JW+yZZBBvEgiyYrTQte5E55/broIHolAk3?=
 =?us-ascii?Q?Z9x8rLQ2/r5QzQwn0jCfriMU/7kjo3y4eIBI+C+dgix1fuA2ImSbLitJefWW?=
 =?us-ascii?Q?13ZdEqgjMN2FX0yN2cZBI0rQLSv2Zu91WJ+jHRLC6bkHdIE9Bng5STPwIq6h?=
 =?us-ascii?Q?ExjCwYrb75ZJ6VnzpLXWqh2vsxR988iXjJ0V4z76KuI8a0MQCIIIyvAV1xOQ?=
 =?us-ascii?Q?bDpor5JZfL3dcyTG9y+qxWDjbxc+UpOCjY2gePmtTLOQUeSl9H985ceMCSK6?=
 =?us-ascii?Q?Iioa1RcNJwbbQyWI4FbUvuyhsOFR7B/FdeHQTy2739B1LhXtBpr+rikSaqof?=
 =?us-ascii?Q?wApDanIScsiiZ/7KW6LA/+4/hQpAsL+3pmk4s0sq67wsYE7oHzthn7qsiD2y?=
 =?us-ascii?Q?dyFPFNH4a9ERRcyX3oacnSMzMtbyy30XfFPOQ1oERAZAnuRKkz1gXu9gAJr/?=
 =?us-ascii?Q?7fU1k9tmYpQPFvTh9dS1a7N1axNIBi1YXJFEnwklZb750+EbMLT41TtKbDXM?=
 =?us-ascii?Q?Yn3Ws2zPptuUoGccAYXlD6LbBb0RxOgt33E4InP2m4s6/w8Iwd4EpyizLHYc?=
 =?us-ascii?Q?Vvx91d98WILcJGr2ZF27zFDKo9MVntoZUBA4wOn6ZSNOeDRkyxYtHY7VS2bR?=
 =?us-ascii?Q?hVFxdwx0vLrOMT/qset9srdKnbUTgH0u2ToUWVIo0FRpg9TsJnv9ONT4/zml?=
 =?us-ascii?Q?H18tZOgITTaATASlkdyuZoeWPhG6j3jwKfl7KVldNEQMv2QyTRnQ4+2ClpDm?=
 =?us-ascii?Q?1FebZ187wVIrDr60/UlTwTrAyDfhBNivJFwPk/j3VhliD2VzpiwbXRgwPjnO?=
 =?us-ascii?Q?Ef2icP37FzJ3wYI4k32s8dwAvjo9BaacQfS49P8KIY8M9VsP2u90S9S1sM0W?=
 =?us-ascii?Q?/j+j/74IwW7tAbPnbhn/GWIxDZupiZS4ZIPDVFuNjBC7fy9bunshsCU9BeFW?=
 =?us-ascii?Q?IlDvqO7XbIV3zNuD5+pXr34CFi/UTo/LFDNgGsfD+TukyEUJJGkblHkkh4RM?=
 =?us-ascii?Q?gPb9fEZ1KbGNixlx9W/B3U9N5QCeVLU8sHm0Sg3TYZkpHSeX0o4TwaiJ9pl2?=
 =?us-ascii?Q?xJTynXH7uTQshDAJL4QMsXtIiksQtmpUe4N3zSUp6ok0UY+Z4ZpISibEA91z?=
 =?us-ascii?Q?bpIOjT1YzP1kb7yqNioUwgYzLrLkCVB/K7oNdoWe9uvRXtZ3IJwssiU1zVm9?=
 =?us-ascii?Q?EQHEg8wLYdHVyAMnFz0FmmbfgCXCOyzyy5FcyOJFE+CjD2VcNoznZ6qVhL8B?=
 =?us-ascii?Q?c+73dHdp6DoWTBi47wOVjitKTdEwmA3e9qxUvedFDBV/XAM/45o00A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 449ea7bf-3422-4e38-b563-08da07e2524d
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2022 06:49:45.4298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ytoHEw24koq8kn1sStzRDue2CbM6OOpi9WMNX74CLtfcUUYzzZrPuQ6gL3k8aQTL+isUes+jh0CGWcb0i+nbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4552
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10288 signatures=693715
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 adultscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203170038
X-Proofpoint-GUID: jGKaDliY-MkRCJz4yypFPMinO_rOHJtd
X-Proofpoint-ORIG-GUID: jGKaDliY-MkRCJz4yypFPMinO_rOHJtd
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 17 Mar 2022 at 04:54, Dave Chinner wrote:
> On Wed, Mar 16, 2022 at 04:04:55PM +0530, Chandan Babu R wrote:
>> On 15 Mar 2022 at 12:12, Dave Chinner wrote:
>> > From: Dave Chinner <dchinner@redhat.com>
>> >
>> > When the AIL tries to flush the CIL, it relies on the CIL push
>> > ending up on stable storage without having to wait for and
>> > manipulate iclog state directly. However, if there is already a
>> > pending CIL push when the AIL tries to flush the CIL, it won't set
>> > the cil->xc_push_commit_stable flag and so the CIL push will not
>> > actively flush the commit record iclog.
>> 
>> I think the above sentence maps to the following snippet from
>> xlog_cil_push_now(),
>> 
>> 	if (list_empty(&cil->xc_cil) || push_seq <= cil->xc_push_seq) {
>> 		spin_unlock(&cil->xc_push_lock);
>> 		return;
>> 	}
>> 
>> i.e. if the CIL sequence that we are trying to push is already being pushed
>> then xlog_cil_push_now() returns without queuing work on cil->xc_push_wq.
>> 
>> However, the push_seq could have been previously pushed by,
>> 1. xfsaild_push()
>>    In this case, cil->xc_push_commit_stable is set to true. Hence,
>>    xlog_cil_push_work() will definitely make sure to submit the commit record
>>    iclog for write I/O.
>> 2. xfs_log_force_seq() => xlog_cil_force_seq()
>>    xfs_log_force_seq() invokes xlog_force_lsn() after executing
>>    xlog_cil_force_seq(). Here, A partially filled iclog will be in
>>    XLOG_STATE_ACTIVE state. This will cause xlog_force_and_check_iclog() to be
>>    invoked and hence the iclog is submitted for write I/O.
>> 
>> In both the cases listed above, iclog is guaranteed to be submitted for I/O
>> without any help from the log worker task.
>> 
>> Looks like I am missing something obvious here.
>
> Pushes triggered by xlog_cil_push_background() can complete leaving
> the partially filled iclog in ACTIVE state. Then xlog_cil_push_now()
> does nothing because it doesn't trigger a new CIL push and so
> setting the cil->xc_push_commit_stable flag doesn't trigger a flush
> of the ACTIVE iclog.

Ah. I had missed xlog_cil_push_background().

>
> The AIL flush does not use xfs_log_force_seq() because that blocks
> waiting for the entire CIL to hit the disk before it can force the
> last iclog to disk. Hence the second piece of this patch is
> necessary, and that is to call xfs_log_force() if the CIL is empty
> (i.e. the case where xlog_cil_push_now() is a no-op because the
> CIL is empty due to background pushes).
>

Thanks for clarifying my doubts.

-- 
chandan
