Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBDBiEUo026076 for <xfs@oss.sgi.com>; Sat, 13 Dec 2008 05:44:14 -0600
Received: from einhorn.in-berlin.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 536621AB82
	for <xfs@oss.sgi.com>; Sat, 13 Dec 2008 03:44:11 -0800 (PST)
Received: from einhorn.in-berlin.de (einhorn.in-berlin.de [192.109.42.8]) by
	cuda.sgi.com with ESMTP id BauBR6dq9ws9OSDp for
	<xfs@oss.sgi.com>; Sat, 13 Dec 2008 03:44:11 -0800 (PST)
Message-ID: <49439FF9.50202@s5r6.in-berlin.de>
Date: Sat, 13 Dec 2008 12:43:53 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
Subject: Re: Intel X25-E running Linux using XFS
References: <alpine.DEB.1.10.0811271257470.2233@p34.internal.lan>
	<20081212185803.GE11974@elf.ucw.cz>
	<alpine.DEB.1.10.0812121516190.17857@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0812121516190.17857@p34.internal.lan>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: smartmontools-support@lists.sourceforge.net, smartmontools-database-owner@lists.sourceforge.net, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, Pavel Machek <pavel@suse.cz>, Alan Piszcz <ap@solarrain.com>

Justin Piszcz wrote:
> On Fri, 12 Dec 2008, Pavel Machek wrote:
>> Actually I'd like to know... how does it behave during powerfails
>> while it is being written to?
>>
>> Flashes I seen (USB / SD) developed bad sectors in that case, and
>> ext2/ext3 can't handle that. (And I don't think xfs can handle that
>> either).
> 
> I have a UPS for all of my machines, so that will not be a problem in my
> case.

UPSs fail too.

...
> With barriers, presumably it would be safe

There are other opinions:  http://lwn.net/Articles/309576/
(Magnetic disks are discussed there.)
-- 
Stefan Richter
-=====-==--- ==-- -==-=
http://arcgraph.de/sr/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
