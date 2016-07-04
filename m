Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E05FA7CA1
	for <xfs@oss.sgi.com>; Sun,  3 Jul 2016 19:15:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 766B9AC002
	for <xfs@oss.sgi.com>; Sun,  3 Jul 2016 17:15:44 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	lErTIETPOwYidyEu for <xfs@oss.sgi.com>;
	Sun, 03 Jul 2016 17:15:41 -0700 (PDT)
Date: Mon, 4 Jul 2016 10:15:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Question: Old Irix tape backup. Recovery on Linux
	(xfsdump/xfsrestore)
Message-ID: <20160704001540.GX12670@dastard>
References: <SN1PR05MB231785E5196A5D31D0D833EACC230@SN1PR05MB2317.namprd05.prod.outlook.com>
	<SN1PR05MB23175D5BF190CCC3F22E2EB0CC240@SN1PR05MB2317.namprd05.prod.outlook.com>
	<4d9d00ef-82d5-a658-e88c-ba75fb7a6023@sandeen.net>
	<SN1PR05MB2317E464B2CFB5A06CC4B66BCC240@SN1PR05MB2317.namprd05.prod.outlook.com>
	<dc20d8ae-d57f-53f1-72b8-d623529c695b@sandeen.net>
	<20160630220737.GS12670@dastard>
	<BFF5CB1A-BA65-4212-9607-2F25F427433B@animezone.org>
	<SN1PR05MB23179FAACBDA0B885FE11D06CC250@SN1PR05MB2317.namprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <SN1PR05MB23179FAACBDA0B885FE11D06CC250@SN1PR05MB2317.namprd05.prod.outlook.com>
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

On Fri, Jul 01, 2016 at 06:23:21PM +0000, Anthony l wrote:
> But I do have an observation. I had a tape (not made on the irix
> system) and I was able to pull a direct transfer of files with the
> dd command. i.e dd if=/dev/nst0 of=./somefile1 ibs =64k
> 
> And I would only have to do this 3 -4 times to get like 30+ GBs of
> data off the tapes and a simple tar xvf command extracted these
> files just fine. But my question is how come when I try to do
> these with the tapes made on the Irix machine I only get about 200
> mb at a time and there are like 190+ files on each tape. Is this
> normal for an xfs file system on a tape drive?

>From the xfsrestore man page:

Media Errors

       xfsdump  is  tolerant of media errors, but cannot do error
       correction.  If a media error occurs in the body of a media
       file, the filesystem file represented at that point is lost.
       The bad portion of the media is skipped, and the restoration
       resumes at the next filesystem file after the bad portion of
       the media.

       If a media error occurs in the beginning of the media file,
       the entire media file is lost.  For this reason, large dumps
       are broken into a number of reasonably sized media files.
       The restore resumes with the next media file.


The error you are seeing is with the last media file in the dump
which, IIRC, contains critical inventory information and so restore
cannot continue without that media file. You need to work out why
that last media file is returning a short read, once once you solve
that problem xfsrestore should work correctly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
