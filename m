Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34526 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730080AbfC3AUi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Mar 2019 20:20:38 -0400
Received: by mail-pf1-f194.google.com with SMTP id b3so1794664pfd.1
        for <linux-xfs@vger.kernel.org>; Fri, 29 Mar 2019 17:20:37 -0700 (PDT)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <00FBAF35-490D-435F-ABD5-1DC7B4D4C649@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_8402BD59-B1DC-4D46-9A97-DCD8810AD300";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v3 2/3] block: verify data when endio
Date: Fri, 29 Mar 2019 18:20:32 -0600
In-Reply-To: <73ecbb57-fd99-5df3-8859-e218b830363b@oracle.com>
References: <20190329142346.1677-1-bob.liu@oracle.com>
 <20190329142346.1677-3-bob.liu@oracle.com>
 <41c8688a-65bd-96ac-9b23-4facd0ade4a7@kernel.dk>
 <73ecbb57-fd99-5df3-8859-e218b830363b@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bob Liu <bob.liu@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Martin Petersen <martin.petersen@oracle.com>, shirley.ma@oracle.com, Allison Henderson <allison.henderson@oracle.com>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, Li Dongyang <dongyangli@ddn.com>, Li Xi <lixi@ddn.com>


--Apple-Mail=_8402BD59-B1DC-4D46-9A97-DCD8810AD300
Content-Type: multipart/mixed;
	boundary="Apple-Mail=_E24C7EA4-B569-4518-B551-5F4C92331809"


--Apple-Mail=_E24C7EA4-B569-4518-B551-5F4C92331809
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Mar 29, 2019, at 8:40 AM, Bob Liu <bob.liu@oracle.com> wrote:
>=20
> On 3/29/19 10:28 PM, Jens Axboe wrote:
>> On 3/29/19 8:23 AM, Bob Liu wrote:
>>> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
>>> index d66bf5f32610..e9f25f162138 100644
>>> --- a/include/linux/blk_types.h
>>> +++ b/include/linux/blk_types.h
>>> @@ -18,6 +18,7 @@ struct block_device;
>>> struct io_context;
>>> struct cgroup_subsys_state;
>>> typedef void (bio_end_io_t) (struct bio *);
>>> +typedef int (bio_verifier_t) (struct bio *);
>>>=20
>>> /*
>>>  * Block error status values.  See block/blk-core:blk_errors for the =
details.
>>> @@ -187,6 +188,8 @@ struct bio {
>>> 		struct bio_integrity_payload *bi_integrity; /* data =
integrity */
>>> #endif
>>> 	};
>>> +	bio_verifier_t		*bi_verifier;	/* verify callback when =
endio */
>>> +	struct work_struct      bi_work;	/* I/O completion */
>>>=20
>>> 	unsigned short		bi_vcnt;	/* how many bio_vec's */
>>=20
>> I told you this for the initial posting, and the objection still =
stands.
>> Adding 40 bytes to struct bio is a no-go.
>=20
> Yes, I know that.
> Already list in Todo:
> - union with "struct bio_integrity_payload *bi_integrity" to save bio =
space.
>=20
> This is only a rfc patch, because not sure any other objection of this =
passdown-verify solution..
> Will consider more about the bio space if there is agreement of the =
passdown-verify way.

It is best if "rfc patch" is labelled with "RFC" in the subject when =
there are known
TODO issues with the patch, to avoid this kind of confusion... :-)


I worked on a similar patch that adds generate and verify callback =
functions to struct
bio_integrity_payload rather than directly in the bio, to avoid =
increasing bio size.

This was implemented by registering the callback functions via =
bio_integrity_prep_fn()
and stored them in bio_integrity_payload before the bio_submit() was =
called, rather
than passing them down the call stack as would be needed here.

