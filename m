Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:35861 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751227AbcLELDB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Dec 2016 06:03:01 -0500
Date: Mon, 5 Dec 2016 22:02:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_io: support -c <cmd> without <file> args
Message-ID: <20161205110257.GC4326@dastard>
References: <1480921485-14888-1-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1480921485-14888-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Mon, Dec 05, 2016 at 09:04:45AM +0200, Amir Goldstein wrote:
> There is an undocumented and possibly unused feature in xfs_io
> where all commands are executed per file given in the file args list.
> 
> This feature creates ambiguity when trying to execute commands
> such as "open" and "file" from command line.
> 
> When running xfs_io -c <cmd> without any file args, xfs_io exits
> without doing anything. This behavior is undocumented and does not
> make much sense either.
> 
> Change the behavior in the case where no file args are given in
> command line to execute every command exactly once, exactly as if
> the commands where executed from an interactive shell.
> 
> This enables writing proper xfs_io scripts in command line, which
> include "open" and "file" commands.

NACK.

This does not fix any of the underlying problems. It just adds
another WTF case to CLI processing as two things that should be
equivlent now behave differently. i.e.

$ xfs_io -c "open foo" -c "open bar" -c file

and 

$ xfs_io -c "open bar" -c file foo

will have different behaviour, even though the man page says they
should be equivalent and do exactly the same thing.

Fix the underlying problems once and for all: do not hack bandaids
into the code that only hides the symptom for your specific use
case.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
