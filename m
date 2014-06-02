Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 359CC7F56
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 09:56:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 250AF8F8071
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 07:56:01 -0700 (PDT)
Received: from mail.zytor.com ([198.137.202.10]) by cuda.sgi.com with ESMTP id
	lp9UPK9dftaR7zZC (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Jun 2014 07:56:00 -0700 (PDT)
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20140602115737.GB14276@thunk.org>
Date: Mon, 2 Jun 2014 07:52:47 -0700
Message-Id: <A37F9FD2-DD07-4EB0-A94B-C22141715911@zytor.com>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<8618458.1EVJCoVbkH@wuerfel>
	<alpine.LFD.2.11.1406012121430.17310@knanqh.ubzr>
	<4178301.j9kWdGCRLC@wuerfel> <20140602115737.GB14276@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "hch@infradead.org" <hch@infradead.org>, "john.stultz@linaro.org" <john.stultz@linaro.org>, "lftan@altera.com" <lftan@altera.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "geert@linux-m68k.org" <geert@linux-m68k.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "joseph@codesourcery.com" <joseph@codesourcery.com>


> On Jun 2, 2014, at 4:57, "Theodore Ts'o" <tytso@mit.edu> wrote:
> 
>> On Mon, Jun 02, 2014 at 12:56:42PM +0200, Arnd Bergmann wrote:
>> 
>> I think you misunderstood what I suggested: the intent is to avoid
>> seeing things break in 2038 by making them break much earlier. We have
>> a solution for ext2 file systems, it's called ext4, and we just need
>> to ensure that everybody knows they have to migrate eventually.
>> 
>> At some point before the mid 2030ies, you should no longer be able to
>> build a kernel that has support for ext2 or any other module that will
>> run into bugs later....
> 
> Even for ext4, it's not quite so simple as that.  You only have
> support for times post 2038 if you are using an inode size > 128
> bytes.  There are a very, very large number of machines which even
> today, are using 128 byte inodes with ext4 for performance reasons.
> 
> The vast majority of those machines which I know of can probably move
> to 256 byte inodes relatively easily, since hard drive replacement
> cycles are order 5-6 years tops, so I'm not that concerned, but it
> just goes to show this is a very complicated problem.
> 
> And even if we're talking about flash and embedded devices, the good
> news is if you assume that 10 years is enough time for people to
> update their embedded OS builds, and that the vast majority of
> deployed devices will probably only be in service for 10-15 years, we
> do have enough time to make file system format changes, although
> admittedly we can't afford to dilly-dally.

I have a number of file systems older than any device they are sitting on.  RAID allows individual disks to be swapped out, and when all disks have been swapped out, extend the file system online.  The system doesn't even have to be taken offline in the process if it is possible to physically get to the drives with the system powered (e.g. hot plug bays), which is really damned nice.
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
