Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 31CB07F37
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 22:47:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1DA4D304075
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 20:47:30 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id 7yoUhg3WWPzbSYjN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Jul 2013 20:47:20 -0700 (PDT)
Date: Thu, 11 Jul 2013 05:47:18 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: Corruption of root fs during git bisect of drm system hang
Message-ID: <20130711034718.GC362@x4>
References: <20130710090634.GA356@x4>
 <51DDFE44.9000606@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51DDFE44.9000606@hardwarefreak.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On 2013.07.10 at 19:37 -0500, Stan Hoeppner wrote:
> On 7/10/2013 4:06 AM, Markus Trippelsdorf wrote:
> > While bisecting a system hang, caused by the drm gpu subsystem, my root fs got
> > corrupted:
> ...
> > My root fs lives on a small SSD:
> > 
> > /dev/root on / type xfs (rw,relatime,attr2,inode64,logbsize=256k,noquota)
> > /dev/root      xfs        30G   15G   16G  50% /
> 
> Does your SSD honor barriers and cache flushes?

Yes, I hope so:

  Enabled Supported:
     ...
     *    Mandatory FLUSH_CACHE
     *    FLUSH_CACHE_EXT

But please note that the system hang mentioned above turned out to be a
locking problem. So the SSD had plenty of time to process any out-
standing commands before reboot.

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
