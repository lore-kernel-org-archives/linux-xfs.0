Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p24JFSof183637 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 13:15:29 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BC6EE10A795C
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2011 11:18:18 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id D0kKW70az8uVcJfd for <xfs@oss.sgi.com>;
	Fri, 04 Mar 2011 11:18:18 -0800 (PST)
Message-ID: <4D713AF9.4050101@sandeen.net>
Date: Fri, 04 Mar 2011 13:18:17 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: corruption, xfs_repair 3.1.4 segfaults
References: <20110304163157.GA2030@schmorp.de>
In-Reply-To: <20110304163157.GA2030@schmorp.de>
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
To: Marc Lehmann <schmorp@schmorp.de>
Cc: xfs@oss.sgi.com

On 3/4/11 10:31 AM, Marc Lehmann wrote:

> On Fri, Mar 04, 2011 at 09:07:09AM -0600, Eric Sandeen <sandeen@sandeen.net> wrote:
>>> I had a case of filesystem corruption a day ago:
>>
>> If you provide an xfs_metadump image of the filesystem, I'd be
>> happy to look into the cause of the segfault.
> 
> That is the second thing that came to my mind, but this disk contains
> sensitive data, and as long as the anonymise/obfuscate option of xfs_metadump
> is broken (a simple hexdump reveals most of the filenames it's supposed to
> obfuscate), I unfortunately cannot.

Do you have a lot of short names?  It should be obfuscating the others
just fine.  Otherwise, Alex has been working on the obfuscation, maybe
he can give you some pointers.

BTW no need to run hexdump; you can xfs_mdrestore the dump, and loopback
mount it, and do a find to see what filenames are there.

(unless you mean the clear names are seen in hexdump but not on the
mounted, restored fs?  If so that's a new and interesting problem).

> (the xfs_metadump -o bug has been reported in the past btw., if it's fixed
> in git I could give thta another try).

well... "-o" DISABLEs obfuscation.  If you use it and see all filenames,
that is exactly as it should be working ;)  Don't use -o if you want
obfuscation (I know, it seems a little backwards to me too).

>> In my experience xfs_repair does not almost always crash, if you
>> encounter this, please do send mail/file bugs/provide images.
> 
> Well, I did (as well as other people did), in the past, and the bugs
> that were reported wree fixed (For example, I stumbled over the problem
> of the xfs_repair livelock with threads, I stumbled over the problem of
> it not being able to repair corruption a number of times despite saying
> everything is ok and so on).
> 
> So "crash" was indeed badly worded - "does not fix things or does not run to
> completion" is more correct.

well, keep reporting them, and with metadumps when possible.

> The fact remains that of reiserfs, ext2/3/4 and jfs, xfs has by far the
> lowest quality fsck, at least for me - each time I have some problem with an
> xfs filesystem, xfs_repair fails to repair it.

I think that's unique to you ;)  but it also depends on your definition
of "quality."

Of course, properly completing repair is a fair definition!  Really, these
things need to be reported, triaged, and fixed.  If the confusion over
metadump was the proper usage of "-o" then perhaps you will be able
to submit some of your unfixable corruptions.

-Eric

> It fortunately doesn't happen often, and is not necessarily a problem with
> xfs itself, but I am using reiserfs and ext2/3/4 and xfs all for a very
> long time, and of these, it's quite obvious that xfs_repair is much worse
> then the fsck tools of the others.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
