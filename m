Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1T8aZb4260309 for <xfs@oss.sgi.com>; Wed, 29 Feb 2012 02:36:37 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	uSsFOgn5lgCMzBXE (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Feb 2012 00:36:34 -0800 (PST)
Date: Wed, 29 Feb 2012 03:36:33 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Question about project quota with container
Message-ID: <20120229083633.GA14241@infradead.org>
References: <4F4D8413.4050709@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F4D8413.4050709@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: xfs@oss.sgi.com

> I was wondering if other file system will also implement project quota
> based on these two configuration files in the future? In other words, is
> it a standard?

The have been a few attempts at roughly similar quotas for ext4, but
they were incompatible enough to not reuse any infrastructure like this.

> 
> Alternatively, maybe the project path and ID can be setup at cgroup
> control files too, the following things could be implemented like
> "xfsprogs/quota/edit.c", but I would put aside this idea for now.

Assigning the project IDs in the cgroups code sounds fine to me.  To
make peoples life's easier it might be good idea to keep the
/etc/projects and /etc/projid files uptodate even from that code.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
