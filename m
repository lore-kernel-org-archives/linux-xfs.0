Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDA66C433FE
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Sep 2021 14:11:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A91DB6103D
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Sep 2021 14:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235899AbhIKONK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Sep 2021 10:13:10 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:39234 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230249AbhIKONI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Sep 2021 10:13:08 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18BDV8Uo021369;
        Sat, 11 Sep 2021 14:11:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=7ejX7eCDK63kHL2Nl1nrKxP+mEA1F1ersvoKnTbmpCk=;
 b=oyMTWJXHrPLjHGPDh7DLO0LmbECiryzzmat53bP2fDYfVwQCKl2kbdGcvo5GDawKpJNx
 RZct3bNOkdyGw4ElGP2hCRWdy5T+SDmLV83vAGL8EGjvM8arUKWbYsf0mujlZYudoeKG
 2SpZmLeliHKhRt2JUMaUDHnm5JvV/dIIQTAZtM6sIvj7ET+MIJYqOyVSBCQcqZ3ailEN
 nNuyOcdiRIxgoNuVAeZq5G3gRYAAGgikQ2gVXWG/WGwovd+K9crOwudfPeYpq/pH7TjY
 5p/g4W/wD47GTI5TXqiQSrTDdnQE1lFmfKNu7DKCUH5Hw1UJgDPaK8lycL9uFSsmaXtD XQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=7ejX7eCDK63kHL2Nl1nrKxP+mEA1F1ersvoKnTbmpCk=;
 b=t/7kzjelcxlVDPXDkBAGD8UGxDUyrDN8acm28U537XdgzDXVt5iNwHGW0uT2/+b8disP
 Q3j/wvt7klS1epZN05Udv7jebFHBhkFHI8oqf3EB6m5tLvtkM+B7v46nnyX7Vcih2OTx
 6C8G+oLzL1A5lOJ8EK8SfZN80dgx8UQzKBat7fLqS7qy40tjY4jwKvRCUE9ixZ1gW5t/
 Z5aVLQUQVsemLNMOFnFbnT8GE0VDGtdFp0XN62qZTxyZiXlcvySFANmyvJOaaBvt7yZL
 ZuoRK9S9VYKGeV04TR/t87vi35lhnXBdoerySIpcS5dWjbDOeMUl17AGY/CFaR2c7Q7b Hw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b0m2srhjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Sep 2021 14:11:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18BEAC26125774;
        Sat, 11 Sep 2021 14:11:54 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3020.oracle.com with ESMTP id 3b0m932mnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Sep 2021 14:11:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cOhudjChAihdZIdf7/+6H2l0TGpvujD/dvNu2nUUlD4xuUAwipUVWVk599aJ6W8AFL0FchulDaEmPhdeNiwYdZAtkP8rl6NAC6p7XCSCbgYKcVBkLeSWaT/bo0XdktkYVPElvrZ5MLZnSynqj0ztN6Z3NtCofebtkdhfedX2ZdIcKngYF5Y7ZZhLJDb5b958kAj6NqyKua1n+xdQ5qyAn0ZflZ9L7Q6tC+vjbcBeBq5GEOrGjs4qVT2mte9aUQrY5trJDQdrAuKooGpOp2sZypZU0O9c6r62iGgzqRMh12I8TfBSj4qr0iZTQ/cSTSGWSrgggUZYRiS6EK4MDrVBLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=7ejX7eCDK63kHL2Nl1nrKxP+mEA1F1ersvoKnTbmpCk=;
 b=BC36ayG3GjC8BRUm8S/H24DD3Q1jr0zFkrMpWbY0XF+7wVE+mqJ7IBOqy9BMjgJzDhjxk92rWdvCpUwnOzUwOK5rIrGtZpAGnM3u69ItARf4/cueVAaQeiSj8jRZRJDnipnP/Ur0Jk1iWDvSuA6QuCvapFA24typ26BfY7Tv78FxXE0ipsUSgoT9SZ7ABbK2cMY0mKgVHstd57nosERbLw9SeAZkmd49LBjWDyjSczQn2o720pOuuDd0A2hAS+Bx6IuHmvmZwSzQn04hbMWv+AClOdVk26a1HKTgBGOgRBZFskhfJBB22u6vBUm+4NwOxXH8FQ+BXUt8YMStoMnt2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ejX7eCDK63kHL2Nl1nrKxP+mEA1F1ersvoKnTbmpCk=;
 b=VVLrJF5nF98ss1iEFrbH6ExBJjFW89Qhu+kATFfXgHcSQXC5ZYymlHPQV8ybxWhRBDkqii0Vu/zTMLQhMHdT70zSiGr3zsLTsubsK0/jUdTkjVzhYQM76qpm+0Rq4GP/V0gxE3mYes5N+psIyxUDXBiQ9IguBBiRau8qlqVnNp4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4290.namprd10.prod.outlook.com (2603:10b6:a03:203::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Sat, 11 Sep
 2021 14:11:52 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::b054:cb04:7f27:17fd]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::b054:cb04:7f27:17fd%5]) with mapi id 15.20.4500.018; Sat, 11 Sep 2021
 14:11:52 +0000
