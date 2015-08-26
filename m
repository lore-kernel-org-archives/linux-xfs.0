Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9FA8B7F47
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 02:25:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2ADCDAC005
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 00:25:36 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id oxjmAIjLYlbKOk2I for
	<xfs@oss.sgi.com>; Wed, 26 Aug 2015 00:25:34 -0700 (PDT)
From: Martin Steigerwald <martin@lichtvoll.de>
Subject: Re: Performance impact of mkfs.xfs vs mkfs.xfs -f
Date: Wed, 26 Aug 2015 09:25:33 +0200
Message-ID: <1594865.42kc89uJrg@merkaba>
In-Reply-To: <20150826010923.GX3902@dastard>
References: <CABppvi6GdaTQgqpYJi6RhkpjP9ydTV8-2VV8LF9tHSN63XzWtA@mail.gmail.com>
	<55DD0AAF.9090401@opensuse.org> <20150826010923.GX3902@dastard>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com
Cc: "Carlos E. R." <carlos.e.r@opensuse.org>

Am Mittwoch, 26. August 2015, 11:09:23 schrieb Dave Chinner:
> On Wed, Aug 26, 2015 at 02:39:11AM +0200, Carlos E. R. wrote:
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA256
> > 
> > On 2015-08-26 01:43, Dave Chinner wrote:
> > > On Tue, Aug 25, 2015 at 04:09:33PM -0700, Shrinand Javadekar
> > > 
> > > wrote:
> > >> Formatted the new disks with mkfs.xfs. Ran the workload.
> > >> Reformatted the disks with mkfs.xfs -f. Ran the workload.
> > > 
> > > Anyway, please post the output so we can see the differences for
> > > ourselves. What we need is mkfs output in both cases, and xfs_info
> > > 
> > >  output in both cases after mount.
> > 
> > Suggestion (for the OP):
> > 
> > To reformat a third time without "-f", you can reformat as ext4, then
> > format a second time as xfs.
> 
> That doesn't work - mkfs.xfs detects that the device has an ext4
> filesystem on it, and demands you use -f to overwrite it.
> 
> > But to imitate a new disk, you have to
> > zero it with dd.
> 
> Only the first MB or so - enough for blkid not to be able to see a
> filesystem signature on it.

wipefs command.

Thanks,
-- 
Martin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
