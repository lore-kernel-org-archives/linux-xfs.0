Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B7E3C43334
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jul 2022 21:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236530AbiGGVzY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 17:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236180AbiGGVzX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jul 2022 17:55:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D932E9D0;
        Thu,  7 Jul 2022 14:55:21 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267KCFll013683;
        Thu, 7 Jul 2022 21:55:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=6OJ1Zx2pq+7nzr+tuqejP1B+OFVrq/JtaBkyVHlZClY=;
 b=NQTSUsAZDQsr39P9zek7z1dpJqyOG/c0REDTe9/v/6qNCpHI3R24lOzikp3vAFGMGWdW
 MQmbKKCCMmEVo2tbT/AC8Aw+mAjNB+b+eEpIKbx1lb6QoizGHrT5Ixfxo+C1UJCBxkT6
 d/blmKjqu1zbzFVWXRxU+Wy1T7XL9ZGfrLhoZrmndYMLPzF1uG68Ig0GhR41S6DMb5MF
 40sQ98sadRjvurpWf1CzlIN/jUY0AfCibvkB87w6E4DSFExjjRPu2SqNmwqYE0yS1/tr
 lvavXG/RihAZuiKVDZvTxRlh30ci9AvT/5D3QNwfjzTUfN2bOcNywgTbB+j/wAWRxIOo XQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4ubyej6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 21:55:13 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 267LjKps015306;
        Thu, 7 Jul 2022 21:55:12 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3h4ud675j3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 21:55:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S4TtYZ/O4yLKaoAx4UpAmB36UzsOpmrRHprYqBEPEpX4ldYHcz/H7kAvBc2oq28QAeE7XRSkmQVkLqPRjtyypLMSOnvmd87u7N4dxCd8xsRqRJcqhVV9or5tE2Pux5aiJJEU1tkAB/qXV1dXTUxuUbI98l73V2/Aq0RugFc44GRbmmBUw5EAN7OkJHTpb2ba8U7SM/QqNOHA8FJj1AEZUiy6mCj4naasu4e7/P38qlXpnk+PZ1rY3iZe5NJ3pY1XeFKRuJbeiBP180o3Nbd2qKQDVatFAhNTceTeYCsUBUR2u55tGylZvCV9w7EZkiI53c0duN/HwVGcPANvsZs6OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6OJ1Zx2pq+7nzr+tuqejP1B+OFVrq/JtaBkyVHlZClY=;
 b=Cb8TB9X5isYV/4LqU9guoLBrMXRidoTXTnmED6q3kdMnakVxToosFOXKUr8CFWFkmL3VOp9gP3pFRkIsLxQf2S99QxaxY9gKBAK8h+3Co1u6fTwT42YD0XdyOEWvZTjLf+p9m8QYbdJpyOA4FhdgaDyJw0Mov5VlCs1X97nCVs/NW6IIxc1fH/5AYiwE6kM6uGy/2jDtMYxRmVXg5PVTbLMd9qgn9VPNHBSfnMKlSWWADIZOVswK3nRPMkV91SFFrTL8uCo6RheHqdcZ8PiCUaGCCnm3DuUFBDhsZ73SMAydT5vxYegW42RunRwiISFKrgpoSzm2U5kvsFJ0bmtE1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6OJ1Zx2pq+7nzr+tuqejP1B+OFVrq/JtaBkyVHlZClY=;
 b=uyOFLpZEnFlp9oC7/CdzLIa0Xo1++221o0Rd+QvH37AhvkvrEfWJ35J14DBx0R0aWbibeSHktGPaIMexpCFimdqIpqqkQbZKSvp7BZh26srVAffZ9SiX+JTaPz9uR/INWhw2+OtpJp2swruSzUEUjAmdhZ5u357CmnVmfXU7GxE=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CH0PR10MB5290.namprd10.prod.outlook.com (2603:10b6:610:dc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Thu, 7 Jul
 2022 21:55:10 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5417.019; Thu, 7 Jul 2022
 21:55:10 +0000
Message-ID: <89d1e21b688d880b200f9dd32891023b55726735.camel@oracle.com>
Subject: Re: [PATCH 2/3] xfs/018: fix LARP testing for small block sizes
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com,
        zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        Catherine Hoang <catherine.hoang@oracle.com>
Date:   Thu, 07 Jul 2022 14:55:07 -0700
In-Reply-To: <YscglleRpAIkrHiA@magnolia>
References: <165705852280.2820493.17559217951744359102.stgit@magnolia>
         <165705853409.2820493.9590517059305128125.stgit@magnolia>
         <YscglleRpAIkrHiA@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0196.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f4c4c67-b51b-431d-102f-08da60635c84
X-MS-TrafficTypeDiagnostic: CH0PR10MB5290:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q4DN6Ib484UHrfZ7zhMYIHNglcLj4yW7v+KRk3zwke6vpfiVmtS5e6LWtDZiXz1oT8L9b7DOPWAsr0G3+WqlQS1axiDDXbCFQiA1r8pM0ow5faf+7OxGn2SGMhM5kT9RaUrpxA8P6FCAgXXvm8BxCcD1dFTlrzQ5kIvX2V+WiZPRMibOBV8J2QGNsl2JqAd8gE6ubsUpgqbgJcWBOJNdAvN0ELjBKA0jP4o736I3KywMtv1LCrSalWBOZzcB8G0TSwk7P52j/umnKzgPxIfrP1+gVRBDzhD4+nEXuOvAtKWpH0Zndx+p1atqZEcWJzzlvr0+x6mgQxDWKRghYYaJvV7I/DGsZO6I2+q/f7AU4jFXkAWyRlWSnMN/mp8TsHiORz20uTcaU+Bq+3bcqRtNyrJ4HXj68nFkY9IFNxEKJ9ugsf52QhTZ939bPqMy8dNvrM7Sa50zQk+UNCOxEMpa90wtHHrgUZbAyqJqW6c2pd6IsRRIInbWMJRdiF6C51tahZ7ybbkK82ikfBMu2yd6D1MuXaWU0tVuNz476ubgOSGOaDlnapg2Nggmbxb0rd+ctwEfkIXwd3wlncNDLTJcGb6Yq+Glw2h4Vyf3REoMS7freuMXMM1don1Jl0Zk8ykDzRaAAMlenyUlwnpSlA1FJY4AMdtAmw2hpu9Iuw4qVZqABgO2qRkIf0YPY3uA9+AbcdoOpIBKcDJ0qYcFT7e7F/BGW70ZcJUboDAtYAYqpEO1wz2+JyKxIZtbaqTogJIiR8ak1whgi3T7LDYMt+A80JUJUfbBt6X504gj4+VdiuYNShcHbaG0EAy13Nz0+EGqOdb3/DWs2/Oe+D3gCg//TA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(346002)(376002)(136003)(39860400002)(186003)(38350700002)(107886003)(26005)(38100700002)(83380400001)(6666004)(41300700001)(66946007)(8936002)(478600001)(86362001)(8676002)(316002)(2906002)(66476007)(6486002)(6512007)(4326008)(66556008)(6506007)(36756003)(5660300002)(52116002)(2616005)(357404004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MHdpN1BwZUlVUmNlQ3J3RFlRcEUvK3ZHTUhxa0NoczlvZEFJbUk0SHJvQXdB?=
 =?utf-8?B?S3ZnemR0K2hDb3FML0Fxa3hoMDlMbENpTU5ickY4MmpCaGRjOG1RbXIyeVdz?=
 =?utf-8?B?S2VLbmwvTjA5SzYrNkhjRi9CaElWY1ZiQ3crUTdrakl4d0pLTmZCOUxNdkhV?=
 =?utf-8?B?SmZQU3ZYN3Yyajh1YTdMblZWN2tHUTh5UXVHMGh5bW1vZGZGWlFxZ3ZxcUph?=
 =?utf-8?B?RGFRT0FURk5ROWVKa01xdDF4QmllV1dCT2ZJMm1pTTRwRlJUenRuWFJBaG9I?=
 =?utf-8?B?aVNwWmx3QS9ZcmNLQkVmTm9NV3VLZ3RWMGZiSEV5UXVKbUR2NC9iMkxQS1BT?=
 =?utf-8?B?bEhqK1RiMVFmTHJtem9vNWZhSDN4aDMzZ3ZlcGtZdW5Rb3lYOUhHVGd5SERz?=
 =?utf-8?B?bG54UU5tR2xYR3NZSEd1YzZyL1RYYmRxdnhRWWtheTdPRGVGLzI4M1VoNFJt?=
 =?utf-8?B?UGorYlBWK0d0U2h4UXBpNTBqL2R3SFFSaFZwWC9JMDc4bDBrNG84NFM0UUFu?=
 =?utf-8?B?VVp1SXFJOWxEbVM2VTA0RkUvLzlURFZKZlBQOWhRQWdWbkNMV0Z2QngxSVRk?=
 =?utf-8?B?T1IralF3S1hmdTk1Sm1yMDUrSTlESm5peGt3eVVUdEZJZGNhWC9BZjByZEpT?=
 =?utf-8?B?YVlVRjNqNE4zQm9xUTMrWktCWVYyQmhFQjJLWUNpTVFWcGdOL2lVNFk1K0V3?=
 =?utf-8?B?QkU1SlQvanZYL05UQm5CWmFIbEJLOWhseXdDSElPWDYyKy8yc2J3STZpQ1lQ?=
 =?utf-8?B?ME1tb2JzSnRtZTdpNmJHaTF0UEdUK0gxdGtHdlpBaGJFTEVIbGdIc0lHaTV0?=
 =?utf-8?B?WnZuSHQ0c1B4cHZoMEJNczBMdmVhYk91c0JmT3hDMW1yZ1lOUTA0OGdkMXo4?=
 =?utf-8?B?OWV1YW9id1dQZ1E0SHlLa3RJTmJoRHhMMHVaNU1BVkpIR0JTbFlYclErc2xK?=
 =?utf-8?B?ZHdOWi9VY1hQSmZ6NFdIVEV1RVBXZkdXRzNWYWxPZTRYWjhMNUcxWkJiTHJW?=
 =?utf-8?B?TXMvM3NQRThndGNtUXpJV3dldUVKZkhPd3A3SFpRZ1MrZ09kcFZ1ZTRxaGVh?=
 =?utf-8?B?aU1lQ2orZGxyQjFMdnJTWWR0VzBMcXJVbFQvVENOQ25sQVBaV0JoaG44andt?=
 =?utf-8?B?bGdsSlZWam8zYnNBc0RvRk5iUmRSWmFZWm1NWndzVHlYUTZBRzZ3bHhDd2kv?=
 =?utf-8?B?VFVXTWxoZEhTSWI4MzNGZlY0OTVwazVJTVVxdHBjL1BKeVVWYStEMG9jVXA0?=
 =?utf-8?B?OTBmTllzNVZZeDZNMUNXMHphZUhNN1hHSFFqSmxFMkh4azJzYWRVOVV3Z20w?=
 =?utf-8?B?M2ZtbW8razlidmUrdlVIazhaZEk4bkhkUEdXWWd1ZWh0UmFTekVNeVIxdkNh?=
 =?utf-8?B?bWJtbmk2ejJlOG1NKzNrNFR2Zzgvbk1NQWdZaEM3TURTOTNYYTBZS3pZOC96?=
 =?utf-8?B?V1BWcmxGUW9uUE1NS21CVi81M2l2OXIvaW4zY1V5RW14ZC9tUVRtYjdKVCs1?=
 =?utf-8?B?QnovNFI1b3JzNjZuQ1FNWTZkS3FJeEJqUHJMT1BJSE9zK0xtbTNCME9YOVMw?=
 =?utf-8?B?MlQ5SG55ZDdmRUhGRk1hSFJiRnRMMGt4eENPNXdFbUFYVDROQ3ZQTCtBaE5F?=
 =?utf-8?B?OHJiZDNXSWY2bDFoRFlHdlpPUHcwWnZCRDl4dnZQeHR4Tk4rQy9tdy80Vi9J?=
 =?utf-8?B?Ti9TTU4wMzZZVGcwejM4Uzg3L3dlRXVRSHR2V2pPNVhXS3BhVG1PbzF1VFYx?=
 =?utf-8?B?Y2VLT1NTK2UrYmhPZHAvTDNNWmp0R3RjbVk0dG8xTWJQZERGc3RMeGNHcENh?=
 =?utf-8?B?MFNlY1RCSU1kM1NJMHh3eXVnTjlBbGV3WHNNL21YK1NSZEdqajk3Y1d5ZnNn?=
 =?utf-8?B?OEFtUzJnT1hZaEJxc0t5eWFsRm9xKzcyWEozNTZhRkUyZzhXbklpdWtDd1Rz?=
 =?utf-8?B?UVlvS01YYk4ySC9sQlRhZWxDWW8zZUh4UlhMbzZEVmhibGlVQVJrQ2VwSHM5?=
 =?utf-8?B?UlFPMkkzblQ1WjExczVtUkhMdnJvUmRtVlp0V1dEZ0h1aDlFbnZDelZqN3lM?=
 =?utf-8?B?ZEhkZXIyZG50SW93N3pmVGNPamp4Z0w2dHdVbzlET2VmZUZpL0xZYmI4V1c4?=
 =?utf-8?B?Zm9KY1JIcHlwOW1QcXlVMzdvQ0ZlVXVGNWkrL01NNWpWemJaSE9oYnYrQWQw?=
 =?utf-8?B?dWc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f4c4c67-b51b-431d-102f-08da60635c84
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 21:55:10.0283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jy1tbTtyKNQgPevZrkGIO9fKaJuW9WxbCnZiFvuOTjRhwSLJcUMSoFWOHO943BkjS3IzGBEImB3F9G130JqowqJAB8CviPVvhA+SdfSHstg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5290
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-07_17:2022-06-28,2022-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207070086
X-Proofpoint-ORIG-GUID: UIjecP8d5kzRmzvBRbMUznndHwzCq_9U
X-Proofpoint-GUID: UIjecP8d5kzRmzvBRbMUznndHwzCq_9U
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2022-07-07 at 11:06 -0700, Darrick J. Wong wrote:
> I guess I should've cc'd Allison and Catherine on this one.
> 
> Could either of you review these test changes, please?
> 
> --D
> 
> On Tue, Jul 05, 2022 at 03:02:14PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Fix this test to work properly when the filesystem block size is
> > less
> > than 4k.  Tripping the error injection points on shape changes in
> > the
> > xattr structure must be done dynamically.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/018     |   52
> > +++++++++++++++++++++++++++++++++++++++++++++++-----
> >  tests/xfs/018.out |   16 ++++------------
> >  2 files changed, 51 insertions(+), 17 deletions(-)
> > 
> > 
> > diff --git a/tests/xfs/018 b/tests/xfs/018
> > index 041a3b24..14a6f716 100755
> > --- a/tests/xfs/018
> > +++ b/tests/xfs/018
> > @@ -54,6 +54,45 @@ test_attr_replay()
> >  	echo ""
> >  }
> >  
> > +test_attr_replay_loop()
> > +{
> > +	testfile=$testdir/$1
> > +	attr_name=$2
> > +	attr_value=$3
> > +	flag=$4
> > +	error_tag=$5
> > +
> > +	# Inject error
> > +	_scratch_inject_error $error_tag
> > +
> > +	# Set attribute; hopefully 1000 of them is enough to cause
> > whatever
> > +	# attr structure shape change that the caller wants to test.
> > +	for ((i = 0; i < 1024; i++)); do
> > +		echo "$attr_value" | \
> > +			${ATTR_PROG} -$flag "$attr_name$i" $testfile >
> > $tmp.out 2> $tmp.err
> > +		cat $tmp.out $tmp.err >> $seqres.full
> > +		cat $tmp.err | _filter_scratch | sed -e 's/attr_name[0-
> > 9]*/attr_nameXXXX/g'
> > +		touch $testfile &>/dev/null || break
> > +	done
> > +
> > +	# FS should be shut down, touch will fail
> > +	touch $testfile 2>&1 | _filter_scratch
> > +
> > +	# Remount to replay log
> > +	_scratch_remount_dump_log >> $seqres.full
> > +
> > +	# FS should be online, touch should succeed
> > +	touch $testfile
> > +
> > +	# Verify attr recovery
> > +	$ATTR_PROG -l $testfile >> $seqres.full
> > +	echo "Checking contents of $attr_name$i" >> $seqres.full
> > +	echo -n "${attr_name}XXXX: "
> > +	$ATTR_PROG -q -g $attr_name$i $testfile 2> /dev/null | md5sum;
> > +
> > +	echo ""
> > +}
> > +


