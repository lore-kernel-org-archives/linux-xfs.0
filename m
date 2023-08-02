Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BA15C001DF
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Aug 2023 13:21:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbjHBNVH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Aug 2023 09:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjHBNVG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Aug 2023 09:21:06 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A6608F
        for <linux-xfs@vger.kernel.org>; Wed,  2 Aug 2023 06:21:05 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 372CxcdK014340;
        Wed, 2 Aug 2023 13:21:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=qgy1WMD02NqSAMWNNzHFr5Ldqs2GBnFmbS+gaOD+2FU=;
 b=2PrG8U87uxMJDXw5wGY0BFft9cJ0JHe1bAIebkSOvPJRSDOK3a1HM4VZjDc6r7XZ+sFs
 gZC1lxAMLIOZaAsA2eXp6eqiph3msM9WWLNZxrowJ+92xNcp22uGjckVwA1PSlriHqmZ
 bPPiVaVYaFq2uHbAG+Gocd5mRpjhFRC4yFfSqns8jrVEZYaOnjudW68vRKQRf0Vq9pPX
 z2ajisvBnhFB0aaEQZC7432we7rNN2RDRGUUj+sJGJFAxGJzAjsOVjJE3keoltXfrSB9
 Cytm2v4vdsLmdkPhGs2N056D1ALSf/ML4Fu3jfGbHXNHRzcO/IV7xGn/83INqREVmcWU pg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4s6e77ny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 13:21:02 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 372Bp0VM006715;
        Wed, 2 Aug 2023 13:21:01 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s77xsnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 13:21:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WV4X65aA9hDWlR3NT9q/V70vAAnD4eYCqMVtTcSmGDiPRWl+ctdL5CeUj3cUZR/WaJ1jAmMQYU8IuU0d4PUnIN82czKpreycfLwrRZVKZ0OniXZnJhOLD+ELGNIcbpt1t+qmtj0C0x3ECDC0YpOa81I8okKb8/qurWv34qr7haiiqwaoOAHiAEFW9vrXPCI4bHH+EOH90aJIOXMoJVV5fGGOpS1cKilldzXwYmsPa84f/7ZBBRT+w7+LXM771FN/rDv+n2Dv/3XxBa8I49bSSwVzg5epR5sAM8zfiICa1qXojPAusgRpwjaZY45S/tprApt8BU5BL06DAYIxVkIr5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qgy1WMD02NqSAMWNNzHFr5Ldqs2GBnFmbS+gaOD+2FU=;
 b=jB/OsI4eYWvfPd1mXzjnIpyNzhid/zvn1CqzB6OhvSavnyezanjzLjP9QRjecWQki4IqQJQh3h/Ewhqr9lACmExjA/gd4vDZUonLKSR7rjw4zx5ddr8amDAvXtTtemhJFPoEr9Le5XvUbyDHPtFciISodp+bVAu7SOABLhjCR1XSwdVs/fiTth6PS6+FxRmVIzLqKFYKeZoY446uqCg4we3IHJEpYBZVe5D3xVtz4/lrp03CRzzOBdMTAWKLK9VyQiiJQ0Tz4JBkqFskgTtgfQOQ3cVC77zQGIn0/xmBXXNQvKePwHYf/DQtNtZEFU1aSQQzCX4jN+IoM8GAyXrizg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qgy1WMD02NqSAMWNNzHFr5Ldqs2GBnFmbS+gaOD+2FU=;
 b=Tl8b0G58TGJYLnCaBGxCOAtF1aNS7lUSpGRzkx3v/VXxKKs1+qqR4ZBLUC27E6l6aRG85rVd4tnq+W2S2k9TSKJu9FYdMokbHZ2UKcia+XdCxkWcp7QvR9sx6tTRWTkfMMmAf/FOg/ZB81kjgiooUoHLcd9qUy0Uw0s2QXU5mKQ=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by CH3PR10MB7356.namprd10.prod.outlook.com (2603:10b6:610:130::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.45; Wed, 2 Aug
 2023 13:20:58 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::707c:5a02:87a1:38e0%3]) with mapi id 15.20.6631.045; Wed, 2 Aug 2023
 13:20:58 +0000
References: <20230724043527.238600-1-chandan.babu@oracle.com>
 <20230724043527.238600-20-chandan.babu@oracle.com>
 <20230802000146.GE11336@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V3 19/23] mdrestore: Replace metadump header pointer
 argument with a union pointer
Date:   Wed, 02 Aug 2023 18:47:09 +0530
In-reply-to: <20230802000146.GE11336@frogsfrogsfrogs>
Message-ID: <87leetr366.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0065.jpnprd01.prod.outlook.com
 (2603:1096:404:2b::29) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH3PR10MB7356:EE_
