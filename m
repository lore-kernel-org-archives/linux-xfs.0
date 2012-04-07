Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q37JBnVr056271 for <xfs@oss.sgi.com>; Sat, 7 Apr 2012 14:11:50 -0500
Received: from anakin.london.02.net (anakin.london.02.net [87.194.255.134]) by
	cuda.sgi.com with ESMTP id RBtEZPLXrLCR6C2T for
	<xfs@oss.sgi.com>; Sat, 07 Apr 2012 12:11:45 -0700 (PDT)
Received: from ty.sabi.co.UK (87.194.99.40) by anakin.london.02.net (8.5.140)
	id 4EEB63D201FAA14D for xfs@oss.sgi.com;
	Sat, 7 Apr 2012 20:11:43 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1SGb2v-00012Z-S0
	for <xfs@oss.sgi.com>; Sat, 07 Apr 2012 20:11:37 +0100
MIME-Version: 1.0
Message-ID: <20352.37224.437790.612297@tree.ty.sabi.co.UK>
Date: Sat, 7 Apr 2012 20:11:36 +0100
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
In-Reply-To: <CAAxjCEwYVB4T2EHU6JWi5Oxf=hepoKjVVj+dVAYWo_t4KNFeyg@mail.gmail.com>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
	<CAAxjCEwYVB4T2EHU6JWi5Oxf=hepoKjVVj+dVAYWo_t4KNFeyg@mail.gmail.com>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux fs XFS <xfs@oss.sgi.com>

> [ ... ] I also tried different Linux IO elevators, as you
> suggested in your other response, without any measurable
> effect. [ ... ]

That's probably because of the RAID6 host adapter being
uncooperative, but I wondered whether this might apply in some
form:

http://xfs.org/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomethin=
g.3E
 =ABAs of kernel 3.2.12, the default i/o scheduler, CFQ, will
  defeat much of the parallelization in XFS.=BB

BTW earlier 'cfq' versions have been reported to have huge
problems with workloads involving writes and reads, and only
'deadline' (which is quite unsuitable for some workloads) seems
to be fairly reliable.

http://www.webhostingtalk.com/showthread.php?t=3D727173

=ABAnyway, we have found HUGE problems with CFQ in many different
 scenarios and many different hardware setups. If it was only an
 issue with our configuration I would have foregone posting this
 message and simply informed those kernel developers responsible
 for the fix.

 Two scenarios where CFQ has a severe problem - When you are
 running a single block device (1 drive, or a raid 1 scenario)
 under certain circumstances where heavy sustained writes are
 occurring the CFQ scheduler will behave very strangely. It will
 begin to give all access to reads and limit all writes to the
 point of allowing only 0-2 I/O write operations being allowed
 per second vs 100-180 read operations per second. This condition
 will persist indefinitely until the sustained write process
 completes. This is VERY bad for a shared environment where you
 need reads and writes to complete regardless of increased reads
 or writes. This behavior goes beyond what CFQ says it is
 supposed to do in this situation - meaning this is a bug, and a
 serious one at that. We can reproduce this EVERY TIME.

 The second scenario occurs when you have two or more block
 devices, either single drives, or any type of raid array
 including raid 0,1,0+1,1+0,5 and 6. (We never tested 3,4 who
 uses raid 3 or 4 anymore anyway?!!). This case is almost exactly
 opposite of what happens with only one block device. In this
 case if one of more of the drives is blocked with heavy writes
 for a sustained period of time CFQ will block reads from the
 other devices or severely limit the reads until the writes have
 completed. We can also reproduce this behavior with test
 software we have written on a 100% consistent basis.=BB

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
