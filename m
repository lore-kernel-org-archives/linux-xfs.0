Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 31 Mar 2008 20:08:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3138mIW017805
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2008 20:08:49 -0700
From: =?iso-8859-2?Q?Husz=E1r_Viktor_D=E9nes?= <hvd@dwo.hu>
Subject: RE: free space problem
Date: Tue, 1 Apr 2008 05:08:52 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
In-Reply-To: <20080401003518.GK103491721@sgi.com>
Message-Id: <20080401030921.9CA0171CF52@cuda.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'David Chinner' <dgc@sgi.com>
Cc: 'Emmanuel Florac' <eflorac@intellique.com>, xfs@oss.sgi.com

>Yes, but if you have fragemented free space then it is possible that there
>are not enough free extents large enough (or aligned correctly) to
>allocate more inodes. The number of "free inodes" reported doesn't take
>this into account; it only looks at the number of free blocks and converts
>that to a theoretical number of inodes that could be allocated in that
>space (i.e. it assumes perfect fit and no waste). 

>In this "not quite full filesystem" situation, you can write data to the
>filesystem, but any attempt to create a new inode (new file, directory,
>etc) will fail with ENOSPC. This sounds like the symptoms you are
>reporting....

>Cheers,

>Dave.

What you described might happen with lot of small files, but in our case,
our attempts fail to create a new inode and fail to write data. You suppose
that we have fractured free spaces, and on these fractures no inodes can be
created. In our case, the situation was different, however as it started to
work again I still can't provide you any xfs_info/debug.

Thanks again,
Viktor
 

__________ Information from ESET NOD32 Antivirus, version of virus signature
database 2989 (20080401) __________

The message was checked by ESET NOD32 Antivirus.

http://www.eset.com
 
