Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Oct 2007 03:41:54 -0700 (PDT)
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.234])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9IAfjUA000536
	for <xfs@oss.sgi.com>; Thu, 18 Oct 2007 03:41:48 -0700
Received: by wr-out-0506.google.com with SMTP id c48so123758wra
        for <xfs@oss.sgi.com>; Thu, 18 Oct 2007 03:41:47 -0700 (PDT)
Message-ID: <cc7060690710180315q65b66c40m74f4e4c80f890d5f@mail.gmail.com>
Date: Thu, 18 Oct 2007 15:45:05 +0530
From: "Bhagi rathi" <jahnu77@gmail.com>
Subject: Re: Slow seek in kernels >= 2.6.18
In-Reply-To: <4717156C.3030308@firma.seznam.cz>
MIME-Version: 1.0
References: <4717156C.3030308@firma.seznam.cz>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Anton A Vorobev <anton.vorobev@firma.seznam.cz>
Cc: xfs@oss.sgi.com

Is it the same on ext file-systems?

Can you run the same tests on disk devices directly to rule out scheduling
issues of  i/o requests
by device drivers?  One way I was thinking that we got a kind of cache
pollution or invalidation
thus exposing to do more seeks.  Can you tell the equivalent file-system
operations that your
application in general do? This will give a lot of insight on what could be
happening.

-Bhagi.

On 10/18/07, Anton A Vorobev <anton.vorobev@firma.seznam.cz> wrote:
>
> Hi!
>
> A question. We've got an application that runs about 30-40 minutes.
> After kernel upgrade from 2.6.17 branch, it runs about 3 hours.
> I've made tests with the help of bonnie++, it shows that random seek
> operations are about 3 times slower in kernels newer than 2.6.18 in
> comparison with 2.6.17. This difference may be seen only during high
> load of a server. When it is in normal state, parameters are rather the
> same.
>
> We use XFS filesystem. Does any one know may it be because of upgrade of
> XFS driver in kernel? Any ideas?
>
> Thanks a lot.
>
> ______________________________________________________________
> Anton Vorobev
> Program=E1tor
> Seznam.cz, a.s. Radlick=E1 608/2 150 00 Praha 5
>
> tel.: +420 234 694 706
> fax: +420 234 694 115
> anton.vorobev@firma.seznam.cz
> http://www.seznam.cz
>
>
>
>


[[HTML alternate version deleted]]
