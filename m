Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 58C7F7F37
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 00:35:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 47DA08F8050
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 22:35:26 -0700 (PDT)
Received: from mx2.lixium.fr (mx2.lixium.fr [79.98.96.12]) by cuda.sgi.com
	with ESMTP id NS3KTDt2BCH2IRnd for <xfs@oss.sgi.com>;
	Wed, 09 Sep 2015 22:35:18 -0700 (PDT)
Received: from [192.168.1.21] (nsg93-h01-31-34-69-35.dsl.sta.abo.bbox.fr
	[31.34.69.35]) (Authenticated sender:
	europeanservers-c.baegert-maildrop@mx2.lixium.fr)
	by mx2.lixium.fr (Postfix) with ESMTPSA id 5EF5B61CBEBD
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 07:35:17 +0200 (CEST)
Message-ID: <55F116A4.5080106@lixium.fr>
Date: Thu, 10 Sep 2015 07:35:32 +0200
From: Christophe Baegert <c.baegert@lixium.fr>
MIME-Version: 1.0
Subject: bug during xfs_repair -L on 1TB of strategic data
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

I see this message when repairing an XFS partition of 1TB of strategic 
data (on Debian Wheezy)

What can I do ?

corrupt dinode 1933282003, extent total = 1, nblocks = 0.  This is a bug.
Please capture the filesystem metadata with xfs_metadump and
report it to xfs@oss.sgi.com.
cache_node_purge: refcount was 1, not zero (node=0x7f7c55b35220)

fatal error -- 117 - couldn't iget disconnected inode

Regards,
-- 
Christophe Baegert
Lixium
http://www.lixium.fr

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
