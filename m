Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Dec 2006 13:40:33 -0800 (PST)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBKLeQqw029236
	for <xfs@oss.sgi.com>; Wed, 20 Dec 2006 13:40:28 -0800
Subject: Re: [PATCH] rethink removal of xattr syscall stubs (for now)
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <45895EBA.8010208@sgi.com>
References: <1166490658.5572.89.camel@edge>
	 <20061219100506.GA22779@infradead.org> <1166571069.5572.117.camel@edge>
	 <45895EBA.8010208@sgi.com>
Content-Type: text/plain
Date: Thu, 21 Dec 2006 08:40:31 +1100
Message-Id: <1166650831.5572.164.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, bnaujok@sgi.com, xfs@oss.sgi.com, agruen@suse.de

On Wed, 2006-12-20 at 16:03 +0000, Lachlan McIlroy wrote:
> Nathan Scott wrote:
> > On Tue, 2006-12-19 at 10:05 +0000, Christoph Hellwig wrote:
> > | > Please apply as an interim fix to the original problem and to
> > | > the accidental new problems its caused, and I'll push through a
> > | > new patch in the new year.
> > | 
> > | There is a way to re-export symbols you imported from another
> > | library with symbol versioning.  That how for example libpthread
> > | works on recent Solaris versions.  I'll find out how exactly that
> > | should be implemented.
> > 
> > Ah, that sounds ideal - thanks!
> > 
> 
> Nathan, do you still need your patch applied or will you look into
> this new approach instead?
> 

The patch needs to be applied, thanks.  At a later date we'll fix it
differently, but that will take some time.

cheers.

-- 
Nathan
