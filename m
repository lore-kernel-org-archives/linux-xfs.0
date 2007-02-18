Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 18 Feb 2007 05:54:21 -0800 (PST)
Received: from mail.edu.haifa.ac.il (mail.edu.haifa.ac.il [132.74.40.10])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1IDsDm7020154
	for <xfs@oss.sgi.com>; Sun, 18 Feb 2007 05:54:15 -0800
From: "Leon Kolchinsky" <leonk@construct.haifa.ac.il>
Subject: RE: xfs internal error on a new filesystem
Date: Sun, 18 Feb 2007 15:56:01 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="windows-1255"
Content-Transfer-Encoding: 7bit
In-Reply-To: <20070215161932.3230.qmail@info11.gawab.com>
Message-Id: <20070218135844.9300C14A856@mail.edu.haifa.ac.il>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Ahmed El Zein' <a.elzein@gawab.net>, 'David Chinner' <dgc@sgi.com>
Cc: "'Ramy M. Hassan '" <ramy@gawab.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

> >
> >> Do u recommend that we switch back to reiserfs ?
> >
> >Not yet.
> >
> >> Could it be a hardware related problems  ?
> >
> >Yes. Do you have ECC memory on your server? Have you run memtest86?
> >Were there any I/O errors in the log prior to the shutdown message?
> Yes, we have ECC memory.
> We will try to run memtest86 as soon as possible.
> There were no I/O errors in the log prior to the shutdown message.
> 
> Btw, this is a vmware image. /vol/6 is an exported physical partition.
> 

I've read that vmware do disk caching by default and we know xfs has problem
with when disaster strikes.

You definitely should disable disk caching on you side. 

> >Cheers,
> >
> >Dave.
> >--
> >Dave Chinner
> >Principal Engineer
> >SGI Australian Software Group
> >
>


Regards,
Leon Kolchinsky
 
