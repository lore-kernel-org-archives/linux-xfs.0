Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:22966 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751557AbeBBDXd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Feb 2018 22:23:33 -0500
Date: Fri, 2 Feb 2018 14:20:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2 2/2] xfs: fix rt_dev usage for DAX
Message-ID: <20180202032023.l644wdfecdm3eqdp@destitution>
References: <151751717968.69886.6978962571680635420.stgit@djiang5-desk3.ch.intel.com>
 <151751718516.69886.135497175511444689.stgit@djiang5-desk3.ch.intel.com>
 <20180201234413.idd27uqzqbg54ddk@destitution>
 <76cbab51-9f18-8531-016e-4e1f3c43637b@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76cbab51-9f18-8531-016e-4e1f3c43637b@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Jiang <dave.jiang@intel.com>
Cc: darrick.wong@oracle.com, linux-xfs@vger.kernel.org, ross.zwisler@linux.intel.com, linux-ext4@vger.kernel.org, dan.j.williams@intel.com, linux-nvdimm@lists.01.org

On Thu, Feb 01, 2018 at 05:13:40PM -0700, Dave Jiang wrote:
> 
> 
> On 02/01/2018 04:44 PM, Dave Chinner wrote:
> > On Thu, Feb 01, 2018 at 01:33:05PM -0700, Dave Jiang wrote:
> >> When using realtime device (rtdev) with xfs where the data device is not
> >> DAX capable, two issues arise. One is when data device is not DAX but the
> >> realtime device is DAX capable, we currently disable DAX.
> >> After passing this check, we are also not marking the inode as DAX capable.
> >> This change will allow DAX enabled if the data device or the realtime
> >> device is DAX capable. S_DAX will be marked for the inode if the file is
> >> residing on a DAX capable device. This will prevent the case of rtdev is not
> >> DAX and data device is DAX to create realtime files.
> > 
> > I'm confused by this description. I'm not sure what is broken, nor
> > what you are trying to fix.
> > 
> > I think what you want to do is enable DAX on RT devices separately
> > to the data device and vice versa?
> > 
> > i.e. is this what you are trying to acheive?
> > 
> > datadev dax	rtdev dax		DAX enabled on
> > -----------     ---------		--------------
> > no		no			neither
> > yes		no			datadev
> > no		yes			rtdev
> > yes		yes			both
> 
> ^ Yes that's pretty much what I was trying to say. I probably should've
> just provided the table above.

Ok, good to know I understood what you want to achieve. Now we've
just got to work out how to do it. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
