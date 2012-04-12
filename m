Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3C7vmW9128876 for <xfs@oss.sgi.com>; Thu, 12 Apr 2012 02:57:49 -0500
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id UQdjk23lSifUr4xK for
	<xfs@oss.sgi.com>; Thu, 12 Apr 2012 00:57:47 -0700 (PDT)
Date: Thu, 12 Apr 2012 08:57:47 +0100
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Fragmentation Issue We Are Having
Message-ID: <20120412075747.GB30891@nsrc.org>
References: <CADrkzimg891ZBGK7-UzhGeey16KwH-ZXpEqFr=O3KwD3qA9LwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADrkzimg891ZBGK7-UzhGeey16KwH-ZXpEqFr=O3KwD3qA9LwQ@mail.gmail.com>
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
To: David Fuller <dfuller@epoch.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 11, 2012 at 06:04:25PM -0700, David Fuller wrote:
>    Adn here are the mount options on one of our servers:
> 
>     xfs     rw,noikeep,allocsize=256M,logbufs=8,sunit=128,swidth=2304

What's the total file system size? If it's over 1TB then you almost
certainly should have 'inode64' as well.
http://xfs.org/index.php/XFS_FAQ#Q:_What_is_the_inode64_mount_option_for.3F

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
