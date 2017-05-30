Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28755 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750811AbdE3Srt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 May 2017 14:47:49 -0400
Date: Tue, 30 May 2017 11:47:39 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/9] xfs_spaceman: space management tool
Message-ID: <20170530184739.GC4519@birch.djwong.org>
References: <149417257252.24656.2629280196308754994.stgit@birch.djwong.org>
 <149417259522.24656.15381603363219279304.stgit@birch.djwong.org>
 <afec66aa-4c12-30e3-ff8d-896c5f3505d5@sandeen.net>
 <20170530173742.GW4519@birch.djwong.org>
 <48b4d991-4c77-4860-8a05-ba71bdda4056@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48b4d991-4c77-4860-8a05-ba71bdda4056@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Tue, May 30, 2017 at 01:17:56PM -0500, Eric Sandeen wrote:
> On 5/30/17 12:37 PM, Darrick J. Wong wrote:
> > On Fri, May 26, 2017 at 08:34:18PM -0500, Eric Sandeen wrote:
> >> On 5/7/17 10:56 AM, Darrick J. Wong wrote:
> >>> From: Dave Chinner <dchinner@redhat.com>
> >>>
> >>> xfs_spaceman is intended as a diagnostic and control tool for space
> >>> management operations within XFS. Operations like examining free
> >>> space, managing allocation policies, issuing block discards on free
> >>> space, etc.
> >>>
> >>> The tool is modelled on the xfs_io interface, allowing both
> >>> interactive and command line control of the tool, enabling it to be
> >>> used in scripts and automated management tools.
> >> This may be a result of the xfs_io ancestry, but:
> >>
> >> # xfs_spaceman /mnt/test2 /mnt/test
> >>
> >> Cool, we can open 2 files(ystems)
> >>
> >> xfs_spaceman> print
> >>  000  /mnt/test2     (non-sync,non-direct,read-write)
> >> [001] /mnt/test      (non-sync,non-direct,read-write)
> >>
> >> (what does non-direct mean for a mountpoint?)
> >> (actually where do these flags come from ... hm.)
> >>
> >> Yep there we are!  Now how do we switch to the other?
> >>
> >> xfs_spaceman> help
> >> help [command] -- help for one or all commands
> >> print -- list current open files
> >> quit -- exit the program
> >>
> >> Use 'help commandname' for extended help.
> >>
> >> hmmm... I guess we can't switch.  Should we be able to?
> >>
> >> Is the intent to open files or filesystems...  both?  Is there ever
> >> a reason to be opening a file not a filesystem?
> > <shrug> I mostly just passed on Dave's original patches from whenever
> > ago, but TBH I'm not 100% sure about the usecases for multiple
> > arguments.  The commands that spaceman has now are all fs-oriented, not
> > file-oriented... but maybe people want to be able to issue one command
> > against multiple fses?  OTOH all the commands provided so far are
> > oneshot, so they only act upon one open file.
> > 
> > So, I'm inclined to ditch the 'list' command and disallow multiple open
> > files, like Eric suggests, unless anyone really wants it?
> 
> Either way is fine: multiple (fs) targets with the ability to switch,
> or restrict to just one, but allowing one to open multiple and only
> use one makes little sense.

I think of all the commands we have, only trim and prealloc seem geared
towards being callable against all the paths specified in the command
line.  OTOH I don't see a lot of harm in letting people run reports
against multiple filesystems, though the output will be sort of messy.

I'll play around with removing the ONESHOT designation and see if that
doesn't turn into a horrible mess.

--D

> 
> -Eric
> 
> > --D
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
