Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CKkUPh026197 for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 14:46:31 -0600
Received: from vms173019pub.verizon.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 24EE913A4571
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 12:47:45 -0800 (PST)
Received: from vms173019pub.verizon.net (vms173019pub.verizon.net
	[206.46.173.19]) by cuda.sgi.com with ESMTP id CWpNEHBVKXpF8lib
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 12:47:45 -0800 (PST)
Received: from [192.168.10.2] ([unknown] [98.114.168.230])
	by vms173019.mailsrvcs.net
	(Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16
	2009)) with ESMTPA id <0KXQ000YAXR5CQ83@vms173019.mailsrvcs.net> for
	xfs@oss.sgi.com; Fri, 12 Feb 2010 14:47:30 -0600 (CST)
Subject: Re: xfs_repair doesn't fix sb versionnum missing attr
From: C Linus Hicks <linush@verizon.net>
In-reply-to: <4B75BA12.1060704@sandeen.net>
References: <1265996674.7755.7.camel@lh10.linush.net>
	<4B75BA12.1060704@sandeen.net>
Date: Fri, 12 Feb 2010 15:47:29 -0500
Message-id: <1266007649.7755.12.camel@lh10.linush.net>
MIME-version: 1.0
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Fri, 2010-02-12 at 14:29 -0600, Eric Sandeen wrote:
> C Linus Hicks wrote:
> > I run:
> > 
> > xfs_check /dev/sdc10
> > 
> > And it reports:
> > 
> > sb versionnum missing attr bit 10
> > 
> > Then I run:
> > 
> > xfs_repair /dev/sdc10
> > 
> > And it reports output from 7 phases and "done".
> > 
> > Again I run:
> > 
> > xfs_check /dev/sdc10
> > 
> > And it reports:
> > 
> > sb versionnum missing attr bit 10
> > 
> > Is this how it's supposed to work?
> > Thanks for any help.
> > Linus
> > 
> 
> I've never seen that before.
> 
> This might be interesting to see:
> 
> # xfs_db /dev/sdc10
> xfs_db> sb 0
> xfs_db> version
> 
> If you want to send me a zipped-up, obfuscated metadump of the filesystem
> I could take a quick look.
> 
> -Eric

The output from the "version" command:

versionnum [0x3084+0x0] = V4,ALIGN,DIRV2,EXTFLG

I'll email the metadump directly to you so as not to pollute the list.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
