Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0F1EC433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Sep 2021 10:29:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82E6E6124B
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Sep 2021 10:29:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244422AbhIYKay (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Sep 2021 06:30:54 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:5146 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234922AbhIYKax (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Sep 2021 06:30:53 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18P8a2VN015709;
        Sat, 25 Sep 2021 10:29:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=7FYnfrLSYA8qABFTEMgPr7H0RdKLbhcXcYGAqs20sx4=;
 b=DK2tmvUbukGWz+0ymFZt+1ypPp3iQk/0A4fF2eUlaKulC6K8OiNwP3TrJjLZMuptjzKU
 L/QeqaQY84+0i/C7GzA388tZBf5Sw8W707t58xARZ51XJfqzy4bw8YllD0coaweTnZgd
 ysZ1FPTFl6Tjm9zw9KnCX39R1MU/BlFlWeaiiPAF+NvDBYQ8gWKlx8JKglPSVlIBxHDV
 ddhNIjSeTuxLZzz1YMuF7IYo7eeSRU+z7QxgMoC/ke1fHMiElgTKrPreu/+KREFmQ7qI
 7d0SBXhfTpR0w9Uh/crLF+CJ2e7JW/cv5YPuX4mnvYg6jH9HoFPVDJyVm//z0Jw6LkEg aw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b9ucsrpvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Sep 2021 10:29:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18PAACRV165114;
        Sat, 25 Sep 2021 10:29:14 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by userp3020.oracle.com with ESMTP id 3b9u3jftqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Sep 2021 10:29:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cySuRQ1xSPcA11v8W0BJKK7DNRbuAiU6TVdz7IJ+cYIriibavCrj7Hex6vfRE/M6ocYFop5U7p0+Lsv5Fz1TgqMaFOclghWHhqHRTzh1pZnAykuKS8sB5REir2F1sWKKn+ZES5/Ucpi5hGttb9MUHO4JYXc8jXFH1XYQ/KbAY0i4rtT17adTlIOp150UYPTkP4/A8Al1VllfY0wFZQ+XJOfgPQZBh9yko1o29EAi5Ye1NXqWPC8l3xm4qABuQ/JlnJF0YlBScLxjSZrclNefsJeGHaTtBo/uKuzBXwvszwIi9LI/dKKQG8uOFTAfFMekD/Kk8T/dBQUD95as6Heypw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=7FYnfrLSYA8qABFTEMgPr7H0RdKLbhcXcYGAqs20sx4=;
 b=HnMbToVsYWnqwRzeQV3irfMs2q2j3UOD7cAA+dCBBiROTokYRVoe2+8XDsKs0tDhSC1NT4OUytRoveofDJOPC8ajkKzWR59O1v7VKX3TGbCTHQU8wSgGh5FdfDW43tx5rjKRnOroSdC0XNZSfqA6CzKVxcO8E0qohI+ukTjHdr4mfJ6TAHmtB0Yaew7buGj7U9t1C5zruE2PC856xCVmcfB1hJBQop/HfVCF/iNN8gjJIIYNUkx0OzvH4ddC/MxRCRdmQbYH/AyQV0Fz6suShx30cC8rBdWXG1TAoYHMxHoIz0vPLb9xCsp+alEi2EkWJjk2zo8ojD0sAx8erEd6VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7FYnfrLSYA8qABFTEMgPr7H0RdKLbhcXcYGAqs20sx4=;
 b=ivlZRoHWsDeCBRCOv4fTzXv/KufSzz7sMz2a/eFx0OlenyWYKlk8nSS2AHuyxl6cteMQMJ5OYqsw2y4BMjuwhZRuY97I4Z80MpaBdK0nX1EhSemKDuAPG5ZhZWe+WbcrWTXqTVcU2q8ihkAJS8TLF2XcyypbjoRRKPFHuZDawr4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by SA2PR10MB4698.namprd10.prod.outlook.com (2603:10b6:806:113::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Sat, 25 Sep
 2021 10:29:12 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::1138:f2cb:64f8:c901%8]) with mapi id 15.20.4544.020; Sat, 25 Sep 2021
 10:29:12 +0000
References: <20210924140912.201481-1-chandan.babu@oracle.com>
 <20210924140912.201481-5-chandan.babu@oracle.com>
 <a268ae0e-01c4-c0cc-5144-adb9128d5d3a@sandeen.net>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        david@fromorbit.com, djwong@kernel.org
Subject: Re: [PATCH V2 4/5] libxfs: add kernel-compatible completion API
In-reply-to: <a268ae0e-01c4-c0cc-5144-adb9128d5d3a@sandeen.net>
Message-ID: <8735pt2bkj.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Sat, 25 Sep 2021 15:59:00 +0530
Content-Type: text/plain
X-ClientProxiedBy: SG2PR0401CA0024.apcprd04.prod.outlook.com
 (2603:1096:3:1::34) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
Received: from nandi (138.3.205.21) by SG2PR0401CA0024.apcprd04.prod.outlook.com (2603:1096:3:1::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend Transport; Sat, 25 Sep 2021 10:29:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 853e89dd-a865-4572-d8b9-08d9800f5100
X-MS-TrafficTypeDiagnostic: SA2PR10MB4698:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4698D95A38762699E1F8D718F6A59@SA2PR10MB4698.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4oI2TeWM4bHIdoHqkvhwbqxOZO67ADNJGwD7EA+6/flDLFc+XGzETffNjcV5TVYlenmoQmRtyz8C8B6rOH0OFxz/S4xv6S4RIc5ZoCaPbnAqF8+JVqUEZwDtx3iudoBn7KocOsgLpcmWWCeiAYGo7u2M9NPtBCi9LIj75fvApHCrkiYrGosmhdu+QOPBHwk2LBKIibtWTvEhgY+VXptlgKY3FK2MQji2D10lG6c6mS2I6weBbOzU0c4xdJf91QCSf95kJg5oql3VgO4isDrSAG+b4gaQ4EZlNY+42GGlBFVtkZhpiWNUzwRQlxJII61kkKp/iZ9hxgbwr+EPqBOzzvbh0ETiWbnPbe6OVws/hzRRNntIXn19g8EeiqNzNbgMA/9XHjwC5ofoPOIRYyg+PgUB3CRhY9bFWNQreG5HPS/988g5EjGq8Lsd7Sbr/Jn62Vqm3iriD/tRciZzmZ/lLnHSL5ZOXDHsaT7QC47nIS9Pzw0YFzL0q43eGnXRBNp5XWutRnxKQRAa5Z9ThLTRTMktNQY5oxnz1Cx6Nk0QDXuXMctmt+5N+RTck7xYS5zq/Doh+TK17oxxqU+IjGy0/gxV+jLq4jfjqRwWItMXZVssImkHX+PN79zCOUMH+iZjCefMAyYzPPKefkWG+ABXjCwWKeqokYUtnvEbl1g8Pqzfk52pOWIcWrVDaDve96+sN9YM3Hd7xKEDAbXNTQP5Fw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(508600001)(9686003)(66476007)(6916009)(66556008)(52116002)(66946007)(956004)(5660300002)(26005)(186003)(8676002)(8936002)(38350700002)(38100700002)(6486002)(6666004)(33716001)(53546011)(2906002)(4326008)(86362001)(6496006)(316002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XZau96oXY+JkOGSndpu5hKsDAxZ/Nc44OMTO3CBZYV+MC6Cs9IoXOdlXx5y3?=
 =?us-ascii?Q?N9KZWFrE3aqx/ljyYLjsXQFdoje7FYFDqWAMOnXLv6fsGL55s2kk+E7+XIbU?=
 =?us-ascii?Q?UwEqdHwkqzYGhGIU73AjeEXaNwsnR9h23yX2PXoyKDjrSwHOtvnMHaoqAqAm?=
 =?us-ascii?Q?44rb5X8RL4dhBvjrPEMz9TxRNVN2wxptsuNsr4v66rLGU48e895hmTeX88p6?=
 =?us-ascii?Q?CZdMUPbEB0c+OvkdbhEesMfRg+Cm9COie7HHszEStdFTBssdoO49SGbeQw+d?=
 =?us-ascii?Q?SkPMbnvlfi59AOccl3G5DTHztLtF3pMT5+o7qb18R4uCwoPyT+EVm07xFGJH?=
 =?us-ascii?Q?v9xnNR0Bw3zSDAjGnId0QfIa6zLVe3zUbEcTkmtbA6tuRhhj2GArVCcgaL3a?=
 =?us-ascii?Q?NKHm3xJbaANSmHAnVQJEzeCwNWvbJ2plz+BhJEtUmihBtZ7xO/ZqP7ElBJy5?=
 =?us-ascii?Q?uxAx4whORjzS5W9l8s6HN3wSwNF4i3KZ2dnaWLNYZzIxa6p8L4feP7I3s/G3?=
 =?us-ascii?Q?xxP2vWiOvX4TdFudvbt7ywK0sinAFFyAX7O5YBODThLGWE7qwjGaQLeagPJ6?=
 =?us-ascii?Q?G+nCa/8317P0u8Lt6P8aWb0ewT9wUxUv/nADpcU/pKWNCccd+uXJRRmAfBgR?=
 =?us-ascii?Q?QnuK2SDLv/l+mQM6JjxJqW2uXADI2psVKlWg/Xlbm0iUkJ/Ve94g8IZYSs21?=
 =?us-ascii?Q?HF+yvtkfRQiKPbGyZ8AN6biH4Gva8MREtMmdaovpkg/smOIw2kwdUXeOBSsb?=
 =?us-ascii?Q?SvMb7zMA4FC3g/tlHN0aOHQYOY50n23xw68hXKbKNmUHhRGYsZj4XWGFHVYS?=
 =?us-ascii?Q?hhymUxeSU7YQZzq8Z5flYe2gAOWYh9mImhNALF3TDr1YhYpzDr6QLSuGxF50?=
 =?us-ascii?Q?kmjXZS6ZswkMWBXb3SOatQrl95QN8epr5yyzM6U9Df0osoFUAPcKWCgqjgXG?=
 =?us-ascii?Q?FZCuygt5eFVR7x6KBgGZCyls1WN9UU7PdZdn4I3llsv5LP+kPkhcyeTZPhHz?=
 =?us-ascii?Q?oTFMG8rgvQ1MX9P0Xs2a2okOg+e38FbuvaDKKApGVE2tU1IcoxyRiQivA9j6?=
 =?us-ascii?Q?48pzzF341b6A5nd6nYGAHabbhRBimGdpd51rdEVw1qINTOVnzTjutU3khC9q?=
 =?us-ascii?Q?Bc1LokBFln5uPrxblnyACLVsi7fqQxLCXX6HrJnqs78LEploWOlB0LDAz24a?=
 =?us-ascii?Q?fq2Mp0t8NLXv50Qyq3AZiQrTplixDQkthKf0R+q7e/bd28iYNNUp7NUp++9m?=
 =?us-ascii?Q?j51NsjJFwfj6i60FQq2KwK3PA1AUKMaH5Rw3udSCY9q7IWzIHjDRO4sYlENM?=
 =?us-ascii?Q?16XEmqI3smjTOuLRRK/EEjgF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 853e89dd-a865-4572-d8b9-08d9800f5100
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2021 10:29:12.2038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NWfreZKxI563Ci01zo8nAE8/Mpc4kejQhdpys4D/PDRRX5mkJzLZ9TW8lm6cmriHdujeOGsO1ftQzOCTm8zrPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4698
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10117 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109250076
X-Proofpoint-GUID: XVVKLQENJvv0-FCfBM_HkswUCk9Idf7W
X-Proofpoint-ORIG-GUID: XVVKLQENJvv0-FCfBM_HkswUCk9Idf7W
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 25 Sep 2021 at 04:32, Eric Sandeen wrote:
> On 9/24/21 9:09 AM, Chandan Babu R wrote:
>> From: Dave Chinner <dchinner@redhat.com>
>> This is needed for the kernel buffer cache conversion to be able
>> to wait on IO synchrnously. It is implemented with pthread mutexes
>> and conditional variables.
>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>
> I am inclined to not merge patches 4 or 5 until there's something that
> uses it. It can be merged and tested together with consumers, rather
> than adding unused code at this point.  Thoughts?
>

I think I will let Dave answer this question since I believe he most likely
has a roadmap on when the consumers will land.

-- 
chandan
