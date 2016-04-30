Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3D36D7D06
	for <xfs@oss.sgi.com>; Sat, 30 Apr 2016 16:56:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C3225AC002
	for <xfs@oss.sgi.com>; Sat, 30 Apr 2016 14:55:59 -0700 (PDT)
Received: from neil.brown.name (neil.brown.name [103.29.64.221]) by
	cuda.sgi.com with ESMTP id EYyGYG3jpDQhtBPu (version=TLSv1.2
	cipher=DHE-RSA-AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 30 Apr 2016 14:55:57 -0700 (PDT)
From: NeilBrown <mr@neil.brown.name>
Date: Sun, 01 May 2016 07:55:31 +1000
Subject: Re: [PATCH 0/2] scop GFP_NOFS api
In-Reply-To: <20160429120418.GK21977@dhcp22.suse.cz>
References: <1461671772-1269-1-git-send-email-mhocko@kernel.org>
	<8737q5ugcx.fsf@notabene.neil.brown.name>
	<20160429120418.GK21977@dhcp22.suse.cz>
Message-ID: <87twiiu5gs.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5059434845322845874=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Chris Mason <clm@fb.com>, linux-ntfs-dev@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, logfs@logfs.org, cluster-devel@redhat.com, linux-mm@kvack.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, xfs@oss.sgi.com, ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-afs@lists.infradead.org

--===============5059434845322845874==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain

On Fri, Apr 29 2016, Michal Hocko wrote:

>
> One think I have learned is that shrinkers can be really complex and
> getting rid of GFP_NOFS will be really hard so I would really like to
> start the easiest way possible and remove the direct usage and replace
> it by scope one which would at least _explain_ why it is needed. I think
> this is a reasonable _first_ step and a large step ahead because we have
> a good chance to get rid of a large number of those which were used
> "just because I wasn't sure and this should be safe, right?". I wouldn't
> be surprised if we end up with a very small number of both scope and
> direct usage in the end.

Yes, shrinkers can be complex.  About two of them are.  We could fix
lots and lots of call sites, or fix two shrinkers.
OK, that's a bit unfair as fixing one of the shrinkers involves changing
many ->evict_inode() functions.  But that would be a very focused
change.

I think your proposal is little more than re-arranging deck chairs on
the titanic.  Yes, it might give everybody a better view of the iceberg
but the iceberg is still there and in reality we can already see it.

The main iceberg is evict_inode.  It appears in both examples given so
far: xfs and gfs.  There are other little icebergs but they won't last
long after evict_inode is dealt with.

One particular problem with your process-context idea is that it isn't
inherited across threads.
Steve Whitehouse's example in gfs shows how allocation dependencies can
even cross into user space.

A more localized one that I have seen is that NFSv4 sometimes needs to
start up a state-management thread (particularly if the server
restarted).
It uses kthread_run(), which doesn't actually create the thread but asks
kthreadd to do it.  If NFS writeout is waiting for state management it
would need to make sure that kthreadd runs in allocation context to
avoid deadlock.
I feel that I've forgotten some important detail here and this might
have been fixed somehow, but the point still stands that the allocation
context can cross from thread to thread and can effectively become
anything and everything.

It is OK to wait for memory to be freed.  It is not OK to wait for any
particular piece of memory to be freed because you don't always know who
is waiting for you, or who you really are waiting on to free that
memory.

Whenever trying to free memory I think you need to do best-effort
without blocking.

>
> I would also like to revisit generic inode/dentry shrinker and see
> whether it could be more __GFP_FS friendly. As you say many FS might
> even not depend on some FS internal locks so pushing GFP_FS check down
> the layers might make a lot of sense and allow to clean some [id]cache
> even for __GFP_FS context.

I think the only part of prune_dcache_sb() that might need care is
iput() which boils down to evict().  The final unlink for NFS
silly-rename might happen in there too (in d_iput).
shrinking the dcache seems rather late to be performing that unlink
though, so I've probably missed some key detail.

If we find a way for evict(), when called from the shrinker, to be
non-blocking, and generally require all shrinkers to be non-blocking,
then many of these allocation problems evaporate.

Thanks,
NeilBrown


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXJSnTAAoJEDnsnt1WYoG5VzYP/0sRKiPS4flNsF5KJO+8W9kv
wAXMCErisoi1qhXUF24r7eKveCvsedAF4ocRL4VVEn8bcS3PQqM4dNw8Hr5yjss0
VxnuMMN67dDSmDmPfFPEZrJTwe5/vQr8DyCStlsuoB2ZaHjXODurzOaRpRKdDxae
1dOwbgPTlitwuDexsjC8xpcVHJx6v/f0+U5/K4DZunr1chcwsIsZONBCZTzsm8Sk
pcZhNAtZSZR/XnsvaM80RYrGwjOCfoY58rpXhYTSRv0NGT+y0m7AeYBVLwueOtke
ye1jJwenlswn5KMdCZRtHz1qoCGVCvVUjahOnzegk7doEYx4f2EN2AQJIvw+Ngci
DRS+XCooDI4jLWTkTZADjPZjm6nH++xa+PfUWgo9+OaDGbyS5sy4H0q2Sqh0Nevp
F+XtkgchYnI/d/Y4/11tvvh4CScdbLR+Cc3qT8r85pz+lCE0D51nsPQo0zMhmrdY
GLmDYkLA4MgymC1PG5Jc76ctIYDY96EO9F10pq/U1SPNaPhrA7y0RE8SLHPJE2OS
Bns+184wgWCgtx6wC1GiFM/H+Hq2B2byRBgX1U90fvJvisZrcKuG2selCfquYHRr
NMFO2YCCag8V7BDXvfmwbQKh5zpDlTCH9Zk9dPpSFzLmaYUp+TyeBPDx3CbqwVtu
yzQMkIxl5FRwqpg2qQNb
=jsDQ
-----END PGP SIGNATURE-----
--=-=-=--


--===============5059434845322845874==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5059434845322845874==--
