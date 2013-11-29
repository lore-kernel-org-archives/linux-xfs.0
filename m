Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 98E7F7F52
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 20:17:58 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3635CAC009
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 18:17:55 -0800 (PST)
Received: from mail-ve0-f179.google.com (mail-ve0-f179.google.com
	[209.85.128.179]) by cuda.sgi.com with ESMTP id
	cwswQXW3cCVuhrB8 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 18:17:54 -0800 (PST)
Received: by mail-ve0-f179.google.com with SMTP id jw12so6496499veb.38
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 18:17:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131129020703.GR10323@ZenIV.linux.org.uk>
References: <20131125160648.GA4933@infradead.org>
	<20131126131134.GM10323@ZenIV.linux.org.uk>
	<20131126141253.GA28062@infradead.org>
	<20131127064351.GN10323@ZenIV.linux.org.uk>
	<20131127100906.GA19740@infradead.org>
	<20131128162618.GO10323@ZenIV.linux.org.uk>
	<20131128212301.GP10323@ZenIV.linux.org.uk>
	<20131128225102.GS10988@dastard>
	<20131128234441.GQ10323@ZenIV.linux.org.uk>
	<20131129014648.GU10988@dastard>
	<20131129020703.GR10323@ZenIV.linux.org.uk>
Date: Thu, 28 Nov 2013 18:17:53 -0800
Message-ID: <CA+55aFzQrUwZx76bS7g+_COpMiRUm2a42n32BK653AYb4DRnvA@mail.gmail.com>
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

On Thu, Nov 28, 2013 at 6:07 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>    Thus the
> comment about unbalanced dput() somewhere; the question is _where_ had
> that dput() been.

Clearing the LOOKUP_RCU bit is what I was looking at, because doing
that without doing the proper successful lockref_get_not_dead() ends
up being equivalent to missing a dget(), not an extra dput(). Which
was why I was looking at unlazy_walk() -> terminate_walk().

But I really don't see anything wrong. That was the only really
obvious sequence where you changed things. Everything else seems to be
a pretty 1:1 conversion.

            Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
