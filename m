Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3914C4BA0A
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 01:48:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A47C222C2
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 01:48:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="yh353gaF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729790AbgBZBsa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 20:48:30 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58006 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729403AbgBZBsa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 20:48:30 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01Q1hjts168393;
        Wed, 26 Feb 2020 01:48:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=9k7hMcGjElGZfkVItyLeeQN/1k/JAmnjwUlzYJNXCIg=;
 b=yh353gaFF79PEV2PEppLMM+R0KLvCVA8ShN5NMUWgv1oCqxwiqCKy1RpEsZsEhmbnRYo
 hZNPoS97lvAfKO/HMLDXw1b1IOGJdCj60P9WUNgcwBN9Dyprn/fnWMvOPW7U9mVGoRDf
 aDCRSBS3g+02X3zqH2nkYMsx41sMs8uxvXZ9+jqDkWqQ9F5KH7mjFjmpqPTTnUDsOvWp
 sbJ+LJGLg+dWsTz76RXZ4/TVOnbrfjVAI3w2nZ9jRJ4s4E80Rc9Ax9pjPIPnRq8k3Ykv
 4YD3OXyFTDFSu4o96vr8tEmSrJvnQUixOlS2HjmQnbHMtVmfoqpRr3W8N+AOlUoKuGS2 bA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2ydcsrgfsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 01:48:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01Q1iIhQ007362;
        Wed, 26 Feb 2020 01:48:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2ydcs0rwqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Feb 2020 01:48:26 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01Q1mP9C018994;
        Wed, 26 Feb 2020 01:48:25 GMT
Received: from [192.168.1.9] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 17:48:25 -0800
Subject: Re: [PATCH v7 15/19] xfs: Add helper function xfs_attr_node_shrink
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-16-allison.henderson@oracle.com>
 <20200225090525.GJ10776@dread.disaster.area>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <5bec1d81-4835-914c-f7ec-6acfe4058e2a@oracle.com>
Date:   Tue, 25 Feb 2020 18:48:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200225090525.GJ10776@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 spamscore=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002260011
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/25/20 2:05 AM, Dave Chinner wrote:
> On Sat, Feb 22, 2020 at 07:06:07PM -0700, Allison Collins wrote:
>> This patch adds a new helper function xfs_attr_node_shrink used to shrink an
>> attr name into an inode if it is small enough.  This helps to modularize
>> the greater calling function xfs_attr_node_removename.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> 
> Can you move this helper function up to early in the patch set?
> That way the code gets simpler and less tangled before adding
> all the new state machine gubbins?
> 
> I suspect that you should do this for all the functions the state
> machine breaks up into gotos, too. THat way adding the state machine
> is really just changing how the functions that do the work are
> called, rather than jumping into the middle of long functions....
> 
> I know, it turns it into a longer series, but it also means that all
> the refactoring work (which needs to be done anyway) can be
> separated and merged while we are still reviewing and working on the
> state machine based operations, thereby reducing the size of the
> patchset you have to manage and keep up to date over time....
> 
> Cheers,
> 
> Dave.
> 
Sure, looking ahead it sounds like that works better for others too, so 
I'll move them back down.  Thanks!

Allison
