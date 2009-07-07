Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n67IDVEL159584 for <xfs@oss.sgi.com>; Tue, 7 Jul 2009 13:13:31 -0500
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B1D819F8EDE
	for <xfs@oss.sgi.com>; Tue,  7 Jul 2009 11:21:00 -0700 (PDT)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id ANgMiRJqsVjM8XgQ for
	<xfs@oss.sgi.com>; Tue, 07 Jul 2009 11:21:00 -0700 (PDT)
Date: Tue, 7 Jul 2009 20:13:52 +0200
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: [PATCH, RFC] default to inode64 on 64-bit systems
Message-ID: <20090707181352.GA3357@citd.de>
References: <4A52419E.5020301@sandeen.net> <20090707093802.GA32125@citd.de>
	<4A535650.7020309@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A535650.7020309@sandeen.net>
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
Cc: xfs mailing list <xfs@oss.sgi.com>

On 07.07.2009 09:06, Eric Sandeen wrote:
> Matthias Schniedermeyer wrote:
> > On 06.07.2009 13:25, Eric Sandeen wrote:
> >> I'm tiring of telling people to use the inode64 mount option
> >> when they are experiencing bad performance on large xfs 
> >> filesystems...
> >>
> >> 32-bit userspace is still largely broken when it comes to still
> >> using 32-bit stat calls, but on 64-bit systems this should be
> >> safe.
> >>
> >> The only problem here is moving the disk onto a 32-bit system, or using
> >> 32-bit apps.  But I think it's a small risk.
> >>
> >> What do we think about the following?
> > 
> > What is with people running 64bit kernel but 32bit Userspace?
> 
> Good point.  I wonder how many do that...   hrm.

I'd guess pretty much anybody who what's to utilize the amount of RAM 
you can have nowadays, but doesn't have any single program that needs 
that amount of memory. Or, like in my case, just needs it for 
tmpfs/buffer cache.

Throw in some "i don't want to reinstall" or "my Distribution isn't 
biarch" and you have someone who justs recompils their kernel and be 
done with it. It took me only a few minutes (rotating my hardware around 
that day took way longer)





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
