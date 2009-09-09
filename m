Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n89LPOHr182311 for <xfs@oss.sgi.com>; Wed, 9 Sep 2009 16:25:39 -0500
Received: from mail1.slb.deg.dub.stisp.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id D1433161FB79
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2009 14:25:54 -0700 (PDT)
Received: from mail1.slb.deg.dub.stisp.net (mail1.slb.deg.dub.stisp.net
	[84.203.253.98]) by cuda.sgi.com with SMTP id Tc5wLx6eWtUDxsIm
	for <xfs@oss.sgi.com>; Wed, 09 Sep 2009 14:25:54 -0700 (PDT)
Message-ID: <4AA81CDB.8070509@draigBrady.com>
Date: Wed, 09 Sep 2009 22:23:39 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
MIME-Version: 1.0
Subject: Re: fsetxattr() fails on a writable descriptor?
References: <1251987642.3855.36.camel@dhcp-lab-219.englab.brq.redhat.com>
	<4AA1A3E6.2020606@draigBrady.com> <87k50den1e.fsf@meyering.net>
	<1252309787.3852.8.camel@dhcp-lab-219.englab.brq.redhat.com>
	<4AA4C950.3080303@draigBrady.com>
	<1252318482.3852.18.camel@dhcp-lab-219.englab.brq.redhat.com>
	<4AA6402D.8040209@draigBrady.com>
	<20090908184049.GA22050@infradead.org>
In-Reply-To: <20090908184049.GA22050@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, CoreutilsBugs <bug-coreutils@gnu.org>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Tue, Sep 08, 2009 at 12:29:49PM +0100, P??draig Brady wrote:
>> fsetxattr() is failing for me when the permissions are readonly
>> but the descriptor is writable as demonstrated by the program below.
>> I've tried this on ext3 and ext4 with libattr-2.4.43-3.fc11.i586
>> and linux-2.6.30.5-43.fc11.i586
> =

> That's not XFS specifci behaviour.  For all xattr operations, fd-based
> or not we always do the full permission checks, and have done so since
> day one.  Check the routined xattr_permission in fs/xattr.c of the
> kernel tree.  It seems a bit unusual, but I'm not sure changing it now
> is a good idea - the xattr support has been around for a long time.

Sorry if you get this twice. Resending using another server...

Thanks for this info Christoph.
http://lxr.linux.no/#linux+v2.6.30.5/fs/xattr.c

The specific issue we have is that `cp --preserve=3Dxattr` gets an
error when copying xattrs from a read only file. Since this has been
an xattr issue since the start, we'll have to work around it.
We'll probably temporarily set u+w on the new file to apply xattrs.

cheers,
P=E1draig.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
