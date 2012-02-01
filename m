Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q11CWDe7248088 for <xfs@OSS.SGI.com>; Wed, 1 Feb 2012 06:32:14 -0600
Received: from woodbine.london.02.net (woodbine.london.02.net
	[87.194.255.145]) by cuda.sgi.com with ESMTP id
	4PZYa8jjIlH4rArC for <xfs@OSS.SGI.com>;
	Wed, 01 Feb 2012 04:32:12 -0800 (PST)
Received: from ty.sabi.co.UK (87.194.99.40) by woodbine.london.02.net (8.5.140)
	id 4EEB647400CE5CE1 for xfs@OSS.SGI.com; Wed, 1 Feb 2012 12:32:11 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1RsZLt-00087l-RX
	for <xfs@OSS.SGI.com>; Wed, 01 Feb 2012 12:31:53 +0000
MIME-Version: 1.0
Message-ID: <20265.12473.715630.925704@tree.ty.sabi.co.UK>
Date: Wed, 1 Feb 2012 12:31:53 +0000
Subject: Re: File system remain unresponsive until the system is rebooted.
In-Reply-To: <20120131120859.1f1d6a17@harpe.intellique.com>
References: <CANs4eSBWLc4HxAbPZ8kOVOdJ7RKiA+-ai3Q2J+FAyuzHtUqfdg@mail.gmail.com>
	<20120131013124.GE9090@dastard>
	<CANs4eSBgmvJCR7vfFa1W5h8tUYFQi=LRPWDPQ1exB29D1o_RjA@mail.gmail.com>
	<4F27AE92.9060003@hardwarefreak.com>
	<20120131120859.1f1d6a17@harpe.intellique.com>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux fs XFS <xfs@oss.sgi.com>

[ ... ]

> Is there a filesystem that's really suitable for EC2? What
> about workloads? my impression is that EC2 is fine for
> whatever doesn't need any QoS. Prototyping, for instance.

That's one use, but it is wider than that. Services like that
are good for "emarassingly parallel" workloads, where the QoS of
*a single* element does not matter, or even the *performance*
(or the *reliability*) of a single element is less important, at
least compared to the ability to throw a lot of cheap ones at a
problem.

Largely the same domain of application as the Google platform,
where their "embarassingly parallel" workload is log generation
and analysis.

Which advises that on EC2 simpler is better, and 'ext2' might be
most appropriate for non-shared applications. XFS, being like JFS
a rather general purpose design, looks appropriate, even if as
mentioned in another reply, it is aimed at massive and highly
parallel storage layers with highly threaded applications.

Aside note: I think that on most VM systems using "virtual disks"
of any sort except to store he OS filetree which is mostly RO is a
bad idea, and I suffered a lot last year dealing with a rather
hastily thrown together setup of that sort.

In that case I eliminated all but the root filetree VM disks and
replaced them with filetrees exported via NFS from XFS on the
underlying VM host itself (that is not over the network).

This improved performance tremendously (in part because in most VM
layers virtual NICs are more efficient than virtual disk adapters)
but in particular much faster check/repair and much reduced crazy
latencies during backups, because I could run check/repair and the
backups *on the real machine*, where XFS performed a lot better
without the VM overheads and "skewed" latencies.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
