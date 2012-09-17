Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8HF71RA175409 for <xfs@oss.sgi.com>; Mon, 17 Sep 2012 10:07:01 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jP5utCs82nrvNcj8 for
	<xfs@oss.sgi.com>; Mon, 17 Sep 2012 08:08:11 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8HF8AeM011934
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 17 Sep 2012 11:08:10 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-119.phx2.redhat.com
	[10.3.113.119])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q8HF87vb016825
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 17 Sep 2012 11:08:10 -0400
Date: Mon, 17 Sep 2012 12:08:06 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/4] xfs: make inode64 as the default allocation mode
Message-ID: <20120917150806.GA1957@andromeda.usersys.redhat.com>
References: <1347641381-30050-1-git-send-email-cmaiolino@redhat.com>
	<1347641381-30050-2-git-send-email-cmaiolino@redhat.com>
	<50537229.1000801@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50537229.1000801@sandeen.net>
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

On Fri, Sep 14, 2012 at 01:06:33PM -0500, Eric Sandeen wrote:
> This looks wrong.  If a user has a system which cannot handle 64 bit inodes,
> you reject a request to mount with 32-bit inodes?
> 
Yeah, you're right, thanks for the review. I'm fixing these mistakes and will
re-send the patchset
-- 
--Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
