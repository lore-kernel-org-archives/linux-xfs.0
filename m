Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63EC4C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 20:01:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243241AbiDKUDS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 16:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349757AbiDKUDR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 16:03:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5963B1B791
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 13:01:02 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23BHV0OG018804;
        Mon, 11 Apr 2022 20:00:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=BLhPUip/DLHw/1cRqLFMRagkYozxFTaRcC+gyiViQy4=;
 b=HMZCcrxa3mgk7XAQdB00OCnzZesMSMdCp51o4Qfz+i2aE64qGMerqWqxpjQ4DdY3uw2y
 3u07bNE4rBhCP3g2XIHPBPkwsniBSZ4D7ElE23MDrGgw6nLnxhaM4n4iC5CT5mQu7tDT
 sMoB5FvgjOA6xsjykEOpV+aJtRoGUINwFquEszQ9eplD2aLRSoIY1010V2mJoMfzEECR
 4Q1Yuete1yrNZ37LrorN1JQ4jQuQa7JB/idox8JDQl7lNCxHDtXoh8XHodfYOw8dOL6/
 OHoCzOJo5a/5n92FTdExXO91BRtwlWFm3wq7BbL76/ewcDALZgiANZIH3NniM+LSfqHE +Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0r1cvjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 20:00:57 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23BJuOuZ013105;
        Mon, 11 Apr 2022 20:00:56 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fck11y6kh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 20:00:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OLku3KCXChi85umQn0NVCwZCvh7DD/1P9UzyfylK8VXjS890sfKchH7PTgv09RmYWWMsf8T7RBAk/OEWeJ3gzDNlUw/iqmABT7jv3u0i4jwrBAHQrYYsx+dq8InXEUj81TCUCNBzlsLErlPcD5HKC0JWX4Udrx6RLeTahfXByEcoLSM+4siY0lt5sg9AOvMeH5rdrUPhhd4ATzYsSlX3piY2225cdtzHs6/jTiz2sMOLp2SfWsmLHajMOXih3jg7Cq0OuSOmT7YChci+VRWZfHG1em10n08ioFXVZYrhZk1t9kQs1cUUGpon2aXPvsn6V4W6nrqH88tl6Ld6ZAySRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BLhPUip/DLHw/1cRqLFMRagkYozxFTaRcC+gyiViQy4=;
 b=GZhv46759Z09CVg8iJezLgBXh2mr8Pp9WyRtZweU0c8UihcYqfg3HwkUuVZwY4YT+TdBPVD15IeZMuB211AgkRt8YNpgS1MZbkOtB1P7CBazoAh2oHAb/1syVcjEIRHZXEFc7IPWmZaYXUmaPYrOVM/VzSztUgzmgwsIx3IJcRh21NQbz97XYJCzNOndTCnj4YNBWp+EJnKhIWXRsea5Su1ODFiwBKsfiyyoui3knVwBJcfGWYAQdX1adX/ag5toqTTM83rtWAN26Cpy7fvUdXfTW7wzUF8CVw6fR+f6Bh1UE628SCY6YcidJZHEd+kfcL17RhKez6s9yhwoHbRglg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BLhPUip/DLHw/1cRqLFMRagkYozxFTaRcC+gyiViQy4=;
 b=QEjXjmiAwdM+8Wqcj7GY0VkILCRP33h8Mhwbs5r/KEAQeXMuANBGRBMIkLTzZA43vJJLb7Pz0pPqGXvQHqQH4Uu1d8xBOyFUjajPRYWBhQAnX2FS+xP93DwUR0Ji/NXsgN+pSZoTfGEHXXZd+i33h+O+Qd7r0qLuAakiXjNYVNo=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2520.namprd10.prod.outlook.com (2603:10b6:a02:b1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 20:00:52 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::4cac:3ab1:a828:34ca]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::4cac:3ab1:a828:34ca%4]) with mapi id 15.20.5144.030; Mon, 11 Apr 2022
 20:00:52 +0000
