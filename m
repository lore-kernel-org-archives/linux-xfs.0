Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAOLmV2X168682 for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 15:48:31 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AF9A613EABDB
	for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 13:50:06 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	pPHxFaDZGhZYkqcC for <xfs@oss.sgi.com>;
	Wed, 24 Nov 2010 13:50:06 -0800 (PST)
Date: Thu, 25 Nov 2010 08:50:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Xfs delaylog hanged up
Message-ID: <20101124215004.GF22876@dastard>
References: <4CEAC412.9000406@shiftmail.org> <20101122232929.GJ13830@dastard>
	<4CEBA2D5.2020708@shiftmail.org> <20101123204609.GW22876@dastard>
	<4CEC3CB8.8000509@hardwarefreak.com>
	<20101124002023.GA22876@dastard> <4CED0F40.606@shiftmail.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CED0F40.606@shiftmail.org>
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
To: Spelic <spelic@shiftmail.org>
Cc: xfs@oss.sgi.com

On Wed, Nov 24, 2010 at 02:12:32PM +0100, Spelic wrote:
> On 11/24/2010 01:20 AM, Dave Chinner wrote:
> >
> >512MB of BBWC backing the disks. The BBWC does a much better job of
> >reordering out-of-order writes than the Linux elevators because
> >512MB is a much bigger window than a couple of thousand 4k IOs.
> 
> Hmmm very interesting...
> so you are using a MD or DM raid-0 above a SATA controller with a BBWC?
> That would probably be a RAID controller used as SATA because I have
> never seen SATA controllers with a BBWC. I'd be interested in the
> brand if you don't mind.

Actually, it's a SAS RAID controller:

03:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 1078 (rev 04)

With each disk exported as a RAID0 lun because the raid controller
does not do JBOD.

> Also I wanted to know... the requests to the drives are really only
> 4K in size for linux?

No, they do much larger than that.  However, for small file
workloads the IO size is determined mostly by the file size.

> Then what purpose do the elevators' merges
> have? When the elevator merges two 4k requests doesn't it create an
> 8k request for the drive?

Yes. But when the two 4k blocks are not adjacent, they can't be
merged and hence are two IOs. And if the block that separated them
is then written 5ms after the other two completed, it's three IOs
that get combined in the BBWC into one...

> Also look at this competitor's link:
> http://thunk.org/tytso/blog/2010/11/01/i-have-the-money-shot-for-my-lca-presentation/
> post #9
> these scalability patches submit larger i/o than 4k. I can confirm
> that from within iostat -x 1  (I can't understand what he means with
> "bypasses the buffer cache layer" though, does it mean it's only for
> DIRECTIO? it does not seem to me).

It means he's calling submit_bio() rather than submit_bh(). Most of
that "new" code in ext4 was copied directly from XFS - XFS has been
using submit_bio() for large IO submission since roughly 2.6.15.

> When such large requests go into
> the elevator, are they broken up into 4K requests again?

No, the opposite used to happen - ext4 would break large contiguous
regions into 4k IOs (becaus submit_bh could only handle one block at
a time), and then the elevator would re-merge them into a large IO.
The issue here is CPU overhead of merging thousands of blocks
unnecessarily.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
