Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p82Eq3c0074726 for <xfs@oss.sgi.com>; Fri, 2 Sep 2011 09:52:04 -0500
Received: from nm3-vm0.bullet.mail.sg1.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 3B7B019734C5
	for <xfs@oss.sgi.com>; Fri,  2 Sep 2011 07:52:00 -0700 (PDT)
Received: from nm3-vm0.bullet.mail.sg1.yahoo.com
	(nm3-vm0.bullet.mail.sg1.yahoo.com [115.178.12.242]) by
	cuda.sgi.com with SMTP id 1xKzVxvHVQvJdvyH for
	<xfs@oss.sgi.com>; Fri, 02 Sep 2011 07:52:00 -0700 (PDT)
Message-ID: <1314975119.93913.YahooMailClassic@web77707.mail.sg1.yahoo.com>
Date: Fri, 2 Sep 2011 22:51:59 +0800 (SGT)
From: Gim Leong Chin <chingimleong@yahoo.com.sg>
Subject: Re: [PATCH] xfsdump: enable dump header checksums
In-Reply-To: <1314654106-28548-1-git-send-email-wkendall@sgi.com>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com, Bill Kendall <wkendall@sgi.com>

Hi Bill,


May I understand:

1) Are the check sums written in the dump file?
2) Which fields would have the check sums?
3) If the checksums at restore time do not agree with the fields, is there =
any kind of recovery action possible?

Thanks!


GL

--- On Tue, 30/8/11, Bill Kendall <wkendall@sgi.com> wrote:

> From: Bill Kendall <wkendall@sgi.com>
> Subject: [PATCH] xfsdump: enable dump header checksums
> To: xfs@oss.sgi.com
> Date: Tuesday, 30 August, 2011, 5:41 AM
> Various structures in a dump file
> optionally contain a checksum, but
> the code to compute and validate the checksum has not been
> enabled.
> The checksum code has a negligible performance impact and
> so this
> patch enables the checksum code unconditionally. Also:
> =

> - make sure all header sizes are multiples of 4 bytes
> =A0 (a requirement of the checksum routine)
> - zero structures to ensure internal padding has a known
> value
> - fix a bug in dump_extattr_buildrecord() which
> checksummed
> =A0 the wrong header structure
> - add calc_checksum() and is_checksum_valid() routines to
> =A0 cut down on duplicate code
> =

> Signed-off-by: Bill Kendall <wkendall@sgi.com>
> ---
>  common/content_inode.h |=A0=A0=A020 +++++++++++
>  dump/content.c=A0 =A0 =A0
> =A0=A0=A0|=A0=A0=A085
> +++++++++++-------------------------------------
>  restore/Makefile=A0 =A0 =A0=A0=A0|=A0
> =A0 2 +-
>  restore/content.c=A0 =A0 =A0
> |=A0=A0=A040 ++--------------------
>  4 files changed, 44 insertions(+), 103 deletions(-)
> =

> diff --git a/common/content_inode.h
> b/common/content_inode.h
> index 479fdfc..e119354 100644
> --- a/common/content_inode.h
> +++ b/common/content_inode.h
> @@ -347,4 +347,24 @@ typedef struct extattrhdr
> extattrhdr_t;
>  =A0=A0=A0 /* a linux "secure" mode attribute
>  =A0=A0=A0=A0=A0*/
>  =

