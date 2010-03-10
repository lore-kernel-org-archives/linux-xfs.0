Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2A8PSNx026740 for <xfs@oss.sgi.com>; Wed, 10 Mar 2010 02:25:28 -0600
Received: from web76211.mail.sg1.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 65C4522B68D
	for <xfs@oss.sgi.com>; Wed, 10 Mar 2010 00:26:59 -0800 (PST)
Received: from web76211.mail.sg1.yahoo.com (web76211.mail.sg1.yahoo.com
	[124.108.115.150]) by cuda.sgi.com with SMTP id
	lUe34EUtePplygna for <xfs@oss.sgi.com>;
	Wed, 10 Mar 2010 00:26:59 -0800 (PST)
Message-ID: <286793.30706.qm@web76211.mail.sg1.yahoo.com>
Date: Wed, 10 Mar 2010 16:26:58 +0800 (SGT)
From: Gim Leong Chin <chingimleong@yahoo.com.sg>
Subject: Re: What are the correct mkfs.xfs parameters for a lying WD-EARS HDD?
In-Reply-To: <20100309214131.GA30233@citd.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>, Matthias Schniedermeyer <ms@citd.de>
Cc: xfs@oss.sgi.com

Hi,


You can use GPT fdisk (gdisk) to do the partitioning.  The author had the exact same problem with the performance of WD 4 kB sector drives.  The tool automatically sets the partition start and end at 4 kB boundaries.  You can in fact set the partition start and end at any sector you want.

It is the firmware in the WD drives that translates the physical 4 kB sector to 512 byte sectors.


GL

--- On Wed, 10/3/10, Matthias Schniedermeyer <ms@citd.de> wrote:

> From: Matthias Schniedermeyer <ms@citd.de>
> Subject: Re: What are the correct mkfs.xfs parameters for a lying WD-EARS HDD?
> To: "Eric Sandeen" <sandeen@sandeen.net>
> Cc: xfs@oss.sgi.com
> Date: Wednesday, 10 March, 2010, 5:41 AM
> On 09.03.2010 00:47, Matthias
> Schniedermeyer wrote:
> > On 08.03.2010 16:45, Eric Sandeen wrote:
> > > Matthias Schniedermeyer wrote:
> > > > Hi
> > > > 
> > > > 
> > > > More than a month ago i bought 4 Western
> Digital WD15EARS (1.5 TB) which 
> > > > are (AFAIK) the first general/commercial
> available 4k sector SATA-HDDs.
> > > > 
> > > > Unfortunatly the HDDs lie about the 4k
> physical sector size and the most 
> > > > prominent drawback is a worse than abysmal
> delete performance.
> > > > ("Normal" Read & Write-performance is
> OK)
> > > > 
> > > > So if i wanted to (re-)mkfs the filesystems
> what would the correct 
> > > > parameters be?
> > > 
> > > once that is done, tell mkfs.xfs "-s size=4096"
> to set the 4k sector size
> > 
> > So that should be enough?
> > Time for backup/mkfs/restore then.
> 
> backup/mkfs/restore is finished.
> 
> I'm currently testing delete-performance.
> And it improved to abysmal performance. (As expected)
> 
> Read-latency, while deleting, has also improved
> drastically. Before the 
> FS was near unusable while deleting. But that is also to be
> expected 
> from such a HDD when it is doing RMW like there is no
> tomorrow. ;-)
> 
> 
> 
> 
> 
> 
> Bis denn
> 
> -- 
> Real Programmers consider "what you see is what you get" to
> be just as 
> bad a concept in Text Editors as it is in women. No, the
> Real Programmer
> wants a "you asked for it, you got it" text editor --
> complicated, 
> cryptic, powerful, unforgiving, dangerous.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 


      New Email names for you! 
Get the Email name you&#39;ve always wanted on the new @ymail and @rocketmail. 
Hurry before someone else does!
http://mail.promotions.yahoo.com/newdomains/sg/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
