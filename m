Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 42BA029E21
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 15:50:19 -0500 (CDT)
Date: Fri, 26 Jul 2013 15:50:18 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: understanding speculative preallocation
Message-ID: <20130726205018.GM3111@sgi.com>
References: <1374823420041-35002.post@n7.nabble.com>
	<20130726115021.GO13468@dastard>
	<CAA+BczQesNL2VmFmrcBNKXcM-Sfx0bXkXPRP5xMx6=Bv+NWrUA@mail.gmail.com>
	<51F2CD8B.8080207@hardwarefreak.com>
	<CAA+BczQGYoJVL0twvz2GRhH30teFPSJOsKWtofbXBrom4_Q6hg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAA+BczQGYoJVL0twvz2GRhH30teFPSJOsKWtofbXBrom4_Q6hg@mail.gmail.com>
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
To: Jason Rosenberg <jbr@squareup.com>
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com

Hi Jason,

On Fri, Jul 26, 2013 at 04:38:21PM -0400, Jason Rosenberg wrote:
> Thanks for the info (most of it was, in fact, news to me).  I'm an
> application developer trying to debug a disk space problem, that's all.  So
> far, I've tracked it down to being an XFS issue.

The speculative block reservations have been an issue for awhile.  You are not
the first person to take issue with it.

> Regardless, is there a version history for XFS vis-a-via mainline Linux?

You can find a full version history for XFS back to 2.6.12 or so here:
http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs.git;a=summary

If you're interested in going older than that look here:
http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=summary

The function you'll most likely want to track is xfs_iomap_write_delay, which
calls xfs_iomap_eof_want_preallocate, both of which are in fs/xfs/xfs_iomap.c.

Recently Brian Foster added a scanner to remove the speculative block
reservations on a timer which may give you some relief.  See
xfs_queue_eofblocks in fs/xfs/xfs_icache.c

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
