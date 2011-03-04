Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2478a21145241 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 01:08:37 -0600
Received: from mail.nethype.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 426BB3121AC
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2011 23:11:25 -0800 (PST)
Received: from mail.nethype.de (mail.nethype.de [78.47.73.129]) by
	cuda.sgi.com with ESMTP id Wk0UzDQHByDFEwhB for
	<xfs@oss.sgi.com>; Thu, 03 Mar 2011 23:11:25 -0800 (PST)
Received: from [10.0.0.5] (helo=doom.schmorp.de)
	by mail.nethype.de with esmtp (Exim 4.72)
	(envelope-from <schmorp@schmorp.de>) id 1PvPAZ-0001tO-KC
	for xfs@oss.sgi.com; Fri, 04 Mar 2011 07:11:23 +0000
Received: from [10.0.0.1] (helo=cerebro.laendle)
	by doom.schmorp.de with esmtp (Exim 4.72)
	(envelope-from <schmorp@schmorp.de>) id 1PvPAZ-0000WT-Ef
	for xfs@oss.sgi.com; Fri, 04 Mar 2011 07:11:23 +0000
Received: from root by cerebro.laendle with local (Exim 4.72)
	(envelope-from <root@schmorp.de>) id 1PvPAZ-0002YH-C0
	for xfs@oss.sgi.com; Fri, 04 Mar 2011 08:11:23 +0100
Date: Fri, 4 Mar 2011 08:11:23 +0100
From: Marc Lehmann <schmorp@schmorp.de>
Subject: Re: corruption, xfs_repair 3.1.4 segfaults
Message-ID: <20110304071123.GC2316@schmorp.de>
References: <20110302175818.GA8290@schmorp.de>
	<20110302224329.3f62c172@galadriel2.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110302224329.3f62c172@galadriel2.home>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Wed, Mar 02, 2011 at 10:43:29PM +0100, Emmanuel Florac <eflorac@intelliq=
ue.com> wrote:
> Le Wed, 2 Mar 2011 18:58:18 +0100 vous =E9criviez:
> =

> > I had a case of filesystem corruption a day ago:
> > =


Thanks for your reply (and sorry for apparrently submitting my mail
multiple times - the crashed machine is also the mail relay and had some
trouble).

> What's the kernel version? It's apparently a loopback device, what is
> mounted and how?

Right... it's 2.6.32-5-amd64 (the debian squeeze kernel), and it is indeed a
loopback device.

It's normally mounted like this:

   mount -orelatime,biosize=3D28,logbufs=3D8,logbsize=3D256k,allocsize=3D8k=
,inode64,largeio ...

There are five logical volumes on this machine which are mounted via
loopback device, all XFS. The other ones seem to work fine.

> Your log looks quite hopeless at first glance...

I hope not :) I can mount the volume read-only, and apparently read a lot
of files on it. My main problem seems to be the crashing xfs_repair.

-- =

                The choice of a       Deliantra, the free code+content MORPG
      -----=3D=3D-     _GNU_              http://www.deliantra.net
      ----=3D=3D-- _       generation
      ---=3D=3D---(_)__  __ ____  __      Marc Lehmann
      --=3D=3D---/ / _ \/ // /\ \/ /      schmorp@schmorp.de
      -=3D=3D=3D=3D=3D/_/_//_/\_,_/ /_/\_\

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
