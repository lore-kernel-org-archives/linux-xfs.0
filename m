Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 975F3C6FA82
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Sep 2022 02:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiIUCOp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 22:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiIUCOn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Sep 2022 22:14:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE8D11A04
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 19:14:41 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KLO6wa019481;
        Wed, 21 Sep 2022 02:14:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2022-7-12;
 bh=ZMbAQdV/tvMr/UxRNdDJ+xAsHGvvnDdGgbBfpElbD3E=;
 b=W/yk5h6T89duFQSusJQCWbUVkSZRBeoruJv/soLr3dGf7xNghcEKAS2RLF7Gs5R5DJHp
 ggIwWE1Af2oNruV42BYjFSIe8BML+OBYjvLbBzJmCfX+JYjeZOFsAaL6L8sZumLntLo1
 Y0M6tALG97Fj670H2psvWXNoZunCuCNCL+kZY71rHLsMr9wR+LN2Yi4ezgapsrKoRTY8
 RNWKfCQ++NWzezZXtK2jERwznSBk53jqyajWJFx55ePHT9mEoX6Uty5kJ7ll8AKuFxMM
 14w3q7mhJ9dSXLf/BNJeHRsg8INCRXIsV7qT2+7LrCL3qLjlNRxCyrOlPj6T83/hxkup qg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68m8wjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 02:14:36 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28KM67O7009919;
        Wed, 21 Sep 2022 02:14:35 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3c9mtqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 02:14:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JurMt8o+E+MwzcAxQScEfguiGHdbo6pXj0filRWW3pWdk2LkEAZJF6J8ydzY6DFcElIO0hUMkos8Kc+t+c1lrcz5mV7+d2ILigX3Ljh9E5BPv+vifIL38St5CI7KJ8yBueVt/SNQC6ogvlSOj4I7J11ffowGq4ZKUxesP0M4JFI9jVhIY0gRpdvvUa6LMxfIRiCfEPrAnEJek40buPeLPRgKHombJcjMxbRobSb4HfkJU3M65kkK+uw9JMEnyp5YVHbBHA9Ds1w67nMP0IB+yVZ5/YEg6IcBaXXhFw4QnmtG1de5WsF+tBoYKA53EIx3lOZ0RdWETTvGCw6WCuTQRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZMbAQdV/tvMr/UxRNdDJ+xAsHGvvnDdGgbBfpElbD3E=;
 b=JS7nhaj/QfigKes5KwqJVJ46DvC4uJx3GOcsUkTI7TVi/L6g6O+JfbaaFxW/7o3Tw1Hq5kaEIIAD9+Ls8cwZbSsG3/Fte50f7mbLZ8N8LoTSIH6qQEO88n2QigViJFXzzNtrLsHxcHZv8gdEA+wcFqtI0Cs9mG0Ynkm0ThSSAQkkURxfIPzWa7Dbq8gvSwbMqeT9QD+GugJ76TADucZrFACB54fAnYStB+jACVc10r11vgKsrOizXzcpLWm+Ay8qVbYlhMKvvnzaoeWg2equjHdLybx6YsRSgnGz9h7OQyKodo+YZ3kgWDGEnfnOM951c3pR+eHFScayQhulmPm/2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZMbAQdV/tvMr/UxRNdDJ+xAsHGvvnDdGgbBfpElbD3E=;
 b=wQh2vBpydIQzcGZ4ewwT23OWiob9XLT7VmZUvPhw9mxLzA6+Tem6kH9I+DHPJKgKIlXqVEQXiQIksJnUs02m9doocSCkimr0gsKOGBavTtFjJ6fukwwMkRhoo/rBKhrs7rY9ndWrRmZfj+Jt+BR3BBAU0ttgxwDL8hoR76tUvSw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB5211.namprd10.prod.outlook.com (2603:10b6:610:df::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 02:14:33 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 02:14:33 +0000
References: <20220920124836.1914918-1-chandan.babu@oracle.com>
 <Yypc8E7m0aySJW3f@magnolia>
User-agent: mu4e 1.6.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 CANDIDATE V2 00/17] xfs stable candidate patches for
 5.4.y (from v5.5)
