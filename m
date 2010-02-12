Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CHUHfP008966
	for <linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 11:30:17 -0600
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6DCAB1CB089
	for <linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 09:31:31 -0800 (PST)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id jgPApfDF0NNDPNeW for <linux-xfs@oss.sgi.com>;
	Fri, 12 Feb 2010 09:31:31 -0800 (PST)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1NfzMW-0001DB-OB
	for linux-xfs@oss.sgi.com; Fri, 12 Feb 2010 18:31:28 +0100
Received: from vm15c-113.broadinstitute.org ([69.173.114.122])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 18:31:28 +0100
Received: from nico by vm15c-113.broadinstitute.org with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 18:31:28 +0100
From: Nicolas Stransky <nico@stransky.cx>
Subject: Re: xfs_repair on a 1.5 TiB image has been hanging for about an hour,
	now
Date: Fri, 12 Feb 2010 12:31:03 -0500
Message-ID: <hl438l$bhm$1@ger.gmane.org>
References: <2d460de71002120607g763afc2bt2167fcfbf4664b56@mail.gmail.com>	<4B75738D.80108@sandeen.net>	<2d460de71002120845ue5b127ex1033b37ae5ff6ba2@mail.gmail.com>
	<2d460de71002120902g3bda548t4e202dfe43a0c742@mail.gmail.com>
Mime-Version: 1.0
In-Reply-To: <2d460de71002120902g3bda548t4e202dfe43a0c742@mail.gmail.com>
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
To: linux-xfs@oss.sgi.com

I'm running into the same problem exactly, except that it's not 10
minutes, but DAYS.

What is the version that fixes this?

Thanks

On 2/12/10 12:02 PM, Richard Hartmann wrote:
> On Fri, Feb 12, 2010 at 17:45, Richard Hartmann
> <richih.mailinglist@gmail.com> wrote:
> 
>> I thought about that, but I fear that I will flood my terminal off with crap
>> and/or that I somehow impair xfs_repair while doing so.
> 
> Running it for ten minutes gives me:
> 
> root@grml ~ # strace -p13629
> Process 13629 attached - interrupt to quit
> futex(0xa381b4cc, FUTEX_WAIT_PRIVATE, 2, NULL^C <unfinished ...>
> Process 13629 detached
> root@grml ~ #


-- 
Nico

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
