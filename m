Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:50318 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbeJGDEd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 6 Oct 2018 23:04:33 -0400
Subject: Re: XFS mount problem
References: <20181006140317.148fe46d@acer-suse.lan>
 <93a3ae91-b69a-a8a6-f196-c539333e3027@sandeen.net>
 <20181006162822.6c9abd75@acer-suse.lan>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8b2c2724-04e1-b6b4-423a-409e32773b29@sandeen.net>
Date: Sat, 6 Oct 2018 14:59:55 -0500
MIME-Version: 1.0
In-Reply-To: <20181006162822.6c9abd75@acer-suse.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Howorth <dave@howorth.org.uk>
Cc: linux-xfs@vger.kernel.org

On 10/6/18 10:28 AM, Dave Howorth wrote:
> On Sat, 6 Oct 2018 09:22:37 -0500
> Eric Sandeen <sandeen@sandeen.net> wrote:
> 
> Thanks for your reply, Eric.
> 
>> The log is dirty as expected.  But at least xfs_repair thinks it is an
>> xfs filesystem, and it looks intact.
>>
>> Try 
>>
>> # mount /dev/dm-3 /srv/live-tv 
> 
> Hmm, that worked. Thanks. I'm not sure why that worked when my attempt
> failed, although I do see in dmesg:
> 
>  [  467.743699] SGI XFS with ACLs, security attributes, no debug enabled
>  [  467.744733] XFS (dm-3): unknown mount option [noacl].
> 
> So is that also the reason it failed at boot? I'm surprised because
> that would seem to imply it's never been mounted using the information
> in /etc/fstab before. I suppose it is possible because I only created
> the filesystem a little while ago. Good news if so, since I can resume
> mounting by label.

Oh, yep, I didn't see the "noacl" in fstab.  That's not a valid xfs 
mount option.  Don't know why its' in fstab or how things were working
before.

>> and if that fails, type "dmesg" to show the kernel message, look
>> towards the end to see what it thinks went wrong.
> 
>> Look at the end of "dmesg" output when mount fails.
>>
>> -Eric
> 
> Thanks again, Dave
> 
> PS What's the list etiquette here about replies? I use claws and both
> Reply and Reply-List would send my reply just to Eric, so I did
> Reply-All. I just did a quick search for list etiquette for the list
> but didn't see anything obvious.


Reply all is fine as far as I'm concerned.

-Eric
