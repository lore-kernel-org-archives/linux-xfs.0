Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E3CE17F37
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 00:59:56 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5FB26AC002
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 22:59:56 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id gZMDgjbq2Qyqg0T4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 22:59:55 -0800 (PST)
Date: Fri, 29 Nov 2013 06:59:41 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: inode_permission NULL pointer dereference in 3.13-rc1
Message-ID: <20131129065941.GW10323@ZenIV.linux.org.uk>
References: <20131127100906.GA19740@infradead.org>
	<20131128162618.GO10323@ZenIV.linux.org.uk>
	<20131128212301.GP10323@ZenIV.linux.org.uk>
	<20131128225102.GS10988@dastard>
	<20131128234441.GQ10323@ZenIV.linux.org.uk>
	<CA+55aFxLZxy75fO4ZXO4Stiu1sMx1q=eJ7HSk-UTCX61jPrirA@mail.gmail.com>
	<20131129024121.GS10323@ZenIV.linux.org.uk>
	<20131129035939.GT10323@ZenIV.linux.org.uk>
	<20131129040658.GU10323@ZenIV.linux.org.uk>
	<20131129041416.GV10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131129041416.GV10323@ZenIV.linux.org.uk>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com

On Fri, Nov 29, 2013 at 04:14:16AM +0000, Al Viro wrote:

> And yes, it has fixed the problem with generic/234.  I'll do full xfstests
> run to see if there's anything else, but this one is obviously needed.
> I'll send it with sane commit message (along with follow_dotdot_rcu()
> fix) later tonight.  path_init() race is a separate story - that one should
> probably go separately, since we'll want it in all branches starting with
> early 2011 or so.

OK, it survives.  However, looking a bit more at follow_dotdot_rcu()...
AFAICS, we have a narrow oopsable race, from 2.6.38 and to 3.12 - think what
happens if we are walking through /tmp/foo/bar/../baz in RCU mode and we'd just
reached /tmp/foo/bar.  handle_dotdot() is called, calling follow_dotdot_rcu().
OK, we are not about to cross a mountpoint.  Read ->d_seq of /tmp/foo into
seq, check that nd->seq matches /tmp/foo/bar (it does, everything's fine)
and set nd->path.dentry to /tmp/foo, with nd->seq set to seq.  Then
we check if the /tmp/foo is overmounted by something; it isn't and now we set
nd->inode.

Sure, it's _very_ hard to get into trouble here - we need somebody to remove
/tmp/foo/bar *and* /tmp/foo while we'd been walking vfsmount hash,
but in theory it is not impossible to get NULL nd->inode.  Then
link_path_walk() gets to checking that we have a directory and we get
an oops on checking inode flags.

I really don't like the way we have nd->inode updates scattered all over
the place in fs/namei.c ;-/  I'm looking into possible ways to deal
with it sanely, but that'll have to wait for tomorrow...

Anyway, I've pushed the minimal regression fix to vfs.git; please, pull
from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (1):
      fix bogus path_put() of nd->root after some unlazy_walk() failures

Diffstat:
 fs/namei.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
