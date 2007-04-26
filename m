Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Apr 2007 03:44:21 -0700 (PDT)
Received: from nz-out-0506.google.com (nz-out-0506.google.com [64.233.162.225])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3QAiFfB007454
	for <xfs@oss.sgi.com>; Thu, 26 Apr 2007 03:44:18 -0700
Received: by nz-out-0506.google.com with SMTP id m22so615477nzf
        for <xfs@oss.sgi.com>; Thu, 26 Apr 2007 03:44:15 -0700 (PDT)
Message-ID: <9a8748490704260317u211c244au3c5478ac02c12c43@mail.gmail.com>
Date: Thu, 26 Apr 2007 12:17:47 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: 2.6.20.3 - possible recursive locking detected - in XFS
In-Reply-To: <20070425233345.GN48531920@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200704251116.57737.jesper.juhl@gmail.com>
	 <20070425233345.GN48531920@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs-masters@oss.sgi.com, xfs@oss.sgi.com, viro@zeniv.linux.org.uk

On 26/04/07, David Chinner <dgc@sgi.com> wrote:
> On Wed, Apr 25, 2007 at 11:16:57AM +0200, Jesper Juhl wrote:
> >
> > Hi,
> >
> > For your information :
> >
> > Once in a while I see the message below after I've just created a new XFS filesystem, mount it and then start copying data to it.
>
> .....
>
> > =============================================
> > [ INFO: possible recursive locking detected ]
> > 2.6.20.3generic #1
> > ---------------------------------------------
> > xfs_fsr/6117 is trying to acquire lock:
> >  (&(&ip->i_lock)->mr_lock){----}, at: [<f929422d>] xfs_ilock+0x7d/0xa0 [xfs]
> >
> > but task is already holding lock:
> >  (&(&ip->i_lock)->mr_lock){----}, at: [<f929422d>] xfs_ilock+0x7d/0xa0 [xfs]
>
> Known false positive - XFS doesn't have the annotations needed for
> this yet; we've got a patch that will probably make it's way into 6.5.22 that
> should fix most of these issues.
>
Ok. Thanks for the feedback.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
