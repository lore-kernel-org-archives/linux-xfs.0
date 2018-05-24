Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60304 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965064AbeEXNQR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 May 2018 09:16:17 -0400
Subject: Re: Bugs involving maliciously crafted file system
References: <000000000000457b2d056cbb0044@google.com>
 <20180522123107.GC3751@bfoster.bfoster> <20180522222620.GW23861@dastard>
 <20180522225208.GB658@sol.localdomain> <20180523074425.GM14384@magnolia>
 <20180523162015.GA3684@sol.localdomain>
 <a52266f9-0096-b28c-c01c-046ababcfe3a@sandeen.net>
 <20180523234114.GA3434@thunk.org> <20180524004931.GB23861@dastard>
 <20180524005906.GC3434@thunk.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <27e0242c-1e71-ffe4-df4d-e75e8d2bb529@sandeen.net>
Date: Thu, 24 May 2018 08:16:14 -0500
MIME-Version: 1.0
In-Reply-To: <20180524005906.GC3434@thunk.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>, Eric Biggers <ebiggers3@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com

On 5/23/18 7:59 PM, Theodore Y. Ts'o wrote:
> On Thu, May 24, 2018 at 10:49:31AM +1000, Dave Chinner wrote:
>> We've learnt this lesson the hard way over and over again: don't
>> parse untrusted input in privileged contexts. How many times do we
>> have to make the same mistakes before people start to learn from
>> them?
> Good question.  For how many years (or is it decades, now) has Fedora
> auto-mounted USB sticks?:-)  Let me know when you successfully get
> Fedora to turn of a feature which appears to have great user appeal.

So we have decades of filesystem design based on one threat model, and
some desktop environments decided to blow it all up 'cause it's more
convenient that way.

Super.  Maybe the email client can start auto-running attachments, too,
For The Convenience.

What's the phrase... poor planning on your part doesn't constitute an
emergency on my part?  :/  (not actually referring to /you/, Ted) ;)

Anyway, if desktops auto-mounting USB sticks is the primary threat,
maybe time would be better spent adding restrictions there - allow only a
subset of common USB formats which are simple and have been fuzzed to hell
and back, rather than mounting whatever you happened to find lying in the
parking lot at work and hoping that somebody, somewhere, has discovered and
fixed every attack vector now that we've blown up the trust model
For The Convenience.

(Digging through dconf-editor, there's just on/off, no gui method at
least, to include or exclude automountable fs types.  It's all or
nothing.  TBH I have no idea how many mechanisms are out there to do
this automounting - hal/udev/systemd/ghome/dbus/...?)

Anyway, fuzzers aside, it sure seems like if we can't un-ring the
automount bell, it'd be prudent to limit it to FAT by default and focus
efforts on making that as safe as possible.

>> Bugs don't have to be exploitable to be a "security issue". Detected
>> filesystem corruptions on a errors=panic mount, or undetected
>> problems that cause a x/NULL deref are still a user-triggerable
>> kernel crash (i.e. a DOS) and therefore considered a security
>> problem.
> 
> I disagree here.  I think it's worth it to disambiguate the two.  If
> you have physical access to the machine, you can also apply AC mains
> voltage to the USB port, which will likely cause the system to crash.
> And at least for Chrome OS, it reboots really quickly.  

Even after you apply AC mains to the USB port?  Cool, Chrome's pretty
resilient.  ;)

I think Dave may have been just stating a reality there rather than agreeing
with it, not sure.
  
> If someone can gain control of the system so they can exfiltrate data,
> or be able to modify files owned as root, that's a much bigger deal
> that crashing the machcine in my view.

For sure.  I guess some subset of the crashes could be more carefully
crafted to be more dangerous, but fuzzers really don't tell us that today,
in fact the more insidious flaws that don't turn up as a crash or hang likely
go unnoticed.

-Eric
