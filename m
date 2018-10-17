Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727186AbeJRDsm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 17 Oct 2018 23:48:42 -0400
MIME-Version: 1.0
References: <1539027169-23332-1-git-send-email-sandeen@sandeen.net>
 <20181011103636.GC9467@quack2.suse.cz> <CAPcyv4iAD_wkjY1way1rOxr4=gC_TGx71VquF13ooAuUPz9RJw@mail.gmail.com>
 <5a8e54e8-4845-1c85-e4e9-0b9b551a9ce2@sandeen.net> <20181012082154.GB30154@lst.de>
 <CAOxpaSWf=6RBTa3WM=Hnbr7MwpQ5mMSMAZ+B5FfZo3zKv4Nu7w@mail.gmail.com> <116ef687-f23d-b45c-1b48-fd444b346719@sandeen.net>
In-Reply-To: <116ef687-f23d-b45c-1b48-fd444b346719@sandeen.net>
From: Ross Zwisler <zwisler@kernel.org>
Date: Wed, 17 Oct 2018 13:51:15 -0600
Message-ID: <CAOxpaSUN3cG5c4CJQHeBMgKKHO6-wguGT0m7tgG5VwpY6PgJEg@mail.gmail.com>
Subject: Re: [PATCH 0/3] ext2, ext4, xfs: hard fail dax mount on unsupported devices
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, linux-xfs <linux-xfs@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>

On Wed, Oct 17, 2018 at 1:42 PM Eric Sandeen <sandeen@sandeen.net> wrote:
> On 10/13/18 11:05 AM, Ross Zwisler wrote:
> > On Fri, Oct 12, 2018 at 2:21 AM Christoph Hellwig <hch@lst.de> wrote:
> >>
> >> On Thu, Oct 11, 2018 at 01:38:34PM -0500, Eric Sandeen wrote:
> >>>> The different behavior between filesystems was confusing customers so
> >>>> we had to align them, then the question was which default to pick.
> >>>> Honestly, we came to the decision to bring ext4 in line with the xfs
> >>>> behavior because we thought that would be easier than the alternative.
> >>>> Dave and Christoph made repeated arguments that DAX is just a hidden
> >>>> performance optimization that no application should rely on, so we
> >>>> went the path of least resistance and changed the ext4 default.
> >>>
> >>> Ok, well, I guess we'd better reconcile "it's a hidden performance hint"
> >>> with "if the administrator asked they must receive..." before making this
> >>> change... cc: hch for bonus input.
> >>
> >> I don't really care too mouch on the mount options, the important bit
> >> was the application behavior.
> >>
> >> I fully agree with Dan that we should have the same behavior for every
> >> file system, though.
> >
> > One factor that might influence this is how we expect users to detect
> > whether or not DAX is being used, and whether that can vary per-inode
> > within a filesystem.  If we choose to only have the mount option then
> > I agree that a hard failure when -o dax doesn't work seems fine.  And
> > of course keeping the filesystems behaving the same is desirable.
> >
> > If we eventually do go back to having a per-inode DAX option, though,
> > the mount option becomes a hint as to what the default behavior is,
> > and the user will need another way to detect whether or not DAX is
> > being used for a given inode.  In that case having the mount option
> > fail loudly isn't as important because all we've really changed is the
> > filesystem's default, and the application will still need a consistent
> > way of detecting whether the inode they are actually using is DAX or
> > not.
> >
> > I'm not sure if per-inode DAX is still a goal for anyone.  If not,
> > then sure, using the DAX mount option as the one source of truth and
> > making it a hard failure when it doesn't work seems reasonable.
>
> I've been thinking about the per-inode stuff a bit, and while I don't know
> how to resolve some of the trickier issues, at least the expected behavior
> seems like something we can narrow down and specify.
>
> Because it's an on-disk flag (in xfs today, in any case) it seems that
> the only sane behavior to expect is either/or, i.e.:
>
> Mount option: All files always dax, per-inode flags ignored (or rejected)
> Per-inode: Mount option cannot be specified; only inodes explicitly flagged are dax
>
> Think about it; what would mount-option-plus-per-inode mean?  We have
> no "negative" dax flag, so while mount-option-with-flag surely means
> "dax", what the heck does mount-option-without-flag mean, and how is it
> distinguishable from mount option only?
>
> I submit that flags can only have meaning w/o the fs-wide mount option
> enabled, so the question of "should we hard fail mount -o dax for devices
> that cannot support it" seems to be orthogonal to the per-inode question.
>
> i.e. mount -o dax really can only mean "I want dax on everything" and so
> again, I think we probably need to fail the mount if that can't be honored.

Works for me.
