Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6F40LTv167141 for <xfs@oss.sgi.com>; Tue, 14 Jul 2009 23:00:21 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CCF0A137E991
	for <xfs@oss.sgi.com>; Tue, 14 Jul 2009 21:01:00 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id sbuLEPgEw8BAOk9R for
	<xfs@oss.sgi.com>; Tue, 14 Jul 2009 21:01:00 -0700 (PDT)
Message-ID: <4A5D547A.9040005@sandeen.net>
Date: Tue, 14 Jul 2009 23:00:58 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs+nfs crash in 2.6.30 and 2.6.30.1
References: <20090715030046.GA28592@rlogin.dk>
In-Reply-To: <20090715030046.GA28592@rlogin.dk>
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
To: Michael Ole Olsen <gnu@gmx.net>
Cc: xfs <xfs@oss.sgi.com>

Michael Ole Olsen wrote:
>             radix_tree_tag_set/xfs_inode_set_reclaim_tag crash
> 
> I keep getting kernel crashes with xfs+lvm2+mdadm (raid6) - correct in sync, 
> all xfs partitions checked for corruption (but there were none, but the crashes persists).
> 
> The raid6 has just resynced now because of this kernel hang.
> 
> 2.6.30 and 2.6.30.1 kernels on my nfsv3 server keep crashing, both with/without SMP, dynticks,
>  selinux (although selinux for some reason seems to make it crash very often)

Thanks, I've pasted this info into the bug report; It's unlikely that
it's a stack issue I think - the hint about selinux making it worse may
be useful.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
