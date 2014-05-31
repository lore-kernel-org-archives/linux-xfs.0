Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 34BC07F83
	for <xfs@oss.sgi.com>; Sat, 31 May 2014 11:20:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 099648F8037
	for <xfs@oss.sgi.com>; Sat, 31 May 2014 09:20:45 -0700 (PDT)
Received: from mail-ig0-f180.google.com (mail-ig0-f180.google.com
	[209.85.213.180]) by cuda.sgi.com with ESMTP id
	bXJNFnRH29oauZUU (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 31 May 2014 09:20:44 -0700 (PDT)
Received: by mail-ig0-f180.google.com with SMTP id c1so1932030igq.13
	for <xfs@oss.sgi.com>; Sat, 31 May 2014 09:20:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6347520.8jMPlVsFjM@wuerfel>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<20140531145114.GA3721@localhost.localdomain>
	<6347520.8jMPlVsFjM@wuerfel>
Date: Sat, 31 May 2014 18:20:43 +0200
Message-ID: <CAMuHMdU9qEJ=k-Jq7VJZUbM82u0ViqaSLsRBf45EMrQJBLTPxA@mail.gmail.com>
Subject: Re: [RFC 00/32] making inode time stamps y2038 ready
From: Geert Uytterhoeven <geert@linux-m68k.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, MTD Maling List <linux-mtd@lists.infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, linux-f2fs-devel@lists.sourceforge.net, ceph-devel@vger.kernel.org, "Joseph S. Myers" <joseph@codesourcery.com>, Linux-Arch <linux-arch@vger.kernel.org>, linux-cifs@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>, codalist@coda.cs.cmu.edu, cluster-devel@redhat.com, coda@cs.cmu.edu, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, linux-afs@lists.infradead.org, fuse-devel@lists.sourceforge.net, Richard Cochran <richardcochran@gmail.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, "open list:NFS, SUNRPC,
	AND..." <linux-nfs@vger.kernel.org>, linux-ntfs-dev@lists.sourceforge.net, samba-technical@lists.samba.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, logfs@logfs.org, linux-btrfs <linux-btrfs@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Ley Foon Tan <lftan@altera.com>, ocfs2-devel@oss.oracle.com

On Sat, May 31, 2014 at 5:23 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Saturday 31 May 2014 16:51:15 Richard Cochran wrote:
>> On Fri, May 30, 2014 at 10:01:24PM +0200, Arnd Bergmann wrote:
>> > I picked this because it is a fairly isolated problem, as the
>> > inode time stamps are rarely assigned to any other time values.
>> > As a byproduct of this work, I documented for each of the file
>> > systems we support how long the on-disk format can work[1].
>>
>> Why are some of the time stamp expiration dates marked as "never"?
>
> It's an approximation:
> with 64-bit timestamps, you can represent close to 300 billion
> years, which is way past the time that our planet can sustain
> life of any form[1].

FWIW, the 48-bit second limit of befs marked never happens sooner
than the 32-bit day limit of affs marked as Y11760870.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
