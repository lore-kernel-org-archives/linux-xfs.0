Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7CJFiTm079204 for <xfs@oss.sgi.com>; Fri, 12 Aug 2011 14:15:44 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A60FF1368150
	for <xfs@oss.sgi.com>; Fri, 12 Aug 2011 12:17:23 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id tgtLW48kWH2zkQ9k
	for <xfs@oss.sgi.com>; Fri, 12 Aug 2011 12:17:23 -0700 (PDT)
Received: by bkd1 with SMTP id 1so2111081bkd.26
	for <xfs@oss.sgi.com>; Fri, 12 Aug 2011 12:15:42 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 12 Aug 2011 14:15:41 -0500
Message-ID: <CAGtzr3foKAyeq=fFr_ROLBztFzPy2koWQ8xsgQZ012yBxQdf3A@mail.gmail.com>
Subject: mkfs.xfs blank sw value mapped to (unsigned long)(-1), expensive when
	using swalloc
From: Chris Pearson <kermit4@gmail.com>
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

Blank sw mapped to -1 (must be an error value returned from some
string parsing function)

So it ends up 4294967264 if su is 128k, as that's equal to (unsigned
long)(-1 * su/bsize)

If you're mounting with swalloc, you'll quickly wind up with no free
space! Ouch!

# mkfs.xfs -V
mkfs.xfs version 3.1.4
# mkfs.xfs -dfile=1,name=hi,size=$((1024*1024*100)) -bsize=4k -d
su=128k,sw= -l version=2 -i size=2k -l lazy-count=1
meta-data=hi                     isize=2048   agcount=4, agsize=6400 blks
        =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=25600, imaxpct=25
        =                       sunit=32     swidth=4294967264 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=1248, version=2
        =                       sectsz=512   sunit=32 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
