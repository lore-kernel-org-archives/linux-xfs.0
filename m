Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q720CluB091874 for <xfs@oss.sgi.com>; Wed, 1 Aug 2012 19:12:47 -0500
Received: from pavilion.ashurst.eu.org (pavilion.ashurst.eu.org
	[85.119.82.45]) by cuda.sgi.com with ESMTP id Wph9vdq5KiPMyDIy
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 01 Aug 2012 17:12:45 -0700 (PDT)
Received: from 79.70.112.87.dyn.plus.net ([87.112.70.79] helo=[192.168.1.155])
	by pavilion.ashurst.eu.org with esmtpsa
	(TLS1.0:RSA_AES_256_CBC_SHA1:32) (Exim 4.72)
	(envelope-from <andyjpb@ashurst.eu.org>) id 1Swj1u-0004rG-K2
	for xfs@oss.sgi.com; Thu, 02 Aug 2012 01:12:44 +0100
Message-ID: <5019C5F9.1080302@ashurst.eu.org>
Date: Thu, 02 Aug 2012 01:12:41 +0100
From: Andy Bennett <andyjpb@ashurst.eu.org>
MIME-Version: 1.0
Subject: XFS Recovery Behaviour
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

Hi,

This post isn't going to be too detailed as I ended up in a recovery
situation and was focused on checking the integrity of my files rather
than recording every step as I went.

I thought it was worth reporting as the file system seemed to recover in
an odd way.

I am not expecting any assistance as I was able to recover all my data.



I am using an XFS partition for storing my digital camera photos. I have
2 cards, card-1 and card-2. On any day when I injest the contents of the
cards I make directories import-YYYY-MM-DD/card-{1,2}/
I have a script that creates the directories and performs the injesting.

I had previously (2012/07/04) injested import-2012-07-04/card-1/

On 2012-07-28 I went into import-2012-07-04/ and created a thumbnail
gallery with my thumbnail script. This involved creating a directory
import-2012-07-05/gal-card-1 and populating it with files. The directory
entry for import-2012-07-04 was now dirty.

Simultaneously, I began a fresh injest session into
import-2012-07-28/card-2/.

Whilst these two jobs were running I suffered a hard power failure as I
unplugged the thing (it's a laptop) not realising that my battery was
flat. :-(

When I rebooted I noticed that import-2012-07-04 was showing up somewhat
thusly in 'ls -la':
-----
?????????? ? ? ?   ?? ???  ? ??:?? import-2012-07-04
-----

I could not 'cd' into it nor could I 'cat' it.
I thought the directory was lost and resolved to restore it from backups
when I returned home.

I didn't pay much attention at the time to the contents of
import-2012-07-28/

Over the course of the day I injested a few more things into
import-2012-07-28/



When I returned home I looked into restoring the backups. To my
surprise, import-2012-07-04/ was showing up as a valid directory again.
Even more surprisingly it contained a (somewhat corrupt) card-2/
directory that should have been in import-2012-07-28/. It did not
contain the card-1/ directory.

There is anecdotal evidence that import-2012-07-28/card-2/ was no longer
present.

I recovered import-2012-07-04/card-1/ from an xfsdump.

I recovered import-2012-07-28/card-2/ because I hadn't gotten around to
verifying the injest so didn't format the card before I reused it. It
wasn't full so I added more shots to it and injested it again later in
the day.


Today, I deleted import-2012-07-04/card-2/ after much to-ing and
fro-ing. It was a subset of import-2012-07-28/card-2b/ (an injest of the
same card later in the day, albeit with extra files) and some of the
overlapping files were corrupt or empty in 2012-07-04/card-2/. (My
injest script records checksums and I used a visual verification of the
images I was concerned about.)
The corrupt & missing files were the ones towards the end of the injest:
they had high numbered filenames, so would have been the ones in flight
at the time of the power failure.



I'm running XFS on Debian Testing (Wheezy)

-----
$ dpkg -l |grep xfs | grep -v x11
ii  xfsdump     3.0.6    Administrative utilities for the XFS filesystem
ii  xfslibs-dev 3.1.7+b1 XFS filesystem-specific static libraries and
headers
ii  xfsprogs    3.1.7+b1 Utilities for managing the XFS filesystem
-----

-----
$ uname -a
Linux lago 3.2.0-3-amd64 #1 SMP Thu Jun 28 09:07:26 UTC 2012 x86_64
GNU/Linux
-----

I have "defaults" under "options" in /etc/fstab.

I'm using Debian defaults on a Lenovo Thinkpad X200 laptop.


I didn't expect to see the import-2012-07-04/ directory again and I
certainly didn't expect to see it populated with the card-2/ subdirectory.






Regards,
@ndy

-- 
andyjpb@ashurst.eu.org
http://www.ashurst.eu.org/
0x7EBA75FF

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
