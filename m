Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Jun 2008 05:07:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5AC7G2w017195
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 05:07:16 -0700
Received: from mail.brightcove.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E77FC691D6
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 05:08:11 -0700 (PDT)
Received: from mail.brightcove.com (mail.brightcove.com [38.113.27.188]) by cuda.sgi.com with ESMTP id xpIJJCqajwpZdrZF for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 05:08:11 -0700 (PDT)
From: Lance Reed <lreed@brightcove.com>
Date: Tue, 10 Jun 2008 08:07:18 -0400
Subject: RE: Probems with xfs_repair on large filesystem and 32bit OS.
Message-ID: <6A32BC807C106440B7E23208F280DDAF01D3F6C8B4@bcmail1.VIDMARK.LOCAL>
References: <6A32BC807C106440B7E23208F280DDAF01D3F6C8A8@bcmail1.VIDMARK.LOCAL>
 <20080610115038.GD3005@sillage.bis.pasteur.fr>
In-Reply-To: <20080610115038.GD3005@sillage.bis.pasteur.fr>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tru Huynh <tru@pasteur.fr>
Cc: "'xfs@oss.sgi.com'" <xfs@oss.sgi.com>

SO, I take it from what you say that that I can running any newer version of xfs progs and a 64bit host (fiber attached, easy to do this), and run xfs_repair on the 32bit XFS volumes without fear of data corruption?
Is this because XFS is not version specific, and xfs_repair will honor the 32bit file data structures?

Again thanks so much for your response!


Lance
-----Original Message-----
From: Tru Huynh [mailto:tru@pasteur.fr]
Sent: Tuesday, June 10, 2008 7:51 AM
To: Lance Reed
Subject: Re: Probems with xfs_repair on large filesystem and 32bit OS.

On Tue, Jun 10, 2008 at 07:28:21AM -0400, Lance Reed wrote:
> So I am having trouble fixing a corrupted <16 TB file system on a 32bit Linux
> system:
>
>
> The problem is that xfs_repair dies due to xfs_repair: libxfs_initbuf can't
> memalign 4096 bytes: Cannot allocate memory:
>
> I found the below post, but the links are dead.
>
> I tried upping the system RAM to 12 GB, but the problem still exists, which I
> assume is the per process limit of 1-4 GB.
you are on a 32 bits OS, so I would say are hitting a hard limit per process.
>
> So I am looking for advice on how to fix a large 32bit filesystem.  I see
> options about running on a 64bit host.  Can I do this with a newer version of
> xfs and kernel?  We have many hosts that run 64bit Linux (2.6.18-8.1.15.el5
> x86_64) and updated xfs progs.  Is it possible to mount the existing LVM
> volumes on a new 64bit host with a newer OS and xfs progs and not risk losing
> data.  Os details for old and possible new host below:
>
My 0.2 cents.
- you can install a x86_64 CentOS-4 machine and fix it from there
or
- you can install a x86_64 CentOS-5 machine and fix it from there
or
- upgrade to the **development** versions for CentOS-4 i386 at
https://projects.centos.org/trac/xfs/

http://people.centos.org/tru/XFS/centos-4/RPMS/i386/xfsprogs-2.9.8-2.c4.i686.rpm
http://people.centos.org/tru/XFS/centos-4/RPMS/i386/xfsdump-2.2.48-1.c4.i686.rpm
and the right kmod-xfs http://people.centos.org/tru/XFS/centos-4/RPMS/i386/

> CentOS release 4.4 (Final)
you should be running 4.6
> 2.6.9-42.ELsmp  i686 i686 i386 GNU/Linux
and 2.6.9-67.0.7.ELsmp...
>
> Possible new host.:
>
> CentOS release 5 (Final)
> 2.6.18-8.1.15.el5  x86_64
2.6.18-53.1.21.el5

> xfsprogs-2.9.4-1.el5.centos
> xfsdump-2.2.46-1.el5.centos
or
http://people.centos.org/tru/XFS/centos-5/RPMS/x86_64/xfsprogs-2.9.8-1.c5.x86_64.rpm
http://people.centos.org/tru/XFS/centos-5/RPMS/x86_64/xfsdump-2.2.48-1.c5.x86_64.rpm

> kmod-xfs-0.4-1.2.6.18_8.1.15.el5
or
http://people.centos.org/tru/XFS/centos-5/RPMS/x86_64/kmod-xfs-0.4-2.2.6.18_53.1.21.el5.x86_64.rpm

Cheers,

Tru
--
Dr Tru Huynh          | http://www.pasteur.fr/recherche/unites/Binfs/
mailto:tru@pasteur.fr | tel/fax +33 1 45 68 87 37/19
Institut Pasteur, 25-28 rue du Docteur Roux, 75724 Paris CEDEX 15 France
