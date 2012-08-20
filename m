Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7KMo9TV010506 for <xfs@oss.sgi.com>; Mon, 20 Aug 2012 17:50:09 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	VqEizBClaQVjBAgJ for <xfs@oss.sgi.com>;
	Mon, 20 Aug 2012 15:49:42 -0700 (PDT)
Date: Tue, 21 Aug 2012 08:49:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Test 272 fails for ext3
Message-ID: <20120820224941.GG19235@dastard>
References: <20120816092808.GA9057@quack.suse.cz>
	<20120816093757.GA11519@quack.suse.cz>
	<20120816224858.GY2877@dastard>
	<20120820162212.GA17354@quack.suse.cz>
	<20120820210638.GA4591@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120820210638.GA4591@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, dmonakhov@openvz.org, xfs@oss.sgi.com

On Mon, Aug 20, 2012 at 11:06:38PM +0200, Jan Kara wrote:
> On Mon 20-08-12 18:22:12, Jan Kara wrote:
> > On Fri 17-08-12 08:48:58, Dave Chinner wrote:
> > > On Thu, Aug 16, 2012 at 11:37:57AM +0200, Jan Kara wrote:
> > > >   Hello,
> > > > 
> > > >   I was looking into why test 272 from xfstests fails for ext3 and the
> > > > reason is that ext3 does not support direct IO to file with enabled data
> > > > journalling (open returns EINVAL because ->direct_IO callback is not
> > > > specified). So I was thinking how to accomodate this fact in the test -
> > > > the best I found was to just check using xfs_io whether O_DIRECT open
> > > > succeeds and perform the test only in that case. Attached patch does this
> > > > or do people have other ideas?
> > > 
> > > 
> > > # ext3 doesn't support direct IO in journalling mode
> > > ext3_write_opt_list="iflag=noatime conv=notrunc conv=fsync"
> > > ext4_write_opt_list="iflag=noatime conv=notrunc conv=fsync oflag=direct"
> > > 
> > > if [ $FSTYP = "ext3" ]; then
> > > 	write_opt_list="$ext3_write_opt_list"
> > > else
> > > 	write_opt_list="$ext4_write_opt_list"
> > > fi
> >   Yeah, this is probably simpler. Thanks for suggestion. BTW, ext4 also
> > does not support direct IO and data journalling but it silently falls back
> > to buffered IO. Anyway new patch is attached.
>   Hum, after testing this I realized why I did the things the original way.
> The test writes a message with title for each test so when direct IO tests
> are skipped outputs don't match.
> 
> After some thought I decided to change the test to output titles only to
> full output and keep compared output (almost) empty. Result is attached.

....
> --- a/272
> +++ b/272
> @@ -32,15 +32,18 @@ tmp=/tmp/$$
>  status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
> +write_opt_list="iflag=noatime conv=notrunc conv=fsync oflag=direct"
> +if [ $FSTYP = "ext3" ]; then
> +	# ext3 doesn't support direct IO in journalling mode
> +	write_opt_list="iflag=noatime conv=notrunc conv=fsync"
> +fi

Seems like asking for trouble duplicating the common options.

# ext3 doesn't support direct IO in journalling mode
write_opt_list="iflag=noatime conv=notrunc conv=fsync
[ $FSTYP = "ext4" ] && write_opt_list="$write_opt_list oflag=direct"

Otherwise looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
