Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Jan 2007 22:22:58 -0800 (PST)
Received: from smtp101.sbc.mail.mud.yahoo.com (smtp101.sbc.mail.mud.yahoo.com [68.142.198.200])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0O6Mqqw002766
	for <xfs@oss.sgi.com>; Tue, 23 Jan 2007 22:22:53 -0800
Date: Tue, 23 Jan 2007 22:21:50 -0800
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: how to sync / commit data to disk?
Message-ID: <20070124062150.GA12989@tuatara.stupidest.org>
References: <d55656c10701230716x1ae7cf49kd8a854fd73429c4f@mail.gmail.com> <45B632F6.50705@sandeen.net> <d55656c10701231233kf7faf02xbdd59ec1e218afa4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d55656c10701231233kf7faf02xbdd59ec1e218afa4@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Gervai <grinapo@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 23, 2007 at 09:33:01PM +0100, Peter Gervai wrote:

> Now, for me it seems to be a very interesting question that why
> people would CARE whether it's synced or not, since they write it by
> the filesystem layer anyway? I do not know, and investigating the
> reason why 'grub-install' would worry about sync is beyond my
> available time.

there was/is a case where grub assumes a sync will put the file in
it's fine place, it then pokes about using it's own fs code talking to
the block device --- and that's where it breaks

the reason is sync/fsync have to put the data down somewhere that's
not volatile, that isn't going to get lost --- the specification
doesn't require those system calls should put the data down in their
final place or indeed put the filesystem in a state where it's safe to
poke about under a mounted filesystem (though freeze essentialyl does
that)

> The original problem was because grub-install froze xfs, then tried
> to do the above, which magically fail on the frozen filesystem,
> hanging the install till the cows come home. I tried to fix this,
> then started wondering how to do it properly, and now that you
> mentioned and I checked the trace I really start wondering about why
> to care... :-o

i guess it wouldn't be hard to add an freeze/unfreeze hacky thing to
use as a super-duper-sync to allow people to do nasty things, i'm not
sure if that's really a good idea long term though

> Apart from that it is so far he best boot manager I found (still I'm
> open to suggestions of better, free boot managers, but please not on
> this list), which is completely based on my extremely subjective
> point of view (which includes XFS support, naturally), and which may
> be completely opposite to the point of view of any human or nonhuman
> being, it is not, as you have seen above. It uses a dirty hack which
> works, I accept that. Specifying --stage2 seems to avoid that hack
> altogether anyway.

to be quite honest, almost all the bootloaders suck in one way or
another, you're just best off picking whatever has the least pain and
living with it (arguably this applies to most software in general but
boot-loaders are most definately nasty in places)

> I accept the "BROKEN" comment regarding this one. ;-) It is a broken
> implementation. Freeze, ten tries to write. Doomed to fail.

right, so freeze/unfreeze in one call might be a better idea so there
is no chance of having it stuck frozen and breaking things

> I thought that freeze lets already written but unsynced data to be
> written.

freeze should push all unwritten data and metadata out to the fs and
leave it in a decent state suitable for taking a snapshot,
freeze/unfreeze in one go won't really do this, but it might be good
enough for grub
