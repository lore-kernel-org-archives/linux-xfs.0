Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E99267F62
	for <xfs@oss.sgi.com>; Sat, 18 Jul 2015 12:47:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C8EAC8F804B
	for <xfs@oss.sgi.com>; Sat, 18 Jul 2015 10:47:34 -0700 (PDT)
Received: from mail-lb0-f182.google.com (mail-lb0-f182.google.com
	[209.85.217.182]) by cuda.sgi.com with ESMTP id
	BULkxSPBTixXyeTf (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 18 Jul 2015 10:47:28 -0700 (PDT)
Received: by lbbzr7 with SMTP id zr7so75992903lbb.1
	for <xfs@oss.sgi.com>; Sat, 18 Jul 2015 10:47:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <03864DDC681E664EBF5D47682BE7D7CF0D358740@USADCWVEMBX07.corp.global.level3.com>
References: <03864DDC681E664EBF5D47682BE7D7CF0D3574DF@USADCWVEMBX07.corp.global.level3.com>
	<55AA5FCE.4080702@sandeen.net>
	<03864DDC681E664EBF5D47682BE7D7CF0D358740@USADCWVEMBX07.corp.global.level3.com>
Date: Sat, 18 Jul 2015 19:47:26 +0200
Message-ID: <CAN3tLtJuk3LKHtxvbXATBR7bjr2e=GTX-fgs-jQniuxqRXjeoA@mail.gmail.com>
Subject: Re: XFS File system in trouble
From: Kris Rusocki <kszysiu@braxis.org>
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
To: "Rhorer, Leslie" <Leslie.Rhorer@level3.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "lrhorer@mygrande.net" <lrhorer@mygrande.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sat, Jul 18, 2015 at 7:23 PM, Rhorer, Leslie
<Leslie.Rhorer@level3.com> wrote:

<snip>

> [  425.657948] ata2.00: exception Emask 0x10 SAct 0x4000000 SErr 0x280100 action 0x6 frozen
> [  425.657956] ata2.00: irq_stat 0x08000000, interface fatal error
> [  425.657962] ata2: SError: { UnrecovData 10B8B BadCRC }
> [  425.657968] ata2.00: failed command: READ FPDMA QUEUED
> [  425.657977] ata2.00: cmd 60/08:d0:b8:02:45/00:00:0c:00:00/40 tag 26 ncq 4096 in
>          res 50/00:d0:b8:02:45/00:00:0c:00:00/40 Emask 0x10 (ATA bus error)
> [  425.657982] ata2.00: status: { DRDY }
> [  425.657988] ata2: hard resetting link

This is your SATA *interface* dying.
Quick google-fu reveals: https://lkml.org/lkml/2008/12/2/426

Seems that hardware needs to be vouched for before looking at higher
layers [?]


Thanks,
Kris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
