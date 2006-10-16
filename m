Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Oct 2006 03:11:43 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9GABaaG012831
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 03:11:37 -0700
Received: from lucidpixels.com (lucidpixels.com [66.45.37.187])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED1D74AECAB
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 03:10:52 -0700 (PDT)
Date: Mon, 16 Oct 2006 06:10:49 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: FS corruption and repair problem
In-Reply-To: <20061016082532.GA5574@jdc>
Message-ID: <Pine.LNX.4.64.0610160609460.30044@p34.internal.lan>
References: <20061016082532.GA5574@jdc>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jason White <jasonjgw@internode.on.net>
Cc: xfs@oss.sgi.com



On Mon, 16 Oct 2006, Jason White wrote:

> This is my desktop system, running kernel 2.6.17.11. Kernel 2.6.17 was
> previously installed, but I upgraded several weeks ago after I found out about
> the corruption bug in 2.6.17, which may or may not be related to the
> following.
> 
> The file system was shut down during a Debian package upgrade while trying to
> access apt-related files. I booted into an old 2.4 kernel on a separate
> partition and ran an old version of xfs_repair. The output is attached.
> Xfs_repair terminated abnormally (see the end of the output).
> 
> I can copy a newer version of xfs_repair to the backup partition if that would
> help, though I'm not sure which libraries to copy along with it.
> 
> Also, if there is any indication of what might have caused this I would be
> interested, as this hasn't happened before and I'de especially like to find
> out whether it is a hardware problem, or related to the current kernel, or
> indeed a manifestation of the 2.6.17 bug. I've successfully mounted the
> corrupted file system and a lot of it is still relatively intact - plenty of
> files in lost+found, especially from the /usr/share/man3 directory for obvious
> reasons.
> 
> It's a straightforward desktop machine with an IDE drive. I haven't updated
> Debian packages on here for a while, so it isn't clear when the corruption
> happened.
> 
> 

Most likely if you booted and mounted the partition r/w with 2.6.17(.1-.6) 
then it is most likely a result of that.

Either follow the instructions on the XFS FAQ on how to fix the problem or 
re-install and bypass 2.6.17-2.6.17.6.

Backup your data first if possible before you do anything!

Justin.
