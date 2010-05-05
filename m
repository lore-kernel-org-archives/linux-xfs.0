Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o45MKEUW057004 for <xfs@oss.sgi.com>; Wed, 5 May 2010 17:20:15 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7DC2294B1A2
	for <xfs@oss.sgi.com>; Wed,  5 May 2010 15:22:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ua8FdzbZXHpYaYAs for
	<xfs@oss.sgi.com>; Wed, 05 May 2010 15:22:24 -0700 (PDT)
Message-ID: <4BE1EF9D.2030901@sandeen.net>
Date: Wed, 05 May 2010 17:22:21 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Fwd: xfs - fixing wrong xfs size
References: <dbd747120904130713t7388971axf75ee779b5b1e1f2@mail.gmail.com>	<49E353FD.5060207@sandeen.net>	<dbd747120904130913p45c2979eu5afd15f5a6ca7b7f@mail.gmail.com>
	<dbd747120904130933i6ae66aedt7912a47b7e561f76@mail.gmail.com>
In-Reply-To: <dbd747120904130933i6ae66aedt7912a47b7e561f76@mail.gmail.com>
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
To: Nebojsa Trpkovic <trx.lists@gmail.com>
Cc: xfs@oss.sgi.com

On 04/13/2009 11:33 AM, Nebojsa Trpkovic wrote:

> how can I set superblock block-count value (now I have realy nothing to
> loose - the only other option is to give up of that data) ?

Sorry, I never replied to this :(

You can use xfs_db to set it; or you could comment out the kernel
check... and mount readonly, and copy off the data you can get to?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
