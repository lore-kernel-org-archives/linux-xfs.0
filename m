Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54146 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbfFXMp2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Jun 2019 08:45:28 -0400
Subject: Re: [PATCH] quota: honor quote type in Q_XGETQSTAT[V] calls
References: <0b96d49c-3c0b-eb71-dd87-750a6a48f1ef@redhat.com>
 <20190624105800.GD32376@quack2.suse.cz>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <c5b47955-4771-e883-4e72-11810141eb19@redhat.com>
Date: Mon, 24 Jun 2019 07:45:27 -0500
MIME-Version: 1.0
In-Reply-To: <20190624105800.GD32376@quack2.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Bob Peterson <rpeterso@redhat.com>

On 6/24/19 5:58 AM, Jan Kara wrote:
> On Fri 21-06-19 18:27:13, Eric Sandeen wrote:
>> The code in quota_getstate and quota_getstatev is strange; it
>> says the returned fs_quota_stat[v] structure has room for only
>> one type of time limits, so fills it in with the first enabled
>> quota, even though every quotactl command must have a type sent
>> in by the user.
>>
>> Instead of just picking the first enabled quota, fill in the
>> reply with the timers for the quota type that was actually
>> requested.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> I guess this is a change in behavior, but it goes from a rather
>> unexpected and unpredictable behavior to something more expected,
>> so I hope it's ok.
>>
>> I'm working on breaking out xfs quota timers by type as well
>> (they are separate on disk, but not in memory) so I'll work
>> up an xfstest to go with this...
> 
> Yeah, makes sense. I've added the patch to my tree.
> 
> 								Honza
> 

Thanks Jan - if you'd like to fix my "quote" for "quota" in the
subject line, please feel free.  ;)

-Eric
