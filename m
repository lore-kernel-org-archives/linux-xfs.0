Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Sep 2007 07:40:31 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8SEeMYl031525
	for <xfs@oss.sgi.com>; Fri, 28 Sep 2007 07:40:27 -0700
Message-ID: <46FD1256.6080201@sandeen.net>
Date: Fri, 28 Sep 2007 09:40:22 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: kernel 2.6.9-42ELsmp
References: <cce360c30709272255h411c368foa07c831a68ce537a@mail.gmail.com>
In-Reply-To: <cce360c30709272255h411c368foa07c831a68ce537a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Manoj Kumar Pradhan <manojkp80@gmail.com>
Cc: xfs@oss.sgi.com

Manoj Kumar Pradhan wrote:
> Hi,
> 
> I am trying to build my RH kernel for XFS dmapi support. I learnt from your
> site that the correct kernel can be cvs checkout from oss.sgi.com. I tried
> the procedure indicated there to do so, but i cant login to ':
> psrever:cvs@oss.sgi.com:/cvs' with password "cvs". It says connection timed
> out.

You might try again:

liberator:~/cvs sandeen$ export CVSROOT=':pserver:cvs@oss.sgi.com:/cvs'
liberator:~/cvs sandeen$ cvs login
Logging in to :pserver:cvs@oss.sgi.com:2401/cvs
CVS password:
liberator:~/cvs sandeen$ cvs co linux-2.6-xfs
cvs checkout: Updating linux-2.g-xfs
U linux-2.6-xfs/COPYING
U linux-2.6-xfs/CREDITS
^Ccvs [checkout aborted]: received interrupt signal
liberator:~/cvs sandeen$

works for me.  Note, though, that the kernel you'll be checking out is
not a RHEL4 kernel, but something more bleeding-edge, 2.6.23-rcX or so.

> Is there any other way to get the kernel?
> Also I learnt that XFS dmapi is not supported on RHEL4, is it?

Like I said last time, no, at least not as far as I can remember.
Although, now that I think harder, I think most of what dmapi needs is
there, though, so depending on what you're doing, it may mostly work.
Sorry, but I just don't remember all the details.  Feel free to get the
dmapi sources from the 2.6 tree, build against rhel4, and test.  With
some minor massaging, you could build dmapi as an external module.  What
are your plans for using it, if I may ask?

> Is there any list of RHEL kernel releases which can support XFS with DMAPI
> on x86_64 platforms?

None that are official.  SGI has shipped dmapi-capable RHEL4 kernels
with CXFS, and that part is all GPL, so perhaps someone @sgi could take
pity on you, or if you find someone who runs CXFS on RHEL4, they could
give you the src.rpms :)

-Eric
