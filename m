Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB4ASeKR146814 for <xfs@oss.sgi.com>; Sat, 4 Dec 2010 04:28:40 -0600
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D355C1C95399
	for <xfs@oss.sgi.com>; Sat,  4 Dec 2010 02:30:23 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id LDMgRWJzaTBo1yFs for
	<xfs@oss.sgi.com>; Sat, 04 Dec 2010 02:30:23 -0800 (PST)
Received: from shambhala.localnet (ppp-93-104-153-33.dynamic.mnet-online.de
	[93.104.153.33])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 08D22BA
	for <xfs@oss.sgi.com>; Sat,  4 Dec 2010 11:30:22 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: xfs_repair of critical volume
Date: Sat, 4 Dec 2010 11:30:19 +0100
References: <75C248E3-2C99-426E-AE7D-9EC543726796@ucsc.edu>
	<201011121422.28993@zmi.at> <4CDDBC5C.7020708@hardwarefreak.com>
	(sfid-20101113_121516_584378_2321CE16)
In-Reply-To: <4CDDBC5C.7020708@hardwarefreak.com>
MIME-Version: 1.0
Message-Id: <201012041130.20344.Martin@lichtvoll.de>
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
To: xfs@oss.sgi.com

Am Freitag 12 November 2010 schrieb Stan Hoeppner:
> Michael Monnerie put forth on 11/12/2010 7:22 AM:
> > I find the robustness of XFS amazing: You overwrote 1/5th of the disk
> > with zeroes, and it still works :-)
> 
> This isn't "robustness" Michael.  If anything it's a serious problem.
> XFS is reporting that hundreds or thousands of files that have been
> physically removed still exist.  Regardless of how he arrived at this
> position, how is this "robust"?  Most people would consider this
> inconsistency of state a "corruption" situation, not "robustness".

I think its necessary to differentiate here:

1) It appears to be robustness - or pure luck - regarding metadata 
consistency of the filesystem. I tend to believe its pure luck and that XFS 
just stored the metadata on the other RAID arrays.

2) XFS does not seem to have a way to detect whether file contents are 
still valid and consistent. It shares that with I think every other Linux 
filesystem instead BTRFS which uses checksumming for files. (Maybe NILFS as 
well, I don't know, and the FUSE or the other ZFS port).

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
