Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DDA017F95
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2015 09:28:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C03CB8F8050
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2015 07:28:42 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id UN4oVMaShUXPaDZS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 17 Jun 2015 07:28:40 -0700 (PDT)
Date: Wed, 17 Jun 2015 10:28:38 -0400 (EDT)
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <551099978.15978267.1434551318983.JavaMail.zimbra@redhat.com>
In-Reply-To: <919039035.15967379.1434550287476.JavaMail.zimbra@redhat.com>
Subject: mkfs: a possible bad
MIME-Version: 1.0
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
I'm looking into mkfs/xfs_mkfs.c and I wonder, is "if (xi.dbsize > sectorsize)" correct?
It is a check for:
Warning: the data subvolume sector size %u is less than the sector size reported by the device (%u).

But psectorsize is assigned to sectorsize, not to xi.dbsize, so the two values seems to be swapped in the condition (and as arguments of the printf too).
I think this gone without noticing because usually, when creating a partition, the two values are the same. So even if the condition is wrong, nothing happens. 
And when -bsize=X is passed, then it is catched earlier and nothing happens again.

Only when I apply a patch that changes how mkfs acts when it gets a file instead of a block device, I start to see the warning, although physical sector size is 512 and block size is set to 4096. The numbers are swapped in the warning too...

I tried to run ./check -g quick and it seems that the change breaks nothing.

Cheers,
Jan

-- 
Jan Tulak
jtulak@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
