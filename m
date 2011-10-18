Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9I9x4v1078276 for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 04:59:04 -0500
Received: from smtprelay03.ispgateway.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A35C1D5A4F
	for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 02:59:02 -0700 (PDT)
Received: from smtprelay03.ispgateway.de (smtprelay03.ispgateway.de
	[80.67.31.26]) by cuda.sgi.com with ESMTP id nJCdj0CKHKRDkZHj
	for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 02:59:02 -0700 (PDT)
Message-ID: <4E9D4DE3.5080304@cape-horn-eng.com>
Date: Tue, 18 Oct 2011 11:58:59 +0200
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: xfs_repair v3.1.6 - Segmentation fault AND XFS internal error
	xfs_btree_check_sblock
References: <4E9C3EEF.5080609@cape-horn-eng.com>
	<20111017225223.GU3159@dastard>
In-Reply-To: <20111017225223.GU3159@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 10/18/2011 12:52 AM, Dave Chinner wrote:
> A corrupt inode allocation btree - not a particularly common type of
> corruption to be reported. Do you know what caused the errors to
> start being reported? A crash, a bad disk, a raid rebuild, something
> else?  That information always helps us understand how badly damaged
> the filesystem might be....

We had a hard disc failure on an Areca 1680 RAID controller, RAID 6. I
checked the firmware and the last available version is already installed.


> And I'd guess that is failing on a different problem - a corrupt
> inode most likely. You've build xfs-repair from the source code -
> can yo urun it under gdb so we can see where it is dying?

I already run it under gdb and sent some mails to Christoph Hellwig. He
found an *issue* in the xfsprogs/repair/attr_repair.c code and sent me a
patch that fixed it. Now "xfs_repair -n -P /dev/sdb1" runs without
errors. But before repairing the XFS I have to rsync as much as I can
from this XFS to another one which is still not available. So it will
take a couple of days before I can run xfs_repair on the XFS.



> That sounds like there's a *lot* of damage to the filesystem. That
> makes it even more important that we understand what caused the
> damage in the first place....

Yes, lots of damage. 8(


Thanks for your help,
Richard


-- =

Richard Ems       mail: Richard.Ems@Cape-Horn-Eng.com

Cape Horn Engineering S.L.
C/ Dr. J.J. D=F3mine 1, 5=BA piso
46011 Valencia
Tel : +34 96 3242923 / Fax 924
http://www.cape-horn-eng.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
