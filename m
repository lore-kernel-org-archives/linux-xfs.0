Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0A5AF7F58
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 16:45:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8782DAC002
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 14:45:55 -0700 (PDT)
Received: from pirx.askja.de (pirx.askja.de [83.137.103.148]) by cuda.sgi.com
	with ESMTP id iqcMc5dV82EHNG9y for <xfs@oss.sgi.com>;
	Thu, 28 Mar 2013 14:45:54 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by pirx.askja.de (Postfix) with ESMTP id 6AA06300AD
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 22:45:51 +0100 (CET)
Received: from pirx.askja.de ([127.0.0.1])
	by localhost (pirx.askja.de [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 0j2W6j05ig6X for <xfs@oss.sgi.com>;
	Thu, 28 Mar 2013 22:45:51 +0100 (CET)
Date: Thu, 28 Mar 2013 22:45:50 +0100
From: Ralf Gross <Ralf-Lists@ralfgross.de>
Subject: Re: Help with XFS in VMs on VMFS
Message-ID: <20130328214550.GA3771@pirx.askja.de>
References: <CAJoqCq9WhFi8yZnTjh_dJmOte4TWpKg3qsQLpVsZ45M8XoWiaA@mail.gmail.com>
	<51549F09.1090109@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51549F09.1090109@hardwarefreak.com>
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

Stan Hoeppner schrieb:
> On 3/28/2013 8:21 AM, Jan Perci wrote:
> 
> > Normally I would use raw mappings and XFS directly on the volumes.  But
> > there is a hard requirement to support VM snapshots, so all the data must
> > reside within VMDK files on the VMFS datastores.
> 
> Since when?  ESX has had LUN snapshot capability back to 3.0, 6 years or
> so.  It may have required the VCB add on back then.

Snapshots are possible with RDM in virtual compatibily mode, not
physical mode (> 2 TB).

http://pubs.vmware.com/vsphere-51/topic/com.vmware.vsphere.storage.doc/GUID-0114693D-94BF-4D0E-9BA4-416D4A51A5A1.html
 
> Is this simply a limitation of the freebie version?  If so, pony up and
> pay for what you need, or switch to a FOSS solution which has no such
> limitations.

No, thats the limit for all versions.

 
> VMFS volumes are not intended for high performance IO.  Unless things
> have changed recently, VMware has always recommended housing only OS
> images and the like in VMDKs, not user data.  They've always recommended
> using RDMs for everything else.  IIRC VMDKs have a huge block (sector)
> size, something like 1MB.  That's going to make XFS alignment difficult,
> if not impossible.

I can't remember that I've every found this recommendation on a vmware
page.

http://blogs.vmware.com/vsphere/2013/01/vsphere-5-1-vmdk-versus-rdm.html

 
> I cannot stress emphatically enough that you should not stitch 2TB VMDKs
> together and use them in the manner you described.  This is a recipe for
> disaster.  Find another solution.

I'm seeing more and more requests for VMs with large disks lately in my
env. Right now the max. is ~2 TB. I'm also thinking about where to go,
 > 2 TB ist only possible with pRDMs which can't be snapshotted. You
have to use the snapshot features of your storage array.

Ralf

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
