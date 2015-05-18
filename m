Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6A3447F56
	for <xfs@oss.sgi.com>; Mon, 18 May 2015 16:37:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3E3BE304053
	for <xfs@oss.sgi.com>; Mon, 18 May 2015 14:37:23 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	QEDmIYHxFOIf4Ljw for <xfs@oss.sgi.com>;
	Mon, 18 May 2015 14:37:17 -0700 (PDT)
Date: Tue, 19 May 2015 07:37:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4 linux-next] xfs: use swap() in
	xfs_dir2_leafn_rebalance()
Message-ID: <20150518213714.GV15721@dastard>
References: <1431969231-12834-1-git-send-email-fabf@skynet.be>
	<20150518171946.GY7232@ZenIV.linux.org.uk>
	<1618479490.17551.1431972373169.open-xchange@webmail.nmp.proximus.be>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1618479490.17551.1431972373169.open-xchange@webmail.nmp.proximus.be>
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
To: Fabian Frederick <fabf@skynet.be>
Cc: xfs@oss.sgi.com, Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org

On Mon, May 18, 2015 at 08:06:13PM +0200, Fabian Frederick wrote:
> =

> =

> > On 18 May 2015 at 19:19 Al Viro <viro@ZenIV.linux.org.uk> wrote:
> >
> >
> > On Mon, May 18, 2015 at 07:13:48PM +0200, Fabian Frederick wrote:
> > >=A0 =A0 =A0 * If the block order is wrong, swap the arguments.
> > >=A0 =A0 =A0 */
> > > -=A0 =A0if ((swap =3D xfs_dir2_leafn_order(dp, blk1->bp, blk2->bp))) {
> > > -=A0 =A0 =A0 =A0 =A0 =A0xfs_da_state_blk_t=A0 =A0 =A0 *tmp;=A0 =A0/* =
temp for block swap */
> > > +=A0 =A0swap =3D xfs_dir2_leafn_order(dp, blk1->bp, blk2->bp);
> > > +=A0 =A0if (swap)
> > > +=A0 =A0 =A0 =A0 =A0 =A0swap(blk1, blk2);
> >
> > Egads...=A0 Have you even read what you'd written?=A0 Yes, sure, prepro=
cessor
> > will do the right thing, but it's a very noticable annoyance for somebo=
dy
> > reading that.=A0 Rename the bleeding flag, please.
> =

> I wanted to focus on the swap() update in this small patchset (some other=
 things
> should be done in there like have xfs_dir2_leafn_order() return bool) but=
 I can
> rename it in something like need_swap. Do I need to resend the 4 patches =
Dave ?

4 patches is 3 patches too many for noise like this.  Anyway, two of
the patches have the same local "swap" variable problem; the context
is "swap order" not "need swap".

FWIW, I am not a fan of changing the code for no actual gain - the
compiled code is identical, there are no stack savings, and now I
have to look at an extra file to work out what the code does. If
you're changing the code and this is prep work for a large series,
then by all means clean the code up. But otherwise, changes like
this just mean work that other developers have in progress need
rebasing....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
