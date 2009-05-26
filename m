Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4Q997Ti133603 for <xfs@oss.sgi.com>; Tue, 26 May 2009 04:09:07 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E5A0B12FFAF0
	for <xfs@oss.sgi.com>; Tue, 26 May 2009 02:15:09 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id zsEYJ1GPoPGOWjEH for
	<xfs@oss.sgi.com>; Tue, 26 May 2009 02:15:09 -0700 (PDT)
Date: Tue, 26 May 2009 05:09:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
Message-ID: <20090526090916.GA17194@infradead.org>
References: <20090520003745.GA27491@samad.com.au>
	<20090520090558.GQ16929@discord.disaster>
	<20090520095639.GA27496@samad.com.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090520095639.GA27496@samad.com.au>
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
To: Alex Samad <alex@samad.com.au>
Cc: randrik@mail.ru, xfs@oss.sgi.com

So you're having primary a NFS workload, right?  Andrew had some
dmesg output in bugzilla (please send this stuff to the list instead
of hiding it in bugzilla if possible, BTW) that looks quite interesting:

May 24 08:48:00 (none) last message repeated 61 times                           
May 24 08:48:47 (none) last message repeated 760 times                          
May 24 08:50:55 (none) kernel: reconnect_path: npd != pd                        
May 24 08:50:55 (none) last message repeated 9 times                            
May 24 08:55:04 (none) kernel: reconnect_path: npd != pd                        
May 24 08:56:05 (none) last message repeated 47 times                           
May 24 08:56:49 (none) last message repeated 419 times

which means we are in deep trouble with the dcache coherency.  Also
the only way the bug you two report could happen from my audit is
we get ->destroy_inode called twice for the same inode.

So defintively some deep problems here.  Alex and Andrew, can you send
me your .config, and a description of the workload your seing this on?
Also the /etc/exports file would be interesting.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
