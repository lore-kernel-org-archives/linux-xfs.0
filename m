Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9B8WGlr071472 for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 03:32:16 -0500
Received: from mail-out4.booking.com (mail-out4.booking.com [91.195.237.21])
	by cuda.sgi.com with ESMTP id mbTTrv4uce9rO3Fp (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 01:33:47 -0700 (PDT)
Date: Thu, 11 Oct 2012 10:33:52 +0200
From: Marcin Deranek <marcin.deranek@booking.com>
Subject: Re: Performance degradation over time
Message-ID: <20121011103352.4ed8bbf5@booking.com>
In-Reply-To: <507586B4.6010201@sandeen.net>
References: <20121010105142.148519ca@booking.com>
	<50757583.9000901@hardwarefreak.com> <507586B4.6010201@sandeen.net>
Mime-Version: 1.0
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
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com

Hi Eric,

On Wed, 10 Oct 2012 09:31:16 -0500
Eric Sandeen <sandeen@sandeen.net> wrote:

> Yep.  Ditch that; it overrides the maintained module that comes with
> the kernel itself.  See if that helps, first, I suppose.

I wasn't aware that stock kernel comes with xfs module. From my testing
looks like stock kernel module is still preferred over kmod-xfs:

# modinfo xfs
filename:       /lib/modules/2.6.18-308.el5/kernel/fs/xfs/xfs.ko
license:        GPL
description:    SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
author:         Silicon Graphics, Inc.
srcversion:     D37A003AFEE1A42BDD4DD56
depends:        
vermagic:       2.6.18-308.el5 SMP mod_unload gcc-4.1
module_sig:
883f3504f44471c48d0a1fbae482c4c11225a009e3fa1179850eea96ab882c910d750e88743fec5309d1ca09de3d81add6999f9dedc65f84a0d1e21293

Most likely due to historical reasons we still install kmod-xfs on our 
systems.
To be sure I have removed kmod-xfs, unmounted filesystem and removed
kernel module and them mounted filesystem again. Still seeing the very same
behaviour.

> Agreed that it would be good to know whether inode64 is in use.

No, we don't use any special mount options here.

> Let's start there (and with a modern xfs.ko) before we speculate
> further.

I guess next step would be to use inode64..
Regards,

Marcin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
