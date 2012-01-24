Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0ONYP9B117825 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 17:34:26 -0600
Received: from mailrelay.mcs.anl.gov (newman-1.mcs.anl.gov [140.221.6.6]) by
	cuda.sgi.com with ESMTP id i3G2gLLGAYjXTQpU for
	<xfs@oss.sgi.com>; Tue, 24 Jan 2012 15:34:24 -0800 (PST)
Date: Tue, 24 Jan 2012 17:34:24 -0600
From: John Valdes <valdes@anl.gov>
Subject: Re: log recovery fails at mount
Message-ID: <20120124233424.GB20222@starfish.mcs.anl.gov>
References: <20120124024340.GA6689@starfish.mcs.anl.gov>
	<4F1E3C71.1020303@sandeen.net>
	<20120124225840.GA20222@starfish.mcs.anl.gov>
	<4F1F38C3.9090409@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F1F38C3.9090409@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Tue, Jan 24, 2012 at 05:03:31PM -0600, Eric Sandeen wrote:
> On 1/24/12 4:58 PM, John Valdes wrote:
> 
> > [...] if I loopback mount the img file, the file/directory names in
> > the mounted fs are mostly corrupted;
> 
> that's because metadump obfuscates filenames by default.  There's an option
> to keep them in the clear, and then you won't see all that garbage.

Ah, OK.  A bit unexpected, but if I repeat the process using the '-o'
option w/ xfs_metadump, the loopback mounted fs now looks as expected:

  prompt# ls -F /mnt
  backup/  data/  pvfs2-server.log  pvfs2-server.log.0 pvfs2-server.log-crashed

I'll run xfs_repair -L on the real filesystem now.

Many thanks for the help!

John

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