> +/* Routines for calculating and validating checksums on
> xfsdump headers
> + */
> +static inline u_int32_t
> +calc_checksum(void *startp, void *endp)
> +{
> +=A0=A0=A0 u_int32_t sum;
> +=A0=A0=A0 u_int32_t *sump =3D (u_int32_t *)startp;
> +=A0=A0=A0 for (sum =3D 0; sump < (u_int32_t
> *)endp; sum +=3D *sump++);
> +=A0=A0=A0 return ~sum + 1;
> +}
> +
> +static inline bool_t
> +is_checksum_valid(void *startp, void *endp)
> +{
> +=A0=A0=A0 u_int32_t sum;
> +=A0=A0=A0 u_int32_t *sump =3D (u_int32_t *)startp;
> +=A0=A0=A0 for (sum =3D 0; sump < (u_int32_t
> *)endp; sum +=3D *sump++);
> +=A0=A0=A0 return sum =3D=3D 0 ? BOOL_TRUE :
> BOOL_FALSE;
> +}
> +
>  #endif /* CONTENT_INODE_H */
> diff --git a/dump/content.c b/dump/content.c
> index 9905c88..2cf15ba 100644
> --- a/dump/content.c
> +++ b/dump/content.c
> @@ -585,6 +585,13 @@ content_init( intgen_t argc,
>  =A0=A0=A0 =A0=A0=A0 sizeof(
> content_inode_hdr_t ));
>  =A0=A0=A0 ASSERT( sizeof( extattrhdr_t ) =3D=3D
> EXTATTRHDR_SZ );
>  =

> +=A0=A0=A0 /* must be a multiple of 32-bits for
> checksums
> +=A0=A0=A0=A0=A0*/
> +=A0=A0=A0 ASSERT( FILEHDR_SZ % sizeof( u_int32_t
> ) =3D=3D 0 );
> +=A0=A0=A0 ASSERT( EXTENTHDR_SZ=A0 % sizeof(
> u_int32_t ) =3D=3D 0 );
> +=A0=A0=A0 ASSERT( DIRENTHDR_SZ % sizeof(
> u_int32_t ) =3D=3D 0 );
> +=A0=A0=A0 ASSERT( EXTATTRHDR_SZ % sizeof(
> u_int32_t ) =3D=3D 0 );
> +
>  =A0=A0=A0 /* calculate offsets of portions of the
> write hdr template
>  =A0=A0=A0=A0=A0*/
>  =A0=A0=A0 dwhdrtemplatep =3D ( drive_hdr_t *
> )gwhdrtemplatep->gh_upper;
> @@ -1491,8 +1498,7 @@ baseuuidbypass:
>  =A0=A0=A0 var_skip( &fsid, inomap_skip );
>  =

>  =A0=A0=A0 /* fill in write header template
> content info. always produce
> -=A0=A0=A0=A0=A0* an inomap and dir dump for
> each media file. flag the checksums
> -=A0=A0=A0=A0=A0* available if so compiled
> (see -D...CHECKSUM in Makefile).
> +=A0=A0=A0=A0=A0* an inomap and dir dump for
> each media file.
>  =A0=A0=A0=A0=A0*/
>  =A0=A0=A0 ASSERT( sizeof(
> cwhdrtemplatep->ch_specific ) >=3D sizeof(
> *scwhdrtemplatep ));
>  =A0=A0=A0 scwhdrtemplatep->cih_mediafiletype =3D
> CIH_MEDIAFILETYPE_DATA;
> @@ -1506,15 +1512,9 @@ baseuuidbypass:
>  =A0=A0=A0 if ( sc_inv_updatepr ) {
>  =A0=A0=A0 =A0=A0=A0
> scwhdrtemplatep->cih_dumpattr |=3D CIH_DUMPATTR_INVENTORY;
>  =A0=A0=A0 }
> -#ifdef FILEHDR_CHECKSUM
>  =A0=A0=A0 scwhdrtemplatep->cih_dumpattr |=3D
> CIH_DUMPATTR_FILEHDR_CHECKSUM;
> -#endif /* FILEHDR_CHECKSUM */
> -#ifdef EXTENTHDR_CHECKSUM
>  =A0=A0=A0 scwhdrtemplatep->cih_dumpattr |=3D
> CIH_DUMPATTR_EXTENTHDR_CHECKSUM;
> -#endif /* EXTENTHDR_CHECKSUM */
> -#ifdef DIRENTHDR_CHECKSUM
>  =A0=A0=A0 scwhdrtemplatep->cih_dumpattr |=3D
> CIH_DUMPATTR_DIRENTHDR_CHECKSUM;
> -#endif /* DIRENTHDR_CHECKSUM */
>  =A0=A0=A0 scwhdrtemplatep->cih_dumpattr |=3D
> CIH_DUMPATTR_DIRENTHDR_GEN;
>  =A0=A0=A0 if ( sc_incrpr ) {
>  =A0=A0=A0 =A0=A0=A0
> scwhdrtemplatep->cih_dumpattr |=3D
> CIH_DUMPATTR_INCREMENTAL;
> @@ -1528,10 +1528,8 @@ baseuuidbypass:
>  =A0=A0=A0 }
>  =A0=A0=A0 if ( sc_dumpextattrpr ) {
>  =A0=A0=A0 =A0=A0=A0
> scwhdrtemplatep->cih_dumpattr |=3D CIH_DUMPATTR_EXTATTR;
> -#ifdef EXTATTRHDR_CHECKSUM
>  =A0=A0=A0 =A0=A0=A0
> scwhdrtemplatep->cih_dumpattr |=3D
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0
> CIH_DUMPATTR_EXTATTRHDR_CHECKSUM;
> -#endif /* EXTATTRHDR_CHECKSUM */
>  =A0=A0=A0 }
>  =

