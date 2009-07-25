Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6P7Qf13184861 for <xfs@oss.sgi.com>; Sat, 25 Jul 2009 02:26:42 -0500
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4351A385652
	for <xfs@oss.sgi.com>; Sat, 25 Jul 2009 00:27:25 -0700 (PDT)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id t381EUI6PaVout2q for
	<xfs@oss.sgi.com>; Sat, 25 Jul 2009 00:27:25 -0700 (PDT)
Date: Sat, 25 Jul 2009 09:26:17 +0200
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: Using xfsdump On Linux With IRIX Version 1 FS?
Message-ID: <20090725072617.GA30450@citd.de>
References: <C68F8010.B953%elbles@sessys.com>
	<alpine.DEB.2.01.0907242048000.6426@bogon.housecafe.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.0907242048000.6426@bogon.housecafe.de>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: Sean Elble <elbles@sessys.com>, xfs@oss.sgi.com

On 24.07.2009 20:53, Christian Kujau wrote:
> On Fri, 24 Jul 2009 at 15:13, Sean Elble wrote:
> > Yeah, that's probably what I'll do then.  I figure the disk will thrash for
> > a while during the search for a string in /etc/shadow, but hopefully it'll
> 
> Instead of working on the (old, slow) disk, you could just work on the 
> backup (located on faster disk, I presume), maybe even set up a 
> blockdevice for it:
> 
>   # losetup -r /dev/loop0 /path/to/IRIXbackup
>   # hexedit /dev/loop0 ...or whatever tool you'll be using.

Which has what advantage over directly changing the image?

And the old disc may be slow, but the relative speed (Speed in relation 
to total capacity) is much better than modern discs. IOW it only takes 
minutes to read/write it completly.

Some month ago i backed up some old HDDs (biggest was 4GB), it nearly 
took longer to switch on/off the computer and change the HDDs, than the 
actual time to copy the HDDs.
Even with just 10MB/s it's less than 4 Minutes for 2GB.
In comparison it takes over 3 hours to copy a modern 1TB HDD @ 80MB/s.






Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
