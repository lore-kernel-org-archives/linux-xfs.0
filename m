Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29B1AC43217
	for <linux-xfs@archiver.kernel.org>; Tue, 17 May 2022 18:21:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352057AbiEQSV3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 14:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352030AbiEQSVB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 14:21:01 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3F9E035
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 11:20:57 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HHTAS1029111;
        Tue, 17 May 2022 18:20:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=urGgJrU6cHuG6ebiDRe/9Uv+YKk0zKOLrVieU6CkuD0=;
 b=PcQOShCZ4JE2l8ek5UFYD8lxVQBTBrP3oSo+xjBE2PMS5IxOzqnZN5D00A52VdtsXtoY
 tWvS1o5mvRur4QTn3vxYjwBM2QZ27VLmjPv1GqUBsXm1DAK9UdhPNbOJ5li3MZU6/pco
 UTrispdMO11wqJVZsXbgQLJii/GOZb2CSPFOSWQ9NrhdAGj4NWp4XAgLP1nXZMmO+cyK
 5lG6VKN/2qsZiPTHY8Z13XJLYFhEQeZ+nWMHT8WL4mNQ981yhOXC+l7F7hJxxQ/ZoENv
 8B04SjaqOWC6/NNxvyiyhtjvHyl1okr7Nj/jCXl1v2O6Re5nacRDmqudR5yhInWRpJn1 XQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2310q7x1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 18:20:52 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24HI5fK3040581;
        Tue, 17 May 2022 18:20:51 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2044.outbound.protection.outlook.com [104.47.74.44])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37cpgd1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 18:20:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Czo/NhmWldVp9C8oKVSRnzrDWTnHvRZkhZ0FDeWdTJKlILsrVr/hzUVLWAtXvLrvSbgVYm0rkbifd7N3Y4bdWIkZIRSPe5Ujws6I65nIhc+27ijwUmYPEdv5RUKZqtK83dTDZ3KXwERKe/ypu0JwQMw5XC0NLHBta9ArBU1uz+rABh3iu9zxc6bF5nU6Q2tNS4zHzntU9NExowFMmvD45w8ZGdF5JmSSkoNfrJ6clR3RLQ1QtEK/OQhzd6KEdt7eU1tRRx7+mAM3kIG932+G8fE7w64r9dmhaVOXqaiVuVkpZNaE3AsOkiRYR1WEJWKM9Kbxk/dT0tpmdR3K0NV5Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=urGgJrU6cHuG6ebiDRe/9Uv+YKk0zKOLrVieU6CkuD0=;
 b=guGMglTnDcmOvfyOwEYxJPhPPYdz0jJk94yAWtOxsEhweZR0JT8tsvI5a4vylG13Nzfl4w9TRyy72SKNT04wDfFuMhfJ3VNNEv+zzDxLHaZC6eyRPk+l72P8X0iNnirnMAS+/N5PeSrYBNu/hHNeKz58ndP7GHJ8G3zmeIMxKE31RpescokujkmuVp83K8AMJISnE/VHEqJRplxPn0m5hgn4XrbgImtvrckXpRLY/IyJOeM0LiF0DLgqlFZF3nnJyveJ8VHKa9qHrtCPpueA8pHSgU50h2O5oA8y3+fHJOpNuJBGF6w3mRXPLvthTJm9/AFrpEEdsJtBj4oPG0c+xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=urGgJrU6cHuG6ebiDRe/9Uv+YKk0zKOLrVieU6CkuD0=;
 b=GNkzEr3Tl4hzU964ZpsD582qbU4BJkp3Zv8RwNxUW34PfJhCejE/gEdLjV2QJD/LQfsHjbhmzGXU5Vq+FgUkUq1YKeRcdWX++bnip7OCGr97S0GYg5t+meXlo73KNg9ycpisfrnm7Br6TZWitkLw9QvOXjdEumv6AiR5I0ICUCQ=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by DM6PR10MB2841.namprd10.prod.outlook.com (2603:10b6:5:6b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.15; Tue, 17 May
 2022 18:20:48 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::54dc:43a5:ea4e:22e]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::54dc:43a5:ea4e:22e%6]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 18:20:48 +0000