Subject: Re: [PATCH 3/3] xfstests: Move *_dump_log routines to common/xfs
To:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <20210909174142.357719-1-catherine.hoang@oracle.com>
 <20210909174142.357719-4-catherine.hoang@oracle.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <7abe1f65-ada4-260c-75bd-645b4e1e887e@oracle.com>
Date:   Sat, 11 Sep 2021 07:11:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210909174142.357719-4-catherine.hoang@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0133.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::18) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.243.157) by SJ0PR13CA0133.namprd13.prod.outlook.com (2603:10b6:a03:2c6::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.8 via Frontend Transport; Sat, 11 Sep 2021 14:11:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2c3d0c7-e79e-44c8-6f11-08d9752e1a99
X-MS-TrafficTypeDiagnostic: BY5PR10MB4290:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB42903E999BE34334F1A794FB95D79@BY5PR10MB4290.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YIBAIMet6gEm73/aFXCHV5h2Sp+/h0cbM058077YHSDVNRRvtaxXFIEJjOtnGmPTxCqbsMPcchCcxrybmUSwNs4CN7IQK1SPECT0EphhzF1PdVeVGZKtn7gHMS1bLJuCl3lBKGBYAo6ByBg+xGNJ7X3rCTLOL5f9yYmGp0EErmdzQQxKNVo9vKK7MWubFCzXjm9vKKmDRRXYNeCbYBajrFsWiD57mHvPSSVOyjK+BIA1gLe4yTZeoYQ4FZ8rB3QNxuv/59wy0gSl0qZnafc99dl3D33aM/7Ash03ksAnU6DmPnMaoGCysOJF5jG/VjZHfoXoYYoiOgnmHjz9MU6E+0Z5P5f8SZGjT0N2mePcIOIIw/jhKYeIx5t+M4Czy7aQF3NKYpEAeap+4vlp2AejsCiDzXB2BF8Ndux4ZvY3qtY+jxQtr4g0WiQCL6tJsw2pNercEgFP+kb2OOTTs6FLKiPZyW943KdwgGCGk4DagQFMZegZ16woysegGoK1H5q8uWtMuBDNobCHGmsUE3appFyiVGfP71oxZa1HDqTDSBNOdepvG2JbrGqzA2RaMUKUz5F2AfkqROLbWFEqpltLM5bZtR1ZZ9Q5k3Y87JQ5z2lVl5tT2hA2ptzE3rZnxwgZXLyqKmihdbmRowziapsLIK4BMUskRBipZrQaLf+B4sY7/rsNjD/QxZS6C2B+Pcka40S8ON5ynYVIdJuRxPHCCnv7V9M18vVGrgZWIDvuaDgtQnZEUaKsgw0Nx6a3mv+LD7zHZhWr12GAIE3jutNLSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(366004)(396003)(39860400002)(8676002)(66476007)(316002)(6486002)(38100700002)(26005)(31686004)(450100002)(16576012)(66556008)(31696002)(478600001)(66946007)(8936002)(44832011)(53546011)(83380400001)(956004)(38350700002)(2906002)(86362001)(5660300002)(52116002)(2616005)(36756003)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y012UGFEWmlTcTV1MjdXMGhPeVFBak9tK3hJYVNVTU9YYWE3S1BYVC9nRGJG?=
 =?utf-8?B?NGxzdTF6VVoyOFdYU0lqNGpzYXVtbHJCNnoxei82cXUxTDlLeGxyMXVDampi?=
 =?utf-8?B?cXBFOTg1RlNQUG4xTm5nOTdTODNRSWNDdStyZUFqSUpmUzQ1VUtpVkZHNHBT?=
 =?utf-8?B?R241MkdnQ2p2TzhTU293Z1VlYlhwdmFYQlplSDBjSll0VEdmQ20wZlZWWXNm?=
 =?utf-8?B?OGZueE85WGpmT2JCTXUxVmx4azFnR1NJMXkyUWFobVRMajdodkVsTHBrRXNz?=
 =?utf-8?B?eFJDd29RME83Y3Y5OU1xN0xXVHRFWUFQMU9qMWRGazN1SkdmT3BQMk5zdGVG?=
 =?utf-8?B?enhsaGxtSkJUdm5iY0txTFlSU3ljV1dVYVhZUzNEazJKWU9FR3VxMXhMbENG?=
 =?utf-8?B?L09CckhBNXNlYXRUTG9DK1lyaFEyaHNiaGVuNllnREN5M0pQc2tKSGVWK2xq?=
 =?utf-8?B?U1ljK21MTldLdjM5U3VKdW5SQzZJUzFWbnNRYzdFM1ZmYzV1bGhHQ3ZzTFNG?=
 =?utf-8?B?T09CcWtRUDc4T1lmVTZMRzZQdkFVQnZKSlNMU2o4ZUloQTNsNmZIRGpVOXd3?=
 =?utf-8?B?S3hzdTdaZHFCa0lxYWM1a0hlbkdHWUJqamp6RWd0Zlk5TGZvZGdRMUpZZ2xZ?=
 =?utf-8?B?VjNDSW5sbkJmUXJHSXVNeXAreFlwWW5wSjhXck9qZlVOYUpZZHNrNHZpZHJh?=
 =?utf-8?B?NlBuaFpsY2FMalZSNnZ0RnpGQWZsMWs3YjFFQWtmOXdIbTkvV1gvMWd2MVli?=
 =?utf-8?B?NlZqL0VEam8ybEI2ZkRzWklERmJNdEFjVDU3cGtVU3VuTHF2Y29iY2t1eWRm?=
 =?utf-8?B?UVJtR2FUZ1ZQK2daY3NLVTE4QXlWN29kblh3YUhqcGN5dzBXNzR2SGs3bDhJ?=
 =?utf-8?B?bnkyRmp0YVZVUnJNUnQxajVZZ2xFY0ZhRVNIVDA4Wk9SV0gyaWdlNElLT3cv?=
 =?utf-8?B?VEZqZEl3bmpJRU9mcmlvWm45ZlNwWUZ2aDI2VC9FcXNST29TUk9FamplZlM1?=
 =?utf-8?B?VUNKTXBJR01kaWxXWEpLM0FaT1lYOXlLTjU1bi9aMzlhRlBPcGJJMnJZRXZm?=
 =?utf-8?B?aUVqN1VkcE15aVpRZTFVejR5RWhRWUVJRXdvVStyRTJFVERodzVpQ2xHaWor?=
 =?utf-8?B?M0RLVXU1Mm56YmpnK3BiNDYyKzUvaG5JTmQxRTlsbFQ0NzBMYnVycnF4VnFI?=
 =?utf-8?B?UXVYVVM1VVdHdWkrM0Q3YTM2UkVMKzVMcllwa3ludDIxcjA5TmtqRnBSZWdE?=
 =?utf-8?B?YzJuRjUxZjY4T0hZQUpieFFYZ3dXcDRPWnduU2VKK1I2R0V3TzNDYU1nTlBi?=
 =?utf-8?B?UnBGb3JoNC9EaFlDTk5jb2ozWG53aTl3T2p4RVp0NkQyVTNpWTZRemFrRlV3?=
 =?utf-8?B?T3FSaUI3a0NkNktSeEYyM0lYazJoUkFBbzJTTHNvZjNYVlZhd2xyN3pNOWJo?=
 =?utf-8?B?WE9leW92bFVaZ3FiSTFnNzBycGZ5aUN5SlExMXlJbHQyNVkvWFVXMjZDQWxR?=
 =?utf-8?B?dW1Gdkt3T0ZadzAvZzJRUjlQbk9VOFVSdWxHaTNLbUdEWEcwamQ0alRlMXpS?=
 =?utf-8?B?bnZWSXNBeFRVNFJ6NjlMd3VQN0NHMjdMWERUR0hBQ2MwaDlrWklMRjVLV09F?=
 =?utf-8?B?cXY4WnJ2NTZyWE05b29VMWwwc1A1UHp3T2ZENFpoY1doaGVLR0JQSnA0UGR4?=
 =?utf-8?B?VGFsbHBaWm1ZazlDNmViM1dSeWRDM1daYTNXa2xyMW5GeFlSUllzSFlSV0lG?=
 =?utf-8?Q?oDqqSUw4DLcxlvuo1ywhp7FhaglX+Z09qXC6xVA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2c3d0c7-e79e-44c8-6f11-08d9752e1a99
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2021 14:11:52.5929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H+zbmjChO6UCbLOhaLIZxmfGVxupmI/wRFyacjvML5otfTuFlt0Wb55ny7Av246MxM9vHOkoORwVlXyKbCukkxjD6tfEXvN7qlVDVo1mIdE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4290
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10104 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109110097
X-Proofpoint-GUID: BRAZae_9_KVG8OZW2Ll6_b7DzN-qHPDY
X-Proofpoint-ORIG-GUID: BRAZae_9_KVG8OZW2Ll6_b7DzN-qHPDY
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/9/21 10:41 AM, Catherine Hoang wrote:
> Move _scratch_remount_dump_log and _test_remount_dump_log from
> common/inject to common/xfs. These routines do not inject errors and
> should be placed with other xfs common functions.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>

Looks ok
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   common/inject | 26 --------------------------
>   common/xfs    | 26 ++++++++++++++++++++++++++
>   2 files changed, 26 insertions(+), 26 deletions(-)
> 
> diff --git a/common/inject b/common/inject
> index b5334d4a..6b590804 100644
> --- a/common/inject
> +++ b/common/inject
> @@ -111,29 +111,3 @@ _scratch_inject_error()
>   		_fail "Cannot inject error ${type} value ${value}."
>   	fi
>   }
> -
> -# Unmount and remount the scratch device, dumping the log
> -_scratch_remount_dump_log()
> -{
> -	local opts="$1"
> -
> -	if test -n "$opts"; then
> -		opts="-o $opts"
> -	fi
> -	_scratch_unmount
> -	_scratch_dump_log
> -	_scratch_mount "$opts"
> -}
> -
> -# Unmount and remount the test device, dumping the log
> -_test_remount_dump_log()
> -{
> -	local opts="$1"
> -
> -	if test -n "$opts"; then
> -		opts="-o $opts"
> -	fi
> -	_test_unmount
> -	_test_dump_log
> -	_test_mount "$opts"
> -}
> diff --git a/common/xfs b/common/xfs
> index bfb1bf1e..cda1f768 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1263,3 +1263,29 @@ _require_scratch_xfs_bigtime()
>   		_notrun "bigtime feature not advertised on mount?"
>   	_scratch_unmount
>   }
> +
> +# Unmount and remount the scratch device, dumping the log
> +_scratch_remount_dump_log()
> +{
> +	local opts="$1"
> +
> +	if test -n "$opts"; then
> +		opts="-o $opts"
> +	fi
> +	_scratch_unmount
> +	_scratch_dump_log
> +	_scratch_mount "$opts"
> +}
> +
> +# Unmount and remount the test device, dumping the log
> +_test_remount_dump_log()
> +{
> +	local opts="$1"
> +
> +	if test -n "$opts"; then
> +		opts="-o $opts"
> +	fi
> +	_test_unmount
> +	_test_dump_log
> +	_test_mount "$opts"
> +}
> 
