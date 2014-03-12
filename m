Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2149B7F5A
	for <xfs@oss.sgi.com>; Wed, 12 Mar 2014 06:37:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A8AB8AC002
	for <xfs@oss.sgi.com>; Wed, 12 Mar 2014 04:37:17 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id yRORJJMaHgxhr7Ti
	for <xfs@oss.sgi.com>; Wed, 12 Mar 2014 04:37:16 -0700 (PDT)
Message-ID: <532046E9.9090302@hardwarefreak.com>
Date: Wed, 12 Mar 2014 06:37:13 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: sw and su for hardware RAID10 (w/ LVM)
References: <20140311045639.GA18159@esri.com>
In-Reply-To: <20140311045639.GA18159@esri.com>
Reply-To: stan@hardwarefreak.com
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
To: Ray Van Dolson <rvandolson@esri.com>, xfs@oss.sgi.com

On 3/10/2014 11:56 PM, Ray Van Dolson wrote:
> RHEL6.x + XFS that comes w/ Red Hat's scalable file system add on.  We
> have two PowerVault MD3260e's each configured with a 30 disk RAID10 (15
> RAID groups) exposed to our server.  Segment size is 128K (in Dell's
> world I'm not sure if this means my stripe width is 128K*15?)

128KB must be the stripe unit.

> Have set up a concatenated LVM volume on top of these two "virtual
> disks" (with lvcreate -i 2).

This is because you created a 2 stripe array, not a concatenation.

> By default LVM says it's used a stripe width of 64K.
>
> # lvs -o path,size,stripes,stripe_size
>   Path                           LSize   #Str Stripe
>   /dev/agsfac_vg00/lv00          100.00t    2 64.00k

from lvcreate(8)

-i, --stripes Stripes
    Gives the number of stripes...

> Unsure if these defaults should be adjusted.
> 
> I'm trying to figure out the appropriate sw/su values to use per:
> 
>   http://xfs.org/index.php/XFS_FAQ#Q:_How_to_calculate_the_correct_sunit.2Cswidth_values_for_optimal_performance
> 
> Am considering either just going with defaults (XFS should pull from
> LVM I think) or doing something like sw=2,su=128K.  However, maybe I
> should be doing sw=2,su=1920K?  And perhaps my LVM stripe width should
> be adjusted?

Why don't you first tell us what you want?  You say at the top that you
created a concatenation, but at the bottom you say LVM stripe.  So first
tell us which one you actually want, because the XFS alignment is
radically different for each.

Then tell us why you must use LVM instead of md.  md has fewer
problems/limitations for stripes and concat than LVM, and is much easier
to configure.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
