Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4BA31Eu080591 for <xfs@oss.sgi.com>; Tue, 11 May 2010 05:03:02 -0500
Received: from smtp.stepping-stone.ch (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0BDE614952F3
	for <xfs@oss.sgi.com>; Tue, 11 May 2010 03:05:37 -0700 (PDT)
Received: from smtp.stepping-stone.ch (smtp.stepping-stone.ch
	[194.176.109.228]) by cuda.sgi.com with ESMTP id
	F8TMumapPxPkJQvy for <xfs@oss.sgi.com>;
	Tue, 11 May 2010 03:05:37 -0700 (PDT)
Message-ID: <4BE92BCD.1000604@purplehaze.ch>
Date: Tue, 11 May 2010 12:05:01 +0200
From: Christian Affolter <christian.affolter@purplehaze.ch>
MIME-Version: 1.0
Subject: Re: failed to read root inode
References: <4BE55A63.8070203@purplehaze.ch> <4BE57E0D.3020601@sandeen.net>
	<4BE6CC4C.3030501@purplehaze.ch>
In-Reply-To: <4BE6CC4C.3030501@purplehaze.ch>
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

Hi

>> So if repair isn't making a mountable fs, first suggestion would
>> be to re-try with the latest version of repair.
> 
> OK, I will try that. Unfortunately the latest upstream version isn't
> included within the distribution package repository, so I will have to
> compile it first.

OK, I was able to mount the volume by first repairing it with the latest
xfs_repair version and mount -o ro,norecovery [...]

Thank you everybody for your helpfulness and your suggestions regarding
this problem.


Regards
Christian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
