Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBNJWh8D232460 for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 13:32:44 -0600
Received: from mx1.u-picardie.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C56401CF52A8
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 11:34:42 -0800 (PST)
Received: from mx1.u-picardie.fr (mx1.u-picardie.fr [193.49.184.7]) by
	cuda.sgi.com with ESMTP id NVpati1CUS1j2tsz for
	<xfs@oss.sgi.com>; Thu, 23 Dec 2010 11:34:42 -0800 (PST)
From: laurent+xfs@u-picardie.fr
Subject: Re: able to mount a fs, unable to repair it
References: <87r5d9uuez.fsf@ezri.u-picardie.fr>
	<20101223183531.19464601@galadriel.home>
Date: Thu, 23 Dec 2010 20:34:41 +0100
In-Reply-To: <20101223183531.19464601@galadriel.home> (Emmanuel Florac's
	message of "Thu, 23 Dec 2010 18:35:31 +0100")
Message-ID: <87zkrws2pa.fsf@ezri.u-picardie.fr>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

Emmanuel Florac <eflorac@intellique.com> writes:

Bonsoir Emmanuel,

> Le Thu, 23 Dec 2010 02:53:08 +0100 vous =E9criviez:
>
>> For a reason all my xfs FS got corrupted at the same time.
>> My setup is: xen host using lvm on top of soft raid6 on top of jbod
>> 3ware connected sata disks.
>> Both the host and the VM fs got corrupted.
>
> RAID-6 is extremely stable on the 3Ware, while software RAID-6 is
> dubbed experimental in the kernel. Software RAID can provide seducely
> high performance when running benchmarks, but IMO it doesn't fly when
> you need your CPU to do some other jobs, like running NFS daemons or
> even worse, VMs. Under high CPU loads concurrently coming from the
> software RAID and virtualisation stack, so many things may go
> wrong...

I can't agree more, I'm using both nfs AND VMs :)
It is very slow and very cpu consuming.
I'm moving away from xen to lxc on this home server, pretty sure it
will help.

> My advice : software RAID stinks under high CPU load/ high IO. Use
> hardware RAID whenever possible because it provides more predictable
> performance and remove many weird software interactions from the
> picture.

The 3w9550sx doesn't raid6, but I admit I've been thinking of using
its raid5 instead of the slow soft raid6.

Thanks for your advices :)

-- =

Laurent

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
