Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8NJ8l9E142389 for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 14:08:48 -0500
Subject: Re: [PATCH v3] xfs: fix possible overflow in xfs_ioc_trim()
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <alpine.LFD.2.00.1109231913400.3806@dhcp-27-109.brq.redhat.com>
References: <1316598150-12447-1-git-send-email-lczerner@redhat.com>
	<1316797735.2879.69.camel@doink>
	<alpine.LFD.2.00.1109231913400.3806@dhcp-27-109.brq.redhat.com>
Date: Fri, 23 Sep 2011 14:08:42 -0500
Message-ID: <1316804922.2879.123.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Cc: hch@infradead.org, xfs@oss.sgi.com

On Fri, 2011-09-23 at 19:17 +0200, Lukas Czerner wrote:
> On Fri, 23 Sep 2011, Alex Elder wrote:
> 
> > On Wed, 2011-09-21 at 11:42 +0200, Lukas Czerner wrote:
> > > In xfs_ioc_trim it is possible that computing the last allocation group
> > > to discard might overflow for big start & len values, because the result
> > > might be bigger then xfs_agnumber_t which is 32 bit long. Fix this by not
> > > allowing the start and end block of the range to be beyond the end of the
> > > file system.
> > > 
> > > Note that if the start is beyond the end of the file system we have to
> > > return -EINVAL, but in the "end" case we have to truncate it to the fs
> > > size.
> > > 
> > > Also introduce "end" variable, rather than using start+len which which
> > > might be more confusing to get right as this bug shows.
> > > 
> > > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > 
> > There are cases where we're (still) not trimming
> > blocks within the range specified when we could.
> > I have an idea about how to do that but I'll send
> > it out later and will commit this as-is.
> 
> What cases do you have in mind ? I have actually noticed that you are
> discarding even more than user asked for in case that the free extent
> and the range to trim overlaps, but that perfectly fine since the
> duration of the discard command does not usually depends on the extent
> size, so it is good thing to do.

Suppose blocks from byte offset 4096 through 20480 are free,
a FSB is 4096 bytes, and minlen computed in xfs_ioc_trim()
is computed to be 4096.

Now suppose a request comes in to trim range 7680 = (8KB - 512B)
for 5KB = 5120 bytes (i.e., bytes 7680 through 12799).

In xfs_ioc_trim(), "start" will be truncated to FSB 1, byte offset
4096.  In computing "end", range.len will be truncated to 1 FSB
or 4096 bytes.  So the resulting "end" byte will be 4096 + 4096 - 1
or 8191, thereby *not* trimming FSB 2 at offset 8192B even though
it is entirely within the requested range, and was free.

As pointed out by Christoph this isn't a big deal because
it's an advisory interface.  I have a way to tighten this up
but it'll be easier to see with code, which I'll try to post
next week.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
