Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47856 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729840AbeGQUsg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Jul 2018 16:48:36 -0400
Date: Tue, 17 Jul 2018 20:14:17 +0000
From: Mark Fasheh <mfasheh@suse.de>
Subject: Re: [RESEND][PATCH v4 0/2] vfs: better dedupe permission check
Message-ID: <20180717201417.GE10690@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20180717190906.31073-1-mfasheh@suse.de>
 <20180717194818.GV32415@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180717194818.GV32415@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, Adam Borowski <kilobyte@angband.pl>, David Sterba <dsterba@suse.cz>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org

CCing Michael Kerrisk and linux-api 

The patch at the end of this e-mail updates our man page for
ioctl_fideduperange to reflect the changes proposed in this patch series:

https://marc.info/?l=linux-fsdevel&m=153185457324037&w=2

Any feedback would be appreciated. Thanks in advance.
	--Mark

On Tue, Jul 17, 2018 at 12:48:18PM -0700, Darrick J. Wong wrote:
> On Tue, Jul 17, 2018 at 12:09:04PM -0700, Mark Fasheh wrote:
> > Hi Al,
> > 
> > The following patches fix a couple of issues with the permission check
> > we do in vfs_dedupe_file_range(). I sent them out for a few times now,
> > a changelog is attached. If they look ok to you, I'd appreciate them
> > being pushed upstream.
> > 
> > You can get them from git if you like:
> > 
> > git pull https://github.com/markfasheh/linux dedupe-perms
> > 
> > I also have a set of patches against 4.17 if you prefer. The code and
> > testing are identical:
> > 
> > git pull https://github.com/markfasheh/linux dedupe-perms-v4.17
> > 
> > 
> > The first patch expands our check to allow dedupe of a file if the
> > user owns it or otherwise would be allowed to write to it.
> > 
> > Current behavior is that we'll allow dedupe only if:
> > 
> > - the user is an admin (root)
> > - the user has the file open for write
> > 
> > This makes it impossible for a user to dedupe their own file set
> > unless they do it as root, or ensure that all files have write
> > permission. There's a couple of duperemove bugs open for this:
> > 
> > https://github.com/markfasheh/duperemove/issues/129
> > https://github.com/markfasheh/duperemove/issues/86
> > 
> > The other problem we have is also related to forcing the user to open
> > target files for write - A process trying to exec a file currently
> > being deduped gets ETXTBUSY. The answer (as above) is to allow them to
> > open the targets ro - root can already do this. There was a patch from
> > Adam Borowski to fix this back in 2016:
> > 
> > https://lkml.org/lkml/2016/7/17/130
> > 
> > which I have incorporated into my changes.
> > 
> > 
> > The 2nd patch fixes our return code for permission denied to be
> > EPERM. For some reason we're returning EINVAL - I think that's
> > probably my fault. At any rate, we need to be returning something
> > descriptive of the actual problem, otherwise callers see EINVAL and
> > can't really make a valid determination of what's gone wrong.
> > 
> > This has also popped up in duperemove, mostly in the form of cryptic
> > error messages. Because this is a code returned to userspace, I did
> > check the other users of extent-same that I could find. Both 'bees'
> > and 'rust-btrfs' do the same as duperemove and simply report the error
> > (as they should).
> > 
> > Please apply.
> > 
> > Thanks,
> >   --Mark
> > 
> > Changes from V3 to V4:
> > - Add a patch (below) to ioctl_fideduperange.2 explaining our
> >   changes. I will send this patch once the kernel update is
> >   accepted. Thanks to Darrick Wong for this suggestion.
> > - V3 discussion: https://www.spinics.net/lists/linux-btrfs/msg79135.html
> > 
> > Changes from V2 to V3:
> > - Return bool from allow_file_dedupe
> > - V2 discussion: https://www.spinics.net/lists/linux-btrfs/msg78421.html
> > 
> > Changes from V1 to V2:
> > - Add inode_permission check as suggested by Adam Borowski
> > - V1 discussion: https://marc.info/?l=linux-xfs&m=152606684017965&w=2
> > 
> > 
> > From: Mark Fasheh <mfasheh@suse.de>
> > 
> > [PATCH] ioctl_fideduperange.2: clarify permission requirements
> > 
> > dedupe permission checks were recently relaxed - update our man page to
> > reflect those changes.
> > 
> > Signed-off-by: Mark Fasheh <mfasheh@suse.de>
> > ---
> >  man2/ioctl_fideduperange.2 | 8 +++++---
> 
> Mmm, man page update, thank you for editing the documentation too!
> 
> Please cc linux-api and Michael Kerrisk so this can go upstream.


From: Mark Fasheh <mfasheh@suse.de>

[PATCH] ioctl_fideduperange.2: clarify permission requirements

dedupe permission checks were recently relaxed - update our man page to
reflect those changes.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 man2/ioctl_fideduperange.2 | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/man2/ioctl_fideduperange.2 b/man2/ioctl_fideduperange.2
index 84d20a276..4040ee064 100644
--- a/man2/ioctl_fideduperange.2
+++ b/man2/ioctl_fideduperange.2
@@ -105,9 +105,12 @@ The field
 must be zero.
 During the call,
 .IR src_fd
-must be open for reading and
+must be open for reading.
 .IR dest_fd
-must be open for writing.
+can be open for writing, or reading.
+If
+.IR dest_fd
+is open for reading, the user must have write access to the file.
 The combined size of the struct
 .IR file_dedupe_range
 and the struct
@@ -185,8 +188,8 @@ This can appear if the filesystem does not support deduplicating either file
 descriptor, or if either file descriptor refers to special inodes.
 .TP
 .B EPERM
-.IR dest_fd
-is immutable.
+This will be returned if the user lacks permission to dedupe the file referenced by
+.IR dest_fd .
 .TP
 .B ETXTBSY
 One of the files is a swap file.
-- 
2.15.1


