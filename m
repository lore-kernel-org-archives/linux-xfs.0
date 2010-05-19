Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4JJmF4I150589 for <xfs@oss.sgi.com>; Wed, 19 May 2010 14:48:16 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0305E109A4E2
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 12:51:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id IJritcq3BZGFIkG3 for
	<xfs@oss.sgi.com>; Wed, 19 May 2010 12:51:42 -0700 (PDT)
Message-ID: <4BF44105.4040902@sandeen.net>
Date: Wed, 19 May 2010 14:50:29 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: noatime,nodiratime?
References: <4BF3F212.5030600@hardwarefreak.com>	<20100519182336.GA6264@infradead.org>
	<4BF43B3C.6030403@hardwarefreak.com>
In-Reply-To: <4BF43B3C.6030403@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On 05/19/2010 02:25 PM, Stan Hoeppner wrote:

> Any chance xfs_info could be updated to output the information we're
> discussing, including spitting out the XFS specific mount options that are
> currently active at the time of running xfs_info?  

xfs_info actually calls xfs_growfs -n, and it's only reporting on-disk
geometry.  I kind of doubt that'll change.  If you want to see mount
options, /proc/mounts is the place ... but then we don't show the
defaults ;)  I wonder if we should change that and be explicit about
every option in /proc/mounts *shrug*

> There seems to be much
> confusion in the community due to lack of accurate information being
> available.  Google for "XFS performance" and you'll see
> "noatime,nodiratime,logbufs=8" mentioned consistently from early 2000's to
> the present as a performance enhancer.

It's so hard to keep google up to date ;)

> If what you say is true, on my 2.6.32.9 system, I actually decreased logbufs
> from 8 to 4 half an hour ago, instead of increasing it from 2 to 4, as man
> lead me to believe I was doing.  Do any of the xfs tools output the XFS
> specific active mount options allowing an op to confirm changes?  As someone
> else stated it would be nice to be able to see these parameter values.  As
> is, AFAICT, there's no way to confirm these parameter values.

/proc/mounts shows all mount options which were set differently from
defaults.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
