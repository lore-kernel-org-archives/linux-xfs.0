Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 31 May 2008 06:24:00 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4VDNvlH001250
	for <xfs@oss.sgi.com>; Sat, 31 May 2008 06:23:58 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 810341B32B6B
	for <xfs@oss.sgi.com>; Sat, 31 May 2008 06:24:50 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id gYktaQKnxaP2FjB0 for <xfs@oss.sgi.com>; Sat, 31 May 2008 06:24:50 -0700 (PDT)
Date: Sat, 31 May 2008 09:24:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] always set a/c/mtime through ->setattr
Message-ID: <20080531132444.GA22936@infradead.org>
References: <20080520060838.GA6436@lst.de> <E1JyMSu-0001au-96@pomaz-ex.szeredi.hu> <20080520083351.GA14826@lst.de> <E1JzFFa-0008VR-9B@pomaz-ex.szeredi.hu> <20080531132048.GA4201@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080531132048.GA4201@ZenIV.linux.org.uk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, hch@lst.de, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, Artem.Bityutskiy@nokia.com

On Sat, May 31, 2008 at 02:20:48PM +0100, Al Viro wrote:
> And there's one more problem, promising very ugly code review: locking
> rules for notify_change() had suddenly changed - you are calling it
> without i_mutex now.  And ext3_setattr() is not happy - especially due
> to this blind call of ext3_orphan_del() in there.  We can easily fix
> that one, but you'll need to audit the rest of instances...

Yeah, I've actually started an audit of the setattr instance and there's
even more crap turning up.  I'm working on a bigger series to sort these
things out.
