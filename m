Return-Path: <SRS0=vweQ=2R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E51CC2D0C0
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Dec 2019 03:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5014820409
	for <linux-xfs@archiver.kernel.org>; Fri, 27 Dec 2019 03:23:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jdMa5Jer"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbfL0DXh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Dec 2019 22:23:37 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37150 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbfL0DXh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Dec 2019 22:23:37 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBR3EPHb151470;
        Fri, 27 Dec 2019 03:23:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=6LJUy4Q+8gKFU+yri1sQNvg08rLYlVKdRCqw4iiHiSI=;
 b=jdMa5JerstBL/8O0fOcjYsJCvudiKmbp56W+nXm2uHgLbyKp26kgV/JuL9XPU5EWQ7D0
 tzlFR3AlBASX0Co3yYGQ7v1Q4M8+lAIhmbqSZoR712GVeht9DRPBP5vgvtTQDvJFTCyD
 VyTz+xYuLQV5jkzNKh6MKDWBsyfFCFn2m2cAH3GoH7Zqw2+BN9zk2+0/01pqknR37Akz
 hnDyegpbBagzz3Tsm+O/B8BQeY6DywaftGByta7rtvnSvbdHgMudWriQv+mQ0/QxHzSg
 MWqaPzb/VsE8uL7neo6+v2WYBX5rZ/jJqhVwqxRl/QdUzYEkvMtGTHYHRsfPjpxF8gt7 oA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2x1bbq3vhn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Dec 2019 03:23:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBR3EOUe125329;
        Fri, 27 Dec 2019 03:23:27 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2x4t4024nc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Dec 2019 03:23:27 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBR3NLnK014328;
        Fri, 27 Dec 2019 03:23:22 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Dec 2019 19:23:21 -0800
Subject: Re: [PATCH v5 08/14] xfs: Factor up xfs_attr_try_sf_addname
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-9-allison.henderson@oracle.com>
 <20191224122554.GF18379@infradead.org>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <7034cafb-db76-23ee-f783-2214a59f5148@oracle.com>
Date:   Thu, 26 Dec 2019 20:23:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191224122554.GF18379@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9482 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912270023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9482 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912270023
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 12/24/19 5:25 AM, Christoph Hellwig wrote:
> On Wed, Dec 11, 2019 at 09:15:07PM -0700, Allison Collins wrote:
>> New delayed attribute routines cannot handle transactions. We
>> can factor up the commit, but there is little left in this
>> function other than some error handling and an ichgtime. So
>> hoist all of xfs_attr_try_sf_addname up at this time.  We will
>> remove all the commits in this set.
> 
> I really don't like this one.  xfs_attr_try_sf_addname is a nice
> abstration, so merging it into the caller makes the code much harder
> to understand.  If that is different after changes to the transaction
> change it can be removed at that point, but merging all the different
> attr formats into one big monster function is a bad idea.
Well, in the last version of the set, I did keep it around, but it was 
so small, Darrick suggested cleaning it out all together.  Here is the 
same patch in the last set:

https://patchwork.kernel.org/patch/11231511/

Maybe when more folks get back from break they can chime in about 
keeping it or not.  I think I commented pretty well on "monster 
function" in the last patch.  It is in all in the pursuit of pulling 
things up and then breaking them back down again.

> 
> Also Factor up still sounds very, very strange to me.  I would
> have worded it as "merge xfs_attr_try_sf_addname into its only caller"
> 
I always assumed it to be a figure of speech in reference to factoring 
out common code, sort of like how one might factor out a common 
denominator or common multiple from an algebraic expression. If it 
really bothers folks though, I don't mind changing it.

Allison
