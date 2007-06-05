Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Jun 2007 16:25:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l55NP4Wt015325
	for <xfs@oss.sgi.com>; Tue, 5 Jun 2007 16:25:06 -0700
Date: Wed, 6 Jun 2007 09:24:57 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Reporting a bug
Message-ID: <20070605232457.GA85884050@sgi.com>
References: <d9c0b9d90706041910t15584e05y16e7eba660c96d51@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d9c0b9d90706041910t15584e05y16e7eba660c96d51@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?iso-8859-1?Q?Germ=E1n_Po=F3-Caama=F1o?= <german.poo@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Jun 04, 2007 at 10:10:06PM -0400, Germán Poó-Caamaño wrote:
> I having have some problems with a XFS partition in Debian Sarge:
> 
> After a clean reboot (it supposed to be), my machine started with
> kernel messages of problems, such us XFS_WANT_CORRUPTED_GOTO and
> XFS_WANT_CORRUPTED_RETURN.
> 
> It mainly was located in /var.  But, after cleaning that, I checked
> other partitions.  I guessed that my root partition (/dev/sda5) was in
> problems also.  I mounted as readonly partition and  I ran xfs_repair
> on it.  xfs_repair moved 6 files (all of them ELF binaries) to
> lost+found.  After reboot the machine, it can't boot anymore.

Sounds like a critical binary for boot got lost...

> Trying with Sysrescue 0.3.5 I get the following:

What version of the XFS utilities has that got?
You might do better booting knoppix and then downloading the
latest tools and running them....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
