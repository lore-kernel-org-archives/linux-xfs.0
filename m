Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p22Jiknt041265 for <xfs@OSS.SGI.com>; Wed, 2 Mar 2011 13:44:47 -0600
Received: from hermes1.dur.ac.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 902BB30C8C2
	for <xfs@OSS.SGI.com>; Wed,  2 Mar 2011 11:47:36 -0800 (PST)
Received: from hermes1.dur.ac.uk (hermes1.dur.ac.uk [129.234.248.1]) by
	cuda.sgi.com with ESMTP id 3LDABahy93H9xo75 for
	<xfs@OSS.SGI.com>; Wed, 02 Mar 2011 11:47:36 -0800 (PST)
Received: from smtphost3.dur.ac.uk (smtphost3.dur.ac.uk [129.234.252.3])
	by hermes1.dur.ac.uk (8.13.8/8.13.7) with ESMTP id p22JlMoT017238
	for <xfs@OSS.SGI.com>; Wed, 2 Mar 2011 19:47:26 GMT
Received: from ty.sabi.co.UK (o1.phyip3.dur.ac.uk [129.234.186.1])
	by smtphost3.dur.ac.uk (8.13.8/8.13.7) with ESMTP id p22JlAgW003549
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <xfs@OSS.SGI.com>; Wed, 2 Mar 2011 19:47:10 GMT
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1Pus0n-00085q-JR
	for <xfs@OSS.SGI.com>; Wed, 02 Mar 2011 19:47:05 +0000
MIME-Version: 1.0
Message-ID: <19822.40630.799564.336178@tree.ty.sabi.co.UK>
Date: Wed, 2 Mar 2011 19:47:02 +0000
Subject: Re: xfs_repair in traversing filesystem
In-Reply-To: <AANLkTimJ0tdvSy+7MSykNm4mW1XoO8PQ_-G9UBonFh8V@mail.gmail.com>
References: <AANLkTimJ0tdvSy+7MSykNm4mW1XoO8PQ_-G9UBonFh8V@mail.gmail.com>
From: pg_xf2@xf2.to.sabi.co.UK (Peter Grandi)
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
To: Linux XFS <xfs@oss.sgi.com>

> Our 35TB XFS filesystem developed some problems and was
> throwing these: [ ... ]

How many drives support that filesystem?
How many inodes does it have?

> so we're running xfs_repair on this filesystem.  It finds this
> inode and everything looks good, but then it hangs at [ ... ]
> - traversing filesystem ...  previous posts suggest running
> xfs_repair -P -o bhash=1024 [ ... ]

It depends on how fast you expect that to happen and how much
memory you have. 'man xfs_repair' says that "The default size is
set to use up the remainder of 75% of the system's physical RAM
size" which seems pretty good to me. You may want to increase
the '-o ihash' value too, or '-m'. Also check the '-P' option.

BTW I just noticed in the same 'man xfs_repair' the option that
"can significantly reduce repair times on concat based filesystems"
which is so amusing...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
