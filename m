Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C4FF67F3F
	for <xfs@oss.sgi.com>; Sat, 30 Nov 2013 09:10:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 500CBAC001
	for <xfs@oss.sgi.com>; Sat, 30 Nov 2013 07:10:01 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id 7QRdkBq1oYyAqzWf (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 30 Nov 2013 07:09:56 -0800 (PST)
Date: Sat, 30 Nov 2013 10:09:43 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] Re: inode_permission NULL pointer dereference in 3.13-rc1
Message-ID: <20131130150943.GH3778@thunk.org>
References: <20131128162618.GO10323@ZenIV.linux.org.uk>
	<20131128212301.GP10323@ZenIV.linux.org.uk>
	<20131128225102.GS10988@dastard>
	<20131128234441.GQ10323@ZenIV.linux.org.uk>
	<CA+55aFxLZxy75fO4ZXO4Stiu1sMx1q=eJ7HSk-UTCX61jPrirA@mail.gmail.com>
	<20131129024121.GS10323@ZenIV.linux.org.uk>
	<20131129035939.GT10323@ZenIV.linux.org.uk>
	<20131129040658.GU10323@ZenIV.linux.org.uk>
	<20131129041416.GV10323@ZenIV.linux.org.uk>
	<20131129065941.GW10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131129065941.GW10323@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, xfs@oss.sgi.com

On Fri, Nov 29, 2013 at 06:59:41AM +0000, Al Viro wrote:
> 
> Anyway, I've pushed the minimal regression fix to vfs.git; please, pull
> from
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus
> 
> Shortlog:
> Al Viro (1):
>       fix bogus path_put() of nd->root after some unlazy_walk() failures

Linus, could you please pull this fix from Al?  I can't do testing of
the ext4 tree without this fix, and I'd prefer not have my own merge
of Al's fix into my tree --- and I was hoping to start processing
patches for the ext4 tree now that -rc2 has been released, and Turkey
day is past.

Thanks!!

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
