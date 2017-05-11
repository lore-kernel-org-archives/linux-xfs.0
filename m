Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50316 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751881AbdEKWWf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 May 2017 18:22:35 -0400
From: NeilBrown <neil@brown.name>
Date: Fri, 12 May 2017 08:22:23 +1000
Subject: Re: [RFC PATCH v1 00/30] fs: inode->i_version rework and optimization
In-Reply-To: <20170511185942.GD25434@fieldses.org>
References: <20170329111507.GA18467@quack2.suse.cz> <1490810071.2678.6.camel@redhat.com> <20170330064724.GA21542@quack2.suse.cz> <1490872308.2694.1.camel@redhat.com> <20170330161231.GA9824@fieldses.org> <1490898932.2667.1.camel@redhat.com> <20170404183138.GC14303@fieldses.org> <878tnfiq7v.fsf@notabene.neil.brown.name> <20170405080551.GC8899@quack2.suse.cz> <20170405181409.GC28681@fieldses.org> <20170511185942.GD25434@fieldses.org>
Message-ID: <87r2zvkp9c.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "J. Bruce Fields" <bfields@fieldses.org>, Jan Kara <jack@suse.cz>
Cc: Jeff Layton <jlayton@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, May 11 2017, J. Bruce Fields wrote:

> On Wed, Apr 05, 2017 at 02:14:09PM -0400, J. Bruce Fields wrote:
>> On Wed, Apr 05, 2017 at 10:05:51AM +0200, Jan Kara wrote:
>> > 1) Keep i_version as is, make clients also check for i_ctime.
>>=20
>> That would be a protocol revision, which we'd definitely rather avoid.
>>=20
>> But can't we accomplish the same by using something like
>>=20
>> 	ctime * (some constant) + i_version
>>=20
>> ?
>>=20
>> >    Pro: No on-disk format changes.
>> >    Cons: After a crash, i_version can go backwards (but when file chan=
ges
>> >    i_version, i_ctime pair should be still different) or not, data can=
 be
