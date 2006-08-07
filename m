Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Aug 2006 03:36:05 -0700 (PDT)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k77AZfDW030972
	for <linux-xfs@oss.sgi.com>; Mon, 7 Aug 2006 03:35:43 -0700
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1GA2Rq-0005aY-Ap
	for linux-xfs@oss.sgi.com; Mon, 07 Aug 2006 12:35:02 +0200
Received: from blueice4n1.de.ibm.com ([195.212.29.187])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Mon, 07 Aug 2006 12:35:02 +0200
Received: from mykleb by blueice4n1.de.ibm.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Mon, 07 Aug 2006 12:35:02 +0200
From: Jan-Frode Myklebust <mykleb@no.ibm.com>
Subject: Re: Concurrent mount of XFS over SAN
Date: Mon, 7 Aug 2006 12:13:10 +0200
Message-ID: <slrnede4hl.bg1.mykleb@99RXZYP.ibm.com>
References: <44D26D3E.5010708@exegy.com> <20060807084830.58133.qmail@web31713.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

On 2006-08-07, Heilige Gheist <hgheist@yahoo.com> wrote:
> It's obvious that I can always fall back to the inter-node heart-beat
> to ensure that only one node is mounting the filesystem.
> I'm just wondering if there's any facility or accepted practice to
> enforce it.

STONITH (Shoot The Other Node In The Head) trough smart power switches
or management adapters in the node. 

SCSI reserve/release ... No idea how reliable this is on a SAN, but the
ServeRAID-version works great. http://www.linux-ha.org/ServeRAID

Export the volume group, or scsi device on the first node, before
importing/attaching it on the second .. Probably best to use together
with STONITH, in case the first node fails on unmounting/exporting.

BTW: I think XFS on IRIX had the owning node name in the file system header, 
and only would allow this node to mount the fs. But I can't find this now...
Maybe it's gone, or maybe it was in xlv.. ?


  -jf
