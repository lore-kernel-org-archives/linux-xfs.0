Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1J6fblX114869 for <xfs@oss.sgi.com>; Fri, 19 Feb 2010 00:41:38 -0600
Received: from srv.cyf-kr.edu.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A7D611CDC255
	for <xfs@oss.sgi.com>; Thu, 18 Feb 2010 22:42:55 -0800 (PST)
Received: from srv.cyf-kr.edu.pl (srv.cyf-kr.edu.pl [149.156.2.11]) by
	cuda.sgi.com with ESMTP id KhkFYBr5AgzAzLsr for
	<xfs@oss.sgi.com>; Thu, 18 Feb 2010 22:42:55 -0800 (PST)
From: Patryk Lason <p.lason@cyfronet.pl>
Subject: Re: XFS + LVM + quota = disk quota exceeded
Date: Fri, 19 Feb 2010 07:42:38 +0100
References: <201002181106.36672.p.lason@cyfronet.pl>
	<4B7DBADB.5020409@sandeen.net>
In-Reply-To: <4B7DBADB.5020409@sandeen.net>
MIME-Version: 1.0
Message-Id: <201002190742.39041.p.lason@cyfronet.pl>
Reply-To: p.lason@cyfronet.pl
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thursday 18 of February 2010, Eric Sandeen wrote:
> Patryk Lason wrote:
> > Hello,
> >
> > I'm not able to touch a file on an XFS filesystem with quotas created on
> > an LVM volume.
> > Even if I set limits to 10TB on 2TB device.
> 
> ...
> 
> > From xfs_quota:
> > Disk quotas for User xxx (1111)
> > Filesystem              Blocks      Quota      Limit  Warn/Time     
> > Mounted on
> > /dev/mapper/lvm--people-people
> >                         742740 10737418240 10737418240   00 [--------]
> > /people
> >
> >
> > # su - xxx
> > $ pwd
> > /people/xxx
> > $ touch a
> > touch: cannot touch `a': Disk quota exceeded
> >
> >
> > What may be wrong and where?
> 
> file quota maybe, not block quota; quota -i ?

Looks like I've found it.
I played with "-d" parameter for "limit" in xfs_quota.
I wanted to set default quota for users, but using the following
command:

limit -u bsoft=5g bhard=7g isoft=0 ihard=0 -d

the limit is set also for groups.
That's why I couldn't created any file.

I have xfsprogs-2.9.4.

Regards,
Patryk

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
