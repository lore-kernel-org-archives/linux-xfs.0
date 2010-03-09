Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o29LeLcj199699 for <xfs@oss.sgi.com>; Tue, 9 Mar 2010 15:40:22 -0600
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 824A422A0BA
	for <xfs@oss.sgi.com>; Tue,  9 Mar 2010 13:41:52 -0800 (PST)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id Sk660YWW1soZECUH for
	<xfs@oss.sgi.com>; Tue, 09 Mar 2010 13:41:52 -0800 (PST)
Date: Tue, 9 Mar 2010 22:41:31 +0100
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: What are the correct mkfs.xfs parameters for a lying WD-EARS HDD?
Message-ID: <20100309214131.GA30233@citd.de>
References: <20100308221044.GA17830@citd.de> <4B957E03.9090000@sandeen.net>
	<20100308234755.GA20269@citd.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100308234755.GA20269@citd.de>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 09.03.2010 00:47, Matthias Schniedermeyer wrote:
> On 08.03.2010 16:45, Eric Sandeen wrote:
> > Matthias Schniedermeyer wrote:
> > > Hi
> > > 
> > > 
> > > More than a month ago i bought 4 Western Digital WD15EARS (1.5 TB) which 
> > > are (AFAIK) the first general/commercial available 4k sector SATA-HDDs.
> > > 
> > > Unfortunatly the HDDs lie about the 4k physical sector size and the most 
> > > prominent drawback is a worse than abysmal delete performance.
> > > ("Normal" Read & Write-performance is OK)
> > > 
> > > So if i wanted to (re-)mkfs the filesystems what would the correct 
> > > parameters be?
> > 
> > once that is done, tell mkfs.xfs "-s size=4096" to set the 4k sector size
> 
> So that should be enough?
> Time for backup/mkfs/restore then.

backup/mkfs/restore is finished.

I'm currently testing delete-performance.
And it improved to abysmal performance. (As expected)

Read-latency, while deleting, has also improved drastically. Before the 
FS was near unusable while deleting. But that is also to be expected 
from such a HDD when it is doing RMW like there is no tomorrow. ;-)






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
