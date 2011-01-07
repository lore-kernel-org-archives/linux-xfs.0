Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0799NR5020869 for <xfs@oss.sgi.com>; Fri, 7 Jan 2011 03:09:24 -0600
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A6E21D15DE4
	for <xfs@oss.sgi.com>; Fri,  7 Jan 2011 01:11:33 -0800 (PST)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id cBAeCnccPin8nXIv for
	<xfs@oss.sgi.com>; Fri, 07 Jan 2011 01:11:33 -0800 (PST)
Date: Fri, 7 Jan 2011 10:11:20 +0100
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: TRIM details
Message-ID: <20110107091120.GA6634@citd.de>
References: <4D2686ED.7000304@philkarn.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D2686ED.7000304@philkarn.net>
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
To: karn@ka9q.net
Cc: xfs@oss.sgi.com

On 06.01.2011 19:22, Phil Karn wrote:
> Now that I've rebuilt my main Linux server, added a 120GB Intel SSD and
> converted all the file systems to XFS, I've gotten interested in the
> internals of both XFS and TRIM and how they work together (or will work
> together).
> 
> I'd like to know exactly how the drives implement TRIM but I've only
> found bits and pieces. Can anyone suggest a current and complete
> reference for the complete SATA command set that includes all the TRIM
> related stuff?
> 
> As I understand it, there's a SATA (and SCSI?) command that will
> repeatedly write a fixed block of data to some number of consecutive
> LBAs (WRITE SAME), and an "unmap" bit in the write command can be set to
> indicate that instead of actually writing the blocks, they can be marked
> for erasure and placed in the free pool.

I roughly know what happens in the SATA version.
The SATA command takes an sector-offset and a sector-count (up to 64k)

Spec is linked on the Wikipedia-page:
http://en.wikipedia.org/wiki/TRIM

> Is this the only way it can be done? It occurs to me that while an
> "unmap" bit should be quite fast, you don't absolutely *have* to have it.

"Quite fast" is something of an understatement.
The Intel SSD can TRIM the whole drive in a matter of seconds. I have 
tested that with hdparm, when i wrote me a simple disc imaging 
perl-script.

> Just have the drive interpret an ordinary write of all 0's to any LBA as
> an implicit "unmap" indication for that LBA. As long as the drive

The drive would have to look into each written sector in the off chance 
that it might be 0, that's a lot of electrons you have to burn for not 
much gain. And that's ignoring the performance side, doing such a check 
on each incoming write would be expensive at best.







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
