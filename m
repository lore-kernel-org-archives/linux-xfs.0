Return-Path: <SRS0=AHt9=DO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A091FC4363C
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 21:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66D8120872
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 21:15:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="enJS9XPM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgJGVPj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Oct 2020 17:15:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37277 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727821AbgJGVPi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Oct 2020 17:15:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602105337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pJAmEsObc3GBVmbzycGf7Hg/e/c/NZxFf/Al/ZlXJRs=;
        b=enJS9XPMpAll45EVc6lhNk3Raxuv1W4TQR+kGIQ/hCfCko3DM+955aewuTbaaig8g1sXM2
        gtiR1h1XVTisUUhAXHarGXkg3BR8JekhxZLvehMTw51VX39+116tdhfj9tStnjGdWpAnbU
        epl7fqJ6MjhPa/TeR4RGd1W3g1EXyjE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-Fl9FKX8hOGCtWD54p-7Llw-1; Wed, 07 Oct 2020 17:15:35 -0400
X-MC-Unique: Fl9FKX8hOGCtWD54p-7Llw-1
Received: by mail-wm1-f69.google.com with SMTP id o136so1580750wme.8
        for <linux-xfs@vger.kernel.org>; Wed, 07 Oct 2020 14:15:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pJAmEsObc3GBVmbzycGf7Hg/e/c/NZxFf/Al/ZlXJRs=;
        b=cz89fdEdNqWAidq0ZXbXc55CNMBGSLokmF81UyMaRF2f4Nt31h+nOOVl8jwvO+7rdj
         cbsyhFDmKUXIknV4fJvfDqOQCPccCATbEoY/Qiukvm1aOarV4LtJ1o3un7Gh2xbcPxIg
         Q+4uiZuYJ/dHXl08pno7g9GL961sU9xFb/PVlK7qMLp95XSBMMJW2zB9cjdQrmfauDGb
         MUyBu7OLJsVCclqicBGoxnely+xizJ0sW+unFD88s7KygX4VYa4LVpqMyKDanuSB9A7N
         UnfIvyYtldgal6BSzl9IpPHGkri9QTPxBvHWcr3slvC9gu06frT2vWtFZzSep3ujOzbb
         Xhjw==
X-Gm-Message-State: AOAM531+KMYMgRbuocsEWuoyqskvCigUCRplrrJssRdG8O2rVT586VaX
        yL4Lw/Wa4UfmeIktokqQ0KuzCQAhYgRKSILczsDuhkBu1LjA197n7xYm4hQwuQQo6ZvgDC+SA4B
        GfUD7L592Hco+OB/TvP8B
X-Received: by 2002:a7b:cbd1:: with SMTP id n17mr5126378wmi.120.1602105334174;
        Wed, 07 Oct 2020 14:15:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQFjcoZoLRZqpUsXJ3LOAMm5FGyq3rhQ92uPo9FTaZpcbZ9LZQFVTpzN6huYb+woE1dClgOA==
X-Received: by 2002:a7b:cbd1:: with SMTP id n17mr5126367wmi.120.1602105333916;
        Wed, 07 Oct 2020 14:15:33 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id h1sm4020724wrx.33.2020.10.07.14.15.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2020 14:15:33 -0700 (PDT)
Subject: Re: [PATCH v9 4/4] xfs: replace mrlock_t with rw_semaphores
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
References: <20201006191541.115364-1-preichl@redhat.com>
 <20201006191541.115364-5-preichl@redhat.com>
 <20201007012159.GA49547@magnolia>
 <066ebfa6-25a2-aee4-a01c-3803ef716361@sandeen.net>
 <20201007152554.GL49559@magnolia>
