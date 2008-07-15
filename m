Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Jul 2008 18:29:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6F1TGCj004423
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 18:29:16 -0700
Received: from elf.torek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3329C2EEB67
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 18:30:22 -0700 (PDT)
Received: from elf.torek.net (mail.torek.net [67.40.109.61]) by cuda.sgi.com with ESMTP id gG6nGISuyuxHZRZW for <xfs@oss.sgi.com>; Mon, 14 Jul 2008 18:30:22 -0700 (PDT)
Message-Id: <200807150129.m6F1THE23901@elf.torek.net>
From: Chris Torek <chris.torek@windriver.com>
Subject: Re: question about xfs_fsync on linux 
In-Reply-To: Your message of "Tue, 15 Jul 2008 09:03:00 +1000."
             <20080714230300.GY29319@disturbed>
Date: Mon, 14 Jul 2008 19:29:16 -0600
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

>What kernel(s), exactly, is/are showing this problem?

Well, that part is a bit tricky.  The base kernel is 2.6.21
but it has a lot of patches, including the one you mentioned.
(The customer is double checking to make sure they actually have
that patch in.)

>> We have a customer who is seeing data not "make it" to disk on a
>> stress test that involves doing an fsync() or fdatasync() and then
>> deliberately rebooting the machine (to simulate a failure; note
>> that the underlying RAID has its own battery backup and this is
>> just one of many different parts of the stress-test).
>
>What is the symptom? The file size does not change? The file the
>right size but has no data in it?

Their system has a large number of databases (on the order of 50)
all open simultaneously, and is using directIO (with a call to
fdatasync()) to make entries in many of them, and apparently *some*
of them get corrupted.  Exactly how, I do not know: naturally, we
cannot reproduce this with our own system, and when they tried a
simplified system with just one database the problem went away on
their end too.  (Agh.)

>No, the filemap_fdatawrite() has already been executed by this
>point [by do_fsync()].

D'oh!  I somehow missed this in eyeballing the code paths.

>However, I do ask exactly what kernel version you are running ...

It is mostly 2.6.21.  We brought in a large number of miscellaneous
XFS fixes, not including the ones that remove the "behavior" layer
stuff, but definitely including this one:

>http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;
>h=978b7237123d007b9fa983af6e0e2fa8f97f9934

(which of course necessitated a bit of hacking on the patches to
fit, as a lot of the later ones assume the bhv* layer has been
removed).

Chris
