Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2D4617F4E
	for <xfs@oss.sgi.com>; Tue, 19 Feb 2013 13:11:18 -0600 (CST)
Date: Tue, 19 Feb 2013 13:11:14 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: 32bit apps and inode64
Message-ID: <20130219191114.GZ30652@sgi.com>
References: <4FA76E11.1070708@profihost.ag> <20120507071713.GZ5091@dastard>
	<4FA77842.5010703@profihost.ag>
	<4FA7FA14.6080700@hardwarefreak.com>
	<4FA82B07.1020102@profihost.ag>
	<4FAA153D.1030606@hardwarefreak.com>
	<20120509070450.GP5091@dastard> <511E4F00.2010703@profihost.ag>
	<20130215214653.GP22182@sgi.com> <51209128.6020901@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51209128.6020901@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Stefan Priebe - Profihost AG <s.priebe@profihost.ag>

Hey Jeff,

On Sun, Feb 17, 2013 at 04:13:28PM +0800, Jeff Liu wrote:
> Hi Ben,
> 
> On 02/16/2013 05:46 AM, Ben Myers wrote:
> > Hi Stefan,
> > 
> > On Fri, Feb 15, 2013 at 04:06:40PM +0100, Stefan Priebe - Profihost AG wrote:
> >> i've discovered some problems on a host with a disk > 1TB. We've some
> >> binary 32bit applications which are not able to read some directory
> >> anymore after we've formated and installed the system using vanilla
> >> 3.7.7 kernel.
> >>
> >> Right now we're using 3.0.61 kernel on this host - so 64bit apps work
> >> well and newly created files get 32bit inode numbers as inode64 is not
> >> the default.
> >>
> >> Is there a way to find / get all 64bit inode files / dies and convert
> >> them back to 32bit without a reinstall?
> > 
> > On IRIX you could use xfs_reno to renumber those inodes.
> > http://techpubs.sgi.com/library/tpl/cgi-bin/getdoc.cgi?coll=0650&db=man&fname=/usr/share/catman/a_man/cat1/xfs_reno.z
> > 
> > xfs_reno was ported to linux in '07 and was most recently reposted by Jeff Liu:
> > http://oss.sgi.com/archives/xfs/2012-11/msg00425.html
> The old patch set was belong to the infrastructures of online shrinking
> support.  Recently, I realized that I have made a few mistakes in swap
> inodes ioctl(2) implementation when I revisit the old patch set at:
> http://oss.sgi.com/archives/xfs/2012-11/msg00414.html
> 
> Since we have user request and this function is independent to the
> shrinking feature, I'd like to work on it at first if you like it.

That sounds good to me.  xfs_reno is a worthwhile feature.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
