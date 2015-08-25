Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 030FE7F47
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 18:34:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 843CAAC009
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 16:34:03 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	I0iaIBnlz3JzqiG9 for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 16:34:01 -0700 (PDT)
Date: Wed, 26 Aug 2015 09:33:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Cant mount xfs lvm. Experimental Features?
Message-ID: <20150825233348.GM714@dastard>
References: <8a6d5afa8829aec73d911f35815d7b92@zbfmail.de>
	<20150825115412.GI714@dastard>
	<5ab00519660fd5ed1b3d347658dba1f2@zbfmail.de>
	<55DCB158.20505@sandeen.net>
	<fe88fd1604660f15cea80477b3855e77@zbfmail.de>
	<20150825230353.GK714@dastard>
	<e4d6436ce2242107ab96dd3be2669046@zbfmail.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <e4d6436ce2242107ab96dd3be2669046@zbfmail.de>
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
To: weber@zbfmail.de
Cc: Xfs <xfs@oss.sgi.com>

On Wed, Aug 26, 2015 at 01:10:41AM +0200, Marko Weber|8000 wrote:
> dave, so the latest lts kernel 3.14.51 does not support to mount
> lvm2 partitions formatted with mkfs.xfs 3.2.4?

As we've always done in the past, we've waited for around a year
after upstream kernel support for a feature has been supported
before turning on the feature by default in xfsprogs. Kernel 3.16
was released just over a year ago with full CRC support. Our hand
was kinda forced by distros independently enabling these features by
default before upstream enabled them, so we enabled it a bt sooner
than previous feature default changes.

Clearly we (upstream) have no control over what distros ship and
enable. We can't stop distros from upgrading userspace out of step
with the kernel they ship, nor can we stop them from changing
default feature enablement. However, it's up to the distro to make
sure that the userspace package and the default configurations they
ship work correctly with the kernel they ship.

i.e. if Gentoo are shipping xfsprogs 3.2.4 w/ kernel 3.14.51, then
Gentoo has a quality control problem - they have failed to verify
that the packages they are shipping work correctly before shipping
them to users...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
