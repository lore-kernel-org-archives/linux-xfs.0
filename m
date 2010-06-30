Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5UCNOMI128216 for <xfs@oss.sgi.com>; Wed, 30 Jun 2010 07:23:24 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6987D1579A61
	for <xfs@oss.sgi.com>; Wed, 30 Jun 2010 05:26:09 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id IPeavgaLP5sR2K74 for
	<xfs@oss.sgi.com>; Wed, 30 Jun 2010 05:26:09 -0700 (PDT)
Received: from [192.168.3.12] (Athenae [192.168.3.12])
	by Ishtar.sc.tlinx.org (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5UCPwr7010942 for <xfs@oss.sgi.com>; Wed, 30 Jun 2010 05:26:00 -0700
Message-ID: <4C2B37D6.50801@tlinx.org>
Date: Wed, 30 Jun 2010 05:25:58 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: When it rains it pours....
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Due to another bug in lvm, my restore of this partition crashed after running a few
hours (takes alot longer to restore than to backup).

So I decided to use the "-R" option to Resume my previously left off dump:

# xfsrestore -R -p 180 -f /backups/Ishtar/torrents/torrents-100629-0-1611.dump .
  xfsrestore: using file dump (drive_simple) strategy
  xfsrestore: version 3.0.4 (dump format 3.0) - Running single-threaded
  xfsrestore: resuming restore previously begun Wed Jun 30 04:41:57 2010
  xfsrestore: examining media file 0
  xfsrestore: seeking past portion of media file already restored

Looks good so far!..Yup, and..

  xfsrestore: drive_simple.c:770: do_seek_mark: Assertion `nreadneeded64 <= ( ( intgen_t ) ( ( ( 1ull << ( ( unsigned long long )sizeof( intgen_t ) * ( unsigned long long )8 - ( 1ull + 1ull ))) - 1ull ) * 2ull + 1ull ))' failed.
  Aborted (core dumped)


Say what?  Um...is that supposed to be an error message?
 
Why can't it just tell me why "'nreadneeded64' > 0xbfffffffffffffd"
is 'bad', or what it means?

I have a feeling that the 'core dumped' message means that 
if I want my filesystem restored in the near future, I should
just restart...

*sigh*
-l

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