Date:   Wed, 21 Sep 2022 07:43:54 +0530
In-reply-to: <Yypc8E7m0aySJW3f@magnolia>
Message-ID: <8735cltqwt.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYXPR01CA0054.jpnprd01.prod.outlook.com
 (2603:1096:403:a::24) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB5211:EE_
X-MS-Office365-Filtering-Correlation-Id: e7d59df8-d3d9-404c-08f7-08da9b770603
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b5G6fZvx39MHOJN9zOx3CxrG8Egi2d6pex/jxsSt+1VkpwEpUUeRWjoFJ25h9Vd72RaKWZAAF6Q/CjTnLukNhBCAey3rQxGo+TS8nHH1pfbC+w5yWT6x1zOWs5Mp5nnMayafLgJ8WP0AjqYTOF6TtwocHqP6v7wdBx9DITGKzUMuSIPklRMfouRTGG6gdt7Rse0itPW4g6qO5bmNyuQ8pmZXDfY4/6vg1s0Lo4MG+A/bF4YlY/O1YejNsRbIMA8z1+7O/2XiL3zkc+K1LmZpdaDnUAX/8WxirxYDj22EryT+3mIevFe3rT+owAIO0TT18lNjiKHYoJ2MMFiKdfOBTkDhi9s8hdjW9ZtpKxKviUQFJ7jI04IIp2ScX9QQOHMjIHGwcALQYMW+wAgC5USDiIY54/C3v+i6qKkPByfCO8mPRLZSIcRDWuZf4FSZYhwvN4mSYFTQXjg251kDlQ1/TzBfAv85JQ6+i4up756IBKM3D6DzIjoIU+Qk1RFIHdsGNg0LGf238zaAxGyPRdnNp1lRBm2dq/MErZ2743r9skSFTTSTY5fmrzyVfSk+yGjbMnkqQUk8Of98QcV5iI0ieagyn208p1L3d9g4JaN/gjlwwgk55GEh1sm/T4ThR7m4N3vbFaPGCjymU85YMKD1XoQwABBZ4Jz4lNPl7rGiPSGXMbF6PAG0SkL2tlmuz+QLedLqZX4ksljEqDmsiJit5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(39860400002)(346002)(376002)(396003)(136003)(451199015)(6916009)(316002)(86362001)(6486002)(38100700002)(83380400001)(186003)(6506007)(478600001)(53546011)(8676002)(66946007)(66556008)(66476007)(4326008)(9686003)(6512007)(26005)(6666004)(41300700001)(8936002)(5660300002)(2906002)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?15x3X86fTsO62yEldwVX42EMR4SYKzbinAIaKPjHZy2n2kd9lc8QONPuu2do?=
 =?us-ascii?Q?8zgfFoVJpmIIrbnLNAvQbAilsPmqn6mcxStntgsM+PFJ8P8sa0rODOUNHG/5?=
 =?us-ascii?Q?+ijIoPRqrdq0w1/PjYCjU/wF7uLlxBDx1QD5DdzU37KP9zBpI1s4BLptU0+y?=
 =?us-ascii?Q?bPHxBR0zeDCGhGS9bcN5MZqb3rUn61TJfs/KdfJOgMg3gTUQMsFiXEYabkz8?=
 =?us-ascii?Q?fkBfgmYsKka2UUgz2MvCyhdiuRAr2CQL+mKLB+R05DmMY/Y68EQO+KINyB3q?=
 =?us-ascii?Q?+m+A4i4wxO1n9E4QiPqup/gZx8mOvh69mfphRoM17dIp0m/PU/s/COqHbOPN?=
 =?us-ascii?Q?MhfD4zlzoyTB85zSTcxybCte52RZyYN9dvo4d607iHSCky8JfhQEHMALm6qa?=
 =?us-ascii?Q?QPJDglbnx3qR6zuPTrcIbtd4wd46cOpJgFl6lRFiZyrg2/eEw6bB8Bbh3CQE?=
 =?us-ascii?Q?9nc4+BbVD9M0UaaehFU0Xe+P8x63MhvOR3T2Va/YDtKNCkYhwM6tqn36YtOf?=
 =?us-ascii?Q?xEKUvA6p8n2nCs/3pAVlfx22PS8BvmJljeN31bMrl7NGGdio2zbL3OzOUzXS?=
 =?us-ascii?Q?0NEzx+zso+gPXAw9HqjvCpaLW1Tlg3LI3TbSyVZIoMgMa1K3pI9qCTkWaYXy?=
 =?us-ascii?Q?W6ceCPWj5VMsEbtyDa72OIjRGKOvyavraGUlfoBPQkqRB68+BwlxQTctGfZi?=
 =?us-ascii?Q?pcQE0L7FAeru1txurDGsEozcOf+OLP+R2g12J5Y3pXQfkJ3ieSazdEwF7Jyc?=
 =?us-ascii?Q?Gz40yAEij3OYMU4KQ8hJNYOZoQntLc1Koaxh5kr4I38sq/HxiRmZ6u+ZDX13?=
 =?us-ascii?Q?Z3xzDAMU7gRcJG83fEOAQRhmeCWIvQnGx/e/yZT+A6vgS1GHKJakhO3DGInB?=
 =?us-ascii?Q?vxUGyp436O5jatPRXKCNgfwR46Utv0Cgtk9fT2xErrX5mNMyXLpKOjs9mD/x?=
 =?us-ascii?Q?eIZb36ZuABbTreR3CRkQy9SjdG7ELI0EaovdJWglTO2JYZVSXHHfycxCauZp?=
 =?us-ascii?Q?V42aBPFIrOtty5daUoERuTCVwddErGv4okMPQ/ekTmWu66lcXWPSbEP1YH2H?=
 =?us-ascii?Q?ty+tnr6VYL2p2aK+Ezhq6MQoXqZNmqAmF0aS/VEyegj2q1nO9Lds3HThheVT?=
 =?us-ascii?Q?aojV678V9OtBQiSwg6zNxbZaqOTGxaY3k8Dt3zphpmLb+6MZDVfhKTu7SI15?=
 =?us-ascii?Q?9Kj7N3/80e8uspp0EzYetNfaQL6XOPrAD5edrbStqLBC2re4PyW3qGpepC7K?=
 =?us-ascii?Q?GCoRAs4+eCRG5q3nW/b85C25rww/rpEujW0lUpQrACScJ1JbUO6j2stSDc0J?=
 =?us-ascii?Q?kI+Pfmxu53u8s39TYa3XbmBXyTp7l1ELDXe286NnjZ7GXJah0tegrVconPoN?=
 =?us-ascii?Q?W1SOn2KL6qS1z20yb8AlRMBH+t99y8OURfT/paUSVly8gdTKdqrTSbarWFFi?=
 =?us-ascii?Q?p8EPxUOsjbTFvCcov57BDGMu5E8AR6HfrbZ+ZNfwbDXPOSa7Lzi1OgiEWhZ6?=
 =?us-ascii?Q?Z2nxl25WtSSYjHnLh8BzgCpCXmhyIC/gODTgBUNjviRxwt3fuvIdpArffafs?=
 =?us-ascii?Q?giYoGqaqi+nuZM1T1xFWrReTfUEUjW5m9hyTblGNL8vzDkJktMNI6Jn64a6u?=
 =?us-ascii?Q?Ww=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7d59df8-d3d9-404c-08f7-08da9b770603
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 02:14:33.3590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fBK0Aprst8fF+ghpEfvYXvzWuo3k049MFtAIOZldtZfY8eU0aVOloofPQQZE+g2R/Lxo+EgB/vabONbLVfTAHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5211
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_12,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209210013
X-Proofpoint-ORIG-GUID: k8w3VEc2MXGidmOOQmbhoeyh-sZK4pwS
X-Proofpoint-GUID: k8w3VEc2MXGidmOOQmbhoeyh-sZK4pwS
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 20, 2022 at 05:38:08 PM -0700, Darrick J. Wong wrote:
> On Tue, Sep 20, 2022 at 06:18:19PM +0530, Chandan Babu R wrote:
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
>> 
>> Changelog:
>> V1 -> V2:
>>   1. Drop "xfs: include QUOTA, FATAL ASSERT build options in
>>      XFS_BUILD_OPTIONS" commit since it does not fix a real bug.
>
> For patches 4, 5, and 14:
> Acked-by: Darrick J. Wong <djwong@kernel.org>
>

Thanks for Ack-ing the patchset.

> Since I suppose we /do/ want LTS maintainers to be able to run fstests
> without so much ASSERT noise. :)

-- 
chandan