From:   Pavel Reichl <preichl@redhat.com>
Message-ID: <4cd57497-4670-f96f-01a0-0c587e77548d@redhat.com>
Date:   Wed, 7 Oct 2020 23:15:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201007152554.GL49559@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/7/20 5:25 PM, Darrick J. Wong wrote:
> On Wed, Oct 07, 2020 at 09:17:13AM -0500, Eric Sandeen wrote:
>> On 10/6/20 8:21 PM, Darrick J. Wong wrote:
>>> On Tue, Oct 06, 2020 at 09:15:41PM +0200, Pavel Reichl wrote:
>>>> Remove mrlock_t as it does not provide any extra value over
>>>> rw_semaphores. Make i_lock and i_mmaplock native rw_semaphores and
>>>> replace mr*() functions with native rwsem calls.
>>>>
>>>> Release the lock in xfs_btree_split() just before the work-queue
>>>> executing xfs_btree_split_worker() is scheduled and make
>>>> xfs_btree_split_worker() to acquire the lock as a first thing and
>>>> release it just before returning from the function. This it done so the
>>>> ownership of the lock is transfered between kernel threads and thus
>>>> lockdep won't complain about lock being held by a different kernel
>>>> thread.
>>>>
>>>> Signed-off-by: Pavel Reichl <preichl@redhat.com>
>>>> ---
>>>>  fs/xfs/libxfs/xfs_btree.c | 14 +++++++
>>>>  fs/xfs/mrlock.h           | 78 ---------------------------------------
>>>>  fs/xfs/xfs_inode.c        | 36 ++++++++++--------
>>>>  fs/xfs/xfs_inode.h        |  4 +-
>>>>  fs/xfs/xfs_iops.c         |  4 +-
>>>>  fs/xfs/xfs_linux.h        |  2 +-
>>>>  fs/xfs/xfs_super.c        |  6 +--
>>>>  7 files changed, 41 insertions(+), 103 deletions(-)
>>>>  delete mode 100644 fs/xfs/mrlock.h
>>>>
>>>> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
>>>> index 2d25bab68764..1d1bb8423688 100644
>>>> --- a/fs/xfs/libxfs/xfs_btree.c
>>>> +++ b/fs/xfs/libxfs/xfs_btree.c
>>>> @@ -2816,6 +2816,7 @@ xfs_btree_split_worker(
>>>>  	unsigned long		pflags;
>>>>  	unsigned long		new_pflags = PF_MEMALLOC_NOFS;
>>>>  
>>>> +	rwsem_acquire(&args->cur->bc_ino.ip->i_lock.dep_map, 0, 0, _RET_IP_);
>>> These calls also need a comment explaining just what they're doing.
>>>
>>>>  	/*
>>>>  	 * we are in a transaction context here, but may also be doing work
>>>>  	 * in kswapd context, and hence we may need to inherit that state
>>>> @@ -2832,6 +2833,7 @@ xfs_btree_split_worker(
>>>>  	complete(args->done);
>>>>  
>>>>  	current_restore_flags_nested(&pflags, new_pflags);
>>>> +	rwsem_release(&args->cur->bc_ino.ip->i_lock.dep_map, _THIS_IP_);
>>> Note that as soon as you call complete(), xfs_btree_split can wake up
>>> and return, which means that *args could now point to reclaimed stack
>>> space.  This leads to crashes and memory corruption in generic/562 on
>>> a 1k block filesystem (though in principle this can happen anywhere):
>>
>>
>> What's the right way out of this; store *ip when we enter the function
>> and use that to get to the map, rather than args i guess?
> 
> Er, no, because the worker could also get preempted right after
> complete() and take so long to get rescheduled that the the inode have
> been reclaimed.  Think about it -- the original thread is waiting on the
> completion that it passed to the worker through $args, and therefore the
> worker cannot touch any of the resources it was accessing through $args
> after calling complete()....

Hi,

thanks for the comments, however for some reason I cannot reproduce the same memory corruption you are getting.

Do you think that moving the 'rwsem_release()' right before the 'complete()' should fix the problem?

Something like:


+       /*
+        * Update lockdep's lock ownership information to point to
+        * this thread as the thread that scheduled this worker is waiting
+        * for it's completion.
+        */
        rwsem_acquire(&args->cur->bc_ino.ip->i_lock.dep_map, 0, 0, _RET_IP_);
        /*
         * we are in a transaction context here, but may also be doing work
@@ -2830,10 +2835,15 @@ xfs_btree_split_worker(
 
        args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
                                         args->key, args->curp, args->stat);
+       /*
+        * Update lockdep's lock ownership information to reflect that we will
+        * be transferring the ilock from this worker back to the scheduling
+        * thread.
+        */
+       rwsem_release(&args->cur->bc_ino.ip->i_lock.dep_map, _THIS_IP_);
        complete(args->done);
 
        current_restore_flags_nested(&pflags, new_pflags);
-       rwsem_release(&args->cur->bc_ino.ip->i_lock.dep_map, _THIS_IP_);



> 
> --D
> 
>> Thanks,
>> -Eric
> 

