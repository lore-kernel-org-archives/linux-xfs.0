Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D63D77F63
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2013 06:12:25 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A7A3E304032
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2013 04:12:22 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DYx4xv4WrEAMxQwa for
	<xfs@oss.sgi.com>; Mon, 11 Feb 2013 04:12:22 -0800 (PST)
Date: Mon, 11 Feb 2013 13:08:12 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Xfs fails in xfstests 013
In-Reply-To: <20130210221600.GC8257@dastard>
Message-ID: <alpine.LFD.2.00.1302111307001.2315@(none)>
References: <alpine.LFD.2.00.1301310910080.14328@dhcp-1-104.brq.redhat.com>
	<20130201002927.GJ32297@disturbed.disaster>
	<alpine.LFD.2.00.1302011149030.6969@dhcp-1-104.brq.redhat.com>
	<alpine.LFD.2.00.1302011219300.6969@dhcp-1-104.brq.redhat.com>
	<20130203230013.GI2667@dastard> <20130210221600.GC8257@dastard>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-1463785984-570699168-1360584732=:2315"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>, xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463785984-570699168-1360584732=:2315
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 11 Feb 2013, Dave Chinner wrote:

> Date: Mon, 11 Feb 2013 09:16:00 +1100
> From: Dave Chinner <david@fromorbit.com>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: xfs@oss.sgi.com
> Subject: Re: Xfs fails in xfstests 013
> 
> On Mon, Feb 04, 2013 at 10:00:13AM +1100, Dave Chinner wrote:
> > On Fri, Feb 01, 2013 at 03:33:06PM +0100, Lukáš Czerner wrote:
> > > On Fri, 1 Feb 2013, Lukáš Czerner wrote:
> > > and I have not hit the assert. However I think that I know what's
> > > going on. The verifier is obviously not attached when the symlink is
> > > created, however it is attached when security attributes are created
> > > for the symlink by xfs_init_security().
> > 
> > Which means the bug is in xfs_bmap_add_attrfork_local() in calling
> > xfs_bmap_local_to_extents(). i.e it assumes that the local data is
> > either directory data or extent data, and is attaching extent tree
> > verifiers to the buffer that contains a remote symlink. Thinking
> > time now needed, as this affects the symlink CRC changes as well.
> > 
> > Thanks for the debug help, Lukas.
> 
> Lukas, can you check whether the patch below fixes the problem you
> saw?

Hi Dave,

from my testing it seems that ti fixes the problem. Can not
reproduce it anymore with the patch applied.

Thanks!
-Lukas

> 
> Cheers,
> 
> Dave.
> 
---1463785984-570699168-1360584732=:2315
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

---1463785984-570699168-1360584732=:2315--
