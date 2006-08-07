Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Aug 2006 07:53:36 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.126.173])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k77ErJDW011973
	for <linux-xfs@oss.sgi.com>; Mon, 7 Aug 2006 07:53:22 -0700
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: Concurrent mount of XFS over SAN
Date: Mon, 7 Aug 2006 15:12:23 +0200
Message-ID: <55EF1E5D5804A542A6CA37E446DDC206393335@mapibe17.exchange.xchg>
In-Reply-To: <44D71DA2.2020409@skynet.be>
From: "Sebastian Brings" <sebas@silexmedia.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: kris buggenhout <kris.buggenhout@skynet.be>, Jan-Frode Myklebust <mykleb@no.ibm.com>
Cc: linux-xfs@oss.sgi.com

Maybe off topic meanwhile, but both Irix volume managers xlv and xvm
have the owner stored in the header. Xvm also has an understanding of a
cluster owning the volume, which is required for cxfs.

In a failover environment you absolutely have to make sure the failed
machine really has no more access to the volume, preferably by fencing
the FC switch ports, before you mount it on the standby system.
STONITH implementations also work, but still two machines have to agree
on the ownership when the failed machine comes up again.

Cheers
Sebastian

> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] On Behalf
Of
> kris buggenhout
> Sent: Montag, 7. August 2006 13:02
> To: Jan-Frode Myklebust
> Cc: linux-xfs@oss.sgi.com
> Subject: Re: Concurrent mount of XFS over SAN
> 
> afaik, the node was stored in xlv, which was an extra option in IRIX,
(
> extra license) but this could later be used in CXFS which allows
> multiple machines to mount the same FS read write from a SAN, made for
> clusters, HA and HPC...
> 
> knowledge of the node "owning" the device was in there for protection.
> but can be overridden with an xlv command.
> 
> kind regards, Kris
> 
> Jan-Frode Myklebust wrote:
> > On 2006-08-07, Heilige Gheist <hgheist@yahoo.com> wrote:
> >
> >> It's obvious that I can always fall back to the inter-node
heart-beat
> >> to ensure that only one node is mounting the filesystem.
> >> I'm just wondering if there's any facility or accepted practice to
> >> enforce it.
> >>
> >
> > STONITH (Shoot The Other Node In The Head) trough smart power
switches
> > or management adapters in the node.
> >
> > SCSI reserve/release ... No idea how reliable this is on a SAN, but
the
> > ServeRAID-version works great. http://www.linux-ha.org/ServeRAID
> >
> > Export the volume group, or scsi device on the first node, before
> > importing/attaching it on the second .. Probably best to use
together
> > with STONITH, in case the first node fails on unmounting/exporting.
> >
> > BTW: I think XFS on IRIX had the owning node name in the file system
> header,
> > and only would allow this node to mount the fs. But I can't find
this
> now...
> > Maybe it's gone, or maybe it was in xlv.. ?
> >
> >
> >   -jf
> >
> >
> >
> >
> >
> 
