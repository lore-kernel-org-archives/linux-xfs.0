Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1IM9HU7079494 for <xfs@oss.sgi.com>; Thu, 18 Feb 2010 16:09:17 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C0B3113BA53B
	for <xfs@oss.sgi.com>; Thu, 18 Feb 2010 14:10:36 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id mkksuQPYcyxvaxaX for
	<xfs@oss.sgi.com>; Thu, 18 Feb 2010 14:10:36 -0800 (PST)
Message-ID: <4B7DBADB.5020409@sandeen.net>
Date: Thu, 18 Feb 2010 16:10:35 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS + LVM + quota = disk quota exceeded
References: <201002181106.36672.p.lason@cyfronet.pl>
In-Reply-To: <201002181106.36672.p.lason@cyfronet.pl>
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
To: p.lason@cyfronet.pl
Cc: xfs@oss.sgi.com

Patryk Lason wrote:
> Hello,
> 
> I'm not able to touch a file on an XFS filesystem with quotas created on an LVM 
> volume.
> Even if I set limits to 10TB on 2TB device.

...

> From xfs_quota:
> Disk quotas for User xxx (1111)
> Filesystem              Blocks      Quota      Limit  Warn/Time      Mounted 
> on
> /dev/mapper/lvm--people-people
>                         742740 10737418240 10737418240   00 [--------] /people
> 
> 
> # su - xxx
> $ pwd
> /people/xxx
> $ touch a
> touch: cannot touch `a': Disk quota exceeded
> 
> 
> What may be wrong and where?

file quota maybe, not block quota; quota -i ?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
