Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n033l1of027188 for <xfs@oss.sgi.com>; Fri, 2 Jan 2009 21:47:02 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 026525BCE7
	for <xfs@oss.sgi.com>; Fri,  2 Jan 2009 19:47:00 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id O1Wwsu4jKuEFjGeo for
	<xfs@oss.sgi.com>; Fri, 02 Jan 2009 19:47:00 -0800 (PST)
Message-ID: <495EDFB2.30603@sandeen.net>
Date: Fri, 02 Jan 2009 21:46:58 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] create xfstests install target
References: <495D42CE.6060806@sandeen.net>	<20090102180247.GC29506@infradead.org>
	<495E5C4D.80307@sandeen.net>
In-Reply-To: <495E5C4D.80307@sandeen.net>
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

Eric Sandeen wrote:
> Christoph Hellwig wrote:
>> On Thu, Jan 01, 2009 at 04:25:18PM -0600, Eric Sandeen wrote:
>>> Not sure what the best location for this is in the end, but that's
>>> just a one-line change in builddefs.in if it should move.  Currently
>>> it goes to whatever configure thinks "libexecdir" is.
>> I think that's incorrect. libexecdir is /usr/lib for FHS or /usr/libexec
>> for BSDish filesystem layouts, but /use should be read-only mountable.
>>
>> Maybe /var/lib/xfstests as a start?  That seems to be the dumping ground
>> for random stuff that needs write access.  
> 
> Ok, easy enough.

Or so one might think.  Anyone good with autoconf who can tell me how
the *!@% to specify /var/lib ?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
