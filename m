Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29552C77B73
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 06:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjFEG0x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 02:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjFEG0v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 02:26:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374F5D3
        for <linux-xfs@vger.kernel.org>; Sun,  4 Jun 2023 23:26:50 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 354Nxwo9006967;
        Mon, 5 Jun 2023 06:26:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=lVDuRtLCb90ma9xDRDJBvlp2/JJQcugI4DxPaQhsX2g=;
 b=A1GRdejEeg3SgcAsdD57GVC2DJmmyvG0YIwwpaKm59VRI5X1TRpMz/8QwoWzIXc9wIEK
 kJ8ciwo011u0q16eB7kttSrn0aG8QtUK1gR3Sd28HLzOzVtLSKYHfzP3yJMzsig0wzpK
 x+z747rw+T8pmUaLj6JT0UP59C3RLQU26wmMaiiCaSol+chYU/XQFoOBw/cHIEjF/lgm
 iz/ytIbdJSi5+T9rzjRCClmFOXZlpovm1UvT+RlVat5GqRxw2cxd57MM5xQkSj+J0t14
 ZcuF8EaUPg5NRtg5WNTR5LpklhGnAWsDBcgJ6pCkOhbL0Q+GcnOIn2mdi+UoyV3tOvIB xA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyxh9j5c3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Jun 2023 06:26:40 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3555RAIN010474;
        Mon, 5 Jun 2023 06:26:39 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2043.outbound.protection.outlook.com [104.47.74.43])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tqb2ek0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Jun 2023 06:26:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uodm0lyLg6lPZraWMQQsuP4+4QNOUHt5/Ce59WLm5z8rfcabDGi9+DE8bDKgnBrUtBfviAojriuVkqhFZjS2nL25HlW/DKtI9E27Toh5Q5APJ3WcfiL38nO5siCDJp069zVrzAdZmmzt7FisoupgFLyiCZUAUQWZo9YCSwGkRGfg2gQMz574C0INRm75K4CyuGvOJNYp4vrBi9mTSH2oTijJRMA3n0NBpWxlH6AZzdpo4wj8IA1Xx/Yahiswm+9R2WLCpqlV9o1tLONir5owjOKFJH2UZiMUkbUj5G+MNP0t7UBzrf7fc+uzlDT3LVxmtMcG9wcTBBalMRfdh5ZhKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lVDuRtLCb90ma9xDRDJBvlp2/JJQcugI4DxPaQhsX2g=;
 b=k5Djc6AsY9ceukn5o7+GUDlrHflijyXTKbUjZva7LIuXc7sNmJ2zJB5PcPlewL/FMoKo+PUkr+WFxxxVV8bCmpJXFd1lW1gJGxDmtZrQePYhcjB78AlCWEzESbOsV7zVmI+n8DpdI8tTLUNBjCncDvVBMLKCQGlcon4SOlFY98n3gaunYrQdD0LRdGNvdYQQjFz/KiGl3lgPt4Wu9s5Cy25DQ3UShcy9Res3JHgsAcynArRXofVmJ0x2Mnw9C/uw6dLQiiNovL4nxvgNtEI9bXSJpDHy2InBKTZx0klBxoKf+2u9O/OJ7zRZEqImKV/r5zAvCCf4rSOdsig722eJ1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lVDuRtLCb90ma9xDRDJBvlp2/JJQcugI4DxPaQhsX2g=;
 b=wSifYqg4cQ/asrfWv/1xOuiEuvAFsb5UwJozM7/53nu2vxs6CQRvMKfZ3iT7b8WZoZBIkVdrtnTLbJex0xi+50mPwztui92m9VNMvNGjnrOLP6u6dbYEyhMTdZWZUpff/TuQJUda9bMSc5aNeNnC5h7E17jIvcDdYGu1ur47kNY=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH7PR10MB6966.namprd10.prod.outlook.com (2603:10b6:510:277::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 06:26:37 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%7]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 06:26:37 +0000
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-24-chandan.babu@oracle.com>
 <20230523180959.GC11620@frogsfrogsfrogs>
 <87edn3iian.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20230602150226.GO16865@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/24] mdrestore: Add support for passing log device as
 an argument
Date:   Mon, 05 Jun 2023 11:49:00 +0530
In-reply-to: <20230602150226.GO16865@frogsfrogsfrogs>
Message-ID: <87wn0i4e7e.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TY2PR02CA0032.apcprd02.prod.outlook.com
 (2603:1096:404:a6::20) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH7PR10MB6966:EE_
