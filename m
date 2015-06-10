Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8DB8C7F86
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2015 02:06:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2A624AC002
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2015 00:06:10 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id wHDmqCDPfYZ9DEih (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Jun 2015 00:06:05 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1Z2a5M-00044r-T8
	for xfs@oss.sgi.com; Wed, 10 Jun 2015 07:06:04 +0000
Date: Wed, 10 Jun 2015 00:06:04 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: xfsprogs for-next build error on Debian Wheezy / amd64
Message-ID: <20150610070604.GA9855@infradead.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8583106924677298968=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8583106924677298968==
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

hch@brick:~/work/xfsprogs$ make
Building include
Building libxfs
    [TEST]    CRC32
In file included from crc32.c:61:0:
crc32table.h:4:1: error: ‘__le32’ undeclared here (not in a
function)
crc32table.h:4:1: error: expected expression before ‘__u32’
crc32table.h:4:20: error: expected expression before ‘__u32’
crc32table.h:4:39: error: expected expression before ‘__u32’
crc32table.h:4:58: error: expected expression before ‘__u32’
crc32table.h:5:1: error: expected expression before ‘__u32’
crc32table.h:5:20: error: expected expression before ‘__u32’
crc32table.h:5:39: error: expected expression before ‘__u32’
crc32table.h:5:58: error: expected expression before ‘__u32’

... and so on

Seems like we're not getting the right headers included in this
generated file, but I'm lost on what exactly is the error.


--===============8583106924677298968==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8583106924677298968==--