Message-ID: <3753135344b00e1a3d5c5bcb64b3ca7d6fec4fde.camel@oracle.com>
Subject: Re: [5.19 cycle] Planning and goals
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Date:   Mon, 11 Apr 2022 13:00:51 -0700
In-Reply-To: <20220411085056.GB1544202@dread.disaster.area>
References: <20220405020312.GU1544202@dread.disaster.area>
         <20220407031106.GB27690@magnolia>
         <20220407054939.GJ1544202@dread.disaster.area>
         <ff1aa185470226b5dac3b8e914277137a88e97e6.camel@oracle.com>
         <20220411015023.GV1544202@dread.disaster.area>
         <20220411035935.GZ1544202@dread.disaster.area>
         <20220411073121.GA1544202@dread.disaster.area>
         <20220411085056.GB1544202@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::20) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d8e2561-2d8f-4a29-e9c9-08da1bf5fb7f
X-MS-TrafficTypeDiagnostic: BYAPR10MB2520:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2520F460357E4BEBD1582CE795EA9@BYAPR10MB2520.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GFE2m7YAAPvmVuNXL8mj/X3/U+iKoAZCoZo9WmWkMgI5ZmV5QKteVgZ17Xyh7nKintnsEXuhukI2fHobGFuaS+43h/iEPqyerKLJ3eyXgJx6YLy6waXumFiRy7a3GUbt2B/GRDINpamSXNkdHTSYf/GH1BmEoKPsbWevQ55iMm/TqLmaDGqJxyh5U2Sf0LteB2P8lUNFhxgau4j/NUV19vmEJEfCt0i3auioaeg64p03gzPeXTmIp7JwiKAAKJUF4INZWDfRnILGJ6oUq91GsbmWnJCKJAlVx2pBhzYLkfKUpktWyxRVjFrIsCefrUr+7rPP7gjduHeQZ6GjDnv85hfPTcelrTv/h8TuQrA/OoMiPoO5llFZL3PERQ+DJlHcugoXYN8Tp4Cy4vsCJgaOlcUgKplHrj5O6mlrFPSiZkAc3XdQUa1LTL6ANxNzptnQXgC4ms1HJq3b1KxW2HOiIIElWGlLbn+fz60Qi5W+7biiAw7ldPK2mBDPFhJRLUoDrOynLh9xGjuDlVIUe4uHFa4oKkv2Me7QOFNFPX8ogf5zRPKOpQGthcH+2JUMujMOoUDvJBTkWg9ts7iGMfUNR3u3tNScpjvLsc6b0/yYL9K7ki3/vSHRbsFU8YxWS82t0hDNUqsMXCfgiV1R3onIwaIGoiwEIu6xl07f0eFF0F86ku7MjmEVsDJYYvvncMyxb0j32vIQknLVV7z8FurJ4kiGSI05gDkK9mXIVTw2VUs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(316002)(52116002)(8936002)(186003)(66556008)(66476007)(8676002)(4326008)(6916009)(26005)(6512007)(86362001)(83380400001)(5660300002)(38100700002)(38350700002)(66946007)(2616005)(36756003)(2906002)(6486002)(508600001)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SXhiZ01HV0RwSnFVVGV4UVN6Qy9lWjR0SGhzcGc1TlI5eVFiZlNXSWphVWlq?=
 =?utf-8?B?RTA3UFNGdW1Gbi84clZwbEZPa2NsdDQwNENCVU9pNVBmZXlIUXQxVG9wYVRQ?=
 =?utf-8?B?azU2a3dQNTFHT3o2eGxSRGRQNEJsanZ6ZzN4N3U3UURQTVNLeHdJaDNXM2Q4?=
 =?utf-8?B?NXJNYzdJcDFKeHpKVVBvdFB1ekdqYjI4aTR6UHAwR3YrakFpcnVnNEhBYTRl?=
 =?utf-8?B?WWVVWnlnTkc0c1lsUmJUMVNZbHEzbHpTcVowQ3V0b243bC9LeUllY1Ixc2FB?=
 =?utf-8?B?VVlldEcvSWw0eW9yQlBmcTVteVMySjVSekdzNi9wSFM4Wm8wRHBZekRGb09O?=
 =?utf-8?B?dldoZS9zWFg3d3BrdXJ6eHQ3RnpqQlN1TEY3U2p3WUNCUG5vRWVjMFpubkRq?=
 =?utf-8?B?a1Y2U2NSVFlYd2c4N0ZrMEhFOHBqSEJmRWV4TVUxalYvcDhyTW15dTVuNGZj?=
 =?utf-8?B?RGcxaGFsRFd2MTQvaXBKMW8wOHJMRTdmNWZXMHdiTW9oM1Y0RWp4UTdaN0xH?=
 =?utf-8?B?bGRmdVNlZFNyYjJmRkxhcVVWM1FjNHJiNUVHTncrK3h0bWxxby9OSGlqRkRa?=
 =?utf-8?B?c0lNT3ZONlIrQm0vT2d5aklILzZlQmJabXB1R0o4aXlDVlEyMUhZWm8va0lI?=
 =?utf-8?B?b2h1OTY5ajZhVVl6M2h4S1lUOXZOSWZnb2U5UkJVaXh3QkdnQXZkakZOc0Z3?=
 =?utf-8?B?MldWbngzZU5MWDQxZFlGUnhvMjNKcU5KTmZoMWt3enJjcm9GTTErK2hDQTFL?=
 =?utf-8?B?NVJBdXovaVJGQUZvR3BrdGtUMmNJMjBoT3pvOGpFTEpxc1hXbXJkZmxxUGtC?=
 =?utf-8?B?SGZLb1dmOEE0S212RUZ0OTRPajF4M2NURXRWNzNYM0tQVE80UUYrTjhrWUN6?=
 =?utf-8?B?ZVVRMGI4aVRkQkNtT0NrWGVuVWN5TDE4WXo4MU54cDZYZCtRMGtUUlZ6SkFv?=
 =?utf-8?B?Z1FtSDdWaHRzMnJLekpUN0FwQ3FtYXB4dmhCdHNQTkM1QTNIWDFlZEQ1S3hI?=
 =?utf-8?B?MVdmNlMyUUd6MHlrK2JRbG1uTGlpdnp1b3kwR3Z1QWpOWjlEb1RtTGxlQW5j?=
 =?utf-8?B?MVFJdDZHMDlMRFBjZm9NVWhvZlp3UC9oNkVnTVZ4NjhQblZ6SFpRclYxRU5F?=
 =?utf-8?B?ODgzcFdxVHRkenU1UHFMeXM0RHRmRktYL2NhanJJTkZOMkI5Wk5jcTBvRlNw?=
 =?utf-8?B?bnlneWIrMVlzMThzU1g2Ukt5bUtHTnNnOXlDUC9iaS85bmN4a1VKYThFTDA2?=
 =?utf-8?B?TkplR0d5cnpRSjhiYzd3SjVKVzR1c1RHZm54SkNRZkI0SFBzam42Rzlzbk1s?=
 =?utf-8?B?c3E1RnNOT3JrK3ZldzlmVzIwdWhIL0UvTmpNZm9hSmxlb041U3ZEWVBJWTM3?=
 =?utf-8?B?QmV6UmI5RU8yZ05IVjJKZzRKa1BvQ29xeVV3UnFIZ2ZtMng0VFlsNkcrVkVL?=
 =?utf-8?B?Ym54WjFFZm9FaytkRkVZM2hLelVlL3l6N0xRYjdwN2IzM1BWNU1JSzk5YWh1?=
 =?utf-8?B?MHlOSGFzektlTHcwdVNtZlRKazcxUllCRDBzSUxEdmtSbmZzdWNuRmRXc3k3?=
 =?utf-8?B?WFo4QmJPdVFqUWFMT1p0aENkUU11MXpJQS9TWWo4MUMyODZsSmZaZ1hjT2JU?=
 =?utf-8?B?eVZ1WG8vUjhiS0tkNS9TZ3JLbWt2dlF5YjV1dExqUStrL2dubEpuaytOV2dG?=
 =?utf-8?B?b0VSMXI5ODNNV09ncXFBVXJsOTdMNDVrVmV2SkRITFRRajRjWmt4NllhaXlN?=
 =?utf-8?B?cm1UeG0zUWpuTHp6THVXMHRZdjF2d3hrZTRNeFE5QlFkYTN5UE52eXV0Q0Uz?=
 =?utf-8?B?NHBvbWpzVmFOUzBDcS9JOFN4Vnc4Wnl1R0tOaitZUjhrMzg3SU1NVXlSVldk?=
 =?utf-8?B?YnlncHRmbFQzbXg4NmlsbWE3SU1xcXJsWkxBVytwdkQvdzRDb1JVTi9BMU56?=
 =?utf-8?B?T3VYaWNUeGphODdqWDJabWdyeFh0VlNEdFVMbG44eGV0d1QrejVFaFQwMFJ6?=
 =?utf-8?B?V1N5VW5XbXhveUNGQlY5R2FOck1nNFZPWk5CUVZ1RFZuYVhGV3BEcnVIN2Z2?=
 =?utf-8?B?OHJYR1RsQWxDRjJSd005a1QyR2tTajFrZ1pMbGtlRmk4RHN6empiUHN3VWZF?=
 =?utf-8?B?N0tsdFNtcnRycG5pWUswWGFZaWlldTNmOUpxb0J6OGQrTUU1WDNVbHAvcUhB?=
 =?utf-8?B?OFdKTmR0alJZbFVuTGhVOERCaDYwZEVvMERINXRNMHRudk9rUEVEWXpDc29B?=
 =?utf-8?B?MXp3cGJvdVUyanlla3dNV0FTUVlsNG00U283UmdMbW1aUmVFY0d1NWZlTVNp?=
 =?utf-8?B?WkVCUmlsemdtRVN1K2tnV3pxT1FYNG9nUU1ES2c3Ry80S1RRajMvMnZoUFpt?=
 =?utf-8?Q?QTTnS32do4vHDBhA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d8e2561-2d8f-4a29-e9c9-08da1bf5fb7f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 20:00:52.8622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FGPNJ9IK7p6WAdCPvBjwUuayxCeYQvbzfjWxIPHTziFqDNHRXyxOUkgADWNRyIUe719ONsE69RAFYoBJIHcA9dgY8q3sfMBEwSJoSLmxMu8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2520
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-11_08:2022-04-11,2022-04-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204110111
X-Proofpoint-GUID: XJdhQgFmeIohdJogztrs4ELssI_j_1f3
X-Proofpoint-ORIG-GUID: XJdhQgFmeIohdJogztrs4ELssI_j_1f3
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 2022-04-11 at 18:50 +1000, Dave Chinner wrote:
> On Mon, Apr 11, 2022 at 05:31:21PM +1000, Dave Chinner wrote:
> > On Mon, Apr 11, 2022 at 01:59:35PM +1000, Dave Chinner wrote:
> > > On Mon, Apr 11, 2022 at 11:50:23AM +1000, Dave Chinner wrote:
> > > > On Thu, Apr 07, 2022 at 03:40:08PM -0700, Alli wrote:
> > > > > On Thu, 2022-04-07 at 15:49 +1000, Dave Chinner wrote:
> > > > > > On Wed, Apr 06, 2022 at 08:11:06PM -0700, Darrick J. Wong
> > > > > > wrote:
> > > > > > > On Tue, Apr 05, 2022 at 12:03:12PM +1000, Dave Chinner
> > > > > > > wrote:
> > > > > > > > - Logged attributes V28 (Allison)
> > > > > > > > 	- I haven't looked at this since V24, so I'm
> > > > > > > > not sure what
> > > > > > > > 	  the current status is. I will do that
> > > > > > > > discovery later in
> > > > > > > > 	  the week.
> > > > > > > > 	- Merge criteria and status:
> > > > > > > > 		- review complete: Not sure
> > > > > So far each patch in v29 has at least 2 rvbs I think
> > > > 
> > > > OK.
> > > > 
> > > > > > > > 		- no regressions when not enabled: v24
> > > > > > > > was OK
> > > > > > > > 		- no major regressions when enabled:
> > > > > > > > v24 had issues
> > > > > > > > 	- Open questions:
> > > > > > > > 		- not sure what review will uncover
> > > > > > > > 		- don't know what problems testing will
> > > > > > > > show
> > > > > > > > 		- what other log fixes does it depend
> > > > > > > > on?
> > > > > If it goes on top of whiteouts, it will need some
> > > > > modifications to
> > > > > follow the new log item changes that the whiteout set makes.
> > > > > 
> > > > > Alternately, if the white out set goes in after the larp set,
> > > > > then it
> > > > > will need to apply the new log item changes to
> > > > > xfs_attr_item.c as well
> > > > 
> > > > I figured as much, thanks for confirming!
> > > 
> > > Ok, so I've just gone through the process of merging the two
> > > branches to see where we stand. The modifications to the log code
> > > that are needed for the larp code - changes to log iovec
> > > processing
> > > and padding - are out of date in the LARP v29 patchset.
> > > 
> > > That is, the versions that are in the intent whiteout patchset
> > > are
> > > much more sophisticated and cleanly separated. The version of the
> > > "avoid extra transactions when no intents" patch in the LARP v29
> > > series is really only looking at whether the transaction is
> > > dirty,
> > > not whether there are intents in the transactions, which is what
> > > we
> > > really need to know when deciding whether to commit the
> > > transaction
> > > or not.
> > > 
> > > There are also a bunch of log iovec changes buried in patch 4 of
> > > the
> > > LARP patchset which is labelled as "infrastructure". Those
> > > changes
> > > are cleanly split out as patch 1 in the intent whiteout patchset
> > > and
> > > provide the xlog_calc_vec_len() function that the LARP code
> > > needs.
> > > 
> > > As such, the RVBs on the patches in the LARPv29 series don't
> > > carry
> > > over to the patches in the intent whiteout series - they are just
> > > too different for that to occur.
> > > 
> > > The additional changes needed to support intent whiteouts are
> > > relatively straight forward for the attri/attrd items, so at this
> > > point I'd much prefer that the two patchsets are ordered "intent
> > > whiteouts" then "LARP".
> > > 
> > > I've pushed the compose I just processed to get most of the
> > > pending
> > > patchsets as they stand into topic branches and onto test
> > > machines
> > > out to kernel.org. Have a look at:
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git
> > > xfs-5.19-compose
> > > 
> > > to see how I merged everything and maybe give it a run through
> > > your
> > > test cycle to see if there's anything I broke when LARP is
> > > enabled....
> > 
> > generic/642 producded this splat:
> > 
> >  XFS: Assertion failed: !list_empty(&cil->xc_cil), file:
> > fs/xfs/xfs_log_cil.c, line: 1274
> >  ------------[ cut here ]------------
> >  kernel BUG at fs/xfs/xfs_message.c:102!
> >  invalid opcode: 0000 [#1] PREEMPT SMP
> >  CPU: 1 PID: 2187772 Comm: fsstress Not tainted 5.18.0-rc2-dgc+
> > #1108
> >  Call Trace:
> >   <TASK>
> >   xlog_cil_commit+0xa5a/0xad0
> >   __xfs_trans_commit+0xb8/0x330
> >   xfs_trans_commit+0x10/0x20
> >   xfs_attr_set+0x3e2/0x4c0
> >   xfs_xattr_set+0x8d/0xe0
> >   __vfs_setxattr+0x6b/0x90
> >   __vfs_setxattr_noperm+0x76/0x220
> >   __vfs_setxattr_locked+0xdf/0x100
> >   vfs_setxattr+0x94/0x170
> >   setxattr+0x110/0x200
> >   ? __might_fault+0x22/0x30
> >   ? strncpy_from_user+0x23/0x170
> >   ? getname_flags.part.0+0x4c/0x1b0
> >   ? kmem_cache_free+0x1fc/0x380
> >   ? __might_sleep+0x43/0x70
> >   path_setxattr+0xbf/0xe0
> >   __x64_sys_setxattr+0x2b/0x30
> >   do_syscall_64+0x35/0x80
> >   entry_SYSCALL_64_after_hwframe+0x44/0xae
> > 
> > Which implies a dirty transaction with nothing in it at the end of
> > a run through xfs_attr_set_iter() without LARP enabled. It raced
> > with a CIL push, so when the empty dirty transaction tries to push
> > the CIL, it assert fails because the CIL is empty....
> > 
> > I don't know how this happens yet, but there are no intents
> > involved
> > here so it doesn't appear to have anything to do with intent
> > logging
> > or intent whiteouts at this point.
> 
> 100% reproducable, and yup, there it is:
> 
> STATIC int
> xfs_xattri_finish_update(
>         struct xfs_attr_item            *attr,
>         struct xfs_attrd_log_item       *attrdp,
>         uint32_t                        op_flags)
> {
> .....
>         switch (op) {
>         case XFS_ATTR_OP_FLAGS_SET:
>                 error = xfs_attr_set_iter(attr);
>                 break;
> .....
>         /*
>          * Mark the transaction dirty, even on error. This ensures
> the
>          * transaction is aborted, which:
>          *
>          * 1.) releases the ATTRI and frees the ATTRD
>          * 2.) shuts down the filesystem
>          */
>         args->trans->t_flags |= XFS_TRANS_DIRTY;
> ....
> 
> Ok, so the problem path is a create that ends up being a pure leaf
> add operation. The trace looks like (trimmed for readability):
> 
> # trace-cmd record -e xfs_attr\* -e xfs_defer\* -e printk
> ....
> 
>  xfs_attr_leaf_lookup:		ino 0x99a name x11 namelen 3
> valuelen 28 hashval 0x1e18b1 filter  flags  op_flags ADDNAME|OKNOENT
>  xfs_defer_finish:		tp 0xffff888802e27138 caller
> __xfs_trans_commit+0x144
>  xfs_defer_create_intent:	optype 5 intent (nil) committed 0 nr 1
>  xfs_defer_pending_finish:	optype 5 intent (nil) committed 0 nr 1
>  xfs_attr_leaf_lookup:		ino 0x99a name x11 namelen 3
> valuelen 28 hashval 0x1e18b1 filter  flags  op_flags ADDNAME|OKNOENT
>  xfs_attr_leaf_add:		ino 0x99a name x11 namelen 3 valuelen
> 28 hashval 0x1e18b1 filter  flags  op_flags ADDNAME|OKNOENT
>  xfs_attr_leaf_add_work:	ino 0x99a name x11 namelen 3 valuelen
> 28 hashval 0x1e18b1 filter  flags  op_flags ADDNAME|OKNOENT
>  xfs_attr_leaf_addname_return:	state change 4 ino 0x99a
>  xfs_defer_trans_roll:		tp 0xffff888802e27138 caller
> xfs_defer_finish_noroll+0x2a5
>  xfs_defer_pending_finish:	optype 5 intent (nil) committed 0 nr 1
>  xfs_defer_finish_done:		tp 0xffff888802e273f0 caller
> __xfs_trans_commit+0x144
>  console:			[   94.219375] XFS: Assertion failed:
> !list_empty(&cil->xc_cil), file: fs/xfs/
> 
> So we have a create/set operation here. THe first lookup is to check
> that xattr exists or not. Gets -ENOENT so it sets the transaction
> to deferred and commits it. That gets us into xfs_defer_finish()
> where we process the xattri. We don't create an intent (because larp
> is false), then we finish it. This calls into:
> 
> xfs_xattri_finish_update()
>   xfs_attr_set_iter()
>     case XFS_DAS_UNINIT:
>       xfs_attr_leaf_addname()
>         xfs_attr_leaf_try_add()
> 	  xfs_attr3_leaf_add()
> 	    xfs_attr3_leaf_add_work()
>         attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
> 	trace_xfs_attr_leaf_addname_return()
> 	  state change 4, XFS_DAS_FOUND_LBLK == 4
> 	return -EAGAIN;
> 
> args->trans->t_flags |= XFS_TRANS_DIRTY;
> 
> Now we return -EAGAIN to xfs_defer_finish_one(), which requeues
> the defered item onto the deferred work, which then returns to
> xfs_defer_finish_noroll() and we go around the loop again.
> We roll the dirty transaction that contained the dirty leaf buffer,
> committing it, then run the loop again.
> 
> This time however, we run:
> 
> xfs_xattri_finish_update
>   xfs_attr_set_iter
>     case XFS_DAS_FOUND_LBLK:
>       <tries to set up and copy remote xattr val>  <XXX - why?>
>       <no remote xattr, nothing dirtied>
>       <not a RENAME op>
>         <no remote blocks, nothing dirtied>
>       return 0;
> 
> args->trans->t_flags |= XFS_TRANS_DIRTY;
> 
> So, at this point, we now have a dirty transaction with no modified
> objects in it. All we need to do how is have some other thread flush
> the CIL and then for this task to win the race to be the first
> transaction to commit once the push switches to a new, empty
> context and unlocks the context lock....
> 
> And then xlog_cil_commit() trips over an empty CIL because we had a
> dirty transaction with no dirty items attached to it.
> 
> So, the code snippet I pointed to above that unconditionally makes
> the xattr transaction dirty is invalid. We should only be setting
> the transaction dirty when we attach dirty an item attached to the
> transaction. If we need to abort because of an unrecoverable error,
> we need to shut down the log here. That will cause the transaction
> to be aborted when it returns to the core defer/commit code.
> 
> In debugging this, there are several things I've noticed that need
> correcting/fixing. Rather than go around the review circle to try to
> get them all understood and fixed, I think I'm just going to writing
> patches and send them out for review as I get them done and tested.
> The faster we knock out the problems, the sooner we get this stuff
> merged.
> 
> I'll start on this tomorrow morning....
Ok then, I will wait to hear a reply on this so that we don't duplicate
each others work efforts.  Let me know if you need me to pick something
up.  Thanks!

Allison

> 
> Cheers,
> 
> Dave.

