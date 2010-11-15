Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAFGP26Z143918 for <xfs@oss.sgi.com>; Mon, 15 Nov 2010 10:25:02 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8BE201C42425
	for <xfs@oss.sgi.com>; Mon, 15 Nov 2010 08:26:34 -0800 (PST)
Received: from mail.sandeen.net (64-131-28-21.usfamily.net [64.131.28.21]) by
	cuda.sgi.com with ESMTP id UqWGANesyJ7JKOsT for
	<xfs@oss.sgi.com>; Mon, 15 Nov 2010 08:26:33 -0800 (PST)
Message-ID: <4CE15F39.2010904@sandeen.net>
Date: Mon, 15 Nov 2010 10:26:33 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Fwd: xfs - fixing wrong xfs size
References: <dbd747120904130713t7388971axf75ee779b5b1e1f2@mail.gmail.com>	<49E353FD.5060207@sandeen.net>	<dbd747120904130933i6ae66aedt7912a47b7e561f76@mail.gmail.com>	<4BE1EF9D.2030901@sandeen.net>
	<30211747.post@talk.nabble.com>
In-Reply-To: <30211747.post@talk.nabble.com>
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
To: johahoff <jh@not-dark-yet.de>
Cc: xfs@oss.sgi.com

On 11/14/10 5:16 AM, johahoff wrote:
> 
>> You can use xfs_db to set it; or you could comment out the kernel
>> check... and mount readonly, and copy off the data you can get to?
> 
> I have got the same problem after recovering a xfs volume using ddrescue. It
> seems that the new 1 TB drive I dd'ed to is a few blocks short ...
> 
> I had a look at the xfs_db man page, but wasn't able to figure out which
> command would allow me to set the block count of the fs. Can you please give
> the appropriate commands? I think I'll be able to figure out the correct
> counts on my own.
> 
> Thanks a lot!
> 
> -Johannes

# xfs_db -w /dev/blah
xfs_db> sb 0
xfs_db> p
...
magicnum = 0x58465342
blocksize = 4096
dblocks = XXXXXX
...
xfs_db> w dblocks <NEW VALUE>
xfs_db> quit

You may have to do it for each of the superblocks but I think the first
should suffice.

If files reference the blocks past the device then of course you'll hit
errors trying to read them as well ...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
