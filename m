Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4JHVYN3144386 for <xfs@oss.sgi.com>; Wed, 19 May 2010 12:31:34 -0500
Received: from petole.demisel.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C23951B5D669
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 10:33:52 -0700 (PDT)
Received: from petole.demisel.net (petole.demisel.net [88.174.118.95]) by
	cuda.sgi.com with ESMTP id yQYrCV8m0al4yZHc for
	<xfs@oss.sgi.com>; Wed, 19 May 2010 10:33:52 -0700 (PDT)
Subject: Re: noatime,nodiratime?
References: <4BF3F212.5030600@hardwarefreak.com>
From: Nicolas KOWALSKI <niko@petole.demisel.net>
Date: Wed, 19 May 2010 19:33:49 +0200
In-Reply-To: <4BF3F212.5030600@hardwarefreak.com>
Message-ID: <87mxvveqyq.fsf@petole.demisel.net>
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
To: xfs@oss.sgi.com

Stan Hoeppner <stan@hardwarefreak.com> writes:
> Need a little education here.  I have a general understanding of what the
> inode access timestamps "are" but I have no idea what, if any, applications
> make use of these access times.  I see posts all over Google land saying to
> use "noatime,nodiratime,logbufs=8" for XFS mount options to increase
> performance.

BTW, about the mount options for XFS, is there a way to check for the
default values (things like logbsize, logbufs, something else)?

I used to have noatime,logbufs=8,logbsize=256k on my fileserver, not
sure if these are still necessary.

Thanks,
-- 
Nicolas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
