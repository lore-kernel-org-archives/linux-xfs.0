Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2LN0CZv135486 for <xfs@oss.sgi.com>; Wed, 21 Mar 2012 18:00:13 -0500
Received: from mail-wg0-f41.google.com (mail-wg0-f41.google.com
	[74.125.82.41]) by cuda.sgi.com with ESMTP id 3zHF2hgDP023KOlN
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 21 Mar 2012 16:00:11 -0700 (PDT)
Received: by wgbds1 with SMTP id ds1so41418wgb.2
	for <xfs@oss.sgi.com>; Wed, 21 Mar 2012 16:00:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120321220652.GJ8451@sgi.com>
References: <20120321183613.2C93F426DA7@whiskey.americas.sgi.com>
	<CA+55aFyz5UWiJeeMbwZUZEscisZY5Jb0nADpJP6jWKwf3Uai1A@mail.gmail.com>
	<20120321220652.GJ8451@sgi.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 21 Mar 2012 15:59:49 -0700
Message-ID: <CA+55aFzzoLDs0MSo7zoNEDL7gzMmqR+Vr1WYh337xeSVyDhJ0w@mail.gmail.com>
Subject: Re: [GIT PULL] XFS update for 3.4-rc1
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Mar 21, 2012 at 3:06 PM, Ben Myers <bpm@sgi.com> wrote:
>
> xfs/master contains scalability improvements for dquots, log grant code
> cleanups, plus bugfixes and cleanups large and small.

Shortlog and diffstat?

> Unfortunately the stuff in: =A0git://oss.sgi.com/xfs/xfs master
>
> Conflicts with the stuff in: =A0git://oss.sgi.com/xfs/xfs for-linus

There's still nothng in 'for-linus'.

> I've resolved the conflict here: =A0git://oss.sgi.com/xfs/xfs for-linus-m=
erged

I actually prefer to merge things myself to see what is up, especially
since everybody else writes horrible merge messages (but also because
I simply want to know what the conflicts are). I appreciate more
complex pull requests that *also* have a "pre-merged" branch just in
case (I tend to use that for verification if there was anything even
remotely questionable going on), but I really do not generally want
pre-merging.

I'm used to resolving conflicts. I'm so used to it, in fact, that
there have been cases where I did it right despite not really knowing
the code and the maintainer did it wrong, just because I know what to
look for.

> I would like to figure out how to
> 1) send important bugfixes upstream after rc1, and
> 2) not hold up development commits to xfs/master, while
> 3) avoiding conflicts like this.

Avoiding conflicts isn't that important. Getting too many of them
implies that there is something odd going on. But a few conflicts due
to upstream bugfixes are basically "normal". Judging by the merge I
see, there wasn't anything complicated going on.

                           Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
