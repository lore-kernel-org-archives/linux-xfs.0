Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BDC0C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 19 May 2022 20:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240828AbiESUd5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 May 2022 16:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237508AbiESUd4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 May 2022 16:33:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B37B7A824
        for <linux-xfs@vger.kernel.org>; Thu, 19 May 2022 13:33:55 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24JJxEr0029206;
        Thu, 19 May 2022 20:33:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=l3IK882UtcDTO3A6QvACWnn3dMNcUi9W8OJIgGJfER0=;
 b=isia1tiA7jqySw5DfKYZi8+fXBerezM3ccgdwYG2vEVYvEEqz94JcNZCrgnUwE7YPjsC
 rV78u1yx5xJMjvvK6GgXyCIgFZelRL1TiQjSnALssp2heii5ZDw/eMguGB9jCvg/WdOx
 Jve5VplBloS6AUPzyk9gPxzZ8zFo2OSqRCNo52FxPLPNCZyKYBCOJKhRR7wI4m6alOlI
 cmMyNSq+d7o1BjtU5cYhO+QfW5ryTymB0uPhzxpQKTxa5AibAEixabIordWvW7gUDjIT
 9DmrDQjntAx0jwzlb15rGENO0S7lFTof8z8ilHak+7UTF/tvm99qbd4bGOBlKMg4jxc/ Iw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24aan2m9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 20:33:51 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24JKF70E001602;
        Thu, 19 May 2022 20:33:50 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v5nkwa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 20:33:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jQvze0pBpS+wNjG+dfsMlvdZE6H0lhFlor01TPRugWAQZ7ZM4Yppj5itkAvjtQuuPHOfjvHsp272cccIV5CBniPm8HhpXq+EOyXtPcr68/sqhWX16bmmUeJR2HhS9odz4UVeEgIsIIHocPU+6nsWwJtxh46bgXIUyraVEALqwjPEE15wL+ugH8fvSmuBn6QTUXwlrfZ+P5vxlnXBwkKMeUDfoxGjCnEurHSYmeKO/GaYuzGAa7C3bwemSKh9YH9FOWNWpqJetoVqzIRr4fEpC18mjhsnnjukg/B0m7Lfj2+z32VmBTD6lEZwRm/koyD/cfhpmD0feTW0t4+IdZIF7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l3IK882UtcDTO3A6QvACWnn3dMNcUi9W8OJIgGJfER0=;
 b=hOAR/1hsH9lGc7NWKTAy5wGhy7iUPF5FYfb2oL5SZ6VscQxKqiaFkLytk7D2exTLGPZHiUXoxPZoYZkVWqPYwqLDFD/TYYjOzE4nxuIF2GCsDTyk2OfzBUI9XCLu9Zv8fGFekipnRlOQT+uwkyCxXuq2W3LuOND0mnq8e1i6EnmmgcA0F06VOq38vRp1/3NTc1xmdr/tNx70zQ/fsfwBbidXOHgHnzgwL9CL+vtsE0z1U4/FKUZXsl68ciqU305jJAR8e916YnQ/DSZjOo5L5Tak7xxgD+pexMqb4Zd0liLN07vY7vB/NWFgXAHXCAo4LlxMkQ2KVeR5aEQzAL8rTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l3IK882UtcDTO3A6QvACWnn3dMNcUi9W8OJIgGJfER0=;
 b=qPlNChczfpCb3CaJ34AFrH9ZOVHIsTJXSe2HuEDskv6A9t/I6QRR2NRrK5Lcqae0pDNUdRErzi5VVuz1vTYUpAiWw5bNnWoyPjsPEbvbxHEp5AGfX3VPHgu4lfL9abOHrPLghgBCeRaZY0YGeL1pqwB4yOO10cx4MHRn4f5t8Uw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM6PR10MB3243.namprd10.prod.outlook.com (2603:10b6:5:1a7::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Thu, 19 May
 2022 20:33:47 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.014; Thu, 19 May 2022
 20:33:47 +0000
Message-ID: <7b913a13ac5c8f7fdc01899f57ff6b4b23e1c4b7.camel@oracle.com>
Subject: Re: [PATCH 1/3] xfs: validate xattr name earlier in recovery
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Thu, 19 May 2022 13:33:45 -0700
In-Reply-To: <165290010814.1646163.10353057311329638248.stgit@magnolia>
References: <165290010248.1646163.12346986876716116665.stgit@magnolia>
         <165290010814.1646163.10353057311329638248.stgit@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::14) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39335d15-92e9-4246-eddc-08da39d6e04e
