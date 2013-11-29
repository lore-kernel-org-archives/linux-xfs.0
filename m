Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 236D87F37
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 20:41:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A4CC1AC002
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 18:41:27 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id nQ5JGMuBmzCzBJxD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 18:41:26 -0800 (PST)
Date: Fri, 29 Nov 2013 02:41:21 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: inode_permission NULL pointer dereference in 3.13-rc1
Message-ID: <20131129024121.GS10323@ZenIV.linux.org.uk>
References: <20131125160648.GA4933@infradead.org>
	<20131126131134.GM10323@ZenIV.linux.org.uk>
	<20131126141253.GA28062@infradead.org>
	<20131127064351.GN10323@ZenIV.linux.org.uk>
	<20131127100906.GA19740@infradead.org>
	<20131128162618.GO10323@ZenIV.linux.org.uk>
	<20131128212301.GP10323@ZenIV.linux.org.uk>
	<20131128225102.GS10988@dastard>
	<20131128234441.GQ10323@ZenIV.linux.org.uk>
	<CA+55aFxLZxy75fO4ZXO4Stiu1sMx1q=eJ7HSk-UTCX61jPrirA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFxLZxy75fO4ZXO4Stiu1sMx1q=eJ7HSk-UTCX61jPrirA@mail.gmail.com>
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

On Thu, Nov 28, 2013 at 06:07:27PM -0800, Linus Torvalds wrote:

> HOWEVER. It's certainly *not* valid if "current->fs->root/pwd" points
> to it. So yeah, there must have been an extra dput() somewhere. Or,
> more likely, I think, we don't get the refcount to some dentry
> properly any more.
> 
> I don't see where, though. You did change where "LOOKUP_RCU" is
> cleared in unlazy_walk() but you did add that
> 
>         nd->path.dentry = NULL;
> 
> and that looks like it should be ok. And I don't see what else would care.

*nod*

BTW, vfsmount refcount is 12, so we *definitely* nowhere near the
final mntput(), etc. and mnt->mnt_root itself should also have
contributed.

I'm going to try to find out _which_ test buggers the refcount - at
least that way I'll have something resembling a usable reproducer...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
