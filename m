Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0FDE67F69
	for <xfs@oss.sgi.com>; Sat, 18 Jul 2015 13:13:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C21E28F804B
	for <xfs@oss.sgi.com>; Sat, 18 Jul 2015 11:13:05 -0700 (PDT)
Received: from mail02.lsn.net (mail02.lsn.net [66.90.130.128]) by cuda.sgi.com
	with ESMTP id 0UEihFFdMAaOOouj for <xfs@oss.sgi.com>;
	Sat, 18 Jul 2015 11:12:59 -0700 (PDT)
Message-ID: <55AA9727.1090609@mygrande.net>
Date: Sat, 18 Jul 2015 13:12:55 -0500
From: Leslie Rhorer <lrhorer@mygrande.net>
MIME-Version: 1.0
Subject: Re: XFS File system in trouble
References: <03864DDC681E664EBF5D47682BE7D7CF0D3574DF@USADCWVEMBX07.corp.global.level3.com>	<55AA5FCE.4080702@sandeen.net>	<03864DDC681E664EBF5D47682BE7D7CF0D358740@USADCWVEMBX07.corp.global.level3.com>
	<CAN3tLtJuk3LKHtxvbXATBR7bjr2e=GTX-fgs-jQniuxqRXjeoA@mail.gmail.com>
In-Reply-To: <CAN3tLtJuk3LKHtxvbXATBR7bjr2e=GTX-fgs-jQniuxqRXjeoA@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Kris Rusocki <kszysiu@braxis.org>, "Rhorer, Leslie" <Leslie.Rhorer@level3.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 7/18/2015 12:47 PM, Kris Rusocki wrote:
> On Sat, Jul 18, 2015 at 7:23 PM, Rhorer, Leslie
> <Leslie.Rhorer@level3.com> wrote:
>
> <snip>
>
>> [  425.657948] ata2.00: exception Emask 0x10 SAct 0x4000000 SErr 0x280100 action 0x6 frozen
>> [  425.657956] ata2.00: irq_stat 0x08000000, interface fatal error
>> [  425.657962] ata2: SError: { UnrecovData 10B8B BadCRC }
>> [  425.657968] ata2.00: failed command: READ FPDMA QUEUED
>> [  425.657977] ata2.00: cmd 60/08:d0:b8:02:45/00:00:0c:00:00/40 tag 26 ncq 4096 in
>>           res 50/00:d0:b8:02:45/00:00:0c:00:00/40 Emask 0x10 (ATA bus error)
>> [  425.657982] ata2.00: status: { DRDY }
>> [  425.657988] ata2: hard resetting link
>
> This is your SATA *interface* dying.
> Quick google-fu reveals: https://lkml.org/lkml/2008/12/2/426

	Except that isn't the interface on which the drives in the array 
reside.  The array is on sd 0:0:x.  Ata2 hosts one of a pair of 
removable Toshiba SSDs, and there is something flaky in the hardware.  I 
haven't had time to figure out if it is the cable, the drive carrier, or 
the SSD.  One of the arrays on one of the partitions on the drive is 
mounted, because those SSDs carry the old OS load and files which were 
active prior to my moving to a clean OS on a conventional hard drive in 
order to try to alleviate these issues.  I'll definitely run it down 
after I resolve this much more serious issue.  When things are settled, 
I want to go back to booting off the RAID1 arrays hosted on the SSDs, 
but for now they aren't in use much.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
