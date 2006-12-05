Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Dec 2006 15:07:34 -0800 (PST)
Received: from page.mel.office.aconex.com (eth2333.vic.adsl.internode.on.net [150.101.159.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB5N7PaG018926
	for <xfs@oss.sgi.com>; Tue, 5 Dec 2006 15:07:28 -0800
Subject: Recent changes in xfsprogs
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
Content-Type: text/plain
Date: Wed, 06 Dec 2006 10:06:10 +1100
Message-Id: <1165359970.1281.51.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: bnaujok@sgi.com
Cc: xfs@oss.sgi.com

Yo Barry,

xfsprogs/doc/CHANGES

        - Rename include/list.h to xfs_list.h so that other applications
          do not accidentally use it.

What was the problem here?  This doesnt sound like the right fix -
there should be no applications outside of the XFS userspace that
use libxfs.h - thats what <xfs/xfs.h> is for (exactly this reason,
preventing namespace collision, by reducing all the XFS internals
being exposed).

Also, there seems to be lots of checkin mail not making it out to
oss.sgi.com (let alone review mail), making it difficult for people
to keep up to date with changes (and keep distros, like Debian,
uptodate) ... could y'all make some effort to keep us "on the
outside" in the loop?

Oh, noone is updating oss.sgi.com/projects/xfs/{news,index}.html
with recent changes either - seems like progress has come to a
halt to those of us no longer in the secret cabal, anyway ;) ...
just FYI.

cheers.

-- 
Nathan
