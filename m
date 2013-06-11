Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4637129DFA
	for <linux-xfs@oss.sgi.com>; Tue, 11 Jun 2013 08:11:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B9D5CAC009
	for <linux-xfs@oss.sgi.com>; Tue, 11 Jun 2013 06:11:02 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id bkMCVqkBE96ngYH4 for
	<linux-xfs@oss.sgi.com>; Tue, 11 Jun 2013 06:10:59 -0700 (PDT)
Date: Tue, 11 Jun 2013 15:10:55 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Questions about XFS
Message-ID: <20130611151055.2680b6cc@harpe.intellique.com>
In-Reply-To: <loom.20130611T112155-970@post.gmane.org>
References: <loom.20130611T112155-970@post.gmane.org>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Steve Bergman <sbergman27@gmail.com>
Cc: linux-xfs@oss.sgi.com

Le Tue, 11 Jun 2013 09:56:38 +0000 (UTC)
Steve Bergman <sbergman27@gmail.com> =E9crivait:

> Hi all,
> =

> I have a few questions about XFS that didn't make the XFS FAQ. I'm
> trying to get a feel for where I might want to use it on my servers
> (or at home). A mix of ext3 & ext4 has worked well for me. But I'd
> like to get to know XFS a bit better. The target OS would be RHEL6.
> =

> 1. I don't have "lots and large". Why should I run XFS?

Because it performs well and reliably.

> 2. I don't have "lots and large". Why shouldn't I run XFS?

Because ext4 is more common and won't uncover unexpected bugs in badly
written applications.

> 3. Why doesn't RHEL6 support XFS on root, when the XFS FAQ says XFS
> on root is fine? Is there some issue I should be aware of?

Not that I know of. I've used XFS as root back in the RedHat 7.x times,
13 years ago. I've used XFS as root on Irix years before that.
However nowadays I use XFS extensively but usually not as root.

> 4. From the time I write() a bit of data, what's the maximum time
> before the data is actually committed to disk?

On the distributions I'm using (Debian, Slackware), no significant
delay that I know of. Even extremely mistreated systems (pulling the
plug while working shouldn't do any harm, should it?)

> 5. Ext4 provides some automatic fsync'ing to avoid the zero-length
> file issue for some common cases via the auto_da_alloc feature added
> in kernel 2.6.30. Does XFS have similar behavior? =


I don't know. I keep hearing of this "xfs bug" but never actually
encountered it, ever, though I've set up about 3000 servers with XFS
filesystems, many to work under very harsh conditions.

> 6. RHEL6 Anaconda sets a RAID10 chunk size of 512K by default XFS
> complains and sets its log stripe down to 32k. Should I accept
> Anaconda's default? It knows I've requested XFS formatting before it
> sets the chunk size, after all.

512k seems insanely large to me. Something like 64 or 256k seems more
common, and reasonable. BTW, 256k is a perfectly valid size for xfs log
stripe. My advice: unless you plan on working only with big files,
create a 64k stripe RAID-10. Your performance will be much better, and
XFS will be happy.

> 8. Eric (and the XFS FAQ) have recommended just using the defaults for
> mkfs.xfs and mount. But I've also heard Dave say "Increase logbsize
> and use inode64; everybody does that, but we just haven't made it the
> default". I'm guessing it doesn't matter if one doesn't have large
> and lots?

Actually inode64 is default on recent kernels. Of course this doesn't
apply to RH which for some reason uses only positively jurassic
kernels :)
Increasing logbsize is probably unnecessary except on highly
performance sensitive workloads; currently the 32k default should be
enough.

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
