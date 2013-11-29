Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B8AC929E04
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 20:07:32 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 97B0F304053
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 18:07:29 -0800 (PST)
Received: from mail-vb0-f47.google.com (mail-vb0-f47.google.com
	[209.85.212.47]) by cuda.sgi.com with ESMTP id 1aLgdvrXA8WWzAop
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 28 Nov 2013 18:07:28 -0800 (PST)
Received: by mail-vb0-f47.google.com with SMTP id x11so6321146vbb.34
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 18:07:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131128234441.GQ10323@ZenIV.linux.org.uk>
References: <20131124140413.GA19271@infradead.org>
	<20131124152758.GL10323@ZenIV.linux.org.uk>
	<20131125160648.GA4933@infradead.org>
	<20131126131134.GM10323@ZenIV.linux.org.uk>
	<20131126141253.GA28062@infradead.org>
	<20131127064351.GN10323@ZenIV.linux.org.uk>
	<20131127100906.GA19740@infradead.org>
	<20131128162618.GO10323@ZenIV.linux.org.uk>
	<20131128212301.GP10323@ZenIV.linux.org.uk>
	<20131128225102.GS10988@dastard>
	<20131128234441.GQ10323@ZenIV.linux.org.uk>
Date: Thu, 28 Nov 2013 18:07:27 -0800
Message-ID: <CA+55aFxLZxy75fO4ZXO4Stiu1sMx1q=eJ7HSk-UTCX61jPrirA@mail.gmail.com>
Subject: Re: inode_permission NULL pointer dereference in 3.13-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
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
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com

On Thu, Nov 28, 2013 at 3:44 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
>         * d_count(dentry) is -128
>         * dentry->d_inode is NULL
>
> In other words, what we get is an extra dput() somewhere.  The trouble is,
> all likely places I'm seeing in the "RCU'd vfsmounts" seem to be OK...
> In theory, we might be hitting a _missing_ dput(), with counter wrapping
> around, but that doesn't seem likely...

So d_count = -128 means that it's dead (see lockref_mark_dead). So it
goes from 0 (last refcount entry) to dead when it transitions into
dentry_kill. Which explains the inode being NULL too, because that
means it's gone through dentry_iput() as well.

And if it was just a normal dentry being passed around as the result
of a lookup, then because we still have LOOKUP_RCU set, such a dentry
is technically "valid" - it just hasn't gotten to the point where
we'll fail it.

HOWEVER. It's certainly *not* valid if "current->fs->root/pwd" points
to it. So yeah, there must have been an extra dput() somewhere. Or,
more likely, I think, we don't get the refcount to some dentry
properly any more.

I don't see where, though. You did change where "LOOKUP_RCU" is
cleared in unlazy_walk() but you did add that

        nd->path.dentry = NULL;

and that looks like it should be ok. And I don't see what else would care.

                   Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
