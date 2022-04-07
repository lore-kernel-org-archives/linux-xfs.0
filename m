Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7155C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 22:40:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbiDGWmn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Apr 2022 18:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbiDGWma (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Apr 2022 18:42:30 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC511104
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 15:40:25 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237MCkDj024447;
        Thu, 7 Apr 2022 22:40:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Ly7eWVhhKlY/fwSvHvAydHcuRM+YNZFlwghHaUGVsmc=;
 b=RFjiFEXMXiuCUfE/18Rsd83NtTzikWfVY4tSoKBFQBHf9CP1GPhnRz6RFh67B/CFwi1o
 xSiIfgx3oYTERDV/Ve6/CnxILROSwRiuVkFDvjXzkTsRXQaP9dLYUZA8Pp9U6Btiisvl
 m9VaOlHfznWt4ewqFe6ksdDR7fEd2M+y9uq5wxfhsPxrnP2G/tOOQmdT9GH32sgkPlmi
 V9HFa0SZmPZWjXljwUFUF3NijtuJG8gllBzmc7yrR1JLqesv4knyfH9Ge0DPEijbqXtN
 A5W4+gPv2YYiRdkNOJU7gwRTlmiXAm5muWkDI+OtRw8ep5EpkpPg8K6/QH5myLuBlDlv Xg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6f1tdh69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 22:40:20 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237KEQEV013741;
        Thu, 7 Apr 2022 22:40:20 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97ttxpjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 22:40:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JQQp/f4OjEp5ZgYEKfCsf8hU4htnulrFPjFz5YZ8V2NjXET2ZNzxQ3RiPJfG1QwUIXwl8M0RCTUjPwLXQJP9MfwOVpd6+AYoF8p1SZP2JLOaNeW1myXUbYYodIDK35r6TXNskrCXe7pzNoD8qET3q3g2jWvBrn1a6wkjElnoM0qAG1+N2IbjBiq6MZYcJcOYmvS1rDQeWrnaQrx4egReL7ewWGZtNfThgPhB3CE8chGyqohKY8jqO9qjH+yHedtefiPVWyKOZcmENfN+ak9zs9+ORCjixtJ9lgsfGXtZkfstsq23CDoA2XDZ41L1AkZ1PaE3D/8E4KObnaC/n9w+uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ly7eWVhhKlY/fwSvHvAydHcuRM+YNZFlwghHaUGVsmc=;
 b=huRaEZqQdBnVc8ZtEz/zn1s5zvTStkIlYC/nPXGb9BoG6q3AAAgEYNaQGoUOpCjm2iWPR8YWzOyPFgUAXGXUOioNFiKzpbIsEGEuHGg/Ym35Zwv4nJ9F0fLMJjoEhuZ16USitkJi/9NSAuUT3LcbWp8uggs9P67L4xdE1B8zezIHz8Birz/Kr/Y/qnaQ8ElBNnnkYomq+yRV8ZME3idnTrY6XRpWR+5HLB3FJ23ElWfl/i+Yj0xQ7Kt+q5aBsjCCodVNHJcH9dFJb9DUXSTS76wTtd76TpNa4stf9dmYgrm8hrqkHILC8AosPwpfYtcAO5xMS1JdIjEO2vY8IhANmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ly7eWVhhKlY/fwSvHvAydHcuRM+YNZFlwghHaUGVsmc=;
 b=IEyLOTkd0EZUim5CvA8HP9qAIhJ/lZAa2ezT3xYrB7WRrv9tiGeSzEl2VJlcITtJ3EXLoR96/aBKYVnH2oZhVC9WercOAQ3T45VFQ+PIVVCL5foX+zNIaS0N+rHn9Y8utapmiTGHmxm0KFkw8KFILQTUQSZ72MaAI0AETfpfhB4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM5PR1001MB2138.namprd10.prod.outlook.com (2603:10b6:4:36::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Thu, 7 Apr
 2022 22:40:11 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7cae:9826:b522:b74]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7cae:9826:b522:b74%5]) with mapi id 15.20.5144.021; Thu, 7 Apr 2022
 22:40:11 +0000