Ok, I think I see what you are trying to do, but I think we can do it
with less duplicated code and looping functions.  What about something
like this:

diff --git a/tests/xfs/018 b/tests/xfs/018
index 041a3b24..dc1324b1 100755
--- a/tests/xfs/018
+++ b/tests/xfs/018
@@ -95,6 +95,9 @@ attr16k="$attr8k$attr8k"
 attr32k="$attr16k$attr16k"
 attr64k="$attr32k$attr32k"
 
+blk_sz=$(_scratch_xfs_get_sb_field blocksize)
+multiplier=$(( $blk_sz / 256 ))
+
 echo "*** mkfs"
 _scratch_mkfs >/dev/null
 
@@ -140,7 +143,7 @@ test_attr_replay extent_file1 "attr_name2" $attr1k
"s" "larp"
 test_attr_replay extent_file1 "attr_name2" $attr1k "r" "larp"
 
 # extent, inject error on split
-create_test_file extent_file2 3 $attr1k
+create_test_file extent_file2 $(( $multiplier - 1 )) $attr256
 test_attr_replay extent_file2 "attr_name4" $attr1k "s" "da_leaf_split"
 
 # extent, inject error on fork transition



Same idea right?  We bring the attr fork right up and to the edge of
the block boundary and then pop it?  And then of course we apply the
same pattern to the rest of the tests.  I think that sort of reads
cleaner too.

