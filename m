Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB8JmoVe052177 for <xfs@oss.sgi.com>; Sat, 8 Dec 2012 13:48:50 -0600
Received: from mail-ie0-f172.google.com (mail-ie0-f172.google.com
	[209.85.223.172]) by cuda.sgi.com with ESMTP id
	R00i5i7gMrxcNHr1 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 08 Dec 2012 11:51:17 -0800 (PST)
Received: by mail-ie0-f172.google.com with SMTP id c13so5242887ieb.31
	for <xfs@oss.sgi.com>; Sat, 08 Dec 2012 11:51:16 -0800 (PST)
Message-ID: <50C39A2F.8090006@gmail.com>
Date: Sat, 08 Dec 2012 14:51:11 -0500
From: Joe Landman <joe.landman@gmail.com>
MIME-Version: 1.0
Subject: Re: XFS write cache flush policy
References: <CAA_rkDfFUmZzT_kMznsTSNVxdfqfmz=bmJ400wdBOzocgP32eA@mail.gmail.com>
	<20121208192927.GA17875@citd.de> <5955806.tSHc7WOiJd@saturn>
In-Reply-To: <5955806.tSHc7WOiJd@saturn>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 12/08/2012 02:40 PM, Michael Monnerie wrote:
> Am Samstag, 8. Dezember 2012, 20:29:27 schrieb Matthias Schniedermeyer:
>> I have the same problem, several times.
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

I am not sure this is xfs specific ... I think I've had this problem on 
ext3 in the 3.x (x >= 5) region ... though I am trying to disambiguate 
this from an mdadm 3.2.6 bug.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
