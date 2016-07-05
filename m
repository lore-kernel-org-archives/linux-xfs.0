Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DE5FC7CE4
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2016 13:21:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 49FDEAC001
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2016 11:21:35 -0700 (PDT)
Received: from c.mx.filmlight.ltd.uk (c.mx.filmlight.ltd.uk [54.76.112.217])
	by cuda.sgi.com with ESMTP id DuKowrFGTRkuQBai for
	<xfs@oss.sgi.com>; Tue, 05 Jul 2016 11:21:26 -0700 (PDT)
Message-ID: <1467742885.7631.246.camel@filmlight.ltd.uk>
Subject: Re: Question: Old Irix tape backup. Recovery on Linux
	(xfsdump/xfsrestore)
From: Roger Willcocks <roger@filmlight.ltd.uk>
Date: Tue, 05 Jul 2016 19:21:25 +0100
In-Reply-To: <20160704001540.GX12670@dastard>
References: <SN1PR05MB231785E5196A5D31D0D833EACC230@SN1PR05MB2317.namprd05.prod.outlook.com>
	<SN1PR05MB23175D5BF190CCC3F22E2EB0CC240@SN1PR05MB2317.namprd05.prod.outlook.com>
	<4d9d00ef-82d5-a658-e88c-ba75fb7a6023@sandeen.net>
	<SN1PR05MB2317E464B2CFB5A06CC4B66BCC240@SN1PR05MB2317.namprd05.prod.outlook.com>
	<dc20d8ae-d57f-53f1-72b8-d623529c695b@sandeen.net>
	<20160630220737.GS12670@dastard>
	<BFF5CB1A-BA65-4212-9607-2F25F427433B@animezone.org>
	<SN1PR05MB23179FAACBDA0B885FE11D06CC250@SN1PR05MB2317.namprd05.prod.outlook.com>
	<20160704001540.GX12670@dastard>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: Anthony l <Martinezant2141@live.com>, Andrew Ho <andrewho@animezone.org>, Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, 2016-07-04 at 10:15 +1000, Dave Chinner wrote:

> The error you are seeing is with the last media file in the dump
> which, IIRC, contains critical inventory information and so restore
> cannot continue without that media file. You need to work out why
> that last media file is returning a short read, once once you solve
> that problem xfsrestore should work correctly.
> 

I think every media file is returning a short read; looking at
http://pastebin.com/UW9zRAZ0 this pattern repeats:

xfsrestore: drive op: end read
xfsrestore: drive op: begin read
xfsrestore: tape op: get status
xfsrestore: tape status = wprot onl
xfsrestore: tape op: forward space file 1
xfsrestore: tape op: get status
xfsrestore: tape status = fmk wprot onl
xfsrestore: tape op: reading 245760 bytes
xfsrestore: tape op read of 245760 bytes short: nread == 4096

i.e. it skips to the next filemark and the first read is short. 

Ah...

https://wiki.zmanda.com/index.php/Installation/OS_Specific_Notes/Installing_Amanda_on_IRIX

"When setting the tape device name in either amanda.conf or one of the
changer configuration files, make sure you specify the "variable" device
name, which has a 'v' on the end. If not, IRIX will write 4KByte blocks
instead of the 32KByte blocks AMANDA tells it to. This apparantly works
OK unless you take the tape to a non-IRIX system, where amrestore will
complain about a short (4096) read."

The page goes on to suggest using dd to skip the first eight 4k blocks,
but that doesn't seem right to me (since the first blocks evidently
contain sensible data.)

So on the face of it this is a tape with fixed length blocks, in which
case 

# mt -f /dev/<name> setblk 4096

might do the trick. (Also use '-m -b 4096' with xfsrestore.)

--
Roger





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
