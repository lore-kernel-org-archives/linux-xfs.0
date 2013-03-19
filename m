Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 380587F4E
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 21:28:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 166568F8035
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 19:28:24 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id I1ufR1z7V4RYDnCd for <xfs@oss.sgi.com>;
	Mon, 18 Mar 2013 19:28:24 -0700 (PDT)
Message-ID: <5147CD46.1090205@sandeen.net>
Date: Mon, 18 Mar 2013 21:28:22 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: possible dev branch regression - xfstest 285/1k
References: <20130315222818.GA16100@wallace> <20130316150923.GA18589@gmail.com>
	<20130317030648.GA14225@thunk.org>
	<51473C8B.5070509@redhat.com> <20130318170927.GA5639@thunk.org>
	<51475043.4010505@redhat.com> <20130318204133.GE22182@sgi.com>
	<20130318231233.GQ6369@dastard> <20130319014718.GV6369@dastard>
	<20130319020056.GC4660@thunk.org>
In-Reply-To: <20130319020056.GC4660@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: Eric Sandeen <sandeen@redhat.com>, Eric Whitney <enwlinux@gmail.com>, xfs-oss <xfs@oss.sgi.com>, Ben Myers <bpm@sgi.com>, linux-ext4@vger.kernel.org

On 3/18/13 9:00 PM, Theodore Ts'o wrote:
> On Tue, Mar 19, 2013 at 12:47:18PM +1100, Dave Chinner wrote:
>> Sorry about this - I've mixed up my threads about ext4 having
>> problems with zero-out being re-enabled. I thought this was a
>> cross-post of the 218 issue....
>>
>> However, the same reasoning can be applied to 285 - the file sizes,
>> the size of the holes and the size of the data is all completely
>> arbitrary. If we make the holes in the files larger, then the
>> zero-out problem simply goes away.
> 
> Right.  That was my observation.  We can either make the holes larger,
> by changing:
> 
>    pwrite(fd, buf, bufsize, bufsize*10);
> 
> to
> 
>    pwrite(fd, buf, bufsize, bufsize*42);
>    
> ... and then changing the expected values returned by
> SEEK_HOLE/SEEK_DATA.  (By the way; this only matters when we are
> testing 1k blocks; if we are using a 4k block size in ext4, the test
> currently passes.)
> 
> Or we could set some ext4-specific tuning parameters into the #218

285! :)

> shell script, if the file system in question was ext4.
> 
> I had assumed that folks would prefer making the holes larger, but
> Eric seemed to prefer the second choice as a better one.

Ok, after the discussion I'm convinced too.  Stretching out the allocation
to avoid fill-in probably makes sense.  But maybe not "42" -
how about something much larger, so that any "reasonable" filesystem
wouldn't even consider zeroing the range in between?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
