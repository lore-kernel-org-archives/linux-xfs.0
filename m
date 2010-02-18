Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1I8hW8U038179 for <xfs@oss.sgi.com>; Thu, 18 Feb 2010 02:43:33 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E00E613B67E5
	for <xfs@oss.sgi.com>; Thu, 18 Feb 2010 00:44:49 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	RyqVUUytWa8Cyurq for <xfs@oss.sgi.com>;
	Thu, 18 Feb 2010 00:44:49 -0800 (PST)
Date: Thu, 18 Feb 2010 19:44:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS problems with 2.6.27
Message-ID: <20100218084446.GZ28392@discord.disaster>
References: <4B717CCD.3040008@poczta.onet.pl> <4B7CF542.6090501@poczta.onet.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B7CF542.6090501@poczta.onet.pl>
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
To: "aluno3@poczta.onet.pl" <aluno3@poczta.onet.pl>
Cc: xfs@oss.sgi.com

On Thu, Feb 18, 2010 at 09:07:30AM +0100, aluno3@poczta.onet.pl wrote:
> Can somebody help with this problem? If you need more details, please
> let me know.

You've got lots of problems.

> > Hello!
> >
> > We"ve got two different systems running with XFS, one of them is
> > publishing shares via NFS, the other via Samba. We've recently
> > encountered filesystem issues on both servers, and received the
> > following call traces. They look very much alike.
> >
> > Are these something you are familiar with? We'd like to at least
> > establish that the problem really is with XFS... We don't really have
> > the possibility to update the kernels (2.6.27.10) on those machines, but
> > we can possibly apply patches etc. These systems are usually under a
> > fairly high load and host a large number of files.
> >
> >
> > Filesystem "dm-16": Disabling barriers, trial barrier write failed        
> > XFS mounting filesystem dm-16                                             
> > Starting XFS recovery on filesystem: dm-16 (logdev: internal)             
> > XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1590 of file
> > fs/xfs/xfs_alloc.c.  Caller 0xffffffff80398ca7
> > Pid: 15745, comm: mount Not tainted 2.6.27.10
> > #24                                                            

That's a corrupt free space tree => xfs_repair.

> > NFSD: starting 90-second grace period                                   
> > bootsplash: status on console 0 changed to off                          
> > usb 3-2: USB disconnect, address 2                                      
> > 00000000: 00 00 00 00 00 28 00 e0 00 00 00 00 00 00 00 00  .....(..........
> > Filesystem "dm-20": XFS internal error xfs_da_do_buf(2) at line 2112 of
> > file fs/xfs/xfs_da_btree.c.  Caller 0xffffffff803b34b4
> > Pid: 23023, comm: smbd Not tainted 2.6.27.10
> > #24                                                                             

That's a corrupt directory block. The output there bears no
resemblance to an XFS directory header - you might be hitting the
problem where DM fails to mark a cancelled readahead bio correctly
and XFS detects it in xfs_da_do_buf() as an uninitialised buffer
and shuts down the filesystem.

I'd say run repair and if it doesn't find any directory corruption,
you need to get the DM and XFS fixes for the cancelled readhead bios
backported.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
