Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p22JilEq041269
	for <linux-xfs@oss.sgi.com>; Wed, 2 Mar 2011 13:44:53 -0600
Received: from hermes1.dur.ac.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A6729A6B78C
	for <linux-xfs@oss.sgi.com>; Wed,  2 Mar 2011 11:47:36 -0800 (PST)
Received: from hermes1.dur.ac.uk (hermes1.dur.ac.uk [129.234.248.1]) by
	cuda.sgi.com with ESMTP id BguHIP5lNCOApHEy for
	<linux-xfs@oss.sgi.com>; Wed, 02 Mar 2011 11:47:36 -0800 (PST)
Received: from smtphost2.dur.ac.uk (smtphost2.dur.ac.uk [129.234.252.2])
	by hermes1.dur.ac.uk (8.13.8/8.13.7) with ESMTP id p22JlNeS017239
	for <linux-xfs@oss.sgi.com>; Wed, 2 Mar 2011 19:47:27 GMT
Received: from ty.sabi.co.UK (o1.phyip3.dur.ac.uk [129.234.186.1])
	by smtphost2.dur.ac.uk (8.13.8/8.13.7) with ESMTP id p22JlAFM019521
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <linux-xfs@oss.sgi.com>; Wed, 2 Mar 2011 19:47:10 GMT
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1Puqc4-0007VF-2h
	for <linux-xfs@oss.sgi.com>; Wed, 02 Mar 2011 18:17:28 +0000
MIME-Version: 1.0
Message-ID: <19822.35253.758862.662542@tree.ty.sabi.co.UK>
Date: Wed, 2 Mar 2011 18:17:25 +0000
Subject: Re: xfs 14TB - check
In-Reply-To: <31051172.post@talk.nabble.com>
References: <31051172.post@talk.nabble.com>
From: pg_xf2@xf2.to.sabi.co.UK (Peter Grandi)
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
To: Linux XFS <linux-xfs@oss.sgi.com>


xfs> i formated a storage with 16 disks (Raid5  and sparedrive)
xfs> with xfs.

One of the many wonderful ideas that get published in this list! :-)

xfs> i used xfs_repair /dev/cciss/c0...p1 and got the following
xfs> error message: fatal error -- couldn't allocate block map,
xfs> size XXXXXXX

xfs> I have 2 GB of Ram in the machine. What should I do and how
xfs> to check my volume?

You probably need a 64 bit systems with a lot more RAM:

  http://groups.google.com/group/comp.arch.storage/browse_thread/thread/f7b8cd324bed34f9/95b96de52dfe321f
  http://groups.google.com/group/linux.debian.ports.x86-64/browse_thread/thread/e9d37880252c1ac5/fd2b4d46a4c294b5

Things have improved a bit with later releases of 'xfsprogs',
but it still takes a lot of space and time. This mailing list
has some post with an estimate of how much RAM and is neeeded
currently. Time depends very much on what is inside the
filesystem and how damaged it is, 14TB could take many hours or
many weeks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
