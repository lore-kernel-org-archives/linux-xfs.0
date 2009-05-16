Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4GLfAwi143197 for <xfs@oss.sgi.com>; Sat, 16 May 2009 16:41:11 -0500
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4772128EE9F
	for <xfs@oss.sgi.com>; Sat, 16 May 2009 14:41:18 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id AMFyjc8D4Zh8Y7vr for
	<xfs@oss.sgi.com>; Sat, 16 May 2009 14:41:18 -0700 (PDT)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: quick question about filename length
Date: Sat, 16 May 2009 23:42:19 +0200
References: <554e24be0905160915l49ff901bn41e4332349c555bc@mail.gmail.com>
	<554e24be0905161106x6a62b7bldc65325ac4102628@mail.gmail.com>
	<20090516202511.GA28186@infradead.org>
	(sfid-20090516_231832_172988_5C4BCCA0)
In-Reply-To: <20090516202511.GA28186@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905162342.19915.Martin@lichtvoll.de>
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
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, Chris Walker <christopher.walker@gmail.com>

Am Samstag 16 Mai 2009 schrieb Christoph Hellwig:
> On Sat, May 16, 2009 at 02:06:22PM -0400, Chris Walker wrote:
> > Thanks for you quick reply, Eric.
> >
> > I have a user who is having filenames (path+filename) cut off at 255
> > characters midway through a simulation -- but the problem must be
> > elsewhere
>
> XFS doesn't actually see the whole filename in normal operation (except
> for copying out the data out of symbolic links), as the resolution to
> individual components is done by the VFS.   Long file name should work
> just fine on Linux and do in my test.  Maybe some buffer is sized using
> incorrect in userspace?

And while a link name itself also can't be longer than about 256 
characters (I only tested 250 and 260), a link can point to a longer 
path ;-):

martin@shambhala:~/Zeit> mkdir -p 
$(ruby -e 'puts "1234567890"*25')/$(ruby -e 'puts "1234567890"*25')
martin@shambhala:~/Zeit> ln -s 
$(ruby -e 'puts "1234567890"*25')/$(ruby -e 'puts "1234567890"*25') 
testlink
martin@shambhala:~/Zeit> ls -l testlink
lrwxrwxrwx 1 martin martin 501 16. Mai 23:40 testlink -> 
12345678901234567890123456789012345678901234567890123456789[...]
martin@shambhala:~/Zeit> (df -hT . | grep -q xfs) && echo "Is XFS"
Is XFS

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
