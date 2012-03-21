Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2LM6jfG127139 for <xfs@oss.sgi.com>; Wed, 21 Mar 2012 17:06:45 -0500
Date: Wed, 21 Mar 2012 17:06:52 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [GIT PULL] XFS update for 3.4-rc1
Message-ID: <20120321220652.GJ8451@sgi.com>
References: <20120321183613.2C93F426DA7@whiskey.americas.sgi.com>
	<CA+55aFyz5UWiJeeMbwZUZEscisZY5Jb0nADpJP6jWKwf3Uai1A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFyz5UWiJeeMbwZUZEscisZY5Jb0nADpJP6jWKwf3Uai1A@mail.gmail.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hey Linus,

On Wed, Mar 21, 2012 at 01:59:22PM -0700, Linus Torvalds wrote:
> On Wed, Mar 21, 2012 at 11:36 AM, Ben Myers <bpm@sgi.com> wrote:
> >
> > =A0 Please pull from git://oss.sgi.com/xfs/xfs for-linus
> =

> "Already up-to-date."
> =

> I'd assume you forgot to push, but in fact all the things you quote
> there seem to have been in 3.3 already. So the whole pull request
> seems stale.
> =

> Wazzup?

PEBKAC mostly.

xfs/master contains scalability improvements for dquots, log grant code
cleanups, plus bugfixes and cleanups large and small.

Unfortunately the stuff in:  git://oss.sgi.com/xfs/xfs master

Conflicts with the stuff in:  git://oss.sgi.com/xfs/xfs for-linus

I've resolved the conflict here:  git://oss.sgi.com/xfs/xfs for-linus-merged

I would like to figure out how to =

1) send important bugfixes upstream after rc1, and
2) not hold up development commits to xfs/master, while
3) avoiding conflicts like this.

Our old strategy was to hold off on development commits for awhile after
rc1, and I would like to avoid that.  It occured to me that
fast-forwarding xfs/master immediately to an important bugfix once it
has been pulled in to your tree might accomplish this, but clearly I
didn't get that figured out.

Thanks,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