X-MS-Office365-Filtering-Correlation-Id: 484ae976-ec50-476c-db31-08db935b4f43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nJ6MKk3K5MsUj4hhKLdxaTewMFZF7qUqRvjHeWRRnmYqST+1TfyPf6OLP5ITi9aPeqYvfBPPubQOElPufL78O31N6UKnlh9BEWZr2ltXv+mdwTml6lMg5ywQuQn58dgu0JKnVqn9TnIJuNwixcBub3TXvLEQR3b+z/5foijEMyVsjbrv6knLFctyWArTbppw22t5YA+zvPU66+7HGSMUuHRXAceYawPDqoUogB0901M1OIr1YgUsReOpi4SjggUZ8aCPCA6zEX2j6jKCL3eSJH2X+tyG5ShMFkPmXuyK1NKsAZX2EJedAncJ5pcNvnlxDsnj3Hi8ANPspLg+OHwtkm1r9tefnXJ49BJze6ZC0cTLi6+CWm8wnsCrFTgg1d1i04xqFXTiHW49prDfj0scNz8DO7XAOkm6d61E24R4X2stxpWp+fye++3okVAUhcdD4tA0cwCZlyO6dLUcVHJh5etksxpQvNJwniXcLTYthK5kP5cqzZkTwR3k0JCgBmcZzuAKZP/8QRKzVbYz4kAuN5Eb6jUpQEF4z9/KAj1EelDQcLjqHXMRQ1QQYhIUwpS0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(376002)(136003)(366004)(39860400002)(346002)(451199021)(41300700001)(2906002)(6916009)(316002)(4326008)(8676002)(8936002)(5660300002)(83380400001)(66556008)(66476007)(66946007)(86362001)(38100700002)(478600001)(26005)(186003)(9686003)(53546011)(6506007)(33716001)(6486002)(6666004)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L/f3Y6uoI27kJ4B9sIZx+EECnamelJHiDcrZUBIMg1freMCf/ppx43wEyuMu?=
 =?us-ascii?Q?yjN92XeB+iqs32cShg3CQ8aEJKhI+73avozTLhy2n1e0d5HZfI7sutIEDPV7?=
 =?us-ascii?Q?mlQQms2VNA7RMB28/Qf/b5tix6z0wolYBi9RCS89StHuCifpBlARZ86SWPQo?=
 =?us-ascii?Q?hFq1XAv8W91EzYYK27SiWKV43jIEr0Veqnmn3LlHx/yFi1Z+tzIuXjvunXoh?=
 =?us-ascii?Q?DJnqNGxvqGMcVSpAmvr6QyzyILdV/m78tKHforFvdGHcyuMy/YVeZAfkI2yz?=
 =?us-ascii?Q?ZiAmms2zgBp8lA1L3FFpwFAcMC2b4+pTLJIIQgJyXt3/2YbFHK/OObWkZoyf?=
 =?us-ascii?Q?+DJtHxYLRvdQDPOyrNPFpdZ+9Kh4G8DJlqyyMRt1mb88o2sgFC+h+uOMaa/P?=
 =?us-ascii?Q?2f8kyCi9IcM5I9H+2NhnJ+5E1nPeksbs/nAsnaLyUXy3qwEAwaswmp7C/2qq?=
 =?us-ascii?Q?oqn7tDZMYo5eQqo5FcHQXJK1F0QDCUpakfGn0l0NFl8gI00hjW28DYdaKkiB?=
 =?us-ascii?Q?ZON74O2ZplCInVuJ0eVoi/M7RwB1KvVFXR1A/55aeV99qyIgDkNEZYHvfmTG?=
 =?us-ascii?Q?YVk7cISF57CsLifmnaP8KRoIiIa4+zJhvRYKgBeNOTQwxKFnq1ryIn63sSwz?=
 =?us-ascii?Q?xqwGn4LKLgkUzy3An26utmsimmKW/FA9IzwshD+jMnXKr5Mq0GKhmfuxJWi4?=
 =?us-ascii?Q?80UsZRlXOFPqJ4Tn8FzBus9H85XMZaGXpqVIqX9cPdJ2sp9hRTT+SwexfH+Z?=
 =?us-ascii?Q?b45dT+crwJWJ5sdKOiX7Z3RwhF/MD1cvOz0y/awzaljMJw2g8v8vzaNI40lN?=
 =?us-ascii?Q?uEzBjuaNbYsK/FJQ52st2Xtjr3eMvR5xA8QBBpraOaXdCEt4Ege8urD3AEVM?=
 =?us-ascii?Q?wQK8CowshpBhDEO8DvkZAoRqwAX3pdArwYBKW0Kt9gKrmfyw2/WzgmE87tIF?=
 =?us-ascii?Q?B6iu8WJw62+ZxDtBKlcKijBUGvQ2DhuJldNKwC/+dQ9zhho3kum2KnKPK9yC?=
 =?us-ascii?Q?swniAfVeRzjtcJS/ztpp6dCj1r9BMDSTsGV9qIMlR5X+u+qo741UghQfgKYE?=
 =?us-ascii?Q?J08jnf9sGrQ/AL+svXRD/yaGUgwf2ljV3GIeSNkZ1x0VqQBl6XBzjWUDbbDE?=
 =?us-ascii?Q?VAQ71wASmxXXy1jqSgHFniA6yjPsZz6AHgjn3xK+H5AeYAcVl90mf1j0kte1?=
 =?us-ascii?Q?is9mEksUN2U/Cpn1PmLP6VOvDmLPgP+Y90edDQseypkbrt0BpXqqDD4TP+c+?=
 =?us-ascii?Q?PYtm2vhqxrn2gJe7EouWAYlOd/YGtKIvPYv+iLqTTYtvVHBsGoF8I36L+b+4?=
 =?us-ascii?Q?KjIkOBNWjDe1OvCjmRixkYbN7n9Pm91TDerUo3J6jaEqrblDefGgdUUR0Yl7?=
 =?us-ascii?Q?QvykdLaUv1FMVImRMxFedkTKXJLqSxOrvQKsOD2GVpVJzn37PKsXNiHpzf/P?=
 =?us-ascii?Q?IfohzJlk8M6w1+tuIBhUeoiXUMU82WwiYAIm0YR33oMLvVuqJXwFq+nKfx3A?=
 =?us-ascii?Q?KhNTJfsXVAe3a5tHOOgz0ruM7cq/6ucoUKRvSYkrRCioLRXlu/LEQYfnqp44?=
 =?us-ascii?Q?BfToLYc63PHjxpC6/Nm8aUg+y6mjQ3/vlfCA5et2gCokRYsjGAJGPy25qL5y?=
 =?us-ascii?Q?Mg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: iwueO8J6QT9LQOZHNsjk0sFMGGWHReBC9KBP4IpFzPhWSGIkBKLA9eimNPOYs9DTbEPvDTIJmyxWHcG0KHRfrfOyzEKi9G9eBJRzehMl8wI7DxzXUcevKgxgTpVgy5tE5EKtl9KyDpmlo9No3f+MvR+rKhmDrZ2jUI0DZzbTWKe1vrN+f2XDDCk4IFWQJgFjM4hDtx4f23yFMOwmPSJJYRlj8Yqxrkbul/GArE+XkLjfge8U82WZ8Cjd9kbW8cRz9WKJFg1WoHqAmW2IikW5Ngxw+HcIf6OU03SrNW+TaOokMVokI8XTCwe2rZKf93PJKhiM8kCp0NxGZMk071LsPhOvKPcQn6Dg8y1/YXj84MyAsNxuF7dtnG8fDYe3QBrOHfgQR47ezIyDxXWXefnxIYo5vC7PMtXefLER6Hvd73tUzab/MsIql7U3QHy9TqOhcd5bKVx0ro8sQSKJl7mxazCViC6KPoeRkDNZbPacLK/J4Yn/UHTzkPsJ0esKNSPxI/ttdyepH0RANMo00VzazKmh89k062EEpfvrTVIVS/s+PYSLhpaR6rwwUXnl2xfObBi4MLVwP5DWDSHT1tc2FGIUPQAvmclbhNrN4eX0G0zfWwhUihyjtw2/Nctzl7WoASZjbGS39xdfuS4OJLtYwDZFbDRJFFah0AWbaqOEOp8Ry8JpU/CUCPBUmqupCJN/fwP1pAePTMRB2QLldEhQ8571GOo0Puk392nxMpmamDIjbJFqTrwKhMmtnN+jj6dL+66sU5OgpzG1Ixt3htVtzPL/zeZwvASulgR1iRgX1ik=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 484ae976-ec50-476c-db31-08db935b4f43
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2023 13:20:58.5506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wY3Fno50vJJaLmE6P/IbQqnPfwA8FtX5z2PRdpmmTDHAzlpWRcCsN8X2a6OW8S0ZUfdSrEJlczzWYF1ziCZ/pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7356
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-02_09,2023-08-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=888 malwarescore=0 mlxscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308020119
X-Proofpoint-GUID: dB52qn4BWAckXje0baeUSTO4vwr12zQV
X-Proofpoint-ORIG-GUID: dB52qn4BWAckXje0baeUSTO4vwr12zQV
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 01, 2023 at 05:01:46 PM -0700, Darrick J. Wong wrote:
> On Mon, Jul 24, 2023 at 10:05:23AM +0530, Chandan Babu R wrote:
>> We will need two variants of read_header(), show_info() and restore() helper
>> functions to support two versions of metadump formats. To this end, A future
>> commit will introduce a vector of function pointers to work with the two
>> metadump formats. To have a common function signature for the function
>> pointers, this commit replaces the first argument of the previously listed
>> function pointers from "struct xfs_metablock *" with "union
>> mdrestore_headers *".
>> 
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>
> The overall code changes look fine to me, but I'm a little mystified why
> the *previous* patch introduces union mdrestore_headers and the
> mdrestore ops without using either of them.
>
> IOWs, I think you could delete patch 18, move the union definition into
> this patch, and move the mdrestore ops definitions that used to be in
> patch 18 into patch 20.
>

You are right. I will make the changes suggested above.

-- 
chandan
