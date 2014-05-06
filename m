Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EEB7D7F37
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 17:49:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 806E9AC003
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 15:49:45 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	UPMoh3uUXBIr0rDa for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 15:49:42 -0700 (PDT)
Date: Wed, 7 May 2014 08:49:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xf kernel trace , what is the cause ?
Message-ID: <20140506224940.GP5421@dastard>
References: <CAJzjPK=YF3=xx5dSGzw4S44Nf01o6d1tcqiiofE4m-nuWdOKTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJzjPK=YF3=xx5dSGzw4S44Nf01o6d1tcqiiofE4m-nuWdOKTQ@mail.gmail.com>
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
To: Gregory Machin <gdm@linuxpro.co.za>
Cc: xfs@oss.sgi.com

On Wed, May 07, 2014 at 09:18:46AM +1200, Gregory Machin wrote:
> Hi.
> 
> I have a file server that has had 2 xfs Kernel trace dumps about 2 weeks
> apart.
> 
> The RAID 60 data store is mounted as /home with xfs as the file system. The
> /home space is shares via NFS export and CIFS share.  At the time of
> the Trace dumps NFS access hangs and crashed users sessions on the client
> side.  The output of the last traces is below.
> 
> Can you advise as to the cause of this dump and possible resolution ?

Commit 2732036 ("xfs: xfs_remove deadlocks due to inverted AGF vs AGI
lock ordering") fixed it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
