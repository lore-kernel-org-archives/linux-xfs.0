Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 691C9C7EE23
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 08:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242344AbjEZIzm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 May 2023 04:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242647AbjEZIzi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 May 2023 04:55:38 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE5118D
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:55:33 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q8YMAd013646;
        Fri, 26 May 2023 08:55:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=DSseWZWVA7JeciHFZRU6ZJQbHzQ49UMwU6zKXjJLhU4=;
 b=SbatvpQqpSvv2LeRlvtkSYiGx1wCD2b1RydgAbYL/dbdUbbX9da/9H03TRqYqls+cPVx
 djJYPgi7zjFt4XvAAbC3KHVwLC25cLOEgqxAoT5/IuE0FMrxkymxp09cdEomcLV+07cZ
 x6vhFFQJkO8WJsyV9ZmEdqvWFLvFTiDdLzAzQ0acHuj/Qd5aWoZGpq/Qbb15k1fzymdH
 9mPLGkF2SWrGl7d0dkHJ1CvwrCDdbhFaebHZB0sIMlUXNrbz/Y/0dHbduiDrbxRfNjtu
 0OYvrqLmeWx/axnt4XV3n8a31qyVEFUkZhN29AKZ1gwMi+efraKg0P0c1B/uy5ngeVrj LA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qtscd825t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:55:31 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q7oba8029349;
        Fri, 26 May 2023 08:55:30 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2uy5qc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:55:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jiuj0M163ckGIQdaCoEwb+vMGegm2jgfGTmnWuFFMgGHFynYB0ydnd71+V7buUdaMS3c0lSDJjDr0ivIylXtdOF5QJmuaCFM8EWlMU9fJ/kF+wstSz+5jGQNlOA4AwYc7s+T/7lD7HpM/KYvTFSboxyddPh8T6Ymw9t8FBRYy7oDHw6ZYLn1YVYuA5CSxmeHBjJ20g59yUI/wvqh0LbwZPleNvl8I2UfXdtU86+fFVQ3ol4lX/OL6K2hYukpapdaUDZqQV4bvb2sTvjeKMYQ4wuU9fiW89EN56WbYEGDgLcJMoWxr1xLH2aQMKo8ZYWPd4nlrewcBUccFY32vUUV1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DSseWZWVA7JeciHFZRU6ZJQbHzQ49UMwU6zKXjJLhU4=;
 b=Y8E37CqRTSCSw4/iR7FXbdi7EW07qqoHNt1OFlINl1iN+qE3u1j7WhmL0ZaF8GiYuv1CHibZ6TqTKBDPDygqIe86SuiTkqQ0WiOj9GSABwMovoccdR/W/XlgWlucUbsAaurBvomxluiUoKxzGe1RHvmWeX6kOxGuccEiQJkD/oZfFdwRuoMhJLoFMDzNYGsa7JE25Ls61Oi5XnU1Eptb3tTFn6ZccV3bpDF656Z7WXbQ2sBwDJgKDON7k/r05wQ/ZzV9NH5d2kk1mXvkRTr5933c1Ia9giMPDVvXO7jjCLAvjN7rJWGgajCOoU85r34a7Ybm9MsNMu+92mywMtPzbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DSseWZWVA7JeciHFZRU6ZJQbHzQ49UMwU6zKXjJLhU4=;
 b=mSORy0MxM+FGgtNQlFJirBzSBR29bfO1yE4uQLhzi3YWU5fHEZHRq5bJgCoz0dM6Iw/igVsCYVBvE1cn/eFRsos9zd6zcii+fU+FQ3VdWroV+9MECY5ZhcWSNx62d6TbFe2W5/6diMqnPI+X0QWIenp6O+GNe/VX36EwAS/kz5c=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB4439.namprd10.prod.outlook.com (2603:10b6:510:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Fri, 26 May
 2023 08:55:28 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%6]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 08:55:28 +0000
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-25-chandan.babu@oracle.com>
 <20230523181056.GD11620@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/24] xfs_mdrestore.8: Add description for the newly
 introduced -l option
