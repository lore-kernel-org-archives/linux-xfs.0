Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91F59C433E9
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 07:23:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B3482070A
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 07:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbhA0HXx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Jan 2021 02:23:53 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:42488 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S317223AbhA0Akp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jan 2021 19:40:45 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R0dImI020170;
        Wed, 27 Jan 2021 00:39:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=twUX7F7UlRoqLh0uRzHJsoecd3eJUyuEf4FCzHNb6QM=;
 b=GffpkszoRwYoLPeBmMg97ISmcIGLp7EoIdXOirwaFzIrxCdU0dCdku8Ugo47zyaWTogS
 CGCmZ0sWzOWOXD3/736jypNAX5M2wkfdboUZ6dsU9X6QDMlp34NL3xRLFr6mNztNJDSH
 5emJuWY7pfB5dh8LpJMENYRovpDSovbV4wp2DTkqL9oukIfiLCUPbZQZW74ItoWVl2T/
 S/iULcBOIecFQhZ19MqYiZysf0wfbEhuoE7osAXH1E2+B9mpZpkQScws4ytDDLgi6vU7
 hFByro0LEZv09UYJQ96GO+QcpKA8VHSP5IKzokQDhHXxSBJzno+AUU/Dg4IlPgRP6f6/ Jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 3689aamuba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 00:39:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R0L5mM059915;
        Wed, 27 Jan 2021 00:39:18 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3030.oracle.com with ESMTP id 368wcnksn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 00:39:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ayq5Im2yBetrHVEcfeXL3cF54/WXOVYJj+ad2VtWqLhmGs8PAXHZEyK3wmQmDSsHG3eTBvyo94X3wBVFcpMBrCquJxSSnLyihReDiMlRyaWNHY4CRVlvTTELtibP0HSGOLmVwwlBf4F39yZSFbJq7EAQzNPW1XFrjEXkDTJkOmEbWIrKFle72CRBt4pfDGNNpr/vYBZzajyLF7lICDjPnNUTCHQsc39evWc05CiVGx2pyYeqrs0QudHnoYmd3eibLO8iu2YLjESk8+3Nw2ACHfwE30EgoECA3f94C2D1pbWMjVJ3gki9EpyR3pb93kYgruxIxE/7S8Z5QGfVV1FA/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=twUX7F7UlRoqLh0uRzHJsoecd3eJUyuEf4FCzHNb6QM=;
 b=IuhDGVHz9o1IhACZNCGYGZTrfpH0egCY09JAul+6YanW61pywrPrywl0nIzapvgkPAz0RQefmfNLftOs3FrOwI7XM7PxOhDOoK/u0HRyYDXXVfQlVBMjDzF363g7omZM3tJ9lhfVLCYjgMUArQX/jFSVwZ9JcTH6MUUkwlnnmGa9W3FuRow/XEZq+tlq0do2kNAyL7BRLpk+w0fONzWj78TeRyF6m8enzoy7fEDDQSyUa0Isw0tA6wflfffqw4N6sI6OKR7BHvm0Nxc2JWp4gOeGLxohj8b6uAZE7F1nFgVoRYW25sTE/UUREzsB4dMh20a1xTVoPc6s7pY1KRhV6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=twUX7F7UlRoqLh0uRzHJsoecd3eJUyuEf4FCzHNb6QM=;
 b=Gxt4B8sk7HmNNKucOy6SE7ThvqOOrKsE5zoP15z6xQcWyGqMg4Ln5WBfrpSY2WBePcaWr26D55b0mGinuFqgUkVABnIYW7op7FHHfAS4JZMQjVH3MvnJTMdGGFbNtCM9jxq0ewN8Lmu7TnU9VrJYX7PyoAMuW/0e/zoWZjRS/8E=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3921.namprd10.prod.outlook.com (2603:10b6:a03:1ff::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Wed, 27 Jan
 2021 00:39:16 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 00:39:16 +0000
Subject: Re: [PATCH V15 05/16] xfs: Check for extent overflow when removing
 dir entries
To:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, hch@lst.de,
        "Darrick J . Wong" <darrick.wong@oracle.com>
References: <20210126063232.3648053-1-chandanrlinux@gmail.com>
 <20210126063232.3648053-6-chandanrlinux@gmail.com>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <0cdcd847-e4b6-b0cc-d999-39a8f404c3b9@oracle.com>
Date:   Tue, 26 Jan 2021 17:39:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210126063232.3648053-6-chandanrlinux@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.89.149]
X-ClientProxiedBy: BY5PR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::22) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.223] (67.1.89.149) by BY5PR20CA0009.namprd20.prod.outlook.com (2603:10b6:a03:1f4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 00:39:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0bb5ec6b-d79e-4c7c-c6f6-08d8c25bf998
X-MS-TrafficTypeDiagnostic: BY5PR10MB3921:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB39215AB8E61C45CEEE6E205895BB9@BY5PR10MB3921.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lI1ON8CwPelVkY4fQLa6zwL5EHNAx+ZtVN8Lnd/sIxcK0Hr3QDZjw8hWa8fIjMlrZu5U2EpJ/pguOZZcDRFiUjWYT9njCeHdv4X7TfJE+NTDfMb4o/DGke2LUTRvNP4a0xpDhsLuC9pjx44L5rOoJ28/Wh2JEONDVKV6+2oIxeFx0EXYZylbLMUnsj3dnw9OTH7Rjd5QqV5O5NfAhDA3sHKZvCp8X77K5fgHkRIBBOXm+dJm166EEF75XMRTHcONMa65X2CTIwiRPN5PjY2UkbLB2UsYC8GaOtja/qqSV1bAwJbicHAmXI/FJm7mTC826LecBvkW4YBhNclNLuyQ0JF1prz9guI5nJJceXuk6YRDN0WcGyhcWqUTShnbHi6aMIpdtzu9iEnRVPzPRB8NVGfoR1LxmtB7Qz3C46fGx/7fmrAZrZHxmrcQzuRKZ7fE+mrTEK5E4GMsqxbZmHu46Jl5juRO3vYEdCM0yOmmmtc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(366004)(136003)(376002)(8936002)(36756003)(316002)(44832011)(16576012)(66556008)(66946007)(66476007)(86362001)(8676002)(2906002)(478600001)(5660300002)(31686004)(6486002)(4326008)(956004)(26005)(16526019)(186003)(53546011)(2616005)(83380400001)(52116002)(107886003)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: qNRk4It095vvTMkhaZKpr1rdqw4ffDZUKu/XxA0pnL4lnyC7GjZwuFTQ0095WN4iDtPnHu7dLbDog48G5/w7VsbFQR9cdf4wRAIQNMy2/2Js3nYPnGUuZR/AjppkjPzlpNddx20BcvMayVRNHszHFHDi782ohnGi3K57drJ6jaYLSNM+DBZGzGawcHXcWdop2ZUuhQHpZOA+RXdhIt7kdMpjWoU+zJ8uFqIGgIcDeLYnQm8Ru33BZ61rw3udwubFrSyZIdaf1wOJh4e2dAKCXRH8sDEnm8nB/+ANs83QP3m9o/PMhgDbojcT63BfNAoCTjCjcbBD9pi7yU+BznmPFGJ21PL0nVTrarNVcKzWvPSEgKXJSzPrf0tXEzWL/IP8nVYQX5PmyNKuXCIXxmxuKW+wi1eEuTm5zqjDnIdGEIfDMbocyWiPNdTQflMyKj3mbK/FPyfyTrFUdaGvANefnDunAIzCmAeFSODNpOyNX4IepLlyowut3wdjyXbcYGkORbYq4cBXO8UyLuI6N8IkeDp6f4Y0+QFFVpJQmst1aEVDKkJWIM3+IRXfBWb1jKg0NeRoH+4+WAX3Xkr6XmPlzWc8jAW8XzS8ZaEufAnm4ehjRi6fQJCeAValswLQdw8v6jKJp3vQjM1k/G4K/ItahPnLruIgcD7wdR1W9VaHWGXZ64ujILkXW9W8eCRDAxRtmEP/hzSq+THEkx8inoqKLTb1bYuYwt9KvRoTA7iacZw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bb5ec6b-d79e-4c7c-c6f6-08d8c25bf998
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 00:39:16.1253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xq0AhK2GCGvplusXghbIEa811vSJ40OrzoLWgpDSxFsUQCInn5Tz00IRtCAc7voU5CCCfdm9Cye5DTnRNGzwDGYTvWLg/BzxUlv0Khqvg0I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3921
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270000
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1011 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/25/21 11:32 PM, Chandan Babu R wrote:
> Directory entry removal must always succeed; Hence XFS does the
> following during low disk space scenario:
> 1. Data/Free blocks linger until a future remove operation.
> 2. Dabtree blocks would be swapped with the last block in the leaf space
>     and then the new last block will be unmapped.
> 
> This facility is reused during low inode extent count scenario i.e. this
> commit causes xfs_bmap_del_extent_real() to return -ENOSPC error code so
> that the above mentioned behaviour is exercised causing no change to the
> directory's extent count.
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Ok, makes sense.  Thanks for the commentary!
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>   fs/xfs/libxfs/xfs_bmap.c | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 32aeacf6f055..6c8f17a0e247 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5151,6 +5151,24 @@ xfs_bmap_del_extent_real(
>   		/*
>   		 * Deleting the middle of the extent.
>   		 */
> +
> +		/*
> +		 * For directories, -ENOSPC is returned since a directory entry
> +		 * remove operation must not fail due to low extent count
> +		 * availability. -ENOSPC will be handled by higher layers of XFS
> +		 * by letting the corresponding empty Data/Free blocks to linger
> +		 * until a future remove operation. Dabtree blocks would be
> +		 * swapped with the last block in the leaf space and then the
> +		 * new last block will be unmapped.
> +		 */
> +		error = xfs_iext_count_may_overflow(ip, whichfork, 1);
> +		if (error) {
> +			ASSERT(S_ISDIR(VFS_I(ip)->i_mode) &&
> +				whichfork == XFS_DATA_FORK);
> +			error = -ENOSPC;
> +			goto done;
> +		}
> +
>   		old = got;
>   
>   		got.br_blockcount = del->br_startoff - got.br_startoff;
> 
