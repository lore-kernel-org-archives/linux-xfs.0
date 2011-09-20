Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KHa2u0073356 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 12:36:02 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 074AF1C28BD2
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 10:36:00 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id WYtQVBRfrMQDIon8
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 10:36:00 -0700 (PDT)
Message-ID: <4E78CEFD.9030603@profihost.ag>
Date: Tue, 20 Sep 2011 19:35:57 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: xfs deadlock in stable kernel 3.0.4
References: <4E6EF274.7050007@profihost.ag>
	<20110913205018.GA8543@infradead.org>
	<4E70571A.80108@profihost.ag> <4E705C42.6020909@profihost.ag>
	<20110914143005.GA28496@infradead.org>
	<4E75B660.1030502@profihost.ag> <20110918230245.GF15688@dastard>
	<4E78665E.8030409@profihost.ag>
	<20110920160226.GA25542@infradead.org>
	<4E78CBF4.1030505@profihost.ag>
	<20110920172455.GA30757@infradead.org>
In-Reply-To: <20110920172455.GA30757@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, aelder@sgi.com

Am 20.09.2011 19:24, schrieb Christoph Hellwig:
> On Tue, Sep 20, 2011 at 07:23:00PM +0200, Stefan Priebe - Profihost AG wrote:
>>>   - what is the fs geometry?
>> What do you exactly mean? I've seen this on 1TB and 160GB SSD
>> devices with totally different disk layout.
>
> The output of mkfs.xfs (of xfs_info after it's been created)

ssd:~# xfs_info /dev/sda3
meta-data=/dev/root              isize=256    agcount=4, agsize=9517888 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=38071552, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=18589, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


> I'll run tests on a system with a pci-e flash device today.  Just to
> make sure we are on the same page, can you give me your kernel .config
> in addition to the mkfs output above?

OK i hope you can reproduce it as well.

.config
http://pastebin.com/raw.php?i=m8AAFJ1B

I also found out that i was not able to reproduce it under a freshly new 
created xfs part. I needed to copy a bunch of files delete some create 
some new and then start the test. I just duplicated multiple times the 
root filesystem and then deleted some, created some hardlinks whatever...

Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
