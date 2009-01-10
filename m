Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0AHuSfD012042 for <xfs@oss.sgi.com>; Sat, 10 Jan 2009 11:56:30 -0600
Received: from mail.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 6E1FA78FFD
	for <xfs@oss.sgi.com>; Sat, 10 Jan 2009 09:56:26 -0800 (PST)
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20]) by cuda.sgi.com
	with SMTP id HWAoGGBpTDKyd3rk for <xfs@oss.sgi.com>;
	Sat, 10 Jan 2009 09:56:26 -0800 (PST)
Message-ID: <4968E145.3050807@gmx.net>
Date: Sat, 10 Jan 2009 18:56:21 +0100
From: Carsten Menke <bootsy52@gmx.net>
MIME-Version: 1.0
Subject: Re: XFS: xfs_trans_cancel Filesystem shutdown
References: <4963B97D.1020201@gmx.net> <49678756.10303@thebarn.com>
In-Reply-To: <49678756.10303@thebarn.com>
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
To: Russell Cattelan <cattelan@thebarn.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

Russell Cattelan wrote:
> 
> cc the xfs list.
> 
> Since you have wiped the file system it is going to be hard to get to 
> the bottom of th issue.
> It looks like you hit two different issues here, one is a shutdown and 
> one look like a deadlock?
> 
> 
> In the future it would be helpful to xfs_metadump the file system and 
> then file a bug and attach the metadump image.
> 
Yes, I know, I have seen this after I created the new filesystem while further
searching the net for possible causes of this, that a xfs_metadump is most of 
the time needed to debug this. But as this is a production system the system had 
to go online again as soon as possible, so I just decided
to share the information I've got afterwards. The next time I will do the
xfs_metadump (but then, I hope also that I won't be hit by the problem once again).

Regards

Carsten


-- 
"There are two major products that came out of Berkeley: LSD and UNIX.
   We don't believe this to be a coincidence." --Jeremy S. Anderson

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
