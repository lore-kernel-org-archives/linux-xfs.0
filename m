Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8311B7F4E
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 16:50:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0D17EAC003
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 14:50:34 -0700 (PDT)
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22]) by cuda.sgi.com
	with ESMTP id NPGwCmxiFuhYvTiC (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 08 Jul 2014 14:50:33 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <trinity-ff2aab11-c2a0-4349-9805-8dc72af47741-1404856231271@3capp-gmx-bs13>
From: "Hans Kraus" <hans.w.kraus@gmx.at>
Subject: Re: Error (failing assert) in xfs_repair
Date: Tue, 8 Jul 2014 23:50:31 +0200
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi Dave,

sorry for the HTML mail. My normal mail account isn't allowed to send mail to the list,
my provider got somehow onto a spam list. I had to revert to GMX and only recently learnt
how to send plain text mails via GMX. I hope that that works now.

The system is now down, therefore some of the details you requested are only from my memory.
The version of xfstools is the one I got with the command "git clone git://oss.sgi.com/xfs/cmds/xfsprogs",
sunday or monday this week.

The story is as follows: my backup file system is on a Raid6 (mdadm), on top of that lvm2 and xfs.
One of the HDs reported smart errors, I replaced it with a new one. During the Raid6 resyncronisation
I got a kernel panic. After reset the raid didn't come up. I finally started it with the '--force'
parameter. After that the filesystem didn't mount. I issued the 'xfs_repair -L ...' from the
current distribution, Debian 7 amd64. During the repair process the command stalled for more than
24 hours. After that I got nervous and restarted the machine.

Then I downloaded the git xfstools version and compiled it. Now I get repeatedly the error from
my first mail.

Two more drives failed, I'm now back to a system without any retundancy. I will only power it up
again when I have two new replacement drives (already ordered).

Kind regards, Hans

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
