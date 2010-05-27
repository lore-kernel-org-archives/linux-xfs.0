Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4RE2ijM137846 for <xfs@oss.sgi.com>; Thu, 27 May 2010 09:02:44 -0500
Received: from kaylee.flamingspork.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EE70437BE01
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 07:05:07 -0700 (PDT)
Received: from kaylee.flamingspork.com (kaylee.flamingspork.com
	[74.207.245.61]) by cuda.sgi.com with ESMTP id haLaXHFKo2JunpKE
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 07:05:07 -0700 (PDT)
From: Stewart Smith <stewart@flamingspork.com>
Subject: Re: NOW: o_direct   --  WAS: Re: WARNING in xfs_lwr.c, xfs_write()
In-Reply-To: <4BFD3926.6040208@hardwarefreak.com>
References: <20100523002023.41f5a5c8@aaa.pulp.binarylife.net>
	<20100523101856.GL2150@dastard>
	<20100523092344.0fcaab42@aaa.pulp.binarylife.net>
	<4BF9FCA8.8090906@hardwarefreak.com>
	<20100524143428.6f3a117c@abend.internal.xtremedata.com>
	<20100526070620.GT2150@dastard>
	<4BFD3926.6040208@hardwarefreak.com>
Date: Fri, 28 May 2010 00:05:05 +1000
Message-ID: <87mxvlbfu6.fsf@willster.local.flamingspork.com>
MIME-Version: 1.0
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
To: Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

On Wed, 26 May 2010 10:07:18 -0500, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> Please educate the ignorant a little bit Dave.  I'm not a programmer, or at
> least, haven't been one for a couple of decades.  If o_direct is superior to
> mmap, why then don't, say, Postfix and Dovecot use it instead of mmap?  Email
> servers are some of the most disk I/O bound applications on the planet.  I
> would think on heavily loaded mail servers (smtp or imap), at $big_isp for
> example, buffer cache would yield very little performance gain, and may even
> slow the system down due to buffer cache thrashing.

email servers are metadata heavy workloads, not data heavy. They do lots
of create/rename/delete of small files.

O_DIRECT requires you to do IO in multiples of 512bytes aligned to
512byte boundaries.

things like email servers... generally don't need/do that.

Database servers tend to do that, so they use O_DIRECT.

Also, email smtpd delivering a message on a machine, you could quite
likely have imapd come along and read that soon after, so using the
cache makes sense.

> Why do you think Wietse and Timo don't use o_direct instead of mmap?  Timo is
> working on a complex and aggressive totally asynchronous I/O subsystem for a
> future Dovecot release in an effort to speed up I/O on loaded systems.  Could
> o_direct not be the solution?  AFAIK, both Postfix and Dovecot support running
> on just about every Unix like OS on the planet.  Is o_direct not a portable
> interface, limited to Linux only?  Is o_direct a POSIX standard?

not posix.

but you can get the functionality out of linux through opening with
O_DIRECT, solaris by doing o_direct(), and who cares about the rest :)

-- 
Stewart Smith

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
