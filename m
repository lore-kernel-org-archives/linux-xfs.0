Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p24GT8ef176318 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 10:29:09 -0600
Received: from mail.nethype.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F5BD313D2A
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2011 08:31:58 -0800 (PST)
Received: from mail.nethype.de (mail.nethype.de [78.47.73.129]) by
	cuda.sgi.com with ESMTP id Jz5YPHDKQ0KR4cIs for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2011 08:31:58 -0800 (PST)
Received: from [10.0.0.5] (helo=doom.schmorp.de)
	by mail.nethype.de with esmtp (Exim 4.72)
	(envelope-from <schmorp@schmorp.de>) id 1PvXv3-0007d5-WA
	for xfs@oss.sgi.com; Fri, 04 Mar 2011 16:31:58 +0000
Received: from [10.0.0.1] (helo=cerebro.laendle)
	by doom.schmorp.de with esmtp (Exim 4.72)
	(envelope-from <schmorp@schmorp.de>) id 1PvXv3-0004Wk-Jb
	for xfs@oss.sgi.com; Fri, 04 Mar 2011 16:31:57 +0000
Received: from root by cerebro.laendle with local (Exim 4.72)
	(envelope-from <root@schmorp.de>) id 1PvXv3-0000Zm-Oz
	for xfs@oss.sgi.com; Fri, 04 Mar 2011 17:31:57 +0100
Date: Fri, 4 Mar 2011 17:31:57 +0100
From: Marc Lehmann <schmorp@schmorp.de>
Subject: Re: corruption, xfs_repair 3.1.4 segfaults
Message-ID: <20110304163157.GA2030@schmorp.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D71001D.2040506@sandeen.net>
	<20110304121407.065d9f17@harpe.intellique.com>
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

On Fri, Mar 04, 2011 at 12:14:07PM +0100, Emmanuel Florac <eflorac@intellique.com> wrote:
> > I think that, no matter what the loop device would do, xfs_repair is
> > - it simply shouldn't crash, no matter how corrupted the filesystem
> 
> That's true. After you've copied everything, you could try using

It seems only a single directory was not readable (which is a backup), so all
data could be recovered. I am currently checking md5sums, but it seems that's
indeed it.

Which might make sense, as xfs_repair crashes after reading a XD2D
block. The backtrace I get when using rsync to copy over files also
supports this:

   http://ue.tst.eu/2bda1b4532cc66248763f723988093ce.txt

> Lenny's xfs_repair (v 2.9.x IIRC). Just in case, it may do better.

I will give that a shot, thanks for the hint, I will report back on this.

On Fri, Mar 04, 2011 at 09:07:09AM -0600, Eric Sandeen <sandeen@sandeen.net> wrote:
> > I had a case of filesystem corruption a day ago:
> 
> If you provide an xfs_metadump image of the filesystem, I'd be
> happy to look into the cause of the segfault.

That is the second thing that came to my mind, but this disk contains
sensitive data, and as long as the anonymise/obfuscate option of xfs_metadump
is broken (a simple hexdump reveals most of the filenames it's supposed to
obfuscate), I unfortunately cannot.

(the xfs_metadump -o bug has been reported in the past btw., if it's fixed
in git I could give thta another try).

> In my experience xfs_repair does not almost always crash, if you
> encounter this, please do send mail/file bugs/provide images.

Well, I did (as well as other people did), in the past, and the bugs
that were reported wree fixed (For example, I stumbled over the problem
of the xfs_repair livelock with threads, I stumbled over the problem of
it not being able to repair corruption a number of times despite saying
everything is ok and so on).

So "crash" was indeed badly worded - "does not fix things or does not run to
completion" is more correct.

The fact remains that of reiserfs, ext2/3/4 and jfs, xfs has by far the
lowest quality fsck, at least for me - each time I have some problem with an
xfs filesystem, xfs_repair fails to repair it.

It fortunately doesn't happen often, and is not necessarily a problem with
xfs itself, but I am using reiserfs and ext2/3/4 and xfs all for a very
long time, and of these, it's quite obvious that xfs_repair is much worse
then the fsck tools of the others.

-- 
                The choice of a       Deliantra, the free code+content MORPG
      -----==-     _GNU_              http://www.deliantra.net
      ----==-- _       generation
      ---==---(_)__  __ ____  __      Marc Lehmann
      --==---/ / _ \/ // /\ \/ /      schmorp@schmorp.de
      -=====/_/_//_/\_,_/ /_/\_\

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
