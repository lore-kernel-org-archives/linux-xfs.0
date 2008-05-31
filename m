Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 31 May 2008 06:20:05 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4VDJxkm000701
	for <xfs@oss.sgi.com>; Sat, 31 May 2008 06:20:01 -0700
Received: from ZenIV.linux.org.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D614F1B32B4F
	for <xfs@oss.sgi.com>; Sat, 31 May 2008 06:20:52 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by cuda.sgi.com with ESMTP id L9wLfyYQy0Lx1G1G for <xfs@oss.sgi.com>; Sat, 31 May 2008 06:20:52 -0700 (PDT)
Date: Sat, 31 May 2008 14:20:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] always set a/c/mtime through ->setattr
Message-ID: <20080531132048.GA4201@ZenIV.linux.org.uk>
References: <20080520060838.GA6436@lst.de> <E1JyMSu-0001au-96@pomaz-ex.szeredi.hu> <20080520083351.GA14826@lst.de> <E1JzFFa-0008VR-9B@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JzFFa-0008VR-9B@pomaz-ex.szeredi.hu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@lst.de, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, Artem.Bityutskiy@nokia.com

On Thu, May 22, 2008 at 08:10:50PM +0200, Miklos Szeredi wrote:

> But there are quite a few others which don't call inode_setattr (which
> means that the unchanged time optimization is lost), or which do
> something possibly slow in their ->setattr():
> 
>  adfs, 9p, afs, coda, gfs2 ...
> 
> just to name a few at the start of the alphabet.
> 
> So it looks to me as this could cause some unintended performance
> regressions in these filesystems.

Actually, there's worse one: ext3.  It *does* call inode_setattr(),
all right, but then it proceeds to call ext3_orphan_del().  Which
will
        lock_super(inode->i_sb);
        if (list_empty(&ei->i_orphan)) {
                unlock_super(inode->i_sb);
                return 0;
        }
and bugger off, but...
	* it's going to cost us
	* code in _caller_ is bogus - we call that sucker regardless of
whether we had ATTR_SIZE in ia_valid

And there's one more problem, promising very ugly code review: locking
rules for notify_change() had suddenly changed - you are calling it
without i_mutex now.  And ext3_setattr() is not happy - especially due
to this blind call of ext3_orphan_del() in there.  We can easily fix
that one, but you'll need to audit the rest of instances...
