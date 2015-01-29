Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8C6CC7FD3
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 16:58:24 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 36869AC004
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 14:58:24 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Ndhfg2cUAoDUp8Di for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2015 14:58:21 -0800 (PST)
Date: Fri, 30 Jan 2015 09:57:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Unable to mount and repair filesystems
Message-ID: <20150129225750.GC6282@dastard>
References: <D90435AEFF34654AA1122988C66C8678023F0277C9@exchange.tsag.local>
	<54CA9586.1010607@sandeen.net>
	<D90435AEFF34654AA1122988C66C8678023F027956@exchange.tsag.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <D90435AEFF34654AA1122988C66C8678023F027956@exchange.tsag.local>
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
To: Gerard Beekmans <GBeekmans@tsag.net>
Cc: Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Jan 29, 2015 at 09:27:32PM +0000, Gerard Beekmans wrote:
> > -----Original Message-----
> > Are you certain that the volume /
> > storage behind dm-9 is in decent shape?  (i.e. is it really even
> > an xfs filesystem?)
.....
> The outage occurred at the SAN level making the NFS storage
> unavailable which in turn turned off all the VMs running on it
> (turned off in the virtual sense).

Define "SAN" outage. All this tells me is that the backing store
went bad in some way and needed recovery, not what the actual
problem in the SAN was. If it was a potential data loss event, then
that's the prime candidate for the storage returning zeros where
there should be data.

The second candidate is the NFS server. What was the NFS server?
Did the NFS server get rebooted? Did the NFS clients (i.e. the
physical machines running the hypervisor, not the guests) get
rebooted too?  If you reboot the server, the NFS clients are
supposed to retransmit any unstable data they have to the server. If
the clients are rebooted or the NFS mount forcible unmounted while
the server is down, then that unstable data is lost forever.

Really, fully zeroed blocks in critical XFS metadata blocks is
almost always an indication of data loss somewhere in the lower
layers of the storage stack.  As a precaution, though, if one vmdk
is bad, I'd consider all the others as suspect, even if the
filesystem checkers haven't thrown errors.  Random block data loss
can really only be reliably recovered from backups, as user data is
notoriously difficult to validate as correct.

.....

> It is possible that it is the vmware VMDK file that belongs to
> this VM that is the issue but it does not appear to be corrupt
> from a vmdk standpoint. Just the data inside of it.

Also, you are using VMDK image files, that implies you are running
ESX as your hypervisor, yes? If so, that limits our ability to help
you track the source of the corruption...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
