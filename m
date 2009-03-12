Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2CFH67s084954 for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 10:17:26 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2E0A91C396B4
	for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 08:16:42 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id 2SI8b29UMUDbPlCu for <xfs@oss.sgi.com>;
	Thu, 12 Mar 2009 08:16:42 -0700 (PDT)
Message-ID: <49B92423.4020708@sandeen.net>
Date: Thu, 12 Mar 2009 10:02:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: LWN article: ext4 and data loss
References: <200903121239.35442@zmi.at>
	<49B9097C.1070003@sandeen.net>	(sfid-20090312_151043_496061_D19DDB11)
	<200903121514.12732.Martin@lichtvoll.de>
In-Reply-To: <200903121514.12732.Martin@lichtvoll.de>
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
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: xfs@oss.sgi.com

Martin Steigerwald wrote:
> Am Donnerstag 12 M=E4rz 2009 schrieb Eric Sandeen:
>> Michael Monnerie wrote:
>>> http://lwn.net/SubscriberLink/322823/e6979f02e5a73feb/
>>>
>>> Very good, maybe similar patches for XFS would help?
>>> IANA Coder, but could be a hint.
>>>
>>> mfg zmi
>> ext4 is taking its hints from XFS in this regard, not the other way
>> around.  XFS dealt with this long ago.
> =

> Hmmm, I remember having had similar issues with XFS not to long ago, wher=
e =


depends on what you mean by not too long ago, I think.  Yes, kde had
this issue on xfs too, and xfs gave up on teaching apps to fsync, and
implemented the same sorts of things ext4 has done (or will do) to
mitigate this quite some time ago.

> at least some KDE configuration were lost or truncated. It seems =

> applications will have to get rid of behavioral assumptions regation =

> filesystem and use safe writing via fsync and whatever else for =

> configuration and other important files.

It's simple.  Want your data safe on disk?  fsync.  There's not a lot
more to it than that.  (and if fsync hurts perf too much, re-think how
you are storing your data)

Filesystems can hack around some heuristics to try to make unsafe apps
safer, but in the end, it's the app's job to make sure a buffered write
hits permanent storage when it matters.

-Eric

> I am thinking about a bug report for KDE at least.
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
