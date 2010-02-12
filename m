Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CKRqoL023799 for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 14:27:52 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8F23D1CC8D99
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 12:29:06 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id jbprLY68M8XfGqeV for
	<xfs@oss.sgi.com>; Fri, 12 Feb 2010 12:29:06 -0800 (PST)
Message-ID: <4B75BA12.1060704@sandeen.net>
Date: Fri, 12 Feb 2010 14:29:06 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair doesn't fix sb versionnum missing attr
References: <1265996674.7755.7.camel@lh10.linush.net>
In-Reply-To: <1265996674.7755.7.camel@lh10.linush.net>
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
To: C Linus Hicks <linush@verizon.net>
Cc: xfs@oss.sgi.com

C Linus Hicks wrote:
> I run:
> 
> xfs_check /dev/sdc10
> 
> And it reports:
> 
> sb versionnum missing attr bit 10
> 
> Then I run:
> 
> xfs_repair /dev/sdc10
> 
> And it reports output from 7 phases and "done".
> 
> Again I run:
> 
> xfs_check /dev/sdc10
> 
> And it reports:
> 
> sb versionnum missing attr bit 10
> 
> Is this how it's supposed to work?
> Thanks for any help.
> Linus
> 

I've never seen that before.

This might be interesting to see:

# xfs_db /dev/sdc10
xfs_db> sb 0
xfs_db> version

If you want to send me a zipped-up, obfuscated metadump of the filesystem
I could take a quick look.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
