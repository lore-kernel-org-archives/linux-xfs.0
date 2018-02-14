Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:37015 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967538AbeBNMSM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Feb 2018 07:18:12 -0500
Received: by mail-wm0-f44.google.com with SMTP id v71so21676030wmv.2
        for <linux-xfs@vger.kernel.org>; Wed, 14 Feb 2018 04:18:12 -0800 (PST)
Subject: Re: xfs_buf_lock vs aio
From: Avi Kivity <avi@scylladb.com>
References: <a0531d16-d872-548d-4821-273c072973e6@scylladb.com>
 <20180207233320.GB20367@dastard>
 <ed83833b-5024-40f2-b335-2dcab7fddf0e@scylladb.com>
 <20180208221153.GF20266@dastard>
 <30274e7a-4029-73b8-0d8b-cdfda450e3bc@scylladb.com>
 <20180209231015.GI20266@dastard>
 <697bf891-e7c4-4d60-e2ce-f1ba6935b38b@scylladb.com>
 <20180213051850.GE6778@dastard>
 <f8b3b7a4-eba4-d5ab-1748-a8382a2a8fd6@scylladb.com>
Message-ID: <72d45559-2214-f6a2-b96f-78b254a7b3c2@scylladb.com>
Date: Wed, 14 Feb 2018 14:18:08 +0200
MIME-Version: 1.0
In-Reply-To: <f8b3b7a4-eba4-d5ab-1748-a8382a2a8fd6@scylladb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On 02/14/2018 02:07 PM, Avi Kivity wrote:
>
>> Indeed, does your application and/or users even care about
>> [acm]times on your files being absolutely accurate and crash
>> resilient? i.e. do you use fsync() or fdatasync() to guarantee the
>> data is on stable storage?
>
> We use fdatasync and don't care about mtime much. So lazytime would 
> work for us. 

We're actually doing something much worse than lazytime now: we truncate 
the file to a much larger size (and keep increasing that size, 
exponentially) to avoid triggering XFS's 
write-will-create-a-hole-so-lets-stall thing. So compared to that, 
lazytime is invisible in terms of data integrity.
