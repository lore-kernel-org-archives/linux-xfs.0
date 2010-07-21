Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6LHVC5Z089714 for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 12:31:12 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 323D71E304AA
	for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 10:34:12 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id pQh7DEYDumbIjM4G for <xfs@oss.sgi.com>;
	Wed, 21 Jul 2010 10:34:12 -0700 (PDT)
Date: Wed, 21 Jul 2010 19:32:25 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] Add test for correct $SCRATCH_MNT into
	_require_scratch
Message-ID: <20100721173224.GG3447@quack.suse.cz>
References: <1279731052-30631-1-git-send-email-jack@suse.cz>
	<1279731052-30631-3-git-send-email-jack@suse.cz>
	<20100721165428.GA1061@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <20100721165428.GA1061@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 21-07-10 12:54:28, Christoph Hellwig wrote:
> This one is missing a signoff.  Once you add it I can apply the series
> and push it out.
  Oops sorry. Attached is the patch including the signoff.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--2fHTh5uZTiUOsy+g
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0002-Add-test-for-correct-SCRATCH_MNT-into-_require_scrat.patch"

>From d72c11b63aa22c920b460a71d4384c2f39be6513 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 15 Jun 2010 10:54:12 +0200
Subject: [PATCH 2/2] Add test for correct $SCRATCH_MNT into _require_scratch

Signed-off-by: Jan Kara <jack@suse.cz>

---
 common.rc |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/common.rc b/common.rc
index 6bf1e12..72997f9 100644
--- a/common.rc
+++ b/common.rc
@@ -703,6 +703,10 @@ _require_scratch()
 		 then
 		     _notrun "this test requires a valid \$SCRATCH_DEV"
 		 fi
+		if [ ! -d "$SCRATCH_MNT" ]
+		then
+		     _notrun "this test requires a valid \$SCRATCH_MNT"
+		fi
 		 ;;
     esac
 
-- 
1.6.4.2


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--2fHTh5uZTiUOsy+g--