Message-ID: <ff1aa185470226b5dac3b8e914277137a88e97e6.camel@oracle.com>
Subject: Re: [5.19 cycle] Planning and goals
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 07 Apr 2022 15:40:08 -0700
In-Reply-To: <20220407054939.GJ1544202@dread.disaster.area>
References: <20220405020312.GU1544202@dread.disaster.area>
         <20220407031106.GB27690@magnolia>
         <20220407054939.GJ1544202@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0013.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::18) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23676908-e223-47ed-1ecd-08da18e79343
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2138:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2138A12186437BB44E06F30195E69@DM5PR1001MB2138.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q/Kr5OjCyfnHpsU3MPxGmLqjR/CkhoFCROWSm5J33Eme0GZXC27R3jaYyevzKWBlEk31fMpX1zgHLnZY2ax/Isnq05SFMXSDUgOhC3o6HOkzYrDzeCqoMiyXDTDT63/LeugCepXJ/2BTE7Ca0jPpAk5FrvGu5M5mejAdQK2uc+LkvYxAfTh847q9SziXHzzfUYk+IweGSdUTmddjVjE19tCiP5hxl7UobbG93uxJCHcjQ+EVNaue8gwQHMG6qaFF0clKNKJ93spZV9KugXmPDJnbKECMSrTJoCA8ChiwCkuSEc1W2bqwkg2sTXgIswrYTC9FOOO2eoE8khLCs2Cbw3r7WuuLMtfTMqo/ZwFAxmUvUsB8ZIr/1WMChUQAvX3DiVOH2Gt8zs8/rv43HB/7ChVtSQmn1ojs+SUaOxvITufpYV4xbZnnr60lOVz7Q7X/NWWSvRH2tcJDfSWTAkmscp2DbCfXasld4AlnPDkq5sz7NLBVOXoS2ppOvCTiVOjEfdk3oNotis6q2vN67MZfKrXZkiatAZ+/94y7lN300LiBfblt1naSrSKWlaKyLXsnyRCUDSX0+J39iYlViMzcHp/Jac0Fe/es4MKo7R9WG+rMt9jHonv/Ehurzfh3fZhV6K+vQfa/C4eWX+KOLhsN32WGAhfO/pfTdljBRFHeV93r0ZTDXEkfaTrUzySwjLxscocZjZI3Fn/x/619lVbVEPWDO78DPd41gLdyjwUrw7oAcigS+PHAm6bt1hIadCpkH5f5nJetrBUIGLS8kIeeWrFU3McgRWTk7tAxqCVBN7iKIpju7+Kpa5U08DKIWBhhhD7i9PFfGqKzYurys9w7fQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38350700002)(38100700002)(86362001)(5660300002)(186003)(8936002)(30864003)(2616005)(26005)(83380400001)(6506007)(2906002)(966005)(6486002)(66476007)(4326008)(66556008)(66946007)(8676002)(6512007)(6666004)(36756003)(316002)(52116002)(508600001)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QVI2VDNDZkVncHVOSXliSUcycXRIeGpxU3Mrb29XVjRKNmE5NzM5ZitNeVVp?=
 =?utf-8?B?WXZ6NFRRcDdwOCtDay9XZEdOWVNRQ2N3NXZEdk9SaklGd0o1Tkloc0NXckhB?=
 =?utf-8?B?bERjZ01pUzRlZEkzVkw5SGMva0N3QWxMdXYwNWNyTllUMmpkSmRsMzh5bk4v?=
 =?utf-8?B?NGQxM3huT29ReCtzTXQ2QXZhWWlESTZxam9GS2xGODBrenNzVmZmRExOaVpC?=
 =?utf-8?B?Q25pQWFiUjUwdG1SSlhYNXYxV0lsN2F1UExZb2JoMkJpRThaMXE3N1BNbHl6?=
 =?utf-8?B?c0szKzhHcncyWEhBamVJYWgyYm12RWhWNURHemR1ZG9NWkFvUGhML2YyakdT?=
 =?utf-8?B?NzBJL1dVdTJlUnhKN0I2a2JvTnRZWEt2Qy9ER3BNclhrRmtWMnJmSjZSOFZv?=
 =?utf-8?B?QnhxZlJLM0lpRVhDTmJqNkt4UENRRVMyV1hOK1dYY0xzWGRGUXYxUTVwU1JR?=
 =?utf-8?B?cXhHeU1ZOEp2QzlzMHRGVmNVNDljSU1KYVNVOUxueExOK3g4Yk94cmxQSkti?=
 =?utf-8?B?UGVQckdRai9jUldrUDNPakxkTUFZbnY3V3VwbGh3VFdjOFpRd3BlaXB1QTVU?=
 =?utf-8?B?TTBHM21JTTFXNkNndCt2eXF3YmtrQmo2NVVjQWVkbHNrZmErS0UzS2tzKy93?=
 =?utf-8?B?aVArYTJiUW11OWt4Z0lTTjdaUlE0M3NhbjNRZG9TRnF1L1hTR2lhQzBWVkRW?=
 =?utf-8?B?MDdETFllVUZRaHltSGdzekdnaUZmRTRMdHZldEFiNEhKRlRRa3BSbzNRcTEx?=
 =?utf-8?B?VnpiTERzZndOZEl5MkhpRGtNQURHQS9QNThTWUQ2eFRZejl3VVgxcitlZzJi?=
 =?utf-8?B?bzF2dGgxYWE0OFhOZnI0aGRtWkZRSlJ6RWdwbmZISDV6QTk1Y0tMRkFEU2pH?=
 =?utf-8?B?NlF1YU9kTTNIZExqL1Jabi9EOUhzc1JTKytpbFkyWmM4Z3lINUlWbWpySUxt?=
 =?utf-8?B?aytldlY1WXFjZFVEUTUzRjhuQTRYdFRxV1NqWjl6TUwrVVUwTmIwSDNlOXFK?=
 =?utf-8?B?cTR6N0xTM1pXK1FwbGVSQzZGTUJmdUZ6T1N5cDhid3NybE5qb0c5Um1ZNEN0?=
 =?utf-8?B?V08wbnIza0Jsb2FPNzY0NWJoMnhRTjhoTS8wRStBYlgzcnBld2lDTWRsS2po?=
 =?utf-8?B?MUkrTkxLdFIvM1FPcGVPTFV3TDVlQjVHRi9tMER3TVZzVGVHMWpEZEY0dXo2?=
 =?utf-8?B?cjVZcnB3WFBickNZMXFjMlFqRkdXcWdVdlpZWWtvbGZvdlY2R2JDZFdrTzJJ?=
 =?utf-8?B?OENXdGVsak5sWWpZak9vK1NNMGVHSE1VUGF3VkRwZGZqc1FEREQ1SnVzU05B?=
 =?utf-8?B?UnI0Q1l6YWw4KzMzcjBJWXFGMjhrWjdrbGxXL2VkZUx4TnNPZVZML2Q1Qk9Z?=
 =?utf-8?B?WVpKOGR4YzlxQnJxNHRydkthZU4xYUtMTFc2YktrcUJNWUdBV3VxbCtZMUl6?=
 =?utf-8?B?bWhyYkttM0xhYVgwNGhMMTA4T0ZLdzh1LzNFc1RmcGVycGptMGZ2Wlkrd1pY?=
 =?utf-8?B?Wkd0UytZYmV4bDNCdVBjT0JEMnh6ZEFGY2dJbjZUSk14ajhwTXcxOElKc1Jl?=
 =?utf-8?B?VnJTNW5vVUZsTkpxeldQeGVGTWRJbHR0MFBZaDZOOW03RFZHcVgvczF0Qk1N?=
 =?utf-8?B?WFFzL2VVNUhRUmc0OXdLOHV2SkFlSnpsRHBLTXQ1S0d6d0MrSXkwMFhuUWps?=
 =?utf-8?B?Z0o5UytqZFVkTW5NYmthNnNIeFdzWmlhQ3lSRHg0MEdudkFiSzNuUFJtdFRO?=
 =?utf-8?B?YmtxblQyMEVlVkR0aWs1OHZucW5XeDZhZkRRc0x6MDN4UHNweUxuanNxTzRM?=
 =?utf-8?B?d1NVWWJOa0p2OEZZYjBlMnE4VjdmWWFpKzk1YzNEak9WRGhzcmtvTE5TdTYx?=
 =?utf-8?B?UVR4OEJFMXRVSmxGa3pZaEFrSmtwZnFScHJQUk1jMlJWN01LOGxzMFBDQS8w?=
 =?utf-8?B?a2Uxc0xvVC9nNXdNajRDUUFSbHdUTlFPOGRZdXBUNXNuM0VxcmZpTEdxZzJs?=
 =?utf-8?B?YWxnQnY0Z28yMXZLUVZyamhLNURrdmU3Z3IwSHFPQ0FVL0sxb3FlVmR5bFdw?=
 =?utf-8?B?MWFEbEh2OVg4QnZ2NkJWYnRJcTlpS1BYS2FtKzV4UXlqMm9aL0xNNzFEOXJS?=
 =?utf-8?B?UVczWk8zQSttcStpaWkxa043d0E2cU5ibGcxRXFhcVhXY2RIR2NwM0FoOVh5?=
 =?utf-8?B?WmgwZVZGZXBNOUZMbVhlN0NZanBtNzFKN2dEN3NlYnFhNDRZcDhDOUFpdHdx?=
 =?utf-8?B?dmhlN0xjUS91U1ZVL3dMUG1jL1dLTFlIZjUvV1dxZS9hV1d2S2loU3owaXJy?=
 =?utf-8?B?aXJNSXZlTVdGNSttS0h5YXZ6VS8rTWpoWUxMN1NtTVpYa05jSHg1bGdYWUR0?=
 =?utf-8?Q?Kzks5PFVnxSft5w0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23676908-e223-47ed-1ecd-08da18e79343
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 22:40:11.7582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HRSqEqMC/Ute6F/xiRxxwQxPT/4gotA+IAr71jw4hv/9XTzEYxrdhopCC2ZuCgoEwgRxJR+iW7rWf54VEyExlRlaXTWlLPlOHRdwXsv4yd0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2138
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-07_01:2022-04-07,2022-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070064
X-Proofpoint-ORIG-GUID: _832h73gH4nZFzpL0AJKVDUbBoszNx4M
X-Proofpoint-GUID: _832h73gH4nZFzpL0AJKVDUbBoszNx4M
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2022-04-07 at 15:49 +1000, Dave Chinner wrote:
> On Wed, Apr 06, 2022 at 08:11:06PM -0700, Darrick J. Wong wrote:
> > On Tue, Apr 05, 2022 at 12:03:12PM +1000, Dave Chinner wrote:
> > > Hi folks,
> > > 
> > > I'd really like to try getting the merge bottlenecks we've had
> > > recently unstuck, so there are a few patchsets I want to try to
> > > get
> > > reviewed, tested and merged for 5.19. Hopefully not too many
> > > surprises will get in the way and so some planning to try to
> > > minimises surprised might be a good thing.  Hence I want to have
> > > a
> > > rough plan for the work I'd like to acheive during this 5.19
> > > cycle,
> > > and so that everyone has an idea of what needs to be done to
> > > (maybe)
> > > achieve those goals over the next few weeks.
> > > 
> > > First of all, a rough timeline that I'm working with:
> > > 
> > > 5.18-rc1:	where we are now
> > > 5.18-rc2:	Update linux-xfs master branch to 5.19-rc2
> > 
> > Presumably you meant 5.18-rc2 here?
> > 
> > > 5.18-rc4:	At least 2 of the major pending works merged
> > > 5.18-rc6:	Last point for new work to be merged
> > > 5.18-rc6+:	Bug fixes only will be merged 
> > > 
> > > I'm assuming a -rc7 kernel will be released, hence this rough
> > > timeline gives us 2 weeks of testing/stabilisation time before
> > > 5.19
> > > merge window opens. 
> > > 
> > > Patchsets for review should be based on either 5.17.0 or the
> > > linux-xfs master branch once it has been updated to 5.19-rc2. If
> > 
> > ...and here?
> 
> Yes, I meant 5.18-rc2.
> 
> > > - Logged attributes V28 (Allison)
> > > 	- I haven't looked at this since V24, so I'm not sure what
> > > 	  the current status is. I will do that discovery later in
> > > 	  the week.
> > > 	- Merge criteria and status:
> > > 		- review complete: Not sure
So far each patch in v29 has at least 2 rvbs I think