X-MS-Office365-Filtering-Correlation-Id: ac085a06-8f75-4364-de3b-08db658dd10e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LQgZbk0xIwaUJlNCigRlFhOY6wVuBPnPIc+12U/43huP9MWv7b2/iYGkacQtU+5gGT94c4E9LUn9MygCwX0ryjk5hpe2AOFdSI16nobBLKMS3nHLqEDfppXxJIdw2uxOO3l9IWJt3SvYvl9OpyALAUzQWyasjvbx3bjTm7GYDm3Xg71nY+QTP3sxKRktdmdZyb4E6klxvKSDWkwUpl0HUPX+taKgJpX/xvSDQ8Al/v4b/5zDYr+UeBw3zq6QEKo16sQXNLR6VqhjmJooVSgwq3KNNwjfjMa7XnJT68vSYryXY41vTQmJraBZYgppqBCdASWuAP52jwnX3TLsgBTECO43zVvSoW7P68Y9iFGJaoXeUby2PRBp2Bozo+QiFWucxfWAjQNcFCfQHZkJxjuSC63Sc+LU4dm9mF9fDWSDgfz0g5+lA3vMzSg9ILSo7qRhlt+w7bn7pBELfzKw8U/qNGTCurE4ZQ/FbRCCa9mJNnZC6X0ejAxqOMjfKNjxpWKiKBx/SU0bsrql5WsJA4E20o7AyRkkTvabOTIU5n3B0sZv5wxZbVhsLGMWhq6SKnSbyo9ZllTIf4BOhrv/F+rfIgPZf2mMhJwrMYQWNfap3tE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(396003)(366004)(376002)(346002)(136003)(451199021)(53546011)(9686003)(6512007)(26005)(6506007)(316002)(83380400001)(6916009)(66556008)(4326008)(66476007)(66946007)(6486002)(6666004)(186003)(33716001)(478600001)(2906002)(5660300002)(8936002)(8676002)(86362001)(41300700001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SVzQp2mqUgCbsK9j9MibXNHVVIX/6ZPebUXtTMmD5Xw3/bfdF1ioe1xVGENQ?=
 =?us-ascii?Q?+QPQiCGWvmCXdFnE/D2hLYhHoYIj8UYbDuRsWvlDQVCvBVauTF41R5f9ORiJ?=
 =?us-ascii?Q?fSW6aIxuWPsriCMfV73+FFRRti1b1h43++0UuGhz6qdaE5nQ17HIojVETf/e?=
 =?us-ascii?Q?yM/xE+HxaKw/2n97NAiyVfXxdm26CWxht5RHGYV/zPA/6O1i8R5IcaUZLe4B?=
 =?us-ascii?Q?O1WtTTyoU+ZV+nCDiDPQB0Z6SMEFWDUsZ6MlNNeQ3abZXSe/VwzEIBgE+F1L?=
 =?us-ascii?Q?DgxJnNRC974EvtOy2WJyZggfZ6EQJFXoiDs/nROL+N5ZTazmc0msbvv7wLjq?=
 =?us-ascii?Q?lfYd6vZ204f0ChNksogEZyJ9ENkpCYh9bBLosUlxUYslNSOjUzUofMyU3ve3?=
 =?us-ascii?Q?mSMVPB7/ascXy7pjLh4aMvWOxdKtkfIrXegTmFLvqL7fE1gQMcSHFb6t1zZ9?=
 =?us-ascii?Q?K8o+jS7xBCxqhe/emi3MjWGv9r4XqfzgaOoW3TqBTMxk5Ubkk+ST562ArVNQ?=
 =?us-ascii?Q?8ZpC2UCN9V4SveJT2C1ps88QxncZt1fbowFg+uQDwF6Br5Jwq40Q869x4Qh6?=
 =?us-ascii?Q?WJozt3MNnoAT2LJ2zrlW3zjTKD1lU3Wrlsx0Z0jznID6jFtTEnYzhD+gJIHa?=
 =?us-ascii?Q?1EPCc1A7oIK/ruC3wZ379HUcQHnlER31YU17jJ7MLY7jcSCMpEk5JTsIzT/s?=
 =?us-ascii?Q?+rUF3LI4WIPd3khtq2rV2kIOIVGDdjvOo8CS3ZeF2mljBSqzrM2mZUvfGhao?=
 =?us-ascii?Q?PeQWziK6rOcCR2MdaoL0PS6DBs9RhqwpLc67vY2bk096pM232NbN9UZtS4BT?=
 =?us-ascii?Q?IIG5lnsLyAuavsCwj5vjP75/1+ynFZYx6NGX6aYN7wdu1nMYdSO7eRM/RKQn?=
 =?us-ascii?Q?WDCmU/PwgOW2iiJ3KiTs+fFoj5xMU8MW2Gn7hstzclTb1tbcosTpoVBWDbUw?=
 =?us-ascii?Q?nw6FTJqytGJBC728Cd6tUqQezvclsh09XQ8Rq4lczAqZfZa9pJPkRt+moHgM?=
 =?us-ascii?Q?OiRO4rNV0O1PN+lrvPA0ZZGMew+m10jMxYsMIxUI6+7pmzVtK79rCUKyxAMH?=
 =?us-ascii?Q?CRR2ie7GEx0IW83FZuOyIp3nZD3AsZpeK9t46hQeWgThJBpKR70wt22zR8Mv?=
 =?us-ascii?Q?Cv5CCFdvHoDLsyNyr2134ciwYfxC6FjHMKtpJxQZrNJx+7LcwIjNvnBQCt/y?=
 =?us-ascii?Q?3pazXCzYt9NSRvtJRlaxt/jBHKAFnqPDNg479RsgoTodIdV4ztLRyUwD4kAl?=
 =?us-ascii?Q?D2KxYcRL4jjN7U95f8a40YSPae7abECT7QheX9k1GyIgam46NwUf5ltgZ0a8?=
 =?us-ascii?Q?QCH3El3Tb3VUwIbWqUjDWAQPiyrtXzzVXB0nNkdL3gQn7PYQ2HXSzvPEAQCx?=
 =?us-ascii?Q?Ps64uogJr5y+uCfG2wYBRmR2nnEQUKOfV1XEtI2s5eK2jRYn8OfTIyXCYuFo?=
 =?us-ascii?Q?hwNPJLzNWHVcuQDdmcgbdHW0PULnjkxDTsnK0cjNbwu2+QdIxwrdMxzj34PG?=
 =?us-ascii?Q?NCOv0b/nJtNYq35dAb/jBH9kbf0VMo4CTJZRnmrbfcjrDr1GGfsFiY3zZNLZ?=
 =?us-ascii?Q?WRxJ9mhT7xLBW1DKf5Y7V8ru9lrJqXsUgIoXuMQW?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: IkB+xcyGip47F3ebAT5y10psDiUpd7Ep3imkOkUFborVDCuz6jza1AB2FW4cNWm78rz98yfK+Kjl/rpYzpzVs6Bez0a+pqO1eTsBHIQ3ZMUexiTTDZusrxL8jVmKL5+KcCES3vC5aWbU1EOJhieQCbFh5kQ8xZtb2kpT2pQg9uNLMoqrRspQXTJxkDswFnFvbFJOmNj/u9SuNjyStRZCKdrCO4OBEaaC6AdFp17BnnXSU14vNNo7aH9AmqgD3C1sUeneE/Mc+WwQh41Ed1L6aAaeXHgGmGyj5s7Nt4a2jx6Vs2v0PJ8dXqR78Zg8OyDIiRZWKj5QGBjNCR9i7AMUE5sCGR15vlOmYd51rLNItAnKfhpiM6vOuLpDti8fYR9IiRgb8CeePZBvRQj6qY/BCSvAoG31wVAGpe0udhsSq09G9lpKYX9lYaLweTfWqCpeR3IxPMqDshKu0NOKS9TbPUAl55+H1EX804Rh+m0ZtZsMpHifro84chz4RFhl+mL5hyp9/BILMi278aadHtbGOJv3KPeIqRwBZhUEi6LIkf+ynq7trFkakIyMFx/BA/+Nttx7zJeksQatfJqFze/9buQ82cKoHmFeB8ah13Kkj2+xKWVRV6uTWVv1k7v9LxQGHJ7NaqCXJF0VLNXUjgJqyfMXMq3mXz7TrTIqPoKpx1HBI7JmG5wa2UfMCa293BwpuVBIJfBvEh8i+iMOCRInocDHDJ4RN3PHqpPT4Z2cG9dwPvR3HaRhKNlvCqVd0WY0HxKKR5+rcRodu1JrnkkzntKtcpcpDeSEptrx393f1Oo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac085a06-8f75-4364-de3b-08db658dd10e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 06:26:37.8249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cry6WHyOT3l+2JULEumoNXF/oFFOTAG+BD5D3Ch3BHfdaHvqoM8Yl1VE5V0/ufPL2YvIoEOMOJxoe9cerVK5tA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6966
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-03_08,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306050057
X-Proofpoint-ORIG-GUID: Jx9GTNwcPgd1CX5maD_tll5KJckBVVJI
X-Proofpoint-GUID: Jx9GTNwcPgd1CX5maD_tll5KJckBVVJI
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 02, 2023 at 08:02:26 AM -0700, Darrick J. Wong wrote:
> On Thu, May 25, 2023 at 07:13:03PM +0530, Chandan Babu R wrote:
>> On Tue, May 23, 2023 at 11:09:59 AM -0700, Darrick J. Wong wrote:
>> > On Tue, May 23, 2023 at 02:30:49PM +0530, Chandan Babu R wrote:
>> >> metadump v2 format allows dumping metadata from external log devices. This
>> >> commit allows passing the device file to which log data must be restored from
>> >> the corresponding metadump file.
>> >> 
>> >> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> >> ---
>> >>  mdrestore/xfs_mdrestore.c | 10 ++++++++--
>> >>  1 file changed, 8 insertions(+), 2 deletions(-)
>> >> 
>> >> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
>> >> index 9e06d37dc..f5eff62ef 100644
>> >> --- a/mdrestore/xfs_mdrestore.c
>> >> +++ b/mdrestore/xfs_mdrestore.c
>> >> @@ -427,7 +427,8 @@ static struct mdrestore_ops mdrestore_ops_v2 = {
>> >>  static void
>> >>  usage(void)
>> >>  {
>> >> -	fprintf(stderr, "Usage: %s [-V] [-g] [-i] source target\n", progname);
>> >> +	fprintf(stderr, "Usage: %s [-V] [-g] [-i] [-l logdev] source target\n",
>> >> +		progname);
>> >>  	exit(1);
>> >>  }
>> >>  
>> >> @@ -453,7 +454,7 @@ main(
>> >>  
>> >>  	progname = basename(argv[0]);
>> >>  
>> >> -	while ((c = getopt(argc, argv, "giV")) != EOF) {
>> >> +	while ((c = getopt(argc, argv, "gil:V")) != EOF) {
>> >>  		switch (c) {
>> >>  			case 'g':
>> >>  				mdrestore.show_progress = 1;
>> >> @@ -461,6 +462,9 @@ main(
>> >>  			case 'i':
>> >>  				mdrestore.show_info = 1;
>> >>  				break;
>> >> +			case 'l':
>> >> +				logdev = optarg;
>> >> +				break;
>> >>  			case 'V':
>> >>  				printf("%s version %s\n", progname, VERSION);
>> >>  				exit(0);
>> >> @@ -493,6 +497,8 @@ main(
>> >>  	}
>> >>  
>> >>  	if (mdrestore_ops_v1.read_header(&mb, src_f) == 0) {
>> >> +		if (logdev != NULL)
>> >> +			usage();
>> >>  		mdrestore.mdrops = &mdrestore_ops_v1;
>> >>  		header = &mb;
>> >>  	} else if (mdrestore_ops_v2.read_header(&xmh, src_f) == 0) {
>> >
>> > What if we have a v2 with XME_ADDR_LOG_DEVICE meta_extents but the
>> > caller doesn't specify -l?  Do we proceed with the metadump, only to
>> > fail midway through the restore?
>> 
>> restore_v2() has the following statement just after reading in the superblock,
>> 
>> 	if (sb.sb_logstart == 0 && log_fd == -1)
>>                 fatal("External Log device is required\n");
>> 
>> Hence, In the case of a missing log device argument, the program exits before
>> any metadata is written to the target device.
>
> Ah, ok, that's how you handle that.  In that case the only reason for a
> flag in the v2 metadump header would be the principle of declaring
> things that happen later in the metadump stream/file.  Your call. :)

I think I will implement your suggestion regarding introducing a new header
flag to indicate that the metadump contains data which was copied from an
external log device.

This will make it easier for mdrestore to detect the requirement for the "-l
logdev" option much earlier in the restore process.

Thanks for the suggestion.

-- 
chandan