>> >    old or not.
>>=20
>> This is probably good enough for NFS purposes: typically on an NFS
>> filesystem, results of a read in the face of a concurrent write open are
>> undefined.  And writers sync before close.
>>=20
>> So after a crash with a dirty inode, we're in a situation where an NFS
>> client still needs to resend some writes, sync, and close.  I'm OK with
>> things being inconsistent during this window.
>>=20
>> I do expect things to return to normal once that client's has resent its
>> writes--hence the worry about actually resuing old values after boot
>> (such as if i_version regresses on boot and then increments back to the
>> same value after further writes).  Factoring in ctime fixes that.
>
> So for now I'm thinking of just doing something like the following.
>
> Only nfsd needs it for now, but it could be moved to a vfs helper for
> statx, or for individual filesystems that want to do something
> different.  (The NFSv4 client will want to use the server's change
> attribute instead, I think.  And other filesystems might want to try
> something more ambitious like Neil's proposal.)
>
> --b.
>
> diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
> index 12feac6ee2fd..9636c9a60aba 100644
> diff --git a/fs/nfsd/nfsfh.h b/fs/nfsd/nfsfh.h
> index f84fe6bf9aee..14f09f1ef605 100644
> --- a/fs/nfsd/nfsfh.h
> +++ b/fs/nfsd/nfsfh.h
> @@ -240,6 +240,16 @@ fh_clear_wcc(struct svc_fh *fhp)
>  	fhp->fh_pre_saved =3D false;
>  }
>=20=20
> +static inline u64 nfsd4_change_attribute(struct inode *inode)
> +{
> +	u64 chattr;
> +
> +	chattr =3D inode->i_ctime.tv_sec << 30;
> +	chattr +=3D inode->i_ctime.tv_nsec;
> +	chattr +=3D inode->i_version;
> +	return chattr;

So if I chmod a file, all clients will need to flush the content from their=
 cache?
Maybe they already do?  Maybe it is a boring corner case?

> +}
> +
>  /*
>   * Fill in the pre_op attr for the wcc data
>   */
> @@ -253,7 +263,7 @@ fill_pre_wcc(struct svc_fh *fhp)
>  		fhp->fh_pre_mtime =3D inode->i_mtime;
>  		fhp->fh_pre_ctime =3D inode->i_ctime;
>  		fhp->fh_pre_size  =3D inode->i_size;
> -		fhp->fh_pre_change =3D inode->i_version;
> +		fhp->fh_pre_change =3D nfsd4_change_attribute(inode);
>  		fhp->fh_pre_saved =3D true;
>  	}
>  }
> --- a/fs/nfsd/nfs3xdr.c
> +++ b/fs/nfsd/nfs3xdr.c
> @@ -260,7 +260,7 @@ void fill_post_wcc(struct svc_fh *fhp)
>  		printk("nfsd: inode locked twice during operation.\n");
>=20=20
>  	err =3D fh_getattr(fhp, &fhp->fh_post_attr);
> -	fhp->fh_post_change =3D d_inode(fhp->fh_dentry)->i_version;
> +	fhp->fh_post_change =3D nfsd4_change_attribute(d_inode(fhp->fh_dentry));
>  	if (err) {
>  		fhp->fh_post_saved =3D false;
>  		/* Grab the ctime anyway - set_change_info might use it */
> diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
> index 26780d53a6f9..a09532d4a383 100644
> --- a/fs/nfsd/nfs4xdr.c
> +++ b/fs/nfsd/nfs4xdr.c
> @@ -1973,7 +1973,7 @@ static __be32 *encode_change(__be32 *p, struct ksta=
t *stat, struct inode *inode,
>  		*p++ =3D cpu_to_be32(convert_to_wallclock(exp->cd->flush_time));
>  		*p++ =3D 0;
>  	} else if (IS_I_VERSION(inode)) {
> -		p =3D xdr_encode_hyper(p, inode->i_version);
> +		p =3D xdr_encode_hyper(p, nfsd4_change_attribute(inode));
>  	} else {
>  		*p++ =3D cpu_to_be32(stat->ctime.tv_sec);
>  		*p++ =3D cpu_to_be32(stat->ctime.tv_nsec);

It is *really* confusing to find that fh_post_change is only set in nfs3
code, and only used in nfs4 code.
It is probably time to get a 'version' field in 'struct kstat'.
That would allow this code to get a little cleaner.

(to me, this exercise is just a reminder that the NFSv4 change attribute
is poorly designed ... so it just makes me grumpy).

NeilBrown


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkU5B8ACgkQOeye3VZi
gbmRug//WHImbIfZr724PFNI4STNq0t1L5nhgSc8TSVWls5YTA1CwTVJgnfwLOBs
xr5WVBYcs02rXDddnqZ1AvyG6fQERDj3rzh6B77maHL/7OY7N8hwZ3MGPrm1E2ov
6SE0Q0SkBNW6xM3Prj+f71s95sp8blPYd1obEHn1q1HS6wrWLW9EV2mZf8KpXgTj
TSUlj6SzfCQ/qAGjULhPB7/4n1q6+xcT8P3d7JEVoNUOuz0ySdOpTt7HQ0idiyFU
Apijbvfb2tza8iNmpuZ9B1DvFubJFspFxVAd0Su7a9oSw/PRvavck3lffOTlT8Ia
qMifcrnxh/vRjjWfmsxDARuoylf4D/plQ2/7ca1AVeEhq3qirHSRj6bOjman8A/x
vRtsUGkTH/SzIqLFFFu+3gTbHh+zMQN4dX684hvm93Y1uy8UM3qWFT09myqEw/6F
Eh6KL9qyjLzbglkvKh1x2TaMnyr71hDAINjFZkaacLlbscy7+hQXESLuC32Wsyk0
lFIe9ioh1s3kEI9rIGmAXC8P79QpEo/+na/NcmMEmyatCXpEuPWyDuBsj0nupQZp
nJkiUEYlUWC6qLk+ctk/z8N1B3Iv7lfsJSbVjCZ8AEgRcRXB6XO6/78zBQkc0Q3g
QDmqs41lZWG/BG+sHCi6iIQX9zuTJgNxt+5urlo5LXY62v0h5ZM=
=KDbz
-----END PGP SIGNATURE-----
--=-=-=--
