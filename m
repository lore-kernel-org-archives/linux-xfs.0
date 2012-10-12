Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9CLUSma231367 for <xfs@oss.sgi.com>; Fri, 12 Oct 2012 16:30:28 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3sk5KHsXCnLyWY0A for
	<xfs@oss.sgi.com>; Fri, 12 Oct 2012 14:32:02 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9CLW17P000496
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 12 Oct 2012 17:32:01 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q9CLW07n007586
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 12 Oct 2012 17:32:01 -0400
Message-ID: <50788C50.40600@redhat.com>
Date: Fri, 12 Oct 2012 16:32:00 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH 0/3] xfsdump: more projid32bit fixes
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
To: xfs-oss <xfs@oss.sgi.com>

I recently sent a patch for 32-bit project IDs for xfsdump, to properly
restore the top 16 bits, which otherwise get lost.  This forced a new
dump format version 4 (we were currently at 3).

One thing missing is that we should not restore a dump with 32-bit
project IDs onto a filesystem w/o that format; the restore will fail
to restore the top 16 bits (but otherwise it returns success; attribute
setting failures are not fatal (!?))

Also, 32-bit project ID is a bit uncommon; bumping the format (and making
older restore incompatible) is a bit draconian.

3 patches here:

1/3: extend fs info call to get fs flags as well
2/3: default back to V3 and go to V4 only if the projid32 flag is set
3/3: fail restore if the target XFS fs doesn't have projid32 set

I have to say, I'm not super happy with this.  I have nagging fear
of feature-flag-itis, and I'm not sure how extensible this is as newer
versions may appear.  But anyway, here's a place to start.

(p.s. anybody have wkendall's new email?)  ;)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
