Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 39A337CA1
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 05:31:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A7940AC001
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 03:30:58 -0700 (PDT)
Received: from mail-pa0-f65.google.com (mail-pa0-f65.google.com
	[209.85.220.65]) by cuda.sgi.com with ESMTP id AAFnmwpQ9RW4Uxb2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 Jun 2016 03:30:56 -0700 (PDT)
Received: by mail-pa0-f65.google.com with SMTP id fg1so3672767pad.3
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 03:30:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160622082332.GH28212@redhat.com>
References: <1466568697.14061.1.camel@gmail.com>
	<20160622063943.GU12670@dastard>
	<20160622082332.GH28212@redhat.com>
From: Kaho Ng <ngkaho1234@gmail.com>
Date: Wed, 22 Jun 2016 18:30:55 +0800
Message-ID: <CAGeO4WNP-HPO-Wt-yyT4D4iWKH3cg561x_Zrt1V3Dw1_LuQngw@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: indentation fix in xfs_btree_get_iroot()
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
To: Dave Chinner <david@fromorbit.com>, Kaho Ng <ngkaho1234@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, cmaiolino@redhat.com

Thanks for the suggestion. I am going to tidy up the things and resend it.

2016-06-22 16:23 GMT+08:00 Carlos Maiolino <cmaiolino@redhat.com>:
> On Wed, Jun 22, 2016 at 04:39:43PM +1000, Dave Chinner wrote:
>> On Wed, Jun 22, 2016 at 12:11:37PM +0800, Kaho Ng wrote:
>> > The indentation in this function is different from the other functions.
>> > Those spacebars are converted to tabs to improve readability.
>> >
>> > Signed-off-by: Kaho Ng <ngkaho1234@gmail.com>
>> > ---
>> >  fs/xfs/libxfs/xfs_btree.c | 8 ++++----
>> >  1 file changed, 4 insertions(+), 4 deletions(-)
>> >
>> > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
>> > index 1f88e1c..4f84dde 100644
>> > --- a/fs/xfs/libxfs/xfs_btree.c
>> > +++ b/fs/xfs/libxfs/xfs_btree.c
>> > @@ -543,12 +543,12 @@ xfs_btree_ptr_addr(
>> >   */
>> >  STATIC struct xfs_btree_block *
>> >  xfs_btree_get_iroot(
>> > -       struct xfs_btree_cur    *cur)
>> > +   struct xfs_btree_cur    *cur)
>> >  {
>> > -       struct xfs_ifork        *ifp;
>> > +   struct xfs_ifork        *ifp;
>> >
>> > -       ifp = XFS_IFORK_PTR(cur->bc_private.b.ip, cur-
>> > >bc_private.b.whichfork);
>> > -       return (struct xfs_btree_block *)ifp->if_broot;
>> > +   ifp = XFS_IFORK_PTR(cur->bc_private.b.ip, cur-
>> > >bc_private.b.whichfork);
>> > +   return (struct xfs_btree_block *)ifp->if_broot;
>> >  }
>>
>> That's better, but your mailer is still doing weird things to the
>> patch. It line wrapped it this time, and converted all the spaces to
>> some wierd multi-byte character instead of a plain ascii space.
>>
>> What you should do is send the patch to yourself, extract it from
>> the email you receive, and try to apply it to a clean tree. If you
>> can do that, then the patch is not getting mangled when you send it.
>> See Documentation/SubmittingPatches and
>> Documentation/email-clients.txt for help.
>>
>
> This is a problem when sending patches from a gmail account. It's converted to a
> base64 format, instead of pure clean text.
>
> I'd setup git to send the patch through the gmail smtp using git send-email. So
> it won't screw up with the file format. Well, at least, that's what I do when I
> need to send patches through a gmail account :)
>
> --
> Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