>  =A0=A0=A0 scwhdrtemplatep->cih_rootino =3D
> sc_rootxfsstatp->bs_ino;
> @@ -3743,6 +3741,8 @@ dump_extattr_buildrecord( xfs_bstat_t
> *statp,
>  =A0=A0=A0 =A0=A0=A0 =A0
> =A0=A0=A0namesz, namesrcp,
>  =A0=A0=A0 =A0=A0=A0 =A0
> =A0=A0=A0valuesz );
>  =A0=A0=A0 ( void )strcpy( namep, namesrcp );
> +
> +=A0=A0=A0 memset( ( void * )&tmpah, 0,
> sizeof( tmpah ));
>  =A0=A0=A0 tmpah.ah_sz =3D recsz;
>  =A0=A0=A0 ASSERT( EXTATTRHDR_SZ + namesz <
> UINT16MAX );
>  =A0=A0=A0 tmpah.ah_valoff =3D ( u_int16_t )(
> EXTATTRHDR_SZ + namesz );
> @@ -3750,17 +3750,8 @@ dump_extattr_buildrecord(
> xfs_bstat_t *statp,
>  =A0=A0=A0 =A0=A0=A0 (( flag &
> ATTR_ROOT ) ? EXTATTRHDR_FLAGS_ROOT :
>  =A0=A0=A0 =A0=A0=A0 (( flag &
> ATTR_SECURE ) ? EXTATTRHDR_FLAGS_SECURE : 0));
>  =A0=A0=A0 tmpah.ah_valsz =3D valuesz;
> -=A0=A0=A0 tmpah.ah_checksum =3D 0;
> -#ifdef EXTATTRHDR_CHECKSUM
> -=A0=A0=A0 {
> -=A0=A0=A0 register u_int32_t *sump =3D ( u_int32_t
> * )ahdrp;
> -=A0=A0=A0 register u_int32_t *endp =3D ( u_int32_t
> * )( ahdrp + 1 );
> -=A0=A0=A0 register u_int32_t sum;
>  =A0=A0=A0 tmpah.ah_flags |=3D
> EXTATTRHDR_FLAGS_CHECKSUM;
> -=A0=A0=A0 for ( sum =3D 0 ; sump < endp ; sum +=3D
> *sump++ ) ;
> -=A0=A0=A0 tmpah.ah_checksum =3D ~sum + 1;
> -=A0=A0=A0 }
> -#endif /* EXTATTRHDR_CHECKSUM */
> +=A0=A0=A0 tmpah.ah_checksum =3D calc_checksum(
> &tmpah, &tmpah + 1 );
>  =

>  =A0=A0=A0 xlate_extattrhdr(ahdrp, &tmpah,
> -1);
>  =A0=A0=A0 *valuepp =3D valuep;
> @@ -3782,23 +3773,13 @@ dump_extattrhdr( drive_t *drivep,
>  =A0=A0=A0 intgen_t rval;
>  =A0=A0=A0 rv_t rv;
>  =

> +=A0=A0=A0 memset( ( void * )&ahdr, 0, sizeof(
> ahdr ));
>  =A0=A0=A0 ahdr.ah_sz =3D recsz;
>  =A0=A0=A0 ASSERT( valoff < UINT16MAX );
>  =A0=A0=A0 ahdr.ah_valoff =3D ( u_int16_t )valoff;
> -=A0=A0=A0 ahdr.ah_flags =3D ( u_int16_t )flags;
> +=A0=A0=A0 ahdr.ah_flags =3D ( u_int16_t )flags |
> EXTATTRHDR_FLAGS_CHECKSUM;
>  =A0=A0=A0 ahdr.ah_valsz =3D valsz;
> -=A0=A0=A0 ahdr.ah_checksum =3D 0;
> -
> -#ifdef EXTATTRHDR_CHECKSUM
> -=A0=A0=A0 {
> -=A0=A0=A0 register u_int32_t *sump =3D ( u_int32_t
> * )&ahdr;
> -=A0=A0=A0 register u_int32_t *endp =3D ( u_int32_t
> * )( &ahdr + 1 );
> -=A0=A0=A0 register u_int32_t sum;
> -=A0=A0=A0 ahdr.ah_flags |=3D
> EXTATTRHDR_FLAGS_CHECKSUM;
> -=A0=A0=A0 for ( sum =3D 0 ; sump < endp ; sum +=3D
> *sump++ ) ;
> -=A0=A0=A0 ahdr.ah_checksum =3D ~sum + 1;
> -=A0=A0=A0 }
> -#endif /* EXTATTRHDR_CHECKSUM */
> +=A0=A0=A0 ahdr.ah_checksum =3D calc_checksum(
> &ahdr, &ahdr + 1 );
>  =

>  =A0=A0=A0 xlate_extattrhdr(&ahdr,
> &tmpahdr, 1);
>  =A0=A0=A0 rval =3D write_buf( ( char *
> )&tmpahdr,
> @@ -5102,11 +5083,6 @@ dump_filehdr( drive_t *drivep,
>  =A0=A0=A0 drive_ops_t *dop =3D drivep->d_opsp;
>  =A0=A0=A0 register filehdr_t *fhdrp =3D
> contextp->cc_filehdrp;
>  =A0=A0=A0 filehdr_t tmpfhdrp;
> -#ifdef FILEHDR_CHECKSUM
> -=A0=A0=A0 register u_int32_t *sump =3D ( u_int32_t
> * )fhdrp;
> -=A0=A0=A0 register u_int32_t *endp =3D ( u_int32_t
> * )( fhdrp + 1 );
> -=A0=A0=A0 register u_int32_t sum;
> -#endif /* FILEHDR_CHECKSUM */
>  =A0=A0=A0 intgen_t rval;
>  =A0=A0=A0 rv_t rv;
>  =

> @@ -5118,13 +5094,8 @@ dump_filehdr( drive_t *drivep,
>  =A0=A0=A0 =A0=A0=A0
> copy_xfs_bstat(&fhdrp->fh_stat, statp);
>  =A0=A0=A0 }
>  =A0=A0=A0 fhdrp->fh_offset =3D offset;
> -=A0=A0=A0 fhdrp->fh_flags =3D flags;
> -
> -#ifdef FILEHDR_CHECKSUM
> -=A0=A0=A0 fhdrp->fh_flags |=3D
> FILEHDR_FLAGS_CHECKSUM;
> -=A0=A0=A0 for ( sum =3D 0 ; sump < endp ; sum +=3D
> *sump++ ) ;
> -=A0=A0=A0 fhdrp->fh_checksum =3D ~sum + 1;
> -#endif /* FILEHDR_CHECKSUM */
> +=A0=A0=A0 fhdrp->fh_flags =3D flags |
> FILEHDR_FLAGS_CHECKSUM;
> +=A0=A0=A0 fhdrp->fh_checksum =3D calc_checksum(
> fhdrp, fhdrp + 1 );
>  =

>  =A0=A0=A0 xlate_filehdr(fhdrp, &tmpfhdrp,
> 1);
>  =A0=A0=A0 rval =3D write_buf( ( char *
> )&tmpfhdrp,
> @@ -5164,11 +5135,6 @@ dump_extenthdr( drive_t *drivep,
>  =A0=A0=A0 drive_ops_t *dop =3D drivep->d_opsp;
>  =A0=A0=A0 register extenthdr_t *ehdrp =3D
> contextp->cc_extenthdrp;
>  =A0=A0=A0 extenthdr_t tmpehdrp;
> -#ifdef EXTENTHDR_CHECKSUM
> -=A0=A0=A0 register u_int32_t *sump =3D ( u_int32_t
> * )ehdrp;
> -=A0=A0=A0 register u_int32_t *endp =3D ( u_int32_t
> * )( ehdrp + 1 );
> -=A0=A0=A0 register u_int32_t sum;
> -#endif /* EXTENTHDR_CHECKSUM */
>  =A0=A0=A0 intgen_t rval;
>  =A0=A0=A0 rv_t rv;
>  =A0=A0=A0 char typestr[20];
> @@ -5198,15 +5164,10 @@ dump_extenthdr( drive_t *drivep,
>  =

>  =A0=A0=A0 ( void )memset( ( void * )ehdrp, 0,
> sizeof( *ehdrp ));
>  =A0=A0=A0 ehdrp->eh_type =3D type;
> -=A0=A0=A0 ehdrp->eh_flags =3D flags;
> +=A0=A0=A0 ehdrp->eh_flags =3D flags |
> EXTENTHDR_FLAGS_CHECKSUM;
>  =A0=A0=A0 ehdrp->eh_offset =3D offset;
>  =A0=A0=A0 ehdrp->eh_sz =3D sz;
> -
> -#ifdef EXTENTHDR_CHECKSUM
> -=A0=A0=A0 ehdrp->eh_flags |=3D
> EXTENTHDR_FLAGS_CHECKSUM;
> -=A0=A0=A0 for ( sum =3D 0 ; sump < endp ; sum +=3D
> *sump++ ) ;
> -=A0=A0=A0 ehdrp->eh_checksum =3D ~sum + 1;
> -#endif /* EXTENTHDR_CHECKSUM */
> +=A0=A0=A0 ehdrp->eh_checksum =3D calc_checksum(
> ehdrp, ehdrp + 1 );
>  =

>  =A0=A0=A0 xlate_extenthdr(ehdrp, &tmpehdrp,
> 1);
>  =A0=A0=A0 rval =3D write_buf( ( char *
> )&tmpehdrp,
> @@ -5249,11 +5210,6 @@ dump_dirent( drive_t *drivep,
>  =A0=A0=A0 direnthdr_t *tmpdhdrp;
>  =A0=A0=A0 size_t direntbufsz =3D
> contextp->cc_mdirentbufsz;
>  =A0=A0=A0 size_t sz;
> -#ifdef DIRENTHDR_CHECKSUM
> -=A0=A0=A0 register u_int32_t *sump =3D ( u_int32_t
> * )dhdrp;
> -=A0=A0=A0 register u_int32_t *endp =3D ( u_int32_t
> * )( dhdrp + 1 );
> -=A0=A0=A0 register u_int32_t sum;
> -#endif /* DIRENTHDR_CHECKSUM */
>  =A0=A0=A0 intgen_t rval;
>  =A0=A0=A0 rv_t rv;
>  =

> @@ -5290,10 +5246,7 @@ dump_dirent( drive_t *drivep,
>  =A0=A0=A0 =A0=A0=A0 strcpy(
> dhdrp->dh_name, name );
>  =A0=A0=A0 }
>  =

> -#ifdef DIRENTHDR_CHECKSUM
> -=A0=A0=A0 for ( sum =3D 0 ; sump < endp ; sum +=3D
> *sump++ ) ;
> -=A0=A0=A0 dhdrp->dh_checksum =3D ~sum + 1;
> -#endif /* DIRENTHDR_CHECKSUM */
> +=A0=A0=A0 dhdrp->dh_checksum =3D calc_checksum(
> dhdrp, dhdrp + 1);
>  =

>  =A0=A0=A0 tmpdhdrp =3D malloc(sz);
>  =A0=A0=A0 xlate_direnthdr(dhdrp, tmpdhdrp, 1);
> diff --git a/restore/Makefile b/restore/Makefile
> index 78ecc2c..588a8f0 100644
> --- a/restore/Makefile
> +++ b/restore/Makefile
> @@ -103,7 +103,7 @@ LLDLIBS =3D $(LIBUUID) $(LIBHANDLE)
> $(LIBATTR) $(LIBRMT)
>  LTDEPENDENCIES =3D $(LIBRMT)
>  =

>  LCFLAGS =3D -DRESTORE -DRMT -DBASED -DDOSOCKS -DINVCONVFIX
> -DPIPEINVFIX \
> -=A0=A0=A0 -DEOMFIX -DSESSCPLT -DWHITEPARSE
> -DDIRENTHDR_CHECKSUM \
> +=A0=A0=A0 -DEOMFIX -DSESSCPLT -DWHITEPARSE \
>  =A0=A0=A0 -DF_FSSETDM
>  =

>  default: depend $(LTCOMMAND)
> diff --git a/restore/content.c b/restore/content.c
> index e3e4994..25849d7 100644
> --- a/restore/content.c
> +++ b/restore/content.c
> @@ -8000,11 +8000,6 @@ read_filehdr( drive_t *drivep,
> filehdr_t *fhdrp, bool_t fhcs )
>  =A0=A0=A0 drive_ops_t *dop =3D drivep->d_opsp;
>  =A0=A0=A0 /* REFERENCED */
>  =A0=A0=A0 intgen_t nread;
> -#ifdef FILEHDR_CHECKSUM
> -=A0=A0=A0 register u_int32_t *sump =3D ( u_int32_t
> * )fhdrp;
> -=A0=A0=A0 register u_int32_t *endp =3D ( u_int32_t
> * )( fhdrp + 1 );
> -=A0=A0=A0 register u_int32_t sum;
> -#endif /* FILEHDR_CHECKSUM */
>  =A0=A0=A0 intgen_t rval;
>  =A0=A0=A0 filehdr_t tmpfh;
>  =

> @@ -8041,21 +8036,18 @@ read_filehdr( drive_t *drivep,
> filehdr_t *fhdrp, bool_t fhcs )
>  =A0=A0=A0 =A0 =A0 =A0
> bstatp->bs_ino,
>  =A0=A0=A0 =A0 =A0 =A0 bstatp->bs_mode
> );
>  =

> -#ifdef FILEHDR_CHECKSUM
>  =A0=A0=A0 if ( fhcs ) {
>  =A0=A0=A0 =A0=A0=A0 if ( ! (
> fhdrp->fh_flags & FILEHDR_FLAGS_CHECKSUM )) {
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> mlog( MLOG_NORMAL | MLOG_WARNING, _(
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0 =A0 =A0 "corrupt file header\n") );
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> return RV_CORRUPT;
>  =A0=A0=A0 =A0=A0=A0 }
> -=A0=A0=A0 =A0=A0=A0 for ( sum =3D 0 ; sump
> < endp ; sum +=3D *sump++ ) ;
> -=A0=A0=A0 =A0=A0=A0 if ( sum ) {
> +=A0=A0=A0 =A0=A0=A0 if (
> !is_checksum_valid( fhdrp, fhdrp + 1)) {
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> mlog( MLOG_NORMAL | MLOG_WARNING, _(
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0 =A0 =A0 "bad file header checksum\n") );
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> return RV_CORRUPT;
>  =A0=A0=A0 =A0=A0=A0 }
>  =A0=A0=A0 }
> -#endif /* FILEHDR_CHECKSUM */
>  =

>  =A0=A0=A0 return RV_OK;
>  }
> @@ -8067,11 +8059,6 @@ read_extenthdr( drive_t *drivep,
> extenthdr_t *ehdrp, bool_t ehcs )
>  =A0=A0=A0 drive_ops_t *dop =3D drivep->d_opsp;
>  =A0=A0=A0 /* REFERENCED */
>  =A0=A0=A0 intgen_t nread;
> -#ifdef EXTENTHDR_CHECKSUM
> -=A0=A0=A0 register u_int32_t *sump =3D ( u_int32_t
> * )ehdrp;
> -=A0=A0=A0 register u_int32_t *endp =3D ( u_int32_t
> * )( ehdrp + 1 );
> -=A0=A0=A0 register u_int32_t sum;
> -#endif /* EXTENTHDR_CHECKSUM */
>  =A0=A0=A0 intgen_t rval;
>  =A0=A0=A0 extenthdr_t tmpeh;
>  =

> @@ -8108,21 +8095,18 @@ read_extenthdr( drive_t *drivep,
> extenthdr_t *ehdrp, bool_t ehcs )
>  =A0=A0=A0 =A0 =A0 =A0
> ehdrp->eh_type,
>  =A0=A0=A0 =A0 =A0 =A0 ehdrp->eh_flags
> );
>  =

> -#ifdef EXTENTHDR_CHECKSUM
>  =A0=A0=A0 if ( ehcs ) {
>  =A0=A0=A0 =A0=A0=A0 if ( ! (
> ehdrp->eh_flags & EXTENTHDR_FLAGS_CHECKSUM )) {
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> mlog( MLOG_NORMAL | MLOG_WARNING, _(
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0 =A0 =A0 "corrupt extent header\n") );
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> return RV_CORRUPT;
>  =A0=A0=A0 =A0=A0=A0 }
> -=A0=A0=A0 =A0=A0=A0 for ( sum =3D 0 ; sump
> < endp ; sum +=3D *sump++ ) ;
> -=A0=A0=A0 =A0=A0=A0 if ( sum ) {
> +=A0=A0=A0 =A0=A0=A0 if (
> !is_checksum_valid( ehdrp, ehdrp + 1)) {
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> mlog( MLOG_NORMAL | MLOG_WARNING, _(
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0 =A0 =A0 "bad extent header checksum\n") );
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> return RV_CORRUPT;
>  =A0=A0=A0 =A0=A0=A0 }
>  =A0=A0=A0 }
> -#endif /* EXTENTHDR_CHECKSUM */
>  =

>  =A0=A0=A0 return RV_OK;
>  }
> @@ -8137,11 +8121,6 @@ read_dirent( drive_t *drivep,
>  =A0=A0=A0 drive_ops_t *dop =3D drivep->d_opsp;
>  =A0=A0=A0 /* REFERENCED */
>  =A0=A0=A0 intgen_t nread;
> -#ifdef DIRENTHDR_CHECKSUM
> -=A0=A0=A0 register u_int32_t *sump =3D ( u_int32_t
> * )dhdrp;
> -=A0=A0=A0 register u_int32_t *endp =3D ( u_int32_t
> * )( dhdrp + 1 );
> -=A0=A0=A0 register u_int32_t sum;
> -#endif /* DIRENTHDR_CHECKSUM */
>  =A0=A0=A0 intgen_t rval;
>  =A0=A0=A0 direnthdr_t tmpdh;
>  =

> @@ -8180,21 +8159,18 @@ read_dirent( drive_t *drivep,
>  =A0=A0=A0 =A0 =A0 =A0 ( size_t
> )dhdrp->dh_gen,
>  =A0=A0=A0 =A0 =A0 =A0 ( size_t
> )dhdrp->dh_sz );
>  =

> -#ifdef DIRENTHDR_CHECKSUM
>  =A0=A0=A0 if ( dhcs ) {
>  =A0=A0=A0 =A0=A0=A0 if ( dhdrp->dh_sz
> =3D=3D 0 ) {
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> mlog( MLOG_NORMAL | MLOG_WARNING, _(
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0 =A0 =A0 "corrupt directory entry header\n") );
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> return RV_CORRUPT;
>  =A0=A0=A0 =A0=A0=A0 }
> -=A0=A0=A0 =A0=A0=A0 for ( sum =3D 0 ; sump
> < endp ; sum +=3D *sump++ ) ;
> -=A0=A0=A0 =A0=A0=A0 if ( sum ) {
> +=A0=A0=A0 =A0=A0=A0 if (
> !is_checksum_valid( dhdrp, dhdrp + 1)) {
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> mlog( MLOG_NORMAL | MLOG_WARNING, _(
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0 =A0 =A0 "bad directory entry header
> checksum\n") );
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> return RV_CORRUPT;
>  =A0=A0=A0 =A0=A0=A0 }
>  =A0=A0=A0 }
> -#endif /* DIRENTHDR_CHECKSUM */
>  =

>  =A0=A0=A0 /* if null, return
>  =A0=A0=A0=A0=A0*/
> @@ -8246,11 +8222,6 @@ read_extattrhdr( drive_t *drivep,
> extattrhdr_t *ahdrp, bool_t ahcs )
>  =A0=A0=A0 drive_ops_t *dop =3D drivep->d_opsp;
>  =A0=A0=A0 /* REFERENCED */
>  =A0=A0=A0 intgen_t nread;
> -#ifdef EXTATTRHDR_CHECKSUM
> -=A0=A0=A0 register u_int32_t *sump =3D ( u_int32_t
> * )ahdrp;
> -=A0=A0=A0 register u_int32_t *endp =3D ( u_int32_t
> * )( ahdrp + 1 );
> -=A0=A0=A0 register u_int32_t sum;
> -#endif /* EXTATTRHDR_CHECKSUM */
>  =A0=A0=A0 intgen_t rval;
>  =A0=A0=A0 extattrhdr_t tmpah;
>  =

> @@ -8288,21 +8259,18 @@ read_extattrhdr( drive_t *drivep,
> extattrhdr_t *ahdrp, bool_t ahcs )
>  =A0=A0=A0 =A0 =A0 =A0
> ahdrp->ah_valsz,
>  =A0=A0=A0 =A0 =A0 =A0
> ahdrp->ah_checksum );
>  =

> -#ifdef EXTATTRHDR_CHECKSUM
>  =A0=A0=A0 if ( ahcs ) {
>  =A0=A0=A0 =A0=A0=A0 if ( ! (
> ahdrp->ah_flags & EXTATTRHDR_FLAGS_CHECKSUM )) {
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> mlog( MLOG_NORMAL | MLOG_WARNING, _(
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0 =A0 =A0 "corrupt extattr header\n") );
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> return RV_CORRUPT;
>  =A0=A0=A0 =A0=A0=A0 }
> -=A0=A0=A0 =A0=A0=A0 for ( sum =3D 0 ; sump
> < endp ; sum +=3D *sump++ ) ;
> -=A0=A0=A0 =A0=A0=A0 if ( sum ) {
> +=A0=A0=A0 =A0=A0=A0 if (
> !is_checksum_valid( ahdrp, ahdrp + 1)) {
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> mlog( MLOG_NORMAL | MLOG_WARNING, _(
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0 =A0 =A0 "bad extattr header checksum\n") );
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> return RV_CORRUPT;
>  =A0=A0=A0 =A0=A0=A0 }
>  =A0=A0=A0 }
> -#endif /* EXTATTRHDR_CHECKSUM */
>  =

>  =A0=A0=A0 return RV_OK;
>  }
> -- =

> 1.7.0.4
> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
