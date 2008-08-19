Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Aug 2008 23:28:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m7J6S7fr020930
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2008 23:28:08 -0700
Message-ID: <48AA6844.7000203@sgi.com>
Date: Tue, 19 Aug 2008 16:29:24 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: endianess macros
References: <20080814180856.GB3087@infradead.org>
In-Reply-To: <20080814180856.GB3087@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> This commit:
> 
> commit 413d57c9907c72ed608df2be72ef8ed13a3eeb46
> Author: Marcin Slusarz <marcin.slusarz@gmail.com>
> Date:   Wed Feb 13 15:03:29 2008 -0800
> 
>     xfs: convert beX_add to beX_add_cpu (new common API)
>         
>     remove beX_add functions and replace all uses with beX_add_cpu
> 
> which is in Linus tree never made it to the oss cvs tree.  It's doing
> this little change all over the place, so having it in both trees would
> be really useful..
> 

Yes, thanks I'll add this one into dev.
I'd really like to start changing stuff to minimise our
cvs/mainline differences.
It's time I did the diff like you and Lachlan have done :)

--Tim
