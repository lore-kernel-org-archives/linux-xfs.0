Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6FC197F37
	for <xfs@oss.sgi.com>; Thu, 24 Sep 2015 08:00:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 50366304048
	for <xfs@oss.sgi.com>; Thu, 24 Sep 2015 06:00:39 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OVCBvnA36fNJNxXd (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 24 Sep 2015 06:00:37 -0700 (PDT)
Date: Thu, 24 Sep 2015 09:00:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 03/12] libxfs: don't hardcode cycle 1 into unmount op
	header
Message-ID: <20150924130034.GB42523@bfoster.bfoster>
References: <1441997742-37160-1-git-send-email-bfoster@redhat.com>
	<1441997742-37160-4-git-send-email-bfoster@redhat.com>
	<20150923034844.GS3902@dastard>
	<20150923132200.GC37210@bfoster.bfoster>
	<20150924003735.GT19114@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150924003735.GT19114@dastard>
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
Cc: xfs@oss.sgi.com

On Thu, Sep 24, 2015 at 10:37:35AM +1000, Dave Chinner wrote:
> On Wed, Sep 23, 2015 at 09:22:00AM -0400, Brian Foster wrote:
> > On Wed, Sep 23, 2015 at 01:48:44PM +1000, Dave Chinner wrote:
> > > On Fri, Sep 11, 2015 at 02:55:33PM -0400, Brian Foster wrote:
...
> > > > --- a/libxfs/rdwr.c
> > > > +++ b/libxfs/rdwr.c
> > > > @@ -122,7 +122,7 @@ static void unmount_record(void *p)
> > > >  	} magic = { XLOG_UNMOUNT_TYPE, 0, 0 };
> > > >  
> > > >  	memset(p, 0, BBSIZE);
> > > > -	op->oh_tid = cpu_to_be32(1);
> > > > +	op->oh_tid = cpu_to_be32(0xb0c0d0d0);
> > > >  	op->oh_len = cpu_to_be32(sizeof(magic));
> > > >  	op->oh_clientid = XFS_LOG;
> > > >  	op->oh_flags = XLOG_UNMOUNT_TRANS;
> > > > @@ -188,10 +188,6 @@ libxfs_log_header(
> > > >  
> > > >  	len = ((version == 2) && sunit) ? BTOBB(sunit) : 1;
> > > >  
> > > > -	/* note that oh_tid actually contains the cycle number
> > > > -	 * and the tid is stored in h_cycle_data[0] - that's the
> > > > -	 * way things end up on disk.
> > > > -	 */
> > > 
> > > This note needs to be hoisted up to the  setting of op->oh_tid to
> > > explain the magic number being used...
> > > 
> > 
> > This requires that I understand what the magic number being used
> > actually means. Any ideas? ;)
> 
> When this gets unpacked by log recovery, the head->h_cycle_data[0]
> value gets written back over the op->oh_tid of the unmount record,
> and so we see an unmount record with a transaction ID of 0xb0c0d0d0.
> On seeing that magic number in an unmount record we know it was
> written by userspace and whatever was in the log is now ancient
> history.
> 
> > I just assumed it was a dummy tid value.
> 
> It's a canary (sort of).
> 
> *ding*
> *ding*
> *ding*
> 
> Obscure Magic Number Reference Acheivement Unlocked!
> 
> [BC: ancient history. Dodo: a dead canary (sort of). ;) ]
> 

Hah, I figured it had to be some kind of obscure reference. ;)

> > The comment removed above just
> > explains why that value is being put where it is (cycle value in oh_tid
> > and tid value in h_cycle_data) as the original code implicitly
> > implements the cycle data packing. That is undone by this patch. The
> > packing is now done explicitly (with its own comments) in the caller and
> > thus the original comment is irrelevant.
> 
> Fair enough - I didn't connect the two bits properly.
> 
> Hmmm - this code does not CRC the unmount record on disk and we
> don't validate the unmount record CRC in the kernel as valid in the
> kernel before we use it, because it never gets to the unpack stage;
> we just look to see if ophdr->oh_flags contains XLOG_UNMOUNT_TRANS
> and then we use it...
> 
> If we are writing a new lsn into it now, should we be CRCing this
> unmount record?
> 

Good question. I'm not so sure it's that important to crc the record in
this particular context. We're reformatting the log and clearing any
real data, after all.

That said, when skimming back through the kernel code I had a faint
recollection of why I started all of this log recovery work in the first
place. ;) The previous EFI/EFD logging fixes, umount hang fixes and
these LSN fixes all spilled out from the inability to effectively test
torn log write detection in an effort to support XFS on pmem. Recall our
previous discussion here:

  http://oss.sgi.com/pipermail/xfs/2015-July/042415.html

I believe I made progress on that work with respect to the
aforementioned discussion, but it was still very much in flux and all of
this stuff got in the way of starting to test what I had at the time.
The short of it is that due to that work, we'll end up doing crc
verification of the head of the log before the real log recovery
actually starts. I don't quite recall whether this incorporated crc
verification of the unmount record in the clean log case (I suspect
not), but I can add that as a TODO item to look into once I get back to
that work. If there's a good enough reason to do that in the kernel, we
could certainly revisit the userspace log formatting code to set a crc.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
