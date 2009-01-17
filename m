Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0HHZfIo027750 for <xfs@oss.sgi.com>; Sat, 17 Jan 2009 11:35:41 -0600
Received: from munster3.sis.pasteur.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A79298787
	for <xfs@oss.sgi.com>; Sat, 17 Jan 2009 09:35:38 -0800 (PST)
Received: from munster3.sis.pasteur.fr (munster3.sis.pasteur.fr
	[157.99.64.214]) by cuda.sgi.com with ESMTP id 43XdrZ2xlbTf2TQn
	for <xfs@oss.sgi.com>; Sat, 17 Jan 2009 09:35:38 -0800 (PST)
Date: Sat, 17 Jan 2009 18:35:37 +0100
From: Tru Huynh <tru@pasteur.fr>
Subject: Re: help with xfs_repair on 10TB fs
Message-ID: <20090117173537.GH15444@sillage.bis.pasteur.fr>
References: <adcf4ef70901170913l693376d7s6fd0395e2c88e10@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <adcf4ef70901170913l693376d7s6fd0395e2c88e10@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Alberto Accomazzi <aaccomazzi@gmail.com>
Cc: xfs@oss.sgi.com

On Sat, Jan 17, 2009 at 12:13:26PM -0500, Alberto Accomazzi wrote:
> I need some help with figuring out how to repair a large XFS
> filesystem (10TB of data, 100+ million files).  xfs_repair seems to
> have crapped out before finishing the job and now I'm not sure how to
> proceed.
> 
> The system is a CentOS 5.2 storage server with a 3ware controller and
> 16 x 1TB drives, 32GB RAM and 64GB swap.  After clearing the issues
> with bad blocks on the disks, yesterday we set out to fix the
> filesystem.  This is the list of relevant packages that yum reports
> installed:
> 
> kmod-xfs.x86_64                          0.4-1.2.6.18_53.1.14.e installed
> kmod-xfs.x86_64                          0.4-2                  installed
> kmod-xfs.x86_64                          0.4-1.2.6.18_92.1.10.e installed
> xfsdump.x86_64                           2.2.46-1.el5.centos    installed
> xfsprogs.x86_64                          2.9.4-1.el5.centos     installed
> xfsprogs-devel.x86_64                    2.9.4-1.el5.centos     installed
> kernel.x86_64                            2.6.18-92.1.13.el5.cen installed
> 
are you using the centosplus kernel? or just the regular kernel + kmod-xfs?

if xfsprogs ran out of memory, try the testing version available at
http://people.centos.org/tru/XFS/centos-5/RPMS/x86_64/

Tru

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
