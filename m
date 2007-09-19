Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 16:34:22 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8JNYBuw009138
	for <linux-xfs@oss.sgi.com>; Wed, 19 Sep 2007 16:34:16 -0700
Received: from snort.melbourne.sgi.com (snort.melbourne.sgi.com [134.14.54.149]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id JAA02937 for <linux-xfs@oss.sgi.com>; Thu, 20 Sep 2007 09:34:13 +1000
Received: from snort.melbourne.sgi.com (localhost [127.0.0.1])
	by snort.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id l8JNYCdD29802686
	for <linux-xfs@oss.sgi.com>; Thu, 20 Sep 2007 09:34:13 +1000 (AEST)
Received: (from dgc@localhost)
	by snort.melbourne.sgi.com (SGI-8.12.5/8.12.5/Submit) id l8JNYBpm29705449
	for linux-xfs@oss.sgi.com; Thu, 20 Sep 2007 09:34:11 +1000 (AEST)
Date: Thu, 20 Sep 2007 09:34:11 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: possible bug with non-default extent sizes
Message-ID: <20070919233411.GP995458@sgi.com>
References: <20070918183308.GB10782@teal.hq.k1024.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918183308.GB10782@teal.hq.k1024.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

On Tue, Sep 18, 2007 at 08:33:08PM +0200, Iustin Pop wrote:
> Hi,
> 
> I've seen a strange behaviour related to sparse files with non-default
> extent sizes and I'm not sure if it's a bug or expected behaviour
> (certainly I was not expecting it).
> 
> cd $TMPDIR
> /usr/sbin/xfs_io -c "extsize 16k" .
> python <<EOF
> f = open("test", "w+")
> f.truncate(1024*64)
> f.write("A")
> f.close()
> EOF

FWIW:

/usr/sbin/xfs_io -f \
	-c "extsize 16k" \
	-c "truncate 64k" \
	-c "pwrite 0 4k" \
	-c "bmap -vp" \
	$TMPDIR/test

Is my usual way of writing these quick sort of tests.

> what I see if I look at the file now with od for example, is that the
> first filesystem block contains "A" and then zeroes, but after the 4k
> offset the file contains stale data from the disk.

Yeah, there's a bug there that I've been trying to work out the
best way to fix - basically the delalloc is supposed to convert
the extent size to 4k of written data and 12k of unwritten data,
but the unwritten flag is not getting set on the unwritten
section. and so we are allocating 16k when we are only writing to
4k.

> I haven't found any bug related to this, and I would not expect stale
> data (since this is doable even by normal users, and maybe could leak
> old data).
> 
> Is this a known issue?

Yes - it was discovered a few months back amongst a raft of other
issues similar to this. This is the only one I know of that I
haven't fixed yet - I've had a couple of attempts and they drowned
in complexity. I'll have another look at it seeing as I have a
better understanding of what is supposed to happen since I last
tried to fix it....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
