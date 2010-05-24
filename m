Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4O5Edfl159252 for <xfs@oss.sgi.com>; Mon, 24 May 2010 00:14:40 -0500
Received: from kaylee.flamingspork.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4245E368747
	for <xfs@oss.sgi.com>; Sun, 23 May 2010 22:17:00 -0700 (PDT)
Received: from kaylee.flamingspork.com (kaylee.flamingspork.com
	[74.207.245.61]) by cuda.sgi.com with ESMTP id QIfxBQDB2wopbkqs
	for <xfs@oss.sgi.com>; Sun, 23 May 2010 22:17:00 -0700 (PDT)
From: Stewart Smith <stewart@flamingspork.com>
Subject: Re: WARNING in xfs_lwr.c, xfs_write()
In-Reply-To: <4BF9FCA8.8090906@hardwarefreak.com>
References: <20100523002023.41f5a5c8@aaa.pulp.binarylife.net>
	<20100523101856.GL2150@dastard>
	<20100523092344.0fcaab42@aaa.pulp.binarylife.net>
	<4BF9FCA8.8090906@hardwarefreak.com>
Date: Mon, 24 May 2010 15:16:58 +1000
Message-ID: <87r5l1ev5h.fsf@willster.local.flamingspork.com>
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

On Sun, 23 May 2010 23:12:24 -0500, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> "The whole notion of "direct IO" is totally braindamaged. Just say no.
> 
> 	This is your brain: O
> 	This is your brain on O_DIRECT: .
> 
> 	Any questions?"
> 
> 
> 		Linus
> 
> From:  http://lkml.org/lkml/2007/1/10/235

and the alternative is......

\0

(null).


We can have very explicit knowledge about buffers and IO in
userspace. Much better than you are ever going to have guessing it in
kernel IO paths. There currently exists *no* usable and reliable way of
transmitting this information to the kernel other than O_DIRECT.
-- 
Stewart Smith

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
