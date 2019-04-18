Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36994 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728074AbfDRLEA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Apr 2019 07:04:00 -0400
Date: Thu, 18 Apr 2019 13:03:56 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: WARNING in notify_change
Message-ID: <20190418110356.GC28541@quack2.suse.cz>
References: <94eb2c0ce3aa7551d30569658325@google.com>
 <96c750b3-fcb0-3d7f-45eb-45459078ef83@I-love.SAKURA.ne.jp>
 <CACGdZYLPLF40cUK+-aZ6O4vOR1YLvHzLJ70SFneKJ7KOXwBOug@mail.gmail.com>
 <20190415235428.GS2217@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190415235428.GS2217@ZenIV.linux.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Khazhismel Kumykov <khazhy@google.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, syzbot <syzbot+2b74da47f048a5046135@syzkaller.appspotmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, syzkaller-bugs@googlegroups.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org

On Tue 16-04-19 00:54:28, Al Viro wrote:
> On Mon, Apr 15, 2019 at 04:20:17PM -0700, Khazhismel Kumykov wrote:
> > I was able to reproduce this by setting security.capability xattr on a
> > blockdev file, then writing to it - when writing to the blockdev we
> > never lock the inode, so when we clear the capability we hit this
> > lockdep warning.
> > 
> > Is the issue here that we can set this xattr in the first place so we
> > have to clear it at all? Or should we really be locking the inode for
> > blockdevs after all? I'm not too familiar, but my gut says former
> 
> More interesting question is, WTF do we even touch that thing for
> bdev?  The thing is, mknod will cheerfully create any number of
> different filesystem objects, all giving access to the same block
> device.  Which of them should have that xattr removed?  It makes
> no sense whatsoever; moreover, who *cares* about caps for block
> device in the first place?
> 
> And if we did, what of another way to modify the block device?
> You know, mount it read-write...

Yes, Alexander Lochman has sent a patch to silence this warning back in
February [1] by just bailing out from file_remove_privs() for non-regular
files.  But so far you've ignored that patch... Will you pick it up please?

								Honza

[1] https://lore.kernel.org/lkml/cbdc8071-de76-bb0a-6890-15ef21023a70@tu-dortmund.de

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
