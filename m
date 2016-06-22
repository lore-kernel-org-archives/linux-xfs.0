Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 92FBB7CA3
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 01:39:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E2F26AC002
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 23:39:49 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	LvQftz0TtDpMGNMj for <xfs@oss.sgi.com>;
	Tue, 21 Jun 2016 23:39:47 -0700 (PDT)
Date: Wed, 22 Jun 2016 16:39:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: indentation fix in xfs_btree_get_iroot()
Message-ID: <20160622063943.GU12670@dastard>
References: <1466568697.14061.1.camel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1466568697.14061.1.camel@gmail.com>
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
To: Kaho Ng <ngkaho1234@gmail.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Jun 22, 2016 at 12:11:37PM +0800, Kaho Ng wrote:
> The indentation in this function is different from the other functions.
> Those spacebars are converted to tabs to improve readability.
> =

> Signed-off-by: Kaho Ng <ngkaho1234@gmail.com>
> ---
> =A0fs/xfs/libxfs/xfs_btree.c | 8 ++++----
> =A01 file changed, 4 insertions(+), 4 deletions(-)
> =

> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 1f88e1c..4f84dde 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -543,12 +543,12 @@ xfs_btree_ptr_addr(
> =A0 */
> =A0STATIC struct xfs_btree_block *
> =A0xfs_btree_get_iroot(
> -=A0=A0=A0=A0=A0=A0=A0struct xfs_btree_cur=A0=A0=A0=A0*cur)
> +	struct xfs_btree_cur	*cur)
> =A0{
> -=A0=A0=A0=A0=A0=A0=A0struct xfs_ifork=A0=A0=A0=A0=A0=A0=A0=A0*ifp;
> +	struct xfs_ifork	*ifp;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0ifp =3D XFS_IFORK_PTR(cur->bc_private.b.ip, cur-
> >bc_private.b.whichfork);
> -=A0=A0=A0=A0=A0=A0=A0return (struct xfs_btree_block *)ifp->if_broot;
> +	ifp =3D XFS_IFORK_PTR(cur->bc_private.b.ip, cur-
> >bc_private.b.whichfork);
> +	return (struct xfs_btree_block *)ifp->if_broot;
> =A0}

That's better, but your mailer is still doing weird things to the
patch. It line wrapped it this time, and converted all the spaces to
some wierd multi-byte character instead of a plain ascii space.

What you should do is send the patch to yourself, extract it from
the email you receive, and try to apply it to a clean tree. If you
can do that, then the patch is not getting mangled when you send it.
See Documentation/SubmittingPatches and
Documentation/email-clients.txt for help.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
