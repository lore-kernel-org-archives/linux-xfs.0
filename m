Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0UBJtvu013980
	for <linux-xfs@oss.sgi.com>; Mon, 30 Jan 2012 05:19:57 -0600
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id izh5UM8Hh4wZfJdi (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Mon, 30 Jan 2012 03:19:53 -0800 (PST)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1RrpH2-0005Fi-Qe
	for linux-xfs@oss.sgi.com; Mon, 30 Jan 2012 12:19:51 +0100
Received: from bd206cc2.virtua.com.br ([bd206cc2.virtua.com.br])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 30 Jan 2012 12:19:48 +0100
Received: from marcosfrm by bd206cc2.virtua.com.br with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 30 Jan 2012 12:19:48 +0100
From: Marcos Mello <marcosfrm@gmail.com>
Subject: Re: Placing the root partition on an XFS filesystem is not supported
Date: Mon, 30 Jan 2012 11:19:39 +0000 (UTC)
Message-ID: <loom.20120130T120943-158@post.gmane.org>
References: <loom.20120129T133929-288@post.gmane.org>
	<4F265EE3.6020908@hardwarefreak.com>
Mime-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

Stan Hoeppner <stan <at> hardwarefreak.com> writes:

> 
> On 1/29/2012 6:46 AM, Marcos Mello wrote:
> >
http://git.fedorahosted.org/git/?p=anaconda.git;a=commit;h=b3e19d43840f6c4015fab75411853003fcf26a63
> > 
> > Does someone knows why? I'm trying to get rid of EXT* partitions on my new
> > CentOS 6.2 installs but apparently it will not be possible.
> 
> I'm unsure what this Fedora commit is all about, but in the general
> Linux case you can put root on XFS, with a minor caveat.  See:
> 
> http://www.xfs.org/index.php/XFS_FAQ#Q:_Can_XFS_be_used_for_a_root_filesystem.3F
> 

Yeah, some time ago I run XFS as my / on Arch. But Anaconda doesn't allow it
now. So we're still forced to have an EXT partition for the root filesystem in
the Red Hat land.

Found this
http://pastebin.com/gHqGGkSp

Marcos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