X-MS-TrafficTypeDiagnostic: DM6PR10MB3243:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB32431636149ADEEDE3FF7CB095D09@DM6PR10MB3243.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tOHJVoUmuoamcf2aM0NdLNWcHahHMMMudGkG6C0oq8qtEcxyhflcdcGg4NqvR3B82ovWvIuUeWynE4Yd+yBWTp8r3OCH4qzRYRguDujMQnku4PemdvEPIbGqiYb2uviCHFAykOSBXKTeoJ+sVqxeNhknkjV/vPyyyZ0ukpoe/6v1lLHiVydS8q1d7PnQfkM4au9Z7abZg//TniZ0PJuTq8Sipmc00ITV3/v3ykikwYRBd32HMrjcxy9+Ls199dvVH/50OUnJeMJNyPkY/95GeM9aaffIaDMjDzjj6cVVCpGFpK1mgmWBC+ivt0AQjWTDF4AvvKqVA+21J9quKqLXf408XE7SkOrL15TCrKpvAW6oo/LMLozGBVI6uxjlxY6EnMdmb15uJAYmvtdAXfFus7kRQY1tJ+0xiSDJg0S4Z8JbzDIVMD2+fheg2x0C8FrV+4geMB4DlGt7bZopTAVQA9bDwNt5tEtGnh6YQnVB0nFeT5/P+Le6luKkO5Hsrk8B2iNn5oUqVQMruvVn16Sqkc87j+OnfxVFWGatY+VO6Qus65OhBIEIcjDDd45sxVGlz4JzXm837JfR8PDJVkF/NYKQJb7ptqOVeUSy0LrOryrTNhDYns0mbONH+vdVvmsyrhBeW/E3YFs71fTzNxDtuvH16a6zShHXq6G79uHvfcN7sWnk7qmju1c5t8EUDJxma9a88C/jimFK2zQjvqGjoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(8676002)(86362001)(66556008)(66946007)(66476007)(6916009)(316002)(38100700002)(38350700002)(5660300002)(8936002)(36756003)(508600001)(2906002)(52116002)(6512007)(26005)(6486002)(83380400001)(15650500001)(186003)(6506007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MW1pNjA5a2ZaZ0pXR3kxWjNOM1RJMERoYllPaE9ua0VPSFhoUCs1T2tVRzlP?=
 =?utf-8?B?dHBmbzJWamw4aFN6Sm5WeHBQaG9lVFZIU1AwMko1a0pBZnlJWkdiZkVSb3h5?=
 =?utf-8?B?UU42cURHdmtMZTNuMWJSVkdzWVN6V1krdWp6ckFJVGNIb1Q4dVlCMHBwYUN2?=
 =?utf-8?B?RmYxQUhSR1hPNzc0VXBtVVN4dGNqYTZSeWU4ZXZYKzVqb2xpUHRUWXNxSWJI?=
 =?utf-8?B?VUxnYktpMlBZdkh3N3N6cDZqbnR1eDB0VCtMblFYbW5mUXZoanpDUnlvb2xi?=
 =?utf-8?B?N09DeEU3dmxvcVB0TS9LendYMENGTHNpUVFtWXdoaERIQzI4QnZ5clpra1VQ?=
 =?utf-8?B?WklZeFdCVGlrK2xQbHdGa0FHN2Yxb05JSFM2c0FVSjZlVUc2M0huN1d5ajNS?=
 =?utf-8?B?Q0hrMzdVeFViY3J3TFFxeXB4YjVSL3FmRGVjRUYrVmtiWndZU25XcURpYmdu?=
 =?utf-8?B?V3NremxZSkNrT3VmbnBmLytGQkx5OExKS3M3Q0VNYy9pRlkvSGgvZEpmeTBx?=
 =?utf-8?B?Q2RVdTZIRUQ0WkJBMWRMeE9kSGlETGlBbTNmWThZdFFwaVR5Yld1bU9GcW9i?=
 =?utf-8?B?ZHZ5ckcycEJEV0hkMHVKcVpoNWQ2K3orSEJWY2VLRUNHQzZ5MHNPRWhTdEda?=
 =?utf-8?B?V3BEWFJvQU9Xa0YwcHdWdEVmd1VkL1VFSC9HMzFSTFM5QmdYSWpFdzVNejUw?=
 =?utf-8?B?aGZXVlI2RlRIenROaTRCNmRkeGZpN0s4RGtmeTdXSXBocUhTNVh0MWFKb0dm?=
 =?utf-8?B?OHErLzYrSHMvdlpuSTJ1eTl1cnVmWE01ZFlITWRuV0hsMjVDOHppVnR5WU1v?=
 =?utf-8?B?c3hKK3RHdEUwczJHZXRJUWtIOGc4blUvTmR1Z1A1K25yci80VFhNUXZ0UXVz?=
 =?utf-8?B?TDZ2RWZxNkU4MTU0eDA1Zjl5VUNpdm90ZzdBVjVEMXNaVVBtS1IzQXJpaDVP?=
 =?utf-8?B?Rytmc1RLb0hkU2xEZFB3OURzOGhlVVd4VjJ4aXo1TEdrbTNLL0hBWEJFaUEz?=
 =?utf-8?B?WFE1OXRnYTZBMlZJVnNzdGJPTllGOFpNL3BRRFFuRE9Xd2pXQVZoMkgxcDVI?=
 =?utf-8?B?QnllaElURk5HUVNQUmdWRHQvL1NmMjFuN2hvbTYwY1QyNEZQdVZKZU5KVG1J?=
 =?utf-8?B?T0NVVjN2N2I3ZlZ6ZUNUQm5MZjVPbWQvV1RBYUsvMkR4eFdpV29hbTNnSUhk?=
 =?utf-8?B?VDkzaTRUT2JoQkt1ZXJqWEc3L2ZrWjk1TjV6ME9RNW5rL2cvcUVzZE9CUS9w?=
 =?utf-8?B?Tk5ITFZLS2Fzc0diVi9rRGdJSzdYQ1NMeDFBQW9FSmcvRExDd2tYeTNKMEtW?=
 =?utf-8?B?M2ErTDVpbjJlbnpNL3BqbVZKRWtYM2lqbTBjTTlrU3pGVEdkWGRXWlFhSmhp?=
 =?utf-8?B?dW5La05Ib2YxeUwyYUh5T09jTHRIMDd5TGIyckhlV2FrZ3FCUk5pRUtHWEgr?=
 =?utf-8?B?T3hQNnJWc1YxV3RiSEUrSFF5OXV4dkRYWm9QTVpQWDNHOEIxbDZNVmEvWkFH?=
 =?utf-8?B?dGVPdDkxYks0M210UXZQNWFHcGdOTURWcmFVYWlaQVJjTUh1eTJYbk55eXJ6?=
 =?utf-8?B?VzkrTkNIYUlHdmJiV2ZTQ1JCMG1hZjZIbXdQaTZmWkprcGFzM3ZUMVFPNmw5?=
 =?utf-8?B?ZnBVMS9sUCs2U3hkYk9aUk5wRVZjV0xuTUJqY254TlBxdlhEcEpQaDd6aU5K?=
 =?utf-8?B?QjJvSFBySVhMQ3RoRkxxUC9oZzh2MWhEVjRlRHk1RW5ySUVaTlRyV1RyTjlK?=
 =?utf-8?B?UzRzMzViS3I0L0RxM1RLdFF6Nno4ZmlYcG81WkFPYXordDdobmpPVXdmSmFk?=
 =?utf-8?B?SElnRlpXRUpwNTNPeWk1ZFVyV1VzSC9WU2xVZTZnZ201dWI1djZOVFdReFNW?=
 =?utf-8?B?OC9XZkVyZXhVNEFWb0ZFR3pJenQ0Z0xyZUtMZWFPaDFNRFZKZDNCV3Yvejhr?=
 =?utf-8?B?QUp0MUNtWGdBeHNib0h2WnpsVWcwYkVvcTRMRFZEQ05VcU9ZalpWZGxWejhO?=
 =?utf-8?B?bHJ3bFcvYTBwWkpYSXNUbWVYZlk0dE1oSUJobEhOTitjSkpzUEluRW5qV3Br?=
 =?utf-8?B?R0VJaE9EeHY0d05EZzlNN1hHV1hKZGI0TDNPbmd0VkNDZWtoUjZmS2EvRTBp?=
 =?utf-8?B?MjZ3bUtlN1FrVmF0OTFEa2xXY2hTZTVLWnNlMUhTTUdsSXFqL2tIUWZ4TWFY?=
 =?utf-8?B?NGFZTXJxUm1IbmUzVjdDc3ErSzJubWdmbkcvOUIwQ0ZqTFk5bEhKWE5CNXFW?=
 =?utf-8?B?eVhmaEEyNzdKUlhYekQvUTFlN2lDd3E0UWw1WnBPQmtkc2d6VmxzTGtibDUv?=
 =?utf-8?B?OEtmdFg1N1JEQVlhd3EvcHNqMUlSQTAxT3BXRThwTmtaTWwyZjBaUUNtcEx4?=
 =?utf-8?Q?9gBWjh5q6oM58Kqg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39335d15-92e9-4246-eddc-08da39d6e04e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 20:33:47.8212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YCQgb9k88vvfEedIzw/1U4E0oSe3VmRJtrLj4lYOxrcNdCbKRSi9vVKQyxSs2exydM3jeuWYzr2LnnaqslQj62jVJM48wR98kAFhBxBeaXU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3243
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-19_06:2022-05-19,2022-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205190112
X-Proofpoint-ORIG-GUID: fZBmLeoTfw0syObt8558lyjVZKLpbh-v
X-Proofpoint-GUID: fZBmLeoTfw0syObt8558lyjVZKLpbh-v
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2022-05-18 at 11:55 -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When we're validating a recovered xattr log item during log recovery,
> we
> should check the name before starting to allocate resources.  This
> isn't
> strictly necessary on its own, but it means that we won't bother with
> huge memory allocations during recovery if the attr name is garbage,
> which will simplify the changes in the next patch.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Ok, this looks good to me
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/xfs_attr_item.c |   15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index fd0a74f3ef45..4976b1ddc09f 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -688,16 +688,23 @@ xlog_recover_attri_commit_pass2(
>  	struct xfs_mount                *mp = log->l_mp;
>  	struct xfs_attri_log_item       *attrip;
>  	struct xfs_attri_log_format     *attri_formatp;
> +	const void			*attr_name;
>  	int				region = 0;
>  
>  	attri_formatp = item->ri_buf[region].i_addr;
> +	attr_name = item->ri_buf[1].i_addr;
>  
> -	/* Validate xfs_attri_log_format */
> +	/* Validate xfs_attri_log_format before the large memory
> allocation */
>  	if (!xfs_attri_validate(mp, attri_formatp)) {
>  		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
>  		return -EFSCORRUPTED;
>  	}
>  
> +	if (!xfs_attr_namecheck(attr_name, attri_formatp-
> >alfi_name_len)) {
> +		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
> +		return -EFSCORRUPTED;
> +	}
> +
>  	/* memory alloc failure will cause replay to abort */
>  	attrip = xfs_attri_init(mp, attri_formatp->alfi_name_len,
>  				attri_formatp->alfi_value_len);
> @@ -713,12 +720,6 @@ xlog_recover_attri_commit_pass2(
>  	memcpy(attrip->attri_name, item->ri_buf[region].i_addr,
>  	       attrip->attri_name_len);
>  
> -	if (!xfs_attr_namecheck(attrip->attri_name, attrip-
> >attri_name_len)) {
> -		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
> -		error = -EFSCORRUPTED;
> -		goto out;
> -	}
> -
>  	if (attrip->attri_value_len > 0) {
>  		region++;
>  		memcpy(attrip->attri_value, item-
> >ri_buf[region].i_addr,
> 

