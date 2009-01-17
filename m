Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0HIjHox031045 for <xfs@oss.sgi.com>; Sat, 17 Jan 2009 12:45:17 -0600
Received: from rv-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DD81498A53
	for <xfs@oss.sgi.com>; Sat, 17 Jan 2009 10:45:15 -0800 (PST)
Received: from rv-out-0708.google.com (rv-out-0708.google.com
	[209.85.198.240]) by cuda.sgi.com with ESMTP id
	A5PL7xCH95Gyzcqo for <xfs@oss.sgi.com>;
	Sat, 17 Jan 2009 10:45:15 -0800 (PST)
Received: by rv-out-0708.google.com with SMTP id f25so2048956rvb.32
	for <xfs@oss.sgi.com>; Sat, 17 Jan 2009 10:45:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090117173537.GH15444@sillage.bis.pasteur.fr>
References: <adcf4ef70901170913l693376d7s6fd0395e2c88e10@mail.gmail.com>
	<20090117173537.GH15444@sillage.bis.pasteur.fr>
Date: Sat, 17 Jan 2009 13:45:15 -0500
Message-ID: <adcf4ef70901171045qcef5230t87077f2e22861c8b@mail.gmail.com>
Subject: Re: help with xfs_repair on 10TB fs
From: Alberto Accomazzi <aaccomazzi@gmail.com>
Content-Disposition: inline
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
To: Tru Huynh <tru@pasteur.fr>
Cc: xfs@oss.sgi.com

On Sat, Jan 17, 2009 at 12:35 PM, Tru Huynh <tru@pasteur.fr> wrote:

> On Sat, Jan 17, 2009 at 12:13:26PM -0500, Alberto Accomazzi wrote:
> > I need some help with figuring out how to repair a large XFS
> > filesystem (10TB of data, 100+ million files).  xfs_repair seems to
> > have crapped out before finishing the job and now I'm not sure how to
> > proceed.
> >
> > The system is a CentOS 5.2 storage server with a 3ware controller and
> > 16 x 1TB drives, 32GB RAM and 64GB swap.  After clearing the issues
> > with bad blocks on the disks, yesterday we set out to fix the
> > filesystem.  This is the list of relevant packages that yum reports
> > installed:
> >
> > kmod-xfs.x86_64                          0.4-1.2.6.18_53.1.14.e installed
> > kmod-xfs.x86_64                          0.4-2                  installed
> > kmod-xfs.x86_64                          0.4-1.2.6.18_92.1.10.e installed
> > xfsdump.x86_64                           2.2.46-1.el5.centos    installed
> > xfsprogs.x86_64                          2.9.4-1.el5.centos     installed
> > xfsprogs-devel.x86_64                    2.9.4-1.el5.centos     installed
> > kernel.x86_64                            2.6.18-92.1.13.el5.cen installed
> >
> are you using the centosplus kernel? or just the regular kernel + kmod-xfs?
>
> if xfsprogs ran out of memory, try the testing version available at
> http://people.centos.org/tru/XFS/centos-5/RPMS/x86_64/
>

Right now we're running centosplus:

Linux adsduo 2.6.18-92.1.13.el5.centos.plus #1 SMP Wed Oct 1 13:41:35 EDT
2008 x86_64 x86_64 x86_64 GNU/Linux

What is the current thinking about this vs. regular kernel + kmod-xfs?

-- AA


[[HTML alternate version deleted]]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
