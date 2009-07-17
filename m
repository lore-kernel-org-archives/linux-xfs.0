Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6HE9G1e093468 for <xfs@oss.sgi.com>; Fri, 17 Jul 2009 09:09:18 -0500
Date: Fri, 17 Jul 2009 10:09:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, RFC] xfs: event tracing support
Message-ID: <20090717140955.GA26050@infradead.org>
References: <20090616214844.GA12310@infradead.org>
	<4E752C93-A674-4725-AF23-C227C0A1E659@sgi.com>
	<20090622205904.GA1855@infradead.org>
	<4A5FA82F.6050903@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A5FA82F.6050903@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, linux-ia64@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, xfs@oss.sgi.com

On Thu, Jul 16, 2009 at 05:22:39PM -0500, Eric Sandeen wrote:
> Where are we at with this one, I'd like to get this in for XFS but I
> agree w/ Felix that throwing out a "working" trace infrastructure w/
> nothing to replace it on ia64 would not be great.

Well, it's not actuall working in these sense of that it isn't and never
has been in mainline and also is utterly bit-rotted.  I have absolutely
no interested in keeping a tracing implementation away from mainline
that just works out of the box (not just on x86 but also on powerpc and
others) just because ia64 is too slow to get modern features.

And it's not like we got any interesting amount of IA64 users, nor have
does SGI who seems to be interested in IA64 do a lot of patches to XFS.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
