Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19AECC48BE6
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 19:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00ADE60FE5
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 19:39:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbhFNTlx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Jun 2021 15:41:53 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:6810 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234280AbhFNTlx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Jun 2021 15:41:53 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15EJWaBs018031;
        Mon, 14 Jun 2021 19:39:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=wmPaGAO4UIdDxYowm0nGq5QozjrF+pVhZxApdKbCwPo=;
 b=tpdpUtU99LejXr07zVh4u2P5alpNDVA7dTBlB3r+ycgDnzJS5GU9qtVCv5eeCOCf2DVD
 PyUOPzI4BPT0qM+P0BkIzMV0SqrTGLJ6i7RwXkavI93hlRrVvgrAXDFYogeKL5eYRIk0
 Q0YEmU/QqcNPR0VRkmkcKGDsuNCVcW3swDYyaFT3ro0TlKbArCnTomrw7/b+8u9k32/C
 EqTbJMQ//wAaUQUW5FyEqQWWUYOYmKAA4ak5urop2h0x2blVNCGroltTBc2x+LbiAWZ4
 qu1SX3vq9dXVXPelk1Ie45NXQAWtihDlVlIXYvfcryiw7X46rRxo1B2H5X5O9U4AFU/O 9Q== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 395t6ugbh3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Jun 2021 19:39:44 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15EJV6UC178627;
        Mon, 14 Jun 2021 19:39:44 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by aserp3020.oracle.com with ESMTP id 394mr76jfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Jun 2021 19:39:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QeRzU8KGp4QOBJoQ9EAQilCd2vQNi/+SMRZLBhWC7L2ZuRHLR5pRhmc34MQHzat0tjDI+ix7ortMO7cfKfJ2SKRuBnX45TjCkqGsFikXuViohHhGUcFnQmMUwBFbnoQTDf7+7PweZNBL6vSzk3oFH/FjOGqi8EwL3Dtcz8j3dkv6VgtBd2LkQxcKl233v8DP7jdF6J2xcB52NWBfQ7yhlGHDalqGG/qqYGYsiNyLDgLUdJx37ICs4jZatudEBAG9rGCphQE6VbgtqvW7l67C+HOKq2fZ8+00pPZwMqCrwQRP3UgfMXuAkbKoypmg7v+200ctilB5xP1H3BvYhAfChQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wmPaGAO4UIdDxYowm0nGq5QozjrF+pVhZxApdKbCwPo=;
 b=mRDmZznQDGBAiZXB1VGTL9qwwSyFCr065mDUMr5Yq/GLokxyR/Ebg5LSHxSG0/TgpWTJy/ENzfHIOWtKZ8dA9LnL8DMqv7pICYJ3hRYhyQ3nVw5nEizh85ffHlkI7gzFoyIKdxCX5TvHVmq3HGW8ILSfT/uOT2NmwQu1rrHw6GHbvhdlo4dIs/Zfgvq1kgDrz8KfCvVpRJffolL700HyEi6+EMTnxp8/uxIpvLSRjGXq9Fm64qDSZ+IFoMKBeFW+pYmIYFIgAC0mhy1WswiR3pBU/UqO+NEKB2+p3YG4XQ+1fwOwhKEZA/kgod33fHcoyqjlmLAQTXiRzn4AgjxcRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wmPaGAO4UIdDxYowm0nGq5QozjrF+pVhZxApdKbCwPo=;
 b=wVoA51OlKTGXj9ETcg46jVpL8vCYBQ5ZCP/1IxjlrmAbm796ItrVmicBdtfhxNVILAvKfuJqcZF+3gv82n6dIuNG2xK6AW/eEJqgZEUvElH636D+mYMK7grteewhZiIvg35jeTZMr6Gm131tYfJxiMI6s/jjk/wzNK/ReXO3qOU=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2568.namprd10.prod.outlook.com (2603:10b6:a02:b1::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Mon, 14 Jun
 2021 19:39:41 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%6]) with mapi id 15.20.4219.025; Mon, 14 Jun 2021
 19:39:41 +0000
Subject: Re: [PATCH 11/13] fstests: remove group files
To:     "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
References: <162317276202.653489.13006238543620278716.stgit@locust>
 <162317282225.653489.1537192803992898300.stgit@locust>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <f246c043-983b-5900-341e-f502708f86b0@oracle.com>
