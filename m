Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3D6X70w199949 for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 01:33:07 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6DB1C126E4E2
	for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 23:35:00 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id md5bnAz0gugglOfT
	for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 23:35:00 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 7DE586C306
	for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 01:35:00 -0500 (CDT)
Message-ID: <4BC41094.7000301@hardwarefreak.com>
Date: Tue, 13 Apr 2010 01:35:00 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: [PATCH] enable inode64 by default when possible
References: <4B7309D7.5090800@sandeen.net>
	<1270850499.7840.25.camel@doink>	<4BBFE478.3090901@hardwarefreak.com>
	<20100412062158.GF2493@dastard>
In-Reply-To: <20100412062158.GF2493@dastard>
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

Dave Chinner put forth on 4/12/2010 1:21 AM:

>> Intel Atom (32bit x86) CPUs
> 
> No, I think Atom is 64 bit.
> 
> /me checks his mailserver
> 
> Yup, it's running a 64 bit kernel and 64 bit userspace. No 32 bit
> issues there....

Nice setup Dave.  I've thought about converting my vanity server to an Atom
330 64 bit dual core microATX board.  Haven't got around to it yet.  A
little over $100 USD sent to Newegg and a bit of time is all it would take.
 With summer fast approaching I may just take the plunge to lower the heat
generation in the home office.  My current old dual proc Intel server expels
about 80-100 watts aggregate continuous at idle.  With the Atom that should
drop to well less than 30 (even more if I splurge for a new more efficient PSU).

Something maybe worthy of note:  only 5 of the 19 Atom processors are 64
bit.  The remaining 14 are 32 bit only.  Hope the link doesn't get horribly
mangled.  If it does just go to the Atom product page, click the select all
button and then compare.  That'll get you the same chart I'm looking at.

http://ark.intel.com/Compare.aspx?ids=46467,35635,35641,43517,43098,36331,41411,42503,35472,35469,41175,41176,40740,35466,41174,35463,41173,35460,40741,

I don't know how many of each Atom model have been sold, but I think it's
safe to assume there are a lot of the 32 bit only Atom CPUs in the wild.
I'll concede that probably not many such systems are running XFS, probably
just a few geeks like us.  Then again, I don't know the retail DVR market at
all, or if any units use the 32 bit Atom chips.  I would think XFS would be
a natural choice for DVR duty though.

Anyway, this may be a total non issue, but I just wanted to point out that
there are definitely some corner cases of 32 bit Atom with big XFS
filesystems in DIY DVRs/HTPCs, as well as maybe some other applications.

I'll still be 32 bit for a while on the vanity server, but my XFS
filesystems are all less than 250GB, so I'm assuming I should be safe from
inodes over 32 bits.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
