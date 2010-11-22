Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAMMUUfZ117956 for <xfs@oss.sgi.com>; Mon, 22 Nov 2010 16:30:30 -0600
Received: from ssec.wisc.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C643313E1C98
	for <xfs@oss.sgi.com>; Mon, 22 Nov 2010 14:32:07 -0800 (PST)
Received: from ssec.wisc.edu (mahogany.ssec.wisc.edu [128.104.110.2]) by
	cuda.sgi.com with ESMTP id jdvJdYGDFVzXKQ5s for
	<xfs@oss.sgi.com>; Mon, 22 Nov 2010 14:32:07 -0800 (PST)
Message-ID: <4CEAEF66.7030708@ssec.wisc.edu>
Date: Mon, 22 Nov 2010 16:32:06 -0600
From: Jesse Stroik <jstroik@ssec.wisc.edu>
MIME-Version: 1.0
Subject: Re: Improving XFS file system inode performance
References: <4CEAE7D7.6050401@ssec.wisc.edu>
	<20101122232528.21b78a9e@galadriel.home>
In-Reply-To: <20101122232528.21b78a9e@galadriel.home>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Linux XFS <xfs@oss.sgi.com>

On 11/22/2010 04:25 PM, Emmanuel Florac wrote:
> Le Mon, 22 Nov 2010 15:59:51 -0600 vous =E9criviez:
>
>> Performance was fine before the file system was filled -- last week
>> ~8TB showed up and filled the 20TB file system.  Since, it has been
>> performing poorly.
>
> Maybe it got fragmented? How does fragmentation look like?


I wasn't able to resolve this in reasonable time.  Part of the issue is =

that we're dealing with files within about 100k directories.  I'll =

attempt to get the fragmentation numbers overnight.

I suspect the regularly listed set of files on this fs exceeds the inode =

cache.  Where can I determine the cache misses and tune the file system?

Best,
Jesse

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