Allison

> >  create_test_file()
> >  {
> >  	filename=$testdir/$1
> > @@ -88,6 +127,7 @@ echo 1 > /sys/fs/xfs/debug/larp
> >  attr16="0123456789ABCDEF"
> >  attr64="$attr16$attr16$attr16$attr16"
> >  attr256="$attr64$attr64$attr64$attr64"
> > +attr512="$attr256$attr256"
> >  attr1k="$attr256$attr256$attr256$attr256"
> >  attr4k="$attr1k$attr1k$attr1k$attr1k"
> >  attr8k="$attr4k$attr4k"
> > @@ -140,12 +180,14 @@ test_attr_replay extent_file1 "attr_name2"
> > $attr1k "s" "larp"
> >  test_attr_replay extent_file1 "attr_name2" $attr1k "r" "larp"
> >  
> >  # extent, inject error on split
> > -create_test_file extent_file2 3 $attr1k
> > -test_attr_replay extent_file2 "attr_name4" $attr1k "s"
> > "da_leaf_split"
> > +create_test_file extent_file2 0 $attr1k
> > +test_attr_replay_loop extent_file2 "attr_name" $attr1k "s"
> > "da_leaf_split"
> >  
> > -# extent, inject error on fork transition
> > -create_test_file extent_file3 3 $attr1k
> > -test_attr_replay extent_file3 "attr_name4" $attr1k "s"
> > "attr_leaf_to_node"
> > +# extent, inject error on fork transition.  The attr value must be
> > less than
> > +# a full filesystem block so that the attrs don't use remote xattr
> > values,
> > +# which means we miss the leaf to node transition.
> > +create_test_file extent_file3 0 $attr1k
> > +test_attr_replay_loop extent_file3 "attr_name" $attr512 "s"
> > "attr_leaf_to_node"
> >  
> >  # extent, remote
> >  create_test_file extent_file4 1 $attr1k
> > diff --git a/tests/xfs/018.out b/tests/xfs/018.out
> > index 022b0ca3..c3021ee3 100644
> > --- a/tests/xfs/018.out
> > +++ b/tests/xfs/018.out
> > @@ -87,22 +87,14 @@ Attribute "attr_name1" has a 1024 byte value
> > for SCRATCH_MNT/testdir/extent_file
> >  attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
> >  
> >  attr_set: Input/output error
> > -Could not set "attr_name4" for SCRATCH_MNT/testdir/extent_file2
> > +Could not set "attr_nameXXXX" for SCRATCH_MNT/testdir/extent_file2
> >  touch: cannot touch 'SCRATCH_MNT/testdir/extent_file2':
> > Input/output error
> > -Attribute "attr_name4" has a 1025 byte value for
> > SCRATCH_MNT/testdir/extent_file2
> > -Attribute "attr_name2" has a 1024 byte value for
> > SCRATCH_MNT/testdir/extent_file2
> > -Attribute "attr_name3" has a 1024 byte value for
> > SCRATCH_MNT/testdir/extent_file2
> > -Attribute "attr_name1" has a 1024 byte value for
> > SCRATCH_MNT/testdir/extent_file2
> > -attr_name4: 9fd415c49d67afc4b78fad4055a3a376  -
> > +attr_nameXXXX: 9fd415c49d67afc4b78fad4055a3a376  -
> >  
> >  attr_set: Input/output error
> > -Could not set "attr_name4" for SCRATCH_MNT/testdir/extent_file3
> > +Could not set "attr_nameXXXX" for SCRATCH_MNT/testdir/extent_file3
> >  touch: cannot touch 'SCRATCH_MNT/testdir/extent_file3':
> > Input/output error
> > -Attribute "attr_name4" has a 1025 byte value for
> > SCRATCH_MNT/testdir/extent_file3
> > -Attribute "attr_name2" has a 1024 byte value for
> > SCRATCH_MNT/testdir/extent_file3
> > -Attribute "attr_name3" has a 1024 byte value for
> > SCRATCH_MNT/testdir/extent_file3
> > -Attribute "attr_name1" has a 1024 byte value for
> > SCRATCH_MNT/testdir/extent_file3
> > -attr_name4: 9fd415c49d67afc4b78fad4055a3a376  -
> > +attr_nameXXXX: a597dc41e4574873516420a7e4e5a3e0  -
> >  
> >  attr_set: Input/output error
> >  Could not set "attr_name2" for SCRATCH_MNT/testdir/extent_file4
> > 

