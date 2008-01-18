Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 18 Jan 2008 09:55:47 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0IHtcr0005585
	for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 09:55:41 -0800
Received: from mail.purevideo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 06780C8B3D7
	for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 09:55:56 -0800 (PST)
Received: from mail.purevideo.com (mail.purevideo.com [208.50.29.149]) by cuda.sgi.com with ESMTP id P9Q2yGmxd7VFBq3w for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 09:55:56 -0800 (PST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: Repairing a possibly incomplete xfs_growfs command?
Date: Fri, 18 Jan 2008 09:50:37 -0800
Message-ID: <9CE70E6ED2C2F64FB5537A2973FA4F0253595B@pvn-3001.purevideo.local>
In-Reply-To: <20080117234604.GG155407@sgi.com>
References: <9CE70E6ED2C2F64FB5537A2973FA4F0253595A@pvn-3001.purevideo.local> <20080117234604.GG155407@sgi.com>
From: "Mark Magpayo" <mmagpayo@purevideo.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

> > So is this all I need then prior to an xfs_repair?:
> >
> > > # for i in `seq 0 1 63`; do
> > > > xfs_db -x -c "sb $i" -c 'write agcount 64' -c 'write dblock
> 4761733120'
> > > /dev/vg0/lv0
> 
> Yes, I think that is all that is necessary (that+repair was what fixed
> the problem at the customer site successfully).
> 

Is this supposed to be the proper output to the command above?

purenas:~# for i in `seq 0 1 63`; do xfs_db -x -c "sb $i" -c 'write
agcount 64' -c 'write dblock 4761733120' /dev/vg0/lv0; done
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error
agcount = 64
field dblock not found
parsing error

Hopefully I just mis-typed something?

Thanks,

Mark
