Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5JDPWek095209 for <xfs@oss.sgi.com>; Tue, 19 Jun 2012 08:25:32 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CKE2Q9FORHs8phgy for
	<xfs@oss.sgi.com>; Tue, 19 Jun 2012 06:25:31 -0700 (PDT)
Date: Tue, 19 Jun 2012 15:25:21 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
In-Reply-To: <20120619131649.GA6811@redhat.com>
Message-ID: <alpine.LFD.2.00.1206191519320.21961@dhcp-1-248.brq.redhat.com>
References: <4FDF9EBE.2030809@shiftmail.org> <20120619015745.GJ25389@dastard>
	<20120619031241.GA3884@redhat.com>
	<alpine.LFD.2.00.1206190816440.2241@dhcp-1-248.brq.redhat.com>
	<20120619131649.GA6811@redhat.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571144193-910616001-1340112324=:21961"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: xfs@oss.sgi.com, device-mapper development <dm-devel@redhat.com>, Spelic <spelic@shiftmail.org>, =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>, linux-ext4@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571144193-910616001-1340112324=:21961
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 19 Jun 2012, Mike Snitzer wrote:

> Date: Tue, 19 Jun 2012 09:16:49 -0400
> From: Mike Snitzer <snitzer@redhat.com>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Dave Chinner <david@fromorbit.com>, Spelic <spelic@shiftmail.org>,
>     device-mapper development <dm-devel@redhat.com>,
>     linux-ext4@vger.kernel.org, xfs@oss.sgi.com
> Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
> 
> On Tue, Jun 19 2012 at  2:32am -0400,
> Lukáš Czerner <lczerner@redhat.com> wrote:
> 
> > On Mon, 18 Jun 2012, Mike Snitzer wrote:
> > 
> > > Date: Mon, 18 Jun 2012 23:12:42 -0400
> > > From: Mike Snitzer <snitzer@redhat.com>
> > > To: Dave Chinner <david@fromorbit.com>
> > > Cc: Spelic <spelic@shiftmail.org>,
> > >     device-mapper development <dm-devel@redhat.com>,
> > >     linux-ext4@vger.kernel.org, xfs@oss.sgi.com
> > > Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
> > > 
> > > On Mon, Jun 18 2012 at  9:57pm -0400,
> > > Dave Chinner <david@fromorbit.com> wrote:
> > > 
> > > > On Mon, Jun 18, 2012 at 11:33:50PM +0200, Spelic wrote:
> > > >
> > > > > Please note that since I am above MD raid5 (I believe this is the
> > > > > reason), the passdown of discards does not work, as my dmesg says:
> > > > > [160508.497879] device-mapper: thin: Discard unsupported by data
> > > > > device (dm-1): Disabling discard passdown.
> > > > > but AFAIU, unless there is a thinp bug, this should not affect the
> > > > > unmapping of thin blocks by fstrimming xfs... and in fact ext4 is
> > > > > able to do that.
> > > > 
> > > > Does ext4 report that same error?
> > > 
> > > That message says the underlying device doesn't support discards
> > > (because it is an MD device).  But the thinp device still has discards
> > > enabled -- it just won't pass the discards down to the underlying data
> > > device.
> > > 
> > > So yes, it'll happen with ext4 -- it is generated when the thin-pool
> > > device is loaded (which happens independent of the filesystem that is
> > > layered ontop).
> > > 
> > > The discards still inform the thin-pool that the corresponding extents
> > > are no longer allocated.
> > 
> > So do I understand correctly that even though the discard came
> > through and thinp took advantage of it it still returns EOPNOTSUPP ?
> 
> No, not correct.  Why are you assuming this?  I must be missing
> something from this discussion that led you there.

Those two paragraphs led me to that conclusion:

  That message says the underlying device doesn't support discards
  (because it is an MD device).  But the thinp device still has discards
  enabled -- it just won't pass the discards down to the underlying data
  device.

  The discards still inform the thin-pool that the corresponding extents
  are no longer allocated.

so I am a bit confused now. Why the dm-thin returned EOPNOTSUPP then
? Is that because it has been configured to ignore_discard, or it
actually takes advantage of the discard but underlying device does
not support it (and no_discard_passdown is not set) so it return
EOPNOTSUPP ?

> 
> > This seems rather suboptimal. IIRC there was a discussion to add an
> > option to enable/disable sending discard in thinp target down
> > to the device.
> > 
> > So maybe it might be a bit smarter than that and actually
> > enable/disable discard pass through depending on the underlying
> > support, so we do not blindly send discard down to the device even
> > though it does not support it.
> 
> Yes, that is what we did.
> 
> Discards are enabled my default (including discard passdown), but if the
> underlying data device doesn't support discards then the discards will
> not be passed down.
> 
> And here are the feature controls that can be provided when loading the
> thin-pool's DM table:
> 
> ignore_discard: disable discard
> no_discard_passdown: don't pass discards down to the data device
> 
> -EOPNOTSUPP is only ever returned if 'ignore_discard' is provided.

Ok, so in this case 'ignore_discard' has been configured ?

Thanks!
-Lukas
--571144193-910616001-1340112324=:21961
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--571144193-910616001-1340112324=:21961--
