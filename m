Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6C73C7F4E
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2014 03:45:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 04160AC006
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2014 01:45:04 -0700 (PDT)
Received: from mwork.nabble.com (static.162.253.133.43.macminivault.com
	[162.253.133.43]) by cuda.sgi.com with ESMTP id
	GkwYrFZvsJ1X9pwn for <xfs@oss.sgi.com>;
	Sun, 12 Oct 2014 01:45:03 -0700 (PDT)
Received: from mtom.nabble.com (unknown [162.253.133.81])
	by mwork.nabble.com (Postfix) with ESMTP id 0E3D877227A
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2014 01:45:04 -0700 (PDT)
Date: Sun, 12 Oct 2014 01:43:28 -0700 (MST)
From: tommason <tom_in_canada@hotmail.com>
Message-ID: <1413103408756-35026.post@n7.nabble.com>
Subject: Mount: Structure needs cleaning
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

First up - my knowledge of linux is pretty sparse - I've used it a few times
before, so please be gentle!

I've had a neil poulton network space for some time now - it freaked out a
while ago and I managed to rig it up to a Ubuntu liveCD via a SATA dock and
rescue the files.

This has now happened again - the drive would not get out of a cycle and was
not spinning properly. Bring out the dock and liveCD (this time Knoppix).
All good. This time however as I eagerly copied files to another drive (a
USB powered lacie rugged thing) and left it overnight i woke up to an error.
I was copying around 500GB in a few diffferent chunks. The first error it
reported was I think error 15? mount structure needs cleaning...

I then tried with a Ubuntu liveCD - same error. This is maybe where I made a
bit of an error of my own. In an attempt to shake it out of it's stupor I
'stupidly' plugged it into windows and opened up the disk utility (sorry I'm
generally mac based) and deleted in total 5 partitions (3x8mb, 1x250odd mb &
1x600mbish partition) This left the partition that I assumed contained all
my files: a 920GB partition. Tried to look at it again on Linux & (both
Knoppix & Ubuntu) and the error message had changed slightly. It now reads:
"Error mounting /dev/sdc2 at
/media/ubuntu/e8b90eb2-8718-4964-939d-8a2b899b68bd: Command-line `mount -t
"xfs" -o "uhelper=udisks2,nodev,nosuid" "/dev/sdc2"
"/media/ubuntu/e8b90eb2-8718-4964-939d-8a2b899b68bd"' exited with non-zero
exit status 32: mount: Structure needs cleaning"

This drive has all my audio and video stored on it! Any help to move me
toward a solution would be much appreciated!

Thanks for your time...

Tom 



--
View this message in context: http://xfs.9218.n7.nabble.com/Mount-Structure-needs-cleaning-tp35026.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
