Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB4E6C77B7C
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 08:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242831AbjEZIx1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 May 2023 04:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242870AbjEZIxR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 May 2023 04:53:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3C219A
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:53:14 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q8YVo3013719;
        Fri, 26 May 2023 08:53:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=FzSmMv7ZCbUdGRftAC0JMsbYFQQnsL8DTKWeqjZJXAA=;
 b=d4ezO3CWNLrFloIY06IpEdXJZcTLqvpQcbIZ+x/iJ2oOSrdUyD81IGhuEso8ZANVn7EF
 3f9sQ726E2Akz5F5B5e2ezUOjjy/aFOYooxxMzKlaQCfJUFGVRQfT29W42g/6duW1Gqo
 ABdmJdpQw9TPuP7bqQScpTrehd7iBLEUzI5SsQyj0s8fRBdKbXRLwJRlS6D3FDgcEj3V
 8kU1BomhdJo7QJortFMLmx3uSTf9SuC5867YPqBpsJpQgXOpi7x84A/IEaVXPYaGcpal
 vd67DFq+nlD+VYMoktDrZoLxxI+GVE5VNinztSzg1C9y05fqo7NlPIVHG8ED133d2Op3 gg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qtscd81gd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:53:11 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q81mCI013061;
        Fri, 26 May 2023 08:53:10 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk7jrpu1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:53:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iHLOR/eu6F8bUeIzCA44RsgbvNX9Of3G6W/PfRj6fLPDMaLZih7GZUKO20xcpqEn+x83Ns6+EO637cl/6vJaUaNTjh+phW1/O3EjLh9MJ6ynCXMt+Bec1Tx9lZrBoBpWL1EBlIsKJ+hzk5Fqitjs7yE8kbsCph2JBlotV8jEd16NfIYX5ZJ45swB/6BpqktlqlmP+z2icnGeJiXArl5AxReBm0+2iX4vNu+ijkma56TdkZrSYB3RrJpwj+bx1300/Gn6Lpxby/5tsaTCurN/pKt+53CIkufk78LIazZPEWAmSYH+tyRiaQjJSVSWD+c1Fx+c/12UKZCg0WmNFfjbEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FzSmMv7ZCbUdGRftAC0JMsbYFQQnsL8DTKWeqjZJXAA=;
 b=fOV3+Y1BnNz3M/wDq28/iVPzjrhNo3eyWD2D+/p8qAyI1MS+z7HycM5bO4XzBuvZnmZjtUR/aCdxuj3YfkwMBMm1C996z7d3HQpNgAmURqWRp8HWUIQrEwD55cdnha5BQ1HIP3ZeELGPgbXjHLXlGTRv+xG41angWnAS3DSv+ay2lI4YBzGZLKmK592eKGBKz+YrS0yBph3xb02D1StzNSGVMjQLO179OiEFiGclxQAJPYkmBwerVOJ3N6iadgA9RYk0l7ugb/V0G92jAvkockXPGN0DPLvo2CWVYmA4dD/J1ocdDRvYT6fyLunYhC5Tzp+ZEOUrGkT+KJ1B5TDa6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FzSmMv7ZCbUdGRftAC0JMsbYFQQnsL8DTKWeqjZJXAA=;
 b=mnXs782+V70cXAhJFMypPiz5zijNxPsLJ7PgjRI0wmNFIAGPR9dWizsGL+DYt4RPD1i8ZFqFZYbUN/JnPgQp6ueut4XEWu4zBJCEavJsaDq7Yn8Y4YJJYLwS03EBfWz/ZF6ws99F4i9g0aH/FIvqy8SEB4iubnZ0aMQlghQmL1E=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB4439.namprd10.prod.outlook.com (2603:10b6:510:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Fri, 26 May
 2023 08:52:57 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%6]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 08:52:57 +0000
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-19-chandan.babu@oracle.com>
 <20230523174449.GY11620@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/24] mdrestore: Introduce struct mdrestore_ops
Date:   Thu, 25 May 2023 16:04:12 +0530
In-reply-to: <20230523174449.GY11620@frogsfrogsfrogs>
Message-ID: <87v8gfiie6.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0016.jpnprd01.prod.outlook.com
 (2603:1096:400:a9::21) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4439:EE_
