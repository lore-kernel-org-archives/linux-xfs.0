Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F346E7CA1
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2016 17:17:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B848B8F8040
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2016 15:17:53 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	4EFmTG1UOjYfPIcz for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2016 15:17:50 -0700 (PDT)
Date: Thu, 30 Jun 2016 08:17:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Question: Old Irix tape backup. Recovery on Linux
	(xfsdump/xfsrestore)
Message-ID: <20160629221749.GP12670@dastard>
References: <SN1PR05MB231785E5196A5D31D0D833EACC230@SN1PR05MB2317.namprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <SN1PR05MB231785E5196A5D31D0D833EACC230@SN1PR05MB2317.namprd05.prod.outlook.com>
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Jun 29, 2016 at 06:48:29PM +0000, Anthony l wrote:
> Hello Anthony here,
> 
> I'm not sure if this is the correct place to send a question, If I am wrong I would appreciate if you could send me in the right direction.  I have come across the oss.sgi forums a lot looking for a solution to my problem but I could not find much.
> 
> 
> Here's my situation.
> 
> I have a bunch a tapes that were created way back when using an IRIX system. Some kind of version 6, perhaps even the latest version. anyway I am able to peak at the headers to determind the the file type on the drive is indeed:
> 
> xFSdump0....   or when I make a sample using 'dd if=/dev/nst0 of=./test.img' '+ 'file test.img' I get XFSDUMP archive (version 2)

dump version 2....

> So, instinctively to get the data off the tapes I would think would be as simple as:
> 
> sudo xfsrestore -f /dev/nst0 ./path to where I want it stored
> 
> Then I get:
> 
> using dump format 3

Oops, wrong format version.

> What am I doing wrong here ?? any help would be great.

Try telling restore to use dump format version 2 by using the -K
option.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
