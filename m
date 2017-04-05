Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:40756 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752118AbdDEOFg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Apr 2017 10:05:36 -0400
Subject: Re: [PATCH 01/22] mkfs: remove intermediate getstr followed by getnum
References: <20170315160017.27805-1-jtulak@redhat.com>
 <20170315160017.27805-2-jtulak@redhat.com>
 <96ddb2a7-d93e-3ba4-6845-eb60d9558f60@sandeen.net>
 <CACj3i720P-iC0UMFhx8QQEp7CPPXVe2SN298C7oWgxoxEVqFHg@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <dfcd1027-79f5-e130-e260-c630e298a61b@sandeen.net>
Date: Wed, 5 Apr 2017 09:05:35 -0500
MIME-Version: 1.0
In-Reply-To: <CACj3i720P-iC0UMFhx8QQEp7CPPXVe2SN298C7oWgxoxEVqFHg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On 4/5/17 8:00 AM, Jan Tulak wrote:
> On Thu, Mar 16, 2017 at 11:59 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> The only downside I see to this is that we used to echo back the same
>> form that was specified, i.e. -
>>
>> # mkfs.xfs -f -d size=4e fsfile
>> size 4e specified for data subvolume is too large, maximum is 262144 blocks
>> # mkfs.xfs -f -d size=4611686018427387904 fsfile
>> size 4611686018427387904 specified for data subvolume is too large, maximum is 262144 blocks
>> # mkfs.xfs -f -d size=1125899906842624b fsfile
>> size 1125899906842624b specified for data subvolume is too large, maximum is 262144 blocks
>>
>> now we always get back the raw byte value:
>>
>> # mkfs/mkfs.xfs -f -d size=4e fsfile
>> size 4611686018427387904 specified for data subvolume is too large, maximum is 262144 blocks
>>
>> Anything that fails the getnum() checks echo back the original
>> form on the cmdline; this case is different because getnum() passes,
>> but by the time we do value checking all we have is the bytes.  Is
>> that intentional/desirable?
>>
>> So it's a change, not necessarily incorrect or unacceptable, but
>> I wanted to highlight it and check.  It wouldn't be too hard to
>> convert it right away, but keep the string around for error printing
>> purposes, I suppose.
>>
> 
> It goes back into the original reporting style later in the set. I
> tried to change the patch to avoid this temporary change, but the
> issue is, I loose the old raw strings before I have access to the
> necessary indexes for the option table to read the raw string from it,
> or before a code shuffling brings the reporting closer to where the
> raw string still exists.
> 
> Given that it is only a temporary change of style and it seems to be
> too deeply depending on other changes, I'm keeping it as a TODO, but
> not a blocker. Maybe if the patch can be split and one of the parts
> moved after other commits...

Even simply noting in the changelog that it's temporary, and the reason
for the change, would be helpful.  It's a big enough patchset that it's
hard for the reviewer to keep everything in mind across 20+ patches.  ;)

Thanks,
-Eric
