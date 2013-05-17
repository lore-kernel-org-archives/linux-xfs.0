Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 13DB229DF8
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 07:02:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 96AB0AC002
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 05:02:26 -0700 (PDT)
Received: from trent.utfs.org (trent.utfs.org [94.185.90.103]) by cuda.sgi.com
	with ESMTP id 74neLNnPwDjrHrI9 for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 05:02:24 -0700 (PDT)
Date: Fri, 17 May 2013 05:02:21 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: xattr performance
Message-ID: <alpine.DEB.2.10.1305170444590.13746@trent.utfs.org>
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
To: jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com

Hi,

a while ago I was setting & reading extended attributes to ~25000 files 
in a directory structure on an XFS filesystem. The files were usually a 
few MB in size, but some where up to 2GB in size.

Anyway, I *felt* that setting or reading these xattrs was going very
slowly. While the storage may be not the fastest, stat()'ing these
files was fine, but getfattr/setfattr took very long.

I got curious and while it turned out that the slowness was related to the 
wrapper script I used to read/set those values, I created a little test 
suite to 1) create a few thousand files and 2) do xattr operations on 
them and see if xattr performance was filesystem specific:

   http://nerdbynature.de/bits/xattr/

Not very sophisticated, true. But it was interesting to see that 
ext3/ext4/xfs behaved kinda well for all these tests; btrfs/jfs/reiserfs
sometimes took way longer than the others.

Christian.
-- 
BOFH excuse #43:

boss forgot system password

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
