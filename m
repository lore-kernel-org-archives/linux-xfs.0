Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n02IQPJq021093 for <xfs@oss.sgi.com>; Fri, 2 Jan 2009 12:26:25 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0C9FF5A528
	for <xfs@oss.sgi.com>; Fri,  2 Jan 2009 10:26:23 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id Jt1qVstZD6xFBt9E for
	<xfs@oss.sgi.com>; Fri, 02 Jan 2009 10:26:23 -0800 (PST)
Message-ID: <495E5C4D.80307@sandeen.net>
Date: Fri, 02 Jan 2009 12:26:21 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] create xfstests install target
References: <495D42CE.6060806@sandeen.net>
	<20090102180247.GC29506@infradead.org>
In-Reply-To: <20090102180247.GC29506@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Thu, Jan 01, 2009 at 04:25:18PM -0600, Eric Sandeen wrote:
>> Not sure what the best location for this is in the end, but that's
>> just a one-line change in builddefs.in if it should move.  Currently
>> it goes to whatever configure thinks "libexecdir" is.
> 
> I think that's incorrect. libexecdir is /usr/lib for FHS or /usr/libexec
> for BSDish filesystem layouts, but /use should be read-only mountable.
> 
> Maybe /var/lib/xfstests as a start?  That seems to be the dumping ground
> for random stuff that needs write access.  

Ok, easy enough.

> Even better would be keeping
> the scripts under /usr/lib and the output in /var/lib, but that might
> be too much work.

Yeah at least right now I'm not that highly motivated.  :)

>> +PKG_SBIN_DIR    = @sbindir@
> 
> This one doesn't actually seem to be used.

true, it's not ... I put it in there thinking about putting a wrapper in
sbin or /usr/sbin so tests could be launched from root's path ...

-Eric

> Otherwise looks good to me.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
