Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6NHljb9195069 for <xfs@oss.sgi.com>; Mon, 23 Jul 2012 12:47:45 -0500
Received: from ppsw-51.csi.cam.ac.uk (ppsw-51.csi.cam.ac.uk [131.111.8.151])
	by cuda.sgi.com with ESMTP id E9fxn88Ctnhvsgqy for
	<xfs@oss.sgi.com>; Mon, 23 Jul 2012 10:47:44 -0700 (PDT)
Received: from smtp.damtp.cam.ac.uk ([131.111.18.84]:50878
	helo=septal.damtp.cam.ac.uk)
	by ppsw-51.csi.cam.ac.uk (ppsw.cam.ac.uk [131.111.8.138]:25)
	with esmtp id 1StMjP-0003Ir-Yd (Exim 4.72) for xfs@oss.sgi.com
	(return-path <J.S.Peatfield@damtp.cam.ac.uk>);
	Mon, 23 Jul 2012 18:47:43 +0100
Date: Mon, 23 Jul 2012 18:47:43 +0100 (BST)
From: Jon Peatfield <J.S.Peatfield@damtp.cam.ac.uk>
Subject: Re: Assert in xfs_repair (Phase 7) and other xfs_restore problems
In-Reply-To: <alpine.LRH.2.02.1207202022300.7993@floggle-toggle.damtp.cam.ac.uk>
Message-ID: <alpine.LRH.2.02.1207231844560.7993@floggle-toggle.damtp.cam.ac.uk>
References: <alpine.LRH.2.02.1207202022300.7993@floggle-toggle.damtp.cam.ac.uk>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Jon Peatfield <J.S.Peatfield@damtp.cam.ac.uk>

Just askign the last question again in case the earlier summary data put 
people off reading it...


On Fri, 20 Jul 2012, Jon Peatfield wrote:
...
> Anyway all of the later runs now end with:
>
> ...
> disconnected dir inode 3892327224, moving to lost+found
> disconnected dir inode 3892327225, moving to lost+found
> disconnected dir inode 3892327226, moving to lost+found
> disconnected dir inode 3892327227, moving to lost+found
> disconnected dir inode 3892327229, moving to lost+found
> disconnected dir inode 3892327231, moving to lost+found
> Phase 7 - verify and correct link counts...
> resetting inode 256 nlinks from 8 to 5
> resetting inode 261 nlinks from 2 to 13006001
> xfs_repair: phase7.c:47: set_nlinks: Assertion `fs_inode_nlink' failed.
>
>
> Now in phase7.c it asserts if nlinks is over 65536 which 13006001 clearly is:
>
>            do_warn(_("resetting inode %" PRIu64 " nlinks from %u to %u\n"),
>                    ino, dinoc->di_nlink, nrefs);
>
>            if (dinoc->di_version == 1 && nrefs > XFS_MAXLINK_1)  {
>                    ASSERT(fs_inode_nlink);
>                    do_warn(
> _("nlinks %u will overflow v1 ino, ino %" PRIu64 " will be converted to 
> version 2\n"),
>                            nrefs, ino);
>
>            }
>            dinoc->di_nlink = nrefs;

...
> Have I completely destroyed this filesystem or is there any hope of getting 
> any of the files back ? (all the error messages I have seen were about 
> problems with the directories so some or all of the files and structures may 
> still be present)...
>
> If it is destroyed (it only contained backup trees so I can live with it 
> being lost), what should I have done differently?  ie what was my first 
> mistake ?
>
> I'm hoping to at least learn something from what went wrong.
...

So can I get xfs_repair to either put the ~13M disconnected files into 
lost+found or somewhere else ?  Does it matter that lost+found does not 
already exist?

  -- Jon

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
