Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4EEPUEC100205 for <xfs@oss.sgi.com>; Mon, 14 May 2012 09:25:31 -0500
Date: Mon, 14 May 2012 09:29:48 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: file corruption issue
Message-ID: <20120514142948.GS3963@sgi.com>
References: <51509.110.174.53.110.1336699622.squirrel@boosthardware.com>
	<20120511165012.GC16099@sgi.com>
	<59946.110.174.53.110.1336959906.squirrel@boosthardware.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <59946.110.174.53.110.1336959906.squirrel@boosthardware.com>
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
To: Patrick Shirkey <pshirkey@boosthardware.com>
Cc: xfs@oss.sgi.com

Hey Patrick,

On Mon, May 14, 2012 at 03:45:06AM +0200, Patrick Shirkey wrote:
> 
> On Fri, May 11, 2012 6:50 pm, Ben Myers wrote:
> > On Fri, May 11, 2012 at 03:27:02AM +0200, Patrick Shirkey wrote:
> >> I have some HP machines running centos:
> >>
> >> kernel 2.6.32-042stab049.6
> >> AMD Opteron(tm) Processor 6180 SE
> >> RAM:   528 GB
> >> RAID bus controller: Hewlett-Packard Company Smart Array G6 controllers
> >>
> >> We have experienced some kernel crashes due to a kernel bug with
> >> interleaving ram on this hardware which require hard reset of the
> >> machines.
> >>
> >> After reboot we are finding that there is severe file corruption on the
> >> xfs file system where TBs of readonly databases are getting partially or
> >> fully truncated.
> >>
> >> Has anyone come across this or similar?
> >
> > This rings a bell for me but I can't be certain.  Could you provide a
> > metadump?
> >
> 
> The machines are live so we have already restored the data several times.
> Will a metadump from the existing file system be useful or do you need it
> post crash?

Well... one of each would be best.  It might be helpful to compare the block
map from before the crash with the block map after the crash for one of the
read-only corrupted databases.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
