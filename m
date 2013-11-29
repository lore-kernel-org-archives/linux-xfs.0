Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7E29A7F50
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 14:17:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5CE8D304059
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 12:17:26 -0800 (PST)
Received: from mail-ve0-f180.google.com (mail-ve0-f180.google.com
	[209.85.128.180]) by cuda.sgi.com with ESMTP id
	jh4rimEVTHlskjOk (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 Nov 2013 12:17:24 -0800 (PST)
Received: by mail-ve0-f180.google.com with SMTP id jz11so7382591veb.11
	for <xfs@oss.sgi.com>; Fri, 29 Nov 2013 12:17:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131129194438.GA11052@kroah.com>
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
	<20131129194438.GA11052@kroah.com>
Date: Fri, 29 Nov 2013 12:17:23 -0800
Message-ID: <CA+55aFxgPQq_1n8Pv6gmMk+=yX9YkA10y6EpS1ECY8OB8-wFig@mail.gmail.com>
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
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com

On Fri, Nov 29, 2013 at 11:44 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> So, should d870b4a191a3 be queued up for
> -stable releases to resolve this issue there as well, or am I
> misunderstanding your post above?

No, the bug d870b4a191a3 fixes is new to the 3.13 merge window (it's
due to the newly RCU'd vfsmounts).

But Al seems to have found another race that has been around for a
while. But that's a separate issue, and there's no patch for that yet
(and nobody has ever hit it, because we'd scream bloody murder if they
did).

Al - even in your scenario I don't see a NULL nd->inode, because when
we do an rmdir we remove the dentry, we don't turn it into a negative
one. Afaik, it would be a violation of all our dentry rules to change
the dentry->d_inode field while the dentry is live. The only way to
get a negative dentry (ie d_inode == NULL) should be from lookup (and
from a rename that switches the dentries around, but even then the
d_inode _stays_ NULL, it's just that we move the dentry itself
around).

That said, I do agree that the games we play with "nd->inode" are not
at all obvious. And I'm not actually convinced we need "nd->inode" AT
ALL these days. We used to have it for other reasons, but afaik these
days the only actual users are

 - some sanity tests in the lookup code

 - a few "inode_permission()" calls that I suspect could equally well
just use path.dentry->inode. Because either the dentry is stable, or
we're in RCU lookup and we'll revalidate it anyway.

Maybe I'm wrong. But iirc, the big reason for 'nd->inode' originally
was that it was the inode that was verified against the dentry
sequence number that we then passed on as a stable inode to the
low-level filesysystems. But that whole calling convention got cleaned
up with commits 12f8ad4b0533 and da53be12bbb4, and I really think most
of the historical reasons for having that nd->inode have gone away.

I dunno. I didn't check the three remaining "inode_permission()"
users, and maybe I missed some other use too. So maybe it's still
required, but my initial reaction when looking at it was "why do we
even have it any more"?

            Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
