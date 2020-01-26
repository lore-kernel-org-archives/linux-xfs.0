Return-Path: <SRS0=svvY=3P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F40C35240
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 04:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCE1220720
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 04:04:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Gtspzzx7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbgAZEEN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Jan 2020 23:04:13 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:47630 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728842AbgAZEEN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Jan 2020 23:04:13 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00Q43r9u164566;
        Sun, 26 Jan 2020 04:04:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=jU8o28AXuXwejKoTW3jXzh+ey4owYS+r8sBCdpFdra8=;
 b=Gtspzzx7VnWe+lCbxMMr9zzlt1cMMJEJsw8h8Yuk0HKBhd7aUwSezkYVF7fsTLBlOydv
 KXiqD/jqgUUYhzD4H/BYEGbyW/8ArfanLHSaF0GiiWp27YFgwM9pd6XAaj0OStWT9qwn
 zdrOgknwwf9LnJHs50AHKKXWwFEXLkank/qfcUYNJN8KOuXkopVcDSI1/nb4gdZITqNy
 5h4vJmXiAKbx5zAMzKyMPuzw+JJUSL40iSFA4G4U9iPo43+o/C8LtG5R7w0vfC52brYM
 KLkxbvtzGAZaodkj++s7NA//KoE9L9nf4xM0PNYfYWBTA/wk7COZQaUsIML99pl65fdg sg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xreaqtfv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jan 2020 04:04:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00Q43nLI109762;
        Sun, 26 Jan 2020 04:03:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xry6fumnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jan 2020 04:03:59 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00Q43wA8007240;
        Sun, 26 Jan 2020 04:03:58 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 25 Jan 2020 20:03:58 -0800
Subject: Re: [PATCH v5 04/14] xfs: Add xfs_has_attr and subroutines
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-5-allison.henderson@oracle.com>
 <20191224121830.GD18379@infradead.org>
 <2b29c0a0-03bb-8a21-8a8a-fd4754bff3ff@oracle.com>
 <20200121223059.GG8247@magnolia>
 <6f955cc1-8739-7c00-0dcb-0b9e4a912380@oracle.com>
 <32b91246-a6c0-a8c1-a50d-8a11cc30674a@oracle.com>
 <20200125230841.GA15222@infradead.org>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <07c7cd1d-b771-716b-4914-57981d8bdf89@oracle.com>
Date:   Sat, 25 Jan 2020 21:03:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200125230841.GA15222@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9511 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=970
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001260033
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9511 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001260033
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/25/20 4:08 PM, Christoph Hellwig wrote:
> On Sat, Jan 25, 2020 at 09:27:39AM -0700, Allison Collins wrote:
>> I was thinking of adapting this patch to be part of a 3 patch series
>> including one of Chistophs.  Something like this:
>>
>> [PATCH v6 11/16] xfs: Check for -ENOATTR or -EEXIST
>> [PATCH v6 03/16] xfs: Add xfs_has_attr and subroutines
>> [PATCH 02/29] xfs: merge xfs_attr_remove into xfs_attr_set
>>
>> What would people think of that?  I figured this would be better than the
>> two of us bombarding the mailing list with giant conflicting sets? Also, was
>> I able to answer everyones questions on this patch?
> 
> I'm still not sold at all on this series.  It adds a lot of code and
> makes it much harder to understand.  So I'd much rather go back and
> figuring out how we can do delayed attrs in a more streamlined way.

I had something like that quite a long time ago.  Instead of the EAGAIN 
ping pong, we had a boolean that just sort of turned the transactions 
off in the delayed attrs path:

https://www.spinics.net/lists/linux-xfs/msg18114.html

The trouble with this is that it creates one large transaction rather 
than breaking them up.  So while the new method is a lot more complex, 
it seemed to be the direction folks preferred.

> The has_attr and co changes are some of exactly that kind of logic
> that is just making things worse in the standalone patch set, so even
> if we must end up with it they absolutely belong into a series actually
> adding functionality, as they have no use on their own. >
Well, in an earlier discussion though we had come together with a plan 
of implementing the new feature through a series of sub sets.  First of 
which being pure refactor with no functional change.

https://www.spinics.net/lists/linux-xfs/msg32035.html

I do try to keep the extended set up to date though.  Mostly for my own 
sanity and to make sure things are still on track for the long term 
goals we are aiming for.

> Independent of that we'll need to clean up the flags mess, so I'd rather
> just go ahead with that for now.
> 
