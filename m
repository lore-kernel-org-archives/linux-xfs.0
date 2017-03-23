Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:32192 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751448AbdCWVig (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Mar 2017 17:38:36 -0400
Date: Fri, 24 Mar 2017 08:38:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Selectively backup based on specific date
Message-ID: <20170323213831.GF17542@dastard>
References: <0c190757-c4ac-ae5c-6e1c-b9be37470be5@lueckdatasystems.com>
 <1904662.EPkO7u6dZY@xrated>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1904662.EPkO7u6dZY@xrated>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: Michael Lueck <mlueck@lueckdatasystems.com>, linux-xfs@vger.kernel.org

On Thu, Mar 23, 2017 at 03:11:07PM +0100, Hans-Peter Jansen wrote:
> Hi Michael,
> 
> On Donnerstag, 23. März 2017 09:21:56 Michael Lueck wrote:
> > Greetings,
> > 
> > I am looking for the correct xfsdump syntax to backup dirs/files newer than
> > a certain date.
> 
> xfsdump is a tool in the tradition of unix filesystem dump utilities.
> Those always dump a full filesystem, and consequently, fully restore  
> filesystems only.

Not true. xfsdump/restore can backup directory subtrees just fine.
See, for example, the '-s pathname' option....

> > I have not found mention of such an option / capability within xfsdump.
> > Hopefully there is a creative way to do the selective backup.

xfsdump does "backup files changed since" operations via incremental
backups. i.e. if you want to backup only things changed since $DATE,
you first need to have run a dump that on $DATE, and you then do an
incremental dump which will contain only the changed files/dirs
since $DATE...

IOWs, xfsdump is designed to be used as part of a well-defined,
managed backup and disaster recovery strategy - it's not an ad-hoc
"copy random specification of files" tool.

> Using a linux derivate, there are plenty of more or less creative options to 
> selectively backup/restore arbitrary file systems, but this is rather OT for 
> the ML. 

The downside of these generic utilities is they are much slower than
xfsdump for large scale backup operations, they trash the
inode/dentry/page caches and they don't really support concurrent
operations needed to scale effectively. i.e.  if you need to dump
throughput of multiple GB/s, process tens/hundreds of millions of
files and/or drive multiple tape drives concurrently from a single
filesystem, then xfsdump is a much better option...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
