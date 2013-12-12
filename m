Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AA2307F37
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 15:27:19 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9939E30406A
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 13:27:19 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	OAuhMRxhiyJ3ZGtX for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 13:27:17 -0800 (PST)
Date: Fri, 13 Dec 2013 08:27:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: Internal error XFS_WANT_CORRUPTED_RETURN
Message-ID: <20131212212713.GC10988@dastard>
References: <20131211172725.GA4606@redhat.com> <20131211230128.GM10988@dastard>
	<52A9E0EF.1000206@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52A9E0EF.1000206@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Jones <davej@redhat.com>, xfs@oss.sgi.com

On Thu, Dec 12, 2013 at 10:14:39AM -0600, Eric Sandeen wrote:
> On 12/11/13, 5:01 PM, Dave Chinner wrote:
> > On Wed, Dec 11, 2013 at 12:27:25PM -0500, Dave Jones wrote:
> >> Powered up my desktop this morning and noticed I couldn't cd into ~/Mail
> >> dmesg didn't look good.  "XFS: Internal error XFS_WANT_CORRUPTED_RETURN"
> >> http://codemonkey.org.uk/junk/xfs-1.txt
> > 
> > They came from xfs_dir3_block_verify() on read IO completion, which
> > indicates that the corruption was on disk and in the directory
> > structure. Yeah, definitely a verifier error:
> > 
> > XFS (sda3): metadata I/O error: block 0x2e790 ("xfs_trans_read_buf_map") error 117 numblks 8
> > 
> > Are you running a CRC enabled filesystem? (i.e. mkfs.xfs -m crc=1)
> > 
> > Is there any evidence that this verifier has fired in the past on
> > write? If not, then it's a good chance that it's a media error
> > causing this, because the same verifier runs when the metadata is
> > written to ensure we are not writing bas stuff to disk.
> 
> Dave C, have you given any thought to how to make the verifier errors more
> actionable?  If davej throws up his hands, the rest of the world is obviously
> in trouble.  ;)

The verifier behaviour is effectively boiler plate code.

> To the inexperienced this looks like a "crash" thanks to the backtrace.
> I do understand that it's necessary for bug reports, but I wonder if we
> could preface it with something informative or instructive.

Yup, It was done like that so it would scare people and they'd
report verifier failures so that we had good visibility of problems
they were detecting. So, from that perspective they are doing
exactly what they were intended to do.

In reality, the incidence of verifiers detecting corruption is no
different from the long term historical trends of corruptions being
reported. The only difference is that we are catching them
immediately as the come off disk, rather than later on in the code
when we can't tell if the problem is a code bug or an IO error.
So, again, the verifiers are doing exactly what they were intended
to do.

> We also don't get a block number or inode number, although you or I can
> dig the inode number out of the hexdump, in this case.

That comes from the higher layer error message. We don't get it from
the verifier simply because the boilerplate code doesn't report it.

> We also don't get any details of what the values in the failed check were;
> not from the check macro itself or from the hexdump, necessarily, since
> it only prints the first handful of bytes.

In most cases, the handful (64) of bytes is more than sufficient -
it is big enough to contain the entire self-describing header for
the object that failed, and that is enough to validate whether the
corruption is a bad metadata block or something internal to the
metadata structure itself. i.e. the hexdump has actually been
carefully sized to balance between scary noise and useful for
debugging.

That said, we need to do some work on the verifiers - they need to
be converted to use WANT_CORRUPTED_RETURN or a similar new
corruption report. That way we know exactly what verifier test
failed from the line of code it dumped from.  A couple of the
verifiers already do this (in the directory code), but the rest need
to be converted across, too.  We can easily add a more custom info
to the failure by doing this (e.g. block number, whether it is a
read or write verifier failure, etc); if we do this correctly then
the stack trace that is currently being dumped can go away.

We also need to distinguish between CRC validation errors and object
format validation errors. We need this in userspace for xfs_repair,
and it could replace the custom code in xfs_db that does this, so the
kernel code needs to have it put in place first.

IOWs, there's a bunch of verifier improvements that are in the
works that should help this situation.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
