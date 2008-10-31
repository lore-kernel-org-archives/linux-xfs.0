Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 31 Oct 2008 08:38:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9VFbx5u017570
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 08:38:00 -0700
Received: from spike.porcupine.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0DD3AB2575C
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 08:38:00 -0700 (PDT)
Received: from spike.porcupine.org (spike.porcupine.org [168.100.189.2]) by cuda.sgi.com with ESMTP id zUFGfBVMjtEc6jyq for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 08:38:00 -0700 (PDT)
Subject: Re: Which FileSystem do you use on your postfix server?
In-Reply-To: <490B1C8B.7010607@sandeen.net> "from Eric Sandeen at Oct 31, 2008
 09:56:11 am"
Date: Fri, 31 Oct 2008 11:37:58 -0400 (EDT)
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20081031153758.EF0521F3E9E@spike.porcupine.org>
From: wietse@porcupine.org (Wietse Venema)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Postfix users <postfix-users@postfix.org>, xfs@oss.sgi.com, wietse@porcupine.org

Eric Sandeen:
> > This
> > would violate a basic requirement of Postfix (don't lose data after
> > fsync).  Postfix updates existing files all the time: it updates
> > queue files as it marks recipients as done, and it updates mailbox
> > files as it appends mail.
> 
> As long as postfix is looking after data properly with fsyncs etc, xfs
> should be perfectly safe w.r.t. data integrity on a crash.  If you see
> any other behavior, it's a *bug* which should be reported, and I'm sure
> it would be fixed.  As far as I know, though, there is no issue here.

The specific question is, will unclean shutdown cause loss of data
that was already fsynced, when the file was updated after the fsync.
For example, if the on-disk file metadata is updated after the file
data is appended, then there is no need to have a zero-fill problem
after crash during append.

What if the crash happens after Postfix requests a 1-byte write in
the middle of a file, i.e. without changing the size? A reasonable
implementation would not corrupt the file, but would either update
the file data or not change it. I can deal with that.

	Wietse
