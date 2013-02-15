Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2BB447F52
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2013 15:46:57 -0600 (CST)
Date: Fri, 15 Feb 2013 15:46:53 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: 32bit apps and inode64
Message-ID: <20130215214653.GP22182@sgi.com>
References: <4FA63DDA.9070707@profihost.ag> <20120507013456.GW5091@dastard>
	<4FA76E11.1070708@profihost.ag> <20120507071713.GZ5091@dastard>
	<4FA77842.5010703@profihost.ag>
	<4FA7FA14.6080700@hardwarefreak.com>
	<4FA82B07.1020102@profihost.ag>
	<4FAA153D.1030606@hardwarefreak.com>
	<20120509070450.GP5091@dastard> <511E4F00.2010703@profihost.ag>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <511E4F00.2010703@profihost.ag>
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
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Stefan,

On Fri, Feb 15, 2013 at 04:06:40PM +0100, Stefan Priebe - Profihost AG wrote:
> i've discovered some problems on a host with a disk > 1TB. We've some
> binary 32bit applications which are not able to read some directory
> anymore after we've formated and installed the system using vanilla
> 3.7.7 kernel.
> 
> Right now we're using 3.0.61 kernel on this host - so 64bit apps work
> well and newly created files get 32bit inode numbers as inode64 is not
> the default.
> 
> Is there a way to find / get all 64bit inode files / dies and convert
> them back to 32bit without a reinstall?

On IRIX you could use xfs_reno to renumber those inodes.
http://techpubs.sgi.com/library/tpl/cgi-bin/getdoc.cgi?coll=0650&db=man&fname=/usr/share/catman/a_man/cat1/xfs_reno.z

xfs_reno was ported to linux in '07 and was most recently reposted by Jeff Liu:
http://oss.sgi.com/archives/xfs/2012-11/msg00425.html

It isn't in xfsprogs today.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
