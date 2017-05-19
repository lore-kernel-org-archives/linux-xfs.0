Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44207 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753421AbdESS6z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 May 2017 14:58:55 -0400
Date: Fri, 19 May 2017 11:58:47 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] vfs: freeze filesystems just prior to reboot
Message-ID: <20170519185847.GI4519@birch.djwong.org>
References: <20170519002032.GA21202@birch.djwong.org>
 <CAOQ4uxhbck8g0o1mSrY7wGvvYtqGpiJjWG8vHFN8Pc5pWc0X+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhbck8g0o1mSrY7wGvvYtqGpiJjWG8vHFN8Pc5pWc0X+A@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Eric Sandeen <sandeen@redhat.com>, Theodore Tso <tytso@mit.edu>

On Fri, May 19, 2017 at 11:29:04AM +0300, Amir Goldstein wrote:
> On Fri, May 19, 2017 at 3:20 AM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> 
> >
> > Therefore, add a reboot hook to freeze all filesystems (which in general
> > will induce ext4/xfs/btrfs to checkpoint the log) just prior to reboot.
> > This is an unfortunate and insufficient workaround for multiple layers
> > of inadequate external software, but at least it will reduce boot time
> > surprises for the "OS updater failed to disengage the filesystem before
> > rebooting" case.
> >
> 
> Darrick,
> 
> Did you consider how many support calls this will generate for a stuck
> reboot command?
> 
> I can think of at least one situation where this is guarantied to hang.
> See this patch for the details:
> https://patchwork.kernel.org/patch/6266791/
> 
> The referenced patch was applied to Android kernel to prevent
> system crash on emergency remount-ro via sysrq trigger.

Hmmm, I agree that we ought to avoid hanging on loopmounted filesystems,
and that iterating superblocks backwards is one (rough) way to do that.

> I don't know if it was even seriously considered by Al, because
> I got no comment, but I do realize that the change of behavior
> could generate support calls, so it's scary to make that change
> in mainline.
> 
> I know it's not going to work around broken system software update,
> but how about providing sysrq trigger for emergency_freeze_all()?
> like emergency_remount(), but stronger.
> And this time, iterate supers in reverse order like I suggested to
> avoid loop mounted fs freeze dependencies.
> 
> There is one little tiny problem though. Eric used up the last sysrq trigger
> key for emergency_thaw_all(). Do you see the irony in that? ;)

LOL.

> I am wondering how many people know about or use the emergency
> thaw trigger, but one dodgy option is to use the 't' trigger to toggle
> thaw_all/freeze_all.
> 
> Another perhaps slightly less dodgy option is to trigger freeze_all
> on a sequence of sysrq "emergency" triggers where it makes sense
> and is least likely to change any existing behavior, for example:
> 
> echo u > /proc/sysrq-trigger
> 
> # Remember if do_emergency_remount() completed with failures
> 
> echo u > /proc/sysrq-trigger
> 
> # Escalate to emergency freeze

Or maybe it's simpler just to have a counter -- three sysrq-u in a row
and we freeze all?

> OR
> 
> echo u > /proc/sysrq-trigger
> 
> # Remember if do_emergency_remount() completed with failures
> 
> echo s > /proc/sysrq-trigger
> 
> # Sync *after* remount r/o? That must mean emergency freeze
> 
> I bet that system software that is already aware of and is issuing
> emergency remount r/o trigger prior to reboot, won't see any harm
> in adding an extra u/s trigger for good luck.
> 
> Do you know if the gnarly system software in question is issuing
> emergency remount r/o prior to reboot?

It does not.

--D

> 
> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
