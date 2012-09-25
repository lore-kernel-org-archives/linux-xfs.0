Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8PDWGSp060375 for <xfs@oss.sgi.com>; Tue, 25 Sep 2012 08:32:16 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PJNBml3iq3PoEmYw for
	<xfs@oss.sgi.com>; Tue, 25 Sep 2012 06:33:33 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8PDXWuk017299
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 25 Sep 2012 09:33:33 -0400
Received: from andromeda.usersys.redhat.com ([10.3.113.16])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q8PDXTxQ029176
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 25 Sep 2012 09:33:32 -0400
Date: Tue, 25 Sep 2012 10:33:29 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 4/6] xfs: Fix mp->m_maxagi update during inode64 remount
Message-ID: <20120925133329.GA10780@andromeda.usersys.redhat.com>
References: <1348147961-7520-1-git-send-email-cmaiolino@redhat.com>
	<1348147961-7520-5-git-send-email-cmaiolino@redhat.com>
	<20120925093715.GF9189@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120925093715.GF9189@infradead.org>
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

On Tue, Sep 25, 2012 at 05:37:15AM -0400, Christoph Hellwig wrote:
> On Thu, Sep 20, 2012 at 10:32:39AM -0300, Carlos Maiolino wrote:
> > With the changes made on xfs_set_inode64(), to make it behave as
> > xfs_set_inode32() (now leaving to the caller the responsibility to update
> > mp->m_maxagi), we use the return value of xfs_set_inode64() to update
> > mp->m_maxagi during remount.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> Shouldn;t this be part of the previous patch?
> 
> Otherwise looks good.
> 
dchinner suggested to keep small changes into different patches, once the
xfs_set_inode64() was added previously, adding a separate patche to add
xfs_set_inode32() and another one to change the behaviour of both functions
looks reasonable to me
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
--Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
