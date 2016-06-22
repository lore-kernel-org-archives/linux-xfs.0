Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 326267CA0
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 10:27:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 043F0304066
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 08:27:23 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id cF8cj3dSHHwbXDoG (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 22 Jun 2016 08:27:20 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: xfs: untangle the direct I/O and DAX path, fix DAX locking
Date: Wed, 22 Jun 2016 17:27:08 +0200
Message-Id: <1466609236-23801-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org

The last patch is what started the series:  XFS currently uses the
direct I/O locking strategy for DAX because DAX was overloaded onto
the direct I/O path.  For XFS this means that we only take a shared
inode lock instead of the normal exclusive one for writes IFF they
are properly aligned.  While this is fine for O_DIRECT which requires
explicit opt-in from the application it's not fine for DAX where we'll
suddenly lose expected and required synchronization of the file system
happens to use DAX undeneath.

Patches 1-7 just untangle the code so that we can deal with DAX on
it's own easily.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
