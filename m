Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:38319 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751851AbdHPNGL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Aug 2017 09:06:11 -0400
Received: by mail-qk0-f169.google.com with SMTP id x191so19503079qka.5
        for <linux-xfs@vger.kernel.org>; Wed, 16 Aug 2017 06:06:10 -0700 (PDT)
Date: Wed, 16 Aug 2017 09:06:08 -0400
From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: CrashMonkey: A Framework to Systematically Test File-System
 Crash Consistency
Message-ID: <20170816130607.GA1347@destiny>
References: <CAPaz=E+-+C-LXtADm99epmVEszpfT70Ep39tKedfPi1AN-P7tA@mail.gmail.com>
 <20170815173349.GA17774@li70-116.members.linode.com>
 <CAPaz=E+sPDK3uWYCepmYPMT2+nvTgA2C_OSyPY0a51iM=bBCsQ@mail.gmail.com>
 <CAOQ4uxhkT05yHfQz0csruH-mz_hTamMABh3eZaNmzjXX02J1=A@mail.gmail.com>
 <CAPaz=E+D7wpkXRx7=M9+7d=TUFpbG7MetK-nkECtWQXwO-Z8gA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPaz=E+D7wpkXRx7=M9+7d=TUFpbG7MetK-nkECtWQXwO-Z8gA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Vijay Chidambaram <vvijay03@gmail.com>
Cc: Amir Goldstein <amir73il@gmail.com>, Josef Bacik <josef@toxicpanda.com>, Ext4 <linux-ext4@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-btrfs@vger.kernel.org, Ashlie Martinez <ashmrtn@utexas.edu>, kernel-team@fb.com

On Tue, Aug 15, 2017 at 08:44:16PM -0500, Vijay Chidambaram wrote:
> Hi Amir,
> 
> I neglected to mention this earlier: CrashMonkey does not require
> recompiling the kernel (it is a stand-alone kernel module), and has
> been tested with the kernel 4.4. It should work with future kernel
> versions as long as there are no changes to the bio structure.
> 
> As it is, I believe CrashMonkey is compatible with the current kernel.
> It certainly provides functionality beyond log-writes (the ability to
> replay a subset of writes between FLUSH/FUA), and we intend to add
> more functionality in the future.
> 
> Right now, CrashMonkey does not do random sampling among possible
> crash states -- it will simply test a given number of unique states.
> Thus, right now I don't think it is very effective in finding
> crash-consistency bugs. But the entire infrastructure to profile a
> workload, construct crash states, and test them with fsck is present.
> 
> I'd be grateful if you could try it and give us feedback on what make
> testing easier/more useful for you. As I mentioned before, this is a
> work-in-progress, so we are happy to incorporate feedback.
> 

Sorry I was travelling yesterday so I couldn't give this my full attention.
Everything you guys do is already accomplished with dm-log-writes.  If you look
at the example scripts I've provided

https://github.com/josefbacik/log-writes/blob/master/replay-individual-faster.sh
https://github.com/josefbacik/log-writes/blob/master/replay-fsck-wrapper.sh

The first initiates the replay, and points at the second script to run after
each entry is replayed.  The whole point of this stuff was to make it as
flexible as possible.  The way we use it is to replay, create a snapshot of the
replay, mount, unmount, fsck, delete the snapshot and carry on to the next
position in the log.

There is nothing keeping us from generating random crash points, this has been
something on my list of things to do forever.  All that would be required would
be to hold the entries between flush/fua events in memory, and then replay them
in whatever order you deemed fit.  That's the only functionality missing from my
replay-log stuff that CrashMonkey has.

The other part of this is getting user space applications to do more thorough
checking of consistency that it expects, which I implemented here

https://github.com/josefbacik/fstests/commit/70d41e17164b2afc9a3f2ae532f084bf64cb4a07

fsx will randomly do operations to a file, and every time it fsync()'s it saves
it's state and marks the log.  Then we can go back and replay the log to the
mark and md5sum the file to make sure it matches the saved state.  This
infrastructure was meant to be as simple as possible so the possiblities for
crash consistency testing were endless.  One of the next areas we plan to use
this in Facebook is just for application consistency, so we can replay the fs
and verify the application works in whatever state the fs is at any given point.

I looked at your code and you are logging entries at submit time, not completion
time.  The reason I do those crazy acrobatics is because we have had bugs in
previous kernels where we were not waiting for io completion of important
metadata before writing out the super block, so logging only at completion
allows us to catch that class of problems.

The other thing CrashMonkey is missing is DISCARD support.  We fuck up discard
support constantly, and being able to replay discards to make sure we're not
discarding important data is very important.

I'm not trying to shit on your project, obviously it's a good idea, that's why I
did it years ago ;).  The community is going to use what is easiest to use, and
modprobe dm-log-writes is a lot easier than compiling and insmod'ing an out of
tree driver.  Also your driver won't work on upstream kernels because of the way
the bio flags were changed recently, which is why we prefer using upstream
solutions.

If you guys want to get this stuff used then it would be better at this point to
build on top of what we already have.  Just off the top of my head we need

1) Random replay support for replay-log.  This is probably a day or two worth of
work for a student.

2) Documentation, because right now I'm the only one who knows how this works.

3) My patches need to actually be pushed into upstream fstests.  This would be
the largest win because then all the fs developers would be running the tests
by default.

4) Multi-device support.  One thing that would be good to have and is a dream of
mine is to connect multiple devices to one log, so we can do things like make
sure mdraid or btrfs's raid consistency.  We could do super evil things like
only replay one device, or replay alternating writes on each device.  This would
be a larger project but would be super helpful.

Thanks,

Josef
