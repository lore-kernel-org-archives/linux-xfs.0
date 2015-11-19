Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 582EE29DF5
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2015 09:30:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 377C0304032
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2015 07:30:11 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id 3FK6CUoA0Ybq1Oz4 (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 19 Nov 2015 07:30:09 -0800 (PST)
Date: Thu, 19 Nov 2015 16:30:04 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: AIO read returns negative number for bytes read
Message-ID: <20151119153004.GB25804@quack.suse.cz>
References: <564883BD.8070607@scylladb.com>
	<x497flhsq1c.fsf@segfault.boston.devel.redhat.com>
	<564B2303.7000902@scylladb.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <564B2303.7000902@scylladb.com>
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
To: Avi Kivity <avi@scylladb.com>
Cc: linux-aio@kvack.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>

On Tue 17-11-15 14:52:19, Avi Kivity wrote:
> 
> 
> On 11/16/2015 09:27 PM, Jeff Moyer wrote:
> >Hi Avi,
> >
> >Avi Kivity <avi@scylladb.com> writes:
> >
> >>Due to a bug in my program, I initiated a read beyond
> >>eof. Specifically, the file size is 13002 bytes and the read offset is
> >>13312 (0x3400).
> >>
> >>I would expect such a read to return 0 bytes read, but io_getevents
> >>returns -310, which is suspiciously equal to (13002 - 13312).
> >>
> >>I attach a reproducer.
> >>
> >>4.2.5-201.fc22.x86_64
> >>
> >>Are my expectations incorrect, or is this a bug in aio or xfs?
> >Your expectations are correct.  The bug was introduced by commit
> >9fe55eea7e4b4 (Fix race when checking i_size on direct i/o read).  I've
> >CC'd the patch author and linux-fsdevel.  I'm not sure what the right
> >fix is, given that the size checks were removed from the vfs to fix some
> >race condition.  Unfortunately, the commit message doesn't really do a
> >good job of explaining the race.  In order to save others time, here is
> >a good explanation of the problem that commit is meant to fix, along
> >with a reproducer:
> >   http://marc.info/?l=linux-fsdevel&m=138641356614458&w=2
> >
> >Thanks for the great bug report, and sorry I have no solution to
> >proffer.
> >
> 
> Thanks.  I will await a fix with interest.

Can you please post the reproduce here as well? I couldn't easily find it
with google.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