Date:   Thu, 25 May 2023 19:15:53 +0530
In-reply-to: <20230523181056.GD11620@frogsfrogsfrogs>
Message-ID: <87a5xrii9z.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0065.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:31a::6) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4439:EE_
X-MS-Office365-Filtering-Correlation-Id: 95de3c35-00b3-4f5d-38e0-08db5dc6f3b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mDVNViyT77P+MLpLm6khw5eDKer9YLUSyhCftj+kHCC9ykILigE6BgKvKrlw1jaQ7RASjMln2BlL3SaHh2A/x1BUjWsvnBBBCdD2rAQhXXrXw7MzanwZoOIk3tL7ootuGqjnN6p7MNeX/3Dyj9e6nR8CJSuLEAAsnF+U4jwZZfagTdkxTlre9MhpNyATDRK54R//TgNwNnjRH0bz7MSFPAdHTG+3GQ8NHiitbvSTPKkeP74PvXfe/3AvjibgvwE5g7I9fPlP9JcyOm7GJJCHimKPTvxCuJzUVLdQZEDAGra7vTXDf2x1X/RUw3wfANdMioGLD3RwRfBvv9PnEvHGSL/gyjN4eg+5aWLzJ1L/K2jpjbfNPNJpICA+dtQgyQCpP8gfRhMbfGOSO1swwwZ8iuU7qHptACxhv1iYtyBqMvz7sNSgMZLasaomXxavmeEwJKhUU46yaADH7UuPZvF+7rrXJorxkigneFEhkEJxKmeLShko8IcJIjWXNP6gHZerNosA6twzvHEPUAL5VNuY4uyw3uVrH+4zCgW6gnhjax1KUZxLVYVxL978meoSnP21
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(396003)(136003)(366004)(39860400002)(376002)(451199021)(83380400001)(2906002)(186003)(33716001)(86362001)(38100700002)(66476007)(5660300002)(66556008)(66946007)(316002)(6486002)(6666004)(41300700001)(8676002)(8936002)(4326008)(6916009)(478600001)(26005)(53546011)(6506007)(6512007)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jTBTGJEgo0FrsKExTVaahW2Xd7mjFusNmM0+KfvT0vXFPrloVnWZvv8o9hVn?=
 =?us-ascii?Q?OKMC3uZFSNLUt8NWuOVBz9UTBjiBKzpFKB5Nr90umBJylieaz4r4pACTBKf4?=
 =?us-ascii?Q?yRjWtZ6pncVirab0tU/ebI8bnfW6NttoOKnBBCVCpF0BjQhr6I8Ojrpzt8O1?=
 =?us-ascii?Q?V3pRWZQmg7VGO73e2lcU9RGBXoEkYDCXCwBPlHRVo7kZzIPAMeWZy/aLeJNn?=
 =?us-ascii?Q?Yz/OCgpsbpIeblyKG8Z7zjXOZP/tJt3boW5MOlAiOz0f0dXU07RYMRe9joQ6?=
 =?us-ascii?Q?xtpk347/pN6fJ+KP73OrnTnCULS5pfpl2jljf69i2hVO1CR6FUOuieran2ai?=
 =?us-ascii?Q?vUbqCrXxHjJeVsH24gIELlVr1dUkKkoWho5sI5lfuGOnVkP0z2MI37QqV7dz?=
 =?us-ascii?Q?TMMlHmOAhldZz0ti4lWQH6t549C4sH8WSrzRCwdG+wB2Kd0x6oe9vNwLIAEa?=
 =?us-ascii?Q?vz9EblS2MfutGQk7rtpPxFZNKpjVW6fKA5iCpxZfl0aoN7WS7XmlqdtmSMkv?=
 =?us-ascii?Q?plur58P+Y5fYi1SV50NtpLjq+1jshY5phcNtcwLmad7ot/3hTi6xI6GeKZQo?=
 =?us-ascii?Q?dKA64ArItg4wHEoISwvK453BzGqfNVJ0iTyXhD6zCQ/2F8CDax7+/16ZT2vD?=
 =?us-ascii?Q?+u0BeNyczMwXUgdo47q9Lii/o9bu4Qtov4aay1akTBv7Ddwsy/4TpZBZNIK4?=
 =?us-ascii?Q?Bjf47h5CtXLu2xaogwM90jTa37yhcX/ewdxcKVOHeJzactA8AjWskzBW3KpQ?=
 =?us-ascii?Q?RI8kz7tz3aWOFAknLOGTvV53E5KKe5T45cJ73034x3ERD5RuoclSgixEXAXj?=
 =?us-ascii?Q?km7+Z11y9YlTWdaHyxY22IbJ+/KJfoXq7SfDyYwD8jOu4xKNkLkqnPRLTOBs?=
 =?us-ascii?Q?GQsIXYw2Pn+Qi8Ff/vClbGu/aNZFqK2TrMFJPwYLzHzoV/uskk830s6qQsmD?=
 =?us-ascii?Q?SHzkTV6ZeFH+vTaQVh8MN3k2neB8yDRtDPPK22mretNaQlXuOmJ+jk+NXWaA?=
 =?us-ascii?Q?+t7YmJOYhMMZOK+J4VN2LCDHRDFGH5BbnS9NT4uHi1M9LTlrZn5MAotc6VZt?=
 =?us-ascii?Q?Q7FPi6CvC6/2vef71uNmcx1rqFn1/fgs0GjhIiKezB2EnBWvgmIej8zuIVI+?=
 =?us-ascii?Q?6NJHHWaUwgkx2K6DkKa+duwPFG0Y7HknovM9z/1t7GDeE7+nP/wTl7uexWpR?=
 =?us-ascii?Q?S/r9Z/T6fO0wue0zY81XaJDMWzlmhFN4carg0QF56Ia5/u693mcPIwIkGYcT?=
 =?us-ascii?Q?SrGAP+MmHIjQ+OoZG2EMO6QvWMkYwPx2UdDYaRBLJs/MTPdSjrmnhffrIxkS?=
 =?us-ascii?Q?pU+Q4Ma7cCSQRLIWQWazMifaj2TioRvxmfZLO/plW7p1QSpm7e28rkMPbkwK?=
 =?us-ascii?Q?ByHmD5pROf1/lX75HX/2Fk/bPyLEX0Cw6iuPd/eNItTet+ZntJfjGXvD6iWH?=
 =?us-ascii?Q?R7aCIkeACywTByD823ijAWdGgh3Y1YJXqW0ikrnPhNflB0MY+NT9BUF60zK/?=
 =?us-ascii?Q?AlqVRlUvHT7EZmh/cFnRmkehVqqeC9LuzxjXJNf4eDFWH2j2jVEn+3Hnv9Do?=
 =?us-ascii?Q?bRRFskRl0NeHGaqJm5IuJdIrJyUWgmB1CDWJQCgJvpk+av1TymFF520ASd+N?=
 =?us-ascii?Q?DQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: TtleN1sfMStiTVhhLL/Bm/aeTvvlyhvTH1vWeBaDKD4JJ+b28Ij22wdZwYxdVuDKpDbzx5JU1sF47LnWQU4ODLYbWSZv1BTEhxW0mmOC2jVS+FXx1C696iq3aY9YqvlgJ+HofCd3L4OkoNHjTH+R4xLHfVd89LFnjlN/OSX79w75sGKaSCztNm6icMGYS3q/sXSjDgMfyPLE2vXBENNDD7hYVJ95FoZBVFxUkH+Nfk6IfXQjkaYLCDqkqSvlKDG2O3ryqYLyxIzdhqcCgF9u2JY5cfVSPQWn0TPPMBLvTk7x0JHlSPrE2LaTRUfddMYZzUoG2W9kDySgXfo2g0hHOgNy31YMqZ4kchXqcawBdOvCd9YO9zNtPbF9sZJtyylqBZ9iOzwZ3qJRy1b13C3y0XRp2dabn7zErl5qyeAFzqtxR5D4plLpkDcL1cUphtMCtGmLQP6MSb6i6ws5imoypUbj81IDUl/h/jFIZY6ZXoS5VT5YjdYjZX7GT5PcveRGuqJczrKBRdDp51SJmJPNcOVRDVIbjb9GGBUH71B5AxbQ+C2ZIAxUGbk/CIglYd2zi7yTn7TZWdkuHyP6h9GVqzJszIfhnEbb+an2HuH2bNTviMwxcS8g0SmkC4tTQLPIwqsFs5Z+cOat5eSAjoZ68XTn7KGpIcUj1WbbL7P8DuXjPvtiy/c5VweEbM70RRgOhrFaCyR5WRTQUOgXXG+lGnSTtGFVpN0mQyS8cNLCMe8ACIFe15EVTUoCUzb/2pIzB8+7PciJAqo9ZtsZy9YY0r9KQjkAqIoCc5M389EpD08=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95de3c35-00b3-4f5d-38e0-08db5dc6f3b8
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 08:55:27.9903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5YmQf6IGKXgwYJ2fhDO1vZYnGPjEUqrMXtMaRywg1AUFgpgthxSdIZ9MthOV2C7LbZx1EnLg5IiwBWzIYXacBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4439
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_01,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305260076
X-Proofpoint-GUID: 9o0ncxxhRXZ80yJO8aaids0SlqggE2WS
X-Proofpoint-ORIG-GUID: 9o0ncxxhRXZ80yJO8aaids0SlqggE2WS
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 11:10:56 AM -0700, Darrick J. Wong wrote:
> On Tue, May 23, 2023 at 02:30:50PM +0530, Chandan Babu R wrote:
>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  man/man8/xfs_mdrestore.8 | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>> 
>> diff --git a/man/man8/xfs_mdrestore.8 b/man/man8/xfs_mdrestore.8
>> index 72f3b2977..a53ac84d0 100644
>> --- a/man/man8/xfs_mdrestore.8
>> +++ b/man/man8/xfs_mdrestore.8
>> @@ -5,6 +5,9 @@ xfs_mdrestore \- restores an XFS metadump image to a filesystem image
>>  .B xfs_mdrestore
>>  [
>>  .B \-gi
>> +] [
>> +.B \-l
>> +.I logdev
>>  ]
>>  .I source
>>  .I target
>> @@ -49,6 +52,11 @@ Shows metadump information on stdout.  If no
>>  is specified, exits after displaying information.  Older metadumps man not
>>  include any descriptive information.
>>  .TP
>> +.B \-l " logdev"
>> +Metadump in v2 format can contain metadata dumped from an external log. In
>> +such a scenario, the user has to provide a device to which the log device
>> +contents from the metadump file are copied.
>
> Please start sentences on a new line.
>
> Also, this ought to be folded into the previous patch.
>
> Otherwise the manpage additions look reasonable to me.

Thanks for your valuable review comments!

-- 
chandan
