Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0BIFFHa168222 for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 12:15:15 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ADAEAEF62BE
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 10:16:09 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ifXHHprRXHZQlhLN for
	<xfs@oss.sgi.com>; Mon, 11 Jan 2010 10:16:09 -0800 (PST)
Message-ID: <4B4B6AE8.8070904@sandeen.net>
Date: Mon, 11 Jan 2010 12:16:08 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: allocsize mount option
References: <614476.89961.qm@web76214.mail.sg1.yahoo.com>
In-Reply-To: <614476.89961.qm@web76214.mail.sg1.yahoo.com>
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
To: Gim Leong Chin <chingimleong@yahoo.com.sg>
Cc: xfs@oss.sgi.com

Gim Leong Chin wrote:
> Hi,
> 
> Mount options for xfs allocsize=size Sets  the buffered I/O
> end-of-file preallocation size when doing delayed allocation writeout
> (default size is 64KiB).
> 
> 
> I read that setting allocsize to a big value can be used to combat
> filesystem fragmentation when writing big files.

That's not universally necessary though, depending on how you are
writing them.  I've only used it in the very specific case of mythtv
calling "sync" every couple seconds, and defeating delalloc.

> I do not understand how allocsize works.  Say I set allocsize=1g, but
> my file size is only 1 MB or even smaller.  Will the rest of the 1 GB
> file extent be allocated, resulting in wasted space and even file
> fragmentation problem?

possibly :)  It's only speculatively allocated, though, so you won't
have 1g for every file; when it's closed the preallocation goes
away, IIRC.

> Does setting allocsize to a big value result in performance gain when
> writing big files?  Is performance hurt by a big value setting when
> writing files smaller than the allocsize value?
> 
> I am setting up a system for HPC, where two different applications
> have different file size characteristics, one writes files of GBs and
> even 128 GB, the other is in MBs to tens of MBs.

We should probably back up and say:  are you seeing fragmentation
problems -without- the mount option, and if so, what is your write pattern?

-Eric

> I am not able to find documentation on the behaviour of allocsize
> mount option.
> 
> Thank you.
> 
> 
> Chin Gim Leong
> 
> 
> New Email names for you! Get the Email name you&#39;ve always wanted
> on the new @ymail and @rocketmail. Hurry before someone else does! 
> http://mail.promotions.yahoo.com/newdomains/sg/
> 
> _______________________________________________ xfs mailing list 
> xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
