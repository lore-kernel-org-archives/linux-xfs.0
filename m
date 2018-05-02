Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-by2nam01on0114.outbound.protection.outlook.com ([104.47.34.114]:53782
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751262AbeEBO1l (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 May 2018 10:27:41 -0400
From: Robert Dorr <rdorr@microsoft.com>
Subject: RE: [PATCH 2/4] iomap: iomap_dio_rw() handles all sync writes
Date: Wed, 2 May 2018 14:27:37 +0000
Message-ID: <BN6PR21MB07409BC39716894D592EB0C0B8800@BN6PR21MB0740.namprd21.prod.outlook.com>
References: <20180418040828.18165-1-david@fromorbit.com>
 <20180418040828.18165-3-david@fromorbit.com>
 <20180421130309.efivmjo5ald2jchv@quack2.suse.cz>
 <20180502024540.GA23861@dastard>
In-Reply-To: <20180502024540.GA23861@dastard>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, Slava Oks <slavao@microsoft.com>, Jasraj Dange <jasrajd@microsoft.com>, Michael Nelson <micn@microsoft.com>, Amit Banerjee <amit.banerjee@microsoft.com>, Travis Wright <twright@microsoft.com>, Bob Ward <bobward@microsoft.com>, Scott Konersmann <scottkon@microsoft.com>

Thanks for your continued effort Dave.

In the current implementation the first write to the location updates the m=
etadata and must issue the flush.   In Windows SQL Server can avoid this be=
havior.   SQL Server can issue DeviceIoControl with SET_FILE_VALID_DATA and=
 then SetEndOfFile.  The SetEndOfFile acquires space and saves metadata wit=
hout requiring the actual write.   This allows us to quickly create a large=
 file and the writes do not need the added flush.

Is this something that fallocate could accommodate to avoid having to write=
 once (triggers flush for metadata) and then secondary writes can use FUA a=
nd avoid the flush?



-----Original Message-----
From: Dave Chinner <david@fromorbit.com>=20
Sent: Tuesday, May 1, 2018 9:46 PM
To: Jan Kara <jack@suse.cz>
Cc: linux-xfs@vger.kernel.org; linux-fsdevel@vger.kernel.org; linux-block@v=
ger.kernel.org; hch@lst.de; Robert Dorr <rdorr@microsoft.com>
Subject: Re: [PATCH 2/4] iomap: iomap_dio_rw() handles all sync writes

On Sat, Apr 21, 2018 at 03:03:09PM +0200, Jan Kara wrote:
> On Wed 18-04-18 14:08:26, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> >=20
> > Currently iomap_dio_rw() only handles (data)sync write completions=20
> > for AIO. This means we can't optimised non-AIO IO to minimise device=20
> > flushes as we can't tell the caller whether a flush is required or=20
> > not.
> >=20
> > To solve this problem and enable further optimisations, make=20
> > iomap_dio_rw responsible for data sync behaviour for all IO, not=20
> > just AIO.
> >=20
> > In doing so, the sync operation is now accounted as part of the DIO=20
> > IO by inode_dio_end(), hence post-IO data stability updates will no=20
> > long race against operations that serialise via inode_dio_wait()=20
> > such as truncate or hole punch.
> >=20
> > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
>=20
> Looks good to me. You can add:
>=20
> Reviewed-by: Jan Kara <jack@suse.cz>

It looks good, but it's broken in a subtle, nasty way. :/

> > @@ -768,14 +776,8 @@ static ssize_t iomap_dio_complete(struct=20
> > iomap_dio *dio)  static void iomap_dio_complete_work(struct=20
> > work_struct *work)  {
> >  	struct iomap_dio *dio =3D container_of(work, struct iomap_dio, aio.wo=
rk);
> > -	struct kiocb *iocb =3D dio->iocb;
> > -	bool is_write =3D (dio->flags & IOMAP_DIO_WRITE);
> > -	ssize_t ret;
> > =20
> > -	ret =3D iomap_dio_complete(dio);
> > -	if (is_write && ret > 0)
> > -		ret =3D generic_write_sync(iocb, ret);
> > -	iocb->ki_complete(iocb, ret, 0);
> > +	dio->iocb->ki_complete(dio->iocb, iomap_dio_complete(dio), 0);

This generates a use after free from KASAN from generic/016. it appears the=
 compiler orders the code so that it dereferences
dio->iocb after iomap_dio_complete() has freed the dio structure
(yay!).

I'll post a new version of the patchset now that I've got changes to
2 of the 3 remaining patches in it....

Cheers,

Dave.
--
Dave Chinner
david@fromorbit.com
