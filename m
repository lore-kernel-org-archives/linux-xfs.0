Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56060 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753719AbdHXQHh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 12:07:37 -0400
Subject: Re: [PATCH 6/6] fiemap: Fix semantics of max_extents (-n arguments)
References: <1503575272-28263-1-git-send-email-nborisov@suse.com>
 <1503575272-28263-7-git-send-email-nborisov@suse.com>
 <53c70cbc-1c81-0fc3-6ef8-a9fdd98d89c0@sandeen.net>
 <6201098e-3095-9c8d-8e81-aed77c2f2052@suse.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c690c91c-108e-885e-e131-fb9ac045047b@sandeen.net>
Date: Thu, 24 Aug 2017 11:07:35 -0500
MIME-Version: 1.0
In-Reply-To: <6201098e-3095-9c8d-8e81-aed77c2f2052@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>, linux-xfs@vger.kernel.org
Cc: sandeen@redhat.com

On 8/24/17 11:06 AM, Nikolay Borisov wrote:
> 
> 
> On 24.08.2017 19:03, Eric Sandeen wrote:

...

>> In my testing, for a bare fiemap (no -n) we get here with
>> cur_extent == max_extents == 0 and so nothing happens:
>>
>> # xfs_io -c fiemap testfile
>> testfile:
>> #
>>
>> (this causes every xfstest which invokes fiemap to fail).
>>
>> I think initializing max_extents to -1 is a simple way to fix this.
> 
> Ah, you are right, I've come to the same conclusion during my testing of
> earlier versions. Would you care to fold that fix if that's the only
> problem found?

Sure, I can fix it on the way in.

-Eric

