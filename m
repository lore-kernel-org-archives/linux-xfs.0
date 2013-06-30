Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C03B329DF8
	for <xfs@oss.sgi.com>; Sun, 30 Jun 2013 16:42:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AF70A8F8035
	for <xfs@oss.sgi.com>; Sun, 30 Jun 2013 14:42:11 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 5F2nyiFWIOkjZnmi
	for <xfs@oss.sgi.com>; Sun, 30 Jun 2013 14:42:11 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id BB3826C054
	for <xfs@oss.sgi.com>; Sun, 30 Jun 2013 16:42:10 -0500 (CDT)
Message-ID: <51D0A62E.2020309@hardwarefreak.com>
Date: Sun, 30 Jun 2013 16:42:06 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: swidth in RAID
References: <557F888F-34EA-4669-B861-C0B684DAD13D@gmail.com>
In-Reply-To: <557F888F-34EA-4669-B861-C0B684DAD13D@gmail.com>
Reply-To: stan@hardwarefreak.com
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

On 6/30/2013 1:43 PM, aurfalien wrote:

> I understand swidth should = #data disks.

No.  "swidth" is a byte value specifying the number of 512 byte blocks
in the data stripe.

"sw" is #data disks.

> And the docs say for RAID 6 of 8 disks, that means 6.
> 
> But parity is distributed and you actually have 8 disks/spindles working for you and a bit of parity on each.
> 
> So shouldn't swidth equal disks in raid when its concerning distributed parity raid?

No.  Lets try visual aids.

Set 8 coffee cups (disk drives) on a table.  Grab a bag of m&m's.
Separate 24 blues (data) and 8 reds (parity).

Drop a blue m&m in cups 1-6 and a red into 7-8.  You just wrote one RAID
stripe.  Now drop a blue into cups 3-8 and a red in 1-2.  Your second
write, this time rotating two cups (drives) to the right.  Now drop
blues into 5-2 and reds into 3-4.  You've written your third stripe,
rotating by two cups (disks) again.

This is pretty much how RAID6 works.  Each time we wrote we dropped 8
m&m's into 8 cups, 6 blue (data chunks) and 2 red (parity chunks).
Every RAID stripe you write will be constructed of 6 blues and 2 reds.
XFS, or EXT4, or any filesystem, can only drop blues into the first 6
cups of a stripe.  The RAID adds the two reds to every stripe.

Maybe now you understand why sw=6 for an 8 drive RAID6.  And now maybe
you understand what "distributed parity" actually means--every stripe is
shifted, not just the parity chunks.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
