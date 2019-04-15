Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:43588 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728101AbfDOXyi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Apr 2019 19:54:38 -0400
Date: Tue, 16 Apr 2019 00:54:28 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: WARNING in notify_change
Message-ID: <20190415235428.GS2217@ZenIV.linux.org.uk>
References: <94eb2c0ce3aa7551d30569658325@google.com>
 <96c750b3-fcb0-3d7f-45eb-45459078ef83@I-love.SAKURA.ne.jp>
 <CACGdZYLPLF40cUK+-aZ6O4vOR1YLvHzLJ70SFneKJ7KOXwBOug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGdZYLPLF40cUK+-aZ6O4vOR1YLvHzLJ70SFneKJ7KOXwBOug@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Khazhismel Kumykov <khazhy@google.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, syzbot <syzbot+2b74da47f048a5046135@syzkaller.appspotmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, syzkaller-bugs@googlegroups.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org

On Mon, Apr 15, 2019 at 04:20:17PM -0700, Khazhismel Kumykov wrote:
> I was able to reproduce this by setting security.capability xattr on a
> blockdev file, then writing to it - when writing to the blockdev we
> never lock the inode, so when we clear the capability we hit this
> lockdep warning.
> 
> Is the issue here that we can set this xattr in the first place so we
> have to clear it at all? Or should we really be locking the inode for
> blockdevs after all? I'm not too familiar, but my gut says former

More interesting question is, WTF do we even touch that thing for
bdev?  The thing is, mknod will cheerfully create any number of
different filesystem objects, all giving access to the same block
device.  Which of them should have that xattr removed?  It makes
no sense whatsoever; moreover, who *cares* about caps for block
device in the first place?

And if we did, what of another way to modify the block device?
You know, mount it read-write...
