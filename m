Return-Path: <SRS0=V5eY=2Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D940C2D0DA
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Dec 2019 17:04:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29D24206CB
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Dec 2019 17:04:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PHs6Whga"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfLZREO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Dec 2019 12:04:14 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53302 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbfLZREO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Dec 2019 12:04:14 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBQGtCKc165063;
        Thu, 26 Dec 2019 17:04:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=+tNhCcpFJQcXUFsLsDI54spIz0K3CoXlohkqyxGD2x0=;
 b=PHs6WhgaEszmR0UdC2WqSG/ewchHD9JZa5K4OZXbX4MWEK/5/ra+15HJv1GxX4t7PSXF
 sLkO1X+NC7sPFUIZ8Mr2DXuvrT/6Nd6JQ7IcbTzwm4J9RP2yFoHmU98vdEbPmxZJ0LBJ
 ymv+6Fk9hz7lHmnbLiQ7XKmkiK6KzEVn0htb5QVeENMQAdmPZovjRuN1N+6i/loolfsH
 n8yNITFpRa6c2NHfddq/NrHmmSfvQM0n8BnMD2GeoEpipI57JSlJijzOl6vJVG+dn1zT
 gpiCVEQNj8aKyvTwj4UNGztru8WwD+DyKWTmOUL8FqRJ7sd0bj0wXQn4oRMzVYq58QGQ TA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2x1bbq2qxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Dec 2019 17:04:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBQH3tQp041092;
        Thu, 26 Dec 2019 17:04:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2x4wj2pqs4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Dec 2019 17:04:02 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBQH414m024763;
        Thu, 26 Dec 2019 17:04:01 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Dec 2019 09:04:01 -0800
Subject: Re: [PATCH v5 07/14] xfs: Factor out xfs_attr_leaf_addname helper
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-8-allison.henderson@oracle.com>
 <20191224122254.GE18379@infradead.org>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <32f47226-d8b7-6f9e-2244-8237a8b1db6e@oracle.com>
Date:   Thu, 26 Dec 2019 10:04:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191224122254.GE18379@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9482 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912260155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9482 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912260154
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 12/24/19 5:22 AM, Christoph Hellwig wrote:
> On Wed, Dec 11, 2019 at 09:15:06PM -0700, Allison Collins wrote:
>> Factor out new helper function xfs_attr_leaf_try_add.
>> Because new delayed attribute routines cannot roll
>> transactions, we carve off the parts of
>> xfs_attr_leaf_addname that we can use.  This will help
>> to reduce repetitive code later when we introduce
>> delayed attributes.
> 
> I have a hard time relating the subject to what is happening here,
> maybe because the patch does too many things at once.  One thing
> is plitting a xfs_attr_leaf_try_add from xfs_attr_leaf_addname, which
> seems pretty sensible, but then it also moves code from
> xfs_attr_node_addname into the only caller.  That probably should be
> a separate patch with a proper description.
> 
Sure, maybe it might help to look at it this way though: the goal of all 
this refactoring is to get all the transactions up into the 
xfs_attr_*_args routines.  Once we have them pretty much corralled, we 
replace them with a sort of state machine like mechanic.  This produces 
the "return EAGAIN for new a transaction" behavior that we need for the 
.finish_item callback.

In this case, xfs_attr_leaf_addname is a subroutine with a transaction 
in the middle.  So we split it into two functions.  Kind of like a top 
half and bottom half, and then the transaction moves up.  While I can 
separate the split and the move into separate patches, it didnt really 
feel to me like the transaction or the node logic really fit with either 
of the helpers.  They are supposed to be about leaves, not nodes.  It's 
not a big deal I suppose to split up the patches, but I thought doing so 
creates a sort of transient patch with functions that have logic not 
particularly appropriate for their scope.  Thoughts?

Also, perhaps I need to remove the line in the commit header about 
reducing repetitive code.  It might be misleading you (apologies).  This 
is left over from an earlier version of the series where I tried to 
avoid "monster function" by having two code paths: one for inline attrs 
and a separate one for delayed attrs.  It generated a lot of repetitive 
code with subtle differences though, and i think folks preferred the 
code paths to stay merged.  The goal being to first establish what 
"monster function" even looks like, and then simplify it into new 
helpers from there.

This is admittedly a very difficult series to review.  People need to 
understand patches 1 - 12 to really understand what 13 and 14 are doing. 
  But really, 13 and 14 are kind of driving the rest of the series. 
Like literally an entire patch fell out of the last set because of some 
changes we made in the end of the series.  I know 13 and 14 are the 
hardest to look at, but they very much dictate what the lower patches 
end up doing.  So I encourage people to try and focus attention there 
before loosing to much sanity on scaffolding.  Certainty it all needs to 
get reviewed of course, but it may help to make more efficient use of 
peoples review time.  :-)

Hope that helps!  Thanks for looking at it!
Allison
