Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Jul 2008 20:53:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m633raxT000632
	for <xfs@oss.sgi.com>; Wed, 2 Jul 2008 20:53:36 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C1B022AE471
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2008 20:54:39 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id wy1UmpstozGgGG7r for <xfs@oss.sgi.com>; Wed, 02 Jul 2008 20:54:39 -0700 (PDT)
Message-ID: <486C4D7E.8060608@sandeen.net>
Date: Wed, 02 Jul 2008 22:54:38 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: grub fails boot after update
References: <alpine.LNX.1.10.0807011712470.20393@fbirervta.pbzchgretzou.qr> <20080701155522.GA29722@infradead.org>
In-Reply-To: <20080701155522.GA29722@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Engelhardt <jengelh@medozas.de>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> sync works perfectly fine on xfs.  Grub just doesn't understand what
> sync means, and because of that it's buggy on all filesystems, just
> with less a chance on others.   The fix is pretty simple and that is
> stopping to try to access the filesystem with it's own driver through
> the block device node.

Aye.

And from the bug:

>> I agree with comment #37: XFS really does suck, especially when it comes to
>> booting Linux on a PC. 

Now that's just inflammatory.  :)

>> Fortunately we do not support it any more for new
>> installations, an ext2 /boot partition is highly recommended.

I didn't read the details of the bug but the conclusion is right though
- grub is busted, just use ext3 on /boot to work around it.

>> The problem is that with XFS, sync(2) returns, but the data isn't synced.
>> The first time yast calls grub install, grub does not find the new stage1.5,
>> because it is not on the disk yet, despite a successful sync; thus it modifies
>> stage2 to do the job. On the second invocation, stage1.5 is found and
>> installed, but stage2 already is modified.
>> 
>> So once again this isn't a grub bug, but an XFS bug with FS semantics.

No, that's wrong as hch said.

(FWIW the issue is that xfs data is safe on disk, metadata is safe in
the log, but grub tries to read the fs directly as if it were frozen and
expects to find metadata at the final spot on disk, .)

Syncing a live filesystem and then thinking you can go read (or worse,
write!) directly from (to) disk is a busted notion in many ways.   It's
the same problem as thinking you can do "sync" and then take a
block-based snapshot.  There's a reason DM for example freezes before this.

There was a bug w/ grub vs. ext3 causing corruption for the exact same
sorts of reasons; it's just a little harder to hit.

This really is grub that is busted, but I'd still just suggest using
ext3 to (mostly) work around the breakage for the foreseeable future.

The other option is to teach grub to always do its io via the filesystem
not the block device while the fs is mounted (IIRC there are various &
sundry non-intuitive commands which actually nudge grub towards or away
from this desired behavior... --with-stage2=/path is one I think,
skipping the "verification" phase (i.e. trying to read the block dev
while mounted) is another)

BTW the patch to "wait 10s for the fs to settle" is pure bunk and will
not definitively fix the problem.  It's not even worth committing IMHO.

-Eric