Message-ID: <8dfac8aee25f51f3db994cacd6ab65329848d730.camel@oracle.com>
Subject: Re: [PATCH 3/6] xfs: use a separate slab cache for deferred xattr
 work state
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Tue, 17 May 2022 11:20:46 -0700
In-Reply-To: <165267195530.626272.4057756502482755002.stgit@magnolia>
References: <165267193834.626272.10112290406449975166.stgit@magnolia>
         <165267195530.626272.4057756502482755002.stgit@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0202.namprd05.prod.outlook.com
 (2603:10b6:a03:330::27) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5dc1dcb7-2c06-47ef-55b0-08da3831f794
X-MS-TrafficTypeDiagnostic: DM6PR10MB2841:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB28414737191EB16F2AD8846F95CE9@DM6PR10MB2841.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zjLzZeD5c4JshuVr+kknqRyTFJ8VzHeGEN9VRnP+Z8GI0H09vntzxZt2pbvAo7HgieovLMPg2JGVlPwz5hgInjmnzdrcbvHmNPjJXpyyeggr7mO3hQeyJDfwr9h+B76VfQN4caH8rfLWI1Vm0m529hLtvEubxmlajKqaaH9OroTvqIXWb7lZwcoEfK8lQZJkB20cb3MuJt2cy9W7LrJFV0VEGGn/9gjZKoTP/GI93Dh/cAqMy+ZJVh60oEp9iJ4QLviP0YhwBujibGqs2Prz6b/fGZA1VLme9NtQZvTVKatd1iBltWRWWYAPAoP6L51vwRNus2uApVQDx1p9qhVCFP73djGV+6SZPpEYZ+jzVZzS/UzUM28XBuuY/09y2a2c0kjoRUDnQIUeQ7zXNqIPhdjF9PE8hvP1vcp6J9pvHSZplxvrONS6hUu5rU4Cl8QXfd28z9KBU1r6o92O0+NmRIfZ6x++BnygESobIw3z6jJts+s90U7f6EyhYQbFAlW5JfMJlTa+UEFU32FC2w+w1vrRDwXl3FYDahwBqD/uFYr8FXv5y53O3sc+k6PNbefqKRkQc6Npum6nSuiIM7dsf5oQkTQT3GF5oOwzJb8nz2Ic2bUAzpmMArzVy/1yButKAv94Hop72x6yqv1D0LmdsgXPOhzkT3gRlUiUob7TpnpTCoVvlS0WNPQEnrBtjqr/2Ea2r8SIa31oysLxXZQjug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(86362001)(36756003)(8936002)(83380400001)(6506007)(508600001)(66476007)(2906002)(4326008)(5660300002)(38350700002)(8676002)(6512007)(2616005)(6916009)(186003)(316002)(52116002)(38100700002)(66556008)(66946007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RXpyK1M1MmNyby94cHM3TEd5ME1vYTdrQllwWUVwTmk2NGVSRWdDV05uYkhT?=
 =?utf-8?B?NStkekRIdXl6dDQwdi9TRDhHVENST0tCbEI5K0pEY3EzdUhMdVR0K2VDODI4?=
 =?utf-8?B?YjJVeThzRDJZS3lMR0hXWDk4b2Z2Rmxvcjg4K1Byait3Z3J4MHBxTVYvaHl2?=
 =?utf-8?B?d0duczNRTXl4MjBaeXpMUi8zekVNSE9YRnhrOGdNUG9QRjZDMzlIZmhLNjVl?=
 =?utf-8?B?NEZEMTRtL1UxNktuVU15NkIwdm12WTYvMFBOaUdNMjNIazREcE9xdUVVVHZ6?=
 =?utf-8?B?VEhCZHpneDJuTmplNVZUU01zSHFCQkpNbzJvZFBjVlZ1SkQ0dDErOWtReWti?=
 =?utf-8?B?U3FMUlhQcTFEKzU4ZW83cUFUUlhzMkkzNHEvb2ZtR0pEdExDR2tIMlFwcVBi?=
 =?utf-8?B?TXdTeWJ2eUh3ZUR6RnpicVVXTzAzTHlCRnB2MklVSHkvdlEvci9ldnZURTdN?=
 =?utf-8?B?T3J4T1FJem9jaENLV3BkRFAvZHdEekpBWDYzOGg2by93a3c2RURwdmxWVVBl?=
 =?utf-8?B?VzN2dkFDcmVHVUs3TUhOMmxXbExCS0FZSXFwUURFUW9PVG9ycDYxQjVYbkVM?=
 =?utf-8?B?aUUxK05VUWFQeGlUSE9oSVlxSGRvSUF4UmlBNVRGN1gybTQxRVhZUnphNGVN?=
 =?utf-8?B?ME9nWkhHYkNpQ1BPN3YvMjJqRHY2TDlCc21BWmNUMUU5ck5yYjc0WFVTM3Y3?=
 =?utf-8?B?eDlWT1IyZGh2azN5OTI1VmIzcTNJSWxFQkp0eTdPcEtRb3kxZFRhbFJMb1cx?=
 =?utf-8?B?RUUyNEVNL21OT3NiRnNydFN5QXpQWGc3TkJXV2JHdjNabk1XWmVNTGFxQ3Y3?=
 =?utf-8?B?dzVRN2pWQ3k1Wkw2aEd0a0sxRWlEc2pQa3BjSXF2UU9QeGFjekpLNlBkSGpD?=
 =?utf-8?B?cGxDclVXWlZDYm9pZEZhbUhwcGw1M3VEM3VxTHA0TUFiUjlrWDNKZWxXNEsv?=
 =?utf-8?B?Z201a0dRV2xkN2VlSnZObDN1SEVOQVZUMGhkM3BFdlNnNzR1NjFpL3VoeU5U?=
 =?utf-8?B?eG9rQVZYaWljN00wTWI5N2RRN3ZETUVXd0ZJTGVXdUpJaGVENVNxSzZBQ1Ey?=
 =?utf-8?B?K1ZmZCszZ3hGcTF3b2ZLTjRMelgzUURzM2FRVThCV3Jsc0oyaC9GVTNsSk9k?=
 =?utf-8?B?Qys0Y0g1cXJmWDM4VjNwTW1TaVdRb2ZGdkRzMlZFK2o5NDNiclh3SmFOYml0?=
 =?utf-8?B?SGVvbUtYVWRiTC9RQnpGZEszUzBuNFhXMmJSM0VOYUcvZURYdUIzclo2UFJz?=
 =?utf-8?B?UFVZT29zWCt6dStDVEx3N2o4Nk9XSHVUMjF6THYzdWp3TVQzSDNBc1hOSXRo?=
 =?utf-8?B?Ky9OK09zUTlSYUMwdzE1cUhwdDRwcCtGMUdiNm9Mc2FEd1VrVlFzbUZQWVhw?=
 =?utf-8?B?RlcvZnBoM1NaZlZKTDZuRGFqKzRDMjRiVjhzcW1EblpvNUpEaVpJSVcyQWxH?=
 =?utf-8?B?dlVXMEVRYTRFOW5vRUZOL0pKTXlXQUJTM2VJSTVROTJWQS9uZDVrZWpoZTB6?=
 =?utf-8?B?U0c0OFQyK3dSOHB2WklIMnpmUVBiSmZDSmwyWEdOZmxCVnJ2UHNIQ0wwM1Nv?=
 =?utf-8?B?ZVRZUE54KzNpWURIdTBSaVdtdkU1V1RtR0tpb3AwVTZzTjIrbXZqMk9PZkFn?=
 =?utf-8?B?czR2WVRJcTY4ekxVcFk1YTJOYk9GN05aS2dwQUoxT2gxNGxSVm5tM2dLSzl1?=
 =?utf-8?B?L2J5QjFybGpUK05tbEVJaDRRa3RtT2plME5IbG5uWWJSUnlvNHAyU2MwcU9H?=
 =?utf-8?B?bHR5NzNQNnZlSmVEcEk0WGJEcVVjU3RoR1RNeUtnaiszbmw5eGUwajJzVEpK?=
 =?utf-8?B?Znd0ZFY4blZYaWtWRFV6V2h5RCtNNjNTSGlrbWxLY2tlRVJFNzlvUGk0V1kr?=
 =?utf-8?B?UytnSXdVT29YZlNnamY4YzhtNjg3ZjZpVWtPNGh2L0I5V2puV0lKbmt5MHp4?=
 =?utf-8?B?UGFwckpDRU5xWTF2MHZhWVFncmpzWjgvWld6bWN6L3l6eUpRUUY5NmxmTmFx?=
 =?utf-8?B?bk4yVk9PTjZWREdFTjlvd0dpYUdiRXV3YWo0M015N1dXMlIwbmNsaktNa041?=
 =?utf-8?B?OWNualpCVUhrS3ZSOHd0YVZhZTN6aDdUVXpycFNWR2xXQkJiQmN6dTdJclJP?=
 =?utf-8?B?VXdwV1pMWENYUENFYmZXaWI3VVNXMDc4bTYrcExSc3YxbE9mcEY4M0hPVy8y?=
 =?utf-8?B?Z1djbW5RSUphRkI3L2N4RHZKZy9JazgxZUxVMjNOaWJkaytSVHVWRXVlVUhF?=
 =?utf-8?B?QUs2Q25VcWJST3BtOE5RTlJxVDh6MHRzT3dZWjFDdUhNRkJwVTllc2xTSVk0?=
 =?utf-8?B?anpLTThFY0hvdGg3WVFkUmNWTG1QcCtsTFJDL3I5UWFOUnlQelMxRndscWNq?=
 =?utf-8?Q?Fjo9jzLoEVHbY8eM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dc1dcb7-2c06-47ef-55b0-08da3831f794
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 18:20:48.6155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /IL0I78u2+XGhr6dani+ykYpJaNaqU0Rgs2pkBHT+/kvjU3gHIpYUPBT3Jrz4CHo3MVnsLlcMJ6g7DarXyF/yQWjw/EBxD4GSysU0OLlm6A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2841
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170107
X-Proofpoint-ORIG-GUID: 1BISER7G6fQmOwR-oMvRC30OYk0URt0a
X-Proofpoint-GUID: 1BISER7G6fQmOwR-oMvRC30OYk0URt0a
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, 2022-05-15 at 20:32 -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a separate slab cache for struct xfs_attr_item objects, since
> we
> can pack the (96-byte) intent items more tightly than we can with the
> general slab cache objects.  On x86, this means 42 intents per memory
> page instead of 32.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr.c  |   20 +++++++++++++++++++-
>  fs/xfs/libxfs/xfs_attr.h  |    4 ++++
>  fs/xfs/libxfs/xfs_defer.c |    4 ++++
>  fs/xfs/xfs_attr_item.c    |    5 ++++-
>  4 files changed, 31 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 0f88f6e17101..687e1b0c49f9 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -29,6 +29,7 @@
>  
>  struct kmem_cache		*xfs_attri_cache;
>  struct kmem_cache		*xfs_attrd_cache;
> +struct kmem_cache		*xfs_attr_intent_cache;
Functionally this looks ok.  It does make me think that at some point
we may want to look at improving the log item naming scheme in general.
It was my observation that most items have a xfs_*i_cache and an xfs_*d
_cache which I think stand for "intent" and "done" caches respectively
(?).   And now were adding another xfs_attr_intent_cache, but I feel
like if I were new to the code, it wouldnt be immediately clear why
there is a xfs_attri_cache and a xfs_attr_intent_cache.

Initially I had modeled attrs from the extent free code which called it
an "xfs_extent_free_item", hence the name "xfs_attr_item".  So i
suppose in that scheme we're logging items to intent items. But it
looks like rmap and bmap call them intents (xfs_rmap_intent and
xfs_bmap_intent).  Which I guess would suggest we log intents to intent
items?  So now this leaves extent free the weird one. :-)

