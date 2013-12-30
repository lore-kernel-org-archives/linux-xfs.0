Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9D5597F3F
	for <xfs@oss.sgi.com>; Mon, 30 Dec 2013 05:27:54 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 24E00AC003
	for <xfs@oss.sgi.com>; Mon, 30 Dec 2013 03:27:54 -0800 (PST)
Received: from awesome.dsw2k3.info (awesome.dsw2k3.info [217.188.63.246]) by
	cuda.sgi.com with ESMTP id gqSlnyzDhj1ipBd6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 30 Dec 2013 03:27:48 -0800 (PST)
Date: Mon, 30 Dec 2013 12:27:43 +0100
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: [xfs_check Out of memory: ]
Message-ID: <20131230112743.GA16889@citd.de>
References: <tencent_3F12563342ED1D4E049D1123@qq.com>
	<201312270907.22638.arekm@maven.pl>
	<20131227224212.GK20579@dastard>
	<201312280020.39244.arekm@maven.pl>
	<20131229095033.GL20579@dastard>
	<52C0D281.7040704@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52C0D281.7040704@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Stor?? <289471341@qq.com>, Jeff Liu <jeff.liu@oracle.com>, xfs@oss.sgi.com

On 29.12.2013 19:55, Stan Hoeppner wrote:
> On 12/29/2013 3:50 AM, Dave Chinner wrote:
> ...
> > I think you are forgetting that developer time is *expensive* and
> > *scarce*. This is essentially a solved problem: An SSD in a USB3
> > enclosure as a temporary swap device is by far the most cost
> > effective way to make repair scale to arbitrary amounts of metadata.
> > It certainly scales far better than developer time and testing
> > resources...
> 
> Now this is an interesting idea Dave.  I hadn't considered temporary
> swap.  Would USB be reliable enough for this?  I've seen lots problem
> reports with folks using USB storage with Linux, random disconnections
> and what not.

It's certainly a problem with several variables.
- Quality of USB-Stack (should be quite good nowadays, but there can 
always be (new) bugs)
- Quality of SATA <-> USB(3) Chip
- Quality of SSD itself

And with Quality i mean everything from physical chip up to firmware.

I'm not quite sure what happens when SWAP crapps out. I think it can be 
everything from "machine goes dead" down to "all programs with pages in 
swap are terminated".

I've transfert quite a few TB over USB3 and i can say, it mostly works. 
But random disconnects happen and you can't really be sure which part is 
the problem as it only happens rarely.

For e.g. currently i have a HDD that randomly but seldomly craps out in 
an USB3 enclosure, after coping a few hundert GB. The drive works 
flawlessly when connected directly by SATA to a (different) computer, at 
least i haven't had a failure after i moved the drive. Is it the drive, 
chip in enclose, firmware between HDD & enclosure not playing nice (like 
too high command timeouts on HDD side and too low on enclosure-sde), 
USB3 stack. Can't really tell.

So:
I would consides SWAP on a device connected via USB3 to be on the risky 
side.

I would validate beforehand if that specific combination of 
xhci/enclosure chip/SSD survies a prolonged time of "high I/O stress".
Like several days of full bandwidth/random I/O.




-- 

Matthias

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
