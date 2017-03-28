Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:16879 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753119AbdC1XS0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Mar 2017 19:18:26 -0400
Date: Wed, 29 Mar 2017 10:18:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_io: changes to statx interface [ver #2]
Message-ID: <20170328231821.GK17542@dastard>
References: <3791d155-b448-5257-d8b9-8a6f20e12180@sandeen.net>
 <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net>
 <29458.1490711932@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29458.1490711932@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Mar 28, 2017 at 03:38:52PM +0100, David Howells wrote:
> Here are my current changes to Eric's statx interface patch.  I've made it
> analoguous to the stat command and so it only does statx-of-fd.
> 
> I've made the "-m" flag able to take the words "basic" and "all" in
> preference to a number and able to take an octal or hex number as an
> alternative too.
> 
> I've dropped the -A and -L flags since it no longer passes a path over.
> 
> Finally, I've added a -c flag that causes an fstat() to be done as well and
> the buffers compared as a consistency check.
> 
> David
> ---
> diff --git a/io/stat.c b/io/stat.c
> index a7aebcd..961b6d1 100644
> --- a/io/stat.c
> +++ b/io/stat.c
> @@ -189,12 +189,10 @@ statx_help(void)
>  " Display extended file status.\n"
>  "\n"
>  " Options:\n"
> -" -m mask -- Specify the field mask for the statx call (default STATX_ALL)\n"
> -" -A -- Suppress terminal automount traversal\n"
> +" -c -- Compare against fstat/fstatat on the same file/fd\n"

Running "compare" tests like this is not a function that xfs_io
should perform. Have it run and output the statx information,
and use xfstests to compare that against a golden output and/or
the output of the xfs_io stat command.

i.e. xfs_io is a utility for executing commands, whilst xfstests is
used to test that the executed functionality has the correct output.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
