Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C001A7F37
	for <xfs@oss.sgi.com>; Thu, 24 Sep 2015 18:18:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id ADD44304043
	for <xfs@oss.sgi.com>; Thu, 24 Sep 2015 16:18:47 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id UvgqwMe4G9ZVnBkm (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 24 Sep 2015 16:18:46 -0700 (PDT)
Received: from zmail20.collab.prod.int.phx2.redhat.com
	(zmail20.collab.prod.int.phx2.redhat.com [10.5.83.23])
	by mx3-phx2.redhat.com (8.13.8/8.13.8) with ESMTP id t8ONIjfE008953
	for <xfs@oss.sgi.com>; Thu, 24 Sep 2015 19:18:45 -0400
Date: Thu, 24 Sep 2015 19:18:45 -0400 (EDT)
From: Nathan Scott <nathans@debian.org>
Message-ID: <1112215787.42591167.1443136725773.JavaMail.zimbra@redhat.com>
In-Reply-To: <1303550487.42590968.1443136538184.JavaMail.zimbra@redhat.com>
Subject: Fix trivial libdm compile errors
MIME-Version: 1.0
Reply-To: Nathan Scott <nathans@debian.org>
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

(not released/tagged, I'll leave that for those who know the process;
I'll await a proper release before updating Debian unstable - cheers)

Changes committed to git://oss.sgi.com/nathans/dmapi.git master

Mathieu Malaterre (1):
      dmapi: fix handle2path compilation by adding missing #include lines

Nathan Scott (1):
      dmapi: bump version for releasing a small libdm compilation fix


 VERSION                |    2 +-
 debian/changelog       |    6 ++++++
 doc/CHANGES            |    4 ++++
 libdm/dm_handle2path.c |    5 +++++
 4 files changed, 16 insertions(+), 1 deletion(-)


commit e6ee9eaf62e85bbd502112f8e2e3a65a348b7309
Author: Nathan Scott <nathans@debian.org>
Date:   Fri Sep 25 08:31:55 2015 +1000

    dmapi: bump version for releasing a small libdm compilation fix
    
    Signed-off-by: Nathan Scott <nathans@debian.org>

commit 5c22e17d842b6b6e52e9432159a562beb372b35a
Author: Mathieu Malaterre <malat@debian.org>
Date:   Fri Sep 25 08:27:51 2015 +1000

    dmapi: fix handle2path compilation by adding missing #include lines
    
    Reviewed-by: Nathan Scott <nathans@debian.org>
    Signed-off-by: Nathan Scott <nathans@debian.org>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
