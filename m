Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4IHkVEK234037 for <xfs@oss.sgi.com>; Fri, 18 May 2012 12:46:32 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 7GMgr0rBSWAT8Jkv for <xfs@oss.sgi.com>;
	Fri, 18 May 2012 10:46:30 -0700 (PDT)
Message-ID: <4FB68AF6.1090303@sandeen.net>
Date: Fri, 18 May 2012 12:46:30 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: How to recover data from an xfs partition
References: <4FAE9DBF.1090505@linuxsystems.it> <20120518143143.GN16099@sgi.com>
	<4FB66430.9040202@linuxsystems.it>
In-Reply-To: <4FB66430.9040202@linuxsystems.it>
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
To: =?ISO-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
Cc: xfs@oss.sgi.com

On 5/18/12 10:01 AM, Niccol=F2 Belli wrote:
> Hi,
> =

> Il 18/05/2012 16:31, Ben Myers ha scritto:
>> I recommend you give it a shot with the latest xfsprogs.  However, it ma=
y be
>> that your filesystem has been corrupted beyond repair.
> =

> I succeeded recovering something with xfsprogs 3.1.8, but no more than 1G=
B of data (~5%).
> =

> Fortunately I managed to save some precious config files, considering I h=
ad a 6 months old backup the disaster is a bit less catastrophic.
> =

> I had a bad time replacing corrupted data from the other ten ext4 virtual=
 machines, but they didn't give me too much troubles compared to xfs. How i=
ronic that the data loss happened during the installation of the backup sys=
tem...
> =

> To be honest I don't know if I will use xfs anymore, unfortunately I need=
 per-directory quota and it is the only viable solution.

You're welcome to follow your heart on choice of filesystem of course, but =
without knowing what happened to your storage, it's a little bit of a stret=
ch to blame xfs.

Just based on:

> xfs_check: /dev/loop51 is not a valid XFS filesystem (unexpected SB magic=
 number 0xeb639010) =


it appears that something scribbled all over your storage (i.e. the file ba=
cking it - what was that stored on?)  What it was that did the scribbling, =
and how much it scribbled is unknown, and it may or may not have been more =
significant than whatever hit your ext4 partitions.

I do not think you encountered an xfs bug; something else severely damaged =
your block device.

-Eric


> Niccol=F2
> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
