Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 383087F37
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 01:06:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 23327304032
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 23:06:19 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Ha4KTQ2DVMsC6IvK for <xfs@oss.sgi.com>;
	Mon, 16 Mar 2015 23:06:17 -0700 (PDT)
Date: Tue, 17 Mar 2015 17:06:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfs: Supporting Host Aware SMR Drives
Message-ID: <20150317060601.GA10105@dastard>
References: <20150316060020.GB28557@dastard>
	<1426519733.4000.11.camel@HansenPartnership.com>
	<20150316203207.GD28557@dastard>
	<CAB-428kqj2KChEGmjqSXLhM4TMM-dsgK7LzkQXxgp5En4jBVRg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAB-428kqj2KChEGmjqSXLhM4TMM-dsgK7LzkQXxgp5En4jBVRg@mail.gmail.com>
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
To: Alireza Haghdoost <haghdoost@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Mar 16, 2015 at 08:12:16PM -0500, Alireza Haghdoost wrote:
> On Mon, Mar 16, 2015 at 3:32 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Mon, Mar 16, 2015 at 11:28:53AM -0400, James Bottomley wrote:
> >> Probably need to cc dm-devel here.  However, I think we're all agreed
> >> this is RAID across multiple devices, rather than within a single
> >> device?  In which case we just need a way of ensuring identical zoning
> >> on the raided devices and what you get is either a standard zone (for
> >> mirror) or a larger zone (for hamming etc).
> >
> > Any sort of RAID is a bloody hard problem, hence the fact that I'm
> > designing a solution for a filesystem on top of an entire bare
> > drive. I'm not trying to solve every use case in the world, just the
> > one where the drive manufactures think SMR will be mostly used: the
> > back end of "never delete" distributed storage environments....
> > We can't wait for years for infrastructure layers to catch up in the
> > brave new world of shipping SMR drives. We may not like them, but we
> > have to make stuff work. I'm not trying to solve every problem - I'm
> > just tryin gto address the biggest use case I see for SMR devices
> > and it just so happens that XFS is already used pervasively in that
> > same use case, mostly within the same "no raid, fs per entire
> > device" constraints as I've documented for this proposal...
> 
> I am confused what kind of application you are referring to for this
> "back end, no raid, fs per entire device". Are you gonna rely on the
> application to do replication for disk failure protection ?

Exactly. Think distributed storage such as Ceph and gluster where
the data redundancy and failure recovery algorithms are in layers
*above* the local filesystem, not in the storage below the fs.  The
"no raid, fs per device" model is already a very common back end
storage configuration for such deployments.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