> > > 		- no regressions when not enabled: v24 was OK
> > > 		- no major regressions when enabled: v24 had issues
> > > 	- Open questions:
> > > 		- not sure what review will uncover
> > > 		- don't know what problems testing will show
> > > 		- what other log fixes does it depend on?
If it goes on top of whiteouts, it will need some modifications to
follow the new log item changes that the whiteout set makes.

Alternately, if the white out set goes in after the larp set, then it
will need to apply the new log item changes to xfs_attr_item.c as well

Looking forward, once we get the kernel patches worked out, we should
probably port the corresponding patches to xfsprogs before enabling the
feature.  I have a patch to print the new log item in a dump.  It's not
very complicated though, I don't think it will take too many reviews to
get through though.

> > > 		- is there a performance impact when not enabled?
It shouldn't.  When the feature is not enabled, it should not create
any intents.

> > 
> > Hm.  Last time I went through this I was mostly satisfied except
> > for (a)
> > all of the subtle rules about who owns and frees the attr
> > name/value
> > buffers, and (b) all that stuff with the alignment/sizing asserts
> > tripping on fsstress loop tests.
> > 
> > I /think/ Allison's fixed (a), and I think Dave had a patch or two
> > for
> > (b)?
> 
> Yup, I think the patches in the intent whiteout series fix the
> issues with the log iovecs that came up.
> 
> > Oh one more thing:
> > 
> > ISTR one of the problems is that the VFS allocates an onstack
> > buffer for the xattr name.  The buffer is char[], so the start of
> > it
> > isn't necessarily aligned to what the logging code wants; and the
> > end of
> > it (since it's 255 bytes long) almost assuredly isn't.
> 
> Not sure that is a problem - we're copying them into log iovecs in
> the shadow buffer - the iovecs in the shadow buffer have alignment
> constraints because xlog_write() needing 4 byte alignment of ophdrs,
> but the source buffer they get memcpy()d from has no alignment
> restrictions.
> 
> I still need check that the code hasn't changed since v24 when I
> looked at this in detail, but I think the VFS buffer is fine.
> 
> > > - DAX + reflink V11 (Ruan)
> > > 	- Merge criteria and status:
> > > 		- review complete: 75%
> > > 		- no regressions when not enabled: unknown
> > > 		- no major regressions when enabled: unknown
> > > 	- Open questions:
> > > 		- still a little bit of change around change
> > > 		  notification?
> > > 		- Not sure when V12 will arrive, hence can't really
> > > 		  plan for this right now.
> > > 		- external dependencies?
> > 
> > I thought the XFS part of this patchset looked like it was in good
> > enough shape to merge, but the actual infrastructure stuff (AKA
> > messing
> > with mm/ and dax code) hasn't gotten a review.  I don't really have
> > the
> > depth to know if the changes proposed are good or bad.
> 
> Most of the patches have RVBs when I checked a couple of days ago.
> There's a couple that still need work. I'm mostly relying on Dan and
> Christoph to finish the reviews of this, hopefully it won't take
> more than one more round...
> 
> > > - xlog_write() rework V8
> > > 	- Merge criteria and status:
> > > 		- review complete: 100%
> > > 		- No regressions in testing: 100%
> > > 	- Open questions:
> > > 		- unchanged since last review/merge attempt,
> > > 		  reverted because of problems with other code that
> > > 		  was merged with it that isn't in this patchset
> > > 		  now. Does it need re-reviewing?
> > 
> > I suggest you rebase to something recent (5.17.0 + xfs-5.18-merge-
> > 4?)
> > and send it to the list for a quick once-over before merging that.
> > IIRC I understood it well enough to have been ok with putting it
> > in.
> 
> When I last posted it (March 9) it was rebased against 5.17-rc4:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git/log/?h=xlog-write-rework-3
> https://lore.kernel.org/linux-xfs/20220309052937.2696447-1-david@fromorbit.com/
> 
> And it I think there's only been a line or two change for rebasing
> to the current for-next branch. 
> 
> I have a current base on 5.17+for-next, so if you need a newer
> version to check over I can send that out easily enough...
> 
> > > 	- Ready to merge.
> > > 
> > > - Intent Whiteouts V3
> > > 	- Merge criteria and status:
> > > 		- review complete: 0%
I think patch 2 of this set is the same as patch 2 of the larp set.  If
you agree with the review results, you can just take patch 2 from the
larp series, and have 2 rvbs for this one

xfs: don't commit the first deferred transaction
v25
https://lore.kernel.org/all/20211117041343.3050202-3-allison.henderson@oracle.com/
v26
https://lore.kernel.org/all/20220124052708.580016-3-allison.henderson@oracle.com/
v27
https://lore.kernel.org/all/20220216013713.1191082-3-allison.henderson@oracle.com/
v28
https://lore.kernel.org/all/20220228195147.1913281-3-allison.henderson@oracle.com/

I'll see if I can stack the two sets together and get some reviews done
on the remainder of the set

> > > 		- No regressions in testing: 100%
> > > 	- Open questions:
> > > 		- will it get reviewed in time?
> > > 		- what bits of the patchset does LARP depend on?
Just from glancing at the sets, I don't think they have merge conflicts
other than patch 2, which can simply be dropped from one of the sets.

However, patches 3,4,6,7 of the whiteout set make a series of changes
to the xfs_*_item.c files.  So similar changes need to be applied to
the new fs/xfs/xfs_attr_item.c that the larp set introduces 
 
> > > 		- Is LARP perf without intent whiteouts acceptible
> > > 		  (Experimental tag tends to suggest yes).
I'll see if I can get a few perf captures on it too

Allison
> > > 	- Functionally complete and tested, just needs review.
> > 
> > <shrug> No opinions, having never seen this before(?)
> 
> First RFC was 7 months ago:
> 
> https://lore.kernel.org/linux-xfs/20210902095927.911100-1-david@fromorbit.com/
> 
> I mentioned it here in the 5.16 cycle planning discussion:
> 
> https://lore.kernel.org/linux-xfs/20210922053047.GS1756565@dread.disaster.area/
> 
> I posted v3 on 5.17-rc4 and xlog-write-rewrite back on about 3
> weeks ago now:
> 
> https://lore.kernel.org/linux-xfs/20220314220631.3093283-1-david@fromorbit.com/
> 
> and like the xlog-write rework it is largely unchanged by a rebase
> to 5.17.0+for-next.
> 
> > > Have I missed any of the major outstanding things that are nearly
> > > ready to go?
> > 
> > At this point my rmap/reflink performance speedups series are ready
> > for
> > review,
> 
> OK, what's the timeframe for you getting them out for review? Today,
> next week, -rc4?
> 
> > but I think the xlog and nrext64 are more than enough for a
> > single cycle.
> 
> Except we've already done most of the work needed to merge them and
> we aren't even at -rc2. That leaves another 4 weeks of time to
> review, test and merge other work before we hit the -rc6 cutoff.
> The plan I've outlined is based on what I think *I* can acheive in
> the cycle, but I have no doubt that some of it will not get done
> because that's the way these things always go. SO I've aimed high,
> knowing that we're more likely to hit the middle of the target
> range...
> 
> That said, if the code is reviewed, ready to merge and passes initial
> regression tests, then I'll merge it regardless of how much else
> I've already got queued up.
> 
> > > Do the patchset authors have the time available in the next 2-3
> > > weeks to make enough progress to get their work merged? I'd kinda
> > > like to have the xlog_write() rework and the large extent counts
> > > merged ASAP so we have plenty of time to focus on the more
> > > complex/difficult pieces.  If you don't have time in the next few
> > > weeks, then let me know so I can adjust the plan appropriately
> > > for
> > > the cycle.
> > > 
> > > What does everyone think of the plan?
> > 
> > I like that you're making the plan explicit.  I'd wanted to talk
> > about
> > doing this back at LPC 2021, but nobody from RH registered... :(
> 
> Lead by example - you need to don't ask for permission or build
> consensus for doing something you think needs to be done. We don't
> need to discuss whether we should have a planning discussion, just
> publish the plan and that will naturally lead to a discussion of
> the plan.
> 
> Speaking as the "merge shepherd" for this release, what I want from
> this discussion is feedback that points out things I've missed, for
> the authors of patchsets that I've flagged as merge candidates to
> tell me if they are able to do the work needed in the next 4-6 weeks
> to get their work merged, for people to voice their concerns about
> aspects of the plan, etc.
> 
> Cheers,
> 
> Dave.
> 

