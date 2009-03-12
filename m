Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2CF0kNI084224 for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 10:01:07 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A153D1C38CBF
	for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 08:00:23 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id sa6W3c2CElYr12FK for <xfs@oss.sgi.com>;
	Thu, 12 Mar 2009 08:00:23 -0700 (PDT)
Message-ID: <49B92311.7030708@sandeen.net>
Date: Thu, 12 Mar 2009 09:58:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: LWN article: 4K disk sectors
References: <200903121258.51497@zmi.at> <49B909CC.7080402@sandeen.net>
	<200903121452.16419@zmi.at>
In-Reply-To: <200903121452.16419@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

Michael Monnerie wrote:
> On Donnerstag 12 M=E4rz 2009 Eric Sandeen wrote:
>> Take a look at the mkfs.xfs man page:
>>
>>        -s sector_size
>>               This option specifies the fundamental  sector  size  of
>>               the filesystem.  The sector_size is specified either as
>>               a value in bytes with size=3Dvalue or as a base two loga-
>>               rithm value with log=3Dvalue.  The default sector_size is
>>               512 bytes. The minimum value for sector  size  is  512;
>>               the  maximum is 32768 (32 KiB). The sector_size must be
>>               a power of 2 size and cannot be made  larger  than  the
>>               filesystem block size.
> =

> Ugh, I felt so good this morning, until you responded ... ;-)
> =

> I thought that it's a limitation of the Linux kernel in more parts than =

> just the filesystem (like block cache), that sector sizes must be 512B. =

> If I had a 4K drive, would that be usable with XFS already?

Other layers need work, yes, but by and large xfs should be ready when
the rest of the kernel & linux infastructure catches up.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
