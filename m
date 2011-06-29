Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5TAhJA8085301 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 05:43:19 -0500
Received: from mail1.slb.deg.dub.stisp.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id E96AF14F7529
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 03:43:17 -0700 (PDT)
Received: from mail1.slb.deg.dub.stisp.net (mail1.slb.deg.dub.stisp.net
	[84.203.253.98]) by cuda.sgi.com with SMTP id rerOSPuiTQpqAJBt
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 03:43:17 -0700 (PDT)
Message-ID: <4E0B019E.8080800@draigBrady.com>
Date: Wed, 29 Jun 2011 11:42:38 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
	<1309275199-10801-5-git-send-email-josef@redhat.com>
	<20110629065306.GC1026@dastard>
	<20110629074021.GA26086@infradead.org>
In-Reply-To: <20110629074021.GA26086@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Josef Bacik <josef@redhat.com>, xfs@oss.sgi.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org

On 29/06/11 08:40, Christoph Hellwig wrote:
> On Wed, Jun 29, 2011 at 04:53:07PM +1000, Dave Chinner wrote:
>> On Tue, Jun 28, 2011 at 11:33:19AM -0400, Josef Bacik wrote:
>>> This is a test to make sure seek_data/seek_hole is acting like it does =
on
>>> Solaris.  It will check to see if the fs supports finding a hole or not=
 and will
>>> adjust as necessary.
>>
>> So I just looked at this with an eye to validating an XFS
>> implementation, and I came up with this list of stuff that the test
>> does not cover that I'd need to test in some way:
>>
>> 	- files with clean unwritten extents. Are they a hole or
>> 	  data? What's SEEK_DATA supposed to return on layout like
>> 	  hole-unwritten-data? i.e. needs to add fallocate to the
>> 	  picture...
>>
>> 	- files with dirty unwritten extents (i.e. dirty in memory,
>> 	  not on disk). They are most definitely data, and most
>> 	  filesystems will need a separate lookup path to detect
>> 	  dirty unwritten ranges because the state is kept
>> 	  separately (page cache vs extent cache).  Plenty of scope
>> 	  for filesystem specific bugs here so needs a roubust test.
> =

> The discussion leading up to the resurrection of SEEK_HOLE/SEEK_DATA
> was pretty much about that point.  The conclusion based on the Sun
> documentation and common sense was that SEEK_DATA may only consider
> unwritten extents as hole if the filesystem has a way to distinguish
> plain unwritten extents and those that have been dirtied.  Else it
> should be considered data.
> =

> Testing for making sure dirty preallocated areas aren't wrongly
> reported sounds relatively easy, the rest falls into implementation
> details, which imho is fine.  Not reporting preallocated extents
> as holes just is a quality of implementation issue and not a bug.

There is the argument, that if this interface can distinguish
these dirty unwritten extents, then why can't the fiemap interface too?
The advantage of the fiemap interface is that it can distinguish
empty extents vs holes. Empty extents will become increasingly common
I think, given the fragmentation and space guarantee benefits they give.
It would be cool for cp for example to be able to efficiently copy
empty extents from source to dest.

cheers,
P=E1draig.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
