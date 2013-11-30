Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 206C57F54
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 18:18:42 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 01846304051
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 16:18:38 -0800 (PST)
Received: from mail-ve0-f177.google.com (mail-ve0-f177.google.com
	[209.85.128.177]) by cuda.sgi.com with ESMTP id
	I94UHCDK7en5M7kA (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 Nov 2013 16:18:37 -0800 (PST)
Received: by mail-ve0-f177.google.com with SMTP id db12so7256985veb.36
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 16:18:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131129235537.GX10323@ZenIV.linux.org.uk>
References: <20131128225102.GS10988@dastard>
	<20131128234441.GQ10323@ZenIV.linux.org.uk>
	<CA+55aFxLZxy75fO4ZXO4Stiu1sMx1q=eJ7HSk-UTCX61jPrirA@mail.gmail.com>
	<20131129024121.GS10323@ZenIV.linux.org.uk>
	<20131129035939.GT10323@ZenIV.linux.org.uk>
	<20131129040658.GU10323@ZenIV.linux.org.uk>
	<20131129041416.GV10323@ZenIV.linux.org.uk>
	<20131129065941.GW10323@ZenIV.linux.org.uk>
	<20131129194438.GA11052@kroah.com>
	<CA+55aFxgPQq_1n8Pv6gmMk+=yX9YkA10y6EpS1ECY8OB8-wFig@mail.gmail.com>
	<20131129235537.GX10323@ZenIV.linux.org.uk>
Date: Fri, 29 Nov 2013 16:18:36 -0800
Message-ID: <CA+55aFw7xmens_+Db0bXCMn8NRbtjRXH69+cPz622YNBxEPfsw@mail.gmail.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com

On Fri, Nov 29, 2013 at 3:55 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Look at the end of vfs_rmdir(); d_delete() in there will turn dentry
> negative if nobody else hold references to it.  So yes, dentry of
> directory *can* go negative under you, unless you've grabbed a reference.
> Which we do not do in RCU mode, obviously.

Ugh. Right you are. I thought we tried to avoid that, but clearly we don't.

I wonder if we could try to avoid it, just unhash and kill the dentry.
And then do this all at dentry release time instead (so after the
appropriate RCU grace period). Because it really would be lovely if
d_inode was stable.

But I guess we might have filesystems that expect the synchronous
d_iput() for last use, and maybe there's even some performance
advantage to re-using the dentry for some loads..

            Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