This would allow having a per-bio callback without the changing the =
whole callchain.
Instead of XFS calling the new bio_submit_verify(), it calls =
bio_integrity_prep_fn(),
which doesn't seem materially different in terms of code complexity =
(i.e. there will
still need to be some changes to XFS but it doesn't affect other code).

I've attached the patch below.  It was based on an older kernel and I've =
just done a
quick port to the latest kernel (untested), so it is entirely possible =
that there is
some breakage but it shows the general approach.

Cheers, Andreas



--Apple-Mail=_E24C7EA4-B569-4518-B551-5F4C92331809
Content-Disposition: attachment;
	filename=0001-block-add-optional-integrity-callbacks-for-bio.patch
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="0001-block-add-optional-integrity-callbacks-for-bio.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=201d999a8597f93ff36d4fbe08ba3a68f81baa5f10=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20Andreas=20Dilger=20<adilger@dilger.ca>=0ADate:=20=
Fri,=2029=20Mar=202019=2017:58:56=20-0600=0ASubject:=20[RFC=20PATCH]=20=
block:=20add=20optional=20integrity=20callbacks=20for=20bio=0A=0AAdd=20=
optional=20integrity=20generate=20and=20verify=20callback=20functions=20=
for=0Aa=20submitted=20bio.=20=20The=20callbacks=20are=20passed=20to=20=
bio_integrity_prep()=0Aand=20bio_integrity_alloc()=20and=20stored=20in=20=
struct=20bio_integrity_payload=0Arather=20than=20the=20bio=20to=20avoid=20=
increasing=20the=20size=20of=20struct=20bio=20when=0Athey=20are=20not=20=
needed.=0A=0AThe=20per-bio=20integrity=20generate=20and=20verify=20=
functions=20take=20priority=0Aover=20the=20ones=20registered=20on=20the=20=
block=20device.=0A=0ASigned-off-by:=20Li=20Xi=20<lixi@ddn.com>=0A=
Signed-off-by:=20Li=20Dongyang=20<dongyangli@ddn.com>=0ASigned-off-by:=20=
Andreas=20Dilger=20<adilger@dilger.ca>=0A---=0A=20block/bio-integrity.c=20=
=20|=2085=20++++++++++++++++++++++++++++++++++++--------------=0A=20=
include/linux/bio.h=20=20=20=20|=20=204=20+++=0A=20=
include/linux/blkdev.h=20|=20=202=20++=0A=203=20files=20changed,=2068=20=
insertions(+),=2023=20deletions(-)=0A=0Adiff=20--git=20=
a/block/bio-integrity.c=20b/block/bio-integrity.c=0Aindex=20=
1b633a3..5e670ad=20100644=0A---=20a/block/bio-integrity.c=0A+++=20=
b/block/bio-integrity.c=0A@@=20-39,18=20+39,23=20@@=20void=20=
blk_flush_integrity(void)=0A=20}=0A=20=0A=20/**=0A-=20*=20=
bio_integrity_alloc=20-=20Allocate=20integrity=20payload=20and=20attach=20=
it=20to=20bio=0A+=20*=20bio_integrity_alloc_fn=20-=20Allocate=20=
integrity=20payload=20and=20attach=20it=20to=20bio=0A=20=20*=20@bio:=09=
bio=20to=20attach=20integrity=20metadata=20to=0A=20=20*=20@gfp_mask:=09=
Memory=20allocation=20mask=0A=20=20*=20@nr_vecs:=09Number=20of=20=
integrity=20metadata=20scatter-gather=20elements=0A+=20*=20@generate_fn:=20=
Optional=20callback=20function=20to=20generate=20integrity=20data=20on=20=
write=0A+=20*=20@verify_fn=09Optional=20callback=20function=20to=20=
verify=20integrity=20data=20on=20read=0A=20=20*=0A=20=20*=20Description:=20=
This=20function=20prepares=20a=20bio=20for=20attaching=20integrity=0A-=20=
*=20metadata.=20=20nr_vecs=20specifies=20the=20maximum=20number=20of=20=
pages=20containing=0A-=20*=20integrity=20metadata=20that=20can=20be=20=
attached.=0A+=20*=20metadata.=20=20@nr_vecs=20specifies=20the=20maximum=20=
number=20of=20pages=20containing=0A+=20*=20integrity=20metadata=20that=20=
can=20be=20attached.=20=20If=20the=20@generate_fn=20and/or=0A+=20*=20=
@verify_fn=20are=20not=20NULL,=20then=20they=20will=20be=20stored=20in=20=
bio_integrity_payload=0A+=20*=20for=20use=20when=20bio_integrity_prep()=20=
and=20bio_integrity_verify()=20are=20called.=0A=20=20*/=0A-struct=20=
bio_integrity_payload=20*bio_integrity_alloc(struct=20bio=20*bio,=0A-=09=09=
=09=09=09=09=20=20gfp_t=20gfp_mask,=0A-=09=09=09=09=09=09=20=20unsigned=20=
int=20nr_vecs)=0A+struct=20bio_integrity_payload=20=
*bio_integrity_alloc_fn(struct=20bio=20*bio,=0A+=09=09=09=09=09gfp_t=20=
gfp_mask,=20unsigned=20int=20nr_vecs,=0A+=09=09=09=09=09=
integrity_processing_fn=20*generate_fn,=0A+=09=09=09=09=09=
integrity_processing_fn=20*verify_fn)=0A=20{=0A=20=09struct=20=
bio_integrity_payload=20*bip;=0A=20=09struct=20bio_set=20*bs=20=3D=20=
bio->bi_pool;=0A@@=20-85,6=20+90,8=20@@=20struct=20bio_integrity_payload=20=
*bio_integrity_alloc(struct=20bio=20*bio,=0A=20=09}=0A=20=0A=20=09=
bip->bip_bio=20=3D=20bio;=0A+=09bip->bip_generate_fn=20=3D=20=
generate_fn;=0A+=09bip->bip_verify_fn=20=3D=20verify_fn;=0A=20=09=
bio->bi_integrity=20=3D=20bip;=0A=20=09bio->bi_opf=20|=3D=20=
REQ_INTEGRITY;=0A=20=0A@@=20-93,6=20+100,14=20@@=20struct=20=
bio_integrity_payload=20*bio_integrity_alloc(struct=20bio=20*bio,=0A=20=09=
mempool_free(bip,=20&bs->bio_integrity_pool);=0A=20=09return=20=
ERR_PTR(-ENOMEM);=0A=20}=0A+EXPORT_SYMBOL(bio_integrity_allocfn);=0A+=0A=
+struct=20bio_integrity_payload=20*bio_integrity_alloc(struct=20bio=20=
*bio,=0A+=09=09=09=09=09=09=20=20gfp_t=20gfp_mask,=0A+=09=09=09=09=09=09=20=
=20unsigned=20int=20nr_vecs)=0A+{=0A+=09return=20=
bio_integrity_alloc_fn(bio,=20gfp_mask,=20nr_vecs,=20NULL,=20NULL);=0A+}=0A=
=20EXPORT_SYMBOL(bio_integrity_alloc);=0A=20=0A=20/**=0A@@=20-187,6=20=
+202,8=20@@=20static=20blk_status_t=20bio_integrity_process(struct=20bio=20=
*bio,=0A=20=0A=20=09=09iter.data_buf=20=3D=20kaddr=20+=20bv.bv_offset;=0A=
=20=09=09iter.data_size=20=3D=20bv.bv_len;=0A+=09=09iter.bio=20=3D=20=
bio;=0A+=09=09iter.bi_idx=20=3D=20proc_iter->bi_idx;=0A=20=0A=20=09=09=
ret=20=3D=20proc_fn(&iter);=0A=20=09=09if=20(ret)=20{=0A@@=20-200,18=20=
+217,23=20@@=20static=20blk_status_t=20bio_integrity_process(struct=20=
bio=20*bio,=0A=20}=0A=20=0A=20/**=0A-=20*=20bio_integrity_prep=20-=20=
Prepare=20bio=20for=20integrity=20I/O=0A-=20*=20@bio:=09bio=20to=20=
prepare=0A+=20*=20bio_integrity_prep_fn=20-=20Prepare=20bio=20for=20=
integrity=20I/O=0A+=20*=20@bio:=09=09bio=20to=20prepare=0A+=20*=20=
@generate_fn:=09optional=20function=20called=20on=20write=20to=20=
generate=20integrity=0A+=20*=20@verify_fn:=09=09optional=20function=20=
called=20on=20read=20to=20verify=20integrity=0A=20=20*=0A=20=20*=20=
Description:=20=20Checks=20if=20the=20bio=20already=20has=20an=20=
integrity=20payload=20attached.=0A=20=20*=20If=20it=20does,=20the=20=
payload=20has=20been=20generated=20by=20another=20kernel=20subsystem,=0A=20=
=20*=20and=20we=20just=20pass=20it=20through.=20Otherwise=20allocates=20=
integrity=20payload.=0A=20=20*=20The=20bio=20must=20have=20data=20=
direction,=20target=20device=20and=20start=20sector=20set=20priot=0A=20=20=
*=20to=20calling.=20=20In=20the=20WRITE=20case,=20integrity=20metadata=20=
will=20be=20generated=20using=0A-=20*=20the=20block=20device's=20=
integrity=20function.=20=20In=20the=20READ=20case,=20the=20buffer=0A-=20=
*=20will=20be=20prepared=20for=20DMA=20and=20a=20suitable=20end_io=20=
handler=20set=20up.=0A+=20*=20either=20the=20passed-in=20@generate_fn=20=
(if=20set),=20the=20payload=20generate_fn=20(if=0A+=20*=20set),=20or=20=
the=20block=20device's=20integrity=20function.=20=20In=20the=20READ=20=
case,=20the=0A+=20*=20buffer=20will=20be=20prepared=20for=20DMA=20and=20=
a=20suitable=20end_io=20handler=20set=20up.=0A=20=20*/=0A-bool=20=
bio_integrity_prep(struct=20bio=20*bio)=0A+bool=20=
bio_integrity_prep_fn(struct=20bio=20*bio,=0A+=09=09=09=20=20=20=
integrity_processing_fn=20*generate_fn,=0A+=09=09=09=20=20=20=
integrity_processing_fn=20*verify_fn)=0A=20{=0A=20=09struct=20=
bio_integrity_payload=20*bip;=0A=20=09struct=20blk_integrity=20*bi=20=3D=20=
blk_get_integrity(bio->bi_disk);=0A@@=20-236,13=20+258,21=20@@=20bool=20=
bio_integrity_prep(struct=20bio=20*bio)=0A=20=09if=20=
(bio_integrity(bio))=0A=20=09=09return=20true;=0A=20=0A-=09if=20=
(bio_data_dir(bio)=20=3D=3D=20READ)=20{=0A-=09=09if=20=
(!bi->profile->verify_fn=20||=0A-=09=09=20=20=20=20!(bi->flags=20&=20=
BLK_INTEGRITY_VERIFY))=0A+=09if=20(bio_data_dir(bio)=20=3D=3D=20WRITE)=20=
{=0A+=09=09if=20(!generate_fn)=20{=0A+=09=09=09generate_fn=20=3D=20=
bip->bip_generate_fn;=0A+=09=09=09if=20(!generate_fn)=0A+=09=09=09=09=
generate_fn=20=3D=20bi->profile->generate_fn;=0A+=09=09}=0A+=09=09if=20=
(!generate_fn=20||=20!(bi->flags=20&=20BLK_INTEGRITY_GENERATE))=0A=20=09=09=
=09return=20true;=0A=20=09}=20else=20{=0A-=09=09if=20=
(!bi->profile->generate_fn=20||=0A-=09=09=20=20=20=20!(bi->flags=20&=20=
BLK_INTEGRITY_GENERATE))=0A+=09=09if=20(!verify_fn)=20{=0A+=09=09=09=
verify_fn=20=3D=20bip->bip_verify_fn;=0A+=09=09=09if=20(!verify_fn)=0A+=09=
=09=09=09verify_fn=20=3D=20bi->profile->verify_fn;=0A+=09=09}=0A+=09=09=
if=20(!verify_fn=20||=20!(bi->flags=20&=20BLK_INTEGRITY_VERIFY))=0A=20=09=
=09=09return=20true;=0A=20=09}=0A=20=09intervals=20=3D=20=
bio_integrity_intervals(bi,=20bio_sectors(bio));=0A@@=20-261,7=20+291,8=20=
@@=20bool=20bio_integrity_prep(struct=20bio=20*bio)=0A=20=09nr_pages=20=3D=
=20end=20-=20start;=0A=20=0A=20=09/*=20Allocate=20bio=20integrity=20=
payload=20and=20integrity=20vectors=20*/=0A-=09bip=20=3D=20=
bio_integrity_alloc(bio,=20GFP_NOIO,=20nr_pages);=0A+=09bip=20=3D=20=
bio_integrity_alloc_fn(bio,=20GFP_NOIO,=20nr_pages,=20generate_fn,=0A+=09=
=09=09=09=20=20=20=20=20verify_fn);=0A=20=09if=20(IS_ERR(bip))=20{=0A=20=09=
=09printk(KERN_ERR=20"could=20not=20allocate=20data=20integrity=20=
bioset\n");=0A=20=09=09kfree(buf);=0A@@=20-303,12=20+334,11=20@@=20bool=20=
bio_integrity_prep(struct=20bio=20*bio)=0A=20=09}=0A=20=0A=20=09/*=20=
Auto-generate=20integrity=20metadata=20if=20this=20is=20a=20write=20*/=0A=
-=09if=20(bio_data_dir(bio)=20=3D=3D=20WRITE)=20{=0A-=09=09=
bio_integrity_process(bio,=20&bio->bi_iter,=0A-=09=09=09=09=20=20=20=20=20=
=20bi->profile->generate_fn);=0A-=09}=20else=20{=0A+=09if=20=
(bio_data_dir(bio)=20=3D=3D=20WRITE)=0A+=09=09bio_integrity_process(bio,=20=
&bio->bi_iter,=20generate_fn);=0A+=09else=0A=20=09=09bip->bio_iter=20=3D=20=
bio->bi_iter;=0A-=09}=0A+=0A=20=09return=20true;=0A=20=0A=20err_end_io:=0A=
@@=20-317,6=20+347,12=20@@=20bool=20bio_integrity_prep(struct=20bio=20=
*bio)=0A=20=09return=20false;=0A=20=0A=20}=0A=
+EXPORT_SYMBOL(bio_integrity_prep_fn);=0A+=0A+bool=20=
bio_integrity_prep(struct=20bio=20*bio)=0A+{=0A+=09return=20=
bio_integrity_prep_fn(bio,=20NULL,=20NULL);=0A+}=0A=20=
EXPORT_SYMBOL(bio_integrity_prep);=0A=20=0A=20/**=0A@@=20-340,7=20+376,8=20=
@@=20static=20void=20bio_integrity_verify_fn(struct=20work_struct=20=
*work)=0A=20=09=20*=20it's=20original=20position.=0A=20=09=20*/=0A=20=09=
bio->bi_status=20=3D=20bio_integrity_process(bio,=20&bip->bio_iter,=0A-=09=
=09=09=09=09=09bi->profile->verify_fn);=0A+=09=09=09=09=09=20=20=20=20=20=
=20=20bip->bip_verify_fn=20?:=0A+=09=09=09=09=09=20=20=20=20=20=20=20=
bi->profile->verify_fn);=0A=20=09bio_integrity_free(bio);=0A=20=09=
bio_endio(bio);=0A=20}=0A@@=20-431,6=20+468,8=20@@=20int=20=
bio_integrity_clone(struct=20bio=20*bio,=20struct=20bio=20*bio_src,=0A=20=
=0A=20=09bip->bip_vcnt=20=3D=20bip_src->bip_vcnt;=0A=20=09bip->bip_iter=20=
=3D=20bip_src->bip_iter;=0A+=09bip->bip_generate_fn=20=3D=20=
bip_src->bip_generate_fn;=0A+=09bip->bip_verify_fn=20=3D=20=
bip_src->bip_verify_fn;=0A=20=0A=20=09return=200;=0A=20}=0Adiff=20--git=20=
a/include/linux/bio.h=20b/include/linux/bio.h=0Aindex=20bb6090a..79e0c2f=20=
100644=0A---=20a/include/linux/bio.h=0A+++=20b/include/linux/bio.h=0A@@=20=
-315,6=20+315,8=20@@=20struct=20bio_integrity_payload=20{=0A=20=09struct=20=
work_struct=09bip_work;=09/*=20I/O=20completion=20*/=0A=20=0A=20=09=
struct=20bio_vec=09=09*bip_vec;=0A+=09integrity_processing_fn=09=
*bip_generate_fn;=20=20/*=20called=20on=20write=20*/=0A+=09=
integrity_processing_fn=09*bip_verify_fn;=09=20=20=20/*=20called=20on=20=
read=20*/=0A=20=09struct=20bio_vec=09=09bip_inline_vecs[0];/*=20embedded=20=
bvec=20array=20*/=0A=20};=0A=20=0A@@=20-754,8=20+756,10=20@@=20static=20=
inline=20bool=20bioset_initialized(struct=20bio_set=20*bs)=0A=20=09=09=
bip_for_each_vec(_bvl,=20_bio->bi_integrity,=20_iter)=0A=20=0A=20extern=20=
struct=20bio_integrity_payload=20*bio_integrity_alloc(struct=20bio=20*,=20=
gfp_t,=20unsigned=20int);=0A+extern=20struct=20bio_integrity_payload=20=
*bio_integrity_alloc_fn(struct=20bio=20*,=20gfp_t,=20unsigned=20int,=20=
integrity_processing_fn=20*generate_fn,=20integrity_processing_fn=20=
*verify_fn);=0A=20extern=20int=20bio_integrity_add_page(struct=20bio=20=
*,=20struct=20page=20*,=20unsigned=20int,=20unsigned=20int);=0A=20extern=20=
bool=20bio_integrity_prep(struct=20bio=20*);=0A+extern=20bool=20=
bio_integrity_prep_fn(struct=20bio=20*,=20integrity_processing_fn=20=
*generate_fn,=20integrity_processing_fn=20*verify_fn);=0A=20extern=20=
void=20bio_integrity_advance(struct=20bio=20*,=20unsigned=20int);=0A=20=
extern=20void=20bio_integrity_trim(struct=20bio=20*);=0A=20extern=20int=20=
bio_integrity_clone(struct=20bio=20*,=20struct=20bio=20*,=20gfp_t);=0A=
diff=20--git=20a/include/linux/blkdev.h=20b/include/linux/blkdev.h=0A=
index=205c58a3b..be9a833=20100644=0A---=20a/include/linux/blkdev.h=0A+++=20=
b/include/linux/blkdev.h=0A@@=20-1471,7=20+1471,9=20@@=20struct=20=
blk_integrity_iter=20{=0A=20=09sector_t=09=09seed;=0A=20=09unsigned=20=
int=09=09data_size;=0A=20=09unsigned=20short=09=09interval;=0A+=09=
unsigned=20short=09=09bi_idx;=0A=20=09const=20char=09=09*disk_name;=0A+=09=
struct=20bio=09=09*bio;=0A=20};=0A=20=0A=20typedef=20blk_status_t=20=
(integrity_processing_fn)=20(struct=20blk_integrity_iter=20*);=0A--=20=0A=
1.8.0=0A=0A=

--Apple-Mail=_E24C7EA4-B569-4518-B551-5F4C92331809--

--Apple-Mail=_8402BD59-B1DC-4D46-9A97-DCD8810AD300
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlyetlEACgkQcqXauRfM
H+C5cg//bpVQPIBEVN8zxOWVyPujtn1666yaeMuRrlg7sQtTFWqZr7VHKTuisoRu
oF0Q0kwGZAKoMxlj7j7bXEXjqkY5Qhx83n4yW0na4PO5drPaoocS4g2Xda+UxcyP
/45pOPd2QPaWxsGRf2ZfmHFxFUOzYyo9YRkWd8VSqXqhpA1RO95L3aZ6UICNdTrL
G+Q8X3vzl3GHi/65NUMWMOEYquwemGdVyrDC183xgEouKmezLlsgI2yg3I16HcMj
p2H4CB4xDKVLBnvD8CFB5GGCCUKp5avRBibTkd2Dx44DCtIHnGYtbVeaWpYpRlll
t/3psZRlGCoIPlJXosxDydcJAecH8VD+DxjUd6HyNhpNt+fB5HvWmo/q+fLBlpr/
iI6jecCbNBVpmXMZ2ikX4J87Kpt4o+VVMJWv5eWpUJd0zrTPHkt8iqByBNDjsvLU
nbX0kHQ8DhfXZa2dTK0L0o2Z7KW84NGz76RnnZNWGqsvAIiLvHiG7mYGEDN1TIgB
QihOKx+ZW74ef/ohrxduh6LEj9RINUehGcsRBQL1KMaM8XDlvAv0niROoFBJ6dhT
6vZe0sdK/TD+SfObE3QxC4XsnTz4Sxzpf3ZP1H3F9sUg79zHHQGrmiCZPLm6PirS
d9VhqAMhgBLIcC81z6uZIxFhxdYzWWO0IkwXLuRBmuD/0K4fN/U=
=WC7C
-----END PGP SIGNATURE-----

--Apple-Mail=_8402BD59-B1DC-4D46-9A97-DCD8810AD300--
