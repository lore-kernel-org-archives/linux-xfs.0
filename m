Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45234 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727512AbfCWB3J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Mar 2019 21:29:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2N1T9rF048729
        for <linux-xfs@vger.kernel.org>; Sat, 23 Mar 2019 01:29:09 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2r8sss0jwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Mar 2019 01:29:08 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2N1T8PA008147
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Mar 2019 01:29:08 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2N1T889013482
        for <linux-xfs@vger.kernel.org>; Sat, 23 Mar 2019 01:29:08 GMT
Subject: Re: Status report 3/18 - 3/22
From: Allison Henderson <allison.henderson@oracle.com>
References: <270152f8-f3e2-3e4b-aec5-a623a06aa773@oracle.com>
Message-ID: <2b46c574-6a30-ec97-6369-02ffe3334cea@oracle.com>
Date: Fri, 22 Mar 2019 18:29:07 -0700
MIME-Version: 1.0
In-Reply-To: <270152f8-f3e2-3e4b-aec5-a623a06aa773@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Shirley Ma <shirley.ma@oracle.com>

Oops, wrong mailing list!  Please ignore!

On 3/22/19 5:10 PM, Allison Henderson wrote:
> Status report 3/18 - 3/22
> 
> [1] PMEM bug and performance
> https://bug.oraclecorp.com/pls/bug/webbug_print.show?c_rptno=29494898
>    Attended XFS performance meeting to discuss performance differences 
> seen between xfs and ext4
>    Need to understand why performance increase is only seen when double 
> write featured is enabled
>    Need to wait for block trace output for further analysis
> 
>    Fix for xfs crash on pmem moved to bugzilla to release fix
>    http://ca-bugzilla.us.oracle.com/bugzilla/show_bug.cgi?id=47146
> 
> [2] XFS Parent Pointer update
>    Started updating previous parent pointer solution onto latest 
> development code
>    Some adjustments needed for delayed operations and protofiles
>    Will send out set for review once all the bugs are worked out again
> 
> [3] Patches reviewed:
>     [PATCH] xfs: serialize unaligned dio writes against all other dio 
> writes
> 
> Thanks everyone!
> Allison
