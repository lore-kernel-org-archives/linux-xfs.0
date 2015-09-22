Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2EC8B7F37
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 14:25:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0DBF98F8035
	for <xfs@oss.sgi.com>; Tue, 22 Sep 2015 12:25:32 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id 3sbLCgbDOjVC9lE0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Sep 2015 12:25:29 -0700 (PDT)
Date: Tue, 22 Sep 2015 15:25:27 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH 1/2] VFS: Kill use of O_LARGEFILE inside the kernel
Message-ID: <20150922192527.GA3318@thunk.org>
References: <20150922155104.GA2296@thunk.org>
	<20150922152450.32539.55285.stgit@warthog.procyon.org.uk>
	<1458.1442938362@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1458.1442938362@warthog.procyon.org.uk>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org

On Tue, Sep 22, 2015 at 05:12:42PM +0100, David Howells wrote:
> 
> Further, path-based truncate() makes no checks based on file-largeness, unlike
> ftruncate().

Right, but truncate in general is used to make files *smaller* so I'm
having trouble thinking of a scenario where a largefile-oblivious
program could get in trouble by truncating a file > 2TB to some
hard-coded length (normally zero).

> Overlayfs and one or two other places need to potentially apply O_LARGEFILE to
> the things that they do on behalf of userspace - but other than suppressing
> some size checks, it seems to be ignored by the filesystems and the VM.

The size checks really were the primary points of O_LARGEFILE.  As I
recall the primary system calls where this really matters is open(2)
and stat(2) (since if st_size is too small to represent the size of
the file, then the user space program could get really confused).

Essentially O_LARGEFILE is an assertion that userspace can handle
handle 64-bit files, and won't get confused by system call interfaces
where off_t is 32-bit wide, because it will use the 64-bit variants.
So it's not at all surprising that the file systems and the VM in
general doesn't need to worry about the flag.

    	       	   	      	      - Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
