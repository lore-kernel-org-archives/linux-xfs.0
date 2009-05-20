Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4KFJZdi109395 for <xfs@oss.sgi.com>; Wed, 20 May 2009 10:19:35 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B1D9219F1A31
	for <xfs@oss.sgi.com>; Wed, 20 May 2009 08:19:22 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id ejggCqpOfJ1Tkhwt for <xfs@oss.sgi.com>;
	Wed, 20 May 2009 08:19:22 -0700 (PDT)
Message-ID: <4A141F72.3020607@sandeen.net>
Date: Wed, 20 May 2009 10:19:14 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS internal error xfs_trans_cancel at line 1164 of
	file	fs/xfs/xfs_trans.c
References: <4A13AA1B.7080801@attglobal.net>
In-Reply-To: <4A13AA1B.7080801@attglobal.net>
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
To: stunnel@attglobal.net
Cc: xfs@oss.sgi.com

Eddie Atherton wrote:
> I'm trying to install a clean Slackware 12.2 (2.6.27.7) under ESXi, and 
> can almost guarantee getting this error immediately after formatting the 
> root partition.  It's happened 4 out of the 5 times I've tried, so far.
> 
> The sequence of commands, after digging through the install scripts, 
> that lead to this failure are just:
> 
> mkfs.xfs
> mount
> mkdir
> 
> Apologies for posting the stack trace as a couple of jpg's, but it's the 
> only way I could capture them, as I don't have any VMs set up, yet, that 
> have conectivity to upload any files.  The stack trace can be found at:
> 
> http://www.bogolinux.net/xfs_crash_a.JPG
> http://www.bogolinux.net/xfs_crash_b.JPG
> 
> I'm guessing that it's something to do with this running under a VM, but 
> is there any way to stop it happening.
> 
> Cheers,
> Eddie

Not sure what that is offhand, seems odd.  xfs_mkdir() is getting some
error and cancelling a dirty transaction.  Perhaps someone on the list
remembers better than me, a few causes of this were fixed but I don't
remember details.  Any chance you can try, say, .28 or .29? :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