X-MS-Office365-Filtering-Correlation-Id: 058e3cf9-6569-4b6a-50d5-08db5dc69a35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o4nE1jGlWsabDP1/ruKhmcspWCGZvfZyMcVK70puqGP18BRgeyr/hrWnMqAapcogXZbWUb3patjognhAUj4Osj9lPNBVHG5Pyf4uLtIjek53/wAkBq/7XpM85hOmd6z5fyjsYMt7jBreTE84dYKeyiXpvE2rDhuRqemYjD8BXIOoKaCHJmLyPmWvqPAN6q1bqahDV0eKZYzMD6l8iHSZD5u2bOLvHav0QaMvXBdqNwxjRCYZ4d9PS0qlVP/vxJx8E34/oR45C1CeYxEFZKnTvyyFQgwYSJs/mVgNNPk90N9ra6hZflxbn1x0hOUsnv2styb0mvhcBhu+LKHgOe96GA4bRtKaCw7LyxeeB+2AIpMfw8JIDxLyNbXlqkN8e5KnCjLZ5+zaRqI/QCi0s1iGDVETdgClslfIrJlA+N+Ggn4IGO/dlJ2mJLgmukF/axcKjrVcC49RDEfqd0A9X63sqQs3XL0CNnI8DjSbdL9VEiqvNHObsijzABLuCTsdCwu6rM6/wY0ReVGRQYSnCZhyZ6x8e3F3mHDH5fhCZ4LDeMFGwRxaFvc3y3P9/b5bJYzj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(396003)(136003)(366004)(39860400002)(376002)(451199021)(4744005)(83380400001)(2906002)(186003)(33716001)(86362001)(38100700002)(66476007)(5660300002)(66556008)(66946007)(316002)(6486002)(6666004)(41300700001)(8676002)(8936002)(4326008)(6916009)(478600001)(26005)(53546011)(6506007)(6512007)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OQaYe4sUdmeuwVW72m5YDaZIsgfZpDU74QC5xGQZjO2wtbhw9Sero1HF/pzT?=
 =?us-ascii?Q?VCntEGhhmGQPjqjuhpty3qkQ92cn8kjNfEMGy/gA2Ld15kiJERzWieQJq1NF?=
 =?us-ascii?Q?IzBXgn6EmZcKRA5iDzejQj2xVTU7JHGinIEs1Ks9E5uLdkU/HSuO0Fkc5ucg?=
 =?us-ascii?Q?YJj5WllZPfgg3WA+Q11gZk63AmD5BpwnEEyL7tebvsE4NzOstmi+WMwRvE0C?=
 =?us-ascii?Q?21PNsHGUcvniYKpRTzKMAnifIg+wlH7Qy+TmxK37ZHru3VuzhR+oU4iJzJzE?=
 =?us-ascii?Q?/Q72v034MNrR/QobSW78PUvCsaxORtomeBUMQAqYJ8z/9kesumRUFrT9gF3p?=
 =?us-ascii?Q?Y+ZK6+WK+olllPFCw8j2vquJwMT4kG7V0NiSAjWmJO9VqsLGBWdhm7KiGlza?=
 =?us-ascii?Q?eAACacLhVgtyIwn4zp5VXSRkriXBAC6+r4fiKnXXbki4f4qGM+BxpWk09kHP?=
 =?us-ascii?Q?JtUJbRSip0j4pNL1yMwkD2DVqFnWRznvt+QjiwbABlWmHbTseSUwoFhJaIl1?=
 =?us-ascii?Q?ozchJ64v7twNu9ai1OvwFq0ijN46DhyGxyB1ETC4B6fH5091bcP1awN95K3i?=
 =?us-ascii?Q?M09dBDqjfIPL9zvz16Pwq+9kQ7d1QW+oxEFs2sv+heGiO+FEVEbWds/MhGXk?=
 =?us-ascii?Q?+aSJt4rXO7Sb+nZ+xDkX/rK67m7G8MPzLZrWPvnFuKUKtfVDTjUnmDER4olf?=
 =?us-ascii?Q?UIjAw+dX4f35CPvD+EmdD2Erxnb5ffwP3aEKRd61cAZGAQvl0DJugsED8ReU?=
 =?us-ascii?Q?sN2i/X7pRbvuh/L7b4bmgnBPUYNPq+LEIdc+csxNrNaeYg9cHOt9m5tVAHBi?=
 =?us-ascii?Q?879kSEqKMIT6UdtOascBj1rSMn2DlNDnXBttL9bsdVhQ00fs4NXDZEFAK4aO?=
 =?us-ascii?Q?VkSqa5JSwVj0PDpZPpXtAo6W+YuxDoTW8AzYtfcKyfXtxinTqTG8D/n7ATXT?=
 =?us-ascii?Q?Qmeyefn5O3H2kqp5IBzYkB00K0YZFUhg89d4vUv5Dw4w1mkvLhIO3/yUeGAG?=
 =?us-ascii?Q?laNJPTOOQ7hi11YkKnqnd1dt6TLVIdTbC/BASjwLMwl2qcBxGmNwhc27NDmZ?=
 =?us-ascii?Q?aWg3fXidNYe2v+Fc4tTz4AT1OfxdFPw0fcWH5dlQeNjH/5STqmtb8uzh7pkK?=
 =?us-ascii?Q?x2PCBbdZoLitiXISJY1ZqP4vmIMhYm10giZ7/1MMoaViZvlQirzw9DFUtpnB?=
 =?us-ascii?Q?bejhxQLDXiOMqwbX9Rci8QeAQ0F81zutGT4yMdrSluLVNClVnRDLmvdYo20H?=
 =?us-ascii?Q?mY4jY/HHH4ppAxmeaUYCTEC04Uhsygs4vdxC5zkn8PiKTXdIOz29R1WiCVlT?=
 =?us-ascii?Q?Jhjufnr2Kn1zdTl/SFTW4tem6VXSdZQBzaRhicGTe9AWNFlVFZpama7UxAQp?=
 =?us-ascii?Q?hm9B6O5h+fn8Ca04zHSwv5ZoYqZFeMyqTZ8IhuEOlW7ljcq0LiM4qxjIlAE8?=
 =?us-ascii?Q?tc4VDvrHGDAfcpnpYyVVq2yni71emi7WZmKAttLzLxXjj/GmErHfQwzhqFbP?=
 =?us-ascii?Q?Vg1XpUEFdAliii7s1GaTUyKB0HRCcE5DOpDVolTT+pThW80VRrYmj6MWVPyC?=
 =?us-ascii?Q?CyKzSnab7fWE0e6sFoYqv4AfFZ4FnBVwYG/ml0FPPz0QPgrp4BRxmi6NOTyO?=
 =?us-ascii?Q?BQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: jTyAkI0iQX9+/D9Ygd8+0jZ2jRk8ALbaytBWVlTT/LbehUll0rHDzD2v+CEtCHkl0+5m3Jbat+d5nakla2ZPNTd2pv5xpKrwSm7b/s6SALLwNV9TUQHMrYJZOhVK2E4+Reh6C7bTVaoXD8N9ViBz3XUdpd3uD/Wv2gI8Ao7jotJcmbHoJXM7Czs0yh9TPcMv1LhJm7PQZu2ngiwFS2eGPROIO+9Q5hYXOV1M9lT9mdQOYZGPotI8uTVzO7rpFs/BS0Vc5j5j4pn/mdHFa6uf/ITb9yNJJ6EXlRpXuVrZFlGLnxKZnBRwiwNjhoio8zg3wf7N1qAepJhm6l2nU5Q2AR16wx9XwUAEVg7eWZusglHfXRFcLK2vQJSebUFCRC7DVk8spyH3oLnqXFBaE8j6iZnMJGpEN+R/f778SCHbKrd0jsFwjiZlm7p/geFMzF3db6LWCpn6rNwrxn+TmOio2wGsEAshMZX6cOEx41iebvUAgmzxqPJz1eQgHg9BjfgbEVE+aDsIraMMsZj1aecmtv0mU9O69Y0Hp5KWquG0FEktEIJ7SXD28uT/kJSeW1eqPjqpmuAttsBGK2ZxajC9+/oxejhHqO5yyoWYl4iqjaMTcg7QqgtXpQE12CIZ73/4O03XwBaaz74uKrmu4mZTh73c8a/Oswrpza07gh4NTZ4DnpYS9wwdI9x3pAe1AYt/PSXlrayzXRcnActVUtJtwQiK1EYrpw3pjGpsQKr5hkg0B215y4VQy7xYx9RsBSje0GfD/qmaM8irU9M1uu9u9qSsw+hGltRuHJ9bvUEDez4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 058e3cf9-6569-4b6a-50d5-08db5dc69a35
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 08:52:57.6486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vNggYxrE3B4yFIp3kFweC0FxxLEvF0eYq+Wg/bPajI2w0Fl+5O2yEeeUltQaE50b9n7S3xRqAu4RUPHROBLY7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4439
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_01,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=974 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305260076
X-Proofpoint-GUID: gm40XqeT4NhI0VdnVTm6Jdk8rfvkJ5FA
X-Proofpoint-ORIG-GUID: gm40XqeT4NhI0VdnVTm6Jdk8rfvkJ5FA
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 10:44:49 AM -0700, Darrick J. Wong wrote:
> On Tue, May 23, 2023 at 02:30:44PM +0530, Chandan Babu R wrote:
>> We will need two sets of functions to work with two versions of metadump
>> formats. This commit adds the definition for 'struct mdrestore_ops' to hold
>> pointers to version specific mdrestore functions.
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>
> Looks ok, though I think those three int fields are really bool, right?
>

Yes, you are right. I will change the data type of these variables.

> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>

-- 
chandan
