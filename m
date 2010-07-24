Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6OL42Lp022575 for <xfs@oss.sgi.com>; Sat, 24 Jul 2010 16:04:02 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5777C46F43B
	for <xfs@oss.sgi.com>; Sat, 24 Jul 2010 14:07:04 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id Dwk1fOVKlwfodtR2 for
	<xfs@oss.sgi.com>; Sat, 24 Jul 2010 14:07:04 -0700 (PDT)
Message-ID: <4C4B55F7.2090501@sandeen.net>
Date: Sat, 24 Jul 2010 16:07:03 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 4k sector drives
References: <201007211333.48363.eye.of.the.8eholder@gmail.com>	<201007230809.28111@zmi.at>
	<20100723095832.GA23174@infradead.org>	<201007231259.11714@zmi.at>
	<20100724084751.GA32006@infradead.org>
In-Reply-To: <20100724084751.GA32006@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Fri, Jul 23, 2010 at 12:59:07PM +0200, Michael Monnerie wrote:
>> On Freitag, 23. Juli 2010 Christoph Hellwig wrote:
>>> -b size=4096 is the default anyway, for 4k sector drivers you also
>>>  want -s size=4096, which you do not want for 512 byte sector disks.
>> Thanks for clarification. Should I use "-s size=4096" despite the drive 
>> saying 512b sectors? It's a "hidden" 4K sector drive, so maybe declaring 
>> it extra for XFS helps performance? Or does it not matter at all?
> 
> If it really is one using -s size=4096 is the right thing to do.

Haven't read the whole thread so maybe this is redundant, but make
sure all partitions (if any) are 4k aligned as well (unless it has
the secret-handshake sector 63 offset...)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
