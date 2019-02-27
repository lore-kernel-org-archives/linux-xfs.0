Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44402 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfB0LkM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Feb 2019 06:40:12 -0500
Subject: Re: [LSF/MM TOPIC] More async operations for file systems - async
 discard?
References: <92ab41f7-35bc-0f56-056f-ed88526b8ea4@gmail.com>
 <20190217210948.GB14116@dastard>
 <46540876-c222-0889-ddce-44815dcaad04@gmail.com>
 <20190220234723.GA5999@localhost.localdomain> <yq18sy8ili7.fsf@oracle.com>
 <20190222164504.GB10066@localhost.localdomain>
From: Ric Wheeler <ricwheeler@gmail.com>
Message-ID: <ec70ef66-cc7a-5a07-9e09-8154d332067a@gmail.com>
Date: Wed, 27 Feb 2019 06:40:08 -0500
MIME-Version: 1.0
In-Reply-To: <20190222164504.GB10066@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Keith Busch <keith.busch@intel.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, lsf-pc@lists.linux-foundation.org, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-block@vger.kernel.org

On 2/22/19 11:45 AM, Keith Busch wrote:
> On Thu, Feb 21, 2019 at 09:51:12PM -0500, Martin K. Petersen wrote:
>> Keith,
>>
>>> With respect to fs block sizes, one thing making discards suck is that
>>> many high capacity SSDs' physical page sizes are larger than the fs
>>> block size, and a sub-page discard is worse than doing nothing.
>> That ties into the whole zeroing as a side-effect thing.
>>
>> The devices really need to distinguish between discard-as-a-hint where
>> it is free to ignore anything that's not a whole multiple of whatever
>> the internal granularity is, and the WRITE ZEROES use case where the end
>> result needs to be deterministic.
> Exactly, yes, considering the deterministic zeroing behavior. For devices
> supporting that, sub-page discards turn into a read-modify-write instead
> of invalidating the page.  That increases WAF instead of improving it
> as intended, and large page SSDs are most likely to have relatively poor
> write endurance in the first place.
>
> We have NVMe spec changes in the pipeline so devices can report this
> granularity. But my real concern isn't with discard per se, but more
> with the writes since we don't support "sector" sizes greater than the
> system's page size. This is a bit of a different topic from where this
> thread started, though.

All of this behavior I think could be helped if we can get some discard testing 
tooling that large customers could use to validate/quantify performance issues. 
Most vendors are moderately good at jumping through hoops held up by large deals 
when the path through that hoop leads to a big deal :)

Ric
