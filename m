Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 53F197FF3
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 02:36:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 397B78F8050
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 00:36:58 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id sL3DGVkyIOKRwPrS for
	<xfs@oss.sgi.com>; Thu, 14 Feb 2013 00:36:57 -0800 (PST)
Date: Thu, 14 Feb 2013 09:36:38 +0100 (CET)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] xfs_mkfs: wipe old signatures from the device
In-Reply-To: <982B8DBB-3FBA-4213-BC92-848A64C60110@colorremedies.com>
Message-ID: <alpine.LFD.2.00.1302140929570.2315@(none)>
References: <1360667215-14701-1-git-send-email-lczerner@redhat.com>
	<20130212202753.GC26694@dastard>
	<20130213080154.GC18597@x2.net.home>
	<alpine.LFD.2.00.1302131127070.2315@(none)>
	<20130213121655.GA7799@x2.net.home>
	<20130213221720.GH26694@dastard>
	<982B8DBB-3FBA-4213-BC92-848A64C60110@colorremedies.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-163697065-1360831004=:2315"
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
To: Chris Murphy <lists@colorremedies.com>
Cc: sandeen@redhat.com, xfs@oss.sgi.com, Karel Zak <kzak@redhat.com>, Zach Brown <zabrown@redhat.com>, =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>, linux-btrfs@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-163697065-1360831004=:2315
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Thu, 14 Feb 2013, Chris Murphy wrote:

> Date: Thu, 14 Feb 2013 00:29:59 -0700
> From: Chris Murphy <lists@colorremedies.com>
> To: Dave Chinner <david@fromorbit.com>
> Cc: Karel Zak <kzak@redhat.com>, Luká¨ Czerner <lczerner@redhat.com>,
>     xfs@oss.sgi.com, sandeen@redhat.com, Zach Brown <zabrown@redhat.com>,
>     linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH] xfs_mkfs: wipe old signatures from the device
> 
> 
> On Feb 13, 2013, at 3:17 PM, Dave Chinner <david@fromorbit.com> wrote:
> > it is the responsibility of filesystem
> > tools to behave sanely, not for the rest of the world to have to
> > work around the dangerous behaviour of a specific filesystems'
> > toolset.
> 
> I appreciate this, and in particular that mkfs.xfs doesn't nerf a file system without the use of -f; even an existing XFS file system. Considering most data loss is user induced, I'd appreciate it if other file systems's tools weren't so easily made belligerent by (hopefully temporarily) confused apes wearing pants.
> 
> Chris Murphy

I would not be so optimistic about it. The reason being that there
are almost _always_ old file system signatures on the device. So I
think that it got to the point where users will usually use mkfs.xfs
-f all the time. And even if they did not and they would use a wrong
device they would probably get the same warning even for the device
they wanted to use in the first place.

So even thoug it might help in some cases I do not think that we
should go and change all file systems to do that as well, it would
not be very useful anyway.

-Lukas
--8323328-163697065-1360831004=:2315
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--8323328-163697065-1360831004=:2315--
