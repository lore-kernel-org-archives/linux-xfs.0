Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9BA5E7F50
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 08:21:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 715533040AA
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 06:21:36 -0700 (PDT)
Received: from mail-la0-f54.google.com (mail-la0-f54.google.com
	[209.85.215.54]) by cuda.sgi.com with ESMTP id UgbIzDdAB17CmQZd
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 28 Mar 2013 06:21:31 -0700 (PDT)
Received: by mail-la0-f54.google.com with SMTP id gw10so17790814lab.13
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 06:21:30 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 28 Mar 2013 09:21:29 -0400
Message-ID: <CAJoqCq9WhFi8yZnTjh_dJmOte4TWpKg3qsQLpVsZ45M8XoWiaA@mail.gmail.com>
Subject: Help with XFS in VMs on VMFS
From: Jan Perci <jperci@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4710435343900256876=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4710435343900256876==
Content-Type: multipart/alternative; boundary=089e01160be6564f9504d8fc0814

--089e01160be6564f9504d8fc0814
Content-Type: text/plain; charset=ISO-8859-1

Hello.

I would like to use XFS in VMs with VMFS datastores on top of RAID-6.  The
RAID is a FC 14+2 x 4TB with 64K stripe.  There are 6 of these arrays.
 Each contains one aligned VMFS partition, and this VMFS partition is
shared by 4 ESXi hosts.  Each host runs 2-3 compute nodes, and some of
these nodes have multiple partitions consuming 20-50 TB.  The data is
comprised of files ranging from 100KB to 500KB, with few outliers reaching
many MB.  The directory hierarchy is such that no single directory contains
more than 2,000 or so of these files.  The data is added almost exclusively
append-only, i.e. write once when added and read many times afterwards, but
they come in spikes of 1-20GB at a time.  As the partitions fill up, new
ones are added, but sometimes the existing partitions must be grown.

Normally I would use raw mappings and XFS directly on the volumes.  But
there is a hard requirement to support VM snapshots, so all the data must
reside within VMDK files on the VMFS datastores.  ESXi has a VMDK size
limit of 2TB.  So, I am forced to create many 2TB virtual disks and attach
them to the host, then use Linux LVM to group them into a single LV, then
create XFS on the LV.

This setup is not optimal and has risks, but I must work within some
constraints.  There are a few things I can do to increase I/O performance,
such as distributing the VMDK files used by each LV across the 6 VMFS
datastores.  But can XFS be tuned as well?  Do stripe unit and stripe width
help?  Thanks for your help.

Jan.

--089e01160be6564f9504d8fc0814
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello.<div><br><div>I would like to use XFS in VMs with VMFS datastores on =
top of RAID-6. =A0The RAID is a FC 14+2 x 4TB with 64K stripe. =A0There are=
 6 of these arrays. =A0Each contains one aligned VMFS partition, and this V=
MFS partition is shared by 4 ESXi hosts. =A0Each host runs 2-3 compute node=
s, and some of these nodes have multiple partitions consuming 20-50 TB. =A0=
The data is comprised of files ranging from 100KB to 500KB, with few outlie=
rs reaching many MB. =A0The directory hierarchy is such that no single dire=
ctory contains more than 2,000 or so of these files. =A0The data is added a=
lmost exclusively append-only, i.e. write once when added and read many tim=
es afterwards, but they come in spikes of 1-20GB at a time. =A0As the parti=
tions fill up, new ones are added, but sometimes the existing partitions mu=
st be grown.<div>

<br></div><div>Normally I would use raw mappings and XFS directly on the vo=
lumes. =A0But there is a hard requirement to support VM snapshots, so all t=
he data must reside within VMDK files on the VMFS datastores. =A0ESXi has a=
 VMDK size limit of 2TB. =A0So, I am forced to create many 2TB virtual disk=
s and attach them to the host, then use Linux LVM to group them into a sing=
le LV, then create XFS on the LV.</div>

<div><br></div><div>This setup is not optimal and has risks, but I must wor=
k within some constraints. =A0There are a few things I can do to increase I=
/O performance, such as distributing the VMDK files used by each LV across =
the 6 VMFS datastores. =A0But can XFS be tuned as well? =A0Do stripe unit a=
nd stripe width help? =A0Thanks for your help.</div>

<div><br></div><div>Jan.</div><div><br></div><div><br></div>
</div></div>

--089e01160be6564f9504d8fc0814--


--===============4710435343900256876==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4710435343900256876==--
