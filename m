Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6RKxBTo209000 for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 15:59:11 -0500
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ADCBD11A2364
	for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 14:09:37 -0700 (PDT)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id JD0h1AZb9wlVbGgk for
	<xfs@oss.sgi.com>; Tue, 27 Jul 2010 14:09:37 -0700 (PDT)
Date: Tue, 27 Jul 2010 23:02:04 +0200
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: High latencies writing to a memory mapped file
Message-ID: <20100727210204.GA14184@citd.de>
References: <20100722144706.GA2840@BohrerMBP.rgmadvisors.com>
	<20100727092452.GA23307@citd.de>
	<4C4EDEFD.7000401@hardwarefreak.com>
	<20100727144914.GA29349@citd.de>
	<F57F2AD357626644AF76410876025D75529604@CGYEX705.encana.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <F57F2AD357626644AF76410876025D75529604@CGYEX705.encana.com>
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
To: "Kinzel, David" <David.Kinzel@encana.com>
Cc: xfs@oss.sgi.com

On 27.07.2010 13:59, Kinzel, David wrote:
> >> Matthias Schniedermeyer put forth on 7/27/2010 4:24 AM:
> >> 
> >> > We have a linux-computer with samba to act as a fileserver 
> >for a few 
> >> > Windows-Clients and ever since kernel 2.6.26 (Never 
> >happend with 2.6.25) 
> >> > the server randomly "hangs" for a few seconds (Which is more of a 
> >> > problem that drives people crazy).
> >> 
> 
> The server hangs, or the connections to samba do? I've found that samba

That's a question i actually hadn't though about. This certainly extends 
the circle of possible culprits a little. From the top of my mind thats 
the the NIC (Intel e100) and it's e100-driver and the (As Cheap as 
possible) 24-port 100MBit-Switch used to connect all computers. And last 
but not least the whole TCP/IP network-stack in the kernel.

This also differentiates "our" server to the mentioned "copy" which uses 
whichever GBit-NIC that was onboard (Something from Realtek AFAIR) to 
the a tree of even cheaper 5 and 8 port switches, not to mention 
on-the-fly-wiring.

> is given a ridiculously low IO priority so that any IO on the server
> will pretty much cause it to stall -- be it updating locate, a backup
> job, etc. 

Whatever the culprit is, in our case it's something that changed between 
2.6.25 and 2.6.26, before 2.6.26 we were happy with whatever was current 
for years. (System is running a reguarly updated Debian SID for at least 
6-7 years)

And the most irritating things is the "a reboot fixes it". When the 
problem reared it's head, you can restart samba, drop all caches, 
umount/decompose the RAID and whatnot, the problem immediatly reappears
after you get back to working conditions.




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
