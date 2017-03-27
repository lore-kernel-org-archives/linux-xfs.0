Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26758 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751677AbdC0Udb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 16:33:31 -0400
Date: Mon, 27 Mar 2017 13:32:58 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2 V2] xfs_io: move stat functions to new file
Message-ID: <20170327203257.GL5722@birch.djwong.org>
References: <05b4710f-8459-6386-244b-9df2db8398f9@sandeen.net>
 <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net>
 <6207.1490646367@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6207.1490646367@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Mar 27, 2017 at 09:26:07PM +0100, David Howells wrote:
> Eric Sandeen <sandeen@sandeen.net> wrote:
> 
> > diff --git a/io/Makefile b/io/Makefile
> 
> What do I apply this to?  I don't see any directory or file called "io" in
> xfstests-dev/master.

This is a patch series against xfsprogs to add a statx command to
xfs_io(8).  Eric wired up statx into a command line tool so that you can
write more easily the xfstests cases to exercise the new syscall.

--D

> 
> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
