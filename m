Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA39xKtZ257406 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 04:59:20 -0500
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CFC7221C2A4
	for <xfs@oss.sgi.com>; Thu,  3 Nov 2011 02:59:19 -0700 (PDT)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id tAslLzgOCSTU73F5
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 02:59:19 -0700 (PDT)
Received: by faai28 with SMTP id i28so1465719faa.26
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 02:59:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20111103070246.GA10579@infradead.org>
References: <CADDb1s0WUfvt8N+hMATboKxbMUZdk2N-R2e=KFH2JvGUjbigBg@mail.gmail.com>
	<20111103070246.GA10579@infradead.org>
Date: Thu, 3 Nov 2011 15:29:18 +0530
Message-ID: <CADDb1s3UN4HMKEA2kSEM0HsUCC7DE63B1oJAoL6QpqXBdDCEqQ@mail.gmail.com>
Subject: Re: [Patch] xfs: serialise unaligned direct IOs
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Thanks Chrisoph for the suggestions.

On Thu, Nov 3, 2011 at 12:32 PM, Christoph Hellwig <hch@infradead.org> wrot=
e:
> On Thu, Nov 03, 2011 at 11:37:03AM +0530, Amit Sahrawat wrote:
>> This is needed for long term kernel 2.6.35.14.
>> Please let me know for any changes/suggestions.
>
> It sounds like a fine candidate to backport, although the context
> differs a lot from the actual changes commited to mainline. =A0A few
> comments below:
>
>> they are overlapping IO and the result of concurrent overlapping IOs
>> is undefined - the result of either IO is a valid result so we let
>> them race. Hence we only penalise unaligned IO, which already has a
>> major overhead compared to aligned IO so this isn't a major problem.
>>
>
> You probably should keep the original Signoff and reviewed-by tags,
> and add your editor note on the top into [ ] =A0brackets.
Ok, will do so in the final patch. Actually was unaware of information
to keep in backported patches?
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!need_i_mutex && ( unaligned_io || mapping=
->nrpages || pos >
>> ip->i_size)) {
>
> no space after the opening brace please, and split overly-long lines
> into two:
Probably running checkpatch.pl will help.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!need_i_mutex &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unaligned_io || mapping->nrpages =
|| pos > ip->i_size)) {
>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (need_i_mutex) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* demote the lock now the cac=
hed pages are gone */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_ilock_demote(ip, XFS_IOLOC=
K_EXCL);
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unaligned_io)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_ioend_wait=
(ip);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* demote the lock now the cach=
ed pages are gone if we can */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_ilock_demo=
te(ip, XFS_IOLOCK_EXCL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iolock =3D XFS=
_IOLOCK_SHARED;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>
> Please use the comment that was used upstream here:
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * If we are doing unalign=
ed IO, wait for all other IO
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * to drain, otherwise dem=
ote the lock if we had to
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * flush cached pages.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&inode->i_mutex=
);
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iolock =3D XFS_IOLOCK_SHARED;
>
>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 need_i_mutex =3D 0;
>
> You also need to make the i_mutex unlock and need_i_mutex update
> conditional here, otherwise you still serialize all O_DIRECT writes.
>
you mean, keeping need_i_mutex=3D0 and mutex_unlock as part of 'else' state=
ment.


Thanks & Regards,
Amit Sahrawat

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
