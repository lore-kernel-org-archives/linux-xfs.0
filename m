Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40810 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbfE2SeT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 May 2019 14:34:19 -0400
Subject: Re: How to package e2scrub
References: <20190529120603.xuet53xgs6ahfvpl@work>
 <20190529182111.GA5220@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <48b9290c-ac0a-b5b2-ab27-970282ae242e@redhat.com>
Date: Wed, 29 May 2019 13:34:06 -0500
MIME-Version: 1.0
In-Reply-To: <20190529182111.GA5220@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Lukas Czerner <lczerner@redhat.com>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>, xfs <linux-xfs@vger.kernel.org>

On 5/29/19 1:21 PM, Darrick J. Wong wrote:
> On Wed, May 29, 2019 at 02:06:03PM +0200, Lukas Czerner wrote:
>> Hi guys,
>>
>> I am about to release 1.45.2 for Fedora rawhide, but I was thinking
>> about how to package the e2scrub cron job/systemd service.
> 
> Funny, xfs has the same conundrum.  Adding Eric & xfs list to cc...
> 
>> I really do not like the idea of installing cron job and/or the service as
>> a part of regular e2fsprogs package. This can potentially really surprise
>> people in a bad way.
>>
>> Note that I've already heard some complaints from debian users about the
>> systemd service being installed on their system after the e2fsprogs
>> update.
> 
> Yeah, e2scrub is bitrotting rather faster than I had thought it
> would... but it's only available in Debian unstable.
> 
>> What I am going to do is to split the systemd service into a separate
>> package and I'd like to come to some agreement about the name of the
>> package so that we can have the same name across distributions (at least
>> Fedora/Debian/Suse).
> 
> Indeed.  Eric picked "xfsprogs-xfs_scrub" for Rawhide, though I find
> that name to be very clunky and would have preferred "xfs_scrub".

Yes it is a bit clunky but *shrug*

The main motivator for this was one piece uses python3 and that Made People
Sad who wanted minimal systems with minimal deps but still wanted xfsprogs.

Keeping services separate is a good idea as well, I think.

I don't have a strong opinion on whether /just/ the service should be separate,
or the scrub util + the service should be separate.

I put all the xfs scrubbing bits in one package in rawhide.

-Eric
