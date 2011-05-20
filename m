Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4KKbaUW110418 for <xfs@oss.sgi.com>; Fri, 20 May 2011 15:37:36 -0500
Received: from mprobst.securesites.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1E1C715B93BF
	for <xfs@oss.sgi.com>; Fri, 20 May 2011 13:37:35 -0700 (PDT)
Received: from mprobst.securesites.net (mprobst2.securesites.net
	[198.173.85.114]) by cuda.sgi.com with ESMTP id
	uvss5ZJUdRdqBONt for <xfs@oss.sgi.com>;
	Fri, 20 May 2011 13:37:35 -0700 (PDT)
Message-ID: <4DD6D108.3010203@zmcconsulting.com>
Date: Fri, 20 May 2011 14:37:28 -0600
From: "Matthew J. Probst" <mprobst@zmcconsulting.com>
MIME-Version: 1.0
Subject: Re: XFS_WANT_CORRUPTED_GOTO on repair of large myisam (mysql) table
References: <4DD097F9.6070205@zmcconsulting.com> <4DD09A09.30807@sandeen.net>
In-Reply-To: <4DD09A09.30807@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 5/15/2011 9:29 PM, Eric Sandeen wrote:
>
> Please try removing kmod-xfs; that is an extremely old xfs codebase.
>
> the kernel above comes with xfs.ko already an is much more up to date.
> When kmod-xfs is installed, it overrides  the one shipped with the kernel.
>
> Hopefully you'll have better luck with the newer code.

Yes...  That worked.. after removing kmod-xfs I was successfully able to
complete the myisamchk of the 20GB table w/o crash.

Thanks!!

-matt

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
