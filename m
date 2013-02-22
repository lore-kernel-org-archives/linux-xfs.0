Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CE9947F50
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 07:27:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7A6DBAC00A
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 05:27:26 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3VE8SsXuDPuEsO6x for
	<xfs@oss.sgi.com>; Fri, 22 Feb 2013 05:27:25 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1MDRPr2013022
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 08:27:25 -0500
Received: from andromeda.usersys.redhat.com (ovpn-113-79.phx2.redhat.com
	[10.3.113.79])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r1MDRL4J010022
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 08:27:24 -0500
Date: Fri, 22 Feb 2013 10:27:21 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: inode64 superblock flag is still worth
Message-ID: <20130222132721.GA10079@andromeda.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
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

Hi,

I was looking the "Ideas for XFS" wiki page, and noticed a topic about the
implementation of a flag in superblock to identify the filesystem is using
64-bit inodes. Once we use it by default now, is this idea still worth? I can
work on it, but I don't think this is still worth to be implemented.
If still looks worth, I'd suggest a flag set when 32-bit inodes only is used not
64, but I really dunno how this might be useful for kernel. From a user
perspective, it might help, but `mount` command or mtab already shows inode32
option when it's used.

comments?

Cheers,
-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
