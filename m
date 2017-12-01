Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43952 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751921AbdLAWZ6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Dec 2017 17:25:58 -0500
Subject: Re: [PATCH 4/4] xfs: move all scrub input checking to
 xfs_scrub_validate
References: <2f4bb05f-fd41-7fa3-22f0-9ec9d2224a47@redhat.com>
 <b60a6557-ca8c-6118-8013-09677d529adb@sandeen.net>
 <20171201222437.GW21412@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1d1f489e-9a24-1b00-05a9-1892f0a6c02b@sandeen.net>
Date: Fri, 1 Dec 2017 16:25:57 -0600
MIME-Version: 1.0
In-Reply-To: <20171201222437.GW21412@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>



On 12/1/17 4:24 PM, Darrick J. Wong wrote:
>> diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
>> index e9ec041..47f098c 100644
>> --- a/fs/xfs/scrub/scrub.h
>> +++ b/fs/xfs/scrub/scrub.h
>> @@ -22,7 +22,17 @@
>>  
>>  struct xfs_scrub_context;
>>  
>> +/* Type info and names for the scrub types. */
>> +enum scrub_type {
> enum xfs_scrub_type ?
> 

Oh, sure.  I can resend or feel free to fix it on the way in if that's
all there is.

-Eric