In any case, I do think having the extra cache is an improvement so:
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>> 

But it does make me think that xfs_*i/d_cache could use some clarity
perhaps as a separate cleanup effort.  Maybe xfs_*i/d_item_cache or
something like that.

>  
>  /*
>   * xfs_attr.c
> @@ -902,7 +903,7 @@ xfs_attr_item_init(
>  
>  	struct xfs_attr_item	*new;
>  
> -	new = kmem_zalloc(sizeof(struct xfs_attr_item), KM_NOFS);
> +	new = kmem_cache_zalloc(xfs_attr_intent_cache, GFP_NOFS |
> __GFP_NOFAIL);
>  	new->xattri_op_flags = op_flags;
>  	new->xattri_da_args = args;
>  
> @@ -1650,3 +1651,20 @@ xfs_attr_namecheck(
>  	/* There shouldn't be any nulls here */
>  	return !memchr(name, 0, length);
>  }
> +
> +int __init
> +xfs_attr_intent_init_cache(void)
> +{
> +	xfs_attr_intent_cache = kmem_cache_create("xfs_attr_item",
> +			sizeof(struct xfs_attr_item),
> +			0, 0, NULL);
> +
> +	return xfs_attr_intent_cache != NULL ? 0 : -ENOMEM;
> +}
> +
> +void
> +xfs_attr_intent_destroy_cache(void)
> +{
> +	kmem_cache_destroy(xfs_attr_intent_cache);
> +	xfs_attr_intent_cache = NULL;
> +}
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index c739caa11a4b..cb3b3d270569 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -634,4 +634,8 @@ xfs_attr_init_replace_state(struct xfs_da_args
> *args)
>  	return xfs_attr_init_add_state(args);
>  }
>  
> +extern struct kmem_cache *xfs_attr_intent_cache;
> +int __init xfs_attr_intent_init_cache(void);
> +void xfs_attr_intent_destroy_cache(void);
> +
>  #endif	/* __XFS_ATTR_H__ */
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index ceb222b4f261..ed65f7e5a9c7 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -877,6 +877,9 @@ xfs_defer_init_item_caches(void)
>  	if (error)
>  		goto err;
>  	error = xfs_attrd_init_cache();
> +	if (error)
> +		goto err;
> +	error = xfs_attr_intent_init_cache();
>  	if (error)
>  		goto err;
>  	return 0;
> @@ -889,6 +892,7 @@ xfs_defer_init_item_caches(void)
>  void
>  xfs_defer_destroy_item_caches(void)
>  {
> +	xfs_attr_intent_destroy_cache();
>  	xfs_attri_destroy_cache();
>  	xfs_attrd_destroy_cache();
>  	xfs_extfree_intent_destroy_cache();
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 930366055013..89cabd792b7d 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -404,7 +404,10 @@ xfs_attr_free_item(
>  {
>  	if (attr->xattri_da_state)
>  		xfs_da_state_free(attr->xattri_da_state);
> -	kmem_free(attr);
> +	if (attr->xattri_da_args->op_flags & XFS_DA_OP_RECOVERY)
> +		kmem_free(attr);
> +	else
> +		kmem_cache_free(xfs_attr_intent_cache, attr);
>  }
>  
>  /* Process an attr. */
> 