Date:   Mon, 14 Jun 2021 12:39:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <162317282225.653489.1537192803992898300.stgit@locust>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: SJ0PR13CA0079.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::24) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by SJ0PR13CA0079.namprd13.prod.outlook.com (2603:10b6:a03:2c4::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Mon, 14 Jun 2021 19:39:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f66af25-b6b0-47d3-54d4-08d92f6c2705
X-MS-TrafficTypeDiagnostic: BYAPR10MB2568:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2568006CFDE2732B1F41D56395319@BYAPR10MB2568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:153;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L6vZzqwNCFlvx+hQmdve9ep1MeJ4mVGfuhiuTRwsEIG5juZBrtz2L9UzlUUk4Y1pRsr+RqOOV4TeQWq7VU7/lpYnrohyfaKwqdbcVzGDwNEEXAg/uX5sI3b4AAgpp6Xq4sUtQ5P8VDNKMQhR8YAN7FCmJB3BEwlHKGUgM3ZCdSFcEYLesrlqcJOdBgHVFDr9mSQGuEacpnBSW9Q+OHnNtd/dQYtYlssXkh6unmrStJNRmnolDfizo8La6cXSqnlNwu6o7IGp2nLh3jMTK5Lt9BInYYx+Wia735hBwxTWpjoZmoJBrR5pbQ8LLF5IWU9k6JA9uMC1CL87d5rPg96GZCQqWPlyEOTIMSJG9+7caiZ5SEEBXGfpIWICfadkp7rSRDLGsYvGbEwgZDtp4uIeFPVALvPUKXxYVzEwVxeZ0wXTXMId78HcUrB81/9gYYSf8jeTZ0eH9YNe/MdyWibMPe8BeBFAkCk34XK3ZZ215Dj2WzJhUnMXHf4eE1sujV3ys7GhwhvAkWbxAX1CqyuK1z/82C+jZ2V4/Lzht/WEdnWzzdjimsHXziMfcTR5fltWbYj5ZmIrmYD0rfgUN2thM8ySwbiSilJ3tlUgUKWqCq1YbZ3IYBApidlklniMRcmRBFU6nCuNQwmqz6jpKFCynvvFhlBlqOJZf1W2rj6SyKoA41z6JWeGWqRmglmNE25zCwdfveAGtnUJe4geHrGB/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(39860400002)(136003)(376002)(86362001)(36756003)(16576012)(316002)(52116002)(8936002)(478600001)(8676002)(83380400001)(31686004)(66556008)(66476007)(66946007)(30864003)(31696002)(6486002)(4326008)(2906002)(5660300002)(186003)(16526019)(53546011)(956004)(38350700002)(26005)(2616005)(38100700002)(44832011)(43740500002)(45980500001)(559001)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ukc1MzlYS2Y1RUFkWkt2YUd0d3N5eXBzcGhDM05mWVc2SVl4N29UN1RFdi96?=
 =?utf-8?B?RGxldkxaZm5rdzdZWU1lcTlKdmFseVVKT1dacFJSOXdsWmtmVTR0WTNuZG03?=
 =?utf-8?B?RVhDWUNPcjlsczEwa2E3SUtiTmtmY29qWm5OZGNpN3FxTWZ3NWdxS3AyZ1pC?=
 =?utf-8?B?SWlZYUZhVVZkOWtlR2FNQi9Ta014Qkxjd0lhazYyS01ZOVk2WVhhbzlLSWVv?=
 =?utf-8?B?K3YrWkF0c3BhL2RXSzZ6SklvV1dhdklkRXUwWUJabmpkcEZuTzUrK2c3TXJp?=
 =?utf-8?B?dWZSWVgyellhSGdVZ1o2KzR1YXpzSFVQeE5MOUFxM1VrTllxdUpkN3I5Mkxs?=
 =?utf-8?B?dXlsVFZTWkVNWUh4TzVIMUJZdngwT25MYVNsQ0hlQTNxOHJBbDhzWExSRVlq?=
 =?utf-8?B?WEhKdkpXMWdCbGxkazZXa29Pb0ZXeGxWWHpET1RrWExKRjFSeXorME9LZUNa?=
 =?utf-8?B?STZtd2tyUENTMDIzWWE0RDVCVXBOdFFNMVUzbTdJZHNrUllxb1VwbUkvaHRN?=
 =?utf-8?B?TEVYMTZFTUM1OGNMSm9xVVpRRER0RzFZMVFCc1VQYVNQcTVNazR2VlpMNjNp?=
 =?utf-8?B?RkZhaWlScG1Yc0U4T1p3cS9KcE55Tzg0YkZqZmlkRnAwQ1BzZzlQK0dRWWhV?=
 =?utf-8?B?UU5KSDdNN2QxSldNeHl5azFOMDVwV3dOZG5ZRW1xVURIOHlkbUttdnRjQ2FS?=
 =?utf-8?B?L0NjK054SnpDeG0veVR1OWpiWHJaQmVSaEhDeFNHdzk5bXgxMjhEWmJCRHVU?=
 =?utf-8?B?bTdqTjJMYTdXS2dwQW5kWFdIcjExbzlEVGRzUUY0Nk9pU2NKVkQvYUNQd1Ju?=
 =?utf-8?B?M3JLREh4Q2N2c0tDZFM5TUQ3NTdWVWFaSldPSlJBRllsNFVzTXRLRFRONkZ0?=
 =?utf-8?B?NXNNZmtjT3lTY2JyTU5md1lNcE1IbnJuZUFEWUZjYUlORmdVaTZ4MEt6VGMr?=
 =?utf-8?B?MExtRkhya2I5ODc0VnAvazliTnM4YjF3NVVpL2hlcHdMaDBXb2lZbDB6MHUv?=
 =?utf-8?B?eml5UW9MUTkyRjVENjJocXBVRGhrWmpsNjVObStBYnNZcGlMRWFDcDlwVDhS?=
 =?utf-8?B?SkpIOUdEcGo0TUVyeHRkMVNLUEhQRThoZ0hEYkVzMHF5cURJdkxTeGgvZ1R4?=
 =?utf-8?B?bDZNcEdjdlc2TVhJZllnTXdHcGkvWEV5clY4TzNwc0pYbXl4RE82TktQZk5N?=
 =?utf-8?B?U1p6WUg2cTJXZld1NUppSm40Z1RJVVljdUFUYnZqUEV2OEx4Z0w0U3VtRkN3?=
 =?utf-8?B?K0RubHhqY2JhKzMrT1ZDNHRzL2NrUU1PaXZpY0VMeWdFNTFSaGFPWkxsSlYy?=
 =?utf-8?B?b2FFRFpLYVpiVExuRnUwN2hUMmc3cFFUZDBSTXFTNExweTRKN1p5d3QxVElX?=
 =?utf-8?B?ZjMxOUQ0dkhvYy9yeWRsU05qdkprWVFlbVZiZnZQQ1ZZZllWTFN3N21NSEsv?=
 =?utf-8?B?NndmeS9ndkkvY1VvN3hxS1lSZTVjS05CSDd5THJaeHIybzlOcWl6MTZEaEpU?=
 =?utf-8?B?ekM0TTZYS2lOVDNDMkNDR0cwdXdIeXEyb1dvQWQyNEFtaHlTWFk1WTByYktR?=
 =?utf-8?B?SmNOaXkvNFdDWEZQUkw2STdzeVQxeXlnVmYwZys3VXFZNzJlZGxkVDM0bkhn?=
 =?utf-8?B?MlJWdU1rTVRVcU1UMnl3V1BjMWJYbkZrVEZZemhqYk5ncmV0TUpEanNlV1Yz?=
 =?utf-8?B?aE8zNEc1ZVRVbjJxdDlUdXVYNUlNNlJzbkdJZEtIOHFkK1c0dkszQm5pUDVw?=
 =?utf-8?Q?M+XuCbfDBRHlcX8zwh39gewUV3be4oDsOAydfIt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f66af25-b6b0-47d3-54d4-08d92f6c2705
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 19:39:40.9779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WX844ggbBWxbj9cZFzl1PilUFae1pS3JWNunw0X8cABmBnu74Pkvv8PNwU+2otjez8R59YaufbI0tc87wS6uyewbTz008njowuWLJHSjp/o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2568
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10015 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106140123
X-Proofpoint-ORIG-GUID: 8tD7mV32zsep8lFh-UgYeKRuCOleFi6Y
X-Proofpoint-GUID: 8tD7mV32zsep8lFh-UgYeKRuCOleFi6Y
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/8/21 10:20 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we autogenerate group files, get rid of them in the source
> tree.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Looks good
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   tests/btrfs/group   |  245 -------------------
>   tests/ceph/group    |    4
>   tests/cifs/group    |    6
>   tests/ext4/group    |   63 -----
>   tests/f2fs/group    |    7 -
>   tests/generic/group |  643 ---------------------------------------------------
>   tests/nfs/group     |    6
>   tests/ocfs2/group   |    1
>   tests/overlay/group |  100 --------
>   tests/perf/group    |    1
>   tests/shared/group  |    8 -
>   tests/udf/group     |    6
>   tests/xfs/group     |  534 ------------------------------------------
>   13 files changed, 1624 deletions(-)
>   delete mode 100644 tests/btrfs/group
>   delete mode 100644 tests/ceph/group
>   delete mode 100644 tests/cifs/group
>   delete mode 100644 tests/ext4/group
>   delete mode 100644 tests/f2fs/group
>   delete mode 100644 tests/generic/group
>   delete mode 100644 tests/nfs/group
>   delete mode 100644 tests/ocfs2/group
>   delete mode 100644 tests/overlay/group
>   delete mode 100644 tests/perf/group
>   delete mode 100644 tests/shared/group
>   delete mode 100644 tests/udf/group
>   delete mode 100644 tests/xfs/group
> 
> 
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> deleted file mode 100644
> index ad59ed3e..00000000
> --- a/tests/btrfs/group
> +++ /dev/null
> @@ -1,245 +0,0 @@
> -# QA groups control file
> -# Defines test groups and nominal group owners
> -# - do not start group names with a digit
> -# - comment line before each group is "new" description
> -#
> -001 auto quick subvol snapshot
> -002 auto snapshot
> -003 auto replace volume balance
> -004 auto rw metadata
> -005 auto defrag
> -006 auto quick volume
> -007 auto quick rw metadata send seek
> -008 auto quick send
> -009 auto quick subvol
> -010 auto
> -011 auto replace volume
> -012 auto convert
> -013 auto quick balance
> -014 auto balance
> -015 auto quick snapshot
> -016 auto quick send
> -017 auto quick qgroup
> -018 auto quick subvol
> -019 auto quick send
> -020 auto quick replace volume
> -021 auto quick balance defrag
> -022 auto qgroup limit
> -023 auto
> -024 auto quick compress
> -025 auto quick send clone
> -026 auto quick compress prealloc
> -027 auto replace volume
> -028 auto qgroup balance
> -029 auto quick clone
> -030 auto quick send
> -031 auto quick subvol clone
> -032 auto quick remount
> -033 auto quick send snapshot
> -034 auto quick send
> -035 auto quick clone
> -036 auto quick send snapshot
> -037 auto quick compress
> -038 auto quick compress send
> -039 auto quick send
> -040 auto quick send
> -041 auto quick compress
> -042 auto quick qgroup limit
> -043 auto quick send
> -044 auto quick send
> -045 auto quick send
> -046 auto quick send
> -047 auto quick snapshot attr
> -048 auto quick
> -049 auto quick
> -050 auto quick send
> -051 auto quick send
> -052 auto quick clone
> -053 auto quick send
> -054 auto quick send
> -055 auto quick clone
> -056 auto quick clone log
> -057 auto quick
> -058 auto quick send snapshot
> -059 auto quick
> -060 auto balance subvol
> -061 auto balance scrub
> -062 auto balance defrag compress
> -063 auto balance remount compress
> -064 auto balance replace volume
> -065 auto subvol replace volume
> -066 auto subvol scrub
> -067 auto subvol defrag compress
> -068 auto subvol remount compress
> -069 auto replace scrub volume
> -070 auto replace defrag compress volume
> -071 auto replace remount compress volume
> -072 auto scrub defrag compress
> -073 auto scrub remount compress
> -074 auto defrag remount compress
> -075 auto quick subvol
> -076 auto quick compress
> -077 auto quick send snapshot
> -078 auto snapshot
> -079 auto rw metadata
> -080 auto snapshot
> -081 auto quick clone
> -082 auto quick remount
> -083 auto quick send
> -084 auto quick send
> -085 auto quick metadata subvol
> -086 auto quick clone
> -087 auto quick send
> -088 auto quick metadata
> -089 auto quick subvol
> -090 auto quick metadata
> -091 auto quick qgroup
> -092 auto quick send
> -093 auto quick clone
> -094 auto quick send
> -095 auto quick metadata log
> -096 auto quick clone
> -097 auto quick send clone
> -098 auto quick metadata clone log
> -099 auto quick qgroup limit
> -100 auto replace volume eio
> -101 auto replace volume eio
> -102 auto quick metadata enospc balance
> -103 auto quick clone compress
> -104 auto qgroup
> -105 auto quick send
> -106 auto quick clone compress
> -107 auto quick prealloc
> -108 auto quick send clone punch
> -109 auto quick send clone compress
> -110 auto quick send
> -111 auto quick send
> -112 auto quick clone
> -113 auto quick compress clone
> -114 auto qgroup
> -115 auto qgroup
> -116 auto quick metadata
> -117 auto quick send clone
> -118 auto quick snapshot metadata log
> -119 auto quick snapshot metadata qgroup log
> -120 auto quick snapshot metadata log
> -121 auto quick snapshot qgroup
> -122 auto quick snapshot qgroup
> -123 auto quick qgroup balance
> -124 auto replace volume balance
> -125 replace volume balance
> -126 auto quick qgroup limit
> -127 auto quick send
> -128 auto quick send
> -129 auto quick send
> -130 auto quick clone send
> -131 auto quick
> -132 auto enospc
> -133 auto quick send
> -134 auto quick send
> -135 auto quick send
> -136 auto convert
> -137 auto quick send
> -138 auto compress
> -139 auto qgroup limit
> -140 auto quick
> -141 auto quick
> -142 auto quick
> -143 auto quick
> -144 auto quick send
> -145 auto quick send
> -146 auto quick eio
> -147 auto quick send
> -148 auto quick rw
> -149 auto quick send compress
> -150 auto quick dangerous
> -151 auto quick volume
> -152 auto quick metadata qgroup send
> -153 auto quick qgroup limit
> -154 auto quick
> -155 auto quick send
> -156 auto quick trim balance
> -157 auto quick raid
> -158 auto quick raid scrub
> -159 auto quick punch log
> -160 auto quick eio
> -161 auto quick volume seed
> -162 auto quick volume seed
> -163 auto quick volume seed
> -164 auto quick volume
> -165 auto quick subvol
> -166 auto quick qgroup
> -167 auto quick replace volume
> -168 auto quick send
> -169 auto quick send
> -170 auto quick snapshot
> -171 auto quick qgroup
> -172 auto quick log replay
> -173 auto quick swap
> -174 auto quick swap
> -175 auto quick swap volume
> -176 auto quick swap volume
> -177 auto quick swap balance
> -178 auto quick send
> -179 auto qgroup dangerous
> -180 auto quick qgroup limit
> -181 auto quick balance
> -182 auto quick balance
> -183 auto quick clone compress punch
> -184 auto quick volume
> -185 volume
> -186 auto quick send volume
> -187 auto send dedupe clone balance
> -188 auto quick send prealloc punch
> -189 auto quick send clone
> -190 auto quick replay balance qgroup
> -191 auto quick send dedupe
> -192 auto replay snapshot stress
> -193 auto quick qgroup enospc limit
> -194 auto volume
> -195 auto volume balance
> -196 auto metadata log volume
> -197 auto quick volume
> -198 quick volume
> -199 auto quick trim
> -200 auto quick send clone
> -201 auto quick punch log
> -202 auto quick subvol snapshot
> -203 auto quick send clone
> -204 auto quick punch
> -205 auto quick clone compress
> -206 auto quick log replay
> -207 auto rw raid
> -208 auto quick subvol
> -209 auto quick log
> -210 auto quick qgroup snapshot
> -211 auto quick log prealloc
> -212 auto balance dangerous
> -213 auto balance dangerous
> -214 auto quick send snapshot
> -215 auto quick
> -216 auto quick seed
> -217 auto quick trim dangerous
> -218 auto quick volume
> -219 auto quick volume
> -220 auto quick
> -221 auto quick send
> -222 auto quick send
> -223 auto quick replace trim
> -224 auto quick qgroup
> -225 auto quick volume seed
> -226 auto quick rw snapshot clone prealloc punch
> -227 auto quick send
> -228 auto quick volume
> -229 auto quick send clone
> -230 auto quick qgroup limit
> -231 auto quick clone log replay
> -232 auto quick qgroup limit
> -233 auto quick subvolume
> -234 auto quick compress rw
> -235 auto quick send
> -236 auto quick log
> -237 auto quick zone balance
> -238 auto quick seed trim
> -239 auto quick log
> -240 auto quick prealloc log
> diff --git a/tests/ceph/group b/tests/ceph/group
> deleted file mode 100644
> index 47903d21..00000000
> --- a/tests/ceph/group
> +++ /dev/null
> @@ -1,4 +0,0 @@
> -001 auto quick copy
> -002 auto quick copy
> -003 auto quick copy
> -004 auto quick quota
> diff --git a/tests/cifs/group b/tests/cifs/group
> deleted file mode 100644
> index 6d07b1c4..00000000
> --- a/tests/cifs/group
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -# QA groups control file
> -# Defines test groups and nominal group owners
> -# - do not start group names with a digit
> -# - comment line before each group is "new" description
> -#
> -001 auto quick
> diff --git a/tests/ext4/group b/tests/ext4/group
> deleted file mode 100644
> index c246feb8..00000000
> --- a/tests/ext4/group
> +++ /dev/null
> @@ -1,63 +0,0 @@
> -# QA groups control file
> -# Defines test groups and nominal group owners
> -# - do not start group names with a digit
> -# - comment line before each group is "new" description
> -#
> -001 auto prealloc quick zero
> -002 shutdown mount auto quick
> -003 auto quick
> -004 auto dump
> -005 auto quick metadata ioctl rw
> -006 dangerous_fuzzers
> -007 fuzzers
> -008 fuzzers
> -009 fuzzers
> -010 fuzzers
> -011 fuzzers
> -012 fuzzers
> -013 fuzzers
> -014 fuzzers
> -015 fuzzers punch
> -016 fuzzers
> -017 fuzzers
> -018 fuzzers
> -019 fuzzers
> -020 auto quick ioctl rw defrag
> -021 auto quick
> -022 auto quick attr dangerous
> -023 auto quick scrub
> -024 auto quick encrypt dangerous
> -025 auto quick fuzzers dangerous
> -026 auto quick attr
> -027 auto quick fsmap
> -028 auto quick fsmap
> -029 auto quick fsmap
> -030 auto quick dax
> -031 auto quick dax
> -032 auto quick ioctl resize
> -033 auto ioctl resize
> -034 auto quick quota
> -035 auto quick resize
> -036 auto quick
> -037 auto quick
> -038 auto quick
> -039 auto enospc rw
> -040 dangerous_fuzzers
> -041 dangerous_fuzzers
> -042 auto quick
> -043 auto quick
> -044 auto quick
> -045 auto dir
> -046 auto prealloc quick
> -047 auto quick dax
> -048 auto quick dir
> -049 auto quick
> -271 auto rw quick
> -301 aio auto ioctl rw stress defrag
> -302 aio auto ioctl rw stress defrag
> -303 aio auto ioctl rw stress defrag
> -304 aio auto ioctl rw stress defrag
> -305 auto
> -306 auto rw resize quick
> -307 auto ioctl rw defrag
> -308 auto ioctl rw prealloc quick defrag
> diff --git a/tests/f2fs/group b/tests/f2fs/group
> deleted file mode 100644
> index 7cd42fe4..00000000
> --- a/tests/f2fs/group
> +++ /dev/null
> @@ -1,7 +0,0 @@
> -# QA groups control file
> -# Defines test groups and nominal group owners
> -# - do not start group names with a digit
> -# - comment line before each group is "new" description
> -#
> -001 auto quick rw
> -002 auto quick rw encrypt compress
> diff --git a/tests/generic/group b/tests/generic/group
> deleted file mode 100644
> index 9a636b23..00000000
> --- a/tests/generic/group
> +++ /dev/null
> @@ -1,643 +0,0 @@
> -# QA groups control file
> -# Defines test groups and nominal group owners
> -# - do not start group names with a digit
> -# - comment line before each group is "new" description
> -#
> -001 rw dir udf auto quick
> -002 metadata udf auto quick
> -003 atime auto quick
> -004 auto quick
> -005 dir udf auto quick
> -006 dir udf auto quick
> -007 dir udf auto quick
> -008 auto quick prealloc zero
> -009 auto quick prealloc zero
> -010 other udf auto
> -011 dir udf auto quick
> -012 auto quick prealloc punch collapse
> -013 other ioctl udf auto quick
> -014 rw udf auto quick
> -015 other auto quick enospc
> -016 auto quick prealloc punch collapse
> -017 auto prealloc collapse
> -018 auto fsr quick defrag
> -019 aio dangerous enospc rw stress
> -020 metadata attr udf auto quick
> -021 auto quick prealloc punch collapse
> -022 auto quick prealloc punch collapse
> -023 auto quick
> -024 auto quick
> -025 auto quick
> -026 acl quick auto
> -027 auto enospc
> -028 auto quick
> -029 auto quick rw
> -030 auto quick rw
> -031 auto quick prealloc rw collapse
> -032 auto quick rw
> -033 auto quick rw zero
> -034 auto quick metadata log
> -035 auto quick
> -036 auto aio rw stress
> -037 auto quick attr metadata
> -038 auto stress trim
> -039 metadata auto quick log
> -040 metadata auto quick log
> -041 metadata auto quick log
> -042 shutdown rw punch zero
> -043 shutdown metadata log auto
> -044 shutdown metadata log auto
> -045 shutdown metadata log auto
> -046 shutdown metadata log auto
> -047 shutdown metadata rw auto
> -048 shutdown metadata rw auto
> -049 shutdown metadata rw auto
> -050 shutdown mount auto quick
> -051 shutdown auto stress log metadata repair
> -052 shutdown log auto quick
> -053 acl repair auto quick
> -054 shutdown log v2log auto
> -055 shutdown log v2log auto quota stress
> -056 metadata auto quick log
> -057 metadata auto quick log
> -058 auto quick prealloc punch insert
> -059 metadata auto quick punch log
> -060 auto quick prealloc punch insert
> -061 auto quick prealloc punch insert
> -062 attr udf auto quick
> -063 auto quick prealloc punch insert
> -064 auto quick prealloc collapse insert
> -065 metadata auto quick log
> -066 auto quick attr metadata log
> -067 auto quick mount
> -068 other auto freeze stress
> -069 rw udf auto quick
> -070 attr udf auto quick stress
> -071 auto quick prealloc
> -072 auto metadata stress collapse
> -073 metadata auto quick log
> -074 rw udf auto
> -075 rw udf auto quick
> -076 metadata rw udf auto quick stress
> -077 acl attr auto enospc
> -078 auto quick metadata
> -079 auto quick ioctl metadata
> -080 auto quick
> -081 auto quick
> -082 auto quick quota
> -083 rw auto enospc stress
> -084 auto metadata quick
> -085 auto freeze mount
> -086 auto prealloc preallocrw quick
> -087 perms auto quick
> -088 perms auto quick
> -089 metadata auto
> -090 metadata auto quick log
> -091 rw auto quick
> -092 auto quick prealloc
> -093 attr cap auto
> -094 auto quick prealloc
> -095 auto rw stress
> -096 auto prealloc quick zero
> -097 attr auto quick
> -098 auto quick metadata
> -099 acl auto quick
> -100 udf auto
> -101 auto quick metadata log
> -102 auto rw
> -103 auto quick attr enospc
> -104 auto quick metadata log
> -105 acl auto quick
> -106 auto quick metadata log
> -107 auto quick metadata log
> -108 auto quick rw
> -109 auto metadata dir
> -110 auto quick clone
> -111 auto quick clone
> -112 rw aio auto quick
> -113 rw aio auto quick
> -114 rw aio auto quick
> -115 auto quick clone
> -116 auto quick clone
> -117 attr auto quick
> -118 auto quick clone
> -119 auto quick clone
> -120 other atime auto quick
> -121 auto quick clone dedupe
> -122 auto quick clone dedupe
> -123 perms auto quick
> -124 pattern auto quick
> -125 other pnfs
> -126 perms auto quick
> -127 rw auto
> -128 perms auto quick
> -129 rw auto quick
> -130 pattern auto quick
> -131 perms auto quick
> -132 pattern auto
> -133 rw auto
> -134 auto quick clone
> -135 metadata auto quick
> -136 auto quick clone dedupe
> -137 auto clone dedupe
> -138 auto quick clone
> -139 auto quick clone
> -140 auto quick clone
> -141 rw auto quick
> -142 auto quick clone
> -143 auto quick clone
> -144 auto quick clone
> -145 auto quick clone collapse
> -146 auto quick clone punch
> -147 auto quick clone insert
> -148 auto quick clone
> -149 auto quick clone zero
> -150 auto quick clone
> -151 auto quick clone
> -152 auto quick clone punch
> -153 auto quick clone collapse
> -154 auto quick clone
> -155 auto quick clone zero
> -156 auto quick clone
> -157 auto quick clone
> -158 auto quick clone dedupe
> -159 auto quick clone
> -160 auto quick clone dedupe
> -161 auto quick clone
> -162 auto quick clone dedupe
> -163 auto quick clone dedupe
> -164 auto clone
> -165 auto clone
> -166 auto clone
> -167 auto clone
> -168 auto clone
> -169 rw metadata auto quick
> -170 auto clone
> -171 auto quick clone
> -172 auto quick clone
> -173 auto quick clone
> -174 auto quick clone
> -175 auto clone
> -176 auto clone punch
> -177 auto quick prealloc metadata punch log
> -178 auto quick clone punch
> -179 auto quick clone punch
> -180 auto quick clone zero
> -181 auto quick clone
> -182 auto quick clone dedupe
> -183 auto quick clone
> -184 metadata auto quick
> -185 auto quick clone
> -186 auto clone punch
> -187 auto clone punch
> -188 auto quick clone
> -189 auto quick clone
> -190 auto quick clone
> -191 auto quick clone
> -192 atime auto
> -193 metadata auto quick
> -194 auto quick clone
> -195 auto quick clone
> -196 auto quick clone
> -197 auto quick clone
> -198 auto aio quick
> -199 auto quick clone punch
> -200 auto quick clone punch
> -201 auto quick clone
> -202 auto quick clone
> -203 auto quick clone
> -204 metadata rw auto
> -205 auto quick clone
> -206 auto quick clone
> -207 auto aio quick
> -208 auto aio
> -209 auto aio
> -210 auto aio quick
> -211 auto aio quick
> -212 auto aio quick
> -213 rw auto prealloc quick enospc
> -214 rw auto prealloc quick
> -215 auto metadata quick
> -216 auto quick clone
> -217 auto quick clone
> -218 auto quick clone
> -219 auto quota quick
> -220 auto quick clone
> -221 auto metadata quick
> -222 auto quick clone
> -223 auto quick
> -224 auto
> -225 auto quick
> -226 auto enospc
> -227 auto quick clone
> -228 rw auto prealloc quick
> -229 auto quick clone
> -230 auto quota quick
> -231 auto quota
> -232 auto quota stress
> -233 auto quota stress
> -234 auto quota
> -235 auto quota quick
> -236 auto quick metadata
> -237 auto quick acl
> -238 auto quick clone
> -239 auto aio rw
> -240 auto aio quick rw
> -241 auto
> -242 auto clone
> -243 auto clone
> -244 auto quick quota
> -245 auto quick dir
> -246 auto quick rw
> -247 auto quick rw
> -248 auto quick rw
> -249 auto quick rw
> -250 auto quick prealloc rw eio
> -251 ioctl trim
> -252 auto quick prealloc rw eio
> -253 auto quick clone
> -254 auto quick clone punch
> -255 auto quick prealloc punch
> -256 auto quick punch
> -257 dir auto quick
> -258 auto quick bigtime
> -259 auto quick clone zero
> -260 auto quick trim
> -261 auto quick clone collapse
> -262 auto quick clone insert
> -263 rw auto quick
> -264 auto quick clone
> -265 auto quick clone eio
> -266 auto quick clone eio
> -267 auto quick clone eio
> -268 auto quick clone eio
> -269 auto rw prealloc ioctl enospc stress
> -270 auto quota rw prealloc ioctl enospc stress
> -271 auto quick clone eio
> -272 auto quick clone eio
> -273 auto rw
> -274 auto rw prealloc enospc
> -275 auto rw enospc
> -276 auto quick clone eio
> -277 auto ioctl quick metadata
> -278 auto quick clone eio
> -279 auto quick clone eio
> -280 auto quota freeze
> -281 auto quick clone eio
> -282 auto quick clone eio
> -283 auto quick clone eio
> -284 auto quick clone
> -285 auto rw seek
> -286 auto quick other seek
> -287 auto quick clone
> -288 auto quick ioctl trim
> -289 auto quick clone
> -290 auto quick clone
> -291 auto quick clone
> -292 auto quick clone
> -293 auto quick clone
> -294 auto quick
> -295 auto quick clone
> -296 auto quick clone
> -297 auto clone
> -298 auto clone
> -299 auto aio enospc rw stress
> -300 auto aio enospc preallocrw stress punch
> -301 auto quick clone
> -302 auto quick clone
> -303 auto quick clone
> -304 auto quick clone dedupe
> -305 auto quick clone
> -306 auto quick rw
> -307 auto quick acl
> -308 auto quick
> -309 auto quick
> -310 auto
> -311 auto metadata log
> -312 auto quick prealloc enospc
> -313 auto quick
> -314 auto quick
> -315 auto quick rw prealloc
> -316 auto quick punch
> -317 auto metadata quick
> -318 acl attr auto quick
> -319 acl auto quick
> -320 auto rw
> -321 auto quick metadata log
> -322 auto quick metadata log
> -323 auto aio stress
> -324 auto fsr quick defrag
> -325 auto quick data log
> -326 auto quick clone
> -327 auto quick clone
> -328 auto quick clone
> -329 auto quick clone eio
> -330 auto quick clone
> -331 auto quick clone eio
> -332 auto quick clone
> -333 auto clone
> -334 auto clone
> -335 auto quick metadata log
> -336 auto quick metadata log
> -337 auto quick attr metadata
> -338 auto quick rw eio
> -339 auto dir
> -340 auto
> -341 auto quick metadata log
> -342 auto quick metadata log
> -343 auto quick metadata log
> -344 auto
> -345 auto
> -346 auto quick rw
> -347 auto quick rw thin
> -348 auto quick metadata
> -349 blockdev rw zero
> -350 blockdev rw punch
> -351 blockdev rw punch collapse insert zero
> -352 auto clone
> -353 auto quick clone
> -354 auto
> -355 auto quick
> -356 auto quick clone swap
> -357 auto quick clone swap
> -358 auto quick clone
> -359 auto quick clone
> -360 auto quick metadata
> -361 auto quick
> -362 auto quick richacl
> -363 auto quick richacl
> -364 auto quick richacl
> -365 auto quick richacl
> -366 auto quick richacl
> -367 auto quick richacl
> -368 auto quick richacl
> -369 auto quick richacl
> -370 auto quick richacl
> -371 auto quick enospc prealloc
> -372 auto quick clone
> -373 auto quick clone
> -374 auto quick clone dedupe
> -375 auto quick acl
> -376 auto quick metadata log
> -377 attr auto quick metadata
> -378 auto quick metadata
> -379 quota auto quick
> -380 quota auto quick
> -381 auto quick quota
> -382 auto quick quota
> -383 auto quick quota
> -384 quota auto quick
> -385 quota auto quick
> -386 auto quick quota
> -387 auto clone
> -388 shutdown auto log metadata
> -389 auto quick acl
> -390 auto freeze stress
> -391 auto quick rw
> -392 shutdown auto quick metadata punch
> -393 auto quick rw
> -394 auto quick
> -395 auto quick encrypt
> -396 auto quick encrypt
> -397 auto quick encrypt
> -398 auto quick encrypt
> -399 auto encrypt
> -400 auto quick quota
> -401 auto quick
> -402 auto quick rw bigtime
> -403 auto quick attr
> -404 auto quick insert
> -405 auto mkfs thin
> -406 auto quick
> -407 auto quick clone metadata
> -408 auto quick clone dedupe metadata
> -409 auto quick mount
> -410 auto quick mount
> -411 auto quick mount
> -412 auto quick metadata
> -413 auto quick dax
> -414 auto quick clone
> -415 auto clone punch
> -416 auto enospc
> -417 auto quick shutdown log
> -418 auto rw
> -419 auto quick encrypt
> -420 auto quick punch
> -421 auto quick encrypt dangerous
> -422 auto quick
> -423 auto quick
> -424 auto quick
> -425 auto quick attr
> -426 auto quick exportfs
> -427 auto quick aio rw
> -428 auto quick dax
> -429 auto encrypt
> -430 auto quick copy_range
> -431 auto quick copy_range
> -432 auto quick copy_range
> -433 auto quick copy_range
> -434 auto quick copy_range
> -435 auto encrypt
> -436 auto quick rw seek prealloc
> -437 auto quick dax
> -438 auto
> -439 auto quick punch
> -440 auto quick encrypt
> -441 auto quick eio
> -442 blockdev eio
> -443 auto quick rw
> -444 auto quick acl
> -445 auto quick rw seek prealloc
> -446 auto quick rw punch
> -447 auto clone punch
> -448 auto quick rw seek
> -449 auto quick acl attr enospc
> -450 auto quick rw
> -451 auto quick rw aio
> -452 auto quick dax
> -453 auto quick dir
> -454 auto quick attr
> -455 auto log replay
> -456 auto quick metadata collapse zero prealloc
> -457 auto log replay clone
> -458 auto quick clone collapse insert zero
> -459 auto freeze thin
> -460 auto quick rw
> -461 auto shutdown stress
> -462 auto quick dax
> -463 auto quick clone
> -464 auto rw
> -465 auto rw quick aio
> -466 auto quick rw
> -467 auto quick exportfs
> -468 shutdown auto quick metadata
> -469 auto quick punch zero
> -470 auto quick dax
> -471 auto quick rw
> -472 auto quick swap
> -473 broken
> -474 auto quick shutdown metadata
> -475 shutdown auto log metadata eio
> -476 auto rw
> -477 auto quick exportfs
> -478 auto quick
> -479 auto quick metadata log
> -480 auto quick metadata log
> -481 auto quick log metadata
> -482 auto metadata replay thin
> -483 auto quick log metadata
> -484 auto quick
> -485 auto quick insert
> -486 auto quick attr
> -487 auto quick eio
> -488 auto quick
> -489 auto quick attr log
> -490 auto quick rw seek
> -491 auto quick freeze mount
> -492 auto quick
> -493 auto quick swap dedupe
> -494 auto quick swap punch
> -495 auto quick swap
> -496 auto quick swap prealloc
> -497 auto quick swap collapse
> -498 auto quick log
> -499 auto quick rw collapse zero
> -500 auto thin trim
> -501 auto quick clone log
> -502 auto quick log
> -503 auto quick dax punch collapse zero
> -504 auto quick locks
> -505 shutdown auto quick metadata
> -506 shutdown auto quick metadata quota
> -507 shutdown auto quick metadata
> -508 shutdown auto quick metadata
> -509 auto quick log
> -510 auto quick log
> -511 auto quick rw zero
> -512 auto quick log prealloc
> -513 auto quick clone
> -514 auto quick clone
> -515 auto quick clone
> -516 auto quick dedupe clone
> -517 auto quick dedupe clone
> -518 auto quick clone
> -519 auto quick
> -520 auto quick log
> -521 soak long_rw
> -522 soak long_rw
> -523 auto quick attr
> -524 auto quick
> -525 auto quick rw
> -526 auto quick log
> -527 auto quick log
> -528 auto quick
> -529 auto quick acl attr
> -530 auto quick shutdown unlink
> -531 auto quick unlink
> -532 auto quick
> -533 auto quick attr
> -534 auto quick log
> -535 auto quick log
> -536 auto quick rw shutdown
> -537 auto quick trim
> -538 auto quick aio
> -539 auto quick punch seek
> -540 auto quick clone
> -541 auto quick clone
> -542 auto quick clone
> -543 auto quick clone
> -544 auto quick clone
> -545 auto quick cap
> -546 auto quick clone enospc log
> -547 auto quick log
> -548 auto quick encrypt
> -549 auto quick encrypt
> -550 auto quick encrypt
> -551 auto stress aio
> -552 auto quick log
> -553 auto quick copy_range
> -554 auto quick copy_range swap
> -555 auto quick cap
> -556 auto quick casefold
> -557 auto quick log
> -558 auto enospc
> -559 auto stress dedupe
> -560 auto stress dedupe
> -561 auto stress dedupe
> -562 auto clone punch
> -563 auto quick
> -564 auto quick copy_range
> -565 auto quick copy_range
> -566 auto quick quota metadata
> -567 auto quick rw punch
> -568 auto quick rw prealloc
> -569 auto quick rw swap prealloc
> -570 auto quick rw swap
> -571 auto quick
> -572 auto quick verity
> -573 auto quick verity
> -574 auto quick verity
> -575 auto quick verity
> -576 auto quick verity encrypt
> -577 auto quick verity
> -578 auto quick rw clone
> -579 auto stress verity
> -580 auto quick encrypt
> -581 auto quick encrypt
> -582 auto quick encrypt
> -583 auto quick encrypt
> -584 auto quick encrypt
> -585 auto rename
> -586 auto quick rw prealloc
> -587 auto quick rw prealloc quota
> -588 auto quick log clone
> -589 auto mount
> -590 auto prealloc preallocrw
> -591 auto quick rw pipe splice
> -592 auto quick encrypt
> -593 auto quick encrypt
> -594 auto quick quota
> -595 auto quick encrypt
> -596 auto quick
> -597 auto quick perms
> -598 auto quick perms
> -599 auto quick remount shutdown
> -600 auto quick quota
> -601 auto quick quota
> -602 auto quick encrypt
> -603 auto quick quota
> -604 auto quick mount
> -605 auto attr quick dax
> -606 auto attr quick dax
> -607 auto attr quick dax
> -608 auto attr quick dax
> -609 auto quick rw
> -610 auto quick prealloc zero
> -611 auto quick attr
> -612 auto quick clone
> -613 auto quick encrypt
> -614 auto quick rw
> -615 auto rw
> -616 auto rw io_uring stress
> -617 auto rw io_uring stress
> -618 auto quick attr
> -619 auto rw enospc
> -620 auto mount quick
> -621 auto quick encrypt
> -622 auto shutdown metadata atime
> -623 auto quick shutdown
> -624 auto quick verity
> -625 auto quick verity
> -626 auto quick rename enospc
> -627 auto aio rw stress
> -628 auto quick rw clone
> -629 auto quick rw copy_range
> -630 auto quick rw dedupe clone
> -631 auto rw overlay rename
> -632 auto quick mount
> -633 auto quick atime attr cap idmapped io_uring mount perms rw unlink
> -634 auto quick atime bigtime
> -635 auto quick atime bigtime shutdown
> -636 auto quick swap
> -637 auto quick dir
> -638 auto quick rw
> diff --git a/tests/nfs/group b/tests/nfs/group
> deleted file mode 100644
> index 2619eaee..00000000
> --- a/tests/nfs/group
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -# QA groups control file
> -# Defines test groups and nominal group owners
> -# - do not start group names with a digit
> -# - comment line before each group is "new" description
> -#
> -001 auto quick nfs4_acl acl
> diff --git a/tests/ocfs2/group b/tests/ocfs2/group
> deleted file mode 100644
> index 28e68072..00000000
> --- a/tests/ocfs2/group
> +++ /dev/null
> @@ -1 +0,0 @@
> -001 auto quick clone
> diff --git a/tests/overlay/group b/tests/overlay/group
> deleted file mode 100644
> index bd014f20..00000000
> --- a/tests/overlay/group
> +++ /dev/null
> @@ -1,100 +0,0 @@
> -# QA groups control file
> -# Defines test groups and nominal group owners
> -# - do not start group names with a digit
> -# - comment line before each group is "new" description
> -#
> -001 auto quick copyup
> -002 auto quick metadata
> -003 auto quick whiteout
> -004 attr auto copyup quick
> -005 auto copyup quick
> -006 auto quick copyup whiteout
> -007 auto quick
> -008 auto quick whiteout
> -009 auto quick
> -010 auto quick whiteout
> -011 auto quick
> -012 auto quick
> -013 auto quick copyup
> -014 auto quick copyup
> -015 auto quick whiteout
> -016 auto quick copyup
> -017 auto quick copyup redirect
> -018 auto quick copyup hardlink
> -019 auto stress
> -020 auto quick copyup perms
> -021 auto quick copyup
> -022 auto quick mount nested
> -023 auto quick attr
> -024 auto quick mount
> -025 auto quick attr
> -026 auto attr quick
> -027 auto quick perms
> -028 auto copyup quick
> -029 auto quick nested
> -030 auto quick perms
> -031 auto quick whiteout
> -032 auto quick copyup hardlink
> -033 auto quick copyup hardlink
> -034 auto quick copyup hardlink
> -035 auto quick mount
> -036 auto quick mount
> -037 auto quick mount
> -038 auto quick copyup
> -039 auto quick atime
> -040 auto quick
> -041 auto quick copyup nonsamefs
> -042 auto quick copyup hardlink
> -043 auto quick copyup nonsamefs
> -044 auto quick copyup hardlink nonsamefs
> -045 auto quick fsck
> -046 auto quick fsck
> -047 auto quick copyup hardlink
> -048 auto quick copyup hardlink
> -049 auto quick copyup redirect
> -050 auto quick copyup hardlink exportfs
> -051 auto quick copyup hardlink exportfs nonsamefs
> -052 auto quick copyup redirect exportfs
> -053 auto quick copyup redirect exportfs nonsamefs
> -054 auto quick copyup redirect exportfs
> -055 auto quick copyup redirect exportfs nonsamefs
> -056 auto quick fsck
> -057 auto quick redirect
> -058 auto quick exportfs
> -059 auto quick copyup
> -060 auto quick metacopy
> -061 posix copyup
> -062 auto quick exportfs
> -063 auto quick whiteout
> -064 auto quick copyup
> -065 auto quick mount
> -066 auto quick copyup
> -067 auto quick copyup nonsamefs
> -068 auto quick copyup hardlink exportfs nested
> -069 auto quick copyup hardlink exportfs nested nonsamefs
> -070 auto quick copyup redirect nested
> -071 auto quick copyup redirect nested nonsamefs
> -072 auto quick copyup hardlink
> -073 auto quick whiteout
> -074 auto quick exportfs dangerous
> -075 auto quick perms
> -076 auto quick perms dangerous
> -077 auto quick dir
> -100 auto quick union samefs
> -101 auto quick union nonsamefs
> -102 auto quick union nonsamefs xino
> -103 auto union rotate samefs
> -104 auto union rotate nonsamefs
> -105 auto union rotate nonsamefs xino
> -106 auto union rotate nonsamefs
> -107 auto union rotate nonsamefs xino
> -108 auto union rotate nonsamefs
> -109 auto union rotate nonsamefs xino
> -110 auto quick union nested samefs
> -111 auto quick union nested samefs xino
> -112 auto quick union nested nonsamefs
> -113 auto quick union nested nonsamefs xino
> -114 auto union rotate nested samefs
> -115 auto union rotate nested samefs xino
> -116 auto union rotate nested nonsamefs
> -117 auto union rotate nested nonsamefs xino
> diff --git a/tests/perf/group b/tests/perf/group
> deleted file mode 100644
> index d3ed4349..00000000
> --- a/tests/perf/group
> +++ /dev/null
> @@ -1 +0,0 @@
> -001 auto
> diff --git a/tests/shared/group b/tests/shared/group
> deleted file mode 100644
> index a8b926d8..00000000
> --- a/tests/shared/group
> +++ /dev/null
> @@ -1,8 +0,0 @@
> -# QA groups control file
> -# Defines test groups and nominal group owners
> -# - do not start group names with a digit
> -# - comment line before each group is "new" description
> -#
> -002 auto metadata quick log
> -032 mkfs auto quick
> -298 auto trim
> diff --git a/tests/udf/group b/tests/udf/group
> deleted file mode 100644
> index 6680da44..00000000
> --- a/tests/udf/group
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -# QA groups control file
> -# Defines test groups and nominal group owners
> -# - do not start group names with a digit
> -# - comment line before each group is "new" description
> -#
> -102 udf
> diff --git a/tests/xfs/group b/tests/xfs/group
> deleted file mode 100644
> index bed7f7b8..00000000
> --- a/tests/xfs/group
> +++ /dev/null
> @@ -1,534 +0,0 @@
> -001 db auto quick
> -002 auto quick growfs
> -003 db auto quick
> -004 db auto quick
> -005 auto quick
> -006 auto quick mount eio
> -007 auto quota quick
> -008 rw ioctl auto quick
> -009 rw ioctl auto prealloc quick
> -010 auto quick repair
> -011 auto freeze log metadata quick
> -012 rw auto quick
> -013 auto metadata stress
> -014 auto enospc quick quota
> -015 auto enospc growfs
> -016 rw auto quick
> -017 mount auto quick stress
> -018 deprecated # log logprint v2log
> -019 mkfs auto quick
> -020 auto repair
> -021 db attr auto quick
> -022 dump ioctl tape
> -023 dump ioctl tape
> -024 dump ioctl tape
> -025 dump ioctl tape
> -026 dump ioctl auto quick
> -027 dump ioctl auto quick
> -028 dump ioctl auto quick
> -029 mkfs logprint log auto quick
> -030 repair auto quick
> -031 repair mkfs auto quick
> -032 copy auto quick
> -033 repair auto quick
> -034 other auto quick
> -035 dump ioctl tape auto
> -036 dump ioctl remote tape
> -037 dump ioctl remote tape
> -038 dump ioctl remote tape
> -039 dump ioctl remote tape
> -040 other auto
> -041 growfs ioctl auto
> -042 fsr ioctl auto
> -043 dump ioctl tape
> -044 other auto
> -045 other auto quick
> -046 dump ioctl auto quick
> -047 dump ioctl auto
> -048 other auto quick
> -049 rw auto quick
> -050 quota auto quick
> -051 shutdown auto log metadata
> -052 quota db auto quick
> -053 attr acl repair quick auto
> -054 auto quick
> -055 dump ioctl remote tape
> -056 dump ioctl auto quick
> -057 auto log
> -058 auto quick fuzzers
> -059 dump ioctl auto quick
> -060 dump ioctl auto quick
> -061 dump ioctl auto quick
> -062 auto ioctl quick
> -063 dump attr auto quick
> -064 dump auto
> -065 dump auto
> -066 dump ioctl auto quick
> -067 acl attr auto quick
> -068 auto stress dump
> -069 ioctl auto quick
> -070 auto quick repair
> -071 rw auto
> -072 rw auto prealloc quick
> -073 copy auto
> -074 quick auto prealloc rw
> -075 auto quick mount
> -076 auto enospc punch
> -077 auto quick copy
> -078 growfs auto quick
> -079 shutdown auto log quick
> -080 rw ioctl
> -081 deprecated # log logprint quota
> -082 deprecated # log logprint v2log
> -083 dangerous_fuzzers punch
> -084 ioctl rw auto
> -085 fuzzers
> -086 fuzzers
> -087 fuzzers
> -088 fuzzers
> -089 fuzzers
> -090 rw auto realtime
> -091 fuzzers
> -092 other auto quick
> -093 fuzzers
> -094 metadata dir ioctl auto realtime
> -095 log v2log auto
> -096 mkfs v2log auto quick
> -097 fuzzers
> -098 fuzzers
> -099 fuzzers
> -100 fuzzers
> -101 fuzzers
> -102 fuzzers
> -103 metadata dir ioctl auto quick
> -104 growfs ioctl prealloc auto stress
> -105 fuzzers
> -106 auto quick quota
> -107 quota
> -108 quota auto quick
> -109 metadata auto
> -110 repair auto
> -111 ioctl
> -112 fuzzers
> -113 fuzzers
> -114 auto quick clone rmap collapse insert
> -115 auto quick fuzzers
> -116 quota auto quick
> -117 fuzzers
> -118 auto quick fsr
> -119 log v2log auto freeze
> -120 fuzzers
> -121 shutdown log auto quick
> -122 other auto quick clone realtime
> -123 fuzzers
> -124 fuzzers
> -125 fuzzers
> -126 fuzzers
> -127 auto quick clone
> -128 auto quick clone fsr
> -129 auto quick clone
> -130 fuzzers clone
> -131 auto quick clone realtime
> -132 auto quick
> -133 dangerous_fuzzers
> -134 dangerous_fuzzers
> -135 auto logprint quick v2log
> -136 attr2
> -137 auto metadata v2log
> -138 auto quick
> -139 auto quick clone
> -140 auto clone
> -141 auto log metadata
> -142 auto quick rw attr realtime
> -143 auto quick realtime mount
> -144 auto quick quota
> -145 auto quick quota
> -146 auto quick rw realtime
> -147 auto quick rw realtime collapse insert unshare zero prealloc
> -148 auto quick fuzzers
> -149 auto quick growfs
> -150 auto quick db
> -151 auto quick db
> -152 auto quick quota idmapped
> -153 auto quick quota idmapped
> -154 auto quick repair
> -155 auto repair
> -156 auto quick admin
> -157 auto quick admin
> -158 auto quick inobtcount
> -159 auto quick bigtime
> -160 auto quick bigtime
> -161 auto quick bigtime quota
> -162 auto quick attr repair
> -163 auto quick growfs shrinkfs
> -164 rw pattern auto prealloc quick
> -165 rw pattern auto prealloc quick
> -166 rw metadata auto quick
> -167 rw metadata auto stress
> -168 auto growfs shrinkfs ioctl prealloc stress
> -169 auto clone
> -170 rw filestreams auto quick
> -171 rw filestreams
> -172 rw filestreams
> -173 rw filestreams
> -174 rw filestreams auto
> -178 mkfs other auto
> -179 auto quick clone
> -180 auto quick clone
> -181 shutdown log auto quick
> -182 auto quick clone
> -183 rw other auto quick
> -184 auto quick clone
> -186 attr auto quick
> -187 attr auto quick
> -188 ci dir auto
> -189 mount auto quick
> -190 rw auto quick
> -191-input-validation auto quick mkfs realtime
> -192 auto quick clone
> -193 auto quick clone
> -194 rw auto
> -195 ioctl dump auto quick
> -196 auto quick rw
> -197 dir auto quick
> -198 auto quick clone
> -199 mount auto quick
> -200 auto quick clone
> -201 metadata auto quick
> -202 repair auto quick
> -203 ioctl auto
> -204 auto quick clone
> -205 metadata rw auto
> -206 growfs auto quick
> -207 auto quick clone
> -208 auto quick clone
> -209 auto quick clone
> -210 auto quick clone
> -211 clone_stress
> -212 shutdown auto quick clone
> -213 auto quick clone
> -214 auto quick clone
> -215 auto quick clone
> -216 log metadata auto quick
> -217 log metadata auto
> -218 auto quick clone
> -219 auto quick clone
> -220 auto quota quick
> -221 auto quick clone
> -222 auto fsr ioctl quick
> -223 auto quick clone
> -224 auto quick clone
> -225 auto quick clone
> -226 auto quick clone
> -227 auto fsr
> -228 auto quick clone punch
> -229 auto rw
> -230 auto quick clone punch
> -231 auto quick clone
> -232 auto quick clone
> -233 auto quick rmap
> -234 auto quick rmap punch
> -235 fuzzers rmap
> -236 auto rmap punch
> -237 auto quick clone eio
> -238 auto quick metadata ioctl
> -239 auto quick clone
> -240 auto quick clone eio
> -241 auto quick clone
> -242 auto quick prealloc zero
> -243 auto quick clone punch
> -244 auto quota quick
> -245 auto quick clone
> -246 auto quick clone
> -247 auto quick clone
> -248 auto quick clone
> -249 auto quick clone
> -250 auto quick rw prealloc metadata
> -251 auto quick clone
> -252 auto quick prealloc punch
> -253 auto quick
> -254 auto quick clone
> -255 auto quick clone
> -256 auto quick clone
> -257 auto quick clone
> -258 auto quick clone
> -259 auto quick
> -260 auto quick mkfs
> -261 auto quick quota
> -262 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -263 auto quick quota
> -264 auto quick mount eio
> -265 auto clone
> -266 dump ioctl auto quick
> -267 dump ioctl tape
> -268 dump ioctl tape
> -269 auto quick ioctl
> -270 auto quick mount
> -271 auto quick rmap fsmap
> -272 auto quick rmap fsmap
> -273 auto rmap fsmap
> -274 auto quick rmap fsmap
> -275 auto quick rmap fsmap
> -276 auto quick rmap fsmap realtime
> -277 auto quick rmap fsmap
> -278 repair auto
> -279 auto mkfs
> -280 auto quick clone
> -281 dump ioctl auto quick
> -282 dump ioctl auto quick
> -283 dump ioctl auto quick
> -284 auto quick dump copy db mkfs repair
> -285 dangerous_fuzzers dangerous_scrub
> -286 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -287 auto dump quota quick
> -288 auto quick repair fuzzers
> -289 growfs auto quick
> -290 auto rw prealloc quick ioctl zero
> -291 auto repair
> -292 auto mkfs quick
> -293 auto quick
> -294 auto dir metadata
> -295 auto logprint quick
> -296 dump auto quick
> -297 auto freeze
> -298 auto attr symlink quick
> -299 auto quota
> -300 auto fsr
> -301 auto dump
> -302 auto dump
> -303 auto quick quota
> -304 auto quick quota
> -305 auto quota
> -306 auto quick punch
> -307 auto quick clone
> -308 auto quick clone
> -309 auto clone
> -310 auto clone rmap
> -311 auto quick
> -312 auto quick clone
> -313 auto quick clone
> -314 auto quick clone
> -315 auto quick clone
> -316 auto quick clone
> -317 auto quick rmap
> -318 auto quick rw
> -319 auto quick clone
> -320 auto quick clone
> -321 auto quick clone
> -322 auto quick clone
> -323 auto quick clone
> -324 auto quick clone
> -325 auto quick clone
> -326 auto quick clone
> -327 auto quick clone
> -328 auto quick clone fsr
> -329 auto quick clone fsr
> -330 auto quick clone fsr quota
> -331 auto quick rmap clone
> -332 auto quick rmap clone collapse punch insert zero
> -333 auto quick rmap realtime
> -334 auto quick rmap realtime
> -335 auto rmap realtime
> -336 auto rmap realtime
> -337 fuzzers rmap realtime
> -338 auto quick rmap realtime
> -339 auto quick rmap realtime
> -340 auto quick rmap realtime
> -341 auto quick rmap realtime
> -342 auto quick rmap realtime
> -343 auto quick rmap collapse punch insert zero realtime
> -344 auto quick clone
> -345 auto quick clone
> -346 auto quick clone
> -347 auto quick clone
> -348 auto quick fuzzers repair
> -349 dangerous_fuzzers scrub
> -350 dangerous_fuzzers dangerous_scrub dangerous_repair
> -351 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -352 dangerous_fuzzers dangerous_scrub dangerous_repair
> -353 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -354 dangerous_fuzzers dangerous_scrub dangerous_repair
> -355 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -356 dangerous_fuzzers dangerous_scrub dangerous_repair
> -357 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -358 dangerous_fuzzers dangerous_scrub dangerous_repair
> -359 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -360 dangerous_fuzzers dangerous_scrub dangerous_repair
> -361 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -362 dangerous_fuzzers dangerous_scrub dangerous_repair
> -363 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -364 dangerous_fuzzers dangerous_scrub dangerous_repair
> -365 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -366 dangerous_fuzzers dangerous_scrub dangerous_repair
> -367 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -368 dangerous_fuzzers dangerous_scrub dangerous_repair
> -369 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -370 dangerous_fuzzers dangerous_scrub dangerous_repair
> -371 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -372 dangerous_fuzzers dangerous_scrub dangerous_repair
> -373 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -374 dangerous_fuzzers dangerous_scrub dangerous_repair
> -375 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -376 dangerous_fuzzers dangerous_scrub dangerous_repair
> -377 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -378 dangerous_fuzzers dangerous_scrub dangerous_repair
> -379 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -380 dangerous_fuzzers dangerous_scrub dangerous_repair
> -381 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -382 dangerous_fuzzers dangerous_scrub dangerous_repair
> -383 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -384 dangerous_fuzzers dangerous_scrub dangerous_repair
> -385 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -386 dangerous_fuzzers dangerous_scrub dangerous_repair
> -387 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -388 dangerous_fuzzers dangerous_scrub dangerous_repair
> -389 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -390 dangerous_fuzzers dangerous_scrub dangerous_repair
> -391 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -392 dangerous_fuzzers dangerous_scrub dangerous_repair
> -393 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -394 dangerous_fuzzers dangerous_scrub dangerous_repair
> -395 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -396 dangerous_fuzzers dangerous_scrub dangerous_repair
> -397 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -398 dangerous_fuzzers dangerous_scrub dangerous_repair
> -399 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -400 dangerous_fuzzers dangerous_scrub dangerous_repair
> -401 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -402 dangerous_fuzzers dangerous_scrub dangerous_repair
> -403 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -404 dangerous_fuzzers dangerous_scrub dangerous_repair
> -405 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -406 dangerous_fuzzers dangerous_scrub dangerous_repair realtime
> -407 dangerous_fuzzers dangerous_scrub dangerous_online_repair realtime
> -408 dangerous_fuzzers dangerous_scrub dangerous_repair realtime
> -409 dangerous_fuzzers dangerous_scrub dangerous_online_repair realtime
> -410 dangerous_fuzzers dangerous_scrub dangerous_repair
> -411 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -412 dangerous_fuzzers dangerous_scrub dangerous_repair
> -413 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -414 dangerous_fuzzers dangerous_scrub dangerous_repair
> -415 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -416 dangerous_fuzzers dangerous_scrub dangerous_repair
> -417 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -418 dangerous_fuzzers dangerous_scrub dangerous_repair
> -420 auto quick clone punch seek
> -421 auto quick clone punch seek
> -422 dangerous_scrub dangerous_online_repair
> -423 dangerous_scrub
> -424 auto quick db
> -425 dangerous_fuzzers dangerous_scrub dangerous_repair
> -426 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -427 dangerous_fuzzers dangerous_scrub dangerous_repair
> -428 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -429 dangerous_fuzzers dangerous_scrub dangerous_repair
> -430 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -431 auto quick
> -432 auto quick dir metadata
> -433 auto quick attr
> -434 auto quick clone fsr
> -435 auto quick clone
> -436 auto quick clone fsr
> -437 auto quick other
> -438 auto quick quota
> -439 auto quick fuzzers log
> -440 auto quick clone quota
> -441 auto quick clone quota
> -442 auto stress clone quota
> -443 auto quick ioctl fsr punch
> -444 auto quick
> -445 auto quick filestreams
> -446 auto quick
> -447 auto mount
> -448 auto quick fuzzers
> -449 auto quick
> -450 auto quick rmap
> -451 auto quick metadata repair
> -452 auto db
> -453 dangerous_fuzzers dangerous_norepair
> -454 dangerous_fuzzers dangerous_norepair
> -455 dangerous_fuzzers dangerous_norepair
> -456 dangerous_fuzzers dangerous_norepair
> -457 dangerous_fuzzers dangerous_norepair
> -458 dangerous_fuzzers dangerous_norepair
> -459 dangerous_fuzzers dangerous_norepair
> -460 dangerous_fuzzers dangerous_norepair
> -461 dangerous_fuzzers dangerous_norepair
> -462 dangerous_fuzzers dangerous_norepair
> -463 dangerous_fuzzers dangerous_norepair
> -464 dangerous_fuzzers dangerous_norepair
> -465 dangerous_fuzzers dangerous_norepair
> -466 dangerous_fuzzers dangerous_norepair
> -467 dangerous_fuzzers dangerous_norepair
> -468 dangerous_fuzzers dangerous_norepair
> -469 dangerous_fuzzers dangerous_norepair
> -470 dangerous_fuzzers dangerous_norepair
> -471 dangerous_fuzzers dangerous_norepair
> -472 dangerous_fuzzers dangerous_norepair
> -473 dangerous_fuzzers dangerous_norepair
> -474 dangerous_fuzzers dangerous_norepair
> -475 dangerous_fuzzers dangerous_norepair
> -476 dangerous_fuzzers dangerous_norepair
> -477 dangerous_fuzzers dangerous_norepair
> -478 dangerous_fuzzers dangerous_norepair
> -479 dangerous_fuzzers dangerous_norepair
> -480 dangerous_fuzzers dangerous_norepair
> -481 dangerous_fuzzers dangerous_norepair realtime
> -482 dangerous_fuzzers dangerous_norepair realtime
> -483 dangerous_fuzzers dangerous_norepair
> -484 dangerous_fuzzers dangerous_norepair
> -485 dangerous_fuzzers dangerous_norepair
> -486 dangerous_fuzzers dangerous_norepair
> -487 dangerous_fuzzers dangerous_norepair
> -488 dangerous_fuzzers dangerous_norepair
> -489 dangerous_fuzzers dangerous_norepair
> -490 auto quick
> -491 auto quick fuzz
> -492 auto quick fuzz
> -493 auto quick fuzz
> -494 auto quick
> -495 auto quick repair
> -496 dangerous_fuzzers dangerous_scrub dangerous_repair
> -497 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> -498 dangerous_fuzzers dangerous_norepair
> -499 auto quick
> -500 auto quick mkfs prealloc mkfs
> -501 auto quick unlink
> -502 auto quick unlink
> -503 auto copy metadump
> -504 auto quick mkfs label
> -505 auto quick spaceman
> -506 auto quick health
> -507 clone
> -508 auto quick quota
> -509 auto ioctl
> -510 auto ioctl quick
> -511 auto quick quota
> -512 auto quick acl attr
> -513 auto mount
> -514 auto quick db
> -515 auto quick quota
> -516 auto quick
> -517 auto quick fsmap freeze
> -518 auto quick quota
> -519 auto quick reflink
> -520 auto quick reflink
> -521 auto quick realtime growfs
> -522 auto quick mkfs
> -523 auto quick mkfs
> -524 auto quick mkfs
> -525 auto quick mkfs
> -526 auto quick mkfs
> -527 auto quick quota
> -528 auto quick rw realtime
> -529 auto quick quota
> -530 auto quick realtime growfs
> -531 auto quick punch zero insert collapse
> -532 auto quick attr
> -533 auto quick dir hardlink symlink
> -534 auto quick
> -535 auto quick reflink
> -536 auto quick reflink
> -537 auto quick
> -538 auto stress
> -539 auto quick mount
> 
