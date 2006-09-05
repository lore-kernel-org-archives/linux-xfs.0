Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Sep 2006 15:36:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k85MZkDW022405
	for <xfs@oss.sgi.com>; Tue, 5 Sep 2006 15:35:58 -0700
Date: Wed, 6 Sep 2006 08:34:48 +1000
From: Nathan Scott <nathans@xfs.org>
Subject: race in xfs_rename? (fwd)
Message-ID: <20060906083448.J3365803@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: xfs@oss.sgi.com

Hi Roger,

I'm gonna be rude and fwd your mail to the list - in the hope
someone there will be able to help you.  I'm running out of time
@sgi and have a bunch of stuff still to get done before I skip
outta here - having to look at the xfs_rename locking right now
might just be enough to make my head explode. ;)

cheers.

----- Forwarded message from Roger Willcocks <roger@filmlight.ltd.uk> -----

Date: 05 Sep 2006 14:30:30 +0100
To: nathans@sgi.com
X-Mailer: Ximian Evolution 1.2.2 (1.2.2-4) 
From: Roger Willcocks <roger@filmlight.ltd.uk>
Subject: race in xfs_rename?

Hi Nathan,

I think I must be missing something here:

xfs_rename calls xfs_lock_for_rename, which i-locks the source file and
directory, target directory, and (if it already exists) the target file.

It returns a two-to-four entry list of participating inodes.

xfs_rename unlocks them all, creates a transaction, and then locks them
all again.

Surely while they're unlocked, another processor could jump in and
fiddle with the underlying files and directories?


--
Roger



----- End forwarded message -----

-- 
Nathan
