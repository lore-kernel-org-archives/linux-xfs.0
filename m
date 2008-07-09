Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Jul 2008 06:57:09 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m69Dv5Lu015342
	for <xfs@oss.sgi.com>; Wed, 9 Jul 2008 06:57:07 -0700
Received: from g5t0006.atlanta.hp.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 98571C605FD
	for <xfs@oss.sgi.com>; Wed,  9 Jul 2008 06:58:11 -0700 (PDT)
Received: from g5t0006.atlanta.hp.com (g5t0006.atlanta.hp.com [15.192.0.43]) by cuda.sgi.com with ESMTP id CsUYH0tVEOBCaGvD for <xfs@oss.sgi.com>; Wed, 09 Jul 2008 06:58:11 -0700 (PDT)
Message-ID: <4874C3E8.20804@hp.com>
Date: Wed, 09 Jul 2008 09:58:00 -0400
From: jim owens <jowens@hp.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] Add timeout feature
References: <20080709005254.GQ11558@disturbed> <20080709010922.GE9957@mit.edu> <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu> <20080709061621.GA5260@infradead.org> <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org> <E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu> <20080708235502.1c52a586@infradead.org> <20080709071346.GS11558@disturbed> <20080709110900.GI9957@mit.edu> <20080709114958.GV11558@disturbed>
In-Reply-To: <20080709114958.GV11558@disturbed>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>, Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org, pavel@suse.cz, t-sato@yk.jp.nec.com, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, axboe@kernel.dk, mtk.manpages@googlemail.com

Jumping into the battle...

Advfs implemented freezefs and thawfs in 2001 so here is
the design rational from a commercial unix view.

Note -  We already had built-in snapshots for local disk
consistent backups so some choices might be different on Linux.

NEED - provide way for SAN and hardware raid storage to do
its snapshot/copy function while the system was in-use and
get an image that could mount cleanly.  Without freeze, at
a minimum we usually needed filesystem metadata recovery
to run, worst case is completely unusable snapshits :)

freezefs() is single-level:

    ENOTSUPPOTED - by any other fs
    EOK - done
    EINPROGRESS
    EALREADY

As implemented, freezefs only ensures the metadata is
consistent so the filesystem copy can mount anywhere.

This means ONLY SOME metadata (or no metadata) is flushed and
then all metadata updates are stopped.  User/kernel writes
to already allocated file pages WILL go to a frozen disk.

It also means writers that need storage allocation (not
delaloc or existing) and things that semantically must
force on-disk updates will hang during the freeze.

These semantics meet the need and has the advantage of the
best perfomance.  The design specification for freezefs
provided flags on the api to add more consistency options
later if they were desired:
   - flush all dirty metadata
   - flush all existing dirty file data
   - prevent new dirty file data to disk
but they would all add to the "kill the system" problem.

freezefs has the timeout argument and the default timeout
is a system config parameter:
   > 0 specifies the timeout value
   = 0 uses the default timeout
   < 0 disable timeout

A program could call the freezefs/thawfs api, but the
only current use is the separate commands

# freezefs
#   [do your hardware raid stuff]
# thawfs

This is either operator driven or script/cron driven
because hardware raid providers (especially our own)
are really unfriendly and not helpful.

NUMBER ONE RULE - freeze must not hang/crash the system
because that defeats the customer reason for wanting it.

WHY A TIMEOUT - need a way for operator to abort the
freeze because with a frozen filesystem they may not
even be able to do a login to thaw it!

Users get pissed when the system is hung for a long
time and our experience with SAN devices is that their
response to commands is often unreasonably long.

In addition to the user controllable timeout mechanism,
we internally implement AUTO-THAW in the filesystem
whenever necessary to prevent a kernel hang/crash.

If an AUTO-THAW occurs, we post to the log and an
event manager so the user knows the snapshot is bad.

jim
