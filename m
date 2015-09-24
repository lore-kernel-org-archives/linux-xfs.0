Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4ABCC7F47
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2015 19:39:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CBE68AC006
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2015 17:39:53 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	zuLSruMmq8DtN17Q for <xfs@oss.sgi.com>;
	Wed, 23 Sep 2015 17:39:51 -0700 (PDT)
Date: Thu, 24 Sep 2015 10:37:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 03/12] libxfs: don't hardcode cycle 1 into unmount op
	header
Message-ID: <20150924003735.GT19114@dastard>
References: <1441997742-37160-1-git-send-email-bfoster@redhat.com>
	<1441997742-37160-4-git-send-email-bfoster@redhat.com>
	<20150923034844.GS3902@dastard>
	<20150923132200.GC37210@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150923132200.GC37210@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Sep 23, 2015 at 09:22:00AM -0400, Brian Foster wrote:
> On Wed, Sep 23, 2015 at 01:48:44PM +1000, Dave Chinner wrote:
> > On Fri, Sep 11, 2015 at 02:55:33PM -0400, Brian Foster wrote:
> > > The libxfs helper to write a log record after zeroing the log fills much
> > > of the record header and unmount record with dummy data. It also
> > > hardcodes the cycle number into the transaction oh_tid field as the
> > > kernel expects to find the cycle stamped at the top of each block and
> > > the original oh_tid value packed into h_cycle_data of the record header.
> > > 
> > > The log clearing code requires the ability to format the log to an
> > > arbitrary cycle number to fix v5 superblock log recovery ordering
> > > problems. As a result, the unmount record helper must not hardcode a
> > > cycle of 1.
> > > 
> > > Fix up libxfs_log_header() to pack the unmount record appropriately, as
> > > is already done for extra blocks that might exist beyond the record. Use
> > > h_cycle_data for the original 32-bit word of the log record data block
> > > and stamp the cycle number in its place. This allows unmount_record() to
> > > work for arbitrary cycle numbers and libxfs_log_header() to pack a cycle
> > > value that matches the lsn used in the record header. Note that this
> > > patch does not change behavior as the lsn is still hardcoded to (1:0).
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  libxfs/rdwr.c | 23 ++++++++++++++++-------
> > >  1 file changed, 16 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> > > index bc77699..ef18749 100644
> > > --- a/libxfs/rdwr.c
> > > +++ b/libxfs/rdwr.c
> > > @@ -122,7 +122,7 @@ static void unmount_record(void *p)
> > >  	} magic = { XLOG_UNMOUNT_TYPE, 0, 0 };
> > >  
> > >  	memset(p, 0, BBSIZE);
> > > -	op->oh_tid = cpu_to_be32(1);
> > > +	op->oh_tid = cpu_to_be32(0xb0c0d0d0);
> > >  	op->oh_len = cpu_to_be32(sizeof(magic));
> > >  	op->oh_clientid = XFS_LOG;
> > >  	op->oh_flags = XLOG_UNMOUNT_TRANS;
> > > @@ -188,10 +188,6 @@ libxfs_log_header(
> > >  
> > >  	len = ((version == 2) && sunit) ? BTOBB(sunit) : 1;
> > >  
> > > -	/* note that oh_tid actually contains the cycle number
> > > -	 * and the tid is stored in h_cycle_data[0] - that's the
> > > -	 * way things end up on disk.
> > > -	 */
> > 
> > This note needs to be hoisted up to the  setting of op->oh_tid to
> > explain the magic number being used...
> > 
> 
> This requires that I understand what the magic number being used
> actually means. Any ideas? ;)

When this gets unpacked by log recovery, the head->h_cycle_data[0]
value gets written back over the op->oh_tid of the unmount record,
and so we see an unmount record with a transaction ID of 0xb0c0d0d0.
On seeing that magic number in an unmount record we know it was
written by userspace and whatever was in the log is now ancient
history.

> I just assumed it was a dummy tid value.

It's a canary (sort of).

*ding*
*ding*
*ding*

Obscure Magic Number Reference Acheivement Unlocked!

[BC: ancient history. Dodo: a dead canary (sort of). ;) ]

> The comment removed above just
> explains why that value is being put where it is (cycle value in oh_tid
> and tid value in h_cycle_data) as the original code implicitly
> implements the cycle data packing. That is undone by this patch. The
> packing is now done explicitly (with its own comments) in the caller and
> thus the original comment is irrelevant.

Fair enough - I didn't connect the two bits properly.

Hmmm - this code does not CRC the unmount record on disk and we
don't validate the unmount record CRC in the kernel as valid in the
kernel before we use it, because it never gets to the unpack stage;
we just look to see if ophdr->oh_flags contains XLOG_UNMOUNT_TRANS
and then we use it...

If we are writing a new lsn into it now, should we be CRCing this
unmount record?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
