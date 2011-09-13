Return-Path: <xfs-bounces@oss.sgi.com>
Subject: Re: [xfs-masters] xfs deadlock in stable kernel 3.0.4
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1315950742.2159.89.camel@doink>
References: <1D2B34A7-7BB9-4E4E-9CA2-382C210E125F@profihost.ag>
	<20110912152133.GA8345@infradead.org>
	<C6515E45-5724-43DD-95A8-1F89AFE29601@profihost.ag>
	<20110912200543.GA22409@infradead.org> <4E6EF274.7050007@profihost.ag>
	<20110913205018.GA8543@infradead.org> <1315950742.2159.89.camel@doink>
Date: Tue, 13 Sep 2011 16:58:13 -0500
Message-ID: <1315951093.2159.92.camel@doink>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Stefan Priebe - Profihost AG <s.priebe@profihost.ag>

On Tue, 2011-09-13 at 16:52 -0500, Alex Elder wrote:
> On Tue, 2011-09-13 at 16:50 -0400, Christoph Hellwig wrote:
> > On Tue, Sep 13, 2011 at 08:04:36AM +0200, Stefan Priebe - Profihost AG wrote:
> > > I just reported it to the scsi list as i didn't knew where the
> > > problems is. But then some people told be it must be a XFS problem.
> > > 
> > > Some more informations:
> > > 1.) It's running with 2.6.32 and 2.6.38
> > > 2.) I can also write to another ext2 part on the same disk
> > > array(aacraid driver) while xfs stucks - so i think it must be an
> > > xfs problem
> > 
> > That points a bit more towards XFS, although we've seen storage setups
> > create issues depending on the exact workload.  The prime culprit for
> > used to be the md software RAID driver, though.
> > 
> > > 3.) I've also tried running 3.1-rc5 but then i'm seeing this error:
> > > 
> > > BUG: unable to handle kernel NULL pointer dereference at 000000000000012c
> > > IP: [] inode_dio_done+0x4/0x25
> > 
> > Oops, that's a bug that I actually introduced myself.  Fix below:
> 
> Yikes.  I'll prepare that one to send to Linus for 3.1.
> I'll wait for your formal signoff, though, Christoph.
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>

Nevermind--the latest code doesn't look quite
like that and doesn't suffer the same problem.

Christoph, will you please ensure the fix gets
to the stable folks though?  You have my review
for the change.

					-Alex


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
