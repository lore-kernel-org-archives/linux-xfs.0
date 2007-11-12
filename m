Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 Nov 2007 12:12:32 -0800 (PST)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lACKCJgm021636
	for <xfs@OSS.SGI.com>; Mon, 12 Nov 2007 12:12:22 -0800
Received: from from [127.0.0.1] (helo=base.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.66 #1)
	id 1Irfdk-0002j5-EH
	for <xfs@OSS.SGI.com>; Mon, 12 Nov 2007 20:12:12 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18232.45975.580521.962971@base.ty.sabi.co.UK>
Date: Mon, 12 Nov 2007 20:12:07 +0000
Subject: Re: xfs options
In-Reply-To: <473844ED.7080605@jamendo.com>
References: <473844ED.7080605@jamendo.com>
From: pg_xfs@xfs.for.sabi.co.UK (Peter Grandi)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <xfs@oss.sgi.com>

>>> On Mon, 12 Nov 2007 13:19:57 +0100, Amandine AUPETIT
>>> <amandine@jamendo.com> said:

amandine> Hi :) I have a 7tb XFS filesystem. [ ... ]

We dearly hope that you are using a 64 bit kernel, BTW.

amandine> So i'm trying to adapt the mount option to what I
amandine> need, and what I need is security. I want to be sure
amandine> that NONE of the files will be lost, even if there's a
amandine> power failure.

That's a very difficult goal, and one that requires quite a lot
of effort and choosing and testing carefully which hardware
components you use and carefully writing your applications.

amandine> For now, I just tried the noatime mount option, I know
amandine> there is a lot of options, but I don't really
amandine> understand what they stand for.

Then you are not yet in position to even judge whether the
following points make sense :-).

amandine> Do you have any suggestion to make my filesystem safer
amandine> ?

Making your *filesystem* safer seems a bit pointless to me, what
seems to matter to you is "NONE of the files will be lost", and
as to that I am assuming that you mean that even if the file has
just been written.

Then the most important and essential thing is to ensure that
that whole storage chain (application, kernel, host adapter,
disk drive) supports disabling (or flushing) their caches, and
that every element of the chain returns and passes up reliable
success or error indications.

Achieving this is not at all simple; many manufacturers do not
supply this information about their products, or they give it
wrong, or anyhow the implementation is buggy no matter what the
documentation says. Finding a storage chain that can reliably
flush data from an application to the storage medium or return a
reliable error indication if that fails is far from easy.

Anyhow, in particular it is very important that the application
writing the files avoid the use of caching (e.g. no use of
'stdio') or use software barriers (e.g. 'fflush' and 'fsync') at
the right times (whuch can be just after every write).

Then by far the safest way to setup things, if the above
conditions have been met, is to disable write caching
everywhere:

* To disable caching in the host adapter/HBA, there is usually
  an option in the BIOS/fw.

* To disable caching in the individual disks, use 'hdparm -W0'
  or equivalent.

* To disable kernel caching, mount the filesystem with '-o sync'.

This will make writes *much* slower (typically at least ten
times slower), but it is safe (except that partial writes may
still fail, and to prevent that battery backup for every element
of the storage chain is needed).

If the decrease in speed is too much, there are less safe but
but still fairly good approaches based on using periodic write
barriers instead of simply disabling caching.

This requires ensuring that the whole storage chain support fine
or coarse grained write barriers with proper error reporting,
which again is far from trivial, and in addition there must be
sufficient battery backup for every element of the storage chain
in which data may be cached until the write barrier is exercised.

This thread may be interesting:

  http://OSS.SGI.com/archives/xfs/2007-03/msg00157.html

And perhaps these FAQs:

  http://OSS.SGI.com/projects/xfs/faq.html#wcache
