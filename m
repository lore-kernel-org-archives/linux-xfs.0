Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D909C7F3F
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 09:23:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4E7E6AC002
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 07:23:48 -0700 (PDT)
Received: from bash.esri.com (Redlands.esri.com [198.102.62.250]) by
	cuda.sgi.com with ESMTP id r4yF6oC0Z0WthAwP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Mar 2014 07:23:45 -0700 (PDT)
Date: Thu, 13 Mar 2014 07:23:43 -0700
From: Ray Van Dolson <rvandolson@esri.com>
Subject: Re: sw and su for hardware RAID10 (w/ LVM)
Message-ID: <20140313142342.GA7582@esri.com>
References: <20140311045639.GA18159@esri.com>
	<532046E9.9090302@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <532046E9.9090302@hardwarefreak.com>
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

On Wed, Mar 12, 2014 at 06:37:13AM -0500, Stan Hoeppner wrote:
> On 3/10/2014 11:56 PM, Ray Van Dolson wrote:
> > RHEL6.x + XFS that comes w/ Red Hat's scalable file system add on.  We
> > have two PowerVault MD3260e's each configured with a 30 disk RAID10 (15
> > RAID groups) exposed to our server.  Segment size is 128K (in Dell's
> > world I'm not sure if this means my stripe width is 128K*15?)
> 
> 128KB must be the stripe unit.
> 
> > Have set up a concatenated LVM volume on top of these two "virtual
> > disks" (with lvcreate -i 2).
> 
> This is because you created a 2 stripe array, not a concatenation.
> 
> > By default LVM says it's used a stripe width of 64K.
> >
> > # lvs -o path,size,stripes,stripe_size
> >   Path                           LSize   #Str Stripe
> >   /dev/agsfac_vg00/lv00          100.00t    2 64.00k
> 
> from lvcreate(8)
> 
> -i, --stripes Stripes
>     Gives the number of stripes...
> 
> > Unsure if these defaults should be adjusted.
> > 
> > I'm trying to figure out the appropriate sw/su values to use per:
> > 
> >   http://xfs.org/index.php/XFS_FAQ#Q:_How_to_calculate_the_correct_sunit.2Cswidth_values_for_optimal_performance
> > 
> > Am considering either just going with defaults (XFS should pull from
> > LVM I think) or doing something like sw=2,su=128K.  However, maybe I
> > should be doing sw=2,su=1920K?  And perhaps my LVM stripe width should
> > be adjusted?
> 
> Why don't you first tell us what you want?  You say at the top that you
> created a concatenation, but at the bottom you say LVM stripe.  So first
> tell us which one you actually want, because the XFS alignment is
> radically different for each.
> 
> Then tell us why you must use LVM instead of md.  md has fewer
> problems/limitations for stripes and concat than LVM, and is much easier
> to configure.

Yes, misused the term concatenation.  Striping is what I'm afer (want
to use all of my LUNs equally).

I don't know that I necessarily need to use LVM here.  No need for
snapshots, just after the best "performance" for multiple NAS sourced
(via Samba) sequential write or read streams (but not read/write at the
same time).

My setup is as follows right now:

MD3260_1 -> Disk Group 0 (RAID10 - 15 RG's, 128K segment size) -> 2
  Virtual Disks (one per controller)
MD3260_2 -> Disk Group 0 (RAID10 - 15 RG's, 128K segment size) -> 2
  Virtual Disks (one per controller)

So I see four equally sized LUNs on my RHEL box, each with one active
path and one passive path (using Linux MPIO).

I'll set up a striped md array across these four LUNs using a 128K
chunk size.

Things work pretty well with the xfs default, so may stick with that,
but to try and get it as "right" as possible, I'm thinking I should be
using a su=128k value, but am not sure on the sw value.  It's either:

- 4 (four LUNs as far as my OS is concerned)
- 30 (15 RAID groups per MD3260)

I'm thinking probably 4 is the right answer since the RAID groups on my
PowerVaults are all abstracted.

Ray

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
