Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAQEJIsK062051 for <xfs@oss.sgi.com>; Thu, 26 Nov 2009 08:19:18 -0600
Received: from galiil.marvell.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 13A301BB971B
	for <xfs@oss.sgi.com>; Thu, 26 Nov 2009 06:19:42 -0800 (PST)
Received: from galiil.marvell.com (galiil.marvell.com [199.203.130.254]) by
	cuda.sgi.com with ESMTP id tU2YzIJ2QU8khbr6 for
	<xfs@oss.sgi.com>; Thu, 26 Nov 2009 06:19:42 -0800 (PST)
From: Ofer Heifetz <oferh@marvell.com>
Date: Thu, 26 Nov 2009 16:19:39 +0200
Subject: RE: XFS support for ARMv5
Message-ID: <EE71107DF0D1F24FA2D95041E64AB9E8985A59F895@IL-MB01.marvell.com>
References: <14274282.01258546868484.JavaMail.root@wombat>
	<4B041AEE.4040506@sandeen.net>
	<EE71107DF0D1F24FA2D95041E64AB9E8985A59F17F@IL-MB01.marvell.com>
	<4B096C6E.8010508@sandeen.net>
	<EE71107DF0D1F24FA2D95041E64AB9E8985A59F31F@IL-MB01.marvell.com>
	<alpine.DEB.2.00.0911251025490.28890@andydesk>
	<20091125210611.GA12150@infradead.org>
In-Reply-To: <20091125210611.GA12150@infradead.org>
Content-Language: en-US
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
To: Christoph Hellwig <hch@infradead.org>, Andy Poling <andy@realbig.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Christoph,

I applied the patches to 2.6.31.6 and the mount passes file. I copied some data to the XFS DOK and had no problem reading the content after several system reset.

Here is a dmesg snippet:

SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
XFS mounting filesystem sda3
Starting XFS recovery on filesystem: sda3 (logdev: internal)
Ending XFS recovery on filesystem: sda3 (logdev: internal)

Is this patch confirmed to be mainlined in 2.6.33?
I need to know `cos I want to run some data integrity and performance tests on this patch before I merge it.

-Ofer
-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Wednesday, November 25, 2009 11:06 PM
To: Andy Poling
Cc: Ofer Heifetz; xfs@oss.sgi.com
Subject: Re: XFS support for ARMv5

On Wed, Nov 25, 2009 at 10:30:09AM -0600, Andy Poling wrote:
> On Mon, 23 Nov 2009, Ofer Heifetz wrote:
>> Here is the dmesg I got for mount /dev/sda3 /mnt/usb:
>> SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
>> XFS mounting filesystem sda3
>> Starting XFS recovery on filesystem: sda3 (logdev: internal)
>> XFS: xlog_recover_process_data: bad clientid
>> XFS: log mount/recovery failed: error 5
>> XFS: log mount failed
>
> See this thread in the archives for a patch that may fix this:
>
> 	http://oss.sgi.com/pipermail/xfs/2009-October/042805.html

I don't think it's the case you found, although the symptoms are the
same.  I'd rather guess this is a case of an architecture with virtually
indexed caches (can anyone confirm the cache architecture?) which
doesn't cope too well with the way we use vmap to write into a buffer
through virtually mapped linear addresses, but then do block I/O using
the physical addresses of the individual pages.  James Bottomley has a
patchset to fix this issue by introducing APIs that allow the
architecture specific memory management to cope with it.  He're a
version I could quickly find, although newer ones have been posted
since:

	http://thread.gmane.org/gmane.linux.kernel.cross-arch/4364

The patchset is planned to get merged into Linux 2.6.33.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
