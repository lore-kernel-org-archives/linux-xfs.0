Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB8Joh1p052325 for <xfs@oss.sgi.com>; Sat, 8 Dec 2012 13:50:43 -0600
Received: from awesome.dsw2k3.info (awesome.dsw2k3.info [195.71.86.230]) by
	cuda.sgi.com with ESMTP id wsgHet4S2iFGuV69 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 08 Dec 2012 11:53:09 -0800 (PST)
Date: Sat, 8 Dec 2012 20:53:04 +0100
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: XFS write cache flush policy
Message-ID: <20121208195304.GA20044@citd.de>
References: <CAA_rkDfFUmZzT_kMznsTSNVxdfqfmz=bmJ400wdBOzocgP32eA@mail.gmail.com>
	<20121208192927.GA17875@citd.de> <5955806.tSHc7WOiJd@saturn>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5955806.tSHc7WOiJd@saturn>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: Lin Li <sdeber@gmail.com>, xfs@oss.sgi.com

On 08.12.2012 20:40, Michael Monnerie wrote:
> Am Samstag, 8. Dezember 2012, 20:29:27 schrieb Matthias Schniedermeyer:
> > I have the same problem, several times.
> 
> I'd like to chime in here, with a similar issue: I have Linux on my 
> desktop, xfs is the home partition, 16G RAM. One day my system froze, no 
> chance to do a buffer flush via SYS-S/U/B, I had to press the reset 
> button (no power off, just reset). Upon restart, *lots* of files were 
> gone, destroyed, etc, and my KDE desktop wouldn't work anymore. Luckily 
> I have backups, and could restore - but this just shouldn't happen, and 
> it was *much* better with older kernels. What is the problem that 
> metadata isn't written to disk occasionally? I was on 3.6.6 when that 
> happened, now on 3.6.8, so very recent.

Now that you say it, this is what happend one of the other times, 
luckily i had done a backup just before i rebooted, so after 
xfs_repair'ing the partition (the only time i had to repair something 
for as long as i'm using XFS) i had to restore my home-directory from 
backup to get my desktop in a usable state again.




-- 

Matthias

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
