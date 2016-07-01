Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 68B857CA3
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2016 14:29:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2B5FD8F8037
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2016 12:29:03 -0700 (PDT)
Received: from c.mx.filmlight.ltd.uk (c.mx.filmlight.ltd.uk [54.76.112.217])
	by cuda.sgi.com with ESMTP id GqC68krYGfDvWUBb for
	<xfs@oss.sgi.com>; Fri, 01 Jul 2016 12:29:00 -0700 (PDT)
Message-ID: <1467401339.7631.221.camel@filmlight.ltd.uk>
Subject: Re: Question: Old Irix tape backup. Recovery on Linux
	(xfsdump/xfsrestore)
From: Roger Willcocks <roger@filmlight.ltd.uk>
Date: Fri, 01 Jul 2016 20:28:59 +0100
In-Reply-To: <SN1PR05MB23179FAACBDA0B885FE11D06CC250@SN1PR05MB2317.namprd05.prod.outlook.com>
References: <SN1PR05MB231785E5196A5D31D0D833EACC230@SN1PR05MB2317.namprd05.prod.outlook.com>
	<SN1PR05MB23175D5BF190CCC3F22E2EB0CC240@SN1PR05MB2317.namprd05.prod.outlook.com>
	<4d9d00ef-82d5-a658-e88c-ba75fb7a6023@sandeen.net>
	<SN1PR05MB2317E464B2CFB5A06CC4B66BCC240@SN1PR05MB2317.namprd05.prod.outlook.com>
	<dc20d8ae-d57f-53f1-72b8-d623529c695b@sandeen.net>
	<20160630220737.GS12670@dastard>
	, <BFF5CB1A-BA65-4212-9607-2F25F427433B@animezone.org>
	<SN1PR05MB23179FAACBDA0B885FE11D06CC250@SN1PR05MB2317.namprd05.prod.outlook.com>
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
To: Anthony l <Martinezant2141@live.com>
Cc: Andrew Ho <andrewho@animezone.org>, Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>


xfsrestore: tape op: reading 245760 bytes
xfsrestore: tape op read of 245760 bytes short: nread == 4096

I think this is the crux -- regardless of the record size xfsrestore
expects, it only ever gets the first 4k block.

This is probably a limitation of the tape drive or the driver.

I'd try:

# mt -f /dev/nst0 setblk 0
# xfsrestore -m -b 245760 -v5 -f /dev/nst0 .


--
Roger



On Fri, 2016-07-01 at 18:23 +0000, Anthony l wrote:
> Thanks for the suggestions again. 
> 
> Still banging my head against a wall. 
> 
> So  I was trying a bunch of xfsrestore commands anything from -m -k -b
> to all three but still the same result every time. 
> 
> xfsrestore -K -m -b 4096 -f /dev/nst0 ./
> 
> xfsrestore  -K -r -f /dev/nst0 ./ 
> 
> 
> I don't think this is a corrupt tape or anything because I have around
> 7 -10 tapes that are all made on the irix machine, but all behave the
> same. I have tried tar before but I get this is not a tar file or gzip
> file something like that. 
> 
> But I do have an observation. I had a tape (not made on the irix
> system) and I was able to pull a direct transfer of files with the dd
> command. i.e dd if=/dev/nst0 of=./somefile1 ibs =64k 
> 
> And I would only have to do this 3 -4 times to get like 30+ GBs of
> data off the tapes and a simple tar xvf command extracted these files
> just fine. But my question is how come when I try to do these with the
> tapes made on the Irix machine I only get about 200 mb at a time and
> there are like 190+ files on each tape. Is this normal for an xfs file
> system on a tape drive?
> 
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
