Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BD1CD7F37
	for <linux-xfs@oss.sgi.com>; Sun, 14 Jul 2013 05:04:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8EA578F8052
	for <linux-xfs@oss.sgi.com>; Sun, 14 Jul 2013 03:04:56 -0700 (PDT)
Received: from awesome.dsw2k3.info (awesome.dsw2k3.info [217.188.63.246]) by
	cuda.sgi.com with ESMTP id fCNgfOJOKj4XW9HB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for
	<linux-xfs@oss.sgi.com>; Sun, 14 Jul 2013 03:04:51 -0700 (PDT)
Date: Sun, 14 Jul 2013 12:04:44 +0200
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: XFS formatted partition is shown as 2TB but should be 3TB
Message-ID: <20130714100444.GA29583@citd.de>
References: <1373788650050-35001.post@n7.nabble.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1373788650050-35001.post@n7.nabble.com>
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
To: "c.monty" <c.monty@web.de>
Cc: linux-xfs@oss.sgi.com

On 14.07.2013 00:57, c.monty wrote:
> Hi!
> 
> On my new HDD WD30EZRX I created a GPT partition table and formatted it with
> XFS.
> Then I put some data (approx. 2.4TB) on that new partition.
> 
> However, after restarting the system the disk is identified of size 2TB
> only.
> /knoppix@Microknoppix:~$ sudo fdisk -l
> Disk /dev/sda: 2000.4 GB, 2000421444608 bytes

Kernel reports the disc as 2TB.

...

k> 
> My understanding of the issue is:
> 1. The HDD is not identified correctly by the mainboard/Bios with 3TB. This

BIOS isn't important for Linux (in that case). It just has to boot 
Linux, after that BIOS is out of the picture (for storage).

> is confirmed by the hardware vendor of my mainboard "Gigabyte P35-DS4",
> means the limit is 2.2TB

P35 sounds too old for me. AFAIR older Intel-Hardware has a problem with 
the 2TiB Barrier.

For the 2TiB-Barrier you need a recent system, something younger than 
about 2-3 years. Most hardware older can't cope with discs bigger than 
2^32 sectors.
> 
> How can I recover the data?
> Should I simply create a new partition table either with gdisk or parted?
> Can I make a low-level copy using dd starting from sector 2048 until the end
> to another HDD WD30EZRX (that I have available) and then mount that
> partition?
> Or are there any other options?

Just plug it into a more recent system, it should "just work".




-- 

Matthias

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
