Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6PAaYAO194670 for <xfs@oss.sgi.com>; Sat, 25 Jul 2009 05:36:34 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7779510C053C
	for <xfs@oss.sgi.com>; Sat, 25 Jul 2009 03:45:46 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.10])
	by cuda.sgi.com with ESMTP id n1Hr9xsUUrUidFq1 for
	<xfs@oss.sgi.com>; Sat, 25 Jul 2009 03:45:46 -0700 (PDT)
Date: Sat, 25 Jul 2009 03:36:53 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: Using xfsdump On Linux With IRIX Version 1 FS?
In-Reply-To: <20090725102258.GA1121@citd.de>
Message-ID: <alpine.DEB.2.01.0907250332110.6426@bogon.housecafe.de>
References: <C68F8010.B953%elbles@sessys.com>
	<alpine.DEB.2.01.0907242048000.6426@bogon.housecafe.de>
	<20090725072617.GA30450@citd.de>
	<alpine.DEB.2.01.0907250241170.6426@bogon.housecafe.de>
	<20090725102258.GA1121@citd.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Matthias Schniedermeyer <ms@citd.de>
Cc: Sean Elble <elbles@sessys.com>, xfs@oss.sgi.com

On Sat, 25 Jul 2009 at 12:22, Matthias Schniedermeyer wrote:
> I meant: What is the advantage of using the a loop-device (of the image) 
> instead of directly using the image?

Some tools don't like to act on flat files, i.e. mkfs.reiserfs won't 
create a filesystem on a file without -forcing it, dunno about all the 
xfsprogs though, or "hexedit", or....

-- 
BOFH excuse #5:

static from plastic slide rules

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
