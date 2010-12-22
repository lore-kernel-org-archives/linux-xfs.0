Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBMH4Nek261837 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 11:04:23 -0600
Received: from parsec.stupidest.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 576271475EEE
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 09:06:21 -0800 (PST)
Received: from parsec.stupidest.org (parsec.stupidest.org [71.6.196.126]) by
	cuda.sgi.com with ESMTP id b50xJZjq1JKJb2em for
	<xfs@oss.sgi.com>; Wed, 22 Dec 2010 09:06:21 -0800 (PST)
Date: Wed, 22 Dec 2010 09:06:20 -0800
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: Anyone using XFS in production on > 20TiB volumes?
Message-ID: <20101222170620.GA29117@puku.stupidest.org>
References: <alpine.DEB.2.00.1012221128440.5245@p34.internal.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1012221128440.5245@p34.internal.lan>
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

On Wed, Dec 22, 2010 at 11:30:05AM -0500, Justin Piszcz wrote:

> Is there anyone currently using this in production?

yes (in the past more than now)

> How much ram is needed when you fsck with a many files on such a
> volume?

didn't check specifically, but with older xfsprogs it could easily use
more than 16GB

> Is inode64 recommended on a 64-bit system?

it's for inode distribution, not 64-bit vs 32-bit system

yes, enable that ... it should be the default

> Any specific 64-bit tweaks/etc for a large 43TiB FS?

if using hw raid teach mkfs about the array geom, that coupled with
inode64 made a huge difference in performance that last time i did
this

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
