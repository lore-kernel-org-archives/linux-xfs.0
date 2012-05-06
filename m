Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q46LhRWF060586 for <xfs@oss.sgi.com>; Sun, 6 May 2012 16:43:27 -0500
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id MkmiDENVAmBjbg1B for
	<xfs@oss.sgi.com>; Sun, 06 May 2012 14:43:25 -0700 (PDT)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: suddenly slow writes on XFS Filesystem
Date: Sun, 6 May 2012 23:43:21 +0200
References: <4FA63DDA.9070707@profihost.ag>
	<201205061233.58496.Martin@lichtvoll.de>
	<4FA69CB0.8000008@hardwarefreak.com>
	(sfid-20120506_233742_387085_AFEABC59)
	(sfid-20120506_233742_387085_AFEABC59)
In-Reply-To: <4FA69CB0.8000008@hardwarefreak.com>
MIME-Version: 1.0
Message-Id: <201205062343.21871.Martin@lichtvoll.de>
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
To: stan@hardwarefreak.com
Cc: Stefan Priebe <s.priebe@profihost.ag>, xfs@oss.sgi.com

Am Sonntag, 6. Mai 2012 schrieb Stan Hoeppner:
> On 5/6/2012 5:33 AM, Martin Steigerwald wrote:
> > Am Sonntag, 6. Mai 2012 schrieb Stefan Priebe:
> >> It is a raid 10 of 20 SATA Disks and i can only write to them with
> >> about  700kb/s while doing random i/o. I tried vanilla Kernel 3.0.30
> >> and 3.3.4 - no difference. Writing to another partition on another
> >> xfs array works fine.
> > 
> > Additionally what RAID is this? SoftRAID or some - which one? -
> > hardware RAID controller? And what disks are used, whats the rpm of
> > these?
> 
> I doubt much of this stuff matters.  Stefan's filesystem is 96% full,
> w/~200GB free.  This free space is likely heavily fragmented.  If he's
> doing allocation in this fragmented free space I'd think that would
> fully explain his write performance dropping off a cliff due to massive
> head seeking.

Hmmm, I thought about that low free space percentage, too, but then 200 GB 
free still sounded like quite much to me. Nonetheless, since according to 
Stefan freeing some space solved the slowness issue, that seems to have 
been it.

Can free space be defragmented in XFS? xfs_fsr only tries to defragment 
files as far as I know.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
