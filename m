Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 035B17F69
	for <xfs@oss.sgi.com>; Sun, 16 Mar 2014 20:38:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D457C8F8035
	for <xfs@oss.sgi.com>; Sun, 16 Mar 2014 18:38:05 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id T84rLdJNHhcmTTTY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 16 Mar 2014 18:38:04 -0700 (PDT)
Date: Mon, 17 Mar 2014 01:38:00 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: fs corruption exposed by "xfs: increase prealloc size to double
	that of the previous extent"
Message-ID: <20140317013759.GV18016@ZenIV.linux.org.uk>
References: <20140315210216.GP18016@ZenIV.linux.org.uk>
	<20140317001130.GA7072@dastard>
	<20140317002918.GT18016@ZenIV.linux.org.uk>
	<20140317012804.GU18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140317012804.GU18016@ZenIV.linux.org.uk>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>

On Mon, Mar 17, 2014 at 01:28:04AM +0000, Al Viro wrote:
> but that is unsafe - consider a situation when you are writing 20Kb from e.g.
> 0.5Kb offset from the beginning of last (4Kb) block.  You have 6 blocks
> affected, right?  One old, five new.  And you want the last half-kilobyte

s/the last/all but the first/, sorry.  Basically, we want to get from
OOOOOOOO  (8 sectors of old data)
to
ONNNNNNN|NNNNNNNN|NNNNNNNN|NNNNNNNN|NNNNNNNN|NZZZZZZZ (1 sector of old data,
40 sectors of new data, 7 sectors of zeroes).  We want the last 7 sectors
zeroed out, but we do *not* want that to happen to the one sector of old data.
OTOH, if the file had been 4K shorter (and all blocks had been new) we would
want
ZNNNNNNN|NNNNNNNN|NNNNNNNN|NNNNNNNN|NNNNNNNN|NZZZZZZZ.  IOW, it's not just
the last block we want to know about.  There's simply not enough bandwidth
in that interface to pass the information we would need for such mixed
block runs...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
