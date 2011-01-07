Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p079FNpF021857 for <xfs@oss.sgi.com>; Fri, 7 Jan 2011 03:15:23 -0600
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3415C1D15E26
	for <xfs@oss.sgi.com>; Fri,  7 Jan 2011 01:17:32 -0800 (PST)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id 5vzJjJVycc07rQyI for
	<xfs@oss.sgi.com>; Fri, 07 Jan 2011 01:17:32 -0800 (PST)
Date: Fri, 7 Jan 2011 10:17:20 +0100
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: TRIM details
Message-ID: <20110107091720.GA6921@citd.de>
References: <4D2686ED.7000304@philkarn.net> <20110107091120.GA6634@citd.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110107091120.GA6634@citd.de>
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

On 07.01.2011 10:11, Matthias Schniedermeyer wrote:
> On 06.01.2011 19:22, Phil Karn wrote:
> 
> > Just have the drive interpret an ordinary write of all 0's to any LBA as
> > an implicit "unmap" indication for that LBA. As long as the drive
> 
> The drive would have to look into each written sector in the off chance 
> that it might be 0, that's a lot of electrons you have to burn for not 
> much gain. And that's ignoring the performance side, doing such a check 
> on each incoming write would be expensive at best.

Altough, after thinking about it a little more. Doing a Population count 
in the controller while the data comes in over the wire can't be that 
expensive.





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
