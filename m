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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C3FEC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 06:20:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E746764EC4
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 06:20:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbhBYGUm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 01:20:42 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:53168 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbhBYGUl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 01:20:41 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11P6Exar059604;
        Thu, 25 Feb 2021 06:19:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=I2xzTP8HvnBUU9PJfzbonJ9fSFWPVzBUtudZujtiKbo=;
 b=g4vYekUAKejQscI2rmTktb/E9lf0yBv7cpLtttSrSnFz1e6+WnZWBWLxJa6S1q/ZZNk/
 +fVmonOYQPG1MgTgqxOmzGaIA/VGPq7uRoiY2hl2xa8SgroJG6qTR0c5nc4sD3kHrwZv
 Qfbh29yhSzBVhwFba68dmMMlYAPU5J/phfj64GgeqLO8q5JETZUvm+/Rmy7VbSQwYqau
 Cnp5vTlJ/EHBN60eAEJCCBU22KAjLzVvhrwF84WpDw9jmZg23pyd1Vfqd1/x/wUBivfk
 zn4sV9vC2pQg8pIA3OP9gyoo1I1sgpISFrTBLqiJ5Ye/iBrm+vcQykD8tIPSpdEPCSgP gg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 36ugq3m6xg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 06:19:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11P6Afhp184248;
        Thu, 25 Feb 2021 06:19:56 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by aserp3020.oracle.com with ESMTP id 36ucb1mv57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 06:19:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NhpvRZyB8pBD1fRA1dyecXUnSQEDPaiXASyIk2ZHnQKVfrDje0vu0gVY2G0aN+IVlJMWbEROOXrbAf595oTrWBN2FCp1rmbfFo4Om7qsVpE6U9tsVYL6svMqmauVAbX1jGwKuq/DBog4rUgDeAqgjWFkH3xp1//spQ70j+zrUVsAxunfPVRP1Ii6kJJX724xPOFdgvF5d4uDnC/QFBjd2UUn3CdB7vM6YRInro1XbnHEcddxk89CVzO2TykzgyUN9LfL1aHoQCP4f+wfkKQQOidu5dmqt0Os61V7QUcs/JR5HoHOi7IqEubTFJGcCh3M8n/eehMaSMz79/ym5lJu8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I2xzTP8HvnBUU9PJfzbonJ9fSFWPVzBUtudZujtiKbo=;
 b=GOPaLQYzkQh0v2TAbrvzTFm0IDPe8kyFm8I/GYCYwE5PT7hkN5J5EN+626WISSvG+lRAaud7xL83lPSQ9jeVSjX/2wXw0fBTMlSbstXUFEt2HvN9JJqRfVWTPHcl//QlWv1w3yg9Lz4uttvZhH/TxcJgpS3PLSNY12HeRsoXBKmJnPDOvt03QYlw+QRY1rvZykhjLzUMpwTucRuxGu5NEOhQvRcGM2bDet9lPb1NVh4UDNsiz12x9r96gC0HfAEg60VyNykMyLDZ7bD+jGBdtz5IrctGyv1x9rSwz3wPyOqdLvm9PM2NbvdAERXU2GsE0IY6GsX3lcg1neQ6f2dgkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I2xzTP8HvnBUU9PJfzbonJ9fSFWPVzBUtudZujtiKbo=;
 b=wFZyFi4J5+vbfsq9olk8FzfPoNUyNJmRgewjmyMgjKpvj6w3uJdtQeNAMhnstvNkdk9e0TpHnT/ihCCoQyqFjk+HFKibD6iPlK3Llw2UUUz47C9PslP7w52M5hWbPVtbm5nVBvMesWd7EnoAGpkO/HMmmTD6fF99FOE1eL464kA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4510.namprd10.prod.outlook.com (2603:10b6:a03:2d6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.16; Thu, 25 Feb
 2021 06:19:54 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.019; Thu, 25 Feb 2021
 06:19:54 +0000
Subject: Re: [PATCH v15 08/22] xfs: Hoist xfs_attr_node_addname
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-9-allison.henderson@oracle.com>
 <20210224184254.GJ981777@bfoster>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <7b649822-d418-fa17-7d44-860dac9c1a3c@oracle.com>
Date:   Wed, 24 Feb 2021 23:19:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210224184254.GJ981777@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0258.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::23) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR03CA0258.namprd03.prod.outlook.com (2603:10b6:a03:3a0::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20 via Frontend Transport; Thu, 25 Feb 2021 06:19:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4fbac18-04b8-4e61-ea27-08d8d9555dee
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4510:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4510BDA154CAA3646408F391959E9@SJ0PR10MB4510.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Kuxx/upnXPX2e6ViSnbSb+fW4L7bQemOEdf+/+KKqEYv1C6yzf3ZHOIyZ93y9SNoySQJLZcUTnNsSn9Je3ofA9BvdueEXSciBeZCuL6nFjMHI7ubuXJtSaaj7GzNKIceh0Aeux7lRqiDKuJyCXQQaA1V6jtReGobbmimVZL/5wAW3s8Ud9rO/I9WtqKSti0IzxgdFCaCtbz1n004Hg9rfHpwQGt0IdZzIqcD4VH2mE4VOFBECnUC45bEDu7MBAkkqAKosC+RzBiB4cZP4DpS3gWMEuMpW8pSpiuLq8vjfI9jAg4nJA4lhoa0Se3z1GEtsVhFLj+dvfazvX0JbvtwwpkUex0bMFezWto70WbiOC+Lq+h5pRgRIJSzpPcD6Yj+YZ6E2Z2UKhvWRKqVNiR2ZB7D7KDgkUbWbSlHXgTxQWA8N9NyUEotCNEWTW5zryLtRYlM2z7XyaPEjHEjq8hx9j4OGp5LGNHebOYJI+Wb6aPjkcoPIsarMf1v7oaO3sH0qLX5UQTX9Ee14/r7cuDOxgrizCLbUkR2oEuZjTqbrQwPTKaOmHq0FToL7zXS6LNU5jEAbZ8pBx80Q4M7TkiBKg5qd8UQfvJgvypHrYQpIM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(136003)(346002)(366004)(39860400002)(26005)(66476007)(6916009)(52116002)(8676002)(66556008)(2616005)(478600001)(16576012)(83380400001)(86362001)(2906002)(186003)(6486002)(5660300002)(36756003)(4326008)(16526019)(31686004)(66946007)(31696002)(44832011)(8936002)(316002)(53546011)(956004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UUtiM0gyZ2VJcDFlWmxVOW5uRlk5STU0eDAxK2ZqL05JcjdCT2RJVVJFMEwz?=
 =?utf-8?B?TDI1dkgvUG8rbWhTWUhBdkF2VWhWS1VENVlGbDBmMWptVmQ3dmpscGFvQ3VO?=
 =?utf-8?B?M3BxWmphQ0ZxTVVYK3RMNXEyTmIrZ1Zqb1h3RDAwN3lnSy9XaVZqVUZFaVho?=
 =?utf-8?B?VVE0WUNzM3dlR2lIcGp5RUFUVmJYT0xDQm5Zcnk0a0FnbW5EK0ZiN1dyaXk3?=
 =?utf-8?B?eGRnRnpIVkZadDEyV0QvVEtBNFpRY0dzSGh1RFoyUEVkTnVKQnN3NGI0NWZ6?=
 =?utf-8?B?alBNRDZsQyttQjhZNHYwRHFlRklIUGUrWis5QVFLR1FJS2QxRnNCdU02UGs3?=
 =?utf-8?B?enB5bVltMTZEa1M0cS82SnhqaUtMTkhqZzlJajhGVGZibzJnK1ZFQ3NVMmlY?=
 =?utf-8?B?WHFvbXdzd21hTGoxRTFIVk9xVWNlZGF5VU5sV00zUFN3R3ljbGVQcmhweDhL?=
 =?utf-8?B?SmRxYzVpeGhGb0t5aG5kWXdOMVh5SlZNNk5uSFd0SUNnTlpreldUbnVSNzNV?=
 =?utf-8?B?RW9vd2dtaUl1dVVBd0tJNVgwYkhUNHBCZDloQWd0UWpOdFB3MnZWbFBPREhG?=
 =?utf-8?B?UWVsa0VvV3RYTit6TFRoalNqNGpmenhZVXlnaHJ5T3VWUHR6czhwVDNnNy9x?=
 =?utf-8?B?eU55elRZS2xKSk5KQUtoUm8rSzQyYkFYbUxHSXFVcEJZZy9XbVVWeFRXYWdY?=
 =?utf-8?B?anJCelhkMThIdGpjQXBucXVmOEVzbVk3NU9iYlFpeXoxSUFXV1VTalUzYkVX?=
 =?utf-8?B?bFdLS0lWQzVjRlV2N3RaYmN3bEVlQXova2xxemN1MWRHOUxLVzBIWDZ4TnBM?=
 =?utf-8?B?c2tXUmxTYzlrSklvM3ZJdUl4eGxyMllsY1VhUmUrLzIwd2hVc1lGSVpPK1Jj?=
 =?utf-8?B?Lzg1b1ViODhNc3Urem4zUjJ3UmRhdldQa2VtbzBERlhyWGFKSCtSejZBTTNS?=
 =?utf-8?B?ODBBR2VKdG5JQnFqVUw5Y094QW5zY3RXWHNtSFJtcHJNaU5IaWxqNVE1SndZ?=
 =?utf-8?B?NFNKK1JjY2pFUysvZHUxMkxmZmtTWXZCVkJDd1dOdExTK0lELzRGVDlvTWRh?=
 =?utf-8?B?b01zNHhWT0NuZnpsWUVxMEZlb3NKSnl5bnhZQnV1SHJ4eU9TU2Uya1IyTlJN?=
 =?utf-8?B?d29jc0l3d0kzbHBwd2ErV2lNYWxEOXBnUmxhblZwbjlzNlZITUMrVDF4Y0Na?=
 =?utf-8?B?OHdweDhiWlVma2J1ZU5wZlAxYzNJNVJuZkZBMDBTTmhBNzkraWFHVlBZYmFy?=
 =?utf-8?B?RU9MVUp3S1czbXRtcGVRdnUxMDJXNXpDZXptc1FQdytUSm9Nc1NGRXAyOVdz?=
 =?utf-8?B?R2ZRcGRFRk1oRnQ4cHJtelpVS0hPdkZDcDNITlpvZldiSGRCZFFGZFpvRU1X?=
 =?utf-8?B?blJ2NUNGcUFoUEw2cDFJNjE1QmZ5Zjh6MHJuQThiZTd0bWIwdGZ1K1hFNWlj?=
 =?utf-8?B?WU9iNzN1NG1McW9EM1ZOUjZkd3k4WDJQMTdFUm1URHVoSUZqQkk1TmZVSksr?=
 =?utf-8?B?TFk4dklmS09TQUcwTEh1c0dDK1czTkxMSHRQN1ZSZkFaZ2tvRkZGdHJ3dFNv?=
 =?utf-8?B?TVEyZXAzOEdHZlpmZXh0ZmZVU0JCWU43ei9CV05QMklxTDVKTW5hWDR0UHBo?=
 =?utf-8?B?RHZtWExncWROdi9Gb2p5d29NRnlDc1grNHNvUnpNUHYwbW8yQ1EwK0Y0TEVH?=
 =?utf-8?B?S1llcWJNUmFvbUZac2U0MTBXNVhLbUE1NXl4RTJIVEk1Z3BXcXpvaWxLZnBk?=
 =?utf-8?Q?euavs4WxMHndyS6bnKtojBHl0CI12mZ2qRPoFBV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4fbac18-04b8-4e61-ea27-08d8d9555dee
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2021 06:19:54.5526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y5LwnI71a4bzInVvnk7h4wSS3gp6ON9zvHnsEfOVO1O0JGfnQjxMEDnWirxPDKuE3paWxpXhafe2RxoGaJUuexVs/LSszSeSXOOtJ4P/CSI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4510
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250054
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250054
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/24/21 11:42 AM, Brian Foster wrote:
> On Thu, Feb 18, 2021 at 09:53:34AM -0700, Allison Henderson wrote:
>> This patch hoists the later half of xfs_attr_node_addname into
>> the calling function.  We do this because it is this area that
>> will need the most state management, and we want to keep such
>> code in the same scope as much as possible
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 165 ++++++++++++++++++++++++-----------------------
>>   1 file changed, 83 insertions(+), 82 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 4333b61..19a532a 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
> ...
>> @@ -320,8 +322,82 @@ xfs_attr_set_args(
>>   			return error;
>>   		error = xfs_attr_node_addname(args, state);
>>   	} while (error == -EAGAIN);
>> +	if (error)
>> +		return error;
>> +
>> +	/*
>> +	 * Commit the leaf addition or btree split and start the next
>> +	 * trans in the chain.
>> +	 */
>> +	error = xfs_trans_roll_inode(&args->trans, dp);
>> +	if (error)
>> +		goto out;
>> +
>> +	/*
>> +	 * If there was an out-of-line value, allocate the blocks we
>> +	 * identified for its storage and copy the value.  This is done
>> +	 * after we create the attribute so that we don't overflow the
>> +	 * maximum size of a transaction and/or hit a deadlock.
>> +	 */
>> +	if (args->rmtblkno > 0) {
>> +		error = xfs_attr_rmtval_set(args);
>> +		if (error)
>> +			return error;
>> +	}
>> +
>> +	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
>> +		/*
>> +		 * Added a "remote" value, just clear the incomplete flag.
>> +		 */
>> +		if (args->rmtblkno > 0)
>> +			error = xfs_attr3_leaf_clearflag(args);
>> +		retval = error;
> 
> It looks like this is the only use of retval. Otherwise this function is
> getting a bit big, but the factoring LGTM:
Ok, will clean out.
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
Thank you!
Allison
> 
>> +		goto out;
>> +	}
>> +
>> +	/*
>> +	 * If this is an atomic rename operation, we must "flip" the incomplete
>> +	 * flags on the "new" and "old" attribute/value pairs so that one
>> +	 * disappears and one appears atomically.  Then we must remove the "old"
>> +	 * attribute/value pair.
>> +	 *
>> +	 * In a separate transaction, set the incomplete flag on the "old" attr
>> +	 * and clear the incomplete flag on the "new" attr.
>> +	 */
>> +	error = xfs_attr3_leaf_flipflags(args);
>> +	if (error)
>> +		goto out;
>> +	/*
>> +	 * Commit the flag value change and start the next trans in series
>> +	 */
>> +	error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +	if (error)
>> +		goto out;
>> +
>> +	/*
>> +	 * Dismantle the "old" attribute/value pair by removing a "remote" value
>> +	 * (if it exists).
>> +	 */
>> +	xfs_attr_restore_rmt_blk(args);
>> +
>> +	if (args->rmtblkno) {
>> +		error = xfs_attr_rmtval_invalidate(args);
>> +		if (error)
>> +			return error;
>> +
>> +		error = xfs_attr_rmtval_remove(args);
>> +		if (error)
>> +			return error;
>> +	}
>> +
>> +	error = xfs_attr_node_addname_work(args);
>> +out:
>> +	if (state)
>> +		xfs_da_state_free(state);
>> +	if (error)
>> +		return error;
>> +	return retval;
>>   
>> -	return error;
>>   }
>>   
>>   /*
>> @@ -955,7 +1031,7 @@ xfs_attr_node_addname(
>>   {
>>   	struct xfs_da_state_blk	*blk;
>>   	struct xfs_inode	*dp;
>> -	int			retval, error;
>> +	int			error;
>>   
>>   	trace_xfs_attr_node_addname(args);
>>   
>> @@ -963,8 +1039,8 @@ xfs_attr_node_addname(
>>   	blk = &state->path.blk[state->path.active-1];
>>   	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>>   
>> -	retval = xfs_attr3_leaf_add(blk->bp, state->args);
>> -	if (retval == -ENOSPC) {
>> +	error = xfs_attr3_leaf_add(blk->bp, state->args);
>> +	if (error == -ENOSPC) {
>>   		if (state->path.active == 1) {
>>   			/*
>>   			 * Its really a single leaf node, but it had
>> @@ -1010,85 +1086,10 @@ xfs_attr_node_addname(
>>   		xfs_da3_fixhashpath(state, &state->path);
>>   	}
>>   
>> -	/*
>> -	 * Kill the state structure, we're done with it and need to
>> -	 * allow the buffers to come back later.
>> -	 */
>> -	xfs_da_state_free(state);
>> -	state = NULL;
>> -
>> -	/*
>> -	 * Commit the leaf addition or btree split and start the next
>> -	 * trans in the chain.
>> -	 */
>> -	error = xfs_trans_roll_inode(&args->trans, dp);
>> -	if (error)
>> -		goto out;
>> -
>> -	/*
>> -	 * If there was an out-of-line value, allocate the blocks we
>> -	 * identified for its storage and copy the value.  This is done
>> -	 * after we create the attribute so that we don't overflow the
>> -	 * maximum size of a transaction and/or hit a deadlock.
>> -	 */
>> -	if (args->rmtblkno > 0) {
>> -		error = xfs_attr_rmtval_set(args);
>> -		if (error)
>> -			return error;
>> -	}
>> -
>> -	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
>> -		/*
>> -		 * Added a "remote" value, just clear the incomplete flag.
>> -		 */
>> -		if (args->rmtblkno > 0)
>> -			error = xfs_attr3_leaf_clearflag(args);
>> -		retval = error;
>> -		goto out;
>> -	}
>> -
>> -	/*
>> -	 * If this is an atomic rename operation, we must "flip" the incomplete
>> -	 * flags on the "new" and "old" attribute/value pairs so that one
>> -	 * disappears and one appears atomically.  Then we must remove the "old"
>> -	 * attribute/value pair.
>> -	 *
>> -	 * In a separate transaction, set the incomplete flag on the "old" attr
>> -	 * and clear the incomplete flag on the "new" attr.
>> -	 */
>> -	error = xfs_attr3_leaf_flipflags(args);
>> -	if (error)
>> -		goto out;
>> -	/*
>> -	 * Commit the flag value change and start the next trans in series
>> -	 */
>> -	error = xfs_trans_roll_inode(&args->trans, args->dp);
>> -	if (error)
>> -		goto out;
>> -
>> -	/*
>> -	 * Dismantle the "old" attribute/value pair by removing a "remote" value
>> -	 * (if it exists).
>> -	 */
>> -	xfs_attr_restore_rmt_blk(args);
>> -
>> -	if (args->rmtblkno) {
>> -		error = xfs_attr_rmtval_invalidate(args);
>> -		if (error)
>> -			return error;
>> -
>> -		error = xfs_attr_rmtval_remove(args);
>> -		if (error)
>> -			return error;
>> -	}
>> -
>> -	error = xfs_attr_node_addname_work(args);
>>   out:
>>   	if (state)
>>   		xfs_da_state_free(state);
>> -	if (error)
>> -		return error;
>> -	return retval;
>> +	return error;
>>   }
>>   
>>   
>> -- 
>> 2.7.4
>>
> 
