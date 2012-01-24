Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0OIB04H061567 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 12:11:00 -0600
Received: from mail-ee0-f53.google.com (mail-ee0-f53.google.com
	[74.125.83.53]) by cuda.sgi.com with ESMTP id vftIz6PFfOvYha7T
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 24 Jan 2012 10:10:59 -0800 (PST)
Received: by eeke51 with SMTP id e51so2355078eek.26
	for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 10:10:58 -0800 (PST)
Subject: Re: How to fix bad superblock or xfs_repair: error - read only 0 of
	512 bytes
Mime-Version: 1.0 (Apple Message framework v1251.1)
From: Christian Kildau <lists@unixhosts.org>
In-Reply-To: <1327425931.24535.610.camel@montana.filmlight.ltd.uk>
Date: Tue, 24 Jan 2012 19:10:51 +0100
Message-Id: <FFA8AC28-4E60-4E6C-B445-E7F8E6502193@unixhosts.org>
References: <CALx8gnT9tdPRGfVR0puoSVYz_MDDs4FtWtodST5x29GDnL3A_w@mail.gmail.com>
	<20120123043117.GH15102@dastard>
	<92CDAC52-1BA1-43A8-8470-0E2DCD916610@unixhosts.org>
	<4F1E3BD0.7080604@sandeen.net>
	<B1F1FDAB-0D48-48FE-8FFC-F0567780E052@unixhosts.org>
	<1327414341.24535.582.camel@montana.filmlight.ltd.uk>
	<4D396236-D516-4948-8F43-1AED88539BC4@unixhosts.org>
	<4F1ED341.4010108@sandeen.net>
	<BE48F258-7061-468F-865E-3595D2C28B3B@unixhosts.org>
	<4F1ED4DF.40907@sandeen.net>
	<1327425931.24535.610.camel@montana.filmlight.ltd.uk>
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
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Jan 24, 2012, at 6:25 PM, Roger Willcocks wrote:

> 
> On Tue, 2012-01-24 at 09:57 -0600, Eric Sandeen wrote:
>> On 1/24/12 9:52 AM, Christian Kildau wrote:
>>> On Jan 24, 2012, at 4:50 PM, Eric Sandeen wrote:
>>> 
> ...
>>>> Can you run the hdparm command Roger suggested on your original hard drive, please?
>>> 
>>> Sure, here it is:
>>> 
>>> /dev/sde:
>>> max sectors   = 2930275055/2930277168, HPA is enabled
>>                                          ^^^^^^^^^^^^^^
>> 
>> ding ding ding, we have a winner.
>> 
>> 2930277168-2930275055 = 2113 which is about how much xfs tried to read past the end.
>> 
>> Something about the ubuntu upgrade messed with your disk.
>> 
>> I'd press them very hard to investigate & resolve that.  You can probably use hdparm
>> to remove the HPA and get your space back but this is beyond my expertise &
>> familiarity.  It'd be interesting to know what is _in_ the HPA area first.
>> 
> 
> Kernel commit d8d9129ea28e2177749627c82962feb26e8d11e9 added code to
> notice if a disk partition extends into the hidden area and 'unlocks'
> the hidden area (uses the full disk capacity) if necessary.
> 
> But if there's no partition table (the entire disk is formatted as a
> single filesystem) the heuristic can't work.
> 
> http://www.spinics.net/lists/linux-ide/msg40244.html suggests that
> Ubuntu no longer always unlocks, but uses the heuristic above. In the
> same message Alan Cox says Ubuntu 'made a bad mistake on that one.'
> 
> -- 
> Roger Willcocks <roger@filmlight.ltd.uk>
> 



Good to know! Made me choose another OS for the next servers!

Thanks
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
