Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6B3397F4E
	for <xfs@oss.sgi.com>; Sun,  3 Nov 2013 20:37:38 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 511B38F8035
	for <xfs@oss.sgi.com>; Sun,  3 Nov 2013 18:37:38 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id dfJgX23KQrY44CTH for <xfs@oss.sgi.com>;
	Sun, 03 Nov 2013 18:37:37 -0800 (PST)
Message-ID: <5277086E.6030905@sandeen.net>
Date: Sun, 03 Nov 2013 20:37:34 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: How to use increased number of ACL entries?
References: <20131103081704.GE9974@fit.vutbr.cz>
	<20131104003915.GN6188@dastard>
In-Reply-To: <20131104003915.GN6188@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Kasparek Tomas <kasparek@fit.vutbr.cz>
Cc: xfs@oss.sgi.com

On 11/3/13, 6:39 PM, Dave Chinner wrote:
> On Sun, Nov 03, 2013 at 09:17:04AM +0100, Kasparek Tomas wrote:
>> Hello,
>>
>> I'm trying to get more then 25 ACLs entries to work according to
>> http://oss.sgi.com/pipermail/xfs/2013-May/026544.html . I'm running 3.10.x
>> kernel which seems to contain these changes. I understand, that this is
>> on-disk format change, so I expect to need new xfsprogs too. I tried the
>> version from CentOS 6.4 (3.1.1) and one from git repo (
>> git://oss.sgi.com/xfs/cmds/xfsprogs), but still it fails to create more then
>> 25 ACL entries (21 user defined). Is there something I'm still missing?
> 
> You haven't told mkfs to change the on disk format to enable more
> than 25 ACLs. Only the version from git will do it, and your CentOS
> kernel will not support it.

but the 3.10.x kernel you're running will IIRC; use "-m crc=1" on the mkfs.xfs
commandline from a git mkfs.xfs.

-Eric
 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
