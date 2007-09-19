Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 15:57:00 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8JMutuw031963
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 15:56:57 -0700
Message-ID: <46F1A936.8060706@sandeen.net>
Date: Wed, 19 Sep 2007 17:56:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Cant find sunit and swidth on luks encrypted raid6 device
References: <728b8e3b0709191129j27b7c319h2efd51ffc9cb64f3@mail.gmail.com>	 <46F17BBE.7060304@sandeen.net> <46F1A3D7.5090805@sandeen.net>	 <33249.192.168.3.1.1190241583.squirrel@mail.aconex.com>	 <46F1A703.6040309@sandeen.net> <728b8e3b0709191550q3adad31bx53e759f66808d8b@mail.gmail.com>
In-Reply-To: <728b8e3b0709191550q3adad31bx53e759f66808d8b@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Jochen K." <jochen.f.k@googlemail.com>
Cc: nscott@aconex.com, xfs@oss.sgi.com

Jochen K. wrote:
> Hi, Eric
> 
> Here is the output you wanted. I also did some debuging with strace but
> its kinda big to paste it in here.
> I also tried with the size option using a smaller device size which was
> working but still using wrong optimized values for the raid6 device.
> I guess you found the bug up there so should I add that and recompile
> xfsprogs to try again ?

Let's let Barry chime in.

I got off on a luks thing, saw "key lookup" and thought it was unique to
luks.  Didn't realize that message came from libxfs  :)  Oh well...

Also FWIW, the issue w/ sunit/swidth is unrelated to the error message.
 It has more to do with xfs not knowing how to get that geometry out of
the encrypted block device (and hmmm is it even relevant in that case?
As long as it just encrypts each individual block, I suppose it still is
relevant).

-Eric
